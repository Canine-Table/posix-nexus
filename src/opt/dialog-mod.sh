#!/bin/sh

nx_dialog_factory()
{
	(
		eval "export $(nx_tty_all)"
		eval "$(nx_str_optarg ':i:v:m:l:f:p:' "$@")"
		DIALOG_ESC=255 DIALOG_ITEM_HELP=4 DIALOG_EXTRA=3 DIALOG_HELP=2 DIALOG_CANCEL=1 DIALOG_OK=0
		DIALOG_OPTIONS=$(eval " dialog $(${AWK:-$(get_cmd_awk)} \
			-v json="{
				'variant': '$v',
				'message': '${m:- }',
				'labels': {$l},
				'properties': [$p],
				'items': [$i],
				'flags': [$f]
			}
		" "
			$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-tui.awk")
		"'
			BEGIN {
				if (l = nx_json(json, arr, 2))
					exit l
				if (".nx.flags[0]" in arr) {
					l = arr[".nx.flags[0]"]
					nx_vector("ascii-lines,beep,beep-after,clear,colors,cr-wrap,cursor-off-label,defaultno,erase-on-exit,ignore,keep-tite,keep-window,last-key,no-cancel,no-hot-list,no-items,no-kill,no-lines,no-mouse,no-nl-expand,no-ok,no-shadow,no-tags,print-maxsize,print-size,print-version,quoted,reorder,scrollbar,single-quoted,size-err,stderr,stdout,tab-correct,trim,visit-items", vec)
					do {
						if (k = nx_option(tolower(arr[".nx.flags[" l "]"]), vec))
							str = str "--" k " "
					} while (--l)
					delete vec
				}
				if (".nx.labels" in arr) {
					l = split(arr[".nx.labels"], opt, "<nx:null/>")
					nx_vector("message,ok-label,no-label,backtitle,cancel-label,yes-label,column-separator,help-label,default-item,exit-label,extra-label,default-button,title", vec)
					do {
						if (k = nx_option(tolower(opt[l]), vec)) {
							if (k == "message" && arr[".nx.labels." opt[l]] != "") {
								arr[".nx.message"] = arr[".nx.labels." opt[l]]
							} else {
								if (k == "title") {
									arr[".nx.labels." opt[l]] = "\xE2\x94\xA4\x00 " arr[".nx.labels." opt[l]] " \xE2\x94\x9C\x00"
								} else if (k == "extra-label") {
									str = str "--extra-button "
								} else if (k == "help-label") {
									str = str "--help-button "
								}
								str = "--" k " \x27" arr[".nx.labels." opt[l]] "\x27 "
							}
						}
					} while (--l)
					delete vec
				}
				nx_vector("treeview,calendar,buildlist,checklist,dselect,fselect,editbox,form,tailbox,tailboxbg,textbox,timebox,infobox,inputbox,inputmenu,menu,mixedform,mixedgauge,gauge,msgbox,passwordform,passwordbox,pause,prgbox,programbox,progressbox,radiolist,rangebox,yesno", vec)
				arr[".nx.variant"] = __nx_else(nx_option(tolower(arr[".nx.variant"]), vec), "infobox")
				delete vec
				if (arr[".nx.variant"] ~ /^(password(box|form))$/)
					str = str "--insecure "
				if (arr[".nx.variant"] != "editbox")
					str = str "--no-collapse "
				err = 0
				str = str "--erase-on-exit --scrollbar --visit-items --trace \x27" __nx_else(ENVIRON["G_NEX_MOD_LOG"], "/var/log") "/nex-dialog.log\x27 --" arr[".nx.variant"] " \x27" arr[".nx.message"] "\x27 " ENVIRON["G_NEX_TTY_ROWS"] " " ENVIRON["G_NEX_TTY_COLUMNS"] " "
				if (arr[".nx.variant"] ~ /^((password|mixed)?form|(radio|check|build)list|(input)?menu|treeview)$/) {
					if (! (".nx.items[0]" in arr)) {
						print nx_log_error(nx_tui_log_db(db, 1, ".nx.item[0]"))
						err = 120
					} else {
						str = str ENVIRON["G_NEX_TTY_ROWS"] " "
						l = split("no,false,off,0", ste, ",")
						ste[0] = l
						nx_vector("name,depth,state,index,value", vec)
						for (l = 1; l <= arr[".nx.items[0]"]; l++) {
							i = split(arr[".nx.items[" l "]"], opt, "<nx:null/>")
							do {
								if (k = nx_option(tolower(opt[i]), vec)) {
									v = arr[".nx.items[" l "]." opt[i]]
									if (k == "state")
										v = __nx_if(nx_option(tolower(v), vec), "off", "on")
									v = arr[".nx.items[" l "]." k] = v
								}
							} while (--i)
							arr[".nx.items[" l "].name"] = __nx_else(arr[".nx.items[" l "].name"], l)
							if (arr[".nx.variant"] ~ /^((password|mixed)?form)$/) {
								kl = length(arr[".nx.items[" l "].name"])
								str = str "\x27" arr[".nx.items[" l "].name"] "\x27 " l " 2 \x27" arr[".nx.items[" l "].value"]  "\x27 " l " " kl + 4 " " ENVIRON["G_NEX_TTY_COLUMNS"] - kl - 10 " 0 "
							} else if (arr[".nx.variant"] ~ /^((radio|check|build)list|treeview|menu)$/) {
								str = str "\x27" arr[".nx.items[" l "].name"] "\x27 \x27" arr[".nx.items[" l "].value"] "\x27 "
								if (arr[".nx.variant"] != "menu") {
									if (arr[".nx.variant"] == "radiolist") {
										if (arr[".nx.items[" l "].state"] == "on" && 0 in ste)
											delete ste
										else
											arr[".nx.items[" l "].state"] = "off"
									}
									str = str __nx_else(arr[".nx.items[" l "].state"], "off") " "
								}
							}
						}
					}
				}
				delete arr; delete opt; delete db
				delete ste; print str
				exit err
			}
		')" 3>&1 1>&2 2>&3)
		DIALOG_EXIT_STATUS=$?
		echo "$DIALOG_OPTIONS"
		return $DIALOG_EXIT_STATUS
	)
}

