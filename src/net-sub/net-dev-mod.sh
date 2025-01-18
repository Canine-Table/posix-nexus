#!/bin/sh

###:( get ):##################################################################################

__get_net_dev_info() {
	eval $(
		while getopts :f:o:l:t:db4601 OPT; do
                        case "$OPT" in
				o) O="$(chk_net_obj "$OPTARG")";;
				f) F="$(chk_net_fam "$OPTARG")";;
                                d) I='-detail';;
                                b) I='-brief';;
				l) L="$(chk_net_dev "$OPTARG")";;
				t) T="$(chk_net_virt_type "$OPTARG")";;
                                4) F="inet";;
                                6) F="inet6";;
                                0) F="link";;
                                1) I="-oneline";;
                        esac
                done
		echo "L_NETOPTS='$(echo $I ${F:+-family} $F $O ${O:+show} ${T:+type} $T ${L:+dev} $L)'"
		echo "L_NETSHIFT='$((OPTIND - 1))'"
	)
}

get_net_dev_info() {
	(
		__get_net_dev_info $*
		shift $L_NETSHIFT
		ip $L_NETOPTS | $(get_cmd_awk) \
			-v prop="$*" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/struct.awk"
			)
		"'
			BEGIN {
				if (prop)
					array(prop, props, ",")
			}
			{
				if (prop) {
					for (i = 1; i <= NF; i++) {
						if ($i in props)
							print $(i + 1)
					}
				} else {
					print
				}
			}
			END {
				if (prop)
					delete props
			}
		'
	)
}

get_net_dev_name_list() {
	(
		for i in "/sys/class/net/"*; do
			[ -h "$i" ] && get_content_leaf "$i"
		done
	)
}

get_net_dev_file() {
	(
		f="$(chk_net_dev_files "$1" "$2")" || exit 6
		cat "/sys/class/net/$(get_net_dev_real "$1")/$f"
	)
}

get_net_dev_ether_list() {
	get_net_dev_info -o link 'link/ether, link/loopback'
}

get_net_dev_group() {
	(
		__load_net_dev_name "$1"
		get_net_dev_info -o link -l "$L_IFACE" 'group'
	)
}

get_net_dev_real() {
	(
		iface=$(chk_net_dev "$1") || exit	
		ip link show dev "$iface" | $(get_cmd_awk) -F ":" '
			{
				gsub(/^ */, "", $2)
				if (! (i = index($2, "@")))
					i = length($2) + 1
				print substr($2, 1, i - 1)
				exit 0
			}'
	)
}

get_net_dev_stats() {
	get_net_dev "$1" "statistics"
}

get_net_dev() {
	(
		__load_net_dev_real "$1"
		get_file_contents "/sys/class/net/$L_IFACE${2:+/}$2"
	)
}

get_net_dev_type() {
	(
		__load_net_dev_name "$1"
		for i in $(get_struct_clist $(__get_net_virt_types)); do
			[ -n "$(ip link show dev "$L_IFACE" type "$i")" ] && {
				echo "$i"
				exit 0
			}
		done
		exit 13
	)
}

get_net_dev_l3_ipv6_list() {
	(
		for i in $(get_net_dev_info -o address 'inet6'); do
			get_net_l3_ipv6 -rel "$i"
		done
	)
}

get_net_dev_alias() {
	get_net_dev_file "$1" 'ifalias'
}

get_net_dev_index() {
	get_net_dev_file "$1" 'ifindex'
}

get_net_dev_duplex() {
	get_net_dev_file "$1" 'duplex'
}

get_net_dev_state() {
	get_net_dev_file "$1" 'operstate'
}

get_net_dev_mtu() {
	get_net_dev_file "$1" 'mtu'
}

get_net_dev_speed() {
	get_net_dev_file "$1" 'speed'
}

get_net_dev_l2_address() {
	get_net_dev_file "$1" 'address'
}

get_net_dev_qlen() {
	get_net_dev_file "$1" 'tx_queue_len'
}

get_net_dev_l2_broadcast() {
	get_net_dev_file "$1" 'broadcast'
}

get_net_dev_relative() {
	(
		__load_net_dev_name "$1"
		shift
		while getopts incp OPT; do
                        case $OPT in
				i|n) d="$OPT";;
				c|p) r="$OPT";;
                        esac
                done
                shift $((OPTIND - 1))
		case "$d" in
			n) d='INTERFACE=';;
			i) d='IFINDEX=';;
			*) exit 10;;
		esac
		case "$r" in
			c) r='upper_';;
			p) r='lower_';;
			*) exit 11;;
		esac
		for prnt in "/sys/class/net/$L_IFACE/$r"*; do
			cat "$prnt/uevent" 2>/dev/null
		done | $(get_cmd_awk) \
			-v dv="$d" '
			{
				if (sub(dv, "", $0))
					print
			}
		'
	)
}

get_net_dev_flags() {
	(
		__load_net_dev_name "$1"
		get_net_dev_info -o link -l "$L_IFACE" | $(get_cmd_awk) '
			{
				gsub(/<|>/, "", $3)
				gsub(/,/, "\n", $3)
				print $3
				exit 0
			}
		'
	)
}

get_net_dev_l3_eui64() {
	(
		__load_net_dev_name "$1"
		__load_net_dev_l2_address "$L_IFACE"
		$(get_cmd_awk) \
			-v l2="$L_IFACE_L2_ADDRESS" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/strings.awk" \
				"$G_NEX_MOD_LIB/awk/conv.awk" \
				"$G_NEX_MOD_LIB/awk/binary.awk" \
				"$G_NEX_MOD_LIB/awk/math.awk" \
				"$G_NEX_MOD_LIB/awk/struct.awk" \
				"$G_NEX_MOD_LIB/awk/l2.awk"
			)
			"'
				BEGIN {
					print eui64(l2)
				}
			'
	)
}

###:( load ):#################################################################################

__load_net_dev_name() {
	L_IFACE=$(chk_net_dev "$1") || exit
}

__load_net_dev_real() {
	L_IFACE="$(get_net_dev_real "$1")" || exit
}

__load_net_dev_alias() {
	L_IFACE_ALIAS="$(get_net_dev_real "$1")" || exit
}

__load_net_dev_group() {
	L_IFACE_GROUP="$(get_net_dev_group "$1")" || exit
}

__load_net_dev_state() {
	L_IFACE_STATE="$(get_net_dev_state "$1")" || exit
}

__load_net_dev_l2_address() {
	L_IFACE_L2_ADDRESS="$(get_net_dev_l2_address "$1")" || exit
}

__load_net_dev_mtu() {
	L_IFACE_MTU="$(get_net_dev_mtu "$1")" || exit
}

__load_net_dev_qlen() {
	L_IFACE_QLEN="$(get_net_dev_qlen "$1")" || exit
}

__load_net_dev_flag_states() {
	eval "$(
		$(get_cmd_awk) \
			-v ste="$2" \
			-v sep="$3" \
			-v flg="$(get_net_dev_flags "$1")" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/strings.awk" \
				"$G_NEX_MOD_LIB/awk/conv.awk" \
				"$G_NEX_MOD_LIB/awk/binary.awk" \
				"$G_NEX_MOD_LIB/awk/math.awk" \
				"$G_NEX_MOD_LIB/awk/struct.awk" \
				"$G_NEX_MOD_LIB/awk/l2.awk"
			)
		"'
			BEGIN {
				print flag_states(flg, ste, sep)
			}
		'
	)"
}

###:( set ):##################################################################################

set_net_dev_flags() {
	(
		__load_net_dev_name "$1"
		shift
		while getopts :o:f: OPT; do
                        case $OPT in
				o|f) eval "$OPT"="'$(get_struct_ref_append "$OPT" "$OPTARG")'";;
                        esac
                done
                shift $((OPTIND - 1))
		$(get_cmd_awk) \
			-v on="$o" \
			-v off="$f" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/struct.awk"
			)
		"'
			BEGIN {
				array(on "," off, arr)
				for (i in arr) {
					if (v = complete_opt(i, "multicast, allmulticast, arp, promisc")) {
						if (str)
							str = str ","
						str = str v
					}
				}
				print clist_uniq(str, ",", ",")
			}
		'
		#__load_net_dev_name "$1"
	)
}


						#set_struct_opt -i "$OPTARG" "
						#	
						#)"

set_net_dev_l3_address() {
	(
		__load_net_dev_name "$1"
		a="$(get_net_l3_ipv4 "$2")" || a="$(get_net_l3_ipv6 "$2")" || exit 14
		echo $a
	)
}

set_net_dev_name() {
	(
		__load_net_dev_name "$1"
		shift
		while getopts :a:s:n:i OPT; do
                        case $OPT in
				i|n|a|s) eval "$OPT"="'${OPTARG:-true}'";;
                        esac
		done
		shift $((OPTIND - 1))
		[ -n "$a" ] && {
			alts="$(get_net_dev_info -o link 'altname')"
			alt="$(get_net_dev_info -o link -l "$L_IFACE" 'altname')"
			i="${i:-false}" || alts="$(get_struct_diff -s '\n' -i "$alts" -r "$alt")"
			alts="$(get_struct_diff -s '\n' -i "$a" -r "$alts")"
			[ -n "$alts" ] && {
				"$i" || {
					for i in $alt; do
						ip link property del dev "$L_IFACE" altname "$i"
					done
				}
				for i in $alts; do
					alt=$(__is_net_dev_label_valid "$i") && {
						ip link property add dev "$L_IFACE" altname "$alt"
					}
				done
			}
		}
		n=$(__is_net_dev_label_valid "${n:-$1}") && {
			get_struct_diff -q -s '\n' -i "$n" -r "$(get_net_dev_name_list)" && {
				ip link set dev "$L_IFACE" name "$n"
			}
		}
	)
}

set_net_dev_qlen() {
	[ -n "$(get_int_range "$2" 10 999999999)" ] && (
		__load_net_dev_name "$1"
		__load_net_dev_qlen "$L_IFACE"
		[ "$2" != "$L_IFACE_QLEN" ] && {
			ip link set "$L_IFACE" txqueuelen "$2"
		}
	)
}

set_net_dev_mtu() {
	[ -n "$(get_int_range "$2" 576 65535)" ] && (
		__load_net_dev_name "$1"
		__load_net_dev_mtu "$L_IFACE"
		[ "$2" != "$L_IFACE_MTU" ] && {
			ip link set "$L_IFACE" mtu "$2"
		}
	)
}

set_net_dev_l2_address() {
	(
		__load_net_dev_name "$1"
		__load_net_dev_l2_address "$L_IFACE"
		shift
		while getopts :m:olu OPT; do
                        case $OPT in
				o|m) eval "$OPT"="'${OPTARG:-true}'";;
				l|u) c="$OPT";;
                        esac
                done
                shift $((OPTIND - 1))
		a="$(new_net_l2_address \
			-x 'unicast' \
			-m 'local' \
			"-${c:-l}" \
			"${o:+"$(echo "$L_IFACE_L2_ADDRESS" | cut -d ':' -f -3)"}$m"
		)" || exit
		get_struct_diff \
			-s '\n' -q -i "$a" \
			-r "$(get_net_dev_ether_list)" && {
				ip link set dev "$L_IFACE" address "$a"
			}
	)
}

set_net_dev_alias() {
	[ -n "$2" ] && (
		__load_net_dev_name "$1"
		__load_net_dev_alias "$L_IFACE"
		[ "$L_IFACE_ALIAS" != "$2" ] && {
			ip link set dev "$L_IFACE" alias "$2"
		}
	)
}

set_net_dev_l2_multicast() {
	(
		:
	)
}

set_net_dev_group() {
	[ -n "$2" ] && (
		__load_net_dev_name "$1"
		__load_net_dev_group "$L_IFACE"
		[ "$2" != "$L_IFACE_GROUP" ] && {

			[ "$2" = 'default' -o "$2" = '0' ] && {
				[ "$L_IFACE_GROUP" = 'default' ] && exit || grp='default'
			} || grp=$(get_int_range "$2" 1 2147483647) || exit
			ip link set dev "$L_IFACE" group "$grp"
		}
	)
}

set_net_dev_state() {
	[ -n "$2" ] && (
		__load_net_dev_name "$1"
		__load_net_dev_group "$L_IFACE"
		ste="$(set_struct_opt -i "$2" 'up, down')"
		[ "$ste" != "$L_IFACE_STATE" ] && ip link set "$L_IFACE" "$ste"
	)
}

set_net_dev_ipv6gen() {
	[ -n "$2" ] && (
		__load_net_dev_name "$1"
		__is_net_dev_loopback "$L_IFACE"
		g="$(chk_net_dev_ipv6gen "$1")" && {
			ip link set dev "$L_IFACE" addrgenmode "$g"
		}
	)
}

###:( chk ):##################################################################################

chk_net_dev_ipv6gen() {
	set_struct_opt -i "$1" 'eui64, none, stable_secret, random'
}

chk_net_dev_files() {
	set_struct_opt -i "$2" $(
		set_struct_join -s ',' $(
			for i in $(get_file_list "/sys/class/net/$(get_net_dev_real "$1")"); do
				get_content_leaf "$i"
			done
		)
	)
}

chk_net_dev_flags() {
	set_struct_opt -i "$1" 'arp, promisc, multicast, allmulticast'
}

chk_net_dev() {
	set_struct_opt -i "$1" $(
		set_struct_join -s ',' "$(
			get_net_dev_name_list
			get_net_dev_info -o link 'altname'
		)"
	)
}

###:( is ):##################################################################################

__is_net_dev_loopback() {
	[ -n "$(get_net_dev_flags "$1" | $(get_cmd_awk) '$1 == "LOOPBACK" {print; exit}')" ] || exit 12
}

__is_net_dev_label_valid() {
	$(get_cmd_awk) \
		-v nm="$1" '
		BEGIN {
			if (nm !~ /^([[:alnum:]_]|[.]|-){1,15}$/) 
				exit 1
			print nm
		}
	'
}

##############################################################################################

alias gndi=get_net_dev_info


