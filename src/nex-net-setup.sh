. "$(cat "$HOME/.nx/.nx-root" 2> /dev/null)"

test -n "$NEXUS_CNF" || {
	printf 'nex-init needs to loaded before using these tools.\n'
	return 1
}

test "$(id -u)" -eq 0 || {
	nx_tty_print -E "elevated privileges required!"
	return 2
}

nx_ip_s_phy
. "$NEXUS_CNF/batch/nex-ns.sh"


