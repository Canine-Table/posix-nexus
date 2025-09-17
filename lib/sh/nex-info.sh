
nx_info_canonize()
{
	printf '%s' "$*" | sed 's|//*|/|g; s|/*$||g; s/ *$//g; s/^ *//g; s|^\./||g'
}

nx_info_path()
{
	case "$1" in
		-e|-E|-b|-d|-p|-s|-S) tmpa="$1"; shift;;
		*) tmpa='-p';;
	esac
	tmpb="$(nx_info_canonize "${1:-"$0"}")"
	tmpc="$(basename "$tmpb")"
	tmpd="$(cd "$(dirname "$tmpb")" && pwd)"
	mkdir -p "$tmpd"
	test -e "${tmpd}/${tmpc}" || return 1
	case "$tmpa" in
		-p) printf '%s/%s\n' "$tmpd" "$tmpc";;
		-d) printf '%s\n' "$tmpd";;
		-b) printf '%s\n' "$tmpc";;
		-e) printf '%s\n' "${tmpc##*.}";;
		-s) printf '%s\n' "${tmpc%.*}";;
		-E) printf '%s\n' "${tmpc#*.}";;
		-S) printf '%s\n' "${tmpc%%.*}";;
	esac
}

nx_info_os()
{
	for tmpa in '/etc/lsb-release' '/etc/os-release' '/etc/redhat-release' '/etc/centos-release'; do
		[ -f "$tmpa" -a -r "$tmpa" ] && {
			cat "$tmpa" | ${AWK:-$(nx_cmd_awk)} '/[a-zA-Z_]+[a-zA-Z0-9]*=.+/{printf("%s", " G_NEX_OS_" $0)}'
		}
	done
}

nx_info_list()
{
	for tmpa in "$@"; do
		[ -e "$tmpa" ] && {
			[ -d "$tmpa" ] && ls -dl "$tmpa" || ls -l "$tmpa"
		}
	done
}

