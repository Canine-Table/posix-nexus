
nx_ip_factory()
{
	(
		eval "$(nx_str_optarg ':s:d:f:o:t:j' "$@")"
		${AWK:-$(get_cmd_awk)} \
			-v json="{
				'devices': $(nx_io_list /sys/class/net/),
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
				'show': [
					'oneline', 'detail', 'brief'
				],
				'input': {
					'device': '$d',
					'show': '$s',
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
				if (nx_json_type(".input.show", arr) > 4 && (arr[".nx.input.show"] = nx_json_match(".show", arr[".nx.input.show"], arr)))
					s = s " -" arr[".nx.input.show"]
				nx_json_delete(".show", arr)
				if (nx_json_type(".input.family", arr) > 4 && (arr[".nx.input.family"] = nx_json_match(".families", arr[".nx.input.family"], arr)))
					s = s " -family " arr[".nx.input.family"]
				nx_json_delete(".families", arr)
				if (nx_json_type(".input.object", arr) > 4 && (arr[".nx.input.object"] = nx_json_match(".objects", arr[".nx.input.object"], arr)))
					s = s " " arr[".nx.input.object"] " show"
				nx_json_delete(".objects", arr)
				if (nx_json_type(".input.type", arr) > 4 && (arr[".nx.input.type"] = nx_json_match(".types", arr[".nx.input.type"], arr)))
					s = s " type " arr[".nx.input.type"]
				nx_json_delete(".type", arr)
				if (nx_json_type(".input.device", arr) > 4 && (arr[".nx.input.device"] = nx_json_match(".devices", arr[".nx.input.device"], arr)))
					s = s " " arr[".nx.input.device"]
				delete arr
				if (err)
					exit err
				else
					print s
			}
		'
	)
}

nx_ip_show()
{
	(
		eval "$(nx_str_optarg ':n:' "$@")"
		json="$(eval "ip $(nx_ip_factory "$@" -j)")" && ${AWK:-$(get_cmd_awk)} \
			-v json="$json" \
			-v num="$n" \
		"
			$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-tui.awk")
		"'
			BEGIN {
				nx_json(json, js, 2)
				print nx_json_flatten("", js, num)
				delete js
			}
		'
	)
}

