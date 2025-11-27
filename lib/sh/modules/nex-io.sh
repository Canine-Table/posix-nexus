nx_io_fifo_mgr()
(
	h_nx_cmd mkfifo || {
		nx_io_printf -W "mkfifo not found! The realm of named pipes is closed to us." 1>&2
		return 192
	}
	while test "$#" -gt 0; do
		if test "$1" = '-r' -a -p "$2"; then
			rm "$2"
			shift
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
)

nx_io_disown()
{
	nohup exec $@ 1>/dev/null 2>&1 & printf '%d\n' "$!"
}

nx_io_backup()
{
	test -e "$1" || {
		nx_io_printf -E "Backup failed—'$1' is imaginary. Perhaps you mistook a dream for a file." 1>&2
		return 1
	}
	eval $(${AWK:-$(nx_cmd_awk)} \
		-v fl="$(nx_info_path -p "$1")" \
		-v ts="$(nx_str_timestamp -f)" \
		-v ext="$2" \
	"
		$(nx_data_include -i "$NEXUS_LIB/awk/nex-str.awk")
	"'
		BEGIN {
			fl = nx_trim_str(fl)
			ext = nx_trim_str(ext)
			sub(/^[.]*/, "", ext)
			if (ext) {
				if (index(fl, ".") > 0)
					sub(/[^.]+$/, ext, fl)
				else
					fl = fl "." ext
			}
			sub(/^[^.]+/, "\\\\&" ts "\x22 -s \x22", fl)
			sub(/^\\/, "", fl)
			print "nx_io_noclobber -p \x22" fl "\x22"
		}
	')
}

nx_io_noclobber()
(
	eval "$(nx_str_optarg ':m:p:s:n:f' "$@")"
	tmpa=""
	n="$(nx_int_natural "$n")"
	p="$(nx_info_canonize "$p")"
	test -n "$p$s" || exit
	test -n "$f" && f="$p$s" || f=""
	case "$m" in
		'<nx:true/>') mkdir -p "${p%/*}" 2>/dev/null;;
		'<nx:false/>');;
	esac
	test -e "$p$tmpa$s" && tmpb="_" || tmpb=""
	while test -e "$p$tmpa$s"; do
		tmpa="$tmpb$(nx_str_rand ${n:-8})"
	done
	case "$f" in
		'<nx:true/>') mv "$f" "$p$tmpa$s";;
		'<nx:false/>') rm -rf "$p$tmpa$s";;
	esac
	printf '%s\n' "$p$tmpa$s"
)

nx_io_ansi()
{
	${AWK:-$(nx_cmd_awk)} \
		-v str="$(nx_str_chain "$@")" \
	"
		$(nx_data_include -i "$NEXUS_LIB/awk/nex-color.awk")
	"'
		BEGIN {
			nx_ansi_print(str)
		}
	' 1>&2
}

nx_io_type()
{
	eval "$(nx_str_optarg 'v' "$@")"
	test "$v" = '<nx:true/>' && v="printf '%s '" || v='eval'
	eval "$v '$(${AWK:-$(nx_cmd_awk)} \
		-v str="$(nx_str_chain "$NEX_OPT_RMDR")" \
	"
		$(nx_data_include -i "$NEXUS_LIB/awk/nex-shell.awk")
	"'
		BEGIN {
			if (s = nx_file_type(str))
				printf("%s\n", s)
			else
				exit 2
		}
	')'"
	return $?
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

nx_io_swap()
{
	test -e "$1" -a -e "$2" && {
		tmpa="$(nx_io_noclobber -p "$1")"
		mv "$1" "$tmpa"
		mv "$2" "$1"
		mv "$tmpa" "$2"
	} || {
		nx_io_printf -W "Hmm... I tried to swap $1 and $2, but they’re playing hide-and-seek. One of them vanished into the quantum filesystem."
	}
	unset tmpa
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

nx_io_prompt()
{
	nx_io_printf -f '_b>L%_ui>A%>L_nb%>S%' '┌──[' "$@" ']\n│\n└' '$ '
}

nx_io_yn()
(
	nx_io_prompt "$* (y/n)"
	nx_tty_hault
	test "$tmpa" = 'y' -o "$tmpa" = 1
)

