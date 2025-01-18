#!/bin/sh
###:( get ):##################################################################################

__get_net_virt_types()  {
	get_struct_clist -s ',' -o ',' 'amt, bareudp,
	bond, bond_slave, bridge, bridge_slave, dsa,
	dummy, erspan, geneve, gre, gretap, gtp,ifb, 
	ip6erspan, ip6gre, ip6gretap, ip6tnl, ipip,
	ipoib, ipvlan, ipvtap, macsec, macvlan, macvtap,
	netdevsim, netkit, nlmon, rmnet, sit, team,
	team_slave, vcan, veth, vlan, vrf, vti, vxcan,
	vxlan, wwan, xfrm, virt_wifi'
}

get_net_l3_inet() {
	(
		while getopts :a:n OPT; do
                       case $OPT in
                                a|n) eval "$OPT"="'${OPTARG:-true}'";;
                        esac
                done
                shift $((OPTIND - 1))
		$(get_cmd_awk) \
			-v nonwln="$n" \
			-v addr="${a:-"$1"}" "
                        $(cat \
				"$G_NEX_MOD_LIB/awk/strings.awk" \
				"$G_NEX_MOD_LIB/awk/conv.awk" \
				"$G_NEX_MOD_LIB/awk/math.awk" \
				"$G_NEX_MOD_LIB/awk/l3.awk"
                        )
		"'
			BEGIN {
				printf("%s", inet(addr))
				if (! nonwln)
					printf("\x0a")
			}
		'
	)
}

get_net_l3_ipv6() {
	(
		while getopts :a:rulet OPT; do
                        case $OPT in
                                r|a) eval "$OPT"="'${OPTARG:-true}'";;
				e|t) f="$OPT";;
				u|l) c="$OPT";;
                        esac
                done
                shift $((OPTIND - 1))
		$(get_cmd_awk) \
			-v cidreq="$r" \
			-v addr="${a:-"$1"}" \
			-v fmt="${f:-"$2"}" \
			-v acase="${c:-"$3"}" "
                        $(cat \
				"$G_NEX_MOD_LIB/awk/strings.awk" \
				"$G_NEX_MOD_LIB/awk/conv.awk" \
				"$G_NEX_MOD_LIB/awk/math.awk" \
				"$G_NEX_MOD_LIB/awk/l3.awk"
                        )
		"'
			BEGIN {
				if (valid_ipv6(addr, cidreq)) {
					if (! cidreq)
						addr = __network(addr)
					if (acase == "u")
						addr = toupper(addr)
					else if (acase == "l")
						addr = tolower(addr)
					if (fmt == "t")
						printf("%s\n", truncate_ipv6(addr))
					else if (fmt == "e")
						printf("%s\n", expand_ipv6(addr))
					else
						printf("%s\n", addr)
				} else {
					exit 1
				}
			}
		'
	)
}

get_net_l3_ipv4() {
	(
		while getopts :a:rn OPT; do
                        case $OPT in
                                r|a|n) eval "$OPT"="'${OPTARG:-true}'";;
                        esac
                done
                shift $((OPTIND - 1))
		$(get_cmd_awk) \
			-v nonwln="$n" \
			-v cidreq="$r" \
			-v addr="${a:-"$1"}" "
                        $(cat \
				"$G_NEX_MOD_LIB/awk/strings.awk" \
				"$G_NEX_MOD_LIB/awk/conv.awk" \
				"$G_NEX_MOD_LIB/awk/math.awk" \
				"$G_NEX_MOD_LIB/awk/l3.awk"
                        )
		"'
			BEGIN {
				if (addr = valid_ipv4(addr, cidreq)) {
					if (! cidreq)
						addr = __network(addr)
					printf("%s\n", addr)
				} else {
					exit 1
				}
			}
		'
	)
}

get_net_l3_type() {
	$(get_cmd_awk) \
		-v addr="$1" \
		-v cidreq="$2" "
                $(cat \
			"$G_NEX_MOD_LIB/awk/strings.awk" \
			"$G_NEX_MOD_LIB/awk/l3.awk"
		)
	"'
		BEGIN {
			if (valid_ipv6(addr, cidreq))
				print "inet6"
			else if (valid_ipv4(addr, cidreq))
				print "inet"
			else
				exit 1
		}
	'
}

get_net_l2_type() {
	$(get_cmd_awk) \
		-v addr="$1" "
                $(cat \
			"$G_NEX_MOD_LIB/awk/strings.awk" \
			"$G_NEX_MOD_LIB/awk/struct.awk" \
			"$G_NEX_MOD_LIB/awk/conv.awk" \
			"$G_NEX_MOD_LIB/awk/binary.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/l2.awk"
                )
	"'
		BEGIN {
			print l2_type(addr)
		}
	'
}

new_net_l2_address() {
	(
		while getopts :a:s:m:x:ul OPT; do
                        case $OPT in
                                s|a) eval "$OPT"="'${OPTARG:-true}'";;
				u|l) c="$OPT";;
				m) m="$(set_struct_opt -i "$OPTARG" 'universal, local, flip')";;
				x) x="$(set_struct_opt -i "$OPTARG" 'unicast, multicast, flip')";;
                        esac
                done
                shift $((OPTIND - 1))
		$(get_cmd_awk) \
			-v ul="$m" \
			-v ig="$x" \
			-v acase="$c" \
			-v sep="$s" \
			-v addr="${a:-"$1"}" "
                        $(cat \
				"$G_NEX_MOD_LIB/awk/strings.awk" \
				"$G_NEX_MOD_LIB/awk/struct.awk" \
				"$G_NEX_MOD_LIB/awk/conv.awk" \
				"$G_NEX_MOD_LIB/awk/binary.awk" \
				"$G_NEX_MOD_LIB/awk/math.awk" \
				"$G_NEX_MOD_LIB/awk/l2.awk"
                        )
		"'
			BEGIN {
				if (valid_address((addr = valid_prefix(addr, sep, ul, ig)))) {
					if (acase == "u")
						printf("%s\n", toupper(addr))
					else if (acase == "l")
						printf("%s\n", tolower(addr))
					else
						printf("%s\n", addr)
				}
			}
		'
	)
}

chk_net_virt_type() {
	set_struct_opt -i "$1" "$(__get_net_virt_types)"
}

chk_net_obj() {
        set_struct_opt -i "$1" \
                'address, addrlabel, fou, ila, ioam, l2tp, link,
                macsec, maddress, monitor, mptcp, mroute, mrule,
                neighbor, neighbour, netconf, netns, nexthop,
                ntable, ntbl, route, rule, sr, tap, tcpmetrics, 
                token, tunnel, tuntap, vrf, xfrm'
}

chk_net_fam() {
        set_struct_opt -i "$1" \
                'inet6, inet, link, mpls, bridge'
}


