#!/bin/sh

nx_bundle_include()
{
	(
		# best if sigil is the comment of the language
		# the directive can be whatever
		# output defaults to stdout (fd 1)
		# input through -i or first remaining parameter
		# f if you want to force clobber
		while getopts :d:f:s:o:i: OPT; do
			case $OPT in
				s|d|f|o|i) eval "$OPT"="'$OPTARG'";;
			esac
		done
		shift $((OPTIND - 1))
		[ -e "$o" -a -n "$f" ] && mv "$o" "${o}-$(date +"%s").bak"
		[ -z "$o" ] && o='/dev/stdout'
		i="$(nx_content_path "${i:-$1}")"
		[ -f "$i" -a -r "$i" ] && {
			cat "$i" | ${AWK:-$(nx_cmd_awk)} \
				-v sig="${s:-#}" \
				-v dir="${d:-nx_include}" \
				-v inpt="$i" \
			"
				$(cat \
					"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
					"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
					"$G_NEX_MOD_LIB/awk/nex-str.awk" \
					"$G_NEX_MOD_LIB/awk/nex-math.awk"
				)
			"'
				BEGIN {
					d = sig dir
				}
				{
					if (s = nx_bundle($0, d, inpt, ara, arb))
						print s
				}
				END {
					delete ara
					delete arb
				}
			' > "$o"
		} || exit 1
	)
}

nx_content_root()
{
	(
		for f in 'cnf' 'env/rom/al8800bt'; do
			[ "$(nx_content_leaf "$G_NEX_ROOT/$f")" = "$f" ] || mkdir -p "$G_NEX_ROOT/$f"
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
		[ -f "$f" -a -r "$f" -a "$(nx_content_leaf "$f")" != 'init-mod.sh' ] && . "$f"
	done
	unset f
}

nx_content_append()
{
	echo "$(
		v="$(nx_struct_ref "$1")"
		[ -z "$2" ] && {
			echo "$v"
			exit
		}
		s="${3:-:}"
		case "$s$v$s" in
			*"$s$2$s"*) echo "$v";;
			*) {
				if [ -n "$4" ]; then
					echo "$2${v:+$s$v}"
				else
					echo "${v:+$v$s}$2"
				fi
			};;
		esac
	)"
}

##############################################################################################

export G_NEX_ROOT="/root/.local/posix-nexus"
export G_NEX_MOD_SRC="$G_NEX_ROOT/src"
export G_NEX_MOD_LIB="$G_NEX_ROOT/lib"
export G_NEX_MOD_CNF="$G_NEX_ROOT/cnf"
export G_NEX_MOD_ENV="$G_NEX_ROOT/env"
export G_NEX_MOD_DOC="$G_NEX_ROOT/docs"
export G_NEX_MOD_LOG="$G_NEX_MOD_ENV"
export TMPDIR="$G_NEX_MOD_ENV"

nx_content_root
nx_content_modules
nx_tex_export
nx_editor_export
nx_asm_export

export G_NEX_WEB_FETCH="$(g_nx_cmd curl wget)"
export LESS='-R'
export COLORFGBG=';0'
export DIALOGRC="$G_NEX_MOD_CNF/.dialogrc"
export PAGER="$(nx_cmd_pager)"
export SHELL="$(nx_cmd_shell)"
export AWK="$(nx_cmd_awk)"
export PKGMGR="$(nx_cmd_pkgmgr)"
export CC="$(nx_cmd_cc)"

alias nex='. "$G_NEX_MOD_SRC/init-mod.sh"'
alias nx=nex
alias vi='$EDITOR'
alias pgr='$PAGER'
alias pkgmgr='nx_pkgmgr'

##############################################################################################

