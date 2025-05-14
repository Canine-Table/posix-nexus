
nx_tui_box()
{
	(
		eval "export $(nx_tty_all)"
		echo -e "\x1bc"
		${AWK:-$(get_cmd_awk)} \
			-v mesg=$@ \ "
			$(cat \
				"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
				"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
				"$G_NEX_MOD_LIB/awk/nex-str.awk" \
				"$G_NEX_MOD_LIB/awk/nex-tui.awk" \
				"$G_NEX_MOD_LIB/awk/nex-math.awk"
			)
		"'
			BEGIN {
				nx_tui(mesg)
			}
		'
	)
}

