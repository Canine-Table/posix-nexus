#nx_include NEX_L:/sh/nex-bc.sh

nx_bc_lin()
(
	__nx_bc "$@" -m 'algebra.d/nex-linear'
)

nx_bc_dist()
(
	nx_data_optargs 'v:' "$@"
	NEX_k_v="${NEX_k_v:-$NEX_S}"
	case "$(nx_str_cnt "$NEX_k_v")" in
		1) NEX_k_v="nx_fma_dist1($NEX_k_v)";;
		3) NEX_k_v="nx_fma_dist2($NEX_k_v)";;
		5) NEX_k_v="nx_fma_dist3($NEX_k_v)";;
		*) {
			nx_tty_print -e 'the distance formula take 2,4 or 6 parameters\n'
			exit 2
		}
	esac
	nx_err='0'
	nx_bc_lin "$@" -c "$NEX_k_v" || nx_err="$?"
	test "$nx_err" -gt 0 && case "$nx_err" in
		*) nx_tty_print -e 'domain breach\n';;
	esac
	exit "$nx_err"
)

