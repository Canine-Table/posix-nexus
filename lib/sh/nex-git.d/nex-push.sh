#nx_include NEX_L:/sh/nex-git.sh

__nx_git_push()
{
	while test "$#" -gt 0; do
		case "$1" in
			p) {
				git push "$origin" "$branch"
			};;
			su) {
				git push --set-upstream "$origin" "$branch"
			};;
			fwl) {
				git push --force-with-lease "$origin" "$branch"
			};;
			*) {
				return 0
			};;
		esac
		shifts=$((shifts + 1))
		shift
	done
}
