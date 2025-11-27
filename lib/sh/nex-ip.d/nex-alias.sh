#nx_include NEX_L:/sh/nex-ip.sh

s_nx_ip_l2()
{
	$(__nx_ip_exec "$2") ip link set "$1" address "${3:-$(nx_ip_l2 -n "$2")}"
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
	eval "$(nx_str_optarg ':a:l:i:n:' "$@")"
	g_nx_ip_ifname "$i" "$n" | grep -q '^'"$i"'$' || return 1
	$(__nx_ip_exec "$n") ip address add "$a" ${l:+label "$l"} dev "$i"
}

s_nx_ip_dev()
(
	eval "$(nx_str_optarg ':n:t:l:i:' "$@")"
	tmpa="$(__nx_ip_exec "$n")"
	i=${i:-"$(nx_ip_name -v "$(nx_str_rand 8)")"}
	i="$(nx_ip_name -n "$n" -v -b "$i" "$i")"
	$tmpa ip link add "$i" type "${t:-dummy}"
)

s_nx_ip_route()
(
	eval "$(nx_str_optarg ':n:d:a:i:' "$@")"
	tmpa="$(__nx_ip_exec "$n")"
	$tmpa ip route add ${d:-default} via "$a" dev "$i"
)

s_nx_ip_master()
(
	eval "$(nx_str_optarg ':n:m:i:' "$@")"
	tmpa="$(__nx_ip_exec "$n")"
	$tmpa ip link set "$i" master "$m"
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

	s_nx_ip_l2 "$Pnm" "$N"
	s_nx_ip_l2 "$pnm" "$n"

	s_nx_ip_state "$Pnm" 'up' "$N"
	s_nx_ip_state "$pnm" 'up' "$n"
)

nx_ip_vlan() {
	eval "$(nx_str_optarg ':n:v:i:' "$@")"
	v="${v:-vlan}"
	ip link add link "$v" name "$v$n.$i" type vlan id "$i"
}

s_nx_ip_brtun()
(
	eval "$(nx_str_optarg ':u:n:b:t:' "$@")"
	b="${b:-bridge}"
	u="${u:-${USER:-$LOGNAME}}"
	t="${t:-$u-tap}"
	tmpa="$(__nx_ip_exec "$n")"
	bnm="$(nx_ip_name -n "$n" -v -b "$b" "$b")"
	$tmpa ip link add "$bnm" type bridge
	tnm="$(nx_ip_name -n "$n" -v -b "$t" "$t")"
	$tmpa ip tuntap add dev "$tnm" mode tap user "$u"
	$tmpa ip link set "$tnm" master "$bnm"
	s_nx_ip_group "$bnm" 1 "$n"
	$tmpa ip link set "$tnm" group 32
	s_nx_ip_l2 "$bnm" "$n"
	s_nx_ip_l2 "$tnm" "$n"
	s_nx_ip_state "$tnm" 'up' "$n"
	s_nx_ip_state "$bnm" 'up' "$n"
)

