#nx_include NEX_L:/sh/nex-git.sh

__nx_git_config()
{
	while test "$#" -gt 0; do
		case "$1" in
			l) {
				git config --$nscope${nscope:+-}$scope --list
			};;
			s) {
				case "$2" in
					g|G) {
						scope='global'
						test "$2" = "G" && nscope=''
						test "$2" = "G" && nscope='no' || nscope=''
					};;
					l|L) {
						scope='local'
						test "$2" = "L" && nscope='no' || nscope=''
						nscope=''
					};;
					*) {
						shifts=$((shifts - 1))
					};;
				esac
				shifts=$((shifts + 1))
				shift
			};;
			un) {
				git config --$nscope${nscope:+-}$scope user.name "$2"
				shifts=$((shifts + 1))
				shift
			};;
			ue) {
				git config --$nscope${nscope:+-}$scope user.email "$2"
				shifts=$((shifts + 1))
				shift
			};;
			*) {
				return 0
			};;
		esac
		shifts=$((shifts + 1))
		shift
	done
}
