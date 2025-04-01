#!/bin/sh

gh_social()
{
	has_cmd jq gh || return 2
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
				gh api -X DELETE "/user/following/$i"
			}
		done
	)
}

__is_git_repo()
{
	has_cmd git && git rev-parse --is-inside-work-tree 1> /dev/null 2>&1
}

get_git_head()
{
	__is_git_repo && get_str_search -s '/' -f '/origin/,1'  git symbolic-ref refs/remotes/origin/HEAD
}

get_git_remote()
{
	__is_git_repo && get_str_search  -r '(fetch)=fetch:\t,(push)=push:\t' -f '/(fetch)/^/(push)/^/,-1' git remote -v
}

get_git_branch()
{
	__is_git_repo && get_str_search  -s '/' -f '/origin/,1' git branch -a | sed -n '3,$p'
}

