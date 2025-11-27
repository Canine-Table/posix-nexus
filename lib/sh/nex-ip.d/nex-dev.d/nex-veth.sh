#nx_include NEX_S:/nex-ip.sh

nx_ip_n_veth()
(
	__nx_ip_a_netns 'd:D:N:e' "$@"
	tmpa="$(nx_ip_c_name)"
	NEX_k_d="$(nx_ip_c_name -v "${NEX_k_d:-nexus}")"
	tmpb="$NEX_k_d"
	__nx_ip_n_dev -D "$NEX_k_d" -v 'veth' peer name "$tmpa"
	nx_ip_s_group 3
	test -n "$NEX_k_N" && {
		__nx_ip_m_netns -d "$tmpa" -N "$NEX_k_N"
		NEX_k_n="$NEX_k_N"
	}
	NEX_k_D="$(nx_ip_c_name -v "${NEX_k_D:-nexus}")"
	NEX_k_d="$tmpa"
	nx_ip_s_group 3
	nx_ip_s_name -v "$NEX_k_D"
	${AWK:-$(nx_cmd_awk)} \
		-v nm="$tmpb" \
		-v pr="$NEX_k_D" \
		-v ex="$NEX_f_e" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-misc-extras.awk")
	"'
		BEGIN {
			if (ex == "<nx:true/>")
				ex = "export "
			else
				ex = ""
			printf("%s%s; %s%s", ex, __nx_stringify_var("G_NEX_NET_VETH" , nm), ex, __nx_stringify_var("G_NEX_NET_PEER" , pr))
		}
	'
)

