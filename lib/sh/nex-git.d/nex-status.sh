#nx_include NEX_L:/sh/nex-git.sh

__nx_git_status()
{
	while test "$#" -gt 0; do
	case "$1" in
		s) {
			git status -sb
		};;
		d) {
			git diff
		};;
		c) {
			git diff --cached
		};;
		*) {
			return 0
		};;
	esac
	shifts=$((shifts + 1))
	shift
	done
}
