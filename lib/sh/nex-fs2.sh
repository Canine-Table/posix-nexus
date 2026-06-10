
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
		<
			description the flag to seek help.>
	' "$@"
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
    tmpa="$(whoami)"
    nx_data_longopt -- ',
	m<%mode>
	<type int>
	<regex ^[0-7]{3}$>
	<default 644>
	<description file mode to apply to created targets (octal)>

	O<%owner>
	<type str>
	<default '"$tmpa"'>
	<description owner username to assign to created targets>

	G<%group-owner>
	<type str>
	<default '"$tmpa"'>
	<description group name to assign to created targets>

	U<%umask>
	<build umask <nx@U/\>;>
	<type int>
	<regex ^[0-7]{3}$>
	<default 022>
	<description umask to apply before creating targets (octal)>

	t<%target>
	<type str>
	<build case <nx@T/\> in
		d) mkdir -p <nx@p/\><nx@t/\>;;
		f) touch <nx@p/\><nx@t/\>;;
		p) mkfifo <nx@p/\><nx@t/\>;;
		*) false;;
	esac && chmod <nx@m/\> <nx@p/\><nx@t/\> && chown <nx@O/\>:<nx@G/\> <nx@p/\><nx@t/\>;>
	<description path (relative to prefix) to create as directory, file, or fifo>

	T<%type>
	<regex ^[dfp]$>
	<type char>
	<default d>
	<description target type: d=directory, f=file, p=fifo>

	p<%prefix>
	<build test -d <nx@p/\> -o ! -e <nx@p/\> && mkdir -p <nx@p/\>;>
	<type str>
	<description prefix directory under which targets are created>

	help<h>
	<description show help and exit>
    ' "$@"
    test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
)

