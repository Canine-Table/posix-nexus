#!/bin/sh

###:( get ):##################################################################################

get_tui_wrap() {
	(
		col="$(get_tty_prop -k "columns")"
		while getopts :f:c:b:s:h: OPT; do
                        case $OPT in
				h) h="$h$OPTARG<{div}>";;
				f)
					{
						F="$(get_mod_realpath "$OPTARG")"
						[ -f "$F" ] && f="$f $F"
					};;
				b) b="$(set_struct_opt -i "$OPTARG" 'single, double' || echo "$OPTARG")";;
                                s|c) eval "$OPT"="'${OPTARG:-true}'";;
                        esac
                done
                shift $((OPTIND - 1))
		$(get_cmd_awk) \
			-v col="$col" \
			-v ncl="$c" \
			-v sep="$s" \
			-v hdr="$h" \
			-v inpt="$*" \
			-v bdr="$b" "
                	$(cat \
				"$G_NEX_MOD_LIB/awk/strings.awk" \
				"$G_NEX_MOD_LIB/awk/math.awk" \
				"$G_NEX_MOD_LIB/awk/tui.awk"
                	)
        	"'
			BEGIN {
				if (bdr) {
					header = hdr
					load_borders(bdr, sep, col - int(ncl))
					print borders["top"]
				}
				if (inpt) {
					wrap(hdr inpt, col, ncl)
					fn["inpt"] = 1
				}
				hdr = ""
			}
                	{
				nor = nor + 1
				if (FILENAME) {
					if (! (FILENAME in fn)) {
						if (bdr) {
							hdr = FILENAME "<{div}>" header
							if (length(fn))
								print borders["center"]
						}
						fn[FILENAME] = nor
						ln = 0
					}
					ln = ln + 1
				}
				wrap(hdr "" $0, col, ncl)
				hdr = ""
                	} END {
				if (bdr)
					print borders["bottom"]
			}
		' $(get_file_path $f) "/dev/null"
	)
}

###:( set ):##################################################################################
###:( cls ):##################################################################################
###:( new ):##################################################################################
###:( add ):##################################################################################
###:( del ):##################################################################################
###:( is ):###################################################################################
##############################################################################################

