#!/bin/sh

nx_test_box()
{
	${AWK:-$(get_cmd_awk)} \
		-v json='{
			"hello": [
				"hi",
				"h",
			]
		}' \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-struct.awk")
	"'
		BEGIN {
			nx_json(json, arr, 2)
			nx_json_build(".hello[5]", arr)
		}
	'
}

