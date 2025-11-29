#nx_include nex-str.sh
#nx_include nex-data.sh

nx_tty_print()
(
	${AWK:-$(nx_cmd_awk)} \
		-v inpt="$(nx_str_chain "$@")" \
		"
			$(nx_data_include -i "${NEXUS_LIB}/awk/nex-log-extras.awk")
		"'
			BEGIN {
				ln = split(inpt, flds, "<nx:null/>")
				trk["sig"] = "<nx:true/>"
				trk["bg"] = ""
				for (i = 1; i <= ln; i++) {
					if (sub(/^-/, "", flds[i])) {
						inpt = tolower(flds[i])
						trk["col"] = flds[i]
						if (inpt == "l") {
							nx_ansi_light(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "b") {
							nx_ansi_dark(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "s") {
							nx_ansi_success(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "w") {
							nx_ansi_warning(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "e") {
							nx_ansi_error(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "d") {
							nx_ansi_debug(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "a") {
							nx_ansi_alert(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "i") {
							nx_ansi_info(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "g") {
							if (flds[i+1] == "-R") {
								trk["bg"] = ""
								i++
							} else {
								nx_boolean(trk, "bg")
							}
						} else if (flds[i] == "c") {
							if (flds[i+1] == "-R") {
								trk["sig"] = ""
								i++
							} else {
								nx_boolean(trk, "sig")
							}
						}
					} else {
						nx_ansi_print(flds[i] "<nx:null/>" flds[i])
					}
				}
				delete flds
			}
		'
)

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
