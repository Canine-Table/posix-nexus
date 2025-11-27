#nx_include NEX_L:/sh/nex-ip.sh

nx_ip_a_inet()
{
	NEX_S="f:$1"
	shift
	nx_ip_a_ifname "$NEX_S" "$@"
	case "$NEX_f_f" in
		4|inet4|inet4) NEX_f_f='-family inet';;
		6|inet6) NEX_f_f='-family inet6';;
		*) NEX_f_f='';;
	esac
	test -n "$NEX_k_d"
}

nx_ip_a_family()
{
	NEX_S="f:$1"
	shift
	nx_ip_a_ifname "$NEX_S" "$@"
	case "$NEX_f_f" in
		4|inet4|inet4) NEX_f_f='-family inet';;
		6|inet6) NEX_f_f='-family inet6';;
		M|m|mpls) NEX_f_f='-family mpls';;
		B|b|bridge) NEX_f_f='-family bridge';;
		0|l|L|link) NEX_f_f='-family link';;
		*) NEX_f_f='';;
	esac
	test -n "$NEX_k_d"
}

nx_ip_g_local()
(
	nx_ip_a_family 's:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip $NEX_f_f -json address show $NEX_k_d)" | ${AWK:-$(nx_cmd_awk)} \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
		'/^\.nx\[[1-9][0-9]*\]\.addr_info\[[1-9][0-9]*\]\.local = /{
			if (b++)
				printf("%s", sep)
			printf("%s", $NF)
		} END {
			exit b < 2
		}
	'
)

nx_ip_o_local()
(
	nx_data_optargs 'o@' "$@"
	nx_data_match $(nx_ip_g_local " -o ") $NEX_S
)

###########################################################################################################

nx_ip_s_inet()
(
	nx_ip_a_inet 'l:v:' "$@" || exit
	test "$NEX_f_f" = '-family inet6' && NEX_k_l=""
	NEX_k_v="${NEX_k_v:-$NEX_S}"
	nx_ip_g_local | grep -q '^'"$NEX_k_v"'$' && return 1
	$(__nx_ip_x_netns) ip $NEX_f_f address add "$NEX_k_v" ${NEX_k_l:+label "$NEX_k_l"} dev "$NEX_k_d"

)

nx_ip_s_route()
(
	nx_ip_a_inet 'v:r:c' "$@" || exit
	if test -n "$($(__nx_ip_x_netns) ip $NEX_f_f route show default)"; then
		if "$NEX_f_c" = '<nx:true/>'; then
			$(__nx_ip_x_netns) ip route delete ${NEX_k_r:-default} dev
			return
		fi
		act='replace'
	fi
	$(__nx_ip_x_netns) ip $NEX_f_f route ${act:-add} ${NEX_k_r:-default} via "${NEX_k_v:-$NEX_S}" dev "$NEX_k_d"
)

