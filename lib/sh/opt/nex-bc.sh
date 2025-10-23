
__nx_bc()
(
	eval "$(nx_str_optarg ':s:o:i:c:m:l' "$@")"
	printf '%s\n' "$(nx_data_include -i "${NEXUS_LIB}/bc/nex-${m-algebra}.bc")
		${s:+scale = $s}
		${o:+obase = $o}
		${i:+ibase = $i}
		$c
	" | bc ${l:+-l}
)

nx_bc_geo()
{
	__nx_bc -m 'geometry' $@
}

