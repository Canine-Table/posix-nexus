#nx_include NEX_L:/sh/nex-bc.sh

__nx_bc_trig()
{

	nx_data_longopt ',
	v<%value>
	<description Angle value to convert or evaluate>
	<default 0>

	dr<@rd raddeg radians-to-degrees degrad degrees-to-radians>
	<description Convert input from degrees or radians to the other>

	help<h>
	<description Show help for nx_bc_trig>
	<build exit;>
	' "$@"

	case "$NEX_GF_dr" in
		rd|raddeg|radians-to-degrees) NEX_Gk_v="nx_rad2deg($NEX_Gk_v)";;
		dr|degrad|degrees-to-radians) NEX_Gk_v="nx_deg2rad($NEX_Gk_v)";;
	esac
	__nx_bc "$@" -c "$NEX_Gk_v" -m 'geometry'
}

nx_bc_trig()
(
	__nx_bc_trig "$@"
)


nx_bc_cos()
(
	nx_data_longopt ',
		v<%value>
		<description Value to evaluate (defaults to $NEX_ARGV_S)>

		f<@inv inverse sec secant>
		<description Select inverse or reciprocal form:
			inv|inverse -\> acos
			sec|secant  -\> sec
			(unset)     -\> cos
		>

		help<h>
		<description Show help for nx_bc_cos>
		<build exit;>
	' "$@"

	# Default value fallback
	NEX_Gk_v="${NEX_Gk_v:-$NEX_ARGV_S}"

	case "$NEX_GF_f" in
		i|inv|inverse) NEX_Gk_v="r_nx_ts_acos($NEX_Gk_v)";;
		s|sec|secant)  NEX_Gk_v="r_nx_ts_sec($NEX_Gk_v)";;
		*)			 NEX_Gk_v="r_nx_ts_cos($NEX_Gk_v)";;
	esac

	nx_err=0
	__nx_bc_trig "$@" -v "$NEX_Gk_v" || nx_err="$?"
	test "$nx_err" -gt 0 && case "$nx_err" in
		230) nx_tty_print -e "acos(z) domain breach — |z| > 1\n";;
	esac

	exit "$nx_err"
)

nx_bc_sin()
(
	nx_data_longopt ',
		v<%value>
		<description Value to evaluate (defaults to $NEX_ARGV_S)>

		f<@inv inverse csc cosecant asin>
		<description Select inverse or reciprocal form:
			asin|inv|inverse  -\> asin
			csc|cosecant      -\> csc
			(unset)           -\> sin
		>

		help<h>
		<description Show help for nx_bc_sin>
		<build exit;>
	' "$@"

	# Default value fallback
	NEX_Gk_v="${NEX_Gk_v:-$NEX_ARGV_S}"

	case "$NEX_GF_f" in
		asin|inv|inverse) NEX_Gk_v="r_nx_ts_asin($NEX_Gk_v)";;
		csc|cosecant) NEX_Gk_v="r_nx_ts_csc($NEX_Gk_v)";;
		*) NEX_Gk_v="r_nx_ts_sin($NEX_Gk_v)";;
	esac

	nx_err=0
	__nx_bc_trig "$@" -v "$NEX_Gk_v" || nx_err="$?"

	test "$nx_err" -gt 0 && case "$nx_err" in
		230) nx_tty_print -e "asin(z) domain breach — |z| > 1\n";;
	esac

	exit "$nx_err"
)

nx_bc_tan()
(
	nx_data_longopt ',
		v<%value>
		<description Value to evaluate (defaults to $NEX_ARGV_S)>

		f<@inv inverse atan cot cotangent>
		<description Select inverse or reciprocal form:
			atan|inv|inverse   -\> atan
			cot|cotangent      -\> cot
			(unset)            -\> tan
		>

		help<h>
		<description Show help for nx_bc_tan>
		<build exit;>
	' "$@"

	# Default value fallback
	NEX_Gk_v="${NEX_Gk_v:-$NEX_ARGV_S}"

	case "$NEX_GF_f" in
		inv|inverse) NEX_Gk_v="r_nx_ts_atan($NEX_Gk_v)";;
		cot|cotangent) NEX_Gk_v="r_nx_ts_cot($NEX_Gk_v)";;
		*) NEX_Gk_v="r_nx_ts_tan($NEX_Gk_v)";;
	esac

	nx_err=0
	__nx_bc_trig "$@" -v "$NEX_Gk_v" || nx_err="$?"

	test "$nx_err" -gt 0 && case "$nx_err" in
		230) nx_tty_print -e "atan(z) domain breach — |z| > 1\n";;
		232) nx_tty_print -e "x == 0 && y == 0 in atan2\n";;
	esac

	exit "$nx_err"
)

