#nx_include nex-bc.d/nex-combinatorics.sh
#nx_include nex-bc.d/nex-algebra.sh
#nx_include nex-bc.d/nex-geometry.sh
#nx_include nex-bc.d/nex-bases.sh
#nx_include nex-bc.d/nex-notation.sh
#nx_include nex-bc.d/nex-calculus.sh

__nx_bc()
{

	nx_data_longopt -v 3 -- ',

	s<%scale>
	<description bc scale value>
	<default 20>

	o<%obase>
	<description bc output base>

	i<%ibase>
	<description bc input base>

	c<%code>
	<description bc expression to evaluate>

	m<%module>
	<description bc module to load>
	<default algebra>

	l<%mathlib>
	<description Enable bc -l math library>
	<type toggle>

	q<%quiet>
	<description Suppress output and only set nx_return>
	<type toggle>

	help<h>
	<description Show help>
	<build exit;>

	' "$@"


	nx_tty_all
	export BC_LINE_LENGTH="$G_NEX_TTY_COLUMNS"
	nx_return="$(
		printf '%s' "
			scale = ${NEX_Gk_s}
			${NEX_Gk_i:+ibase = $NEX_Gk_i}
			${NEX_Gk_o:+obase = $NEX_Gk_o}
			$(nx_data_include -i "${NEXUS_LIB}/bc/nex-${NEX_Gk_m}.bc")
			$NEX_Gk_c
		" 
		#| bc ${NEX_Gf_l:+-l} | ${AWK:-$(nx_cmd_awk)} '
		#	{
		#		if (sub(/^<nx:impurity/, "", $0) && sub(/\/>.*$/, "", $0)) {
		#			gsub(/[^0-9]*/, "", $0)
		#			if (($0 = int($0)) && $0 > 227 && $0 < 255)
		#				exit $0
		#			exit 227
		#		}
		#		print $0
		#	}
		#' || exit $?
	)" || return $?
	test "$NEX_Gf_q" = '<nx:true/>' && return
	printf '%s' "$nx_return"
	test "$NEX_Gf_q" = '<nx:false/>' && unset nx_return
	return 0
}

nx_bc()
(
	__nx_bc "$@"
)

