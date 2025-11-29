#nx_include NEX_L:/sh/nex-TeX.sh

nx_tex_gls()
(
	makeglossaries \
		-d "$NEXUS_DOC" \
		-t "$NEXUS_ENV/log/vimtex_gls.log" "$@"
)

