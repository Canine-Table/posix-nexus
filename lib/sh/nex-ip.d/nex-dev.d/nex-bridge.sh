#nx_include nex-vlan.sh
#nx_include NEX_L:/sh/nex-ip.sh

nx_ip_s_bridge()
(
	nx_ip_a_ifname 'l:e' "$@" || exit 2
	NEX_k_l="$(nx_ip_c_name -v "$NEX_k_l")"
	nx_ip_n_dev -t 'bridge' 2>/dev/null
	${AWK:-$(nx_cmd_awk)} \
		-v nm="$NEX_k_l" \
		-v ex="$NEX_f_e" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-misc-extras.awk")
	"'
		BEGIN {
			if (ex == "<nx:true/>")
				ex = "export "
			else
				ex = ""
			printf("%s%s;", ex, __nx_stringify_var("G_NEX_NET_BRIDGE" , nm))
		}
	'
)

nx_ip_s_vlan_bridge()
(
	nx_ip_a_ifname 'i:I:e' "$@" || exit 2
	#nx_ip_c_vid "$NEX_k_i" 1>/dev/null || exit 2
	#tmpa="$NEX_k_d.$NEX_k_i"
	#test -n "$(nx_ip_o_ifname "$tmpa")" || exit 2
	#NEX_k_I="${NEX_k_I:-999}"
	#nx_ip_c_vid "$NEX_k_I" 1>/dev/null || NEX_k_I=999
	#__nx_ip_dev -m 'add link' -p "name $tmpa" -v 'vlan' id $NEX_k_i
	#tmpb="$NEX_k_d"
	#NEX_k_d="$tmpa"
	#nx_ip_s_master -m "$tmpb"
	$(__nx_ip_x_netns) bridge vlan add dev "$NEX_k_d" vid "$NEX_k_i" "${NEX_k_I:+pvid untagged master}"
	nx_ip_s_group 999
	${AWK:-$(nx_cmd_awk)} \
		-v nm="$NEX_k_d" \
		-v ex="$NEX_f_e" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-misc-extras.awk")
	"'
		BEGIN {
			if (ex == "<nx:true/>")
				ex = "export "
			else
				ex = ""
			printf("%s%s;", ex, __nx_stringify_var("G_NEX_NET_BVID" , nm))
		}
	'
)

