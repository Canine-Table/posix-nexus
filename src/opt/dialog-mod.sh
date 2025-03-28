#!/bin/sh

__get_dialog_factory()
{
	R="$(get_tty_prop -k 'rows')"
	C="$(get_tty_prop -k 'columns')"
	DIALOG_ESC=255 DIALOG_ITEM_HELP=4 DIALOG_EXTRA=3 DIALOG_HELP=2 DIALOG_CANCEL=1 DIALOG_OK=0
	while getopts :v:m:b:p:e: OPT; do
		case $OPT in
			v|m|b|p) eval "$OPT"="'$OPTARG'";;
		esac
	done
	shift $((OPTIND - 1))
	${AWK:-$(get_cmd_awk)} \
		-v vrnt="${v:-msgbox}" \
		-v msg="$m" \
		-v bol="$b" \
		-v param="$p" \
		-v columns="$C" \
		-v rows="$R" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/bool.awk" \
			"$G_NEX_MOD_LIB/awk/structs.awk" \
			"$G_NEX_MOD_LIB/awk/algor.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk"
		)
	"'
		BEGIN {
			if (length(bol)) {
				for(i = 1; i <= trim_split(bol, arr, ","); i++) {
					if (k = match_option(tolower(arr[i]), "ascii-lines,beep,beep-after,clear,colors,cr-wrap,cursor-off-label,defaultno,erase-on-exit,ignore,keep-tite,keep-window,last-key,no-cancel,no-hot-list,no-items,no-kill,no-lines,no-mouse,no-nl-expand,no-ok,no-shadow,no-tags,print-maxsize,print-size,print-version,quoted,reorder,scrollbar,single-quoted,size-err,stderr,stdout,tab-correct,trim,visit-items"))
						printf("--%s ", k)
				}
			}
			if (length(msg)) {
				for(i = 1; i <= trim_split(msg, arr, ","); i++) {
					if (k = match_option(tolower(__get_half(arr[i], "=", 1)), "ok-label,message,no-label,backtitle,cancel-label,yes-label,column-separator,help-label,default-item,exit-label,extra-label,default-button,title")) {
						w = __get_half(arr[i], "=")
						if (k == "message") {
							msg = w
						} else {
							if (k == "title") {
								w = "┤ " w " ├"
							} else if (k == "extra-label") {
								printf("--extra-button ")
							} else if (k == "help-label") {
								printf("--help-button ")
							}
							printf("--%s \x22%s\x22 ", k, w)
						}
					} else {
						msg = arr[i]
					}
				}
			}
			vrnt = __return_value(match_option(tolower(vrnt), "treeview,calendar,buildlist,checklist,dselect,fselect,editbox,form,tailboxfg,tailboxbg,textbox,timebox,infobox,inputbox,inputmenu,menu,mixedform,mixedgauge,gauge,msgbox,passwordform,passwordbox,pause,prgbox,programbox,progressbox,radiolist,rangebox,yesno"), "infobox")
			if (vrnt ~ /^(password(box|form))$/)
				printf("--%s ", "insecure")
			printf("%s ", "--no-collapse")
			printf("--%s ", vrnt)
			printf("\x22%s\x22 ", msg)
			printf("%s %s ", rows, columns)
			if (vrnt ~ /^((password|mixed)?form|(radio|check|build)list|(input)?menu|treeview)$/) {
				printf("%s ", rows)
				for (i = 1; i <= trim_split(param, arr, ","); i++) {
					st = ""
					k = ""
					w = ""
					if (st = tolower(__get_half(arr[i], ":"))) {
						arr[i] = __get_half(arr[i], ":", 1)
						if (match_option(st, "no,false,off,0"))
							st = "off"
						else if (match_option(st, "yes,true,on,ok,1"))
							st = "on"
					}
					st = __return_value(st, "off")
					k = __get_half(arr[i], "=", 1)
					w = __get_half(arr[i], "=")
					if (vrnt ~ /^((password|mixed)?form)$/) {
						#<label1> <l_y1> <l_x1> <item1> <i_y1> <i_x1> <flen1> <ilen1>
						printf("\x22%s\x22: %d %d ", k, i, 2)
						printf("\x22%s\x22 %d %d ", w, i, length(k) + 4)
						printf("%d %d ", columns - length(k) - 12, 0)
					} else if (vrnt ~ /^((radio|check|build)list)$/) {
						if (vrnt == "radiolist") {
							if (st == "on" && ! _st)
								_st = 1
							else
								st = "off"
						}
						printf("\x22 %s \x22 \x22 %s \x22 %s ", k, w, st)
					}
				}
			} else if (vrnt ~ /^((tailbox(bg|fg))|(msg|edit|time|text|progress|info|program|range)box|(f|d)select|calendar|gauge|pause|yesno)$/) {
			}
		}
	'
}


get_dialog_explorer()
{
	{
		trap 'exec 7>&-' EXIT SIGINT SIGHUP
		exec 7>&2
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory "$@")" 3>&1 1>&7 7>&3)
		DIALOG_EXIT_STATUS=$?
		set_tty_hault
		return $DIALOG_EXIT_STATUS
	}
}

get_dialog_menu()
{
	{
		trap 'exec 7>&-' EXIT SIGINT SIGHUP
		exec 7>&2
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory "$@")" 3>&1 1>&7 7>&3)
		DIALOG_EXIT_STATUS=$?
		set_tty_hault
		return $DIALOG_EXIT_STATUS
	}
}


get_dialog_form()
{
	{
		trap 'exec 7>&-' EXIT SIGINT SIGHUP
		exec 7>&2
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory "$@")" 3>&1 1>&7 7>&3)
		DIALOG_EXIT_STATUS=$?
		set_tty_hault
		return $DIALOG_EXIT_STATUS
	}
}

get_dialog_box()
{
	{
		trap 'exec 7>&-' EXIT SIGINT SIGHUP
		exec 7>&2
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory "$@")" 3>&1 1>&7 7>&3)
		DIALOG_EXIT_STATUS=$?
		set_tty_hault
		return $DIALOG_EXIT_STATUS
	}
}

