

nx_hw_blocks()
(
	while test "${#@}" -gt 0; do
		case "$1" in
			-l)
				{
					ls -1 /sys/block | while read; do
						nx_io_printf -I "$REPLY"
						#${AWK:-$(nx_cmd_awk)} -v $(ls -l "/sys/proc/*
					done
				};;
		esac
		shift
	done
	#-type f -exec cat {} \;
)

