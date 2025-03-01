#!/bin/sh

###:( get ):##################################################################################

get_int_conv()
{
	${AWK:-$(get_cmd_awk)} \
		-v num="$1" \
		-v to="$2" \
		-v from="${3:-10}" \
		-v sn="${4:-0}" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/algor.awk" \
			"$G_NEX_MOD_LIB/awk/bool.awk" \
			"$G_NEX_MOD_LIB/awk/structs.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk"
		)
	"'
		BEGIN {
			if (res = convert_base(num, from, to, sn))
				print res
			else
				exit 1
		}
	'
}

get_int_bsubt()
{
	${AWK:-$(get_cmd_awk)} \
		-v minuend="$1" \
		-v subtrahend="$2" \
		-v from="${3:-10}" \
		-v prec="${4:-10}" \
		-v sn="${5:-0}" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/algor.awk" \
			"$G_NEX_MOD_LIB/awk/bool.awk" \
			"$G_NEX_MOD_LIB/awk/structs.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk"
		)
	"'
		BEGIN {
			if (difference = subtract_base(minuend, subtrahend, from, prec))
				print difference
			else
				exit 1
		}
	'
}

get_int_badd()
{
	${AWK:-$(get_cmd_awk)} \
		-v addend1="$1" \
		-v addend2="$2" \
		-v from="${3:-10}" \
		-v prec="${4:-10}" \
		-v sn="${5:-0}" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/algor.awk" \
			"$G_NEX_MOD_LIB/awk/bool.awk" \
			"$G_NEX_MOD_LIB/awk/structs.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk"
		)
	"'
		BEGIN {
			if (sum = add_base(addend1, addend2, from, prec, sn))
				print sum
			else
				exit 1
		}
	'
}

get_int_comp()
{
	${AWK:-$(get_cmd_awk)} \
		-v num="$1" \
		-v base="${2:-10}" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/algor.awk" \
			"$G_NEX_MOD_LIB/awk/bool.awk" \
			"$G_NEX_MOD_LIB/awk/structs.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk"
		)
	"'
		BEGIN {
			if (res = compliment(num, base))
				print res
			else
				exit 1
		}
	'
}

get_int_abs()
{
	${AWK:-$(get_cmd_awk)} \
		-v num="$1" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk"
		)
	"'
		BEGIN {
			if (is_digit(num, 1))
				print absolute(num)
			exit 1
		}
	'
}

get_int_fact()
{
	${AWK:-$(get_cmd_awk)} \
		-v num="$1" \
		-v prnt="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk"
		)
	"'
		BEGIN {
			if (prnt)
				prnt = 1
			if (is_integral(num))
				print factoral(num, prnt)
			exit 1
		}
	'
}

get_int_fib()
{
	${AWK:-$(get_cmd_awk)} \
		-v num="$1" \
		-v prnt="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk"
		)
	"'
		BEGIN {
			if (prnt)
				prnt = 1
			if (is_integral(num))
				print fibonacci(num, prnt)
			exit 1
		}
	'
}

get_int_round()
{
	${AWK:-$(get_cmd_awk)} \
		-v num="$1" \
		-v rnd="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/algor.awk" \
			"$G_NEX_MOD_LIB/awk/bool.awk" \
			"$G_NEX_MOD_LIB/awk/structs.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk"
		)
	"'
		BEGIN {
			if (! is_digit(num, 1))
				exit 1
			if (rnd = match_option(rnd, "ceiling, round")) {
				if (rnd == "round")
					return round(num)
				else
					return ceiling(num)
			}
			return int(num)
		}
	'
}

get_int_gcd()
{
	${AWK:-$(get_cmd_awk)} \
		-v num1="$1" \
		-v num2="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk"
		)
	"'
		BEGIN {
			if (res = euclidean(num1, num2))
				print res
			else
				exit 1
		}
	'
}

get_int_remainder()
{
	${AWK:-$(get_cmd_awk)} \
		-v num1="$1" \
		-v num2="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk"
		)
	"'
		BEGIN {
			if (is_digit(num1) && is_digit(num2))
				print remainder(num1, num2)
			else
				exit 1
		}
	'
}

get_int_lcd()
{
	${AWK:-$(get_cmd_awk)} \
		-v num1="$1" \
		-v num2="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk"
		)
	"'
		BEGIN {
			if (res = lcd(num1, num2))
				print res
			else
				exit 1
		}
	'
}

get_int_tau()
{
	${AWK:-$(get_cmd_awk)} \
		-v num="$1" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk"
		)
	"'
		BEGIN {
			if (is_integral(num))
				print tau(num)
			else
				print tau()
		}
	'
}

get_int_pi()
{
	${AWK:-$(get_cmd_awk)} \
		-v num="$1" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk"
		)
	"'
		BEGIN {
			if (is_integral(num))
				print pi(num)
			else
				print pi()
		}
	'
}

get_int_distribute()
{
	${AWK:-$(get_cmd_awk)} \
		-v num1="$1" \
		-v num2="$2" \
		-v num3="$3" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk"
		)
	"'
		BEGIN {
			if (is_digit(num1) && is_digit(num2) && is_digit(num3))
				print distribution(num1, num2, num3)
			else
				exit 1
		}
	'
}

get_int_range()
{
	${AWK:-$(get_cmd_awk)} \
		-v num1="$1" \
		-v num2="$2" \
		-v num3="$3" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk"
		)
	"'
		BEGIN {
			if (is_digit(num1) && is_digit(num2) && is_digit(num3))
				print modulus_range(num1, num2, num3)
			else
				exit 1
		}
	'
}

