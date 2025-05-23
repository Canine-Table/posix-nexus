#!/bin/sh

h_nx_cmd()
{
	while [ ${#@} -gt 0 ]; do
		command -v "$1" 1>/dev/null 2>&1 || return 1
		shift
	done
}

g_nx_cmd()
{
	while [ ${#@} -gt 0 ]; do
		command -v "$1" && return
		shift
	done
	return 1
}

nx_cmd_pager()
{
	g_nx_cmd less more tee
}

nx_cmd_awk()
{
	g_nx_cmd mawk nawk awk gawk
}

nx_cmd_shell()
{
	g_nx_cmd dash sh ash mksh posh yash ksh loksh pdksh bash zsh fish
}

nx_cmd_editor()
{
	g_nx_cmd nvim vim gvim vi
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

