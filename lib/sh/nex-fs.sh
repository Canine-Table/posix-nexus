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
				tmpb="$(nx_fs_canonize -p "$pdloc/$dloc/$sdloc")"
				mnt="${mnt}if(\$3==\"$tmpa\"){delete lmnt[\$3]}"
				#if(\$3 in lmnt){delete lmnt[\$3]};
				#mnt="${mnt}if(\"$tmpa\" in lmnt)delete lmnt[\"$tmpa\"];"
				lmnt="${lmnt}lmnt[\"$tmpa\"]=\"$tmpb\";"
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

nx_fs_i_fd()
{
	case "$1" in
		-o) test -e "/proc/${3:-$$}/fd/$2" && return 1;;
		-c) test -e "/proc/${3:-$$}/fd/$2" || return 0;;
	esac
}

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
				if (nx_file_store(fls,	nx_file_path(drnm, 1) "/" bnm) == -1) {
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



:<<'NX'

			for (i = 1; i <= j; ++i)
				print arr[i]
			exit
			sq = 0
			for (i = 1; i <= k; ++i) {
				ptok = ctok
				ctok = arr[i]
				if (ctok == "/" && gsub("Ø", "", ptok) % 2 == 0) {
					end = i - start + sq
					cur = substr(path, start, end)
					if (cur != "." || i == 2)
						arr[++j] = cur
					sq = sq + 1
					start = i + sq
				}
			}

			j = 0
			start = 1
			pre = ""
			post = ""
			ptok = ""
			ctok = ""
			acm = ""
			cr = "/"
			rcr = "[^" cr "]"
			esc = "\\\\"
			plhr = "\xFF"
			gsub(esc, plhr, path)
			k = split(nx_trim_str(path), arr, "")

			if (arr[1] == cr)
				pre = cr
			if (arr[k] == cr)
				post = cr

			for (i = 1; i <= k; ++i) {
				ptok = ctok
				ctok = arr[i]
				if (ctok == cr && ptok != plhr) {
					if ((acm != "." || i == 2) && acm != "")
						arr[++j] = acm
					acm = ""
				} else if (ctok == plhr && ptok == plhr) {
					ctok = ""
				} else {
					acm = acm ctok
				}
			}

			if (acm != "")
				arr[++j] = acm
			path = ""
			for (i = j; i > 0; --i) {
				cur = arr[i]
				if (cur == "..") {
					k  = 0
					do {
						k++
						cur = arr[--i]
					} while (i > 1 && cur == "..")
					i = i - k
					if (i < 1)
						i = 1
					cur = arr[i]
				}
				path = nx_join_str(cur, path, "/")
			}
			gsub("\xFF", "", path)
			print pre path post
			delete arr

NX

