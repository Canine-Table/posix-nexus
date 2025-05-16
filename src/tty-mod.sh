#!/bin/sh

###:( get ):##################################################################################

nx_tty_all()
{
	h_nx_cmd tty stty && [ -n "$(tty)" ] && {
		${AWK:-$(nx_cmd_awk)} \
			-v tt="$(stty --all)" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
				"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
				"$G_NEX_MOD_LIB/awk/nex-str.awk" \
				"$G_NEX_MOD_LIB/awk/nex-math.awk"
			)
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

nx_tty_hault()
{
	h_nx_cmd setterm && {
		setterm -cursor off
		trap 'setterm -cursor on' EXIT SIGINT SIGHUP
	}
	read -n 1 -s;
}

##############################################################################################

