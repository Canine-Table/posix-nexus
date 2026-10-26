#nx_include nex-data.sh
#nx_include nex-cmd.sh

nx_int_Z()
{
	printf ' %s' $* | sed -E --posix 's/(^0*|[^0-9]*)//g;/^$/{s/$/0/}'
}

nx_int_Q()
{
	printf ' %s' $* | sed -E --posix -f "${NEXUS_LIB}/sed/nex-parse.sed"
}




nx_int_convert()
(
	nx_data_longopt -- ',
		i<%ibase>
		<type int>
		<default 10>
		<min 2>
		<max 64>
		<description Input base (default 10, range 1-64)>

		o<%obase>
		<type int>
		<default 16>
		<min 2>
		<max 64>
		<description Output base (default 16, range 1-64)>

		n<%num>
		<type int>
		<description Number to convert (defaults to the first positional)>

		help<h>
		<description Show help for nx_int_convert>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	test -z "${NEX_Gk_n:="$NEX_ARGV_1"}" && {
		nx_tty_print -e 'nx_int_convert: error - empty input (-n required)'
		exit 226
	}
	${AWK:-$(nx_cmd_awk)} \
		-v ibs="$NEX_Gk_i" \
		-v obs="$NEX_Gk_o" \
		-v num="$NEX_Gk_n" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math-extras.awk")
	"'
		BEGIN {
			print nx_convert_base(num, ibs, obs)
		}
	'
)

nx_int_prime()
(
	nx_data_longopt -- ',
		d<%digits>
		<type int>
		<default 8>
		<min 1>
		<max 8>

		help<h>
		<description Show help for nx_int_prime>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	${AWK:-$(nx_cmd_awk)} \
		-v dit="$NEX_Gk_d" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math-extras.awk")
	"'
		BEGIN {
			print nx_prime(dit)
		}
	'
)

nx_int_modulo()
(
	nx_data_longopt -- ',
		d<%dividend>
		<type int>
		<description Dividend, the number being divided>

		v<%divisor>
		<type int>
		<min 1>
		<description Divisor, the number to divide by (must be non-zero)>

		help<h>
		<description Show help for nx_int_modulo>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	${AWK:-$(nx_cmd_awk)} \
		-v a="$NEX_Gk_d" \
		-v b="$NEX_Gk_v" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math-extras.awk")
	"'
		BEGIN {
			print nx_modulo(a, b)
		}
	'
)

nx_int_divisible()
(
	nx_data_longopt -- ',
		d<%dividend>
		<type real>
		<description Dividend, the number being divided>

		v<%divisor>
		<type real>
		<min 0.0001>
		<description Divisor, the number to divide by (must be non-zero)>

		help<h>
		<description Show help for nx_int_modulo>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	${AWK:-$(nx_cmd_awk)} \
		-v a="$NEX_Gk_d" \
		-v b="$NEX_Gk_v" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math-extras.awk")
	"'
		BEGIN {
			exit nx_divisible(a, b)
		}
	'
)

nx_int_percent()
(
	nx_data_longopt -- ',
		n<%first>
		<type real>
		<description First operand: the percent (default mode) or the whole (--reverse mode)>

		m<%second>
		<type real>
		<description Second operand: the whole (default mode) or the part (--reverse mode)>

		r<R reverse Reverse>
		<type toggle>
		<default <nx:false/\\>>

		<description Reverse mode: compute what percent the second value is of the first>
		help<h>
		<description Show help for nx_int_percent>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	${AWK:-$(nx_cmd_awk)} \
		-v n="$NEX_Gk_n" \
		-v m="$NEX_Gk_m" \
		-v b="$NEX_Gf_r" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math-extras.awk")
	"'
		BEGIN {
			print b
			print nx_percent(n, m, b == "<nx:true/>")
		}
	'
)

nx_int_modulus_range()
(
	nx_data_longopt -- ',
		a<%first>
		<type int>
		<description Dividend (N1)>

		b<%second>
		<type int>
		<min 1>
		<description Divisor (N2); must be non-zero>

		c<%lower>
		<type int>
		<description Optional lower bound (N3); if omitted, plain N1 mod N2>

		d<%offset>
		<type int>
		<description Optional offset (N4) added inside the ranged modulus; ignored if N3 is omitted>

		help<h>
		<description Show help for nx_int_modulus_range>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	${AWK:-$(nx_cmd_awk)} \
		-v n1="$NEX_Gk_a" \
		-v n2="$NEX_Gk_b" \
		-v n3="$NEX_Gk_c" \
		-v n4="$NEX_Gk_d" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math-extras.awk")
	"'
		BEGIN {
			print nx_modulus_range(n1, n2, n3, n4)
		}
	'
)

nx_int_scaled_ratio()
(
	nx_data_longopt -- ',
		n<%first>
		<type real>
		<description First value (N1)>

		m<%second>
		<type real>
		<description Second value (N2)>

		o<%offset>
		<type real>
		<default 0>
		<description Shared offset (N3) subtracted from both values before the ratio (default 0)>

		help<h>
		<description Show help for nx_int_scaled_ratio>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	${AWK:-$(nx_cmd_awk)} \
		-v n1="$NEX_Gk_n" \
		-v n2="$NEX_Gk_m" \
		-v n3="$NEX_Gk_o" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math-extras.awk")
	"'
		BEGIN {
			print nx_scaled_ratio(n1, n2, n3)
		}
	'
)

nx_int_remainder()
(
	nx_data_longopt -- ',
		n<%value>
		<type int>
		<description Value to compute the complement remainder of (N1)>

		m<%modulus>
		<type int>
		<min 1>
		<description Modulus (N2); must be a positive natural number>

		help<h>
		<description Show help for nx_int_remainder>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	${AWK:-$(nx_cmd_awk)} \
		-v n1="$NEX_Gk_n" \
		-v n2="$NEX_Gk_m" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math-extras.awk")
	"'
		BEGIN {
			print nx_remainder(n1, n2)
		}
	'
)

nx_int_modular_exponentiation()
(
	nx_data_longopt -- ',
		b<%base>
		<type int>
		<description Base (N1)>

		e<%exponent>
		<type int>
		<description Exponent (N2); negative exponents return the modular inverse>

		help<h>
		<description Show help for nx_int_modular_exponentiation>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	${AWK:-$(nx_cmd_awk)} \
		-v n1="$NEX_Gk_b" \
		-v n2="$NEX_Gk_e" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math-extras.awk")
	"'
		BEGIN {
			print nx_modular_exponentiation(n1, n2)
		}
	'
)

nx_int_compliment()
(
	nx_data_longopt -- ',
		n<%number>
		<type str>
		<description Number to complement (e.g. 123 in base 10, a3 in base 16)>

		b<%base>
		<type int>
		<min 2>
		<max 64>
		<default 10>
		<description Base of the number (default 10, range 2-64)>

		help<h>
		<description Show help for nx_int_compliment>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	${AWK:-$(nx_cmd_awk)} \
		-v num="$NEX_Gk_n" \
		-v bse="$NEX_Gk_b" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math-extras.awk")
	"'
		BEGIN {
			print nx_compliment(num, bse)
		}
	'
)

nx_int_miller_rabin()
(
	nx_data_longopt -- ',
		n<%number>
		<type int>
		<min 2>
		<description Number to test for primality (>= 2)>

		s<%separator>
		<type char>
		<default ,>
		<description Separator for the witness list (default comma)>

		help<h>
		<description Show help for nx_int_miller_rabin>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	${AWK:-$(nx_cmd_awk)} \
		-v n="$NEX_Gk_n" \
		-v s="$NEX_Gk_s" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math-extras.awk")
	"'
		BEGIN {
			exit !nx_miller_rabin(n, s)
		}
	'
)

nx_int_entropy()
(
	nx_data_longopt -- ',
		n<%digits>
		<type int>
		<min 1>
		<max 8>
		<default 8>
		<description Number of random decimal digits to generate from urandom (default 8)>

		help<h>
		<description Show help for nx_int_entropy>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	${AWK:-$(nx_cmd_awk)} \
		-v n="$NEX_Gk_n" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math-extras.awk")
	"'
		BEGIN {
			print __nx_entropy(n)
		}
	'
)


__nx_int_round_trunc() { tmpa="$tmpa\nif(n=nx_trunc($1))"; tmb="trunc"; }
__nx_int_round_round() { tmpa="$tmpa\nif(n=nx_round($1))"; tmpb="round"; }
__nx_int_round_floor() { tmpa="$tmpa\nif(n=nx_floor($1))"; tmpb="floor"; }
__nx_int_round_ceiling() { tmpa="$tmpa\nif(n=nx_ceiling($1))"; tmpb="ceiling"; }
nx_int_round()
(
	nx_data_longopt -- '
		r<@tfc, trunc round floor ceiling>
		<type str>
		<regex ^(trunc|round|floor|ceiling|t|r|f|c)$>
		<default round>
		<description Default rounding mode: trunc, round, floor, ceiling (or t/r/f/c); default round>

		help<h>
		<description Show help for nx_int_round>
		<build exit;>
	' "$@"

	tmpa=""
	tmpb="$NEX_GF_r"
	case "$tmpb" in
		t) tmpb=trunc;; r) tmpb=round;; f) tmpb=floor;; c) tmpb=ceiling;;
	esac
	i=1
	while test "$i" -le "$NEX_ARGV_0"; do
		__nx_int_round_$tmpb "$(nx_data_ref "NEX_ARGV_$i")"
		tmpa="$tmpa{print n}else{e=-1}"
		i=$((i+1))
	done

	test -n "$tmpa" && ${AWK:-$(nx_cmd_awk)} "
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-int-extras.awk")
	"'
		BEGIN {
			'"$(printf "$tmpa")"'
		}
	'
)


nx_int_range()
(
	nx_data_optargs 'v@g:l:b<oa>e' "$@"
	NEX_K_v="${NEX_K_v:-$NEX_R}"
	${AWK:-$(nx_cmd_awk)} \
		-v lt="${NEX_k_l:-<nx:null/>}" \
		-v gt="${NEX_k_g:-<nx:null/>}" \
		-v bl="$NEX_g_b" \
		-v eql="$NEX_f_e" \
		-v val="$NEX_K_v" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-int-extras.awk")
	"'
		function nx_my_msg(D1, D2) {

				nx_ansi_warning("the passed " D1 " value \x27" D2 "\x27 is not a valid number in base 10, skipping...\n")
		}
		BEGIN {
			if ((val = nx_digit_guard(val, 1, 1, "<nx:null/>", 2, "", arr)) < 0)
				exit val
			if (gt != "<nx:null/>" && (gtv = int(gt)) != gt)
				nx_my_msg("(-g) greater than", gt)
			if (lt != "<nx:null/>" && (ltv = int(lt)) != lt)
				nx_my_msg("(-l) less than", lt)
			do {
				val = int(arr[arr[0]])
				if (val != arr[arr[0]])
					break
				if (eql == "<nx:true/>") {
					if (bl == "a") {
						if (val < gtv || val > ltv)
							break
					} else {
						if (gt != "" && gtv == gt && val < gtv)
							break
						if (lt != "" && ltv == lt && val > ltv)
							break
					}
				} else {
					if (bl == "a") {
						if (val <= gtv || val >= ltv)
							break
					} else {
						if (gt != "<nx:null/>" && gtv == gt && val <= gtv)
							break
						if (lt != "<nx:null/>" && ltv == lt && val >= ltv)
							break
					}
				}
			} while (--arr[0] > 0)
			val = arr[0]
			delete arr
			if (val > 0)
				exit 1
		}
	'
)


