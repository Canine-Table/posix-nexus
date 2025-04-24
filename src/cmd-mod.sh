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

nx_cmd_tex_compiler()
{
	g_nx_cmd lualatex luatex latexmk pdflatex xelatex
}

nx_cmd_pdf_viewer()
{
	g_nx_cmd zathura mupdf evince
}

nx_cmd_pkgmgr()
{
	g_nx_cmd pacman apk port apt zypper dnf yum pkg brew emerge
}

