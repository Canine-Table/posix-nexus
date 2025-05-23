nx_tex_export()
{
	export G_NEX_TEX_VIEWER="$(g_nx_cmd zathura mupdf evince skim)"
	export G_NEX_TEX_COMPILER="$(g_nx_cmd lualatex luatex latexmk pdflatex xelatex)"
	export G_NEX_TEX_BACKEND="$(g_nx_cmd latexmk latexrun tectonic arara)"
	export G_NEX_BIB_BACKEND="$(g_nx_cmd biber bibtex bibparse bibtexparser)"
	export TEXMFHOME="${G_NEX_MOD_LIB}/lua/lualatex"
	#nx_tex_var 'TEXMFCNF' "${G_NEX_MOD_CNF}//" ':' 1
}

nx_tex_var()
{
	[ -n "$1" ] && {
		export "$(
			v="$(nx_struct_ref "$1")"
			[ -z "$v" ] && v=$(kpsewhich -var-value "$1")
			eval "$1=$(${AWK:-$(nx_cmd_awk)} \
				-v val="$v" \
				-v side="$4" \
				-v sep="${3:-:}" \
			"
				$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-str.awk")
			"'
				BEGIN {
					if (val ~ "^\{.*\}$")
						val = nx_slice_str(val, 2, 0, 0)
					if (val)
						gsub(",", sep, val)
					else
						exit 1
					print val
				}
			')"
			echo "$1=$(nx_content_append "$1" "$2" "${3:-:}" "$4")"
		)"
	}
}

