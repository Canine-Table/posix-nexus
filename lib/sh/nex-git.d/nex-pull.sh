#nx_include NEX_L:/sh/nex-git.sh

__nx_git_pull()
{
	while test "$#" -gt 0; do
		case "$1" in
			p) {
				git pull "$origin" "$branch"
			};;
			f) {
				git fetch "$origin" "$branch"
			};;
			ff) {
				git pull --ff-only "$origin" "$branch"
			};;
			r) {
				git pull --rebase "$origin" "$branch"
			};;
			*) {
				return 0
			};;
		esac
		shifts=$((shifts + 1))
		shift
	done
}

