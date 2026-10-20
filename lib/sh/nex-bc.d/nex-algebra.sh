#nx_include nex-algebra.d/nex-linear.sh
#nx_include NEX_L:/sh/nex-bc.sh

__nx_bc_alg()
{
	__nx_bc "$@" -m 'algebra'
}

nx_bc_alg()
(
	__nx_bc_alg "$@"
)

nx_bc_pow()
(
    nx_data_longopt ',
        v<%value>
        <description Base value (defaults to $NEX_ARGV_S)>

        p<%power>
        <default 2>
        <description Exponent value>

        help<h>
        <description Show help for nx_bc_pow>
        <build exit;>
    ' "$@"

    __nx_bc_alg "$@" -c "nx_erde_pow("${NEX_Gk_v:-$NEX_ARGV_S}",$NEX_Gk_p)" || {
        nx_tty_print -e 'pow(x, y) domain breach — x ≤ 0\n'
        exit 227
    }
)

nx_bc_sqrt()
(
    nx_data_longopt ',
        v<%value>
        <description Value to square‑root (defaults to $NEX_ARGV_S)>

        help<h>
        <description Show help for nx_bc_sqrt>
        <build exit;>
    ' "$@"

    __nx_bc_alg "$@" -c "nx_nr_sqrt(${NEX_Gk_v:-$NEX_ARGV_S})" || {
        nx_tty_print -e 'sqrt(x) domain breach — x ≤ 0\n'
        exit 227
    }
)


nx_bc_sqs()
(
    nx_data_longopt ',
        v<%value>
        <description Value to square (defaults to $NEX_ARGV_S)>

        help<h>
        <description Show help for nx_bc_sqs>
        <build exit;>
    ' "$@"

    __nx_bc_alg "$@" -c "nx_squares(${NEX_Gk_v:-$NEX_ARGV_S})"
)

nx_bc_lcd()
(
    nx_data_longopt ',
        v<%value>
        <description Pair (x,y) for LCD computation>

        help<h>
        <description Show help for nx_bc_lcd>
        <build exit;>
    ' "$@"

    __nx_bc_alg "$@" -c "nx_lcd(${NEX_Gk_v:-$NEX_ARGV_S})" || {
        nx_tty_print -e 'lcm(x,y) domain breach — x,y must be positive integers\n'
        exit 227
    }
)


nx_bc_gcd() { nx_bc_euc "$@"; }
nx_bc_euc()
(
    nx_data_longopt ',
        v<%value>
        <description Pair (x,y) for Euclidean GCD>

        help<h>
        <description Show help for nx_bc_euc>
        <build exit;>
    ' "$@"

    NEX_Gk_v="${NEX_Gk_v:-$NEX_ARGV_S}"

    __nx_bc_alg "$@" -c "nx_euc($NEX_Gk_v)" || {
        nx_tty_print -e 'euc(x,y) domain breach — x,y must be non‑negative integers\n'
        exit 227
    }
)

nx_bc_binom()
(
	nx_data_longopt -- ',
		v<%value>
		<type str>
		<description Operands n,k for binomial(n,k); n,k non-negative integers with k <= n (defaults to the first positional)>

		help<h>
		<description Show help for nx_bc_binom>
	' "$@"

	__nx_bc_alg "$@" -c "nx_binom(${NEX_Gk_v:-$NEX_ARGV_S})" || {
		nx_tty_print -e 'binomial(n,k) domain breach — n,k must be non‑negative integers with k ≤ n\n'
		exit 226
	}
)

nx_bc_binom()
(
	nx_data_longopt -- ',
		v<%n>
		<type int>
		<description n, the total number of items to choose from>

		k<%k-count>
		<type int>
		<description k, the number of items chosen; must satisfy 0 <= k <= n>

		help<h>
		<description Show help for nx_bc_binom>
	' "$@"

	__nx_bc_alg "$@" -c "nx_binom(${NEX_Gk_v},${NEX_Gk_k})" || {
		nx_tty_print -e 'binomial(n,k) domain breach — n,k must be non‑negative integers with k ≤ n\n'
		exit 226
	}
)

nx_bc_part()
(
	nx_data_longopt -- ',
		v<%value>
		<type float>
		<description Value whose integer part is returned, sign preserved (defaults to the first positional)>

		help<h>
		<description Show help for nx_bc_part>
	' "$@"

	__nx_bc_alg "$@" -c "nx_part(${NEX_Gk_v:-$NEX_ARGV_S})"
)

nx_bc_trunc()
(
	nx_data_longopt -- ',
		v<%value>
		<type float>
		<description Value truncated toward zero, i.e. fractional part dropped (defaults to the first positional)>

		help<h>
		<description Show help for nx_bc_trunc>
	' "$@"

	__nx_bc_alg "$@" -c "nx_pt_trunc(${NEX_Gk_v:-$NEX_ARGV_S})"
)

nx_bc_floor()
(
	nx_data_longopt -- ',
		v<%value>
		<type float>
		<description Value rounded down to the nearest integer (defaults to the first positional)>

		help<h>
		<description Show help for nx_bc_floor>
	' "$@"

	__nx_bc_alg "$@" -c "nx_pt_floor(${NEX_Gk_v:-$NEX_ARGV_S})"
)

nx_bc_ceil()
(
	nx_data_longopt -- ',
		v<%value>
		<type float>
		<description Value rounded up to the nearest integer (defaults to the first positional)>

		help<h>
		<description Show help for nx_bc_ceil>
	' "$@"

	__nx_bc_alg "$@" -c "nx_pt_ceil(${NEX_Gk_v:-$NEX_ARGV_S})"
)

nx_bc_frac()
(
	nx_data_longopt -- ',
		v<%value>
		<type float>
		<description Fractional part of the value, i.e. value minus its integer part (defaults to the first positional)>

		help<h>
		<description Show help for nx_bc_frac>
	' "$@"

	nx_bc_alg "$@" -c "nx_pt_frac(${NEX_Gk_v:-$NEX_ARGV_S})"
)

nx_bc_round()
(
	nx_data_longopt -- ',
		v<%value>
		<type float>
		<description Value rounded to the nearest integer (defaults to the first positional)>

		help<h>
		<description Show help for nx_bc_round>
	' "$@"

	nx_bc_alg "$@" -c "nx_pt_round(${NEX_Gk_v:-$NEX_ARGV_S})"
)

nx_bc_unround()
(
	nx_data_longopt -- ',
		v<%value>
		<type float>
		<description Value with rounding undone, restoring the pre-round form (defaults to the first positional)>

		help<h>
		<description Show help for nx_bc_unround>
	' "$@"

	nx_bc_alg "$@" -c "nx_pt_unround(${NEX_Gk_v:-$NEX_ARGV_S})"
)

nx_bc_mod()
(
	nx_data_longopt -- ',
		v<%value>
		<type str>
		<description Operands a,b for modulo; divisor must be non-zero and both integral (defaults to the first positional)>

		help<h>
		<description Show help for nx_bc_mod>
	' "$@"

	__nx_bc_alg "$@" -c "nx_pt_mod(${NEX_Gk_v:-$NEX_ARGV_S})" || {
		nx_tty_print -e 'modulo(a,b) domain breach — divisor must be non‑zero and both operands integral\n'
		exit 226
	}
)

