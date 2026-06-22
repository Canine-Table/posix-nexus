#nx_include NEX_L:/sh/nex-bc.sh

nx_bc_ntn()
(
	__nx_bc "$@" -m 'notation'
)

nx_bc_sci()
(
	nx_data_longopt -u -- ',

	v<%value>
	<description Value to convert to scientific notation>

	n<@e E default>
	<regex ^(e|E|default)$>
	<description Scientific notation mode [e|E|default]>

	help<h>
	<description Show help>
	<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	case "$NEX_GF_n" in
		E) NEX_GF_n=2;;
		e) NEX_GF_n=1;;
		*) NEX_GF_n=0;;
	esac

	nx_bc_ntn -c "nx_ntn_sci(${NEX_Gk_v:-$NEX_ARGV_S},$NEX_GF_n)" || {
		nx_tty_print -e 'scientific notation not defined for 0\n'
		exit 227
	}
)

