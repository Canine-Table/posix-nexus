. "$(cat "$HOME/.nx/.nx-root" 2> /dev/null)"

test -n "$NEXUS_CNF" || {
	printf 'nex-init needs to loaded before using these tools.\n'
	return 1
}

(
	i="${1:-32}"
	j=0
	while test "$j" -lt "$i"; do
		nx_tty_print -s 'The factoral of ' -c -R -l "$j" -s ' is ' -w "$(nx_bc_fact -v "$j")\n"
		j="$((j + 1))"
	done
)
