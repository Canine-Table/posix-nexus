
__nx_bc()
(
	eval "$(nx_str_optarg ':p:s:o:i:c:m:l' "$@")"
	printf '%s\n' "$(nx_data_include -i "${NEXUS_LIB}/bc/nex-${m-real}.bc")
		${i:+ibase = $i}
		${o:+obase = $o}
		${s:+scale = $s}
		$c
	" | bc ${l:+-l}
)

