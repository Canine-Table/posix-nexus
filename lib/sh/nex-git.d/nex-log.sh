#nx_include NEX_L:/sh/nex-git.sh

__nx_git_log()
{
	while test "$#" -gt 0; do
		case "$1" in
			pt) {
				git log -p
			};;
			st) {
				git log --stat
			};;
			c) {
				git rev-list --count HEAD
			};;
			ogld) {
				git log --oneline --graph --decorate --all
			};;
			*) {
				return 0
			};;
		esac
		shifts=$((shifts + 1))
		shift
	done
}

