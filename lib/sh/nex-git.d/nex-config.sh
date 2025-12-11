#nx_include NX_L:/sh/nex-git.sh

__nx_git_scope()
{
	tmpa="$no_scope${nx_scope:+-}$scope"
	test -n "$tmpa" && printf '--%s' "$tmpa" || true
}

__nx_git_config()
{
	while :; do
		case "$1" in
			+A|sign) {
				sign='-S'
				nx_misc_shift 1
			};;
			!A|remove-sign) {
				sign=''
				nx_misc_shift 1
			};;
			+B|branch) {
				branch="${2:-main}"
				nx_misc_shift 2 "$#" || return
				shift
			};;
			+O|origin) {
				branch="${2:-upstream}"
				nx_misc_shift 2 "$#" || return
				shift
			};;
			+G|global) {
				scope="global"
				nx_misc_shift= 1
			};;
			+L|local) {
				scope="local"
				nx_misc_shift 1
			};;
			+S|system) {
				scope="system"
				nx_misc_shift 1
			};;
			!D|default) {
				scope=""
				no_scope=""
				nx_misc_shift 1
			};;
			+Y|yes|!N) {
				no_scope=""
				nx_misc_shift 1
			};;
			+N|no|!Y) {
				no_scope="no"
				nx_misc_shift 1
			};;
			-mt|--merge-tool) {
				git config $(__nx_git_scope) merge.tool "${2:-vimdiff}"
				nx_misc_shift 2 $# || return
				shift
			};;
			-ue|--user-email) {
				git config $(__nx_git_scope) user.email "${2:-$(whoami)@$(cat /etc/hostname)}"
				nx_misc_shift 2 $# || return
				shift
			};;
			-un|--user-name) {
				git config $(__nx_git_scope) user.name "${2:-$(whoami)}"
				nx_misc_shift 2 $# || return
				shift
			};;
			-ce|--core-editor) {
				git config $(__nx_git_scope) core.editor "${2:-$EDITOR}"
				nx_misc_shift 2 $# || return
				shift
			};;
			-cu|--color-ui) {
				git config $(__nx_git_scope) color.ui "${2:-auto}"
				nx_misc_shift 2 $# || return
				shift
			};;
			-pd|--push-default) {
				git config $(__nx_git_scope) push.default "${2:-simple}"
				nx_misc_shift 2 $# || return
				shift
			};;
			-ch|--credential-helper) {
				git config $(__nx_git_scope) credential.helper "${2:-cache}"
				nx_misc_shift 2 $# || return
				shift
			};;
			-idb|--init-default-branch) {
				git config $(__nx_git_scope) init.defaultbranch "${2:-${branch:-main}}"
				nx_misc_shift 2 $# || return
				shift
			};;
			-crfv|--core-repository-format-version) {
				git config $(__nx_git_scope) core.repositoryformatversion "${2:-0}"
				nx_misc_shift 2 $# || return
				shift
			};;
			-cfm|--core-filemode) {
				git config $(__nx_git_scope) core.filemode "${2:-true}"
				nx_misc_shift 2 $# || return
				shift
			};;
			-clru|--core-logicalrefupdates) {
				git config $(__nx_git_scope) core.logallrefupdates "${2:-true}"
				nx_misc_shift 2 $# || return
				shift
			};;
			-cb|--core-bare) {
				git config $(__nx_git_scope) core.bare "${2:-false}"
				nx_misc_shift 2 $# || return
				shift
			};;
			-h|--help) {
				nx_tty_print \
					-i 'Usage: nx_git --config [options]\n\n' \
					-s '+A | sign/authenticate\n' \
					-i '    Enable commit signing (-S)\n\n' \
					-s '!A | remove-sign\n' \
					-i '    Disable commit signing\n\n' \
					-w '+B | branch [name]\n' \
					-i '    Set default branch (default: main)\n\n' \
					-w '+O | origin [name]\n' \
					-i '    Set origin branch (default: upstream)\n\n' \
					-s '+G | global\n' \
					-i '    Apply config globally\n\n' \
					-s '+L | local\n' \
					-i '    Apply config locally\n\n' \
					-s '+S | system\n' \
					-i '    Apply config system-wide\n\n' \
					-a '!D | default\n' \
					-i '    Reset scope to default\n\n' \
					-a '+Y | yes / !N\n' \
					-i '    Clear no_scope flag\n\n' \
					-a '+N | no / !Y\n' \
					-i '    Set no_scope flag\n\n' \
					-w '-mt | --merge-tool [tool]\n' \
					-i '    Set merge tool (default: vimdiff)\n\n' \
					-w '-ue | --user-email [email]\n' \
					-i '    Set user email (default: whoami@hostname)\n\n' \
					-w '-un | --user-name [name]\n' \
					-i '    Set user name (default: whoami)\n\n' \
					-w '-ce | --core-editor [editor]\n' \
					-i '    Set core editor (default: $EDITOR)\n\n' \
					-w '-cu | --color-ui [mode]\n' \
					-i '    Set color.ui (default: auto)\n\n' \
					-w '-pd | --push-default [mode]\n' \
					-i '    Set push.default (default: simple)\n\n' \
					-w '-ch | --credential-helper [helper]\n' \
					-i '    Set credential.helper (default: cache)\n\n' \
					-w '-idb | --init-default-branch [name]\n' \
					-i '    Set init.defaultbranch (default: main)\n\n' \
					-w '-crfv | --core-repository-format-version [num]\n' \
					-i '    Set core.repositoryformatversion (default: 0)\n\n' \
					-w '-cfm | --core-filemode [true|false]\n' \
					-i '    Set core.filemode (default: true)\n\n' \
					-w '-clru | --core-logicalrefupdates [true|false]\n' \
					-i '    Set core.logallrefupdates (default: true)\n\n' \
					-w '-cb | --core-bare [true|false]\n' \
					-i '    Set core.bare (default: false)\n\n' \
					-c -R \
					-i 'Color legend:\n' \
					-s '    [green]   scope/sign flags\n' \
					-w '    [yellow]  config options\n' \
					-a '    [teal] special toggles\n' \
				2>&1 | ${PAGER:-tee}
				nx_misc_shift 1
			};;
			.) {
				nx_misc_shift 1
				return
			};;
			*) {
				test -n "$nx_flg" && git config $(__nx_git_scope) --list
				return
			};;
		esac
		test "$#" -eq 0 && return
		nx_flg=""
		shift
	done
}

