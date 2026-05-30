(
	nx_data_longopt ',
		realpath<@
			b basename
			d dirname
			r
		>
		file<%
			l location
			f
		>
	' "$@"
	NEX_ARGV_S="$(nx_data_dir "${NEX_Gk_file:=$NEX_ARGV_S}")"
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
