#!/bin/sh

##:( get ):##################################################################################

nx_struct_ref()
{
	[ -n "$1" ] && eval "echo \$$1"
}

nx_struct_append_ref()
{
	(
		v=$(nx_struct_ref "$1")
		[ -n "$v" -a -n "$2" ] && v="${v}${3:-,}"
		echo "$v$2"
	)
}

get_struct_list() {
	(
		while getopts :s:o:cru OPT; do
			case $OPT in
				c|s|k|o) eval "$OPT"="'${OPTARG:-true}'";;
				r|u) t="$OPT";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(get_cmd_awk)} \
			-v inpt="$(echo $*)" \
			-v sep="$s" \
			-v ksep="$s" \
			-v osep="$o" \
			-v typ="$t" \
			-v cs="$c" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/misc.awk" \
				"$G_NEX_MOD_LIB/awk/bool.awk" \
				"$G_NEX_MOD_LIB/awk/structs.awk" \
				"$G_NEX_MOD_LIB/awk/algor.awk" \
				"$G_NEX_MOD_LIB/awk/bases.awk" \
				"$G_NEX_MOD_LIB/awk/math.awk" \
				"$G_NEX_MOD_LIB/awk/types.awk" \
				"$G_NEX_MOD_LIB/awk/str.awk"
			)
		"'
			BEGIN {
				__load_delim(dlm, sep, osep)
				if (! cs) {
					dlm["ics"] = IGNORECASE
					IGNORECASE = 1
				}
				if (typ == "r") {
					outpt = reverse_indexed_hashmap(arr, 0, 0, inpt, dlm["s"], dlm["o"])
				} else if (typ == "u") {
					outpt = unique_indexed_array(inpt, arr, dlm["s"], dlm["o"], 1)
				} else {
					trim_split(inpt, arr, dlm["s"])
					outpt = __join_indexed_array(arr, dlm["o"])
				}
				if ("isc" in dlm)
					IGNORECASE = dlm["isc"]
				delete dlm
				if (outpt) {
					print outpt
				} else {
					exit 1
				}
			}
		'
	)
}

get_struct_map() {
	(
		while getopts :s:o: OPT; do
			case $OPT in
				s|o) eval "$OPT"="'$OPTARG'";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(get_cmd_awk)} \
			-v inpt="$(echo $*)" \
			-v sep="$s" \
			-v osep="$o" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/misc.awk" \
				"$G_NEX_MOD_LIB/awk/bool.awk" \
				"$G_NEX_MOD_LIB/awk/structs.awk" \
				"$G_NEX_MOD_LIB/awk/algor.awk" \
				"$G_NEX_MOD_LIB/awk/bases.awk" \
				"$G_NEX_MOD_LIB/awk/math.awk" \
				"$G_NEX_MOD_LIB/awk/types.awk" \
				"$G_NEX_MOD_LIB/awk/str.awk"
			)
		"'
			BEGIN {
				if (! osep)
					osep = "="
				__load_delim(dlm, sep, osep)
				if (is_integral(k = trim_split(inpt, arr, dlm["s"]) / 2)) {
					j = k
					str = ""
					for (i = 1; i <= k; i++)
						str = __join_str(str, arr[i] dlm["o"] arr[++j], dlm["s"])
				}
				delete arr
				delete dlm
				if (str)
					print str
				else
					exit 1
			}
		'
	)
}

###:( set ):##################################################################################

set_struct_opt()
{
	(
		while getopts :s:o:i:r:vcle OPT; do
			case $OPT in
				s|o|c|l|e|i|v) eval "$OPT"="'${OPTARG:-true}'";;
				r) r="$(get_struct_ref_append r "$OPTARG")";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(get_cmd_awk)} \
			-v inpt="${i:-"$1"}" \
			-v reflst="${r:-"$2"}" \
			-v lgt="$l" \
			-v cs="$c" \
			-v vrb="$v" \
			-v sep="$s" \
			-v osep="$o" \
			-v ed="$e" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/misc.awk" \
				"$G_NEX_MOD_LIB/awk/types.awk" \
				"$G_NEX_MOD_LIB/awk/str.awk" \
				"$G_NEX_MOD_LIB/awk/structs.awk" \
				"$G_NEX_MOD_LIB/awk/algor.awk" \
				"$G_NEX_MOD_LIB/awk/bool.awk" \
				"$G_NEX_MOD_LIB/awk/bases.awk"
			)
		"'
			BEGIN {
				if (! inpt || ! reflst)
					exit 1
				__load_delim(dlm, sep, osep)
				if (! cs) {
					dlm["ics"] = IGNORECASE
					IGNORECASE = 1
				}
				gsub(/\n/, dlm["s"], reflst)
				str = match_option(inpt, reflst, dlm["s"], dlm["o"], vrb, ed, lgt)
				if ("isc" in dlm)
					IGNORECASE = dlm["isc"]
				osep = dlm["o"]
				delete dlm
				if (length(str)) {
					if (str !~ osep || vrb)
						print str
					if (str ~ osep)
						exit 2
					exit 0
				}
				exit 3
			}
		'
	)
}

##############################################################################################

