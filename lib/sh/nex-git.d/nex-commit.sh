#nx_include NEX_L:/sh/nex-git.sh

__nx_git_commit()
{
	while test "$#" -gt 0; do
		case "$1" in
			s|S) {
				test "$1" = 'S' && sign='' || sign='-S'
			};;
			a) {
				git commit --amend --no-edit $sign
			};;
			m) {
				git commit $sign -m "$2"
				shifts=$((shifts + 1))
			};;
			cc) {
				git rev-list --left-right --count HEAD...$origin/$branch
			};;
			*) {
				return 0
			};;
		esac
		shifts=$((shifts + 1))
		shift
	done
}

