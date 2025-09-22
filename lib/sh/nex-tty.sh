
nx_tty_all()
{
	h_nx_cmd tty stty && [ -n "$(tty)" ] && {
		${AWK:-$(nx_cmd_awk)} \
			-v tt="$(stty --all)" \
		"
			$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str.awk")
		"'
			BEGIN {
				gsub(/ = |[\t\n\v\f\r]/, " ", tt)
				tt = split (tt, arr, "; *")
				l = split(arr[tt], flgv, " ")
				do {
					if (sub(/-/, "", flgv[l]))
						v = "<nx:false/>"
					else
						v = "<nx:true/>"
					r = nx_join_str(r, "G_NEX_TTY_" toupper(flgv[l]) "=\x27" v "\x27", " ")
				} while (--l)
				split("", flgv, "")
				while(--tt) {
					if (arr[tt] !~ /^ *$/) {
						nx_pair_str(arr[tt], flgv, " ")
						r = nx_join_str(r, "G_NEX_TTY_" toupper(flgv[flgv[0]]) "=\x27" flgv[flgv[flgv[0]]] "\x27", " ")
					}
				}
				print r
			}
		'
	}
}

nx_tty_div()
(
	eval $(nx_tty_all) || exit
	case "$1" in
		-s) tmpa="─";;
		-t) tmpa='━';;
		-j) tmpa='╍';;
		-r) tmpa='╼';;
		-l) tmpa='╾';;
		*) tmpa="═";;
	esac
	nx_str_append "$G_NEX_TTY_COLUMNS" "$tmpa"
)

nx_tty_hault()
{
	trap "printf '\x1b[?25h'" EXIT HUP INT
	printf '\x1b[?25l'
	tmpa="$(nx_int_natural "$1")"
	read -n 1 -s ${tmpa:+-t $tmpa} tmpa
}

