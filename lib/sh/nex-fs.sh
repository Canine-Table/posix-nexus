#nx_include nex-tty.sh
#nx_include nex-data.sh
#nx_include nex-str.sh
#nx_include nex-cmd.sh

nx_fs_path()
(
	nx_data_longopt -- ',
		realpath<@
			b basename
			d dirname
			D Dirname
			r
		>
		<
			type str>
		<
			default realpath>
		<
			description this is a radio option for return a path.>

		file<%
			l location
			f
		>
		<
			type str>
		<lazy>
		<
			default .>
		<
			description a path relative or absolute pointing to a file, directory or whatever has a path on the filesystem. >

		help<
			h
		>
		<build exit;>
		<
			description the flag to seek help.>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	NEX_ARGV_S="$(nx_data_dir "${NEX_Gk_file:=${NEX_ARGV_S:-$(pwd)}}")"
	case "$?" in
		66) {
			exit 66
		};;

		196) {
			NEX_Gk_file="$(basename "$NEX_ARGV_S")"
			dnm="$(dirname "$NEX_ARGV_S")"
		};;

		0) {
			NEX_Gk_file="$(basename "$NEX_Gk_file")"
			dnm="$NEX_ARGV_S"
			NEX_ARGV_S="$NEX_ARGV_S/$NEX_Gk_file"
		};;
	esac

	case "$NEX_GF_realpath" in
		b|basename) {
			printf '%s' "$NEX_Gk_file"
		};;

		D|Dirname) {
			test -d "$NEX_ARGV_S" && printf "$NEX_ARGV_S" || printf '%s' "$dnm"
		};;

		d|dirname) {
			printf '%s' "$dnm"
		};;

		*) {
			printf "$NEX_ARGV_S"
		};;
	esac
)

nx_fs_install()
(
	L_NEX_USER="$(command -v whoami 2>&1 1>/dev/null && whoami || printf '%s' "${USER:-${LOGNAME}}")"
	nx_data_longopt -- ',
		m<%mode>
		<type int>
		/<regex ^[0-7]{3}$>
		<default 644>
		<description file mode to apply to created targets (octal)>

		O<%owner>
		<type str>
		<default '"$L_NEX_USER"'>
		<description owner username to assign to created targets>

		G<%group-owner>
		<type str>
		<default '"$L_NEX_USER"'>
		<description group name to assign to created targets>

		U<%umask>
		<build umask <nx@U/\\>;>
		<type int>
		<regex ^[0-7]{3}$>
		<default 022>
		<description umask to apply before creating targets (octal)>

		t<%target>
		<type str>
		<build nx_path=<nx@p/\\><nx@t/\\>; case <nx@T/\\> in
			d) {
				nx_msg="directory"
				mkdir -p "$nx_path"
			};;
			f) {
				nx_msg="file"
				touch "$nx_path"
			};;
			p) {
				nx_msg="named pipe"
				mkfifo "$nx_path"
			};;
		esac 2\\>&1 1\\>/dev/null; if test "$?" -eq 0; then
				nx_tty_print -n -s "Created $nx_msg at $nx_path"
				nx_msg=<nx@m/\\>
				chmod "$nx_msg" "$nx_path"
				if test "$?" -eq 0; then
					nx_tty_print -n -a "Set permissions on $nx_path to $nx_msg"
					nx_msg="owner <nx@O/\\> and group <nx@G/\\>"
					chown <nx@O/\\>:<nx@G/\\> "$nx_path"
					if test "$?" -eq 0; then
						nx_tty_print -n -i "Set ownership as $nx_msg on $nx_path"
					else
						nx_tty_print -n -e "Failed to set ownership as $nx_msg on $nx_path"
					fi
				else
					nx_tty_print -n -e "Failed to set permissions on $nx_path to $nx_msg"
				fi
			else
				nx_tty_print -n -e "Failed to create $nx_msg at $nx_path"
			fi;>
		<description path (relative to prefix) to create as directory, file, or fifo>

		T<%type>
		<regex ^[dfp]$>
		<type char>
		<default d>
		<description target type: d=directory, f=file, p=fifo>

		p<%prefix>
		<build test -d <nx@p/\\> -o ! -e <nx@p/\\> && mkdir -p <nx@p/\\>;>
		<type str>
		<description prefix directory under which targets are created>

		help<h>
		<description show help and exit>
	' "$@"
	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
)

nx_fs_canonize()
(
	nx_data_longopt -- ',
		p<%mode>
		<regex ^[bdp]$>
		<description Canonicalization mode: b = basename, d = directory, p = path>

		f<%path>
		<description Path to canonicalize (defaults to the first positional)>

		help<h>
		<description Show help for nx_fs_canonize>
		<build exit;>
	' "$@"

	case "$NEX_Gk_p" in
		b) NEX_Gk_p="";;
		d) NEX_Gk_p=1;;
		*) NEX_Gk_p=0;;
	esac

	${AWK:-$(nx_cmd_awk)} \
		-v nm="${NEX_Gk_f:-$NEX_ARGV_S}" \
		-v prt="$NEX_Gk_p" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-io-extras.awk")
	"'
		BEGIN {
			print nx_str_parse_esc(nx_file_path(nm, prt))
		}
	'
)

nx_fs_noclobber()
(
	nx_data_longopt -- ',
		v<verbose>
		<type toggle>
		<description Print the new name without moving the file (dry run)>
		<default <nx:false/\\>>

		help<h>
		<description Show help for nx_fs_noclobber>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	acm=''
	i=1

	while test "$i" -le "$NEX_ARGV_0"; do
		arg="$(nx_data_ref "NEX_ARGV_$i")"
		tmpa="$(nx_fs_path --realpath --location "$arg" 2>/dev/null)"
		acm="$acm${acm:+<nx:null/>}${tmpa:-$arg}<nx:null/>$(nx_str_timestamp --filename)"
		i=$((i+1))
	done

	acm="$(${AWK:-$(nx_cmd_awk)} \
		-v acm="$acm" \
		-v vb="$NEX_Gf_v"  \
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
						bext = "." stamp "-$(nx_str_rand --number 16)" bext
					} else {
						tmpa = substr(bnm, srt)
						bext = tmpa
						sub(/[.].*$/, "", tmpa)
						sub(/^[^.]*/, "", bext)
						bnm = substr(bnm, 1, srt - 1) tmpa
					}
				}
				if (!gsub(/(([0-9]{2}(0[1235679]|[2468][1235679]|[13579][0134579])(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|1[0-9]|2[0-8])))_([01][0-9]|2[0-3])[0-5][0-9][0-5][0-9])|([0-9]{2}(0[48]|[2468][048]|[13579][26])(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|1[0-9]|2[0-9])))_([01][0-9]|2[0-3])[0-5][0-9][0-5][0-9]))-[0-9A-Za-z]{16}/, stamp "-$(nx_str_rand --number 16)", bext))
					bext = "." stamp "-$(nx_str_rand --number 16)" bext
				npath = __nx_stringify_var("", dnm bnm bext, 1)
				printf("%s tmpb%s tmpc=\x22$tmpa\x22;test -e \x22$tmpa\x22", __nx_stringify_var("tmpa", path), npath)
				if (vb == "<nx:true/>")
					printf("||{ printf \x27%%s\x27 \x22$tmpa\x22;false;}")
				printf("&&{ while test -e \x22$tmpc\x22;do tmpc%s;done;", npath)
				if (vb !=  "<nx:true/>")
					printf("mv \x22$tmpa\x22 \x22$tmpc\x22;")
				printf("printf \x27%%s\x27 \x22$tmpc\x22;}", npath)
			}
			delete earr
			delete szarr
			delete paths
		}
	')"
	test -n "$acm" && eval  "$acm"
)


__nx_fs_n_fifo()
{
	nx_data_longopt -- ',
		n<%name>
		<description Name for the FIFO (optional; if omitted, a unique name is generated)>

		r<%random>
		<default 16>
		<description number of random digits to add to the end of the file name (default 16)>

		p<%prefix>
		<default nx>
		<description Prefix for the generated name (default nx)>

		help<h>
		<description Show help for __nx_fs_n_fifo>
		<build exit;>
	' "$@"
	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	tmpa="$NEXUS_ENV/run/${NEX_Gk_p}_${NEX_Gk_n:-"$(nx_str_timestamp --filename)-$(nx_str_rand --number "$NEX_Gk_r")"}.fifo"
	while test -e "$tmpa"; do
		tmpa="$(nx_fs_noclobber --verbose "$tmpa")"
	done
	mkfifo "$tmpa" || {
		nx_tty_print -E "Failed to create named pipes at '$tmpa'."
		exit 227
	}
	printf '%s\n' "$tmpa"
}


nx_fs_fifo()
(
	h_nx_cmd mkfifo || {
		nx_tty_print -W 'mkfifo not found! The realm of named pipes is closed to us.'
		exit 127
	}
	nx_data_longopt  -- '
		t<@c, try create>
		<type str>
		<regex ^(t|c|try|create)$>
		<default t>
		<lazy>
		<build case <nx@t/\\> in
			t|try)
				tmpa=<nx@p/\\>_<nx@n/\\>.fifo
				tmpb="$NEXUS_ENV/run/$tmpa"
				if test -p "$tmpa"; then
					printf "%s" "$tmpa"
				elif test -p "$tmpb"; then
					printf "%s" "$tmpb"
				else
					__nx_fs_n_fifo -n=<nx@n/\\> -p=<nx@p/\\> -r=<nx@r/\\>
				fi
			;;
			c|create) __nx_fs_n_fifo -n=<nx@n/\\> -p=<nx@p/\\> -r=<nx@r/\\>;;
		esac;>
		<description Operation: t/try, c/create (default try)>

		d<%del delete>
		<build test -p <nx@d/\\> && rm -f <nx@d/\\>;>

		r<%random>
		<default 16>
		<description number of random digits to add to the end of the file name (default 16)>

		n<%name>
		<description Name for the FIFO (optional; if omitted, a unique name is generated)>

		p<%prefix>
		<default nx>
		<description Prefix for the generated name (default nx)>

		help<h>
		<description Show help for nx_fs_fifo>
		<build exit;>
	' "$@"
	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
)


__nx_fs_pipe()
{
	nx_data_longopt -- ',
		v<%value>
		<description Value to write to the FIFO (write mode)>

		f<force Force>
		<type toggle>
		<default <nx:false/\\>>
		<description Create a new FIFO and print its path (create mode)>

		c<read>
		<type toggle>
		<default <nx:false/\\>>
		<description Read one line from the FIFO (read mode)>

		r<remove>
		<type toggle>
		<default <nx:false/\\>>
		<description Remove the FIFO after use (remove mode)>

		hup<hangup>
		<type toggle>
		<default <nx:false/\\>>
		<description Also trap HUP (hangup) in addition to INT and TERM>

		p<%path>
		<description FIFO path (required unless -f creates one)>

		help<h>
		<description Show help for nx_fs_pipe>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	test "$NEX_Gf_f" = '<nx:true/>' && {
		test "$NEX_Gf_hup" = '<nx:true/>' && {
			NEX_Gf_hup='HUP'
		} || NEX_Gf_hup=''
		trap 'nx_fs_fifo --delete "$NEX_Gk_p";' INT $NEX_Gf_hup TERM
		NEX_Gk_p="$(nx_fs_fifo --create)"
		printf '%s' "$NEX_Gk_p"
	}
	test ! -p "$NEX_Gk_p" && {
		nx_tty_print -e 'fifo not provided! The realm of named pipes told us to get lost in a socket.'
		exit 2
	}
	test "$NEX_Gf_c" = '<nx:true/>' && {
		read NEX_L <"$NEX_Gk_p" || true
		printf '%s' "$NEX_L"
	}
	test -n "$NEX_Gk_v" && printf '%s' "$NEX_Gk_v" >"$NEX_Gk_p" &
	test "$NEX_Gf_r" = '<nx:true/>' -a -p "$NEX_Gk_p" && nx_fs_fifo --delete "$NEX_Gk_p"
}

nx_fs_follow()
(
	nx_data_longopt -- ',
		r<%redirects>
		<type int>
		<min 1>
		<max 8>
		<default 7>
		<description Maximum number of symlink hops to follow (default 7, max 8)>

		help<h>
		<description Show help for nx_fs_follow>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	tmpa="$(nx_fs_path --realpath "$NEX_ARGV_S")" || exit 66
	tmpb="$NEX_Gk_r"
	while test -h "$tmpa"; do
		tmpa="$(
			nx_fs_path --realpath "$(
				dirname "$tmpa"
			)/$(
				ls --color=never -l "$tmpa" | sed 's/^.*[\t ][ \t]*->[\t ][ \t]*//'
			)"
		)" || exit 66
		test "$tmpb" -gt 0 || {
			nx_tty_print -e 'too many redirects'
			exit 47
		} && {
			tmpb=$((tmpb - 1))
		}
	done
	printf '%s' "$tmpa"
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

