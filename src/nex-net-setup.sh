. "$(cat "$HOME/.nx-root" 2> /dev/null)"

test -n "$NEXUS_CNF" || {
	printf 'nex-init needs to loaded before using these tools.\n'
	return 1
}

test "$(id -u)" -eq 0 || {
	nx_io_printf -E "elevated privileges required!"
	return 2
}

eval "$(nx_ip_net -e)"

for tmpa in $G_NEX_NET_PHY; do
	ip link set down "$tmpa"
	if test -d "/sys/class/net/$tmpa/wireless"; then
		tmpb="$(nx_ip_name -v -b "$tmpa" 'wireless')"
		test -n "$tmpb" && {
			s_nx_ip_name "$tmpa" "$tmpb"
			s_nx_ip_group "$tmpb" "11"
			s_nx_ip_alt "$tmpb" "$tmpa"
			s_nx_ip_alias "$tmpb" "Physical wireless pci device refered by $tmpb"
		}
	else
		tmpb="$(nx_ip_name -v -b "$tmpa" 'ethernet')"
		test -n "$tmpb" && {
			s_nx_ip_name "$tmpa" "$tmpb"
			s_nx_ip_group "$tmpb" "3"
			s_nx_ip_alias "$tmpb" "Physical ethernet pci device refered by $tmpb"
		}
	fi
	s_nx_ip_alt "$tmpb" "$tmpa"
	s_nx_ip_l2 "${tmpb:-$tmpa}" "$(nx_ip_l2)"
	ip link set up "${tmpb:-$tmpa}"
done

for tmpa in $G_NEX_NET_VIRT; do
	ip link set down "$tmpa"
	case "$(cat "/sys/class/net/$tmpa/type")" in
		772)
			{
				tmpb="$(nx_ip_name -v -b "$tmpa" 'loopback')"
				test -n "$tmpb" && {
					s_nx_ip_name "$tmpa" "$tmpb"
					s_nx_ip_alt "$tmpb" "$tmpa"
					s_nx_ip_group "$tmpb" "772"
					s_nx_ip_alias "$tmpb" "The $tmpb does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
				}
			};;
		*);;
	esac
	ip link set up "$tmpa"
done

unset tmpa tmpb

