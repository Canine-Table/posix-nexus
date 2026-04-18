#nx_include nex-data.sh
#nx_include nex-str.sh
#nx_include nex-cmd.sh
#nx_include nex-fs.sh

__nx_web_google_drive()
{
	wget --save-cookies "$cookies" \
		"https://docs.google.com/uc?export=download&id=${FILEID}" -O- \
		| sed -n 's/.*confirm=\([0-9A-Za-z_]\{1,\}\).*/\1/p' > "$confirm"
	wget --load-cookies "$cookies" \
		"https://docs.google.com/uc?export=download&confirm=$(cat "$confirm")&id=${FILEID}" \
		-O "${FILENAME}"
}

nx_web_fetch()
(
	out="$HOME/Downloads"
	test -d "$out" || out="$(pwd)"
	pre="output-"
	suf=".out"
	while test "$#" -gt 0; do
		case "$1" in
			-o|--output) tmpa="$(nx_data_dir "$2")" && {
				out="$tmpa"
				shift
			};;

			-s|--suffix) {
				suf="$2"
				shift
			};;

			-p|--prefix) {
				pre="$2"
				shift
			};;

			--) {
				shift
				break
			};;

			*) {
				break
			};;
		esac
		shift
	done
	test "$#" -gt 0 || return 226
	tmpa="$(nx_str_timestamp -f)-$(nx_str_rand 16)"
	cookies="$(nx_fs_noclobber -v "$NEXUS_ENV/tmp/cookies.$tmpa.txt")"
	confirm="$(nx_fs_noclobber -v "$NEXUS_ENV/tmp/confirm.$tmpa.txt")"
	out="$(nx_fs_noclobber -v "$out/$tmpa")"
	mkdir -p "$out" || return 227
	while test "$#" -gt 0; do
		FILENAME="$(nx_fs_noclobber -v "$out/$pre.$(nx_str_timestamp -f)-$(nx_str_rand 16)$suf")"
		FILEID="$(${AWK:-$(nx_cmd_awk)} -v lnk="$1" '
			BEGIN {
				if (sub(/^[ \t\n\f\v]*https:\/\/drive\.google\.com\/file\/d\//, "", lnk)) {
					if (sub(/[^/]*$/, "", lnk))
						sub(/[/]$/, "", lnk)
					printf("%s", lnk)
					exit 196
				}
			}
		')" || case "$?" in
			196) __nx_web_google_drive;;
		esac
		shift
	done
	rm -f "$cookies" "$confirm"
)

