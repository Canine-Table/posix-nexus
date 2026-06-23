#nx_include NEX_L:/sh/nex-bc.sh

__nx_bc_cmb()
{
	__nx_bc "$@" -m 'combinatorics'
}


nx_bc_cmb()
(
	__nx_bc_cmb "$@"
)


nx_bc_fact()
(
    nx_data_longopt ',
        v<%value>
        <description Value to evaluate (defaults to $NEX_ARGV_S)>

        help<h>
        <description Show help for nx_bc_fact>
        <build exit;>
    ' "$@"

    NEX_Gk_v="${NEX_Gk_v:-$NEX_ARGV_S}"

    __nx_bc_cmb "$@" -c "nx_fact($NEX_Gk_v)" || {
        nx_tty_print -e 'factorial input < 0 detected!!!\n'
        exit 227
    }
)

nx_bc_ln()
(
    nx_data_longopt ',
        v<%value>
        <description Value to evaluate (defaults to $NEX_ARGV_S)>

        help<h>
        <description Show help for nx_bc_ln>
        <build exit;>
    ' "$@"

    NEX_Gk_v="${NEX_Gk_v:-$NEX_ARGV_S}"

    __nx_bc_cmb "$@" -c "nx_de_ln($NEX_Gk_v)" || {
        nx_tty_print -e 'ln(x) domain breach — x ≤ 0\n'
        exit 227
    }
)

nx_bc_log2()
(
    nx_data_longopt ',
        v<%value>
        <description Value to evaluate (defaults to $NEX_ARGV_S)>

        help<h>
        <description Show help for nx_bc_log2>
        <build exit;>
    ' "$@"

    NEX_Gk_v="${NEX_Gk_v:-$NEX_ARGV_S}"

    __nx_bc "$@" -m 'combinatorics' -c "nx_de_log2($NEX_Gk_v)" || {
        nx_tty_print -e 'log2(x) domain breach — x ≤ 0\n'
        exit 227
    }
)

nx_bc_fib()
(
    nx_data_longopt ',
        v<%value>
        <description Value to evaluate (defaults to $NEX_ARGV_S)>

        help<h>
        <description Show help for nx_bc_fib>
        <build exit;>
    ' "$@"

    NEX_Gk_v="${NEX_Gk_v:-$NEX_ARGV_S}"

    __nx_bc "$@" -m 'combinatorics' -c "nx_fib($NEX_Gk_v)" || {
        nx_tty_print -e 'Fibonacci sequence expects an integral number > 0\n'
        exit 227
    }
)



