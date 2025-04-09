
del_tex_int()
{
	[ -n "$G_NEX_MOD_DOC" ] && (
		for i in "${G_NEX_MOD_DOC}/"*; do
			[ -d "$i" ] || {
				case "$i" in
					*.pdf|*.tex);;
					*) rm "$i";;
				esac
			}
		done
	)
}

