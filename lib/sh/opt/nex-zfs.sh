

nx_zfs_mount()
(	
	h_nx_cmd zfs || {
		exit 1
	}
        eval "$(nx_str_optarg ':d:f:t:' "$@")"
	test -z "$d" -o -z "$f" -o -z "$t" && {
		exit 2
	}

	tmpa=$(zfs list | ${AWK:-$(nx_cmd_awk)} \
		-v dataset="$d" \
		-v from="$f" \
		-v to="$t" \
	'
		$1 ~ data {
			if (sub(from, to, $NF)) {
				printf("zfs set mountpoint=%s %s\n", $NF, $1)
			}
		}
	')
	test -n "$tmpa" || {
		exit 3
	}
	eval "$tmpa" || {
		exit 4
	}
)

