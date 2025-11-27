#nx_include NEX_L:/sh/nex-git.sh

__nx_git_merge()
{
	while test "$#" -gt 0; do
		case "$1" in
			rt) {
				git merge -s recursive -X theirs "$origin/$branch"
			};;
			sq) {
				git merge --squash "$origin/$branch"
			};;
			ab) {
				git merge --abort
			};;
			*) {
				return 0
			};;
		esac
		shifts=$((shifts + 1))
		shift
	done
}

