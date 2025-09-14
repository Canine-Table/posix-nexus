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
		tmpb="$(nx_ip_name 'wireless' "$tmpa")"
		test -n "$tmpb" && {
			ip link set "$tmpa" name "$tmpb"
			ip link set "$tmpb" group "11"
			ip link set "$tmpb" alias "Physical wireless pci device refered by $tmpb"
		}
	else
		tmpb="$(nx_ip_name 'ethernet' "$tmpa")"
		test -n "$tmpb" && {
			ip link set "$tmpa" name "$tmpb"
			ip link set "$tmpb" group "3"
			ip link set "$tmpb" alias "Physical ethernet pci device refered by $tmpb"
		}
	fi
	ip link set up "${tmpb:-$tmpa}"
done

for tmpa in $G_NEX_NET_VIRT; do

	case "$(cat "/sys/class/net/$tmpa/type")" in
		772)
			{
				tmpb="$(nx_ip_name 'loopback' "$tmpa")"
				test -n "$tmpb" && {
					ip link set "$tmpa" name "$tmpb"
					ip link set dev "$tmpb" altname "$tmpa"
					ip link set "$tmpb" group "772"
					ip link set "$tmpb" alias "The $tmpb does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
				}
			};;
		*);;
	esac
done

unset tmpa tmpb

