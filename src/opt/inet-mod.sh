__get_net_virt_types()	{
	get_struct_list -s ',' -o ',' '
		amt, bareudp, bond, bond_slave, bridge, bridge_slave,
		dummy, erspan, geneve, gre, gretap, gtp,ifb,
		ip6erspan, ip6gre, ip6gretap, ip6tnl, ipip,
		ipoib, ipvlan, ipvtap, macsec, macvlan, macvtap,
		netdevsim, netkit, nlmon, rmnet, sit, team,
		team_slave, vcan, veth, vlan, vrf, vti, vxcan,
		vxlan, wwan, xfrm, virt_wifi, dsa'
}

__chk_net_virt_type()
{
	set_struct_opt -i "$1" -r "$(__get_net_virt_types)"
}

__get_net_dev_name()
{
	get_str_search -o ',' -f '/mtu/:/,-2' ip --color=never link show
}

__get_net_dev_id()
{
	get_str_search -o ',' -f '/mtu/:/,-3' ip --color=never link show
}

__get_net_dev_map()
{
	get_struct_map "$(__get_net_dev_id),$(__get_net_dev_name)"
}

__get_net_dev_alt()
{
	get_str_search -o ',' -f '/altname/,1' ip --color=never link show
}

__get_net_dev_names()
{
	echo "$(__get_net_dev_alt),$(__get_net_dev_name)"
}

__chk_net_dev_names()
{
	set_struct_opt -i "$1" -r "$(__get_net_dev_names)"
}

__get_net_dev_realname()
{
	get_str_search -f '/mtu/:/,-2' ip --color=never address show "$(__chk_net_dev_names "$1")"
}

__is_net_dev() {
	[ -d "/sys/class/net/$(__get_net_dev_realname "$1")" ]
}

__get_net_obj()
{
	get_struct_list -s ',' -o ',' '
		address, addrlabel, fou, ila, ioam, l2tp, link,
		macsec, maddress, monitor, mptcp, mroute, mrule,
		neighbor, neighbour, netconf, netns, nexthop,
		ntable, ntbl, route, rule, sr, tap, tcpmetrics,
		token, tunnel, tuntap, vrf, xfrm'
}

__chk_net_obj()
{
	set_struct_opt -i "$1" -r "$(__get_net_obj)"
}

__get_net_fam()
{
	get_struct_list -s ',' -o ',' '
		inet6, inet, link, mpls, bridge'
}

__chk_net_fam()
{
	set_struct_opt -i "$1" -r "$(__get_net_fam)"
}

__get_net_dev_ipv6gen()
{
	get_struct_list -s ',' -o ',' '
		eui64, none, stable_secret, random'
}

__chk_net_dev_ipv6gen()
{
	set_struct_opt -i "$1" -r "$(__get_net_dev_ipv6gen)"
}

__get_net_dev_files()
{
	__is_net_dev "$1" && (
		f="/sys/class/net/$(__get_net_dev_realname "$1")"
		for i in "$f/"*; do
			get_content_leaf "$i"
		done
	)
}

__get_net_dev_list()
{
	(
		for i in "/sys/class/net/"*; do
			[ -h "$i" ] && get_content_leaf "$i"
		done
	)
}

get_net_dev_map()
{
	get_struct_list -s ' ' -o ',' "$(
		for i in $(get_net_dev_name_list); do
			echo "$(get_str_search -f "/$i:/:/,-1" ip link show "$i")=$i"
		done
	)"
}
__get_net_dev_file()
{
	__is_net_dev "$1" && {
		[ -f "/sys/class/net/$(__get_net_dev_realname "$1")/$2" ] && {
			cat "/sys/class/net/$(__get_net_dev_realname "$1")/$2"
		} || return 2
	} 2>/dev/null
}

get_net_dev_alias()
{
	__get_net_dev_file "$1" 'ifalias'
}

get_net_dev_index()
{
	__get_net_dev_file "$1" 'ifindex'
}

get_net_dev_duplex()
{
	__get_net_dev_file "$1" 'duplex'
}

get_net_dev_state()
{
	__get_net_dev_file "$1" 'operstate'
}

get_net_dev_mtu()
{
	__get_net_dev_file "$1" 'mtu'
}

get_net_dev_speed()
{
	__get_net_dev_file "$1" 'speed'
}

get_net_dev_l2()
{
	get_str_locate -f 'link/(ether|loopback)' -n 1 ip --color=never address show "$(__chk_net_dev_names "$1")"
}

get_net_dev_qlen()
{
	__get_net_dev_file "$1" 'tx_queue_len'
}

get_net_dev_inet6()
{
	get_str_locate -f 'inet6' -n 1 ip --color=never address show "$(__chk_net_dev_names "$1")"
}

get_net_dev_inet()
{
	get_str_locate -f 'inet' -n 1 -r '/.*' ip  --color=never address show "$(__chk_net_dev_names "$1")"
}


get_net_dev_inet4()
{
	get_str_locate -f 'inet' -r '.*:.*' -n 1 ip --color=never address show "$(__chk_net_dev_names "$1")"
}

__get_net_dev_info()
{
	eval $(
		while getopts :f:o:l:t:db4601 OPT; do
			case $OPT in
				o) O="$(__chk_net_obj "$OPTARG")";;
				f) F="$(__chk_net_fam "$OPTARG")";;
				d) I='-detail';;
				b) I='-brief';;
				l) L="$(__chk_net_dev_names "$OPTARG")";;
				t) T="$(__chk_net_virt_type "$OPTARG")";;
				4) F="inet";;
				6) F="inet6";;
				0) F="link";;
				1) I="-oneline";;
			esac
		done
		echo "L_NETOPTS='$(echo $I ${F:+-family} $F $O ${O:+show} ${T:+type} $T ${L:+dev} $L)' L_NETSHIFT='$((OPTIND - 1))'"
	)
}

get_net_l3_type()
{
	${AWK:-$(get_cmd_awk)} \
		-v addr="$1" \
		-v cidr="${2:-false}" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/structs.awk" \
			"$G_NEX_MOD_LIB/awk/inet.awk"
		)
	"'
		BEGIN {
			if (valid_ipv6(addr, cidr))
				print "inet6"
			else if (valid_ipv4(addr, cidr))
				print "inet"
			else
				exit 1
		}
	'
}

get_net_l2_type()
{
	${AWK:-$(get_cmd_awk)} \
		-v addr="$1" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/bool.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk" \
			"$G_NEX_MOD_LIB/awk/structs.awk" \
			"$G_NEX_MOD_LIB/awk/inet.awk"
		)
	"'
		BEGIN {
			if (addr = l2_type(addr))
				print addr
			else
				exit 1
		}
	'
}

new_net_l2_address()
{
	(
		while getopts :a:s:m:x:ul OPT; do
			case $OPT in
				s|a) eval "$OPT"="'${OPTARG:-true}'";;
				u|l) c="$OPT";;
				m) m="$(set_struct_opt -i "$OPTARG" -r 'universal, local, flip')";;
				x) x="$(set_struct_opt -i "$OPTARG" -r 'unicast, multicast, flip')";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(get_cmd_awk)} \
			-v ul="$m" \
			-v ig="$x" \
			-v acase="$c" \
			-v sep="$s" \
			-v addr="${a:-"$1"}" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/misc.awk" \
				"$G_NEX_MOD_LIB/awk/str.awk" \
				"$G_NEX_MOD_LIB/awk/types.awk" \
				"$G_NEX_MOD_LIB/awk/bool.awk" \
				"$G_NEX_MOD_LIB/awk/bases.awk" \
				"$G_NEX_MOD_LIB/awk/structs.awk" \
				"$G_NEX_MOD_LIB/awk/algor.awk" \
				"$G_NEX_MOD_LIB/awk/inet.awk"
			)
		"'
			BEGIN {
				if (valid_l2(addr = valid_prefix(addr, sep, ul, ig))) {
					if (acase == "u")
						printf("%s\n", toupper(addr))
					else if (acase == "l")
						printf("%s\n", tolower(addr))
					else
						printf("%s\n", addr)
				} else {
					exit 1
				}
			}
		'
	)
}

get_net_eui64()
{
	(
		while getopts :a:s: OPT; do
			case $OPT in
				s|a) eval "$OPT"="'${OPTARG:-true}'";;
				u|l) c="$OPT";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(get_cmd_awk)} \
			-v acase="$c" \
			-v sep="$s" \
			-v addr="${a:-"$1"}" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/misc.awk" \
				"$G_NEX_MOD_LIB/awk/str.awk" \
				"$G_NEX_MOD_LIB/awk/types.awk" \
				"$G_NEX_MOD_LIB/awk/bool.awk" \
				"$G_NEX_MOD_LIB/awk/bases.awk" \
				"$G_NEX_MOD_LIB/awk/structs.awk" \
				"$G_NEX_MOD_LIB/awk/algor.awk" \
				"$G_NEX_MOD_LIB/awk/inet.awk"
			)
		"'
			BEGIN {
				if (valid_l2(addr)) {
					addr = eui64(addr, sep)
					if (acase == "u")
						printf("%s\n", toupper(addr))
					else if (acase == "l")
						printf("%s\n", tolower(addr))
					else
						printf("%s\n", addr)
				} else {
					exit 1
				}
			}
		'
	)
}

get_net_info_menu()
{
	(
		while :; do
			RES=$(get_dialog_menu \
				-p $(get_struct_map "$(__get_net_dev_name),$(__get_net_dev_id)") \
				-m "'tit=Network Info,ok=Select Device,cancel=Exit Menu, iproute2'"
			) || case $? in
				1) break
			esac
			#eval "$RES"
			#get_dialog_other -v programbox -m "'
			#	title=$GDF_SL_1,
			#	ok=Back,
			#	echo "hello world"
			#'"
		done
	)
}
