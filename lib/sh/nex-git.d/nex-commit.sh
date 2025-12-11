#nx_include NEX_L:/sh/nex-git.sh

__nx_git_commit_reset()
{
	tmpa="$(nx_git -l -c)"
	nx_int_range -e -a -g 1 -l "$tmpa" -v "$1" && tmpa="$1"
	git reset --$2 HEAD$nx_prnt$tmpa
}

__nx_git_commit()
{
	while :; do
		case "$1" in
			+M|msg|message) {
				nx_msg="$2"
				nx_misc_shift 2 "$#" || return
				shift
			};;
			!P|commits) {
				nx_prnt="~"
				nx_misc_shift 1
			};;
			+P|parents) {
				nx_prnt="^"
				nx_misc_shift 1
			};;
			+A|sign) {
				sign='-S'
				nx_misc_shift 1
			};;
			!A|remove-sign) {
				sign=''
				nx_misc_shift 1
			};;
			-ane|--amend-no-edit) {
				git commit --amend --no-edit $sign
				nx_misc_shift 1
			};;
			-cc|--commit-counts) {
				git rev-list --left-right --count HEAD...$origin/$branch
				nx_misc_shift 1
			};;
			-rs|--reset-soft) {
				if __nx_git_commit_reset "$1" soft; then
					nx_misc_shift 2
					shift
				else
					nx_misc_shift 1
				fi
			};;
			-rh|--reset-hard) {
				if __nx_git_commit_reset "$1" hard; then
					nx_misc_shift 2
					shift
				else
					nx_misc_shift 1
				fi
			};;
			-h|--help) {
				nx_tty_print \
					-i 'Usage: nx_git --commit [options]\n\n' \
					-s '+M | msg | message [text]\n' \
					-i '    Provide commit message text\n\n' \
					-a '!P | commits\n' \
					-i '    Use ~ to reference commits back from HEAD\n\n' \
					-a '+P | parents\n' \
					-i '    Use ^ to reference parent commits\n\n' \
					-s '+A | sign\n' \
					-i '    Enable commit signing (-S)\n\n' \
					-s '!A | remove-sign\n' \
					-i '    Disable commit signing\n\n' \
					-w '-ane | --amend-no-edit\n' \
					-i '    Amend last commit without editing message\n\n' \
					-w ' -cc|--commit-count\n' \
					-i '    Show ahead/behind commit counts vs origin/branch\n\n' \
					-w '-rs | --reset-soft [n]\n' \
					-i '    Soft reset HEAD by n commits (default: 1)\n\n' \
					-w '-rh | --reset-hard [n]\n' \
					-i '    Hard reset HEAD by n commits (default: 1)\n\n' \
					-c -R \
					-i 'Color legend:\n' \
					-s '    [green]   commit message / signing flags\n' \
					-w '    [yellow]  commit operations (amend, reset, counts)\n' \
					-a '    [teal]    commit ancestry toggles (~ for commits, ^ for parents)\n' \
				2>&1 | ${PAGER:-tee}
				nx_misc_shift 1
			};;
			.) {
				nx_misc_shift 1
				return
			};;
			*) {
				test -n "$nx_flg" && {
					git commit $sign -m "${nx_msg:-$2}"
					nx_misc_shift 1
					test -n "$nx_msg" || nx_misc_shift 1 && shift || return
				}
				return 0
			};;
		esac
		test "$#" -eq 0 && return
		nx_flg=""
		shift
	done
}

