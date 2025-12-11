
nx_states()
(
	__nx_states "$@"
)

__nx_states()
{
	while test "$#" -gt 0; do
		nx_flg="$1"
		shift
		nx_shft=0
		case "$nx_flg" in
			a) {
				__nx_state_a "$@"
			};;
			d) {
				__nx_state_d "$@"
			};;
			.) break;;
		esac
		test "$nx_shft" -gt 0 && shift "$nx_shft"
	done
}

__nx_state_d()
{
	while :; do
		case "$1" in
			e) {
				printf '%s\n' 'e state'
				nx_misc_shift 1
			};;
			f) {
				printf '%s %s\n' 'f state with' "${2:-no argument}"
				nx_misc_shift 2 "$#" || return 0
				shift
			};;
			.) {
				nx_misc_shift 1
				return
			};;
			*) {
				test -n "$nx_flg" && printf '%s\n' 'd state'
				return
			};;
		esac
		test "$#" -eq 0 && return
		nx_flg=""
		shift
	done
}

__nx_state_a()
{
	while :; do
		case "$1" in
			b) {
				printf '%s\n' 'b state'
				nx_misc_shift 1
			};;
			c) {
				printf '%s %s\n' 'c state with' "${2:-no argument}"
				nx_misc_shift 2 "$#" || return 0
				shift
			};;
			.) {
				nx_misc_shift 1
				return
			};;
			*) {
				test -n "$nx_flg" && printf '%s\n' 'a state'
				return
			};;
		esac
		test "$#" -eq 0 && return
		nx_flg=""
		shift
	done
}

