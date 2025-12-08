#nx_include nex-TeX.d/nex-glossaries.sh
#nx_include nex-cmd.sh

nx_tex_lua_path()
{
	h_nx_cmd luatex || return 127
	G_NEX_LUA_ROCKS="$(
		tmpa="$(luatex --luaonly "$NEXUS_LIB/lua/luatex/version.lua")"
		nx_data_path_append -v G_NEX_LUA_ROCKS -s ':' \
			$(h_nx_cmd luarocks && printf '%s' "$HOME/.luarocks/lib/lua/$tmpa") \
			"/usr/lib/lua/$tmpa"
	)"
	test -n "$G_NEX_LUA_ROCKS" && {
		export G_NEX_LUA_ROCKS
		return 0
	} || {
		unset G_NEX_LUA_ROCKS
		return 1
	}
}

nx_tex_export()
{
	export G_NEX_TEX_VIEWER="$(g_nx_cmd zathura mupdf evince skim)"
	export G_NEX_TEX_COMPILER="$(g_nx_cmd lualatex luatex latexmk pdflatex xelatex)"
	export G_NEX_TEX_BACKEND="$(g_nx_cmd latexmk latexrun tectonic arara)"
	export G_NEX_BIB_BACKEND="$(g_nx_cmd biber bibtex bibparse bibtexparser)"
	export TEXMFHOME="${NEXUS_LIB}/tex"
	export TEXINPUTS="${TEXMFHOME}/sty//://:"
	nx_tex_lua_path && export CLUAINPUTS="${G_NEX_LUA_ROCKS}//://:"
	export LUAINPUTS="${G_NEX_LUA_ROCKS}${G_NEX_LUA_ROCKS:+//:}${NEXUS_LIB}/lua://:"
	unset E_NEX_TEX
}

export E_NEX_TEX=true
