

nx_gpg_menu()
{
	(
		while :; do
			DIALOG_OPTIONS="$(
				nx_dialog_factory -v 'check' -l '
					"title": "GNU Privacy Guard",
					"ok": "Select",
					"cancel": "Exit"
				' -i '
					{
						"value": "bge keys",
						"name": "ree keys"
					},
					{
						"value": "abc keys"
					},
					{
						"value": "get keys"
					},
					{
						"value": "list keys",
						"key": "lst_keys"
					}
				'
			)"
			[ $? = 1 ] && break
			echo "$DIALOG_OPTIONS"

			break
		done
	)
}
