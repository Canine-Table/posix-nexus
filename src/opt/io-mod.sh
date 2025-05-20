nx_io_fifo_mgr()
{
	h_nx_cmd mkfifo && {
		while [ ${#@} -gt 0 ]; do
			if [ "$1" = '-r' -a -p "$2" ]; then
				rm "$2"
				shift
			elif [ "$1" = '-c' ]; then
				(
					while [ -z "$nx_fifo" ]; do
						nx_fifo="$G_NEX_MOD_ENV/nx_$(nx_str_rand 32).fifo"
						[ -e "$nx_fifo" ] && unset nx_fifo
					done
					mkfifo "$nx_fifo"
					echo "$nx_fifo"
				)
			fi
			shift
		done
	}
}

nx_io_dir()
{
	while [ ${#@} -gt 0 ]; do
		nx_content_container "$1" 1>/dev/null 2>&1 || return 1
		shift
	done
}

nx_io_leaf()
{
	while [ ${#@} -gt 0 ]; do
		nx_content_leaf "$1" 1>/dev/null 2>&1 || return 1
		shift
	done
}

nx_io_swap()
{
	[ -e "$1" -a -e "$2" ] && {
		mv "$1" "${1}.swap"
		mv "$2" "$1"
		mv "${1}.swap" "$2"
	}
}

nx_io_printf()
{
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
			-v str="$(nx_str_chain "$@")" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
				"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
				"$G_NEX_MOD_LIB/awk/nex-str.awk" \
				"$G_NEX_MOD_LIB/awk/nex-log.awk" \
				"$G_NEX_MOD_LIB/awk/nex-math.awk"
			)
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
}

nx_io_mv()
{
	h_nx_cmd rsync find && nx_io_dir "$1" "$2" && (
		if="$(nx_content_container "$1")"
		of="$(nx_content_container "$2")"
		[ -n "$if" -a -n "$of" -a "$if" != "$of" ] && {
			rsync -av --remove-source-files "$1" "$2"
			find "$1" -type d -empty -delete
		}
	)
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

