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
		g_nx_ip_l2 -a | grep -q "$tmpa" || break
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

nx_ip_exec()
{
	ip netns exec $*
}


s_nx_ip_group()
{
	$3 ip link set "$1" group "$(nx_int_natural "$2" || printf '%s' 'default')"
}

s_nx_ip_alias()
{
	g_nx_ip_alias | grep -q '^'"$2"'$' && return 1
	ip link set "$1" alias "$2"
}

s_nx_ip_l2()
{
	ip link set "$1" address "$2"
}

s_nx_ip_name()
{
	ip link set "$1" name "$2"
}

s_nx_ip_alt()
{
	g_nx_ip_alt | grep -q '^'"${2}"'$' && return 1
	ip link property add dev "$1" altname "$2"
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
	tmpa="$(ip -json link show $1 2> /dev/null)" && nx_data_jdump "$tmpa" | ${AWK:-$(nx_awk_cmd)} '/.nx\[[0-9]+\]\.ifname/{print $NF}'
)

g_nx_ip_alt()
(
	tmpa="$(ip -json link show $1 2> /dev/null)" && nx_data_jdump "$tmpa" | ${AWK:-$(nx_awk_cmd)} '/\.nx\[[0-9]+\]\.altnames\[[1-9][0-9]*\]/{print $NF}'
)

g_nx_ip_alias()
(
	tmpa="$(ip -json link show $1 2> /dev/null)" && nx_data_jdump "$tmpa" | ${AWK:-$(nx_awk_cmd)} '/\.nx\[[0-9]+\]\.ifalias/{print substr($0, index($0, "=") + 1)}'
)

nx_ip_veth()
(
	eval "$(nx_str_optarg ':n:e:p:' "$@")"
	e="${e:-"$p"}"
	p="${p:-"$e"}"
	test -n "$e" || exit
	tmpa="$(ip -oneline link show "$e" type veth 2> /dev/null)"
	test -n "$tmpa" || {
		if test -n "$n"; then
			nx_ip_netns "$n"
			tmpc="ip netns exec '$n'"
			tmpb="$(nx_str_rand 15)"
			ip link add "$e" type veth peer name "$tmpb"
			ip link set "$tmpb" netns "$n"
			nx_ip_name -n "$n" "$p" || exit
			ip netns exec "$n" ip link set "$tmpb" name "$tmpa"
			s_nx_ip_group "$e" 3
			s_nx_ip_group "$tmpb" 3
			ip link set "$tmpb" up
			ip link set "$e" up
		else
			nx_ip_name "$p" || exit
			ip link add "$e" type veth peer name "$tmpa"
			ip link set "$tmpa" up
			ip link set "$e" up
		fi
	}
)

nx_ip_brtun()
(
	eval "$(nx_str_optarg ':n:b:t:' "$@")"
	test -n "$n" && tmpb="ip netns exec $n" || tmpb=""
	b="${b:-bridge}"
	t="${t:-tap}"
	tmpa="$(ip netns exec posix-nexus ip link show "$b" type bridge)"\
	test -z "$tmpa" && {
		nx_ip_name "$b"
		b="$tmpa"
		$tmpb ip link add name "$b" type bridge
		$tmpb ip link set "$t" group 1
	}
	$tmpb ip -detail -oneline link show "$t" | grep -q 'tun type tap' || {
		nx_ip_name "$t"
		t="$tmpa"
		$tmpb ip tuntap add dev "$t" mode tap user "${u:-${USER:-$LOGNAME}}"
		$tmpb ip link set "$t" group 32
		$tmpb ip link set "$t" master "$b"
		$tmpb ip link set "$t" up
	}
	$tmpb ip link set dev "$b" up
)

