
get_json_parser()
{
	${AWK:-$(get_cmd_awk)} \
		-v inpt="$*" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/bool.awk" \
			"$G_NEX_MOD_LIB/awk/structs.awk" \
			"$G_NEX_MOD_LIB/awk/algor.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/json.awk"
		)
	"'
		BEGIN {
			print json_parser("  i { abc\\:\\: :gg }")
			#print json_parser("{ abc: [ { x: y }, z ], def: { d: d, e: e, f: f }}")
		}
	'

