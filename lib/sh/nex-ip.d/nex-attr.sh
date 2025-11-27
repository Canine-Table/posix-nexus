#nx_include NEX_L:/sh/nex-ip.sh

nx_ip_s_master()
(
	test -n "$(nx_ip_o_ifname "$NEX_k_m")" && NEX_S='' || NEX_S='m:'
	nx_ip_a_ifname "$NEX_S" "$@" || exit 2
	test -n "$(nx_ip_o_ifname "$NEX_k_m")" || exit 2
	$(__nx_ip_x_netns) ip link set "$NEX_k_d" up
	$(__nx_ip_x_netns) ip link set "$NEX_k_d" master "$NEX_k_m"
)

nx_ip_s_state()
(
	nx_ip_a_ifname 'v:m:' "$@" || exit
	NEX_k_v="$(nx_ip_o_state "${NEX_k_v:-$NEX_S}" || printf '%s' 'down')"
	NEX_S="$(test "$NEX_k_v" = 'up' && printf '%d' 1 || printf '%d' 0)"
	$(__nx_ip_x_netns) ip link set "$NEX_k_d" $NEX_k_m  "$NEX_k_v" || $(__nx_ip_x_netns) ip link set "$NEX_k_d" $NEX_k_m  "$NEX_k_v"
)

nx_ip_s_active()
(
	nx_ip_a_ifname 'v:m:' "$@" || exit
	NEX_k_v="$(nx_ip_o_active "${NEX_k_v:-$NEX_S}" || printf '%s' 'off')"
	NEX_S="$(test "$NEX_k_v" = 'on' && printf '%d' 1 || printf '%d' 0)"
	$(__nx_ip_x_netns) ip link set "$NEX_k_d" $NEX_k_m  "$NEX_k_v" || $(__nx_ip_x_netns) ip link set "$NEX_k_d" $NEX_k_m  "$NEX_k_v"
)


nx_ip_s_promisc()
{
	nx_ip_s_active "$@" -m 'promisc'
}

nx_ip_s_arp()
{
	nx_ip_s_active "$@" -m 'arp'
}

nx_ip_s_multicast()
{
	nx_ip_s_active "$@" -m 'multicast'
}

nx_ip_s_allmulticast()
{
	nx_ip_s_active "$@" -m 'allmulticast'
}

nx_ip_s_carrier()
{
	nx_ip_s_active "$@" -m 'carrier'
}

nx_ip_s_dynamic()
{
	nx_ip_s_active "$@" -m 'dynamic'
}

nx_ip_s_group()
(
	nx_ip_a_ifname 'v:' "$@" || exit
	$(__nx_ip_x_netns) ip link set "$NEX_k_d" group "$(nx_int_range -g 0 -v "${NEX_k_v:-$NEX_S}" && printf '%s' "${NEX_k_v:-$NEX_S}" || printf '%s' 'default')"
)

nx_ip_s_txqueuelen()
(
	nx_ip_a_ifname 'v:' "$@" || exit
	NEX_k_v="${NEX_k_v:-$NEX_S}"
	$(__nx_ip_x_netns) ip link set dev "$NEX_k_d" txqueuelen "$(nx_int_range -v "$NEX_k_v" -l 1 -g 4294967295 -e -a "$NEX_k_v" || printf '%d' 1000)"
)

nx_ip_s_lld_gen()
(
	nx_ip_a_ifname 'v:' "$@" || exit
	NEX_k_v="${NEX_k_v:-$NEX_S}"
	$(__nx_ip_x_netns) ip link set dev "$NEX_k_d" addrgenmode "$(nx_ip_o_lld_gen "${NEX_k_v:-$NEX_S}" || printf '%s' 'stable-privacy')"
)

nx_ip_s_mtu()
(
	nx_ip_a_ifname 'v:' "$@" || exit
	NEX_k_v="${NEX_k_v:-$NEX_S}"
	$(__nx_ip_x_netns) ip link set dev "$NEX_k_d" mtu "$(nx_int_range -v "$NEX_k_v" -l 65535 -g 68 -e -a && printf '%d' "$NEX_k_v" || printf '%d' 1500)"
)

