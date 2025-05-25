nx_ssl_gpg()
{
	(
		eval "$(nx_str_optarg ':t:' "$@")"
		${AWK:-$(get_cmd_awk)} \
			-v json="{
				'type': {
					'directory': 'd',
					'pipe': 'p',
					'socket': 's',
					'file': 'f',
					'link': 'l',
					'character': 'c',
					'block': 'b'
				},
				'input': {
					'type': '$t'
				}
			}
		" "
			$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-json.awk")
		"'
			BEGIN {
				nx_json(json, js, 2)
				if (js[".nx.input.type"] = nx_json_match(".type", js[".nx.input.type"], js))
					s = s "-type " js[".nx.input.type"]
				print s
			}
		'
	)
}
