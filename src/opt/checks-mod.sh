
nx_check_count()
{
	${AWK:-$(nx_cmd_awk)} \
		-v mch="$1" '
		BEGIN {
			counter = 0
		} {
			counter = counter + gsub(mch, "", $0)
		} END {
			print counter
		}
	' < "${2:-$TMPDIR/count.txt}"
}

nx_check_network()
{
	h_nx_cmd curl && (
		eval "$(nx_str_optarg ':u:l:p:a:c:C:s:r:ko' "$@")"
		l="${l:-example.com}"
		u="${u:-https}"
		ul="$u://$l"
		
		[ -n "$o" ] && curl -o /dev/null -s -w  "Redirection: %{url_effective}\n
			MIME Type:\t%{content_type}\n
			Size: %{size_download}\n
			Speed:%{speed_download}\n
			Lookup: %{time_namelookup}\n
			Connect: %{time_connect}\n
			Start:  %{time_starttransfer}\n
			Redirects: %{num_redirects}\n" "$ul" | while read -r i; do
				echo -n "$(nx_io_printf -a "$i")"
		done
		echo -e '\r\n'
		a="$(nx_algor_opt -i "$a" -l 'mozilla,googlebot')" 
		[ -n "$a" ] && {
			case "$a" in
				'mozila')
					{
						a='Mozilla/5.0 (Windows NT 10.0; Win64; x64)'
					};;
				'googlebot')
					{
						a='Googlebot/2.1 (+http://www.google.com/bot.html)' 
					};;
			esac
			nx_io_printf -f '_b>l<b%' "$(curl -A "$a" "$ul")"
		}
		[ -n "$c" ] && curl --cookie "$c" "$ul"
		[ -n "$r" ] && curl --C - -o "$r" "$ul"
		[ -n "$C" ] && curl --cookie-jar "$C" "$ul"
		[ -n "$s" ] && for ((i = 1; i <= $s; i++)); do nx_io_printf -i "$(curl -o /dev/null  -w "%{time_total}" "$ul" &)"; done
		[ -n "$k" ] && nx_io_printf -f '_b>l<b%' "$(curl -k "$ul")"
		[ -n "$p" ] && nx_io_printf -l "Port $p: $(curl -v telnet://$l:$p)"
		
	)
}
