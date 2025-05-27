
nx_ip_factory()
{
	(
		eval "$(nx_str_optarg ':d:f:o:t:j' "$@")"
		${AWK:-$(get_cmd_awk)} \
			-v json="{
				'objects': [
					'address', 'addrlabel', 'fou', 'ila', 'ioam', 'l2tp', 'link',
					'macsec', 'maddress', 'monitor', 'mptcp', 'mroute', 'mrule',
					'neighbor', 'neighbour', 'netconf', 'netns', 'nexthop',
					'ntable', 'ntbl', 'route', 'rule', 'sr', 'tap', 'tcpmetrics',
					'token', 'tunnel', 'tuntap', 'vrf', 'xfrm'
				],
				'types': [
					'amt', 'bareudp', 'bond', 'bond_slave', 'bridge', 'bridge_slave',
					'dummy', 'erspan', 'geneve', 'gre', 'gretap', 'gtp', 'ifb',
					'ip6erspan', 'ip6gre', 'ip6gretap', 'ip6tnl', 'ipip',
					'ipoib', 'ipvlan', 'ipvtap', 'macsec', 'macvlan', 'macvtap',
					'netdevsim', 'netkit', 'nlmon', 'rmnet', 'sit', 'team',
					'team_slave', 'vcan', 'veth', 'vlan', 'vrf', 'vti', 'vxcan',
					'vxlan', 'wwan', 'xfrm', 'virt_wifi', 'dsa'
				],
				'families': [
					'inet6', 'inet', 'link', 'mpls', 'bridge'
				],
				'display': [
					'oneline', 'detail', 'brief'
				],
				'input': {
					'display': '$d',
					'family': '$f',
					'type': '$t',
					'object': '$o',
					'json': '$j'
				}
			}
		" "
			$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-tui.awk")
		"'
			BEGIN {
				if (err = nx_json(json, arr, 2))
					exit err
				if (nx_json_type(".input.json", arr) > 4 && arr[".nx.input.json"] == "<nx:true/>")
					s = s " -json"
				if (nx_json_type(".input.display", arr) > 4 && (arr[".nx.input.display"] = nx_json_match(".display", arr[".nx.input.display"], arr)))
					s = s " -" arr[".nx.input.display"]
				nx_json_delete(".display", arr)
				if (nx_json_type(".input.family", arr) > 4 && (arr[".nx.input.family"] = nx_json_match(".families", arr[".nx.input.family"], arr)))
					s = s " -family " arr[".nx.input.family"]
				nx_json_delete(".families", arr)
				if (nx_json_type(".input.object", arr) > 4 && (arr[".nx.input.object"] = nx_json_match(".objects", arr[".nx.input.object"], arr)))
					s = s " " arr[".nx.input.object"] " show"
				nx_json_delete(".objects", arr)
				if (nx_json_type(".input.object", arr) > 4 && (arr[".nx.input.type"] = nx_json_match(".types", arr[".nx.input.type"], arr)))
					s = s " type " arr[".nx.input.type"]
				delete arr
				if (err)
					exit err
				else
					print s
			}
		'
	)
}


