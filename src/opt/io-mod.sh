
nx_fifo_mgr()
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

