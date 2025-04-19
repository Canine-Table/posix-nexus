#!/bin/sh

nx_content_root()
{
	(
		for f in env cnf; do
			[ "$(nx_content_leaf "$G_NEX_ROOT/$f")" = "$f" ] || mkdir "$G_NEX_ROOT/$f"
		done
	)
}

nx_content_trim()
{
	echo "$*" | sed 's|\./|/|g; s|/\+|/|g; s|/\+$||'
}

nx_content_leaf()
{
	(
		b="$(nx_content_container "$*")" || exit 2
		echo "$*" | sed 's|/\+$||; s|.*/||'
	)
}

nx_content_container()
{
	(
		if [ -d "$*/." ]; then
			d="$*/."
		elif [ -e "$*" ]; then
			d="$*"
		else
			exit 1
		fi
		nx_content_trim "$(cd "$(dirname "$d")" && pwd)"
	)
}

nx_content_path()
{
	(
		p="$(nx_content_leaf "$*")" || exit 3
		nx_content_trim "$(cd $(dirname "$*") && pwd)/$p"
	)
}

nx_content_list()
{
	(
		for i in "$@"; do
			j="$(nx_content_path "$i")" && {
				k="$(nx_content_container "$i")"
				[ "$k" != "$j" ] && ls -l "$j" || ls -dl "$j"
			}
		done
	)
}

nx_content_modules()
{
	for f in "$(nx_content_path "$G_NEX_MOD_SRC")/"*"-mod.sh"; do
		[ -f "$f" -a -r "$f" -a "$(nx_content_leaf "$f")" != 'content-mod.sh' ] && . "$f"
	done
	unset f
}

##############################################################################################

export G_NEX_ROOT="/usr/local/bin/nex"
export G_NEX_MOD_SRC="$G_NEX_ROOT/src"
export G_NEX_MOD_LIB="$G_NEX_ROOT/lib"
export G_NEX_MOD_CNF="$G_NEX_ROOT/cnf"
export G_NEX_MOD_ENV="$G_NEX_ROOT/env"
export G_NEX_MOD_DOC="$G_NEX_ROOT/docs"
export G_NEX_MOD_LOG="$G_NEX_MOD_ENV"

nx_content_root
nx_content_modules

export LESS='-R'
export COLORFGBG=';0'
export DIALOGRC="$G_NEX_MOD_CNF/.dialogrc"
export PAGER="$(nx_cmd_pager)"
export EDITOR="$(nx_cmd_editor)"
export SHELL="$(nx_cmd_shell)"
export AWK="$(nx_cmd_awk)"
export PKGMGR="$(nx_cmd_pkgmgr)"
export TEXCPL="$(nx_cmd_tex_compiler)"
export VPDF="$(nx_cmd_pdf_viewer)"

alias nex='. "$G_NEX_MOD_SRC/content-mod.sh"'
alias nx=nex
alias vi='$EDITOR'
alias pgr='$PAGER'
alias pkgmgr='nx_pkgmgr'

##############################################################################################

