
get_json_parser()
{
	${AWK:-$(get_cmd_awk)} \
		-v tmpa="$1" \
		-v tmpb="$2" \
		-v tmpc="$3" \
		-v tmpd="$4" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-algor.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk"
			#"$G_NEX_MOD_LIB/awk/misc.awk" \
			#"$G_NEX_MOD_LIB/awk/str.awk" \
			#"$G_NEX_MOD_LIB/awk/bool.awk" \
			#"$G_NEX_MOD_LIB/awk/algor.awk" \
			#"$G_NEX_MOD_LIB/awk/bases.awk" \
			#"$G_NEX_MOD_LIB/awk/types.awk" \
			#"$G_NEX_MOD_LIB/awk/math.awk" \
			#"$G_NEX_MOD_LIB/awk/json.awk"
	)
	"'
		BEGIN {
			#(startingValue - minimumValue + (offset % modulus) + modulus) % modulus + minimumValue
			#print (tmpa - 10 + (1 % (10 - 5)) + (10 - 5)) % (10 - 5) + 5
			#while (nx_generator(arr, 9, 1, 1, 0, 1))
			#	print arr[0 "_idx"]
			#while (nx_generator(arr, 1, 10, 1, 0, 1))
			#	print arr[0 "_idx"]
			j = 25
			while (--j)
				print nx_generator(arrc, 0, 10, 3, 1)
		}
	'
}

