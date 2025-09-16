
nx_str_chain()
{
	while [ "${#@}" -gt 0 ]; do
		printf '%s' "$1"
		[ "${#@}" -gt 1 ] && {
			printf '%s' "<nx:null/>"
		}
		shift
	done
}

nx_str_optarg()
{
	${AWK:-$(nx_cmd_awk)} \
		-v str="$(nx_str_chain "$@")" \
	"
		$(cat \
			"${NEXUS_LIB}/awk/nex-misc.awk" \
			"${NEXUS_LIB}/awk/nex-struct.awk" \
			"${NEXUS_LIB}/awk/nex-log.awk" \
			"${NEXUS_LIB}/awk/nex-json.awk" \
			"${NEXUS_LIB}/awk/nex-str.awk" \
			"${NEXUS_LIB}/awk/nex-shell.awk" \
			"${NEXUS_LIB}/awk/nex-math.awk"
		)
	"'
		BEGIN {
			if (s = nx_str_opts(str))
				print s
			else
				exit 1
		}
	'
}

nx_str_case()
(
	while getopts ult OPT; do
		case $OPT in
			u|l|t) c="$OPT";;
		esac
	done
	shift $((OPTIND - 1))
	${AWK:-$(nx_cmd_awk)} \
		-v inpt="$@" \
		-v strcase="$c" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str.awk")
	"'
		BEGIN {
			if (strcase == "t")
				print nx_totitle(inpt)
			else if (strcase == "u")
				print toupper(inpt)
			else if (strcase == "l")
				print tolower(inpt)
			else
				print inpt
		}
	'
)

nx_str_rand()
{
	${AWK:-$(nx_cmd_awk)} \
		-v num="${1:-8}" \
		-v chars="${2:-alnum}" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str.awk")
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

nx_str_hex()
{
	h_nx_cmd hexdump && {
		nx_str_case -u "$(printf '%s' "$*" | hexdump)" | ${AWK:-$(nx_cmd_awk)} '
			{
				for (i = 2; i <= NF; i++)
					h = h "\\x" substr($i, 3) "\\x" substr($i, 1, 2)
			} END {
				sub("\\\\x00$", "", h)
				print h
			}
		'
	}
}

nx_str_len()
{
	${AWK:-$(nx_cmd_awk)} -v str="$*" 'BEGIN { print length(str) }'
}

nx_str_reverse()
{
	${AWK:-$(nx_cmd_awk)} \
		-v str="$*" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str.awk")
	"'
		BEGIN {
			print nx_reverse_str(str)
		}
	'
}

nx_str_append()
(
	eval "$(nx_str_optarg ':c:n:s:' "$@")"
	${AWK:-$(nx_cmd_awk)} \
		-v str="$s" \
		-v num="${n:-"$1"}" \
		-v char="${c:-"$2"}" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str.awk")
	"'
		BEGIN {
			print nx_append_str(char, num, str)
		}
	'
)

nx_str_path()
{
	${AWK:-$(nx_cmd_awk)} \
		-v str="$*" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-shell.awk")
	"'
		BEGIN {
			if (str = nx_expand_path(str))
				print str
			else
				exit 1
		}
	'
}

