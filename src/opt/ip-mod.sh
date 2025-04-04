
###:( chk ):##################################################################################
__chk_inet_opt()
{
	set_struct_opt -i "$1" -r "$($2)"
}

chk_inet_names()
{
	__chk_inet_opt "$1" get_inet_names
}

chk_inet_fam()
{
	__chk_inet_opt "$1" get_inet_fam
}

###:( get ):##################################################################################

__get_inet_opt()
{
	get_struct_list -u -s ',' -o ',' "$1"
}

__get_inet_dev()
{
	ip --color=never "$1" show "$(chk_inet_names "$2")"
}

get_inet_names()
{
	(
		[ "$1" != false ] && l_tmpa="$(
			get_str_search \
				-o ',' \
				-f '/altname/,1' \
				ip --color=never link show
		)"
		[ "$2" != false ] && l_tmpb="$(
			get_str_search \
				-o ',' \
				-f '/mtu/(@.*|:)/,-2' \
				ip --color=never link show
		)"
		echo -n "$l_tmpa${l_tmpa:+${l_tmpb:+,}}$l_tmpb"
	)
}

get_inet_real()
{
	(
		while getopts :d:pa OPT; do
			case $OPT in
				p) c="(.*@|:)";;
				a) c=":";;
				d) d="$OPTARG";;
			esac
		done
		shift $((OPTIND -1))
		get_str_search -o ',' -f "/mtu/${c:-(@.*|:)}/g,-2" __get_inet_dev link "${d:-$1}"
	)
}

get_inet_alt()
{
	get_str_search -o ',' -f '/altname/,1' __get_inet_dev link "$1"
}

get_inet_fam()
{
	__get_inet_opt 'inet6, inet, link, mpls, bridge'
}

get_inet_virt()  {
	__get_inet_opt '
		amt, bareudp, bond, bond_slave, bridge, bridge_slave,
		dummy, erspan, geneve, gre, gretap, gtp,ifb,
		ip6erspan, ip6gre, ip6gretap, ip6tnl, ipip,
		ipoib, ipvlan, ipvtap, macsec, macvlan, macvtap,
		netdevsim, netkit, nlmon, rmnet, sit, team,
		team_slave, vcan, veth, vlan, vrf, vti, vxcan,
		vxlan, wwan, xfrm, virt_wifi, dsa'
}

get_inet_obj()
{
	__get_inet_opt '
		address, addrlabel, fou, ila, ioam, l2tp, link,
		macsec, maddress, monitor, mptcp, mroute, mrule,
		neighbor, neighbour, netconf, netns, nexthop,
		ntable, ntbl, route, rule, sr, tap, tcpmetrics,
		token, tunnel, tuntap, vrf, xfrm'
}


###:( set ):##################################################################################
###:( new ):##################################################################################
##############################################################################################

