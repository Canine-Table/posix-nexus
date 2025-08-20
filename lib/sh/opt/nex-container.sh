
nx_container_export()
{
	export G_NEX_CONTAINER="$(nx_cmd_container)"
}

nx_container_alpine_test()
{
	[ -n "$G_NEX_CONTAINER" ] && (
		h="$(hostname | cut -d 1 -f 1)"
		if [ "$1" = '-c' ]; then
			{
				for i in $(
					$G_NEX_CONTAINER container ls -a --format='{{.Names}} {{.ID}}' | ${AWK:-$(get_cmd_awk)} -v hst="$h" '{
						if ($1 ~ "^" h "_alpine_[a-zA-Z0-9]{16}$") {
							print $2
						}
					}'
				); do
					(
						$G_NEX_CONTAINER container stop $i
						$G_NEX_CONTAINER container rm $i
					) &
				done
			} > /dev/null 2>&1
		else
			CONTAINER_ID="$(
				UNIQUE="$(nx_str_rand 16)"
				$G_NEX_CONTAINER container run --detach \
					--name "${h}_alpine_${UNIQUE}" \
					--label "${UNIQUE}" \
					--hostname "alpine-${UNIQUE}.$(hostname | cut -d '.' -f 2-)" \
					--publish-all \
					alpine:latest ash -c "while :; do sleep 1; done"
			)" && {
				$G_NEX_CONTAINER container exec --interactive --tty ${CONTAINER_ID} ash
			}
		fi
	)
}

nx_container_rm_none()
{
	[ -n "$G_NEX_CONTAINER" ] && (
		$G_NEX_CONTAINER image ls -a | sed -n '2,$p' | ${AWK:-$(get_cmd_awk)} '{
			if ($1 == $2 && $2 == "<none>")
				print $3
		}' | while read -r i; do
			$G_NEX_CONTAINER image rm -f "$i" &
		done > /dev/null
	)
}

nx_container_rm_all_v()
{
	[ -n "$G_NEX_CONTAINER" ] && (
		$G_NEX_CONTAINER volume ls -a | sed -n '2,$p' | ${AWK:-$(get_cmd_awk)} '{print $2}' |
		while read -r i; do
			$G_NEX_CONTAINER volume rm -f "$i" &
		done > /dev/null
	)
}

nx_container_rm_all_i()
{
	[ -n "$G_NEX_CONTAINER" ] && (
		$G_NEX_CONTAINER image ls -a | sed -n '2,$p' | ${AWK:-$(get_cmd_awk)} '{print $3}' |
		while read -r i; do
			$G_NEX_CONTAINER image rm -f "$i" &
		done > /dev/null
	)
}


nx_container_rm_all_c()
{
	[ -n "$G_NEX_CONTAINER" ] && (
		$G_NEX_CONTAINER container ls -a | sed -n '2,$p' | ${AWK:-$(get_cmd_awk)} '{print $1}' |
		while read -r i; do
			$G_NEX_CONTAINER container rm -f "$i" &
		done > /dev/null
	)
}

nx_container_export

