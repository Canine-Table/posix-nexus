#!/bin/sh

###:( get ):##################################################################################

get_test_one() {
	$(get_cmd_awk) \
		-v tmpa="$1" \
		-v tmpb="$2" \
		-v tmpc="$3" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/bool.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/structs.awk" \
			"$G_NEX_MOD_LIB/awk/algor.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk" \
			"$G_NEX_MOD_LIB/awk/inet.awk"
		)
	"'
		BEGIN {
			print __valid_cidr(tmpa, 4);
		}
	'
}
