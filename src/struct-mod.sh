#!/bin/sh

##:( get ):##################################################################################

get_struct_ref()
{
	[ -n "$1" ] && eval "echo \$$1"
}

get_struct_ref_append()
{
	(
		var=$(get_struct_ref "$1")
		[ -n "$var" ] && var="$var${3:-\\n}"
		echo "$var$2"
	)
}

get_struct_compare()
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
		$(get_cmd_awk) \
			-v inptlst="${a:-"$1"}" \
			-v reflst="${b:-"$2"}" \
			-v mde="$m" \
			-v cs="$c" \
			-v sep="$s" \
			-v osep="$o" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/misc.awk" \
				"$G_NEX_MOD_LIB/awk/str.awk" \
				"$G_NEX_MOD_LIB/awk/bool.awk" \
				"$G_NEX_MOD_LIB/awk/structs.awk" \
				"$G_NEX_MOD_LIB/awk/algor.awk" \
				"$G_NEX_MOD_LIB/awk/bases.awk" \
				"$G_NEX_MOD_LIB/awk/math.awk" \
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

get_struct_noexpand() {
	(
		get_struct_clist $* | while read -r var; do
			set_str_noexpand "$var"
		done
	)
}

get_struct_list() {
	(
		while getopts :s:d:o:cru OPT; do
			case $OPT in
				c|s|o) eval "$OPT"="'$OPTARG'";;
				r|u) t="$OPT";;
			esac
		done
		shift $((OPTIND - 1))
		$(get_cmd_awk) \
			-v inpt="$(echo $*)" \
			-v dft="$d" \
			-v sep="$s" \
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

###:( new ):##################################################################################
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
		$(get_cmd_awk) \
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

