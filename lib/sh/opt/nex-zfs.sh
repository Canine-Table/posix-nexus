

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

nx_zfs_cache()
{
	h_nx_cmd zpool && zpool list "$1" 2>/dev/null 1>&2 && (
		tmpa="$(test -f "$2" && printf "$2" || printf '/etc/zfs/zpool.cache')"
		zpool import -c "$tmpa"
		zpool set cachefile="$tmpa" "$1"
	)
}
nx_zfs_list()
{
	nx_tty_div -d
	h_nx_cmd zpool && zpool list -v
	nx_tty_div -s
	h_nx_cmd zfs && zfs list -H
	nx_tty_div -d
}
