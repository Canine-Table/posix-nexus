#!/bin/sh

nx_test_box()
{
	${AWK:-$(get_cmd_awk)} \
		-v json='{
			"hello": {
				"hi": [ "hi", {"bye": "hi" } ],
				"hello": "world",
				"world": "hello"
			}
		}' \
		-v comp='{
			"hi": "bye",
			"yes": [[[[["no"]]]]],
			"bro": [ "yes", { "yes": "no", "no": "yes" }]
		}' \
		-v lol='[
			[ "a", "list"],
			[ "of", "lists"]
		]' \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-struct.awk")
	"'
		BEGIN {
			nx_json(comp, js, 2)
			nx_json_delete(".bro", js)
			#nx_json(lol, js, 2)
			print nx_json_tostring("", js)
			#nx_json_length("", js, 1)
			#nx_json_length("", js, 0)
			for (i in js)
				print i " == " js[i]
		}
	'
}

