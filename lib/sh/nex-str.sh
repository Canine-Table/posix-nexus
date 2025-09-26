
nx_str_chain()
{
	while [ "$#" -gt 0 ]; do
		printf '%s' "$1"
		[ "$#" -gt 1 ] && {
			printf '%s' "<nx:null/>"
		}
		shift
	done
}

nx_str_look()
(
	eval "$(nx_str_optarg ':e:s:n:b:a:c:r:u' "$@")"
	$c | ${AWK:-$(nx_cmd_awk)} \
		-v bfre="${b:-"<nx:null/>"}" \
		-v aftr="${a:-"<nx:null/>"}" \
		-v utl="$u" \
		-v regx="$r" \
		-v num="$n" \
		-v ed="${e:-"<nx:null/>"}" \
		-v st="${s:-"<nx:null/>"}" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math.awk")
	"'
		{
			if (fnd) {
				if (! _aftr) {
					if ($0 ~ ed)
						_aftr = 1
				} else if (! __nx_is_integral(aftr, 1) || --aftr <= 0) {
					_aftr = 2
					if (utl)
						exit 0
				}
				print $0
				if (_aftr == 2)
					exit 0
			} else if ($0 ~ regx && --num <= 0) {
				if (__nx_is_integral(bfre)) {
					if (st == "<nx:null/>")
						_bfre = 1
					else
						_bfre = 0
					for (bfre = __nx_if(bfre == 0 || +bfre > fld[0], 1, fld[0] - bfre); +bfre <= fld[0]; ++bfre) {
						if (! _bfre && fld[bfre] ~ st) {
							_bfre = 1
							if (utl)
								continue
						}
						if (_bfre)
							print fld[bfre]
					}
				}
				fnd = 1
				if (ed == "<nx:null/>")
					_aftr = 1
				else
					_aftr = 0
				if (utl && ! (_aftr || __nx_is_integral(aftr)))
					exit 0
				print $0
			} else {
				fld[++fld[0]] = $0
			}
		}
	'
)

nx_str_od()
{
	h_nx_cmd od && (
		tmpb="$(nx_str_case -l "$1" | cut -d '-' -f 2)"
		case "$tmpb" in
			d|o|x) shift;;
			*) tmpb="x";;
		esac
		h_nx_cmd wc && tmpc="$(printf '%s' "$@" | wc --bytes)" || tmpc=1024
		test "$G_NEX_ASM_ENDIAN" -eq 1 && tmpa="big" || tmpa="little"
		printf '%s' "$@" | od \
			--endian="$tmpa" \
			--address-radix=none \
			--format="${tmpb}1" \
			--width="$tmpc" | ${AWK:-$(nx_cmd_awk)} -v fmt="$tmpb" \
		'	BEGIN {
				if (fmt == "o")
					esc = "\\0"
				else if (fmt == "x")
					esc = "\\x"
			} {
				for (i = 1; i <= NF; ++i)
					s = s esc $i
			} END {
				print s
			}
		'
	)
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
	tmpb="$(printf '%s' "$1" | tr 'A-Z' 'a-z')"
	case "$tmpb" in
		-u|-l|-t) shift;;
		*) tmpb=''
	esac
	${AWK:-$(nx_cmd_awk)} \
		-v inpt="$@" \
		-v strcase="$tmpb" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str.awk")
	"'
		BEGIN {
			if (strcase == "-t")
				print nx_totitle(inpt)
			else if (strcase == "-u")
				print toupper(inpt)
			else if (strcase == "-l")
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

nx_str_sfld()
(
	eval "$(nx_str_optarg ':n:c:d:' "$@")"
	$c | ${AWK:-$(nx_cmd_awk)} \
		-v num="$n" \
		-v dlm="$d" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math.awk")
	"'
		BEGIN {
			num = __nx_if(__nx_is_integral(num), num, 0)
			if (dlm == "")
				dlm = ".*"
		} {
			s = ""
			for (i = 1; i <= num; ++i)
				s = s dlm $i
			match($0, s)
			s = substr($0, RSTART + RLENGTH)
			gsub(/(^[ \t]+)|([ \t]+$)/, "", s)
			print s
		}
	'
)

