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
	nx_data_longopt -O  ',
		u<%
			user
		>
		<type int>
		<min 0>
		<max 7>
		<default 6>
		g<%
			group
		>
		<type int>
		<min 0>
		<max 7>
		<default 4>
		o<%
			other
		>
		<type int>
		<min 0>
		<max 7>
		<default 4>
		m<%
			mode
		>
		<type int>
		<min 0>
		<max 777>
		<default 644>
		M<%
			mask
		>
		<type int>
		<min 0>
		<max 777>
		<default 644>
		t<%
			target
		>
		T<%type>
		<lazy>
		<regex ^[dfp]$>
		<default d>
		<type char>
		p<%prefix>
		<
			build test -d <nx@p/\> -o ! -e <nx@p/\> && NEX_Gk_p=<nx@p/\>;>
	' "$@"
)

#nx_fs2_install()
#(

#	nx_data_longopt ',
#		p<%
#			prefix
#		>
#		<
#			type str>
#		<
#			expects directory>
#		<
#			build test -d <nx@p/\> -o ! -e <nx@p/\> && NEX_Gk_p=<nx@p/\>;>
#	'
#	u=6
#	g=4
#	o=4
#	U=7
#	G=5
#	O=5
#	a="$(whoami)"
#	A="$a"
#	c=""
#	while test "$#" -gt 0; do
#		case "$1" in
#			-c|-C) {
#				test $1 "-C" && c="" || b="1"
#			};;
#			-b) {
#				test -d "$2" && b="$2"
#				shift
#			};;
#			-a|-A) {
#				eval "$(printf '%s' "$1" | cut -d '-' -f 2)"="$2"
#				shift
#			};;
#			-u|-g|-o|-U|-G|-O) {
#				if awk -v prm="$2" 'BEGIN{if(perm >= 0 && perm <= 7){exit 0}else{exit 1}}'; then
#					eval "$(printf '%s' "$1" | cut -d '-' -f 2)"="$2"
#					shift
#				else
#					nx_err "expected an octal number,  received $1."
#				fi
#			};;
#			*) {
#				test -d "$b$1" || {
#					test -e "$b$1" && {
#						while :; do
#							tmpd="$b$1-$(date '+%s').bak"
#							test -e "$tmpd" || break
#						done
#						mv "$b$1" "$tmpd" || {
#							nx_err "The path to '$1' must be either be a directory or a path that does not yet exist, manual intervention required."
#							exit 2
#						}
#					}
#					mkdir -p "$b$1" || {
#						nx_err "The path to '$1' could not be created, manual intervention required."
#						exit 3
#					}
#					nx_success "$b$1 was created"
#				}
#				test -n "$c" && {
#					chmod "$U$G$O" "$b$1"
#					chown "$a:$A" "$b$1"
#				}
#			};;
#		esac
#		shift
#	done
#)
