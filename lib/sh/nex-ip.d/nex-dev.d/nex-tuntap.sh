
nx_ip_s_tap()
(
	nx_ip_a_ifname 'v:u:e' "$@" || exit 2
	NEX_k_v="$(nx_ip_c_name -v "${NEX_k_v:-tap}")"
	$(__nx_ip_x_netns) ip tuntap add dev "$NEX_k_v" mode tap ${NEX_k_u:+user "$NEX_k_u"}
	nx_ip_s_group 32
	${AWK:-$(nx_cmd_awk)} \
		-v nm="$NEX_k_v" \
		-v ex="$NEX_f_e" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-misc-extras.awk")
	"'
		BEGIN {
			if (ex == "<nx:true/>")
				ex = "export "
			else
				ex = ""
			printf("%s%s;", ex, __nx_stringify_var("G_NEX_NET_TAP" , nm))
		}
	'
)


