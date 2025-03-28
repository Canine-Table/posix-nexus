#!/bin/sh

###:( get ):##################################################################################

set_algor_qsort() {
	(
		while getopts :s:o:l:m:r OPT; do
			case $OPT in
				o|s|m|r) eval "$OPT"="'${OPTARG:-true}'";;
				l) l="$(get_struct_ref_append -l "$OPTARG")";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(get_cmd_awk)} \
			-v meh="$m" \
			-v lst="${l:-"$*"}" \
			-v sep="$s" \
			-v osep="$o" \
			-v rvs="$r" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/misc.awk" \
				"$G_NEX_MOD_LIB/awk/types.awk" \
				"$G_NEX_MOD_LIB/awk/str.awk" \
				"$G_NEX_MOD_LIB/awk/bool.awk" \
				"$G_NEX_MOD_LIB/awk/structs.awk" \
				"$G_NEX_MOD_LIB/awk/algor.awk" \
				"$G_NEX_MOD_LIB/awk/bases.awk"
			)
		"'
			BEGIN {
				__load_delim(dlm, sep, osep)
				gsub(/\n/, dlm["s"], lst)
				cnt = trim_split(lst, arr, dlm["s"])
				quick_sort(arr, 1, cnt, rvs, meh)
				for (i = 1; i <= cnt; i++)
					str = __join_str(str, arr[i], dlm["o"])
				delete dlm
				delete arr
				if (str)
					print str
				else
					exit 1
			}
		'
	)
}

