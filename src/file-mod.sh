#!/bin/sh

get_file_list() {
	(
		for i in "$@"; do
			d="$(get_content_container "$i")"
			get_content_filter_list -fhrD $(
				for fl in "$d/"*; do
					echo "$fl"
				done
			)
		done
	)
}

get_file_contents() {
	(
		while getopts :f:b: OPT; do
                        case $OPT in
                                b) eval "$OPT"="'${OPTARG:-true}'";;
				f) f="$f${f:+\n}$(get_content_path "$OPTARG")";;
                        esac
                done
                shift $((OPTIND - 1))
		[ -z "$f" ] && {
			f="$(get_file_list $*)"
			[ -n "$f" ] || exit
		} || f="$(echo -e "$f")"
		f="$(get_struct_clist -u -s '\n' -o ' ' "$f")" 
		c="$(get_tty_prop -k "columns")"
		$(get_cmd_awk) \
			-v col="$c" \
			-v bdr="$b" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/strings.awk" \
				"$G_NEX_MOD_LIB/awk/struct.awk" \
				"$G_NEX_MOD_LIB/awk/tui.awk" \
				"$G_NEX_MOD_LIB/awk/files.awk"
			)
		"'
			BEGIN {
				if (! (b = complete_opt(bdr, "single, double")))
					b = bdr
				if (! b)
					b = "single"
				load_borders(b, sep)
			} {
				if (FILENAME)
					outfile(FILENAME, $0, col)
			} END {
				printf("%s%s%s\n", append(6, borders[10]) ,borders[8], append(col - 7, borders[10]))
			}
		' $f | $(get_cmd_pager)
	)
}

get_file_shell() {
        (
                get_out_color_support && csup='true'
                add_str_div
                echo -e "$(get_out_style -F 'yellow' -t 'bold' "nexus root")\x1b[1;37m: \x1b[0;4m""$(get_content_path "$G_NEX_ROOT")"
                echo -e "$(get_out_style -F 'green' -t 'bold' "nexus mod")\x1b[1;37m: \x1b[0;4m""$(get_content_path "$G_NEX_MOD_SRC")"
                echo -e "$(get_out_style -F 'teal' -t 'bold' "nexus lib")\x1b[1;37m: \x1b[0;4m""$(get_content_path "$G_NEX_MOD_LIB")"
                add_str_div
                for i in $(get_file_list "$G_NEX_MOD_SRC"); do
                        echo -e "\n$(get_out_style -F 'blue' -t 'bold' "$(get_content_leaf "$i" | sed 's/[.]sh$//')")\x1b[1;37m:""$(
                                $(get_cmd_awk) \
                                        -v csup="$csup" "
                                        $(
                                                cat "$G_NEX_MOD_LIB/awk/strings.awk"
                                        )
                                "'
                                        BEGIN {
                                                lst = "->"
                                                if (csup)
                                                        lst = "\x1b[1;33m" lst "\x1b[3;37m"
                                        }
                                        {
                                                sub(/^ *function/, "", $0)
                                                cur = trim($0)
                                                if (cur ~ /^[a-zA-Z]+([0-9a-zA-Z_]+)? *\(\) */)
                                                        printf("\n\t%s %s", lst, substr(cur, 1, index(cur, "(") - 1))
                                        }
                                ' "$i"
                        )"
                done
                echo ''
                add_str_div
        ) | $(get_cmd_pager)
}


###:( get ):##################################################################################
###:( set ):##################################################################################
###:( new ):##################################################################################
###:( add ):##################################################################################
###:( del ):##################################################################################
###:( is ):###################################################################################

