#nx_include NEX_L:/sh/nex-git.sh

__nx_git_branch()
{
	while test "$#" -gt 0; do
		case "$1" in
			o) {
				origin="$2"
			};;
			b) {
				branch="$2"
			};;
			*) {
				return 0
			};;
		esac
		shifts=$((shifts + 1))
		shift
	done

}

