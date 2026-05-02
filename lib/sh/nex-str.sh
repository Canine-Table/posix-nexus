

nx_str_od()
(
	nx_asm_export
	h_nx_cmd od || {
		nx_tty_print -e 'o no od was not found'
		exit 127
	}
	test "$NEX_k_s" = '<nx:blank/>' && NEX_k_s='' || NEX_k_s="${NEX_k_s:- }"
	nx_data_optargs 'd<ox>s:' "$@"
	test "$G_NEX_ASM_ENDIAN" -eq 1 && G_NEX_ASM_ENDIAN="big" || G_NEX_ASM_ENDIAN="little"
	NEX_g_d="${NEX_g_d:-x}"
	${AWK:-$(nx_cmd_awk)} \
		-v dlm="$NEX_k_s" \
		-v args="$(printf '%s' "$NEX_R" | od --endian="$G_NEX_ASM_ENDIAN" --address-radix=none --format="${NEX_g_d}1")" \
		-v cnv="$NEX_g_d" \
	'
		BEGIN {
			if (cnv == "x")
				gsub(/ /, "\\x", args)
			else
				gsub(/ /, "\\0", args)
			gsub(/\n/, "", args)
			if (cnv == "x")
				gsub(/\\x3c\\x6e\\x78\\x3a\\x6e\\x75\\x6c\\x6c\\x2f\\x3e/, dlm, args)
			else
				gsub(/\\0074\\0156\\0170\\0072\\0156\\0165\\0154\\0154\\0057\\0076/, dlm, args)
			printf("%s", args)
		}
	'
)

nx_str_join()
{
	printf '%s' "$1" | ${AWK:-$(nx_cmd_awk)} -v dlm="$2" 'NR==1{printf("%s",$0); next}{printf("%s",dlm $0)}'
}

nx_str_cnt()
(
	nx_data_optargs 'd:' "$@"
	${AWK:-$(nx_cmd_awk)} \
		-v dlm="${NEX_k_d:-,}" \
		-v str="$NEX_S" \
		'BEGIN {print gsub(dlm, "\\\&", str)}'
)

nx_str_chain()
{
	printf '%s' "$1"
	shift
	while test "$#" -gt 0; do
		printf '%s' "<nx:null/>$1"
		shift
	done
}

nx_str_timestamp()
{
	while test "$#" -gt 0; do
		case "$1" in
			-a) date +"%Y-%m-%d %H:%M:%S %Z (%A)";;
			-n) date +"%Y-%m-%d %H:%M:%S.%N";;
			-u) date +"%Y-%m-%dT%H:%M:%SZ";;
			-l) date +"%Y-%m-%dT%H:%M:%S%z";;
			-s) date +"%b %d %H:%M:%S";;
			-e) date +"%s";;
			-f) date +"%Y%m%d_%H%M%S";;
			-w) date +"%a_%Y%m%d_%H%M";;
			-z) date +"%Y-%m-%d %H:%M:%S %Z";;
		esac
		shift
	done
}

nx_str_case()
(
	nx_data_optargs 'c<ult>v:' "$@"
	${AWK:-$(nx_cmd_awk)} \
		-v cse="$NEX_g_c" \
		-v str="${NEX_k_v:-$NEX_S}" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str-extras.awk")
	"'
		BEGIN {
			if (cse == "t")
				printf("%s", nx_str_totitle(str))
			else if (cse == "u")
				printf("%s", toupper(str))
			else
				printf("%s", tolower(str))
		}
	'
)

nx_str_rand()
{
	${AWK:-$(nx_cmd_awk)} \
		-v num="${1:-8}" \
		-v chars="${2:-alnum}" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str-extras.awk")
	"'
		BEGIN {
			num __nx_if(__nx_is_integral(num), num, 8)
			if (val = nx_random_str(num, chars))
				print val
			else
				exit 1
		}
	'
}

nx_str_append()
{
	${AWK:-$(nx_cmd_awk)} \
		-v cnt="$1" \
		-v cr="$2" \
	"
			$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str.awk")
	"'
		BEGIN {
			print nx_append_str(cr, cnt)
		}
	'
}

