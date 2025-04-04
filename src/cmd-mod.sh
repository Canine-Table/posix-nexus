#!/bin/sh

###:( get ):##################################################################################

has_cmd()
{
	while [ ${#@} -gt 0 ]; do
		command -v "$1" 1>/dev/null 2>&1 || return 1
		shift
	done
}

get_cmd()
{
	while [ ${#@} -gt 0 ]; do
		command -v "$1" && return
		shift
	done
	return 1
}

get_cmd_pager()
{
	get_cmd less more tee
}

get_cmd_awk()
{
	get_cmd mawk nawk awk gawk
}

get_cmd_shell()
{
	get_cmd dash sh ash mksh posh yash ksh loksh pdksh bash zsh fish
}

get_cmd_editor()
{
	get_cmd nvim vim gvim vi
}

get_cmd_tex_compiler()
{
	get_cmd latexmk pdflatex lualatex xelatex
}

get_cmd_pdf_viewer()
{
	get_cmd zathura mupdf evince
}

get_cmd_pkgmgr()
{
	get_cmd pacman apk port apt zypper dnf yum pkg brew emerge
}

##############################################################################################

