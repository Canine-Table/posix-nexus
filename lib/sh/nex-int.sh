#nx_include nex-data.sh
#nx_include nex-cmd.sh

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
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-int.awk")
	"'
		BEGIN {
			'"$(printf "$tmpa")"'
		}
	'
)

nx_int_convert()
(
	nx_data_optargs 'i:o:n:' "$@"
	nx_int_range -l 64 -a -g 1 -v "$NEX_k_i" || NEX_k_i=10
	nx_int_range -l 64 -a -g 1 -v "$NEX_k_o" || NEX_k_o=16
	test -z "$NEX_k_n" && NEX_k_n="$NEX_R"
	nx_int_range -o -v "$NEX_k_n" || exit 2
	test -z "$NEX_k_n" && {
		nx_tty_print -e 'nx_int_convert: error — empty input (-n required)'
		exit 24
	}
	${AWK:-$(nx_cmd_awk)} \
		-v ibs="${NEX_k_i:-10}" \
		-v obs="${NEX_k_o:-16}" \
		-v num="$NEX_k_n" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math-extras.awk")
	"'
		BEGIN {
			print nx_convert_base(num, ibs, obs)
		}
	'
)

