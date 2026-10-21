#nx_include nex-tty.sh

nx_fs2_path()
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


nx_fs2_install()
(

	L_NEX_USER="$(command -v whoami 2>&1 1>/dev/null && whoami || printf '%s' "${USER:-${LOGNAME}}")"
	nx_data_longopt -- ',
		m<%mode>
		<type int>
		<regex ^[0-7]{3}$>
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

nx_fs2_canonize()
(
	nx_data_longopt -- ',
		p<%mode>
		<regex ^[bdp]$>
		<description Canonicalization mode: b = bare, d = directory, p = path>

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


nx_fs2_noclobber()
(
	nx_data_longopt -- ',
		v<%verbose>
		<type toggle>
		<description Print the new name without moving the file (dry run)>
		<build vb=1;>

		help<h>
		<description Show help for nx_fs_noclobber>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	acm=''
	i=1

	while test "$i" -le "$NEX_ARGV_0"; do
		arg="$(nx_data_ref "NEX_ARGV_$i")"
		tmpa="$(nx_fs2_path --realpath "$arg" 2>/dev/null)"
		acm="$acm${acm:+<nx:null/>}${tmpa:-$arg}<nx:null/>$(nx_str_timestamp --filename)"
		i=$((i+1))
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
	test -n "$acm" && echo "$acm"
)

