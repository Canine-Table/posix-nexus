#!/bin/sh

###:( get ):##################################################################################

get_out_color_support() {
	[ -n "$(tty)" ] && case "$TERM" in
		screen*|Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|tmux*|xterm*);;
		*) return 1;;
	esac
}

get_out_style() {
	(
                while getopts :f:F:b:B:t:s: OPT; do
                        case $OPT in
				f|b|F|B|s)
					{
						[ "$OPT" = 'F' -o "$OPT" = 'B' ] && eval "$OPT"="true"
						eval "$(set_str_case -l "$OPT")"="'$(
							set_struct_opt -i "$OPTARG" '
								black, dark, red, error, green,
								success, yellow, warning,
								blue, info, magenta, debug,
								teal, alert, white, light'
						)'"
					};;
				t)
					{
						t="$(
							set_struct_opt -i "$OPTARG" '
								none, bold, italics,
								underlined, blinking,
								highlighted'
						)"
					};;
                        esac
                done
                shift $((OPTIND - 1))
		get_out_color_support && {
			c=true
			trap 'echo -e "\x1b[0m"' SIGHUP SIGINT EXIT
		}
		echo $* | $(get_cmd_awk) \
			-v fg="$f" \
			-v bg="$b" \
			-v fgl="$F" \
			-v bgl="$B" \
			-v txt="$t" \
			-v sym="$s" \
			-v csup="$c" "
			$(
	                        cat "$G_NEX_MOD_LIB/awk/style.awk"
			)
		"'
			{
				printf("%s", color_style($0, fg, bg, txt, csup, sym, fgl, bgl))
			}
		'
	)
}

