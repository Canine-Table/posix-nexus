#nx_include NEX_L:/sh/nex-git.sh

__nx_git_stash()
{
	while test "$#" -gt 0; do
		case "$1" in
			s) {
				git stash save "$2"
				shifts=$((shifts + 1))
			};;
			p) {
				git stash pop
			};;
			l) {
				git stash list
			};;
			d) {
				git stash drop
			};;
			*) {
				return 0
			};;
		esac
		shifts=$((shifts + 1))
		shift
	done
}

