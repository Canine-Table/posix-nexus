#nx_include NX_L:/sh/nex-git.sh

__nx_git_log()
{
	while :; do
		case "$1" in
			-pt|--pretty) {
				git log -p
				nx_misc_shift 1
			};;
			-st|--stat) {
				git log --stat
				nx_misc_shift 1
			};;
			-c|--count) {
				git rev-list --count HEAD
				nx_misc_shift 1
			};;
			-ogld|--all) {
				git log --oneline --graph --decorate --all
				nx_misc_shift 1
			};;
			-h|--help) {
				nx_tty_print \
					-i 'Usage: nx_git_log [options]\n\n' \
					-s '-l | --log\n' \
					-i '    Run default git log\n\n' \
					-w '-pt | --pretty\n' \
					-i '    Show full patch diff for each commit\n\n' \
					-w '-st | --stat\n' \
					-i '    Show diffstat summary (files changed, insertions/deletions)\n\n' \
					-s '-c | --count\n' \
					-i '    Show total commit count on current branch\n\n' \
					-a '-ogld | --all\n' \
					-i '    Show oneline decorated graph of all branches\n\n' \
					-c -R \
					-i 'Color legend:\n' \
					-s '    [green]   primary action\n' \
					-w '    [yellow]  sub-option\n' \
					-a '    [magenta] graph view\n'
				nx_misc_shift 1
			};;
			.) {
				nx_misc_shift 1
				return
			};;
			*) {
				test -n "$nx_flg" && git log
				return
			};;
		esac
		test "$#" -eq 0 && return
		nx_flg=""
		shift
	done
}

