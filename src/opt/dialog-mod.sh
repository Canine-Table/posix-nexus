#!/bin/sh

nx_dialog_factory()
{
	(
		eval "export $(nx_tty_all)"
		eval "$(nx_str_optarg ':i:v:m:l:f:p:' "$@")"
		DIALOG_ESC=255 DIALOG_ITEM_HELP=4 DIALOG_EXTRA=3 DIALOG_HELP=2 DIALOG_CANCEL=1 DIALOG_OK=0
		DIALOG_OPTIONS="$(${AWK:-$(get_cmd_awk)} \
			-v json="{
				'labels': [
					'message',
					'ok-label',
					'no-label',
					'backtitle',
					'cancel-label',
					'yes-label',
					'column-separator',
					'help-label',
					'default-item',
					'exit-label',
					'extra-label',
					'default-button',
					'title'
				],
				'variants': [
					'treeview',	'calendar',
					'buildlist',	'checklist',
					'dselect',	'fselect',
					'editbox',	'form',
					'tailbox',	'tailboxbg',
					'textbox',	'timebox',
					'infobox',	'inputbox',
					'inputmenu',	'menu',
					'mixedform',	'mixedgauge',
					'gauge',	'msgbox',
					'pause',	'passwordbox',
					'prgbox',	'passwordform',
					'radiolist',	'rangebox',
					'yesno',	'progressbox',
					'programbox'
				],
				'flags': {
					'ascii-lines': '<nx:false/>',
					'beep': '<nx:false/>',
					'beep-after': '<nx:false/>',
					'clear': '<nx:false/>',
					'colors': '<nx:false/>',
					'cr-wrap': '<nx:false/>',
					'cursor-off-label': '<nx:true/>',
					'defaultno': '<nx:true/>',
					'ignore': '<nx:false/>',
					'keep-tite': '<nx:false/>',
					'keep-window': '<nx:false/>',
					'last-key': '<nx:false/>',
					'no-cancel': '<nx:false/>',
					'no-hot-list': '<nx:false/>',
					'no-items': '<nx:false/>',
					'no-kill': '<nx:false/>',
					'no-lines': '<nx:false/>',
					'no-mouse': '<nx:false/>',
					'no-nl-expand': '<nx:false/>',
					'no-ok': '<nx:false/>',
					'no-shadow': '<nx:true/>',
					'no-tags': '<nx:false/>',
					'print-maxsize': '<nx:false/>',
					'print-size': '<nx:false/>',
					'print-version': '<nx:false/>',
					'quoted': '<nx:false/>',
					'reorder': '<nx:false/>',
					'scrollbar': '<nx:true/>',
					'single-quoted': '<nx:false/>',
					'size-err': '<nx:true/>',
					'stderr': '<nx:false/>',
					'stdout': '<nx:false/>',
					'tab-correct': '<nx:false/>',
					'trim': '<nx:false/>',
					'insecure': '<nx:true/>',
					'visit-items': '<nx:false/>',
					'no-collapse': '<nx:true/>',
					'erase-on-exit': '<nx:true/>'
				},
				'toggle': {
					'on': [
						'true',
						'yes',
						'on',
						1
					],
					'off': [
						'false',
						'no',
						'off',
						0
					]
				},
				'items': [
					'name',
					'depth',
					'state',
					'index',
					'value'
				],
				'input': {
					'variant': '$v',
					'message': '${m:- }',
					'labels': {$l},
					'properties': [$p],
					'items': [$i],
					'flags': [$f]
				}
			}
		" "
			$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-tui.awk")
		"'
			BEGIN {
				if (err = nx_json(json, arr, 2))
					exit err
				s = ""
				nx_json_split(".flags", arr, flgs)
				if (nx_json_type(".input.flags", arr) == 2) {
					l = arr[".nx.input.flags[0]"]
					for (i = 1; i <= l; i++) {
						if (k = nx_json_match(".flags", arr[".nx.input.flags[" i "]"], arr, flgs)) {
							nx_boolean(arr, ".nx.flags." k)
						}
					}
				}
				arr[".nx.input.variant"] = __nx_else(nx_json_match(".variants", arr[".nx.input.variant"], arr), "msgbox")
				nx_json_delete(".variants", arr)
				if (arr[".nx.input.variant"] !~ /^(password(box|form))$/)
					delete arr[".nx.flags.insecure"]
				if (arr[".nx.variant"] == "editbox")
					delete arr[".nx.flags.no-collapse"]
				for (i = 1; i <= flgs[0]; i++) {
					if (arr[".nx.flags." flgs[i]] == "<nx:true/>")
						s = s " --" flgs[i]
				}
				nx_json_delete(".flags", arr)
				nx_json_delete(".input.flags", arr)
				if (nx_json_type(".input.labels", arr) == 1) {
					nx_json_split(".labels", arr, flgs)
					nx_json_split(".input.labels", arr, opts)
					for (i = 1; i <= opts[0]; i++) {
						if ((k = nx_json_match(".labels", opts[i], arr, flgs)) && arr[".nx.input.labels." opts[i]] != "") {
							v = arr[".nx.input.labels." opts[i]]
							if (k == "message") {
								arr[".nx.input.message"] = v
							} else {
								if (k == "title") {
									v = "\xE2\x94\xA4 " v " \xE2\x94\x9C"
								} else if (k == "extra-label") {
									s = s " --extra-button"
								} else if (k == "help-label") {
									s = s " --help-button"
								}
								s = s " --" k " \x27" v "\x27"
							}
							delete flgs[k]
						}
					}
				}
				nx_json_delete(".labels", arr)
				nx_json_delete(".input.labels", arr)
				s = s " --trace \x27" __nx_else(ENVIRON["G_NEX_MOD_LOG"], "/var/log") "/nex-dialog.log\x27 --" arr[".nx.input.variant"] " \x27" __nx_else(arr[".nx.input.message"], " ") "\x27 " ENVIRON["G_NEX_TTY_ROWS"] " " ENVIRON["G_NEX_TTY_COLUMNS"]
				if (arr[".nx.input.variant"] ~ /^((password|mixed)?form|(radio|check|build)list|(input)?menu|treeview)$/) {
					nx_tui_log_db(db)
					if (nx_json_type(".input.items", arr) != 2) {
						print nx_log_error(nx_tui_log_db(db, 1, ".input.items[0] (-i)"))
						err = 120
					} else {
						s = s " " ENVIRON["G_NEX_TTY_ROWS"]
						nx_json_split(".toggle.off", arr, ste)
						nx_json_split(".items", arr, opts)
						for (i = 1; i <= arr[".nx.input.items[0]"]; i++) {
							nx_json_split(".input.items[" i "]", arr, flgs)
							do {
								if (k = nx_json_match(".items", flgs[flgs[0]], arr, opts)) {
									v = arr[".nx.input.items[" i "]." flgs[flgs[0]]]
									if (k == "state")
										v = __nx_if(nx_json_match(".toggle.off", v, arr, ste), "off", "on")
									arr[".nx.input.items[" i "]." k] = v
								}
							} while (--flgs[0])
							arr[".nx.input.items[" i "].name"] = __nx_else(arr[".nx.input.items[" i "].name"], i)
							if (arr[".nx.input.variant"] ~ /^((password|mixed)?form)$/) {
								kl = length(arr[".nx.input.items[" i "].name"])
								str = str " \x27" arr[".nx.input.items[" i "].name"] "\x27 " i " 2 \x27" arr[".nx.items[" i "].value"]  "\x27 " i " " kl + 4 " " ENVIRON["G_NEX_TTY_COLUMNS"] - kl - 10 " 0"
							} else if (arr[".nx.input.variant"] ~ /^((radio|check|build)list|treeview|menu)$/) {
								s = s " \x27" arr[".nx.input.items[" i "].name"] "\x27 \x27" arr[".nx.input.items[" i "].value"] "\x27 "
								if (arr[".nx.input.variant"] != "menu") {
									if (arr[".nx.input.variant"] == "radiolist") {
										if (arr[".nx.input.items[" i "].state"] == "on" && 0 in ste)
											delete ste
										else
											arr[".nx.input.items[" i "].state"] = "off"
									}
									s = s " " __nx_else(arr[".nx.input.items[" i "].state"], "off")
								}
							}
							nx_json_delete(".input.items[" i "]", arr)
						}
						delete ste
					}
				}
				delete arr
				delete opts
				delete flgs
				if (err)
					exit err
				print s
			}
		')" || {
			DIALOG_EXIT_STATUS=$?
			echo -e "$DIALOG_OPTIONS"
			exit $DIALOG_EXIT_STATUS
		}
		DIALOG_OPTIONS=$(eval "dialog $DIALOG_OPTIONS" 3>&1 1>&2 2>&3)
		DIALOG_EXIT_STATUS=$?
		echo "$DIALOG_OPTIONS"
		return $DIALOG_EXIT_STATUS
	)
}


