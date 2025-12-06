#nx_include NEX_L:/sh/nex-bc.sh

nx_bc_ntn()
(
	__nx_bc "$@" -m 'notation'
)

nx_bc_sci()
(
	nx_data_optargs 'v:n<eE>' "$@"
	case "$NEX_g_n" in
		E) NEX_g_n=2;;
		e) NEX_g_n=1;;
		*) NEX_g_n=0;;
	esac
	nx_bc_ntn -c "nx_ntn_sci(${NEX_k_v:-$NEX_S},$NEX_g_n)" || {
		nx_tty_print -e 'scientific notation not defined for 0\n'
		exit 227
	}
)

