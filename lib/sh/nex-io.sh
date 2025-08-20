
nx_io_fifo_mgr()
{
	h_nx_cmd mkfifo && {
		while [ "${#@}" -gt 0 ]; do
			if [ "$1" = '-r' -a -p "$2" ]; then
				rm "$2"
				shift
			elif [ "$1" = '-c' ]; then
				tmpa=""
				while [ -z "$tmpa" ]; do
					tmpa="$NEXUS_ENV/nx_$(nx_str_rand 32).fifo"
					[ -e "$tmpa" ] && unset tmpa
				done
				mkfifo "$tmpa"
				printf '%s\n' "$tmpa"
			fi
			shift
		done
	}
}

nx_io_type()
{
	tmpa="$(${AWK:-$(nx_cmd_awk)} \
		-v str="$(nx_str_chain "$@")" \
	"
		$(nx_data_include -i "$NEXUS_LIB/awk/nex-shell.awk")
	"'
		BEGIN {
			if (s = nx_file_type(str))
				printf("%s\n", s)
			else
				exit 2
		}
	')"
	echo "$tmpa"
}
