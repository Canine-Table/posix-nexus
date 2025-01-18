
###:( get ):##################################################################################

get_int_convert() {
	$(get_cmd_awk) \
		-v num="$1" \
		-v from="$2" \
		-v to="$3" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk"
		)
	"'
		BEGIN {
			print convert_base(num, from, to)
		}
	'
}

get_int_pi() {
	$(get_cmd_awk) \
		-v prec="$1" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/pi.awk"
		)
	"'
		BEGIN {
			printf("%s\n", pi(prec))
		}
	'
}

get_int_round() {
	$(get_cmd_awk) \
		-v num="$1" \
		-v typ="$2" "
		$(
			cat "$G_NEX_MOD_LIB/awk/math.awk"
		)
	"'
		BEGIN {
			if (type == "floor")
				printf("%s\n", floor(num))
			else if (type == "ceiling")
				printf("%s\n", ceiling(num))
			else
				printf("%s\n", round(num))
		}
	'
}

get_int_absolute() {
	$(get_cmd_awk) \
		-v num="$1" "
		$(
			cat "$G_NEX_MOD_LIB/awk/math.awk"
		)
	"'
		BEGIN {
			printf("%s\n", absolute(num))
		}
	'
}


get_int_range() {
	$(get_cmd_awk) \
		-v num="$1" \
		-v gtr="$2" \
		-v lst="$3" "
		$(
			cat "$G_NEX_MOD_LIB/awk/math.awk"
		)
	"'
		BEGIN {
			if (val = range(num, gtr, lst))
				printf("%s\n", val)
			else
				exit 8
		}
	'

}

###:( set ):##################################################################################
###:( new ):##################################################################################
###:( add ):##################################################################################

###:( set ):##################################################################################
###:( new ):##################################################################################
###:( add ):##################################################################################
###:( del ):##################################################################################
###:( is ):###################################################################################
##############################################################################################

