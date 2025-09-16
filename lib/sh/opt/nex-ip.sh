nx_ip_net()
{
	ls --color=never -l '/sys/class/net/' | ${AWK:-$(nx_cmd_awk)} -v ex="$1" -F '/' '
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
		}
		END {
			printf("%sG_NEX_NET_VIRT\x22=%s\x22\n%sG_NEX_NET_PHY=\x22%s\x22\n", ex, substr(virt, 2), ex, substr(phy, 2));
		}
	'
}

nx_ip_l2()
(
	eval "$(nx_str_optarg ':n:' "$@")"
	test -n "$n" && n="-n $n"
	while :; do
		tmpa="$(${AWK:-$(nx_cmd_awk)} -v addr="$(nx_str_rand 12 xdigit)" '
			BEGIN {
				l = split(tolower(addr), hex, "")
				do {
					s = s ":" hex[l] hex[l-1]
				} while ((l-=2) > 0)
				delete hex
				print substr(s, 2)
			}
		')"
		g_nx_ip_l2 $n -a | grep -q "$tmpa" || break
	done
	printf '%s\n' "$tmpa"
)

nx_ip_name()
{
	tmpa="$(
		eval "$(nx_str_optarg ':n:b:v' "$@")"
		test -n "$NX_OPT_RMDR" || exit
		test -n "$n" && tmpd="ip netns exec $n " || tmpd=""
		tmpa="$(${AWK:-$(nx_cmd_awk)} -v name="$NX_OPTSTR_RMDR" -v base="$b" 'BEGIN {
			if (name !~ /^[0-9A-Za-z_-]{1,15}$/)
				exit 1
			if (match(name, /[0-9]+$/)) {
				if ((cur = substr(name, 1, RSTART - 1)) == base)
					exit 3
				printf("tmpa=%s tmpb=\x22%s\x22", substr(name, RSTART), cur)
			} else {
				printf("tmpa=0 tmpb=\x22%s\x22", name)
			}
		}')" || {
			test $? -eq 3 && exit 3
			nx_io_printf -E "$NX_OPT_STR_RMDR is an invalid name, names must be 1 to 15 character of '0-9,a-z,A-Z,-._'" 1>&2
			unset tmpa
			exit 1
		}
		eval "$tmpa"
		while $tmpd ip link show "$tmpb$tmpa" 2>/dev/null 1>&2 || test "$tmpb$tmpa" = "$b"; do
			tmpa=$((tmpa+1))
			test "$(nx_str_len "$tmpb$tmpa")" -le 15 || {
				nx_io_printf -E "interface name '$tmpb$tmpa' is to long, the maximum length is 15." 1>&2
				exit 2
			}
		done
		printf 'tmpa=\x22%s\x22 tmpc=\x22%s\x22\n' "$tmpb$tmpa" "$v"
	)" || return
	eval "$tmpa"
	test -n "$tmpc" && printf '%s\n' "$tmpa"
	unset tmpc
}

nx_ip_netns()
(
	eval "$(nx_str_optarg 'r' "$@")"
	eval "$(
		test -n "$r" && {
			nx_data_repeat 'ip netns | grep -q "$NX_ARG" && ip netns delete "$NX_ARG"' "$NX_OPT_RMDR"
		} || {
			nx_data_repeat 'ip netns | grep -q "$NX_ARG" || ip netns add "$NX_ARG" && ip netns exec "$NX_ARG" ip link set lo up' "$NX_OPT_RMDR"
		}
	)"
)

__nx_ip_exec()
{
	test -n "$1" && {
		nx_ip_netns "$1"
		printf '%s ' "${1:+ip netns exec $1}"
	}
}

d_nx_ip_alt()
{
	g_nx_ip_alt $2 | grep -q '^'"$1"'$' || return 1
	$(__nx_ip_exec "$2") ip link property del dev $(g_nx_ip_ifname "$1" "$2") altname "$1"
}

g_nx_ip_l2()
(
	eval "$(nx_str_optarg ':n:a' "$@")"
	test -n "$n" && n="ip netns exec $n "
	test -n "$a" && $n ip neighbor | ${AWK:-$(nx_awk_cmd)} '{ print $(NF - 1) }'
	tmpa="$($n ip -json address show $NX_OPT_RMDR 2> /dev/null)" && nx_data_jdump "$tmpa" | ${AWK:-$(nx_awk_cmd)} '/\.nx\[[0-9]+\]\.address =/{print $NF}'
)

g_nx_ip_ifname()
(
	tmpa="$($(__nx_ip_exec "$2") ip -json link show $1 2> /dev/null)" && nx_data_jdump "$tmpa" | ${AWK:-$(nx_awk_cmd)} '/.nx\[[0-9]+\]\.ifname/{print $NF}'
)

g_nx_ip_alt()
(
	tmpa="$($(__nx_ip_exec "$2") ip -json link show $1 2> /dev/null)" && nx_data_jdump "$tmpa" | ${AWK:-$(nx_awk_cmd)} '/\.nx\[[0-9]+\]\.altnames\[[1-9][0-9]*\]/{print $NF}'
)

g_nx_ip_alias()
(
	tmpa="$($(__nx_ip_exec "$3") ip -json link show $1 2> /dev/null)" && nx_data_jdump "$tmpa" | ${AWK:-$(nx_awk_cmd)} '/\.nx\[[0-9]+\]\.ifalias/{print substr($0, index($0, "=") + 1)}'
)

s_nx_ip_group()
{
	$(__nx_ip_exec "$3") ip link set "$1" group "$(nx_int_natural "$2" || printf '%s' 'default')"
}

s_nx_ip_alias()
{
	g_nx_ip_alias | grep -q '^'"$2"'$' && return 1
	$(__nx_ip_exec "$3") ip link set "$1" alias "$2"
}

s_nx_ip_l2()
{
	$(__nx_ip_exec "$3") ip link set "$1" address "$2"
}

s_nx_ip_netns()
{
	test -n "$(__nx_ip_exec "$2")" -a -n "$(g_nx_ip_ifname "$1")" && ip link set "$1" netns "$2"
}

s_nx_ip_name()
{
	$(__nx_ip_exec "$3") ip link set "$1" name "$2"
}

s_nx_ip_alt()
{
	g_nx_ip_alt $3 | grep -q '^'"$2"'$' && return 1
	g_nx_ip_ifname "$1" "$3" | grep -q '^'"$1"'$' || return 2
	$(__nx_ip_exec "$3") ip link property add dev "$1" altname "$2"
}

s_nx_ip_state()
{
	g_nx_ip_ifname "$1" "$3" | grep -q '^'"$1"'$' || return 1
	$(__nx_ip_exec "$3") ip link set "$2" "$1"
}

s_nx_ip_inet()
{
	g_nx_ip_ifname "$1" "$3" | grep -q '^'"$1"'$' || return 1
	$(__nx_ip_exec "$3") ip link set "$2" "$1"
}

s_nx_ip_dev()
(
	eval "$(nx_str_optarg ':n:t:l:i:u' "$@")"
	tmpa="$(__nx_ip_exec "$n")"
	i=${i:-"$(nx_ip_name -v "$(nx_str_rand 8)")"}
	i="$(nx_ip_name -n "$n" -v -b "$i" "$i")"
	$tmpa ip link add "$i" type "${t:-dummy}"
	test -n "$u" && $tmpa ip link set up "$i"
)

s_nx_ip_veth()
(
	# upper -> peer
	eval "$(nx_str_optarg ':n:N:p:P:' "$@")"
	
	p="${p:-${P:-'ethernet'}}"
	nx_ip_netns "$n"
	prnm="$(nx_ip_name -v "$(nx_str_rand 8)")"
	pnm="$(nx_ip_name -n "$n" -v -b "$p" "$p")"

	P="${P:-$p}"
	nx_ip_netns "$N"
	Prnm="$(nx_ip_name -v "$(nx_str_rand 8)")"
	Pnm="$(nx_ip_name -n "$N" -v -b "$P" "$P")"

	ip link add "$prnm" type veth peer name "$Prnm"

	s_nx_ip_group "$prnm" 3
	s_nx_ip_group "$Prnm" 3

	s_nx_ip_netns "$prnm" "$n"
	s_nx_ip_netns "$Prnm" "$N"

	s_nx_ip_name "$Prnm" "$Pnm" "$N"
	s_nx_ip_name "$prnm" "$pnm" "$n"

	s_nx_ip_state "$Pnm" 'up' "$N"
	s_nx_ip_state "$pnm" 'up' "$n"

)

s_nx_ip_brtun()
(
	eval "$(nx_str_optarg ':u:n:b:t:' "$@")"
	b="${b:-bridge}"
	t="${t:-tap}"
	tmpa="$(__nx_ip_exec "$n")"
	bnm="$(nx_ip_name -n "$n" -v -b "$b" "$b")"
	$tmpa ip link add "$bnm" type bridge
	s_nx_ip_group "$pnm" 1 "$n"
	tnm="$(nx_ip_name -n "$n" -v -b "$t" "$t")"
	$tmpa ip tuntap add dev "$tnm" mode tap user "${u:-${USER:-$LOGNAME}}"
	$tmpa ip link set "$tnm" group 32
	$tmpa ip link set "$tnm" master "$bnm"
	s_nx_ip_state "$tnm" 'up' "$n"
	s_nx_ip_state "$bnm" 'up' "$n"
)

