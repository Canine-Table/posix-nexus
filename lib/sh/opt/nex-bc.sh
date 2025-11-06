
__nx_bc()
(
	eval "export $(nx_tty_all)"
	export BC_LINE_LENGTH=$NX_TTY_COLUMNS
	eval "$(nx_str_optarg ':s:o:i:c:m:l' "$@")"
	printf '%s\n' "
		${s:+scale = $s}
		${o:+obase = $o}
		${i:+ibase = $i}
	        $(nx_data_include -i "${NEXUS_LIB}/bc/nex-${m-algebra}.bc")
		$c
	" | bc ${l:+-l}
)

nx_bc_geo()
{
	__nx_bc -m 'geometry' $@
}


nx_bc_base()
{
	__nx_bc -m 'bases' $@
}
