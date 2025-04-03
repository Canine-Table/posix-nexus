#!/bin/sh

##:( get ):##################################################################################

get_str_rand()
{
	(
		${AWK:-$(get_cmd_awk)} \
			-v num="${1:-8}" \
			-v chars="${2:-alnum}" \
		"
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
				if (! is_integral(num))
					num = 8
				val = random_str(num, chars)
				if (val)
					print val
				else
					exit 1
			}
		'
	)
}

get_str_parser()
{
	(
		opt="$1"
		shift
		${AWK:-$(get_cmd_awk)} \
			-v inpt="$(get_str_print "$@")" \
			-v opt="$opt" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/misc.awk" \
				"$G_NEX_MOD_LIB/awk/algor.awk" \
				"$G_NEX_MOD_LIB/awk/structs.awk" \
				"$G_NEX_MOD_LIB/awk/types.awk" \
				"$G_NEX_MOD_LIB/awk/str.awk"
			)
		"'
			BEGIN {
				print str_parser(opt, inpt)
			}
		'
	)
}

get_str_print()
{
	[ "${#@}" -gt 0 ] && {
		echo -n "$1"
		[ "${#@}" -gt 1 ] && {
			echo -n "<NULL>"
		}
		shift
		get_str_print "$@"
	}
}

get_str_param()
{
	(
		while getopts :s:o:n OPT; do
			case $OPT in
				s|o|n) eval "$OPT"="'${OPTARG:-true}'";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(get_cmd_awk)} \
			-v sep="${s:-=}" \
			-v nil="$n" \
			-v osep="${o:-,}" \
			-v param="$*" "
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
				split_parameters(param, arr, osep, sep, nil)
				if (str = __join_parameters(arr, osep, sep))
					print str
				else
					exit 1
			}
		'
	)
}

get_str_search()
{
	(
		while getopts :f:s:o:r:d:n: OPT; do
			case $OPT in
				f|r|s|o|d|n) eval "$OPT"="'${OPTARG:-true}'";;
			esac
		done
		shift $((OPTIND - 1))
		eval "$*" 2>/dev/null | ${AWK:-$(get_cmd_awk)} \
			-v sep="$s" \
			-v osep="$o" \
			-v div="$d" \
			-v ndiv="$n" \
			-v fnd="$f" \
			-v rpl="$r" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/misc.awk" \
				"$G_NEX_MOD_LIB/awk/algor.awk" \
				"$G_NEX_MOD_LIB/awk/structs.awk" \
				"$G_NEX_MOD_LIB/awk/bool.awk" \
				"$G_NEX_MOD_LIB/awk/types.awk" \
				"$G_NEX_MOD_LIB/awk/math.awk" \
				"$G_NEX_MOD_LIB/awk/str.awk"
			)
		"'
			BEGIN {
				if (! div)
					div = "/"
				if (! sep)
					sep = "\x20"
				__load_delim(dlm, sep, osep)
				o = ""
				v = ""
			} {
				if (str = str_search($0, dlm["s"], div, ndiv, dlm["o"], fnd, rpl)) {
					printf("%s%s", o, str)
					if (! o)
						o = dlm["o"]
				}
			} END {
				delete dlm
			}
		' || eval "$*"
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

