#!/bin/sh

##:( get ):##################################################################################

get_str_locate()
{
	(
		while getopts :f:r:s:o:n:g OPT; do
			case $OPT in
				f|n|s|r|o|g) eval "$OPT"="'${OPTARG:-true}'";;
			esac
		done
		shift $((OPTIND - 1))
		eval "$*" | ${AWK:-$(get_cmd_awk)} \
			-v glbl="$g" \
			-v sep="$s" \
			-v osep="$o" \
			-v fnd="$f" \
			-v rpl="$r" \
			-v num="$n" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/misc.awk" \
				"$G_NEX_MOD_LIB/awk/algor.awk" \
				"$G_NEX_MOD_LIB/awk/structs.awk" \
				"$G_NEX_MOD_LIB/awk/types.awk" \
				"$G_NEX_MOD_LIB/awk/math.awk" \
				"$G_NEX_MOD_LIB/awk/str.awk"
			)
		"'
			BEGIN {
				if (! sep)
					sep = "\x20"
				__load_delim(dlm, sep, osep)
			} {
				gsub(/\t|\v/, dlm["s"], $0)
				anchor_search($0, fnd, rpl, num, glbl, dlm["s"], dlm["o"])
			}
		'
	)
}

###:( set ):##################################################################################

set_str_case()
{
	(
		while getopts ult OPT; do
			case $OPT in
				u|l|t) c="$OPT";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(get_cmd_awk)} \
			-v inpt="$*" \
			-v strcase="$c" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/algor.awk" \
				"$G_NEX_MOD_LIB/awk/structs.awk" \
				"$G_NEX_MOD_LIB/awk/str.awk"
			)
		"'
			BEGIN {
				if (strcase == "t")
					print totitle(inpt)
				else if (strcase == "u")
					print toupper(inpt)
				else if (strcase == "l")
					print tolower(inpt)
				else
					print inpt
			}
		'
	)
}

set_str_format()
{
	(
		while getopts :i:s:f:l:r:k OPT; do
			case $OPT in
				i|s|f|l|r|k) eval "$OPT"="'${OPTARG:-true}'";;
			esac
		done
		shift $((OPTIND - 1))
		[ -n "$f" ] || { 
			f="$1"
			shift
		}
		${AWK:-$(get_cmd_awk)} \
			-v fmt="$f" \
			-v inpt="${i:-"$*"}" \
			-v sep="$s" \
			-v lft="$l" \
			-v rgt="$r" \
			-v kp="$k" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/misc.awk" \
				"$G_NEX_MOD_LIB/awk/str.awk" \
				"$G_NEX_MOD_LIB/awk/structs.awk"
			)
		"'
			BEGIN {
				print format_str(fmt, inpt, sep, lft, rgt, kp)
			}
		'
	)
}

###:( add ):##################################################################################

add_str_append()
{
	(
		while getopts :c:n:e OPT; do
			case $OPT in
				n|c|e) eval "$OPT"="'${OPTARG:-true}'";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(get_cmd_awk)} \
			-v ed="$e" \
			-v num="${n:-"$1"}" \
			-v char="${c:-"$2"}" "
			$(cat \
					"$G_NEX_MOD_LIB/awk/misc.awk" \
					"$G_NEX_MOD_LIB/awk/structs.awk" \
					"$G_NEX_MOD_LIB/awk/types.awk" \
					"$G_NEX_MOD_LIB/awk/str.awk"
			)
		"'
			BEGIN {
				print append_str(num, char, ed)
			}
		'
	)
}

add_str_div()
{
	n="$(get_tty_prop -k "columns")"
	[ -n "$(tty)" ] && {
		add_str_append -n "$n" -c "─"
	}
}

##:( del ):##################################################################################
###:( is ):###################################################################################
##############################################################################################

