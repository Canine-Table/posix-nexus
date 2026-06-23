#nx_include nex-geometry.d/nex-trigonometry.sh
#nx_include NEX_L:/sh/nex-bc.sh

nx_bc_geo()
(
	__nx_bc "$@" -m 'geometry'
)

nx_bc_pi()
(
	nx_data_longopt --export ',
	v<@ramanujan rj leibniz lz agm>
	<description Algorithm to compute π [ramanujan|rj|leibniz|lz|agm]>
	<lazy>
	<default agm>

	t<tau>
	<type toggle>
	<description Compute τ instead of π>

	help<h>
	<description Show help for nx_bc_pi>
	<build exit;>
	' "$@"

	# normalize algorithm names
	case "$NEX_GF_v" in
		ramanujan|rj) {
			NEX_GF_v='rj'
		};;

		*) {
			NEX_GF_v='agm'
		};;
	esac

	__nx_bc "$@" \
		-m 'geometry' \
		-c "nx_${NEX_GF_v}_$(test "$NEX_Gf_t" = '<nx:true/>' && printf '%s' 'tau' || printf '%s' 'pi')()"
)

