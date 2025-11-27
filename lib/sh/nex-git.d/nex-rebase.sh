#nx_include NEX_L:/sh/nex-git.sh

__nx_git_rebase()
{
	while test "$#" -gt 0; do
		case "$1" in
			rt) {
				git rebase "$origin/$branch" --strategy=recursive -X theirs
			};;
			ab) {
				git rebase --abort
			};;
			ct) {
				git rebase --continue
			};;
			*) {
				return 0
			};;
		esac
		shifts=$((shifts + 1))
		shift
	done
}
