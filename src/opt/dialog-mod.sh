#!/bin/sh

nx_dialog_factory()
{
	(
		#eval "export $(nx_tty_all)"
		eval "$(nx_str_optarg ':v:m:' "$@")"
		DIALOG_ESC=255 DIALOG_ITEM_HELP=4 DIALOG_EXTRA=3 DIALOG_HELP=2 DIALOG_CANCEL=1 DIALOG_OK=0
		${AWK:-$(get_cmd_awk)} \
			-v mesg="$m" \ "
			$(cat \
				"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
				"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
				"$G_NEX_MOD_LIB/awk/nex-str.awk" \
				"$G_NEX_MOD_LIB/awk/nex-math.awk"
			)
		"'
			BEGIN {
				#print ENVIRON["G_NEX_TTY_ROWS"]
				#print ENVIRON["G_NEX_TTY_COLUMNS"]
			}
		'
	)
}

