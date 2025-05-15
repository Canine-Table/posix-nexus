
nx_tui_box()
{
	(
		eval "export $(nx_tty_all)"
		#echo -e "\x1bc"
		${AWK:-$(get_cmd_awk)} \
			-v bdr="$1" \
			-v mesg="${2:-$( cat "$G_NEX_MOD_ENV/file.tui")}" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
				"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
				"$G_NEX_MOD_LIB/awk/nex-str.awk" \
				"$G_NEX_MOD_LIB/awk/nex-tui.awk" \
				"$G_NEX_MOD_LIB/awk/nex-math.awk"
			)
		"'
			BEGIN {
				nx_tui(mesg, __nx_else(bdr, "s"), arr)
				for (i = 1; i <= arr[0]; i++)
					print arr[i]
			}
		'
	)
}

