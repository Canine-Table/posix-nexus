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

__get_net_dev_file()
{
	__is_net_dev "$1" && {
		[ -f "/sys/class/net/$(__get_net_dev_realname "$1")/$2" ] && {
			cat "/sys/class/net/$(__get_net_dev_realname "$1")/$2"
		} || return 2
	} 2>/dev/null
}

__get_net_dev_alias()
{
	__get_net_dev_file "$1" 'ifalias'
}

__get_net_dev_index()
{
	__get_net_dev_file "$1" 'ifindex'
}

__get_net_dev_duplex()
{
	__get_net_dev_file "$1" 'duplex'
}

__get_net_dev_state()
{
	__get_net_dev_file "$1" 'operstate'
}

__get_net_dev_mtu()
{
	__get_net_dev_file "$1" 'mtu'
}

__get_net_dev_speed()
{
	__get_net_dev_file "$1" 'speed'
}

__get_net_dev_qlen()
{
	__get_net_dev_file "$1" 'tx_queue_len'
}

get_net_dev_l2()
{
	get_str_search -o ',' -d '"' -f '"link/(ether|loopback)",1' ip --color=never link show "$(__chk_net_dev_names "$1")"
}

get_net_dev_inet()
{
	(
		while getopts :d:46c OPT; do
			case $OPT in
				4) f='inet$';;
				6) f='inet6';;
				c) c='/.*';;
				d) d="$OPTARG";;
			esac
		done
		shift $((OPTIND - 1))
		get_str_search -o ',' -d '!' -f "!${f:-inet}!$c!,1" ip --color=never address show "$(__chk_net_dev_names "${d:-$1}")"
	)
}

get_net_dev_name()
{
	(
		while getopts :d:pa OPT; do
			case $OPT in
				p) c='(.*@|:)';;
				a) c=':';;
				d) d="$OPTARG";;
			esac
		done
		shift $((OPTIND - 1))
		get_str_search -o ',' -f "/mtu/${c:-(@.*|:)}/g,-2" ip --color=never link show "$(chk_net_dev_names "${d:-$1}")"
	)
}

get_net_dev_alt()
{
	get_str_search -o ',' -f '/altname/,1' ip --color=never link show "$(chk_net_dev_names "$1")"
}

get_net_dev_names()
{
	echo "$(get_net_dev_alt),$(get_net_dev_name)"
}

chk_net_dev_names()
{
	set_struct_opt -i "$1" -r "$(get_net_dev_names)"
}

get_net_dev_realname()
{
	get_str_search -f '/mtu/:/,-2' ip --color=never address show "$(chk_net_dev_names "$1")"
}


get_net_dev_id()
{
	get_str_search -o ',' -f '/mtu/:/,-3' ip --color=never link show "$(__chk_net_dev_names "$1")"
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

get_net_menu()
{
	(
		while :; do
			L_NEX_DIALOG_RESPONSE=$(get_dialog_menu \
				-p $(get_struct_map "$(__get_net_dev_id),$(__get_net_dev_name)") \
				-m '
					title=Network Devices,
					ok=Modify Device,
					cancel=Exit Menu,
					extra=Device Information,
					help=New Device,
					message=POSIX Nexus Network Management: Select an interface to inspect and configure.
				'
			)
			L_NEX_DIALOG_STATE=$?
			eval "$L_NEX_DIALOG_RESPONSE"
			L_NEX_IFACE=$(get_struct_ref "$GDF_SL_1")
			case $L_NEX_DIALOG_STATE in
				0) __get_net_menu_modify;;
				1) break;;
				2) __get_net_menu_new;;
				3) __get_net_menu_info;;
			esac
		done
	)
}

__get_net_menu_info()
{
	(
		get_dialog_other \
			-v 'msgbox' \
			-m "tit=$L_NEX_IFACE,
				ok=Done,
			" -c "$(
				for i in inet inet6 l2; do
					j="$(get_net_dev_$i "$L_NEX_IFACE")\\\\n"
					[ -n "$j" ] && echo "$i: $j"
				done
			)"
	)
}

__get_net_menu_modify()
{
	(
		while :; do
			L_NEX_DIALOG_RESPONSE=$(get_dialog_menu \
				-v 'buildlist' \
				-p 'inet6,inet4,l2,duplex,qlen,index,alias,state,mtu,speed' \
				-m "
					title=$L_NEX_IFACE,
					cancel=Go Back,
					ok=Proceed,
					message=Choose the network properties you want to adjust. Each selection will lead to a detailed setup screen.,
				"
			) || case $? in
				1) break
			esac
			L_NEX_DIALOG_STATE=$?
			eval "$L_NEX_DIALOG_RESPONSE"
		done
	)
}

__get_net_menu_new()
{
	(
		while :; do
			L_NEX_DIALOG_RESPONSE=$(get_dialog_menu \
				-v 'radiolist' \
				-p "$(__get_net_virt_types)" \
				-m "
					title=Virtual Devices,
					cancel=Go Back,
					ok=Proceed,
					message=Choose the network device you want to add.
				"
			) || case $? in
				1) break
			esac
			L_NEX_DIALOG_STATE=$?
			eval "$L_NEX_DIALOG_RESPONSE"
		done
	)
}


