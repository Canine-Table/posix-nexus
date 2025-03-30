#!/bin/sh

__get_dialog_factory()
{
	(
		__get_dialog_size 'R_GDF' 'C_GDF'
		DIALOG_ESC=255 DIALOG_ITEM_HELP=4 DIALOG_EXTRA=3 DIALOG_HELP=2 DIALOG_CANCEL=1 DIALOG_OK=0
		while getopts :v:m:b:p:e: OPT; do
			case $OPT in
				v) v_gdf="$OPTARG";;
				m|b|p|e) eval "${OPT}_gdf"="'$(get_struct_ref_append "${OPT}_gdf" "$OPTARG" ',')'";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(get_cmd_awk)} \
			-v vrnt="${v_gdf:-${v:-msgbox}}" \
			-v msg="${m_gdf:-$m}" \
			-v bol="${b_gdf:-$b}" \
			-v ext="${e_gdf:-$e}" \
			-v rmdr="$@" \
			-v param="${p_gdf:-$p}" \
			-v columns="${C_DGF:-$C}" \
			-v rows="${R_GDF:-$R}" "
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
				if (length(ext)) {
					for(i = 1; i <= trim_split(ext, arr, ","); i++) {
						if (k = match_option(tolower(__get_half(arr[i], "=", 1)), "auto,rows,columns")) {
							w = __get_half(arr[i], "=")
							if (k == "auto" && ! (cl || rw)) {
								cl = columns
								columns = 0
								rw = rows
								rows = 0
						} else if (is_integral(w)) {
								if (k == "rows" && w < __return_value(rows, rw))
									rows = w
								else if (k == "columns" && w < __return_value(columns, cl))
									columns = w
							}
						}
					}
				}
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
				vrnt = __return_value(match_option(tolower(vrnt), "treeview,calendar,buildlist,checklist,dselect,fselect,editbox,form,tailbox,tailboxbg,textbox,timebox,infobox,inputbox,inputmenu,menu,mixedform,mixedgauge,gauge,msgbox,passwordform,passwordbox,pause,prgbox,programbox,progressbox,radiolist,rangebox,yesno"), "infobox")
				if (vrnt ~ /^(password(box|form))$/)
					printf("--%s ", "insecure")
				if (vrnt != "editbox")
					printf("--%s ", "no-collapse")
				printf("%s ", "--erase-on-exit --scrollbar")
				printf("--trace \x22%s\x22 ", __return_value(ENVIRON["G_NEX_MOD_LOG"], "/var/log"), "/nex-dialog.log")
				printf("--%s ", vrnt)
				printf("\x22%s\x22 ", __return_value(msg, " "))
				if (vrnt == "calendar")
					printf("0 0 ")
				else
					printf("%s %s ", rows, columns)
				if (vrnt ~ /^((password|mixed)?form|(radio|check|build)list|(input)?menu|treeview)$/) {
					printf("%s ", rows)
					l = trim_split(param, arr, ",")
					for (i = 1; i <= l; i++) {
						st = ""
						dth = ""
						k = ""
						w = ""
						if (dth = __get_half(arr[i], ">")) {
							if (! is_integral(dth))
								dth = 0
							arr[i] = __get_half(arr[i], ">", 1)
						}
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
							printf("%d %d ", columns - length(k) - 10, 0)
						} else if (vrnt ~ /^((radio|check|build)list|treeview|menu)$/) {
							printf("\x22 %s \x22 \x22 %s \x22 ", k, w)
							if (vrnt != "menu") {
								if (vrnt == "radiolist") {
									if (st == "on" && ! _st)
										_st = 1
									else
										st = "off"
								}
								printf("%s ", st)
								if (vrnt == "treeview")
									printf("%s ", __return_value(dth, 0))
							}
						}
					}
				} else if (vrnt ~ /^((tailbox(bg)?)|(msg|edit|time|text|progress|info|program|range)box|(f|d)select|calendar|gauge|pause|yesno)$/) {
					# TODO
				}
			}
		'
	)
}

__get_dialog_size()
{
	eval "${1:-R}"="$(get_tty_prop -k 'rows')"
	eval "${2:-C}"="$(get_tty_prop -k 'columns')"
}

__get_dialog_output()
{
	${AWK:-$(get_cmd_awk)} \
		-v opt="$1" \
		-v fld="$2" \
		-v dft="${3:-0}" "
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
			l = trim_split(opt, arr, "\n")
			trim_split(fld, flds, ",")
			for (i = 1; i <= l; i++) {
				k = __get_half(flds[i], "=", 1)
				if (dft)
					w = __return_value(arr[i], __get_half(flds[i], "="))
				else
					w = __get_half(flds[i], "=")
				gsub(/ /, "_", k)
				gsub(/(^[0-9]+|[^a-zA-Z0-9_])/, "", k)
				printf("%s=\x22%s\x22 ", k, w)
			}
			delete flds
			delete arr
		}
	'
}

__get_dialog_selected()
{
	${AWK:-$(get_cmd_awk)} \
		-v opt="$1" \
		-v fld="$2" "
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
			sl = 0
			l = trim_split(opt, arr, "\x22")
			m = split_parameters(fld, flds, ",", "=")
			for (i = 1; i <= l; i++) {
				if (arr[i] in flds) {
					k = arr[i]
					gsub(/ /, "_", k)
					gsub(/(^[0-9]+|[^a-zA-Z0-9_])/, "", k)
					printf("%s=\x22%s\x22 %s=\x22%s\x22 ", "GDF_SL_" ++sl, k, k, __return_value(__get_half(flds[arr[i]], ":", 1), flds[arr[i]]))
				}
			}
			printf("%s=\x22%s\x22 ", "GDF_SL", sl)
			delete flds
			delete arr
		}
	'
}

get_dialog_explorer()
{
	(
		__get_dialog_size
		eval $(get_str_parser 'v:f:e:m:b:p:' "$*")
		v="$(set_struct_opt -i "$v" -r "fselect,dselect,textbox,editbox,tailboxbg,tailbox")"
		[ -z "$f" -a -n "$1" ] && {
			f="$(get_content_path "$1")"
			shift
		} || {
			f="$(get_content_path "$f")"
		}
		[ -r "$f" ] && {
			[ -f "$f" ] && {
				[ "$v" = 'dselect' ] && {
					v="textbox"
				}
			}
			[ -d "$f" -a -x "$f" ] && {
				v="dselect"
			}
		}
		[ -z "$v" ] && {
			exit 1
		}
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory ${p:+-p "$p"} ${e:+-e "$e"}  ${m:+-m "$m"} ${b:+-b "$b"} -v $v -m "$f")" 3>&1 1>&7 7>&3)
		DIALOG_EXIT_STATUS=$?
		echo "$DIALOG_OPTIONS"
		return $DIALOG_EXIT_STATUS
	)
}

get_dialog_yn()
{
	(
		__get_dialog_size
		eval $(get_str_parser 'v:e:m:b:p:' "$*")
		v="$(set_struct_opt -i "$v" -r "yesno,msgbox")"
		eval "dialog $(__get_dialog_factory ${p:+-p "$p"} ${e:+-e "$e"}  ${m:+-m "$m"} ${b:+-b "$b"} -v ${v:-yesno})"
	)
}

get_dialog_cal()
{
	(
		eval $(get_str_parser 'e:m:b:p:' "$*")
		v="calendar"
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory ${p:+-p "$p"} ${e:+-e "$e"}  ${m:+-m "$m"} ${b:+-b "$b"} -v $v -m "$f") $(date +"%d %m %y")" 3>&1 1>&2 2>&3)
		DIALOG_EXIT_STATUS=$?
		echo "$DIALOG_OPTIONS"
		return $DIALOG_EXIT_STATUS
	)
}

get_dialog_time()
{
	(
		__get_dialog_size
		eval $(get_str_parser 'v:e:m:b:p:' "$*")
		v="$(set_struct_opt -i "$v" -r "pause,timebox")"
		[ "$1" = '-t' ] && {
			t="$2"
		} || {
			[ "$v" = "pause" ] && t="59" || t="23 59 59"
		}
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory ${p:+-p "$p"} ${e:+-e "$e"}  ${m:+-m "$m"} ${b:+-b "$b"} -v ${v:-timebox}) $t" 3>&1 1>&2 2>&3)
		DIALOG_EXIT_STATUS=$?
		echo "$DIALOG_OPTIONS"
		return $DIALOG_EXIT_STATUS
	)
}

get_dialog_form()
{
	(
		__get_dialog_size
		eval $(get_str_parser 'v:e:m:b:p:d' "$*")
		v="$(set_struct_opt -i "$v" -r "form,passwordform,mixedform")"
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory ${p:+-p "$p"} ${e:+-e "$e"}  ${m:+-m "$m"} ${b:+-b "$b"} -v ${v:-form})" 3>&1 1>&2 2>&3)
		DIALOG_EXIT_STATUS=$?
		__get_dialog_output "$DIALOG_OPTIONS" "$p" "$d"
		return $DIALOG_EXIT_STATUS
	)
}

get_dialog_menu()
{
	(
		__get_dialog_size
		eval $(get_str_parser 'v:e:m:b:p:' "$*")
		v="$(set_struct_opt -i "$v" -r "radiolist,checklist,buildlist,inputmenu,menu,treeview")"
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory ${p:+-p "$p"} ${e:+-e "$e"}  ${m:+-m "$m"} ${b:+-b "$b"} -v ${v:-menu})" 3>&1 1>&2 2>&3)
		DIALOG_EXIT_STATUS=$?
		__get_dialog_selected "$DIALOG_OPTIONS" "$p"
		return $DIALOG_EXIT_STATUS
	)
}

