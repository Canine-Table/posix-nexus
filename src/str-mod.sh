#!/bin/sh

nx_str_rand()
{
	(
		${AWK:-$(nx_cmd_awk)} \
			-v num="${1:-8}" \
			-v chars="${2:-alnum}" \
		"
			$(cat \
				"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
				"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
				"$G_NEX_MOD_LIB/awk/nex-str.awk" \
				"$G_NEX_MOD_LIB/awk/nex-math.awk"
			)
		"'
			BEGIN {
				num __nx_if(__nx_is_integral(num), num, 8)
				if (val = nx_random_str(num, chars))
					print val
				else
					exit 1
			}
		'
	)
}

nx_str_chain()
{
	[ "${#@}" -gt 0 ] && {
		echo -n "$1"
		[ "${#@}" -gt 1 ] && {
			echo -n "<nx:null/>"
		}
		shift
		nx_str_chain "$@"
	}
}

nx_str_optarg()
{
	(
		${AWK:-$(nx_cmd_awk)} \
			-v str="$(nx_str_chain "$@")" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
				"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
				"$G_NEX_MOD_LIB/awk/nex-shell.awk" \
				"$G_NEX_MOD_LIB/awk/nex-str.awk" \
				"$G_NEX_MOD_LIB/awk/nex-math.awk"
			)
		"'
			BEGIN {
				print nx_parser(str, "<nx:null/>")
			}
		'
	)
}

nx_str_case()
{
	(
		while getopts ult OPT; do
			case $OPT in
				u|l|t) c="$OPT";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(nx_cmd_awk)} \
			-v inpt="$@" \
			-v strcase="$c" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
				"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
				"$G_NEX_MOD_LIB/awk/nex-str.awk" \
				"$G_NEX_MOD_LIB/awk/nex-math.awk"
			)
		"'
			BEGIN {
				if (strcase == "t")
					print nx_totitle(inpt)
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

nx_str_reverse()
{
	${AWK:-$(nx_cmd_awk)} \
		-v str="$*" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk"
		)
	"'
		BEGIN {
			print nx_reverse_str(str)
		}
	'
}

nx_str_append()
{
	(
		while getopts :c:n:s: OPT; do
			case $OPT in
				n|c|s) eval "$OPT"="'$OPTARG'";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(nx_cmd_awk)} \
			-v str="$s" \
			-v num="${n:-"$1"}" \
			-v char="${c:-"$2"}" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
				"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
				"$G_NEX_MOD_LIB/awk/nex-str.awk" \
				"$G_NEX_MOD_LIB/awk/nex-math.awk"
			)
		"'
			BEGIN {
				print nx_append_str(char, num, str)
			}
		'
	)
}

nx_str_div()
{
	n="$(nx_tty_prop -k "columns")"
	[ -n "$(tty)" ] && {
		nx_str_append -n "$n" -c "─"
	}
}

