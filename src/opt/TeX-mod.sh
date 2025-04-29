d_nx_tex_int()
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

nx_tex_var()
{
	[ -n "$1" ] && {
		export "$(
			v="$(nx_struct_ref "$1")"
			[ -z "$v" ] && v=$(kpsewhich -var-value "$1")
			eval "$1=$(${AWK:-$(nx_cmd_awk)} \
				-v val="$v" \
				-v side="$4" \
				-v sep="${3:-:}" "
				$(cat \
					"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
					"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
					"$G_NEX_MOD_LIB/awk/nex-str.awk" \
					"$G_NEX_MOD_LIB/awk/nex-math.awk" \
					"$G_NEX_MOD_LIB/awk/nex-algor.awk"
				)
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

