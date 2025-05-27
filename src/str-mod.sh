#!/bin/sh

nx_str_rand()
{
	${AWK:-$(nx_cmd_awk)} \
		-v num="${1:-8}" \
		-v chars="${2:-alnum}" \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-str.awk")
	"'
		BEGIN {
			num __nx_if(__nx_is_integral(num), num, 8)
			if (val = nx_random_str(num, chars))
				print val
			else
				exit 1
		}
	'
}

nx_str_chain()
{
	while [ "${#@}" -gt 0 ]; do
		echo -n "$1"
		[ "${#@}" -gt 1 ] && {
			echo -n "<nx:null/>"
		}
		shift
	done

}

nx_str_hex()
{
	h_nx_cmd hexdump && {
		nx_str_case -u "$(echo -en "$*" | hexdump)" | ${AWK:-$(nx_cmd_awk)} \
		'
			{
				for (i = 2; i <= NF; i++)
					h = h "\\x" substr($i, 3) "\\x" substr($i, 1, 2)
			} END {
				sub("\\\\x00$", "", h)
				print h
			}
		'
	}
}

nx_str_optarg()
{
	${AWK:-$(nx_cmd_awk)} \
		-v str="$(nx_str_chain "$@")" \
	"
		$(cat \
			"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
			"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
			"$G_NEX_MOD_LIB/awk/nex-log.awk" \
			"$G_NEX_MOD_LIB/awk/nex-json.awk" \
			"$G_NEX_MOD_LIB/awk/nex-str.awk" \
			"$G_NEX_MOD_LIB/awk/nex-shell.awk" \
			"$G_NEX_MOD_LIB/awk/nex-math.awk"
		)
	"'
		BEGIN {
			if (s = nx_str_opts(str))
				print s
			else
				exit 1
		}
	'
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
			-v strcase="$c" \
		"
			$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-str.awk")
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
		-v str="$*" \
	"
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-str.awk")
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
			-v char="${c:-"$2"}" \
		"
			$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-str.awk")
		"'
			BEGIN {
				print nx_append_str(char, num, str)
			}
		'
	)
}

nx_str_div()
{
	h_nx_cmd tty stty && [ -n "$(tty)" ] && {
		nx_str_append -n "$(
			eval "export $(nx_tty_all)"
			echo "$G_NEX_TTY_COLUMNS"
		)" -c "─"
	}
}

