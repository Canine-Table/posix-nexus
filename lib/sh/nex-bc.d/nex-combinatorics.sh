#nx_include NEX_L:/sh/nex-bc.sh

nx_bc_cmb()
(
	__nx_bc "$@" -m 'combinatorics'
)

nx_bc_fact()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'combinatorics' -c "nx_fact(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'factoral input < 0 detected!!!\n'
		exit 2
	}
)

nx_bc_ln()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'combinatorics' -c "nx_de_ln(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'ln(x) domain breach — x ≤ 0\n'
		exit 2
	}
)

nx_bc_log2()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'combinatorics' -c "nx_de_log2(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'log2(x) domain breach — x ≤ 0\n'
		exit 2
	}
)

nx_bc_fib()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'combinatorics' -c "nx_fib(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'Fibonacci sequence expects an integral number > 0\n'
		exit 2
	}
)

