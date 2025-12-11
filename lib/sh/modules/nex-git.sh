#nx_include nex-git.d/nex-config.sh
#nx_include nex-git.d/nex-log.sh
#nx_include nex-git.d/nex-remote.sh
#nx_include nex-git.d/nex-commit.sh

nx_git()
(
	origin='upstream'
	branch='main'
	nx_prnt='~'
	nx_obj_fmt='sha1'
	sign=""
	scope=""
	no_scope=""
	__nx_git "$@"
)

__nx_git()
{
	while test "$#" -gt 0; do
		nx_flg="$1"
		shift
		nx_shft=0
		case "$nx_flg" in
			--log|-l) {
				__nx_git_log "$@"
			};;
			--remote|-r) {
				__nx_git_remote "$@"
			};;
			--save|-s|--commit) {
				__nx_git_commit "$@"
			};;
			--config|-c) {
				__nx_git_config "$@"
			};;
			.) return;;
			-h|--help) {
				nx_tty_print \
					-i 'Usage: nx_git [sub-command] [options]\n\n' \
					-s '--log | -l\n' \
					-i '    View commit history and graph overlays\n\n' \
					-w '--remote | -r\n' \
					-i '    Manage remotes, sync branches, and merge strategies\n\n' \
					-s '--save | -s | --commit\n' \
					-i '    Create commits, amend, reset, and sign\n\n' \
					-w '--config | -c\n' \
					-i '    Set git configuration options and scope\n\n' \
					-c -R \
					-i 'Color legend:\n' \
					-s '    [green]   commit and log operations\n' \
					-w '    [yellow]  remote and config operations\n' \
				2>&1 | ${PAGER:-tee}
			};;
		esac
		test "$nx_shft" -gt 0 && shift "$nx_shft"
	done
}

