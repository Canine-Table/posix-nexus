#nx_include NEX_L:/sh/nex-bc.sh


__nx_bc_lin()
{
	__nx_bc "$@" -m 'algebra.d/nex-linear'
}

nx_bc_lin()
(
	__nx_bc_lin "$@"
)

nx_bc_dist()
(
	nx_data_longopt -- ',
		v<%value>
		<type str>
		<description Coordinates for the distance formula: 2, 4, or 6 values (x1,y1 or x1,y1,x2,y2 or x1,y1,x2,y2,x3,y3); defaults to the first positional>

		help<h>
		<description Show help for nx_bc_dist>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	NEX_Gk_v="${NEX_Gk_v:-$NEX_ARGV_S}"
	case "$(nx_str_cnt "$NEX_Gk_v")" in
		1) NEX_Gk_v="nx_fma_dist1($NEX_Gk_v)";;
		3) NEX_Gk_v="nx_fma_dist2($NEX_Gk_v)";;
		5) NEX_Gk_v="nx_fma_dist3($NEX_Gk_v)";;
		*) {
			nx_tty_print -e 'the distance formula take 2,4 or 6 parameters\n'
			exit 2
		}
	esac
	nx_err='0'
	__nx_bc_lin "$@" -c "$NEX_Gk_v" || nx_err="$?"
	test "$nx_err" -gt 0 && case "$nx_err" in
		*) nx_tty_print -e 'domain breach\n';;
	esac
	exit "$nx_err"
)

