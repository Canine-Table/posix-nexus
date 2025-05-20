nx_lexer_file()
{
	${AWK:-$(nx_cmd_awk)} \
		-v fn="$G_NEX_MOD_ENV/file.nx" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
				"$G_NEX_MOD_LIB/awk/nex-shell.awk" \
				"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
				"$G_NEX_MOD_LIB/awk/nex-log.awk" \
				"$G_NEX_MOD_LIB/awk/nex-str.awk" \
				"$G_NEX_MOD_LIB/awk/nex-math.awk" \
				"$G_NEX_MOD_LIB/awk/nex-lexer.awk" \
				"$G_NEX_MOD_LIB/awk/nex-json.awk"
			)
		"'
			BEGIN {
				__nx_emoji_map(arr)
				for (i in arr)
					print i "  =  " arr[i]
			}
		'
}

nx_lexer_json()
{
	${AWK:-$(nx_cmd_awk)} \
		-v fn="$G_NEX_MOD_ENV/file.json" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
				"$G_NEX_MOD_LIB/awk/nex-shell.awk" \
				"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
				"$G_NEX_MOD_LIB/awk/nex-log.awk" \
				"$G_NEX_MOD_LIB/awk/nex-str.awk" \
				"$G_NEX_MOD_LIB/awk/nex-math.awk" \
				"$G_NEX_MOD_LIB/awk/nex-json.awk"
			)
		"'
			BEGIN {
				if (! (i = nx_json(fn, arr, 4))) {
					for (i in arr)
						print "arr[" i "] = " arr[i]
					i = 0
				}
				delete arr
				exit i
			}
		'
}

nx_json_cat()
{
	cat -n	"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
				"$G_NEX_MOD_LIB/awk/nex-shell.awk" \
				"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
				"$G_NEX_MOD_LIB/awk/nex-log.awk" \
				"$G_NEX_MOD_LIB/awk/nex-str.awk" \
				"$G_NEX_MOD_LIB/awk/nex-math.awk" \
				"$G_NEX_MOD_LIB/awk/nex-json.awk" | $PAGER
}
