#nx_include NEX_L:/sh/nex-bc.sh

nx_bc_calc()
(
	__nx_bc "$@" -m 'calculus'
)

nx_bc_mc_esp()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_calc "$@" -c "nx_mc_esp(${NEX_k_v:-$NEX_S})"
)

nx_bc_ts()
(
	nx_data_optargs 'v:f' "$@"
	NEX_k_v="${NEX_k_v:-$NEX_S}"
	case "$NEX_f_f" in
		'<nx:true/>') NEX_k_v="nx_ts_alt($NEX_k_v)";;
		*) NEX_k_v="nx_ts($NEX_k_v)";;
	esac
	nx_bc_calc "$@" -c "$NEX_k_v"
)

