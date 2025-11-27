#nx_include nex-cmd.sh
#nx_include nex-data.sh
#nx_include nex-ip.d/nex-ns.sh
#nx_include nex-ip.d/nex-l2.sh
#nx_include nex-ip.d/nex-l3.sh
#nx_include nex-ip.d/nex-names.sh
#nx_include nex-ip.d/nex-attr.sh
#nx_include nex-ip.d/nex-opts.sh
#nx_include nex-ip.d/nex-builder.sh

nx_ip_g_net()
{
	eval "$(
		ls --color=never -l '/sys/class/net/' | ${AWK:-$(nx_cmd_awk)} \
			-v ex="$1" \
			-F '/' \
		"
			$(nx_data_include -i "${NEXUS_LIB}/awk/nex-misc-extras.awk")
		"'
			BEGIN {
				if (ex == "-e")
					ex = "export "
				else
					ex = ""
				virt = ""
				phy = ""
			}
			/devices\/pci/{
				phy = phy " " $NF
			}
			/devices\/virtual/{
				virt = virt " " $NF
			} END {
				printf("%s%s; %s%s", ex, __nx_stringify_var("G_NEX_NET_VIRT" , substr(virt, 2)), ex, __nx_stringify_var("G_NEX_NET_PHY" , substr(phy, 2)))
			}
		'
	)"
}

###########################################################################################################

nx_ip_g_phy()
(
	__nx_ip_a_netns 's:w' "$@"
	nx_ip_g_net
	NEX_k_s="${NEX_k_s:- }"
	tmpb='0'
	for tmpa in $G_NEX_NET_PHY; do
		test "$tmpb" = '1' && printf '%s' "$NEX_k_s"
		if test "$NEX_f_w" = '<nx:true/>'; then
			test -d "/sys/class/net/$tmpa/wireless" && {
				printf '%s' "$tmpa"
				tmpb='1'
			}
		else
			test -e "/sys/class/net/$tmpa/wireless" || {
				printf '%s' "$tmpa"
				tmpb='1'
			}
		fi
	done
)

nx_ip_g_lo()
(
	nx_ip_g_net
	for tmpa in $G_NEX_NET_VIRT; do
		test "$(cat "/sys/class/net/$tmpa/type")" = '772' && {
			printf '%s' "$tmpa"
			exit
		}
	done
	exit 1
)

nx_ip_s_phy()
(
	__nx_ip_a_netns 'E:W:L:' "$@"
	NEX_k_E="${NEX_k_E:-ethernet}"
	NEX_k_W="${NEX_k_W:-wireless}"
	NEX_k_L="${NEX_k_L:-loopback}"
	for tmpa in $(nx_ip_g_phy); do
		case "$tmpa" in
			"$NEX_k_E"*);;
			*) {
				NEX_k_E="$(nx_ip_c_name -v "$NEX_k_E")"
				nx_ip_s_name -d "$tmpa" -v "$NEX_k_E"
				nx_ip_n_dev -t 'ethernet' -l "$NEX_k_E"
			};;
		esac
	done
	for tmpa in $(nx_ip_g_phy -w); do
		case "$tmpa" in
			"$NEX_k_W"*);;
			*) {
				NEX_k_W="$(nx_ip_c_name -v "$NEX_k_W")"
				nx_ip_s_name -d "$tmpa" -v "$NEX_k_W"
				nx_ip_n_dev -t 'wireless' -l "$NEX_k_W"
			};;
		esac
	done
	tmpa="$(nx_ip_g_lo)"
	case "$tmpa" in
		"$NEX_k_L"*);;
		*) {
			NEX_k_L="$(nx_ip_c_name -v "$NEX_k_L")"
			nx_ip_s_name -d "$tmpa" -v "$NEX_k_L"
			nx_ip_n_dev -t 'loopback' -l "$NEX_k_L"
		};;
	esac
)

nx_ip_n_dev()
(
	__nx_ip_a_netns 'l:t:qh' "$@"
	case "$NEX_k_t" in
		ethernet|wireless|loopback) {
			NEX_k_l="${NEX_k_l:-$NEX_k_t}"
		};;
		*) {
			NEX_k_t="$(nx_ip_o_dev "$NEX_k_t" || printf '%s' 'dummy')"
			NEX_k_l="$(nx_ip_c_name "${NEX_k_l:-$NEX_k_t}")"
			$(__nx_ip_x_netns) ip link add "$NEX_k_l" type "$NEX_k_t" || exit
		};;
	esac
	NEX_k_d="$NEX_k_l"
	NEX_E=0
	case "$NEX_f_q" in
		'<nx:true/>'|'<nx:false/>') {
			NEX_S="$(__nx_ip_n_builder)" || {
				printf '%s' "$NEX_S" 1>&2
				exit 2
			}
			if test "$NEX_f_q" = '<nx:true/>'; then
				nohup eval "$NEX_S" \
					2>"$NEXUS_ENV/proc/err-$NEX_PID.log" \
					1>"$NEXUS_ENV/proc/err-$NEX_PID.log" \
					& printf '%d' "$!" > "$NEXUS_ENV/proc/pid-$NEX_PID.log"
				exit
			else
				eval "$NEX_S" || NEX_E=1
			fi
		};;
		*) {
			NEX_S="$(__nx_ip_n_builder '<nx:null/>')" || {
				printf '%s' "$NEX_S" 1>&2
				exit 2
			}
			for i in $(nx_str_od -x -s ' ' "$NEX_S"); do
				cmdstr="$(printf "$i")"
				nx_tty_print -i "$cmdstr\n"
				cmdres="$(eval "$cmdstr" 2>&1)" || {
					for j in $(nx_str_od -x -s ' ' "$cmdres"); do
						nx_tty_print -e "$(printf '%s' "$j")\n"
						NEX_E=$((NEX_E + 1))
					done
				}
			done
		}
	esac
	test "$NEX_E" -gt 0 && {
		nx_tty_print -w "$NEX_E errors while creating $NEX_k_d of type $NEX_k_t! D:\n"
	} || {
		nx_tty_print -s "$NEX_k_d was created without errors! :D\n"
	}
)

__nx_ip_dev()
(
	nx_ip_a_ifname 'v:p:m:' "$@" || exit
	test "$NEX_k_m" = 'delete' && {
		NEX_k_v=$(nx_ip_t_dev)
	}
	if NEX_k_v="$(nx_ip_o_dev "$NEX_k_v")"; then
		$(__nx_ip_x_netns) ip link $NEX_k_m "${NEX_k_d:-$NEX_k_D}" $NEX_k_p type "$NEX_k_v" $NEX_S || exit
	else
		$(__nx_ip_x_netns) ip link $NEX_k_m "${NEX_k_d:-$NEX_k_D}" $NEX_S || exit
	fi
)

nx_ip_s_dev()
{
	__nx_ip_dev "$@" -m 'set'
}

__nx_ip_n_dev()
{
	__nx_ip_dev "$@" -m 'add'
}

nx_ip_t_dev()
(
	nx_ip_a_ifname '' "$@" || exit
	tmpa="$(nx_data_jdump "$($(__nx_ip_x_netns) ip -detail -json link show $NEX_k_d)" | ${AWK:-$(nx_cmd_awk)} '/\.nx\[1\]\.linkinfo\.info_kind = /{printf("%s", $NF); exit}')"
	test -n "$tmpa" && printf '%s' "$tmpa"
)

nx_ip_r_dev()
(
	__nx_ip_dev "$@" -m 'delete'
)

nx_ip_r_dev()
(
	__nx_ip_dev "$@" -m 'delete'
)

