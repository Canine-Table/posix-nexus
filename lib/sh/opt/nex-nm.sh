
__h_nx_nm()
{
	h_nx_cmd nmcli || {
		nx_io_printf -W "nmcli not found! NetworkManager stands silent-no path, no voice, no invocation." 1>&2
		return 1
	}
}

g_nx_nm_status()
(
	__h_nx_nm || return
	while test "$#" -gt 0; do
		tmpa=""
		tmpb=""
		case "$1" in
			-d) {
				case "$2" in
					s) tmpb="status";;
					w) tmpb="wifi list";;
				esac
				test -n "$tmpb" && {
					tmpa="device $tmpb"
					shift
				}
			};;
			-c) {
				tmpa="connection show"
				case "$2" in
					a) tmpb="--active";;
				esac
				test -n "$tmpb" && {
					tmpa="$tmpa $tmpb"
					shift
				}
			};;
			-g) {
				case "$2" in
					l) tmpb="logging";;
					s) tmpb="status";;
				esac
				test -n "$tmpb" && {
					tmpa="general $tmpb"
					shift
				}
			};;
		esac
		test -n "$tmpa" && nmcli $tmpa
		shift
	done
)

nx_nm_wifi_pskpass()
(
	__h_nx_nm || exit
	eval "$(nx_str_optarg ':d:p:c:s:C' "$@")"
	nmcli connection add \
		type wifi \
		ifname "$d" \
		con-name "${c:-$s}" \
		ssid "$s" \
		wifi-sec.key-mgmt wpa-psk \
		wifi-sec.psk "$p" \
		connection.autoconnect ${C:-yes}${C:+no} || {
			nx_io_printf -E "Authentication failed! The passphrase was denied—no handshake, no lease, no link." 1>&2
			exit 1
		}
)

nx_nm_wifi_eap()
(
	__h_nx_nm || exit
	eval "$(nx_str_optarg ':d:p:c:s:a:C' "$@")"
	case "$(nx_str_case -l "$a")" in
		tp)
			{
				tmpa="ttls"
				tmpb="pap"
			};;
		tm)
			{
				tmpa="ttls"
				tmpb="mschapv2"
			};;
		pm)
			{
				tmpa="peap"
				tmpb="mschapv2"
			};;
		pp)
			{
				tmpa="peap"
				tmpb="pap"
			};;
		fm)
			{
				tmpa="fast"
				tmpb="mschapv2"
			};;
		*)
			{
				nx_io_printf -E "Authentication failed! The passphrase was denied—no handshake, no lease, no link." 1>&2
				exit 1
			};;
	esac
	nmcli connection add \
		type wifi \
		iface "$d" \
		con-name "${c:-$s}" \
		ssid "$s" \
		wifi-sec.key-mgmt wpa-eap \
		802-1x.eap "$tmpa" \
		802-1x.phase2-auth "$tmpb" \
		802-1x.identity "$i" \
		802-1x.password "$p" \
		connection.autoconnect ${C:-yes}${C:+no} || {
			nx_io_printf -E "Failed to create Wi-Fi connection! The SSID remains untouched—no key, no link, no lease." 1>&2
			exit 2
		}
)

nx_nm_eth()
(
	__h_nx_nm || exit
	eval "$(nx_str_optarg ':d:c:g:G:a:A:n:N:s:S:m:M:C' "$@")"
	nmcli connection add type ethernet \
		con-name "$c" \
		ifname "$d" \
		${g:+ipv4.gateway "$g"} \
		${G:+ipv6.gateway "$G"} \
		${g:+ipv4.address "$a"} \
		${G:+ipv6.address "$A"} \
		${n:+ipv4.dns "$n"} \
		${N:+ipv6.dns "$N"} \
		${n:+ipv4.dns-search "$s"} \
		${N:+ipv6.dns-search "$S"} \
		${n:+ipv4.method "$m"} \
		${N:+ipv6.method "$M"} \
		connection.autoconnect ${C:-yes}${C:+no} || {
			nx_io_printf -E "Failed to create ethernet connection! No link, no lease—our ritual ends at the interface boundary." 
			exit 1
		}
)

