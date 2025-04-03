#!/bin/sh

__get_dialog_factory_options()
{
	eval $(
		while getopts :v:m:b:p:c:e: OPT; do
			case $OPT in
				v|c) eval "${OPT}_gdf"="'$OPTARG'";;
				m|b|p|e) eval "${OPT}_gdf"="'$(get_struct_ref_append "${OPT}_gdf" "$OPTARG" ',')'";;
			esac
		done
		echo -n "GDF_OPTIND=$((OPTIND - 1)) "
		echo -n "${v_gdf:+v_gdf='$v_gdf'} "
		echo -n "${m_gdf:+m_gdf='$m_gdf'} "
		echo -n "${b_gdf:+b_gdf='$b_gdf'} "
		echo -n "${p_gdf:+p_gdf='$p_gdf'} "
		echo -n "${e_gdf:+e_gdf='$e_gdf'} "
		echo -n "${c_gdf:+c_gdf='$c_gdf'} "
	)
}

__get_dialog_factory()
{
	__get_dialog_size 'R_GDF' 'C_GDF'
	DIALOG_ESC=255 DIALOG_ITEM_HELP=4 DIALOG_EXTRA=3 DIALOG_HELP=2 DIALOG_CANCEL=1 DIALOG_OK=0
	__get_dialog_factory_options "$@"
	shift $GDF_OPTIND
	${AWK:-$(get_cmd_awk)} \
		-v vrnt="${v_gdfe:-${v_gdf:-msgbox}}" \
		-v msg="${m_gdfe:-$m_gdf}" \
		-v cmd="${c_gdfe:-$c_gdf}" \
		-v bol="${b_gdfe:-$b_gdf}" \
		-v ext="${e_gdfe:-$e_gdf}" \
		-v param="${p_gdfe:-$p_gdf}" \
		-v columns="${C_GDFE:-$C_GDF}" \
		-v rows="${R_GDFE:-$R_GDF}" "
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
					if (k = match_option(tolower(__return_value(__get_half(arr[i], "=", 1), arr[i])), "auto,fill,rows,columns")) {
						w = __get_half(arr[i], "=")
						if (k == "auto" && ! (cl || rw)) {
							cl = columns
							columns = 0
							rw = rows
							rows = 0
						} else if (k == "fill" && ! (cl || rw)) {
							cl = columns
							columns = -1
							rw = rows
							rows = -1
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
			printf("%s ", "--erase-on-exit --scrollbar --visit-items")
			printf("--trace \x22%s%s\x22 ", __return_value(ENVIRON["G_NEX_MOD_LOG"], "/var/log"), "/nex-dialog.log")
			printf("--%s ", vrnt)
			if (vrnt == "prgbox") {
				printf("\x22%s\x22 ", __return_value(msg, " "))
				printf("\x22%s\x22 ", __return_value(cmd, "echo"))
			} else {
				printf("\x22%s\x22 ", __return_value(__return_value(msg, cmd), " "))
			}
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
}

__get_dialog_size()
{
	eval "${1:-R_GDFE}"="$(get_tty_prop -k 'rows')"
	eval "${2:-C_GDFE}"="$(get_tty_prop -k 'columns')"
}

__set_dialog_selected()
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
			split_parameters(fld, flds, ",", "=", 1)
			l = unique_indexed_array(opt, opts, "\x22")
			for (i = 1; i <= l; i++) {
				k = trim(opts[i])
				w = flds[k]
				gsub(/ /, "_", k)
				gsub(/[^a-zA-Z0-9_]/, "", k)
				if (k ~ /^[0-9]+/)
					k = "_" k
				printf("%s=\x22%s\x22 %s=\x22%s\x22 ", "GDF_SL_" i, k, k, w)
			}
			printf("%s=\x22%s\x22 ", "GDF_SL", i - 1)
			delete opts
			delete flds
		}
	'
}

__set_dialog_output()
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
			l = trim_split(fld, flds, ",")
			trim_split(opt, opts, "\n")
			for (i = 1; i <= l; i++) {
				k = trim(__get_half(flds[i], "=", 1))
				gsub(/ /, "_", k)
				gsub(/[^a-zA-Z0-9_]/, "", k)
				if (k ~ /^[0-9]+/)
					k = "_" k
				printf("%s=\x22%s\x22 %s=\x22%s\x22 ", "GDF_SL_" i, k, k, __return_else_value(dft, __return_value(opts[i], __get_half(flds[i], "=")), opts[i]))
			}
			printf("%s=\x22%s\x22 ", "GDF_SL", i - 1)
			delete opts
			delete flds
		}
	'
}

get_dialog_explorer()
{
	(
		__get_dialog_size
		eval $(get_str_parser 'm:e:v:f:' "$@")
		v_gdfe="$(set_struct_opt -i "$v" -r "fselect,dselect,textbox,editbox,tailboxbg,tailbox")"
		[ -z "$f" -a -n "$1" ] && {
			f="$(get_content_path "$1")"
			shift
		} || {
			f="$(get_content_path "$f")"
		}
		[ -r "$f" ] && {
			[ -f "$f" ] && {
				[ "$v_gdfe" = 'dselect' ] && {
					v_gdfe="textbox"
				}
			}
			[ -d "$f" -a -x "$f" ] && {
				v_gdfe="dselect"
			}
		}
		[ -z "$v_gdfe" ] && {
			exit 1
		}
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory \
			${m:+-m "$m"} \
			${e:+-e "$e"} \
			"-m" "$f"\
		)" 3>&1 1>&2 2>&3)
		DIALOG_EXIT_STATUS=$?
		echo "$DIALOG_OPTIONS"
		return $DIALOG_EXIT_STATUS
	)
}

get_dialog_yn()
{
	(
		__get_dialog_size
		eval $(get_str_parser 'c:m:e:v:' "$@")
		v_gdfe="$(set_struct_opt -i "$v" -r "yesno,msgbox")"
		v_gdfe="${v_gdfe:-msgbox}"
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory \
			${m:+-m "$m"} \
			${e:+-e "$e"} \
			${c:+-c "$c"} \
		)" 3>&1 1>&2 2>&3)
		DIALOG_EXIT_STATUS=$?
		echo "$DIALOG_OPTIONS"
		return $DIALOG_EXIT_STATUS
	)
}

get_dialog_cal()
{
	(
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory \
			"$@" \
			-e "auto" \
			-v "calendar" \
		) $(date +"%d %m %y")" 3>&1 1>&2 2>&3)
		DIALOG_EXIT_STATUS=$?
		echo "$DIALOG_OPTIONS"
		return $DIALOG_EXIT_STATUS
	)
}

get_dialog_time()
{
	(
		__get_dialog_size
		eval "$(get_str_parser 'v:t:' "$@")"
		v_gdfe="$(set_struct_opt -i "$v" -r "pause,timebox")"
		v_gdfe="${v_gdfe:-timebox}"
		[ -z "$t" ] && {
			[ "$v_gdfe" = "pause" ] && t="59" || t="23 59 59"
		}
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory "$@") $t" 3>&1 1>&2 2>&3)
		DIALOG_EXIT_STATUS=$?
		echo "$DIALOG_OPTIONS"
		return $DIALOG_EXIT_STATUS
	)
}

get_dialog_form()
{
	(
		__get_dialog_size
		eval $(get_str_parser 'c:e:p:m:v:d' "$@")
		v_gdfe="$(set_struct_opt -i "$v" -r "form,passwordform,mixedform")"
		v_gdfe="${v_gdfe:-form}"
		p_gdfe="$(get_str_param -n "$p")"
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory \
			${m:+-m "$m"} \
			${e:+-e "$e"} \
			${c:+-c "$c"} \
		)" 3>&1 1>&2 2>&3)
		DIALOG_EXIT_STATUS=$?
		__set_dialog_output "$DIALOG_OPTIONS" "$p_gdfe" "$d"
		return $DIALOG_EXIT_STATUS
	)
}

get_dialog_menu()
{
	(
		__get_dialog_size
		eval $(get_str_parser 'c:m:e:v:p:' "$@")
		v_gdfe="$(set_struct_opt -i "$v" -r "radiolist,checklist,buildlist,inputmenu,menu,treeview")"
		v_gdfe="${v_gdfe:-menu}"
		p_gdfe="$(get_str_param "$p")"
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory \
			${m:+-m "$m"} \
			${e:+-e "$e"} \
			${c:+-c "$c"} \
		)" 3>&1 1>&2 2>&3)
		DIALOG_EXIT_STATUS=$?
		__set_dialog_selected "$DIALOG_OPTIONS" "$p_gdfe"
		return $DIALOG_EXIT_STATUS
	)
}

get_dialog_other()
{
	(
		__get_dialog_size
		eval $(get_str_parser 'c:m:e:v:p:' "$@")
		DIALOG_OPTIONS=$(eval "dialog $(__get_dialog_factory \
			${m:+-m "$m"} \
			${e:+-e "$e"} \
			${v:+-v "$v"} \
			${p:+-p "$p"} \
			${c:+-c "$c"} \
		)" 3>&1 1>&2 2>&3)
		DIALOG_EXIT_STATUS=$?
		echo "$DIALOG_OPTIONS"
		return $DIALOG_EXIT_STATUS
	)
}

