#!/bin/sh

###:( get ):##################################################################################

get_test_one() {
	$(get_cmd_awk) \
		-v tmpa="$1" \
		-v tmpb="$2" \
		-v tmpc="$3" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/bool.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/structs.awk" \
			"$G_NEX_MOD_LIB/awk/algor.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/inet.awk" \
		)
	"'
		BEGIN {
			#resize_indexed_hashmap(arr, 5)
			print l2_type(valid_prefix())
			#__queue(arr, "size", 313)
			#__queue(arr, "enqueue", "a,b,c,d")
			#__queue(arr, "enqueue", "e,f,g,h")
			#queue(arr, "resizee", 5)
			#print __queue(arr, "peek")
		}
	'
}
