
g_nx_misc_port()
{
	h_nx_cmd "$(nx_info_path -b "$G_NEX_SOCKETS")" || {
		nx_io_printf -E "Without ss or netstat, we’re charting the seas without a compass." 1>&2
		return 1
	}
	tmpa="$($G_NEX_SOCKETS -apn 2>/dev/null | ${AWK:-$(nx_cmd_awk)} -v port="$(nx_int_natural "$1")" '
		BEGIN {
			if (! port || port > 65535)
				port = 1025
			split("", pmap, "")
		} {
			if (sub(/^.*:/, "", $5))
				pmap[$5] = 1
			else
				pmap[$6] = 1
			if ($NF ~ /:?[1-9]+[0-9]*$/) {
				sub(/.*:/, "", $NF)
				pmap[$NF] = 1
			} else {
				sub(/.*:/, "", $(NF - 1))
				pmap[$(NF - 1)] = 1
			}
		} END {
			while (port in pmap && port <= 65535)
				port++
			delete pmap
			if (port == 65535)
				exit 1
			print port
		}
	')"
	test -n "$tmpa" || {
		unset tmpa
		nx_io_printf -E "All 65,535 ports are spoken for. The network is now a sold-out stadium." 1>&2
		return 2
	}
}

nx_misc_pid()
(
	test -n "$1" && {
		nx_io_parent "$(printf '%s' "$1" | sed 's/\/$//; s/.pid$//; s/$/.pid/')" "$HOME/.local/run/"
	}
)

nx_misc_brave()
{
	h_nx_cmd brave && {
		while test "${#@}" -gt 0; do
			case "$1" in
				-u|--unlock) rm "$HOME/.config/BraveSoftware/Brave-Browser/Singleton"*;;
				-o|--open) nohup setsid brave 1> /dev/null 2>&1 &;;
			esac
			shift
		done
	}
}


nx_misc_lemonade()
{
	h_nx_cmd lemonade && test -z "$SSH_CLIENT" && (
		tmpc="$(nx_misc_pid "lemonade")"
		ps "$(cat "$tmpc")" 2>/dev/null | grep -q 'lemonade server' || {
			g_nx_misc_port 2489 || return
			nx_io_printf -i "starting the lemonade service on port $tmpa"
			nohup setsid lemonade server \
				--allow=0.0.0.0/0 \
				--host="localhost" \
				--trans-loopback=true \
				--port=$tmpa 1> /dev/null 2>&1 & printf '%d' $! > "$tmpc"
		}
	)
	unset E_NEX_LEMONADE
}

nx_misc_soffice()
{
	h_nx_cmd soffice && (
		tmpc="$(nx_misc_pid "soffice")"
		ps "$(cat "$tmpc")" 2> /dev/null | grep -q 'soffice' || {
			g_nx_misc_port 2002 || return
			nx_io_printf -i "starting the soffice service on port $tmpa"
			nohup setsid soffice --headless --accept="socket,host=localhost,port=$tmpa;urp;" 1> /dev/null 2>&1 & printf '%d' $! > "$tmpc"
		}
	)
	unset E_NEX_SOFFICE
}

export E_NEX_SOFFICE=false
export E_NEX_LEMONADE=true
