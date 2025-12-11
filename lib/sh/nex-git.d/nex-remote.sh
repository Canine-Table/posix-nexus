#nx_include NX_L:/sh/nex-git.sh

__nx_git_remote()
{
	while :; do
		case "$1" in
			+B|branch) {
				branch="${2:-main}"
				nx_misc_shift 2 $# || return
				shift
			};;
			+O|origin) {
				branch="${2:-upstream}"
				nx_misc_shift 2 $# || return
				shift
			};;
			-mt|--merge-theirs) {
				git fetch "$origin" "$branch" &&
				git merge -s recursive -X theirs "$origin/$branch" &&
				git push "$origin" "$branch"
				nx_misc_shift 1
			};;
			-rt|--rebase-theirs) {
				git fetch "$origin" "$branch" &&
				git rebase "$origin/$branch" --strategy=recursive -X theirs &&
				git push "$origin" "$branch"
				nx_misc_shift 1
			};;
			-ph|--push) {
				git push "$origin" "$branch"
				nx_misc_shift 1
			};;
			-pl|--pull) {
				git pull "$origin" "$branch"
				nx_misc_shift 1
			};;
			-fh) {
				git fetch "$origin" "$branch"
				nx_misc_shift 1
			};;
			-ff|--ff-only) {
				git pull --ff-only "$origin" "$branch"
				nx_misc_shift 1
			};;
			-r|--rebase) {
				git pull --rebase "$origin" "$branch"
				nx_misc_shift 1
			};;
			-aur|--add-upstream-remote) {
				git remote add "$origin" "$2"
				nx_misc_shift 2 $# || return
				shift
			};;
			-gar|--get-all-upstream-remote) {
				git remote --verbose
				nx_misc_shift 1
			};;
			-gur|--get-upstream-remote) {
				git remote get-url --all "$origin"
				nx_misc_shift 1
			};;
			-rur|--remove-upstream-remote) {
				git remote remove "$origin"
				nx_misc_shift 1
			};;
			-msq|--merge-squash) {
				git merge --squash "$origin/$branch"
				nx_misc_shift 1
			};;
			-ma|--merge-abort) {
				git merge --abort
				nx_misc_shift 1
			};;
			-mc|--merge-continue) {
				git merge --continue
				nx_misc_shift 1
			};;
			-su|--set-upstream) {
				git push --set-upstream "$origin" "$branch"
				nx_misc_shift 1
			};;
			-fwl|--force-with-lease) {
				git push --force-with-lease "$origin" "$branch"
				nx_misc_shift 1
			};;
			-h|--help) {
				nx_tty_print \
					-i 'Usage: nx_git --remote [options]\n\n' \
					-s '+B | branch [name]\n' \
					-i '    Set branch name (default: main)\n\n' \
					-s '+O | origin [name]\n' \
					-i '    Set origin name (default: upstream)\n\n' \
					-w '-mt | --merge-theirs\n' \
					-i '    Fetch, merge with theirs strategy, then push\n\n' \
					-w '-rt | --rebase-theirs\n' \
					-i '    Fetch, rebase with theirs strategy, then push\n\n' \
					-w '-ph | --push\n' \
					-i '    Push current branch to origin\n\n' \
					-w '-pl | --pull\n' \
					-i '    Pull current branch from origin\n\n' \
					-w '-fh\n' \
					-i '    Fetch branch from origin\n\n' \
					-w '-ff | --ff-only\n' \
					-i '    Pull with fast‑forward only\n\n' \
					-w '-r | --rebase\n' \
					-i '    Pull with rebase\n\n' \
					-w '-aur | --add-upstream-remote [url]\n' \
					-i '    Add a new upstream remote named "\$origin" pointing to given URL\n\n' \
					-w '-gar | --get-all-upstream-remote\n' \
					-i '    Show all remotes with verbose output\n\n' \
					-w '-gur | --get-upstream-remote\n' \
					-i '    Show URL(s) for the upstream remote (origin defaults to "upstream")\n\n' \
					-w '-rur | --remove-upstream-remote\n' \
					-i '    Remove the upstream remote (origin defaults to "upstream")\n\n' \
					-w '-msq | --merge-squash\n' \
					-i '    Merge branch from origin with squash\n\n' \
					-w '-ma | --merge-abort\n' \
					-i '    Abort current merge\n\n' \
					-w '-mc | --merge-continue\n' \
					-i '    Continue current merge\n\n' \
					-w '-su | --set-upstream\n' \
					-i '    Push and set upstream tracking branch\n\n' \
					-w '-fwl | --force-with-lease\n' \
					-i '    Push with force‑with‑lease\n\n' \
					-c -R \
					-i 'Color legend:\n' \
					-s '    [green]   branch/origin selectors\n' \
					-w '    [yellow]  remote operations (fetch, pull, push, merge)\n' \
				2>&1 | ${PAGER:-tee}
				nx_misc_shift 1
			};;
			.) {
				nx_misc_shift 1
				return
			};;
			*) {
				test -n "$nx_flg" && git branch --list --all
				return
			};;
		esac
		test "$#" -eq 0 && return
		nx_flg=""
		shift
	done
}

