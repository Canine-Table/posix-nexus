#nx_include nex-bc.d/nex-combinatorics.sh
#nx_include nex-bc.d/nex-algebra.sh
#nx_include nex-bc.d/nex-geometry.sh
#nx_include nex-bc.d/nex-bases.sh
#nx_include nex-bc.d/nex-calculus.sh

__nx_bc()
{
	nx_return="$(
		eval "export $(nx_tty_all)"
		export BC_LINE_LENGTH=$NX_TTY_COLUMNS
		nx_data_optargs 's:o:i:c:m:l' "$@"
		printf '%s' "
			scale = ${NEX_k_s:-3}
			${NEX_k_o:+obase = $NEX_k_o}
			${NEX_k_i:+ibase = $NEX_k_i}
			$(nx_data_include -i "${NEXUS_LIB}/bc/nex-${NEX_k_m:-algebra}.bc")
			$NEX_k_c
		" | bc ${NEX_f_l:+-l} | ${AWK:-$(nx_cmd_awk)} '
			{
				if (sub(/^<nx:impurity/, "", $0) && sub(/\/>.*$/, "", $0)) {
					gsub(/[^0-9]*/, "", $0)
					if ($0 != "")
						exit $0
					exit 227
				}
				print $0
			}
		' || exit $?
	)" || return $?
	test "$NEX_f_q" = '<nx:true/>' && return
	printf '%s' "$nx_return"
}

