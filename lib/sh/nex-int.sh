
nx_int_natural()
{
	${AWK:-$(nx_cmd_awk)} \
		-v num="$1" \
		'BEGIN { if (num ~ /^[1-9]+[0-9]*$/) {print num} else {exit 1} }'
}

nx_int_digit()
(
	eval "$(nx_str_optarg ':n:s:t:b' "$@")"
	${AWK:-$(nx_cmd_awk)} \
		-v bl="$b" \
		-v tp="$t" \
		-v sep="$s" \
		-v nums="$n" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math.awk")
	"'
		BEGIN {
			bl = bl == "<nx:true/>"
			if (nx_digit_guard(nums, bl, tp, sep) == -1)
				exit -1
		}
	'
)


__nx_int_round_trunc() { tmpa="$tmpa\nif(n=nx_trunc($1))"; tmb="trunc"; }
__nx_int_round_round() { tmpa="$tmpa\nif(n=nx_round($1))"; tmpb="round"; }
__nx_int_round_floor() { tmpa="$tmpa\nif(n=nx_floor($1))"; tmpb="floor"; }
__nx_int_round_ceiling() { tmpa="$tmpa\nif(n=nx_ceiling($1))"; tmpb="ceiling"; }
nx_int_round()
(
	tmpa=""
	tmpb="round"
	while test "$#" -gt 0; do
		case "$1" in
			-t) __nx_int_round_trunc "$2"; shift;;
			-r) __nx_int_round_round "$2"; shift;;
			-c) __nx_int_round_ceiling "$2"; shift;;
			-f) __nx_int_round_floor "$2"; shift;;
			*) __nx_int_round_$tmpb "$1";;
		esac
		tmpa="$tmpa{print n}else{e=-1}"
		shift
	done
	test -n "$tmpa" && ${AWK:-$(nx_cmd_awk)} "
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math.awk")
	"'
		BEGIN {
			'"$(printf "$tmpa")"'
			if (e == -1)
				exit -1
		}
	'
)

