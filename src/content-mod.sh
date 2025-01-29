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

get_content_filter_list()
{
	(
		while getopts DdFfCcBbPpSsHhRrWwXx OPT; do
			case $OPT in
				d|f|c|b|p|s|h) f="$f${f:+,}$OPT";;
				D|F|C|B|P|S|H|R|W|X) F="$F${F:+,}$OPT";;
				r|w|x) p="$p${p:+}$OPT";;
			esac
		done
		shift $((OPTIND - 1))
		template="$(
			$(get_cmd_awk) \
				-v pis="$p" \
				-v fis="$f" \
				-v fnot="$F" "
				$(
					cat "$G_NEX_MOD_LIB/awk/struct.awk"
				)
			"'
				BEGIN {
					if (fnot) {
						array(tolower(fnot), nota, ",")
						for (i in nota) {
							if (nstr)
								nstr = nstr "-a"
							nstr = nstr " ! -" i " \x27<1>\x27 "
						}
						delete nota
						if (nstr)
							nstr = "[" nstr "]"
					}
					if (fis) {
						array(fis, isa, ",")
						for (i in isa) {
							if (istr)
								istr = istr "-o"
							istr = istr " -" i " \x27<1>\x27 "
						}
						delete isa
						if (istr) {
							istr = "[" istr "]"
							if  (nstr)
								nstr = nstr " && "
						}
					}
					if (pis) {
						array(pis, isa, ",")
						for (i in isa) {
							if (pstr)
								pstr = pstr "-a"
							pstr = pstr " -" i " \x27<1>\x27 "
						}
						delete isa
						if (pstr) {
							pstr = "[" pstr "]"
							if  (nstr || istr)
								pstr = " && " pstr
						}
					}
					print nstr istr pstr
				}
			'
		)"
		for i in "$@"; do
			j=$(get_content_path "$i") && {
				[ -z "$template" ] && {
					k="$k${k:+,}$j"
				} || {
					eval "$(set_str_format -f "$j" "$template")" && {
						k="$k${k:+,}$j"
					}
				}
			}
		done
		get_struct_clist -u "$k"
	)
}

add_content_modules() {
	for f in "$(get_content_path "$G_NEX_MOD_SRC")/"*"-mod.sh"; do
		[ -f "$f" -a -r "$f" -a "$(get_content_leaf "$f")" != 'content-mod.sh' ] && . "$f"
	done
	unset f
}

export G_NEX_ROOT="/usr/local/bin/nex"
export G_NEX_MOD_SRC="$G_NEX_ROOT/src"
export G_NEX_MOD_LIB="$G_NEX_ROOT/lib"

export VIMINIT='source $G_NEX_MOD_LIB/viml/init.vim'
export LESS='-R'
export COLORFGBG=';0'

add_content_modules
export PAGER="$(get_cmd_pager)"
export EDITOR="$(get_cmd_editor)"
export SHELL="$(get_cmd_shell)"
export AWK="$(get_cmd_awk)"
export PDF_VIEWER="$(get_cmd_pdf_viewer)"
export TEX_COMPILER="$(get_cmd_pdf_viewer)"

