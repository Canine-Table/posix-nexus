#nx_include NEX_L:/sh/nex-bc.sh

nx_bc_bs()
(
	__nx_bc "$@" -m 'bases'
)

nx_bc_from_dec()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'bases' -c "nx_from_dec(${NEX_k_v:-$NEX_S})" || case "$?" in
		227) {
			nx_tty_print -e 'base cannot be less than 2.\n'
			exit 227
		};;
		228) {
			nx_tty_print -e 'base cannot be greater than obase.\n'
			exit 228
		};;
	esac
)

nx_bc_rvs()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'bases' -c "nx_reverse(${NEX_k_v:-$NEX_S})" || {
		exit 227
	}
)

