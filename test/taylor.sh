. "$(cat "$HOME/.nx/.nx-root" 2> /dev/null)"

test -n "$NEXUS_CNF" || {
	printf 'nex-init needs to loaded before using these tools.\n'
	return 1
}

(
	# i	initial
	# s	skip
	# b	begin
	# n	number
	# c	count
	# a	alt<t/f>
	#nx_data_optargs 'i:s:b:n:c:a' "$@"
	i=32
	#nx_int_range -g 0 -v "$NEX_k_n" || NEX_k_n=24
	#nx_int_range -v "$NEX_k_i" || NEX_k_i=2
	#nx_int_range -g 0 -v "$NEX_k_c" || NEX_k_c=32
	#nx_int_range -g 0 -v "$NEX_k_s" || NEX_k_s=2
	#nx_int_range -g 0 -v "$NEX_k_b" || NEX_k_b=2

	NEX_k_n=64
	NEX_k_i=1
	NEX_k_c=64
	NEX_k_s=2
	NEX_k_b=2
	while test "$i" -lt "$NEX_k_n"; do
		nx_tty_print -s 'The Taylor series for ' \
			-c -R \
			-l "$i" \
			-s ' starting at ' \
			-l "$NEX_k_b" \
			-s ' and going up by ' \
			-l "$NEX_k_s" \
			-s ' with the inital value of ' \
			-l "$NEX_k_i" \
			-s ' is ' \
			-l "$(nx_bc_ts -s 8 -v "$i,$NEX_k_b,$NEX_k_s,$NEX_k_i")" \
			-d ".\n"
		i="$((i + 1))"
		#	-l "$j" -s ' is ' 
		#nx_tty_print -i 'The alternating Taylor series for $k of ' -c -R -l "$j" -s ' is ' -w "$(nx_bc_ts -f -v "$k,$j")\n"
		#j="$((j + 1))"
	done
)
