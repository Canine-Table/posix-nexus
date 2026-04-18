#nx_include nex-data.sh
#nx_include nex-str.sh
#nx_include nex-cmd.sh

__nx_fs_n_fifo()
{
	tmpa=""
	tmpb="$1${1:+-}"
	test -n "$1" && {
		tmpa="$NEXUS_ENV/run/nx_$1.fifo"
		test -e "$tmpa" && unset tmpa
	}

	while test -z "$tmpa"; do
		tmpa="$NEXUS_ENV/run/nx_$tmpb$(nx_str_rand 32).fifo"
		test -e "$tmpa" && unset tmpa
	done

	mkfifo "$tmpa" || {
		nx_tty_print -E "Failed to create named pipes at '$tmpa'."
		return 227
	}
	printf '%s' "$tmpa"
}

nx_fs_fifo()
(
	h_nx_cmd mkfifo || {
		nx_tty_print -W 'mkfifo not found! The realm of named pipes is closed to us.'
		exit 127
	}
	while test "$#" -gt 0; do
		case "$1" in
			-r|--remove) test -p "$2" && {
				rm "$2"
				shift
			};;

			-t|--try) {
				tmpa="$NEXUS_ENV/run/nx_$2.fifo"
				if test -p "$2"; then
					printf '%s' "$2"
				elif test -p "$tmpa"; then
					printf '%s' "$tmpa"
				else
					__nx_fs_n_fifo "$2"
				fi
				shift
			};;

			-c|--create) {
				__nx_fs_n_fifo "$2"
				shift
			};;
		esac
		shift
	done
)

nx_fs_mount()
(
	sloc='' psloc='' ssloc=''
	dloc='' pdloc='' sdloc=''
	lmnt='' umnt='' mnt=''
	cmd='' pcmd=''
	run='' tmpa=''

	while test "$#" -gt 0; do
		case "$1" in
			-r|--run) {
				run='1'
			};;

			-d|--dry) {
				test "$run" = '0' && run='' || run='0'
			};;
			
			-o|--out) {
				run='-1'
			};;

			-c|--command-prefix) {
				pcmd="$2 "
				shift
			};;

			-l|--source) {
				sloc="$2"
				shift
			};;

			-L|--destination) {
				dloc="$2"
				shift
			};;

			-p|--source-prefix) {
				psloc="$2"
				shift
			};;

			-P|--destination-prefix) {
				pdloc="$2"
				shift
			};;

			-s|--source-suffix) {
				ssloc="$2"
				shift
			};;

			-S|--destination-suffix) {
				sdloc="$2"
				shift
			};;

			-M|--umount) {
				umnt="${umnt}if(\$3==\"$(nx_fs_canonize -p "$psloc/$sloc/$ssloc")\"){mnt[\$3]=1;delete lmnt[\$3]}"
			};;

			-m|--mount) {
				tmpa="$(nx_fs_canonize -p "$psloc/$sloc/$ssloc")"
				mnt="${mnt}if(\$3==\"$tmpa\"){delete lmnt[\$3]}"
				lmnt="${lmnt}lmnt[\"$tmpa\"]=\"$(nx_fs_canonize -p "$pdloc/$dloc/$sdloc")\";"
			};;
		esac
		shift
	done

	test -n "$lmnt" && cmd='for(i in lmnt){printf("'"$pcmd"'mount --bind \"%s\" \"%s\";", lmnt[i], i)}; delete lmnt;'
	test -n "$umnt" && cmd="$cmd"'for(i in mnt)printf("'"$pcmd"'umount \"%s\";",i);'
	test "$run" = '-1' && {
		$pcmd mount | ${AWK:-$(nx_cmd_awk)} 'BEGIN{split("",mnt,"");split("",lmnt,"")'"${lmnt:+;}$lmnt"'}{'"${umnt}${umnt:+;}$mnt"'}END{
			i = ""
			for (i in lmnt)
				print "lmnt: " i " = " lmnt[i]
			delete lmnt
			if (i)
				j = 1
			i = ""
			for (i in mnt)
				print "mnt: " i " = " mnt[i]
			delete mnt
			if (i)
				j = 3
			exit 227 + j
		}'
		return $?
	}

	test -n "$cmd" && {
		cmd="$pcmd mount | ${AWK:-$(nx_cmd_awk)} 'BEGIN{split(\"\",mnt,\"\");split(\"\",lmnt,\"\")${lmnt:+;}$lmnt}{${umnt}${umnt:+;}$mnt}END{${cmd}delete mnt}'"
		if test -z "$run"; then
			printf '%s' "$cmd"
		else
			if test "$run" != '1'; then
				eval "$cmd"
			else
				tmpa="$(eval "$cmd")"
				eval "$tmpa"
			fi
		fi
	}
)

nx_fs_canonize()
(
	nx_data_optargs 'p<:bdp>' "$@"
	case "$NEX_Gk_p" in
		b) NEX_Gk_p="";;
		d) NEX_Gk_p=1;;
		*) NEX_Gk_p=0;;
	esac
	${AWK:-$(nx_cmd_awk)} \
		-v nm="${NEX_Gl_p:-$NEX_S}" \
		-v prt="$NEX_Gk_p" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-io-extras.awk")
	"'
		BEGIN {
			print nx_str_parse_esc(nx_file_path(nm, prt))
		}
	'
)

nx_fs_pipe()
(
	nx_data_optargs 'v:fcr' "$@"
	test "$NEX_f_f" = '<nx:true/>' && {
		test "$NEX_f_h" = '<nx:true/>' && {
			NEX_f_h='HUP'
		} || NEX_f_h=''
		trap 'nx_fs_fifo -r $NEX_f_f;' INT $NEX_f_h TERM
		NEX_f_f="$(nx_fs_fifo -c)"
		printf '%s' "$NEX_f_f"
	}
	test ! -p "$NEX_f_f" && {
		nx_tty_print -e 'fifo not provided! The realm of named pipes told us to get lost in a socket.'
		exit 2
	}
	test "$NEX_f_c" = '<nx:true/>' && {
		read -t 1 NEX_L <"$NEX_f_f" || true
		printf '%s' "$NEX_L"
	}
	test -n "$NEX_k_v" && printf '%s' "$NEX_k_v" >"$NEX_f_f" &
	test "$NEX_f_r" = '<nx:true/>' -a -p "$NEX_f_f" && nx_fs_fifo -r "$NEX_f_f"
)

nx_fs_path()
(
	nx_data_optargs 'p<:bdp>' "$@"
	tmpa="$(nx_data_dir "$NEX_Gl_p")"
	if test $? -eq 196; then
		NEX_pth_1="$tmpa"
		NEX_pth_2="$tmpa"
		NEX_pth_3="$(basename "$tmpa")"
	else
		tmpb="$(${AWK:-$(nx_cmd_awk)} \
			-v drnm="$tmpa" \
			-v nm="$NEX_Gl_p" \
			-v val="$NEX_Gk_p" \
		"
			$(nx_data_include -i "${NEXUS_LIB}/awk/nex-io-extras.awk")
		"'
			BEGIN {
				dnm = nx_file_path(drnm, 0)
				bnm = nx_file_path(nm)
				if (nx_file_store(fls, bnm, dnm) == -1)
				if (nx_file_store(fls, nx_file_path(drnm, 1) "/" bnm) == -1) {
					nx_ansi_error("(nx_fs_path breach) file check failed: '" dnm "' (NEX_Gl_p=" nm ") either does not exist, is not readable, or is empty")
					delete fls
					exit 1
				}
				for (i = 1; i <= 3; ++i)
					printf("%s", __nx_stringify_var("NEX_pth_" i, fls[fls[i]]))
				delete fls
			}
		')" || {
			printf '%s' "$tmpb" 1>&2
			exit 1
		}
		eval "$tmpb"
	fi
	case "$NEX_Gk_p" in
		b) {
			printf '%s' "$NEX_pth_3"
		};;
		d) {
			printf '%s' "$NEX_pth_2"
		};;
		p) {
			printf '%s' "$NEX_pth_1"
		};;
	esac
)


__nx_fs_follow()
{
	printf '%s' "$tmpa" 1>&2
	exit 66
}

nx_fs_follow()
(
	nx_data_optargs 'r:' "$@"
	tmpa="$(nx_fs_path -p "$NEX_S")" || __nx_fs_follow
	nx_int_range -o -v "${NEX_k_r:-7}" -e -g 8 || NEX_f_r=16
	while test -h "$tmpa"; do
		tmpa="$(
			nx_fs_path -p "$(
				dirname "$tmpa"
			)/$(
				ls --color=never -l "$tmpa" | sed 's/^.*[\t ][ \t]*->[\t ][ \t]*//
			')"
		)"  || __nx_fs_follow
		test "$NEX_f_r" -gt 0 || {
			nx_tty_print -e 'too many redirects'
			exit 47
		} && {
			NEX_f_r=$((NEX_f_r - 1))
		}
	done
	printf '%s' "$tmpa"
)

nx_fs_noclobber()
(
	acm=''
	vb=''
	test "$1" = '-v' -o "$1" = '--verbose' && {
		vb=1
		shift
	}

	while test "$#" -gt 0; do
		tmpa="$(nx_fs_path -p "$1" 2>/dev/null)"
		acm="$acm${acm:+<nx:null/>}${tmpa:-$1}<nx:null/>$(nx_str_timestamp -f)"
		shift
	done

	acm="$(${AWK:-$(nx_cmd_awk)} \
		-v acm="$acm" \
		-v vb="$vb" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-io-extras.awk")
	"'
		BEGIN {
			len = split(acm, paths, "<nx:null/>")
			for (idx = 1; idx < len; idx+=2) {
				path = nx_str_parse_esc(nx_file_path(paths[idx], 0, "/", earr))
				stamp = paths[idx + 1]
				dnm = path
				bnm = path
				sub(/[^/]*$/, "", dnm)
				sub(/^.*\//, "", bnm)
				if (bnm !~ /^[.]/) {
					bext = bnm
					bext = bnm
					sub(/^[^.]*/, "", bext)
					sub(/[.].*$/, "", bnm)
				} else {
					sz = split(bnm, szarr, "")
					for (srt = 1; srt <= sz; ++srt) {
						if (szarr[srt] != ".")
							break
					}
					if (srt == sz) {
						bext = "." stamp "-$(nx_str_rand 16)" bext
					} else {
						tmpa = substr(bnm, srt)
						bext = tmpa
						sub(/[.].*$/, "", tmpa)
						sub(/^[^.]*/, "", bext)
						bnm = substr(bnm, 1, srt - 1) tmpa
					}
				}
				if (!sub(/(([2-9][0-9]([0248][1-35-79]|[1379][014-9])(((0[135679]|12)([12][0-9]|0[1-9]|3[01]))|((0[469]|11)([12][0-9]|0[1-9]|30))|((0[469]|11)([12][0-9]|0[1-8])))_([01][0-9]|2[0-3])[0-5][0-9][0-5][0-9])|([2-9][0-9]([0248][048]|[1379][23])(((0[135679]|12)([12][0-9]|0[1-9]|3[01]))|((0[469]|11)([12][0-9]|0[1-9]|30))|((0[469]|11)([12][0-9]|0[1-9])))_([01][0-9]|2[0-3])[0-5][0-9][0-5][0-9]))-[0-9A-Za-z]{16}/, stamp "-$(nx_str_rand 16)", bext))
					bext = "." stamp "-$(nx_str_rand 16)" bext
				npath = __nx_stringify_var("", dnm bnm bext, 1)
				printf("%s tmpb%s tmpc=\x22$tmpa\x22;test -e \x22$tmpa\x22", __nx_stringify_var("tmpa", path), npath)
				if (vb == 1)
					printf("||{ printf \x27%%s\x27 \x22$tmpa\x22;false;}")
				printf("&&{ while test -e \x22$tmpc\x22;do tmpc%s;done;", npath)
				if (vb != 1)
					printf("mv \x22$tmpa\x22 \x22$tmpc\x22;")
				printf("printf \x27%%s\x27 \x22$tmpc\x22;}", npath)
			}
			delete earr
			delete szarr
			delete paths
		}
	')"
	test -n "$acm" && eval "$acm"

)

nx_fs_swap()
(
	tmpb=""
	tmpa="$(nx_data_dir "$1")"
	case "$?" in
		66) return 227;;
		196) tmpc="$tmpa";;
		0) tmpb="$(basename "$1")" && tmpc="$tmpa/$tmpb";;
	esac

	tmpe=""
	tmpd="$(nx_data_dir "$2")"
	case "$?" in
		66) return 228;;
		196) tmpf="$tmpd";;
		0) tmpe="$(basename "$2")" && tmpf="$tmpd/$tmpe";;
	esac

	test "$tmpf" = "$tmpc" && {
		nx_tty_print -E 'Swap aborted: both paths refer to the same file'
		return 229
	}

	test -e "$tmpf" -a -e "$tmpc" && {
		${AWK:-$(nx_cmd_awk)} \
			-v da="$tmpa" \
			-v db="$tmpd" \
		'
			BEGIN {
				la = length(da)
				lb = length(db)
				if (la < lb)
					l = la
				else
					l = lb
				if (substr(da, 1, l) == substr(db, 1, l) && la != lb)
					exit 1
			}
		' || {
			nx_tty_print -E "Swap aborted: cannot swap nested paths:\n\tA: $tmpc\n\tB: $tmpf\n"
			exit 230
		}
		tmpa="$(nx_fs_noclobber "$tmpc")"
		mv "$tmpf" "$tmpc"
		mv "$tmpa" "$tmpf"
	}
)
