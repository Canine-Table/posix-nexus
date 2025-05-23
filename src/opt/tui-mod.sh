nx_tui_box()
{
	(
		eval "export $(nx_tty_all)"
		export G_NEX_TTY_PADDING=1
		export G_NEX_TTY_MARGINS=1
		export G_NEX_TTY_BOX="s"
		${AWK:-$(get_cmd_awk)} \
			-v bdr="$1" \
			-v mesg="${2:-$(cat "$G_NEX_MOD_ENV/file.tui")}" \
			"
				$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-tui.awk")
		"'
			BEGIN {
				nx_tui(mesg, arr, 5)
				#if ("tbdr" in arr)
				#	print arr["tbdr"]
				for (i = 1; i <= arr[0]; i++)
					print arr[i]
					#print arr["lvl"] arr[i] arr["lvr"]
				#if ("bbdr" in arr)
				#	print arr["bbdr"]
			}
		'
	)
}

nx_tui_shell()
{
	(
		trap 'nx_io_fifo_mgr -r "$nx_fifo"; echo -e "\x1b[?1049l\x1b[?1003l\x1b[?1015l\x1b[?1000l\x1b[H\x1b[2J\x1b[u"' EXIT SIGINT
		nx_fifo="$(nx_io_fifo_mgr -c)"
		${AWK:-$(get_cmd_awk)} \
			-v nx_fifo="$(echo "$nx_fifo")"
		"
			$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-tui.awk")
		"'
			BEGIN {
				while (1) {
					getline line < nx_fifo
					print line
					close(nx_fifo)
				}
			}
		' &
		P="$(nx_io_printf -f "_b>e%_iu>l%_IU>e%_i>s%" \
			"\n┌{" \
			"Posix-Nexus Shell" \
			"}\n│\n└" \
			"\$ "
		)"
		echo -e "\x1b[s\x1b[H\x1b[2J\x1b[?1000h\x1b[?1015h\x1b[?1003h\x1b[?1049h"
		while :; do
			read -p "$P"
			[ "$REPLY" = 'exit' ] && exit
			echo "$REPLY" > $nx_fifo
		done
	)
	nx_io_printf -f "_bi>s%_I>l%>e%" "\n\tBye" " :" ")\n"
}

