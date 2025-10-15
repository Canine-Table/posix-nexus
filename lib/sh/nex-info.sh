nx_info_canonize()
{
	printf '%s' "$*" | sed 's/ *$//g; s/^ *//g; s|^\./||g; s|^[~]|'"$HOME"'|; s|^[-]|'"$OLDPWD"'|; s|//*|/|g; s|/*$||g'
}

nx_info_path()
{
	case "$1" in
		-e|-E|-b|-d|-p|-s|-S|-q) tmpa="$1"; shift;;
		*) tmpa='-p';;
	esac
	tmpb="$(nx_info_canonize "${1:-"$0"}")"
	tmpc="$(basename "$tmpb")"
	tmpd="$(cd -P "$(dirname "$tmpb")" && pwd)"
	mkdir -p "$tmpd"
	test -e "${tmpd}/${tmpc}" || return 1
	while test -L "${tmpd}/${tmpc}"; do
		tmpb="$tmpd/$(nx_str_sfld -n 10 -c "ls -lnA '${tmpd}/${tmpc}'")"
		tmpc="$(basename "$tmpb")"
		tmpd="$(dirname "$tmpb")"
	done
	test "$tmpa" = '-q' && return
	case "$tmpa" in
		-p) nx_info_canonize "$(printf '%s/%s\n' "$tmpd" "$tmpc")";;
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

nx_info_file()
(
	while test "$#" -gt 0; do
		tmpa="$(nx_info_path -p "$1")"
		tmpb="$(nx_str_case -l "$(file "$tmpa")")"
		printf '%s' "$tmpb" | ${AWK:-$(nx_cmd_awk)} '"^[ \t]*'"$tmpb"':[ \t]+(empty|ascii text|utf-8 unicode text|json|xml|script|source|text)" {exit 1}' || {
		    printf '%s\n' "$tmpa"
		}
		shift
	done
)

nx_info_list()
(
	eval "export $(nx_tty_all)"
	tmpc="$(nx_io_fifo_mgr -c)"
	trap "nx_io_fifo_mgr -r '$tmpc'" EXIT HUP TERM INT
	while test "$#" -gt 0; do
		tmpa="$(nx_info_file "$1")"
		if test -f "$tmpa" -a -r "$tmpa" && ! ${AWK:-$(nx_cmd_awk)} '{if ($1 ~ /[ -~]+/ && $1 !~ /^[ \t]$/){exit 1}}' "$tmpa"; then
			{
				nx_io_printf -I "$tmpa"
				nx_io_printf -A "$(basename "$tmpa")"
				nx_tty_div -s
				cat "$tmpa" 2>/dev/null | tr -dc ' -~\n\t' | tee "$tmpc" &
				file "$tmpa" | ${AWK:-$(nx_awk_cmd)} -F ':' '/[ \t]*empty[ \t]*$/{exit 1}' && {
					nx_tty_div -d
				} || printf '\n%s' "$(nx_tty_div -d)"
			} | (test "$(($(cat "$tmpc" | wc -l) + 10))" -ge "$G_NEX_TTY_ROWS" && {
				"$PAGER"
				printf '%d' 1 > "$tmpc" &
			} || {
				tee
				printf '%d' 0 > "$tmpc" &
			})
		else
			tmpa=""
		fi
		shift
		test -f "$tmpa" && test "$(cat "$tmpc")" -eq 0 && nx_tty_hault
	done
)

