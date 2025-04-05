
get_json_parser()
{
	${AWK:-$(get_cmd_awk)} \
		-v inpt="$*" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/data.awk"
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
			#s = "a\\: b, c: d, e: f"
			#s = "aa"
			#vector("tom, is, here \"hello, this, is, world\", this,is, \"tom\"", arr, ",")
			l = nx_vector("tom, is, here \"hello, this, is, world\", this,is, \" tom   \"", arr, ",")
			#l = nx_uniq("a,a,b,c,c,d,e,e,f,f,g", arr, ",")
			#print arr[1]
			for (i = 1; i <= arr[0]; i++) {
				print arr[i]
			}
			#"abcd , drerr"
			#print typeof(s)
			#split("", arr, "")
			#tokenize(s, arr)
			#while (stack(arr, "isempty"))
			#print json_parser("{ abc: [ { x: y }, z ], def: { d: d, e: e, f: f }}")
		}
	'
}

