
nx_lexer_file()
{
	#[ -n "$1" ] && ${AWK:-$(nx_cmd_awk)} \
	#		-v fn="$(nx_content_path "$1")" "
	${AWK:-$(nx_cmd_awk)} \
		-v fn="$G_NEX_MOD_ENV/file.nx" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
				"$G_NEX_MOD_LIB/awk/nex-shell.awk" \
				"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
				"$G_NEX_MOD_LIB/awk/nex-log.awk" \
				"$G_NEX_MOD_LIB/awk/nex-str.awk" \
				"$G_NEX_MOD_LIB/awk/nex-math.awk" \
				"$G_NEX_MOD_LIB/awk/nex-lexer.awk"
			)
		"'
			BEGIN {
				if (fn)
					nx_lexer(fn)
				else
					exit 1
			}
		'
}

nx_lex_view()
{
	cat -n \
		"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
		"$G_NEX_MOD_LIB/awk/nex-shell.awk" \
		"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
		"$G_NEX_MOD_LIB/awk/nex-log.awk" \
		"$G_NEX_MOD_LIB/awk/nex-str.awk" \
		"$G_NEX_MOD_LIB/awk/nex-math.awk" \
		"$G_NEX_MOD_LIB/awk/nex-lexer.awk" | $PAGER
}
