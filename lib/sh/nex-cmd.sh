
h_nx_cmd()
{
	while test "$#" -gt 0; do
		command -v "$1" || return 226
		shift
	done 2>&1 1>/dev/null
}

_h_nx_cmd()
{
	while read -r; do
		command -v "$REPLY" || return 227
	done 2>&1 1>/dev/null
}

_h_nx_cmd_()
{
	h_nx_cmd "$@" && _h_nx_cmd "$@" || return 228
}

g_nx_cmd()
{
	while test "$#" -gt 0; do
		command -v "$1" && return
		shift
	done
	return 226
}

_g_nx_cmd()
{
	while read -r; do
		command -v "$REPLY" && return
	done
	return 227
}

_g_nx_cmd_()
{
	g_nx_cmd "$@" || _g_nx_cmd "$@" || return 228
}

_g_nx_cmd_nm_()
{
	if test "$#" -eq 0; then
		_g_nx_cmd || return 227
	else
		g_nx_cmd "$@" || return
	fi | tr '\\' '/' | sed 's/.*[/]//'
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
	g_nx_cmd bash zsh dash sh ash mksh posh yash ksh loksh pdksh fish
}

nx_cmd_editor()
{
	g_nx_cmd vim nvim gvim vim.tiny vi
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

nx_cmd_python()
{
	g_nx_cmd python python3 python3.14 python3.$1 python3$1
}

nx_cmd_pip()
{
	g_nx_cmd pip pip3 pip3.14 pip3.$1 pip$1
}

nx_cmd_sockets()
{
	g_nx_cmd ss netstat
}

