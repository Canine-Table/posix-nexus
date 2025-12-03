#nx_include NEX_L:/sh/nex-bc.sh

nx_bc_alg()
(
	__nx_bc "$@" -m 'algebra'
)

nx_bc_pow()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'algebra' -c "nx_erde_pow(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'pow(x, y) domain breach — x ≤ 0\n'
		exit 227
	}
)

nx_bc_sqrt()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'algebra' -c "nx_nr_sqrt(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'sqrt(x) domain breach — x ≤ 0\n'
		exit 227
	}
)

nx_bc_lcd()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'algebra' -c "nx_lcd(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'lcm(x,y) domain breach — x,y must be positive integers'
		exit 227
	}
)

nx_bc_gcd() { nx_bc_euc "$@"; }
nx_bc_euc()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'algebra' -c "nx_euc(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'euc(x,y) domain breach — x,y must be non‑negative integers\n'
		exit 227
	}
)

nx_bc_binom()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'algebra' -c "nx_binom(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'binomial(n,k) domain breach — n,k must be non‑negative integers with k ≤ n\n'
		exit 227
	}
)

nx_bc_part()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'algebra' -c "nx_part(${NEX_k_v:-$NEX_S})"
)

nx_bc_trunc()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'algebra' -c "nx_pt_trunc(${NEX_k_v:-$NEX_S})"
)

nx_bc_floor()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'algebra' -c "nx_pt_floor(${NEX_k_v:-$NEX_S})"
)

nx_bc_ceil()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'algebra' -c "nx_pt_ceil(${NEX_k_v:-$NEX_S})"
)

nx_bc_frac()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'algebra' -c "nx_pt_frac(${NEX_k_v:-$NEX_S})"
)

nx_bc_round()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'algebra' -c "nx_pt_round(${NEX_k_v:-$NEX_S})"
)

nx_bc_unround()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'algebra' -c "nx_pt_unround(${NEX_k_v:-$NEX_S})"
)

nx_bc_mod()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'algebra' -c "nx_pt_mod(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'modulo(a,b) domain breach — divisor must be non‑zero and both operands integral\n'
		exit 227
	}
)

