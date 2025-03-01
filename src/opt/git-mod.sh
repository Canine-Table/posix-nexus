#!/bin/sh

gh_social()
{
	command -v jq 1> /dev/null 2>&1 || return 1
	command -v gh 1> /dev/null 2>&1 || return 2
	(
		usr="$(gh auth status | ${AWK:-$(get_cmd_awk)} '/Token scopes/')"
		([ "$?" -gt 0 ] || ! (echo "$usr" | grep -q "'user'")) && {
			gh auth login --scopes $(
				${AWK:-$(get_cmd_awk)} -v val="$usr" '
					BEGIN {
						val = substr(val, 20)
						val = substr(val, 1, length(val) - 1)
						gsub("\x27\x2c\x20\x27", "\x2c", val)
						if (val)
							val = val ","
						print val "user"
					}
				'
			)
		}
		for i in $(get_algor_compare \
			-a $(gh api user/following | jq -r '.[].login') \
			-b $(gh api user/followers | jq -r '.[].login')
		); do
			[ -n "$(get_algor_compare \
				-a "$i" \
				-b "torvalds"
			)" ] && {
				echo gh api -X DELETE "/user/following/$i"
			}
		done
	)
}

