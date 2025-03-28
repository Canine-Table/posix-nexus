#!/bin/sh

###:( get ):##################################################################################

get_tty_prop_list()
{
	[ -n "$(tty)" ] && stty -a | ${AWK:-$(get_cmd_awk)} '
		{
			gsub(/= /, "")
			cnt_t = split($0, arr_t, "; *")
			for (i = 1; i <= cnt_t; i++) {
				if (arr_t[i]) {
					if (i < cnt_t) {
						sub(/ /, "=\x27", arr_t[i])
						print arr_t[i] "\x27"
					} else {
						cnt_b = split(arr_t[i], arr_b, " ")
						for (j = 1; j <= cnt_b; j++) {
							s = "true"
							if (sub(/^-/, "", arr_b[j]))
								s = "false"
							print arr_b[j] "=\x27" s "\x27"
						}
						delete arr_b
					}
				}
			}
			delete arr_t
		}
	'
}

get_tty_prop()
{
	[ -n "$(tty)" ] && (
		while getopts :k:v: OPT; do
			case $OPT in
				k|v) eval "$OPT"="$OPTARG";;
			esac
		done
		shift $((OPTIND - 1))
		get_tty_prop_list | ${AWK:-$(get_cmd_awk)} \
			-v key="$k" \
			-v val="$v" '
			{
				if (! key && ! val) {
					print substr($0, 1, index($0, "=") - 1)
				} else {
					sub("\x27$", "")
					if (substr($0, (m = index($0, "\x27")) + 1) == val)
						print substr($0, 1, m - 2)
					if (sub("^" key "=\x27", ""))
						print $0
				}
			}
		'
	)
}

set_tty_hault()
{
	command -v setterm 1>/dev/null 2>&1 && {
		setterm -cursor off
		trap 'setterm -cursor on' RETURN SIGINT SIGHUP
	}
	read -n 1 -s;
}

##############################################################################################

