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
		con-name "$c" \
		ssid "$s" \
		wifi-sec.key-mgmt wpa-psk \
		wifi-sec.psk "$p" \
		connection.autoconnect yes
)

nx_nm_terse()
(
	nmcli --terse device
	nmcli general status
	nmcli general logging
	nmcli connection show --active
	nmcli device status

)


