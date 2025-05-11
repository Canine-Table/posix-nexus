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

nx_tty_print()
{
	${AWK:-$(nx_cmd_awk)} \
		-v fmt="$1" \
		-v msg="$2" \
		-v sep="$3" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk" \
			"$G_NEX_MOD_LIB/awk/nex-log.awk"
		)
	"'
		BEGIN {
			print nx_printf(fmt, msg, sep)
		}
	'
}

nx_tty_prop_list()
{
	[ -n "$(tty)" ] && stty -a | ${AWK:-$(nx_cmd_awk)} '
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

nx_tty_prop()
{
	[ -n "$(tty)" ] && (
		while getopts :k:v: OPT; do
			case $OPT in
				k|v) eval "$OPT"="$OPTARG";;
			esac
		done
		shift $((OPTIND - 1))
		nx_tty_prop_list | ${AWK:-$(nx_cmd_awk)} \
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

nx_tty_hault()
{
	h_nx_cmd setterm && {
		setterm -cursor off
		trap 'setterm -cursor on' EXIT SIGINT SIGHUP
	}
	read -n 1 -s;
}

##############################################################################################

