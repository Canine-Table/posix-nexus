. "$(cat "$HOME/.nx/.nx-root" 2> /dev/null)"

test -n "$NEXUS_CNF" || {
	printf 'nex-init needs to loaded before using these tools.\n'
	return 1
}

test "$(id -u)" -eq 0 || {
	nx_tty_print -E "elevated privileges required!"
	return 2
}

nx_ip_vlan176()
( # vlan 176 (qemu)
	for j in 'questing' 'wsc2025' 'gentoo' 'lfs'; do
		eval "$(nx_ip_s_tap -v "$j" -u nex)"
		NEX_k_d="$G_NEX_NET_TAP"
		nx_ip_s_master
		nx_ip_s_state 'up'
	done
)

nx_ip_vlan192()
( # vlan 192 (vpn connection port forwarding destination)
	return
)

nx_ip_vlan240()
( # vlan 240 (internal services dhcp dns etc, management)
	return
)

nx_ip_vlan224()
( # vlan 224 (iscsi, nfs, and filesystem related stuff)
	return
)

nx_ip_vlan208()
( # vlan 208 (pods)
	k=2
	tmpa="$NEX_k_n"
	nx_tty_print -i "ns: $tmpa\n"
	for j in 'phpmyadmin' 'pgadmin'; do
		nx_tty_print -a "current: $k\n"
		__nx_ip_r_netns "$j"
		NEX_k_n="$tmpa"
		eval "$(nx_ip_n_veth -N "$j")"
		NEX_k_d="$G_NEX_NET_VETH"
		nx_tty_print -i "veth: $NEX_k_d\n"
		nx_ip_s_master
		eval "$(nx_ip_s_vlan_bridge -i '208')"
		NEX_k_n="$j"
		NEX_k_d="$G_NEX_NET_PEER"
		nx_tty_print -i "peer: $NEX_k_d\n"
		nx_ip_s_inet -l "vlan$i" -v "172.16.208.$k/20"
		nx_ip_s_state 'up'
		nx_ip_s_route  '172.16.208.1'
		k=$((k + 1))
	done
)

__nx_ip_r_netns posix
__nx_ip_r_netns phpmyadmin
__nx_ip_r_netns pgadmin
nx_ip_r_dev -d nexus0

: << 'EOF'
__nx_ip_r_netns posix_176
__nx_ip_r_netns posix_192
__nx_ip_r_netns posix_208
__nx_ip_r_netns posix_224
__nx_ip_r_netns posix_240
EOF

nx_ip_link()
{
	nx_data_optargs 'N:l:i:c:o:' "$@"
	eval "$(nx_ip_n_veth -N "$NEX_k_N")"
	NEX_k_d="$G_NEX_NET_VETH"
	nx_tty_print -i "veth: $NEX_k_d -> (ns: nex-$NEX_k_N) peer: $G_NEX_NET_PEER\n"
	nx_ip_s_inet -l "${NEX_k_l:-$NEX_k_N}-inet4" -v "172.16.${NEX_k_c:-128}.1/${NEX_k_o:-17}"
	nx_ip_s_state 'up'
	NEX_k_d="$G_NEX_NET_PEER"
	NEX_k_n="$NEX_k_N"
	nx_ip_s_inet -l "$NEX_k_N-inet4" -v "172.16.${NEX_k_c:-128}.2/${NEX_k_o:-17}"
	nx_ip_s_state 'up'
	nx_ip_s_route  "172.16.${NEX_k_c:-128}.1"
	eval "$(nx_ip_s_bridge -l 'bridge')"
	NEX_k_d="$G_NEX_NET_BRIDGE"
	nx_br="$NEX_k_d"
	nx_tty_print -i "bridge: $NEX_k_d\n"
	nx_ip_s_state 'up'
	eval "$(nx_ip_s_vlan_bridge -I '999' -i "$NEX_k_i,999")"
}


(
	nx_ip_link \
		-i '176,192,208,224,240' \
		-N 'posix' \
		-o '17' \
		-c '128' \
		-l 'default'

	NEX_k_m="$G_NEX_NET_BRIDGE"
	(
		nx_ip_link \
			-i '208' \
			-N 'pods' \
			-o '20' \
			-c '208' \
			-l 'posix'
		nx_ip_s_master
	)
	(
		nx_ip_link \
			-i '176' \
			-N 'qemu' \
			-o '20' \
			-c '176' \
			-l 'posix'
		nx_ip_s_master
	)
)

: << 'EOF'
(
	NEX_k_N='posix'
	eval "$(nx_ip_n_veth -N "$NEX_k_N")"
	NEX_k_d="$G_NEX_NET_VETH"
	nx_tty_print -i "veth: $NEX_k_d -> (ns: nex-$NEX_k_N) peer: $G_NEX_NET_PEER\n"
	nx_ip_s_inet -l 'default-inet4' -v '172.16.128.1/17'
	nx_ip_s_state 'up'
	NEX_k_d="$G_NEX_NET_PEER"
	NEX_k_n="posix"
	nx_ip_s_inet -l "$NEX_k_N-inet4" -v '172.16.128.2/17'
	nx_ip_s_state 'up'
	nx_ip_s_route  '172.16.128.1'
	eval "$(nx_ip_s_bridge -l 'bridge')"
	NEX_k_d="$G_NEX_NET_BRIDGE"
	nx_br="$NEX_k_d"
	nx_tty_print -i "bridge: $NEX_k_d\n"
	nx_ip_s_state 'up'
	eval "$(nx_ip_s_vlan_bridge -I '999' -i '176,192,208,224,240,999')"
	NEX_k_d="$G_NEX_NET_PEER"
	eval "$(nx_ip_s_vlan_bridge -I 't' -i '176,208,999')"
	(
		i=208
		NEX_k_d="$nx_br"
		eval "$(nx_ip_s_bridge -l "bridge.$i")"
		nx_ip_s_state 'up'
		eval "$(nx_ip_s_vlan_bridge -i "$i")"
		nx_ip_s_route  "172.16.$i.1"
		#for i in 176 192 208 224 240; do
		#eval "$(nx_ip_s_vlan_bridge -l 'bridge')"
			#NEX_k_d="$G_NEX_NET_BRIDGE"
			#eval "$(nx_ip_s_vlan_bridge -i "$i")"
			#nx_tty_print -i "bvid: $G_NEX_NET_BVID\n"
			#NEX_k_d="$G_NEX_NET_BVID"
			#NEX_k_m="$NEX_k_d"
			nx_tty_print -i "master: $NEX_k_m\n"
			nx_ip_s_inet -l "vlan$i" -v "172.16.$i.1/20"
			nx_ip_s_state 'up'
			case "$i" in
				176) {
					nx_ip_vlan176
				};;
				208) {
					nx_ip_vlan208
				};;
				*);;
			esac
		#done
	)
	nx_ip_s_state 'up'
)


EOF
