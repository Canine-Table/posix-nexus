nx_grid()
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
			)
		"'
			BEGIN {
				nx_grid_queue(arr, "abc")
				nx_grid_queue(arr, "def")
				nx_grid_queue(arr, "abc")
				nx_grid_queue(arr, "ghi")
				while (i = nx_grid_queue(arr))
					print i
				
				#for (i = arr[0]; i > 0; i--) {
				#	for (j = arr[i "_" 0]; j > 0; j--)
				#		print arr[i "_" j]
				#}
			}
		'
}




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
				if (fn)
					nx_json(fn, arr, 1)
				else
					exit 1
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
