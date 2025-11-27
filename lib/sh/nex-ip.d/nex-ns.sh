#nx_include NEX_L:/sh/nex-ip.sh

# a:	args
# x:	exec
# e:	remove
# m:	move
# n:	new
# i:	is
# c:	check
# o:	options
# j:	json
# c:	create

# __nx_ip_a_netns -> __nx_ip_a_ifname


__nx_ip_a_netns()
{
	
	NEX_S="$(__nx_ip_c_netns "$NEX_k_n" && printf '%s' "$1" || printf '%s' "n:$1")"
	shift
	nx_data_optargs "$NEX_S" "$@"
	__nx_ip_c_netns "$NEX_k_n"
}


__nx_ip_x_netns()
(
	if __nx_ip_a_netns 'x' "$@"; then
		if test "$NEX_S" != ""; then
			case "$NEX_f_x" in
				'<nx:true/>') {
					ip netns exec "nex-$NEX_k_n" $NEX_S
				};;
				'<nx:false/>') {
					printf '%s' "ip netns exec 'nex-$NEX_k_n' $NEX_S"
				};;
			esac
		else
			printf '%s ' "ip netns exec nex-$NEX_k_n"
		fi
	elif test "$NEX_S" != ""; then
		case "$NEX_f_x" in
			'<nx:true/>') {
				eval $NEX_S
			};;
			'<nx:false/>') {
				printf '%s ' "$NEX_S"
			};;
		esac
	fi
)

__nx_ip_e_netns()
(
	test -n "$1" || exit
	__nx_ip_x_netns -n "$1" -e ${0#-}
)

__nx_ip_r_netns()
{
	__nx_ip_i_netns "$1" || return 0
	test -e "/var/run/nex-$1.pid" && {
		kill "$(cat /var/run/nex-$1.pid)"
		rm -f "/var/run/nex-$1.pid"
	} 2> /dev/null
	ip netns delete "nex-$1"
}

__nx_ip_i_netns()
{
	ip netns | grep -q "^nex-$1\([\\\t ]\+(id:[ \\\t]\+[0-9]\+)$\|$\)"
}

__nx_ip_c_netns()
{
	__nx_ip_i_netns "$1" || {
		test -n "$1" || return
		__nx_ip_n_netns "$1"
	}
	__nx_ip_i_netns "$1"
}

__nx_ip_n_netns()
{
	__nx_ip_i_netns "$1" && return
	ip netns add "nex-$1" && {
		ip netns exec "nex-$1" sysctl --system 1> /dev/null 2>&1
		ip netns exec "nex-$1" ip link set lo up
		nohup nsenter --net="/var/run/netns/nex-$1" -- ${0#-} -c 'while :; do sleep 18250; done' 1> /dev/null 2>&1 & printf '%d' $! > "/var/run/nex-$1.pid"
	}
}

nx_ip_netns()
(
	nx_data_optargs 're' "$@"
	NEX_R="$(
		${AWK:-$(nx_cmd_awk)} \
			-v str="$NEX_R" \
			-v rmve="${NEX_f_r:-<nx:false/>}" \
		"
			$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct.awk")
		"'
			BEGIN {
				nx_trim_split(str, args, "<nx:null/>")
				if (rmve == "<nx:true/>")
					rmve = "r"
				else
					rmve = "n"
				for (str = 1; str <= args[0]; ++str)
					print "__nx_ip_" rmve "_netns " args[str]
				delete args
			}
		'
	)"
	test "$NEX_f_e" != '<nx:true/>' && printf '%s' "$NEX_R" || eval "$NEX_R"
)

__nx_ip_m_netns()
(
	__nx_ip_a_netns 'd:N:' "$@"
	test "$NEX_k_N" != "$NEX_k_n" -a "$NEX_k_N" != "" || exit
	__nx_ip_c_netns "$NEX_k_N" || exit
	$(__nx_ip_x_netns) ip link set $(nx_ip_g_ifname -d "$NEX_k_d") netns "nex-$NEX_k_N"
)

