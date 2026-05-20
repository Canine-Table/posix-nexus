(
	nx_data_longopt ',
		realpath<@
			b basename
			d dirname
			r
		>
		<
			type toggle>
		<
			description this is a radio option for return a path.>
		file<%
			l location
			f
		>
		<
			type string>
		<
			description a path relative or absolute pointing to a file, directory or whatever has a path on the filesystem.>
		help<
			h
		>
		<
			description the flag to seek help.>
	' "$@"
	NEX_ARGV_R=$(nx_data_dir "${NEX_Gk_file:=$NEX_ARGV_R}")
	case "$?" in
		66) {
			exit 66
		};;

		196) {
			NEX_Gk_file="$(basename "$NEX_ARGV_R")"
			dnm="$(dirname "$NEX_ARGV_R")"
		};;

		0) {
			NEX_Gk_file="$(basename "$NEX_Gk_file")"
			dnm="$NEX_ARGV_R"
			NEX_ARGV_R="$NEX_ARGV_R/$NEX_Gk_file"
		};;
	esac

	case "$NEX_GF_realpath" in
		b|basename) {
			printf '%s' "$NEX_Gk_file"
		};;

		d|dirname) {
			printf '%s' "$dnm"
		};;

		*) {
			printf '%s' "$NEX_ARGV_R"
		};;
	esac
)
