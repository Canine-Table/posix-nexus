#nx_include NEX_L:/sh/nex-ip.sh

###########################################################################################################
nx_ip_o_dev()
(
	nx_data_optargs 'o@' "$@"
	NEX_S="$(
		nx_data_match -o ipip -o sit -o vti -o xfrm -o ip6tnl -o gre -o gretap -o ip6gre -o ip6gretap \
			-o erspan -o ip6erspan -o geneve -o vxlan -o vxcan -o nlmon -o veth -o vcan -o dummy \
			-o ifb -o nlmon -o vlan -o vrf -o ipvlan -o ipvtap -o macvlan -o macvtap -o macsec \
			-o netdevsim -o netkit -o virt_wifi -o gtp -o pfcp -o rmnet -o wwan -o ipoib \
			-o bridge -o bridge_slave -o bond -o bond_slave -o team -o team_slave -o hsr $NEX_S
	)"
	test -n "$NEX_S" && printf '%s' "$NEX_S"
)

nx_ip_o_lld_gen()
(
	nx_data_optargs 'o@' "$@"
	NEX_S="$(
		nx_data_match -o eui64 -o none -o stable-privacy -o random $NEX_S
	)"
	test -n "$NEX_S" && printf '%s' "$NEX_S"
)

nx_ip_o_state()
(
	nx_data_optargs 'o@' "$@"
	NEX_S="$(
		nx_data_match -o up -o down "$(nx_str_case -l "$NEX_S")"
	)"
	test -n "$NEX_S" && printf '%s' "$NEX_S"
)

nx_ip_o_active()
(
	nx_data_optargs 'o@' "$@"
	NEX_S="$(
		nx_data_match -o on -o off "$(nx_str_case -l "$NEX_S")"
	)"
	test -n "$NEX_S" && printf '%s' "$NEX_S"
)

