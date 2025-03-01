#!/bin/sh

###:( get ):##################################################################################

get_algor_compare()
{
	(
		while getopts :s:o:a:b:irclrnd OPT; do
			case $OPT in
				l|r|i|d) m="$OPT";;
				c|s|o) eval "$OPT"="'${OPTARG:-true}'";;
				a|b) eval "$OPT"="'$(get_struct_ref_append $OPT "$OPTARG")'";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(get_cmd_awk)} \
			-v inptlst="${a:-"$1"}" \
			-v reflst="${b:-"$2"}" \
			-v mde="$m" \
			-v cs="$c" \
			-v sep="$s" \
			-v osep="$o" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/misc.awk" \
				"$G_NEX_MOD_LIB/awk/str.awk" \
				"$G_NEX_MOD_LIB/awk/structs.awk" \
				"$G_NEX_MOD_LIB/awk/algor.awk" \
				"$G_NEX_MOD_LIB/awk/bool.awk" \
				"$G_NEX_MOD_LIB/awk/bases.awk" \
				"$G_NEX_MOD_LIB/awk/types.awk"
			)
		"'
			BEGIN {
				if (! inptlst || ! reflst)
					exit 1
				__load_delim(dlm, sep, osep)
				if (! cs) {
					dlm["ics"] = IGNORECASE
					IGNORECASE = 1
				}
				gsub(/\n/, dlm["s"], inptlst)
				gsub(/\n/, dlm["s"], reflst)
				if (! mde)
					mde = "left"
				str = compare_arrays(inptlst, reflst, mde, dlm["s"], dlm["o"])
				if ("isc" in dlm)
					IGNORECASE = dlm["isc"]
				delete dlm
				if (length(str)) {
					print str
					exit 0
				}
				exit 2
			}
		'
	)
}

set_algor_qsort() {
	(
		while getopts :s:o:l:m:r OPT; do
			case $OPT in
				o|s|m|r) eval "$OPT"="'${OPTARG:-true}'";;
				l) l="$(get_struct_ref_append l "$OPTARG")";;
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

