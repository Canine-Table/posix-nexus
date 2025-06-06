nx_gpg_init()
{
	(
		eval "$(nx_init_os)"
		case "$G_NEX_OS_ID" in
			'gentoos')
				{
					gpg --auto-key-locate=clear,nodefault,wkd --locate-key releng@gentoo.org
				};;
		esac
	)
}

nx_gpg_encrypt()
{
	(
		FE="$(
			nx_dialog_explorer -v 'fselect' -l '
				"title": "GNU Privacy Guard",
				"ok": "Select"
			'
		)"
		eval "$(nx_dialog_form -v 'form' -l '
			"title": "GNU Privacy Guard",
			"ok": "Encrypt"
		' -i '
			{
				"name": "Recipient",
				"key": "recipient_id"
			},
			{
				"name": "Output",
				"key": "output_file",
				"value": "'"$FE"'.gpg"
			},
			{
				"name": "Encrypt",
				"key": "encrypt_file",
				"value": "'"$FE"'"
			}
		')"

		gpg --recipient "$recipient_id" \
			--output "$output_file" \
			--encrypt "$encrypt_file"
	)
}

nx_gpg_list()
{
	nx_dialog_factory -v 'msgbox' -l '
		"title": "GNU Privacy Guard",
		"ok": "Back"
	' -m "$(gpg --list-keys)"
}

nx_gpg_menu()
{
	(
		while :; do
			DIALOG_OPTIONS="$(
				nx_dialog_menu -v 'buildlist' -l '
					"title": "GNU Privacy Guard",
					"ok": "Select",
					"cancel": "Exit"
				' -i '
					{
						"value": "List Keys",
						"key": "lst_keys"
					},
					{
						"value": "Encrypt a File",
						"key": "encrypt_a_file"
					}
				'
			)"
			[ $? = 1 ] && break
			eval "$DIALOG_OPTIONS"
			for i in $G_NEX_DIALOG; do
				case "$(nx_struct_ref "G_NEX_DIALOG_${i}")" in
					'lst_keys') nx_gpg_list;;
					'encrypt_a_file') nx_gpg_encrypt;;
				esac
			done
		done
	)
}
