#!/bin/sh

##:( get ):##################################################################################

get_content_trim()
{
	echo "$*" | sed 's|\./|/|g; s|/\+|/|g; s|/\+$||'
}

get_content_leaf()
{
	(
		b="$(get_content_container "$*")" || exit 2
		echo "$*" | sed 's|/\+$||; s|.*/||'
	)
}

get_content_container()
{
	(
		if [ -d "$*/." ]; then
			d="$*/."
		elif [ -e "$*" ]; then
			d="$*"
		else
			exit 1
		fi
		get_content_trim "$(cd "$(dirname "$d")" && pwd)"
	)
}

get_content_path()
{
	(
		p="$(get_content_leaf "$*")" || exit 3
		get_content_trim "$(cd $(dirname "$*") && pwd)/$p"
	)
}

get_content_list()
{
	(
		for i in "$@"; do
			j="$(get_content_path "$i")" && {
				k="$(get_content_container "$i")"
				[ "$k" != "$j" ] && ls -l "$j" || ls -dl "$j"
			}
		done
	)
}

###:( add ):##################################################################################

add_content_modules() {
	for f in "$(get_content_path "$G_NEX_MOD_SRC")/"*"-mod.sh"; do
		[ -f "$f" -a -r "$f" -a "$(get_content_leaf "$f")" != 'content-mod.sh' ] && . "$f"
	done
	unset f
}

##############################################################################################

export G_NEX_ROOT="/usr/local/bin/nex"
export G_NEX_MOD_SRC="$G_NEX_ROOT/src"
export G_NEX_MOD_LIB="$G_NEX_ROOT/lib"
export G_NEX_MOD_CNF="$G_NEX_ROOT/cnf"
export G_NEX_MOD_LOG="/tmp"

add_content_modules
export LESS='-R'
export COLORFGBG=';0'
export DIALOGRC="$G_NEX_MOD_CNF/.dialogrc"
export PAGER="$(get_cmd_pager)"
export EDITOR="$(get_cmd_editor)"
export SHELL="$(get_cmd_shell)"
export AWK="$(get_cmd_awk)"
export PKGMGR="$(get_cmd_pkgmgr)"
export TEXCPL="$(get_cmd_tex_compiler)"
export VPDF="$(get_cmd_pdf_viewer)"

alias nex='. "$G_NEX_MOD_SRC/content-mod.sh"'
alias vi='$EDITOR'
alias pgr='$PAGER'
alias pkgmgr='get_pkgmgr'

##############################################################################################

