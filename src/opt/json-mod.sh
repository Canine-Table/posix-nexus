
get_json_parser()
{
	${AWK:-$(get_cmd_awk)} \
		-v tmpa="$1" \
		-v tmpb="$2" \
		-v tmpc="$3" "
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
			#z4nx_trim_vector(4, "abc,def, adef", arra)
			#print nx_option("a", arra)
			print nx_random_str(4, "hello, bye, hi")
		}
	'
}

