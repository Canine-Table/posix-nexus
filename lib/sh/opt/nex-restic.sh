

__nx_restic_conf() {
	h_nx_cmd restic || {
		nx_io_printf -E "restic not found! The backup daemon cannot rise—no repository, no snapshot, no invocation." 1>&2
		return 192
	}
	test -f "$NEXUS_CNF/restic.json" || {
		nx_io_printf -E "Configuration scroll '$NEXUS_CNF/restic.json' not found. The backup altar is silent—no parameters, no prophecy." 1>&2
		return 1
	}
	${AWK:-$(nx_cmd_awk)} -v fl="$NEXUS_CNF/restic.json" \
		-v json="{
			  'user': {
			    'id': 42,
			    'name': 'Alice',
			    'email': 'alice@example.com',
			    'roles': [ 'admin', 'editor', 'viewer' ]
			  },
			  'settings': {
			    'theme': 'dark',
			    'notifications': true,
			    'languages': [ 'en', 'fr' ]
			  },
			  'projects': [
			    { 'title': 'Apollo', 'status': 'active' },
			    { 'title': 'Zephyr', 'status': 'archived' }
			  ],
			  'misc': null
			}" "
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-tui.awk")
	"'
		BEGIN {
			if (err = nx_json(json, arr, 2))
				exit err
			#nx_json_split(".user.roles", arr, V2, "")
			for (err in  arr)
				print err " = " arr[err]
			#delete V2
			delete arr
		}
	'
}

