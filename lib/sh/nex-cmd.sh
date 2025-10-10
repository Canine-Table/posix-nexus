
h_nx_cmd()
{
	while test "$#" -gt 0; do
		command -v "$1" 1>/dev/null 2>&1 || return 1
		shift
	done
}

g_nx_cmd()
{
	while test "$#" -gt 0; do
		command -v "$1" && return
		shift
	done
	return 1
}

nx_cmd_pager()
{
	g_nx_cmd less more most tee
}

nx_cmd_awk()
{
	g_nx_cmd mawk nawk gawk awk
}

nx_cmd_shell()
{
	g_nx_cmd sh ash dash mksh posh yash ksh loksh pdksh bash zsh fish
}

nx_cmd_editor()
{
	g_nx_cmd nvim vim gvim vim.tiny vi
}

nx_cmd_cc()
{
	g_nx_cmd clang gcc cc
}

nx_cmd_pkgmgr()
{
	g_nx_cmd pacman apk port apt zypper dnf yum pkg brew emerge
}

nx_cmd_aurmgr()
{
	g_nx_cmd yay pacaur aurutils trizen pikaur paru
}

nx_cmd_container()
{
	g_nx_cmd podman docker-rootless docker
}

nx_cmd_sudo()
{
	g_nx_cmd doas sudo sudo-rs
}

nx_cmd_clipboard() {
	g_nx_cmd ${SSH_CLIENT:+lemonade} ${DISPLAY:+xsel xclip} ${WAYLAND_DISPLAY:+wl-copy wayclip} ${TMUX:+tmux}
}


nx_cmd_wget()
{
	g_nx_cmd curl wget
}


nx_cmd_sql()
{
	g_nx_cmd mariadb mysql
}

nx_cmd_sockets()
{
	g_nx_cmd ss netstat
}

