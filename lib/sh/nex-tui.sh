
nx_tui_box()
{
	eval "export $(nx_tty_all)"
	eval "$(nx_str_optarg ':p:m:b:t:' "$@")"
	#export G_NEX_TTY_PADDING="$(nx_int_natural "$p" || printf '%d' 1)"
	#export G_NEX_TTY_MARGINS="$(nx_int_natural "$m" || printf '%d' 1)"
	export G_NEX_TTY_BOX="${b:-s}"
	${AWK:-$(get_cmd_awk)} \
		-v txt="$t" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-tui.awk")
	"'
		BEGIN {
			nx_tui(txt, arr)
			if ("tbdr" in arr)
				print arr["tbdr"]
			for (i = 1; i <= arr[0]; i++)
				print arr["lvl"] arr[i] arr["lvr"]
			if ("bbdr" in arr)
				print arr["bbdr"]
		}
	'
}

