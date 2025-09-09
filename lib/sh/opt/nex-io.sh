
nx_io_fifo_mgr()
{
	h_nx_cmd mkfifo || {
		nx_io_printf -W "mkfifo not found! The realm of named pipes is closed to us." 1>&2
		return 1
	}
	while test "${#@}" -gt 0; do
		if test "$1" = '-r' -a -p "$2"; then
			rm "$2"
			shift 2
		elif test "$1" = '-c'; then
			tmpa=""
			while test -z "$tmpa"; do
				tmpa="$NEXUS_ENV/nx_$(nx_str_rand 32).fifo"
				test -e "$tmpa" && unset tmpa
			done
			mkfifo "$tmpa"
			printf '%s\n' "$tmpa"
		fi
		shift
	done
}


nx_io_parent()
(
	test -n "$1" && {
		tmpa="${2:-/}"
		tmpb="$(printf '%s' "$1" | sed 's/\/*$//g')"
		if test "$tmpb" != "${tmpb%/*}"; then
			tmpa="$(printf '%s' "$tmpa${tmpb%/*}" | sed 's/\/\//\//g')"
			tmpb="${tmpb##*/}"
		fi
		mkdir -p "$tmpa"
		test -f "$tmpa/$tmpb" -a -r "$tmpa/$tmpb" || touch "$tmpa/$tmpb"
		printf '%s\n' "$tmpa/$tmpb"
	}
)

nx_io_type()
{
	tmpa="$(${AWK:-$(nx_cmd_awk)} \
		-v str="$(nx_str_chain "$@")" \
	"
		$(nx_data_include -i "$NEXUS_LIB/awk/nex-shell.awk")
	"'
		BEGIN {
			if (s = nx_file_type(str))
				printf("%s\n", s)
			else
				exit 2
		}
	')"
	printf '%s' "$tmpa"
}

nx_io_printf()
(
	while getopts :f:F:lLbBsSwWeEdDaAiI OPT; do
		case $OPT in
			l|L|b|B|s|S|w|W|e|E|d|D|a|A|i|I) v="$v$OPT";;
			f|F) f="$OPTARG";;
		esac
	done
	shift $((OPTIND - 1))
	${AWK:-$(nx_cmd_awk)} \
		-v fmt="$f" \
		-v vrnt="$v" \
		-v str="$(nx_str_chain "$@")" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-log.awk")
	"'
		BEGIN {
			if (vrnt) {
				if ((l1 = split(vrnt, arrv, "")) && (l2 = split(str, arra, "<nx:null/>"))) {
					if (l1 > l2)
						l1 = l2
					for (l2 = 1; l2 <= l1; l2++) {
						v = tolower(arrv[l2])
						arrv[l2] = (arrv[l2] == v)
						if (v == "s")
							printf("%s", nx_log_success(arra[l2], arrv[l2]))
						else if (v == "w")
							printf("%s", nx_log_warn(arra[l2], arrv[l2]))
						else if (v == "e")
							printf("%s", nx_log_error(arra[l2], arrv[l2]))
						else if (v == "d")
							printf("%s", nx_log_debug(arra[l2], arrv[l2]))
						else if (v == "a")
							printf("%s", nx_log_alert(arra[l2], arrv[l2]))
						else if (v == "i")
							printf("%s", nx_log_info(arra[l2], arrv[l2]))
						else if (v == "l")
							printf("%s", nx_log_light(arra[l2], arrv[l2]))
						else if (v == "b")
							printf("%s", nx_log_black(arra[l2], arrv[l2]))
					}
				}
				delete arrv
				delete arra
				printf("\n")
			} else if (fmt) {
				printf("%s", nx_printf(fmt, str))
			} else {
				exit 1
			}
		}
	'
)

nx_io_mv()
{
	h_nx_cmd rsync find && {
		tmpa="$(nx_info_path -p "$1")"
		tmpb="$(nx_info_path -p "$2")"
		test -n "$tmpa" -a -n "$tmpb" -a "$tmpa" != "$tmpb" && {
			rsync -av --remove-source-files "$tmpa" "$tmpb"
			find "$1" -type d -empty -delete
		}
	}
}

nx_io_dd()
{
	(
		while getopts :c:b:B:s:i:o:vV OPT; do
			case $OPT in
				v) v='noxfer';;
				V) v='progress';;
				i|o|b|B|s|c) eval "$OPT"="'${OPTARG:-true}'";;
			esac
		done
		shift $((OPTIND - 1))
		[ -z "$i" -a -n "$1" ] && {
			i="$1"
			shift
		}
		[ -z "$o" -a -n "$1" ] && {
			o="$1"
			shift
		}
		dd \
			if="$i" \
			of="$o" \
			status=${v:-none} \
			ibs=${s:-${b:-4096}} \
			obs=${s:-${B:-4096}} \
			${c:+count=$c} \
			conv=fsync \
			oflag=direct
	)
}

