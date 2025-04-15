
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
			#nx_map("this = that, where = who, why = what, hello = world, this = tom, and = jerry, andor = not or", arr, ",", "=")
			#nx_map("hello", arr)
			#for (i = 1; i <= arr[0]; i++) {
			#	print arr[i] " = " arr[arr[i]]
			#}
			#print nx_base_compliment(tmpa, tmpb)
			#nx_vector("hello, world, this is `tom, and, jerry,`, and stuff", arr, ",", 1)
			#for (i = 1; i <= arr[0]; i++) {
			#	print arr[i]
			#}
			#nx_vector("a,b,c,d,e,f,g", abc)
			#nx_pop_vector(abc, "a,b,c,d")
			#print __nx_pad_bits(arr, tmpa, 10)
			print nx_subtract(tmpa, tmpb, tmpc)
		}
	'
}

