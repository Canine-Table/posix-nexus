
get_json_parser()
{
	${AWK:-$(get_cmd_awk)} \
		-v tmpa="$1" \
		-v tmpb="$2" \
		-v tmpc="$3" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-log.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk" \
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
			#print __nx_if(1, "3", "2")
			print nx_option("g", arr, ",", "add,rebt,ici,iud,iuiueiu,iuufiiu,uiuig", 1)
			#print __nx_equality(tmpa, tmpb, tmpc)
			#print nx_cut_str("hello world : cut me", ":", 0)
			#print nx_totitle("hello world : cut me", ":")
		}
	'
}

