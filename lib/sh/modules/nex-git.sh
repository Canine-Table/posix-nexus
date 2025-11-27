#nx_include nex-git.d/nex-branch.sh
#nx_include nex-git.d/nex-commit.sh
#nx_include nex-git.d/nex-config.sh
#nx_include nex-git.d/nex-fsck.sh
#nx_include nex-git.d/nex-log.sh
#nx_include nex-git.d/nex-merge.sh
#nx_include nex-git.d/nex-pull.sh
#nx_include nex-git.d/nex-push.sh
#nx_include nex-git.d/nex-rebase.sh
#nx_include nex-git.d/nex-stach.sh
#nx_include nex-git.d/nex-status.sh
#nx_include nex-git.d/nex-sync.sh

### Router ### Router ### Router ### Router ### Router ### Router ### Router ### Router ### Router ###

nx_git()
(
	origin='origin'
	branch='main'
	shifts="0"
	sign=""
	scope="global"
	nscope=""
	__nx_git_router "$@"
)

__nx_git_router()
{
	while test "$#" -gt 1; do
		arg="$1"
		shift
		case "$arg" in
			-u|--unite|--sync) {
				__nx_git_sync "$@"
			};;
			-S|--stach) {
				__nx_git_stash "$@"
			};;
			-s|--status) {
				__nx_git_status "$@"
			};;
			-b|--branch) {
				__nx_git_branch "$@"
			};;
			-c|--config) {
				__nx_git_config "$@"
			};;
			-l|--log) {
				__nx_git_log "$@"
			};;
			-r|--rebase) {
				__nx_git_rebase "$@"
			};;
			-m|--merge) {
				__nx_git_merge "$@"
			};;
			-C|--commit) {
				__nx_git_commit "$@"
			};;
			-p|--push) {
				__nx_git_push "$@"
			};;
			-P|--pull) {
				__nx_git_pull "$@"
			};;
		esac
		test "$shifts" -gt 0 && shift "$shifts"
		shifts="0"
	done
}

