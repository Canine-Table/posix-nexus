nx_math_convert_base()
{
	${AWK:-$(nx_cmd_awk)} \
		-v n1="$1" \
		-v n2="${2:-10}" \
		-v n3="${3:-10}" \
		-v n4="${4:-8}" \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-math.awk")
	"'
		BEGIN {
			n = nx_convert_base(n1, n2, n3, n4)
			if (n != "")
				print n
			else
				exit 1
		}
	'
}

nx_math_compliment_base()
{
	${AWK:-$(nx_cmd_awk)} \
		-v n="$1" \
		-v b="${2:-10}" \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-math.awk")
	"'
		BEGIN {
			
			if ((n = nx_compliment(n, b)) != "")
				print n
			else
				exit 1
		}
	'
}

nx_math_power()
{
	${AWK:-$(nx_cmd_awk)} \
		-v n1="$1" \
		-v n2="$2" \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-math.awk")
	"'
		BEGIN {
			if (n = nx_modular_exponentiation(n1, n2, 1, v)
				print n
			else
				exit 1
		}
	'
}

nx_math_sqrt()
{
	${AWK:-$(nx_cmd_awk)} \
		-v n="$1" \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-math.awk")
	"'
		BEGIN {
			print nx_square_root(n)
			if (n = nx_square_root(n))
				print n
			else
				exit 1
		}
	'
}

nx_math_remainder()
{
	${AWK:-$(nx_cmd_awk)} \
		-v n1="$1" \
		-v n2="$2" \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-math.awk")
	"'
		BEGIN {
			
			if ((n = nx_remainder(n1, n2)) != "")
				print n
			else
				exit 1
		}
	'
}

nx_math_percent()
{
	${AWK:-$(nx_cmd_awk)} \
		-v n1="$1" \
		-v n2="$2" \
		-v b1="$3" \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-math.awk")
	"'
		BEGIN {
			
			if ((n = nx_percent(n1, n2, b1)) != "")
				print n
			else
				exit 1
		}
	'
}

nx_math_summation()
{
	${AWK:-$(nx_cmd_awk)} \
		-v n1="$1" \
		-v n2="$2" \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-math.awk")
	"'
		BEGIN {
			
			if ((n = nx_summation(n1, n2)) != "")
				print n
			else
				exit 1
		}
	'
}

nx_math_factoral()
{
	${AWK:-$(nx_cmd_awk)} \
		-v n1="$1" \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-math.awk")
	"'
		BEGIN {
			if ((n = nx_factoral(n1)) != "")
				print n
			else
				exit 1
		}
	'
}

nx_math_fibonacci()
{
	${AWK:-$(nx_cmd_awk)} \
		-v n1="$1" \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-math.awk")
	"'
		BEGIN {
			if ((n = nx_fibonacci(n1)) != "")
				print n
			else
				exit 1
		}
	'
}

nx_math_euclidean()
{
	${AWK:-$(nx_cmd_awk)} \
		-v n1="$1" \
		-v n2="$2" \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-math.awk")
	"'
		BEGIN {
			if ((n = nx_euclidean(n1, n2)) != "")
				print n
			else
				exit 1
		}
	'
}

nx_math_lcd()
{
	${AWK:-$(nx_cmd_awk)} \
		-v n1="$1" \
		-v n2="$2" \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-math.awk")
	"'
		BEGIN {
			if ((n = nx_lcd(n1, n2)) != "")
				print n
			else
				exit 1
		}
	'
}
nx_math_modulo()
{
	${AWK:-$(nx_cmd_awk)} \
		-v num="$1" \
		-v mod="$2" \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-math.awk")
	"'
		BEGIN {
		if ((num = nx_modulo(num, mod)) != "")
				print num
			else
				exit 1
		}
	'
}

nx_math_round()
{
	(
		case $1 in
			-f|-c|-r|-t)
				{
					m="$1"
					shift
				};;
		esac
		${AWK:-$(nx_cmd_awk)} \
			-v num="$1" \
			-v meh="$m" \
		"
			$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-math.awk")
		"'
			BEGIN {
				if (! (num = nx_digit(num, 1)))
					exit 1
				if (! meh)
					print int(num)
				if (meh == "-t")
					print nx_trunc(num)
				if (meh == "-f")
					print nx_floor(num)
				if (meh == "-r")
					print nx_round(num)
				if (meh == "-c")
					print nx_ceiling(num)
			}
		'
	)
}

