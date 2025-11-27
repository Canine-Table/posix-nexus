#nx_include nex-bc.d/nex-combinatorics.sh
#nx_include nex-bc.d/nex-algebra.sh
#nx_include nex-bc.d/nex-geometry.sh

__nx_bc()
(
        eval "export $(nx_tty_all)"
        export BC_LINE_LENGTH=$NX_TTY_COLUMNS
	nx_data_optargs 's:o:i:c:m:l' "$@"
	printf '%s\n' "
		scale = ${NEX_k_s:-3}
		${NEX_k_o:+obase = $NEX_k_o}
		${NEX_k_i:+ibase = $NEX_k_i}
		$(nx_data_include -i "${NEXUS_LIB}/bc/nex-${NEX_k_m:-algebra}.bc")
		$NEX_k_c
	" | bc ${NEX_f_l:+-l} 2>&1 | ${AWK:-$(nx_cmd_awk)} '
		{
			if (sub(/^<nx:impurity[ \t]*/, "", $0)) {
				gsub(/[^0-9]*/, "", $0)
				if ($0)
					exit $0
				exit 1
			}
			print $0
		}
	'
)
