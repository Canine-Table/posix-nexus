
nx_io_fifo_mgr()
{
	h_nx_cmd mkfifo && {
		while [ ${#@} -gt 0 ]; do
			if [ "$1" = '-r' -a -p "$2" ]; then
				rm "$2"
				shift
			elif [ "$1" = '-c' ]; then
				(
					while [ -z "$nx_fifo" ]; do
						nx_fifo="$G_NEX_MOD_ENV/nx_$(nx_str_rand 32).fifo"
						[ -e "$nx_fifo" ] && unset nx_fifo
					done
					mkfifo "$nx_fifo"
					echo "$nx_fifo"
				)
			fi
			shift
		done
	}
}

nx_io_dir()
{
	while [ ${#@} -gt 0 ]; do
		nx_content_container "$1" 1>/dev/null 2>&1 || return 1
		shift
	done
}

nx_io_leaf()
{
	while [ ${#@} -gt 0 ]; do
		nx_content_leaf "$1" 1>/dev/null 2>&1 || return 1
		shift
	done
}

nx_io_mv()
{
	h_nx_cmd rsync find && nx_io_dir "$1" "$2" && (
		if="$(nx_content_container "$1")"
		of="$(nx_content_container "$2")"
		[ -n "$if" -a -n "$of" -a "$if" != "$of" ] && {
			rsync -av --remove-source-files "$1" "$2"
			find "$1" -type d -empty -delete
		}
	)
}

