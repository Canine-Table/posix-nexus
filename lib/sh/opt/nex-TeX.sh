
nx_tex_export()
{
	export G_NEX_TEX_VIEWER="$(g_nx_cmd zathura mupdf evince skim)"
	export G_NEX_TEX_COMPILER="$(g_nx_cmd lualatex luatex latexmk pdflatex xelatex)"
	export G_NEX_TEX_BACKEND="$(g_nx_cmd latexmk latexrun tectonic arara)"
	export G_NEX_BIB_BACKEND="$(g_nx_cmd biber bibtex bibparse bibtexparser)"
	export TEXMFHOME="${NEXUS_LIB}/tex"
	export TEXINPUTS="${TEXMFHOME}/sty://:"
	export LUAINPUTS="${NEXUS_LIB}/lua://:"
	unset E_NEX_TEX
}

export E_NEX_TEX=true
