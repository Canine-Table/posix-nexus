nx_convert_base()
{
	${AWK:-$(get_cmd_awk)} \
		-v n1="$1" \
		-v n2="${2:-10}" \
		-v n3="${3:-10}" \
		-v n4="${4:-8}" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk"
		)
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

nx_compliment_base()
{
	${AWK:-$(get_cmd_awk)} \
		-v num="$1" \
		-v ibs="${2:-10}" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk"
		)
	"'
		BEGIN {
			n = nx_compliment(num, ibs)
			if (n != "")
				print n
			else
				exit 1
		}
	'
}

nx_power()
{
	${AWK:-$(get_cmd_awk)} \
		-v n1="$1" \
		-v n2="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk"
		)
	"'
		BEGIN {
			if (n = nx_power(n1, n2, 1, v))
				print n
			else
				exit 1
		}
	'
}

nx_remainder()
{
	${AWK:-$(get_cmd_awk)} \
		-v n1="$1" \
		-v n2="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk"
		)
	"'
		BEGIN {
			
			if ((n = nx_remainder(n1, n2)) != "")
				print n
			else
				exit 1
		}
	'
}

nx_percent()
{
	${AWK:-$(get_cmd_awk)} \
		-v n1="$1" \
		-v n2="$2" \
		-v b1="$3" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk"
		)
	"'
		BEGIN {
			
			if ((n = nx_percent(n1, n2, b1)) != "")
				print n
			else
				exit 1
		}
	'
}

nx_summation()
{
	${AWK:-$(get_cmd_awk)} \
		-v n1="$1" \
		-v n2="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk"
		)
	"'
		BEGIN {
			
			if ((n = nx_summation(n1, n2)) != "")
				print n
			else
				exit 1
		}
	'
}

nx_factoral()
{
	${AWK:-$(get_cmd_awk)} \
		-v n1="$1" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk"
		)
	"'
		BEGIN {
			if ((n = nx_factoral(n1)) != "")
				print n
			else
				exit 1
		}
	'
}

nx_fibonacci()
{
	${AWK:-$(get_cmd_awk)} \
		-v n1="$1" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk"
		)
	"'
		BEGIN {
			if ((n = nx_fibonacci(n1)) != "")
				print n
			else
				exit 1
		}
	'
}

nx_euclidean()
{
	${AWK:-$(get_cmd_awk)} \
		-v n1="$1" \
		-v n2="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk"
		)
	"'
		BEGIN {
			if ((n = nx_euclidean(n1, n2)) != "")
				print n
			else
				exit 1
		}
	'
}

nx_lcd()
{
	${AWK:-$(get_cmd_awk)} \
		-v n1="$1" \
		-v n2="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk"
		)
	"'
		BEGIN {
			if ((n = nx_lcd(n1, n2)) != "")
				print n
			else
				exit 1
		}
	'
}

nx_add()
{
	${AWK:-$(get_cmd_awk)} \
		-v n1="$1" \
		-v n2="$2" \
		-v n3="$3" \
		-v n4="$4" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk"
		)
	"'
		BEGIN {
			if ((n = nx_add(n1, n2, n3, n4)) != "")
				print n
			else
				exit 1
		}
	'
}

nx_subtract()
{
	${AWK:-$(get_cmd_awk)} \
		-v n1="$1" \
		-v n2="$2" \
		-v n3="$3" \
		-v n4="$4" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk"
		)
	"'
		BEGIN {
			if ((n = nx_subtract(n1, n2, n3, n4)) != "")
				print n
			else
				exit 1
		}
	'
}


