
#__pkg_list()
#(
#	if tmpa="$(nx_cmd_aurmgr)"; then
#		tmpb="$(nx_cmd_pkgmgr)"
#	else
#		tmpa="$(nx_cmd_pkgmgr)"
#	fi

	#tmpa="$(nx_cmd_aurmgr || nx_cmd_pkgmgr)" && tmpb="$(nx_cmd_pkgmgr)"
#)


__nx_ev_pid()
{
	exec 3<&-
	while test "$#" -gt 0; do
		read < "$1"
		kill -9 "$REPLY"
		rm -f "$1"
		shift
	done 2> /dev/null
}

nx_ev_fifo()
{
	NEXUS_PID="$(nx_fs_noclobber -v "$NEXUS_ENV/run/$$.$(nx_str_timestamp -f)-$(nx_str_rand 16).pid")"
	(
		ttou="$(nx_fs_fifo -t "$1" "ttou")"
		ttin="$(nx_fs_fifo -t "$1" "ttin")"
		ev="$(nx_fs_noclobber -v "$NEXUS_ENV/run/$$.$(nx_str_timestamp -f)-$(nx_str_rand 16).pid")"
		trap "nx_fs_fifo -r $ttin; nx_fs_fifo -r $ttou; __nx_ev_pid $ev; rm -f $NEXUS_PID" EXIT HUP INT TERM
		printf '%s' "$ttou"
		${AWK:-$(nx_cmd_awk)} \
			-v ttin="$ttin" \
			-v ttou="$ttou" \
		'
			BEGIN {
				while(line != "EXIT") {
					getline line < ttin
					printf("%d %s\n", ++cnt, line) > ttou
					fflush(ttou)
					close(ttin)
				}
			}
		' & printf '%d' "$!" > "$ev"
		exec 3< "$ttou"
		while read -u 3; do
			case "$REPLY" in
				*EXIT) break;;
				*) echo "hello $REPLY";;
			esac
		done
	) & printf '%d' "$!" > "$NEXUS_PID"
}

