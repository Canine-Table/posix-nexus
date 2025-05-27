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
			nx_json(json, js, 2)
			nx_json_delete(".hello.hi", js)
			for (i in js)
				print i " = " js[i]
		}
	'
}

