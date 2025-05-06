#!/bin/sh

nx_bundle_include()
{
	(
		# best if sigil is the comment of the language
		# the directive can be whatever
		# output defaults to stdout (fd 1)
		# input through -i or first remaining parameter
		# f if you want to force clobber
		while getopts :d:f:s:o:i: OPT; do
			case $OPT in
				s|d|f|o|i) eval "$OPT"="'$OPTARG'";;
			esac
		done
		shift $((OPTIND - 1))
		[ -e "$o" -a -n "$f" ] && mv "${o}-$(date +"%s").bak"
		[ -z "$o" ] && o='/dev/stdout'
		i="$(nx_content_path "${i:-$1}")"
		[ -f "$i" -a -r "$i" ] && {
			cat "$i" | ${AWK:-$(nx_cmd_awk)} \
				-v sig="${s:-#}" \
				-v dir="${d:-nx_include}" \
				-v inpt="$i" \
			"
				$(cat \
					"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
					"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
					"$G_NEX_MOD_LIB/awk/nex-str.awk" \
					"$G_NEX_MOD_LIB/awk/nex-math.awk"
				)
			"'
				BEGIN {
					d = sig dir
				}
				{
					if (s = nx_bundle($0, d, inpt, ara, arb))
						print s
				}
				END {
					delete ara
					delete arb
				}
			' > "$o"
		} || exit 1
	)
}

