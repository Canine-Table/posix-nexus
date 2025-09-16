nx_nm_wifi_ls()
{
	h_nx_cmd nmcli && nmcli dev wifi list
}

nx_nm_wifi_pskpass()
(

	eval "$(nx_str_optarg ':d:p:c:s:' "$@")"
	h_nx_cmd nmcli && nmcli connection add \
		type wifi \
		ifname "$d" \
		con-name "${c:-$s}" \
		ssid "$s" \
		wifi-sec.key-mgmt wpa-psk \
		wifi-sec.psk "$p" \
		connection.autoconnect yes
)

nx_nm_wifi_eap()
{
	eval "$(nx_str_optarg ':d:p:c:s:a:' "$@")"
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
				nx_io_printf -E "auth??"
				return 1
			};;
	esac
	h_nx_cmd nmcli && nmcli connection add \
		type wifi \
		iface "$d" \
		con-name "${c:-$s}" \
		ssid "$s" \
		wifi-sec.key-mgmt wpa-eap \
		802-1x.eap "$tmpa" \
		802-1x.phase2-auth "$tmpb" \
		802-1x.identity "$i" \
		802-1x.password "$p" \
		connection.autoconnect yes
}

nx_nm_terse()
(
	nmcli --terse device
	nmcli general status
	nmcli general logging
	nmcli connection show --active
	nmcli device status

)


