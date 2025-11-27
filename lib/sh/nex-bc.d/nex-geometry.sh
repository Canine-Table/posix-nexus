#nx_include NEX_L:/sh/nex-bc.sh

nx_bc_geo()
(
	__nx_bc "$@" -m 'geometry'
)

nx_bc_pi()
(
	nx_data_optargs 'v:t' "$@"
	case "$(nx_data_match -o ramanujan -o rj -o leibniz -o lz "$NEX_k_v")" in
		ramanujan|rj) NEX_k_v='rj';;
		leibniz|lz) NEX_k_v='lz';;
		*) NEX_k_v='agm';;
	esac
	__nx_bc "$@" -m 'geometry' -c "nx_${NEX_k_v}_$(test "$NEX_f_t" = '<nx:true/>' && printf '%s' 'tau' || printf '%s' 'pi')()"
)

nx_bc_agm()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'geometry' -c "nx_agm(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'agm(a,b) domain breach — inputs must be strictly positive reals'
		exit 2
	}
)

