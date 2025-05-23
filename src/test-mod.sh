#!/bin/sh

nx_test_box()
{
	${AWK:-$(get_cmd_awk)} \
		-v json='{
			"hello": [
				"hi",
				"help",
				"hello"
			]
		}' \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-struct.awk")
	"'
		BEGIN {
			nx_json_split(".hello", js, arr, json)
			print nx_json_match(".hello", "he", js, arr)
			#print js[".nx.hello(length)"]

			#for (i = 1; i <= arr[0]; i++)
			#	print arr[i]
		}
	'
}

