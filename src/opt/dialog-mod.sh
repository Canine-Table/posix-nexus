#!/bin/sh

nx_dialog_factory()
{
	(
		#eval "export $(nx_tty_all)"
		eval "$(nx_str_optarg ':v:m:l:b:' "$@")"
		DIALOG_ESC=255 DIALOG_ITEM_HELP=4 DIALOG_EXTRA=3 DIALOG_HELP=2 DIALOG_CANCEL=1 DIALOG_OK=0
		${AWK:-$(get_cmd_awk)} \
			-v json="{
				'variant': '$v',
				'message': '${m:- }',
				'label': {$l},
				'boolean': [$b]
			}
		" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
				"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
				"$G_NEX_MOD_LIB/awk/nex-log.awk" \
				"$G_NEX_MOD_LIB/awk/nex-str.awk" \
				"$G_NEX_MOD_LIB/awk/nex-math.awk" \
				"$G_NEX_MOD_LIB/awk/nex-json.awk"
			)
		"'
			BEGIN {
				#print ENVIRON["G_NEX_TTY_ROWS"]
				#print ENVIRON["G_NEX_TTY_COLUMNS"]
				if (! (i = nx_json(json, arr, 2))) {
				#nx_option(D, V1, V2, B1, B2,   i, v1)

				nx_vector("treeview,calendar,buildlist,checklist,dselect,fselect,editbox,form,tailbox,tailboxbg,textbox,timebox,infobox,inputbox,inputmenu,menu,mixedform,mixedgauge,gauge,msgbox,passwordform,passwordbox,pause,prgbox,programbox,progressbox,radiolist,rangebox,yesno", vec)
				arr[".nx.variant"] = __nx_else(nx_option(tolower(arr[".nx.variant"]), vec), "infobox")
				delete vec
				if (".nx.label" in arr) {
					l = split(arr[".nx.label"], opt, "<nx:null/>")
					nx_vector("ok-label,no-label,backtitle,cancel-label,yes-label,column-separator,help-label,default-item,exit-label,extra-label,default-button,title", vec)
					do {
						if (k = nx_option(tolower(opt[l]), vec)) {
							#print k
						}
					} while (--l)
					delete vec
				}
				for (i in arr)
					print "arr[" i "] = " arr[i]
				}
			}
		'
	)
}

