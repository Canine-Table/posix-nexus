. "$(cat "$HOME/.nx-root" 2> /dev/null)"

test -n "$NEXUS_CNF" || {
	printf 'nex-init needs to loaded before using these tools.\n'
	return 1
}

test "$(id -u)" -eq 0 || {
	nx_io_printf -E "elevated privileges required!"
	return 2
}

nx_ip_netns 'nexus-pods'
nx_ip_brtun -n 'nexus-pods'

#nx_ip_veth -n 'nexus-pods' -e 'nexus0' -p 'nexus0'


