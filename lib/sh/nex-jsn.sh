

nx_jsn_parse()
(
	nx_data_longopt -v 4 ',
		f<%file s stream>
		<
			description json file or stream to parse.
		>
		d<debug>
		<
			description debug level.
		>
	' "$@"
	${AWK:-$(nx_cmd_awk)} \
		-v fl="$NEX_Gk_f" \
		-v vrb="$NEX_Gk_d" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-jsn.awk")
	"'
		BEGIN {
			nx_jsn(fl, js, vrb)
			delete js
		}
	'
)

