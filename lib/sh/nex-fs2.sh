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

