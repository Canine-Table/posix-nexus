#nx_include NEX_S:/nex-ip.sh

nx_ip_s_phy_bond()
(
	__nx_ip_a_netns 'B:' "$@"
	NEX_k_B="$(nx_ip_c_name -v "${NEX_k_B:-bond}")"
	nx_ip_n_dev -t 'bond' -l "$NEX_k_B"
	for tmpa in $(nx_ip_g_phy); do
		nx_ip_s_state -d "$tmpa" 'down'
		nx_ip_s_dev -d "$tmpa" master "$NEX_k_B"
		nx_ip_s_state -d "$tmpa" 'up'
	done
	for tmpa in $(nx_ip_g_phy -w); do
		nx_ip_s_state -d "$tmpa" 'down'
		nx_ip_s_dev -d "$tmpa" master "$NEX_k_B"
		nx_ip_s_state -d "$tmpa" 'up'
	done
)

