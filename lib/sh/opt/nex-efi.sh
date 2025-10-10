
nx_efi_bak()
(
	h_nx_cmd efi-readvar || {
		nx_io_printf -E 'efi-readvar not found!' 1>&2
		exit 1
	}

	tmpa="$(nx_info_canonize "$(test -d "$1" && printf '%s' "$1" || printf '%s' "$HOME")")"
	for tmpb in PK KEK db dbx ; do
		efi-readvar -v $tmpb -o "$(nx_io_noclobber -p "$tmpa/old_$tmpb" -s '.esl')"
	done
)

