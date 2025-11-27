#nx_include nex-cmd.sh
#nx_include nex-data.sh
#nx_include NEX_S:/nex-ip.sh

nx_ip_c_vid()
{
	nx_int_range -v "${1:-$NEX_k_i}" -l 4095 -g 1 -e -a || {
		nx_tty_print -e "Error: VLAN ID must be between 1 and 4095"
		return 2
	}
	printf '%d' "${1:-$NEX_k_i}"
}


nx_ip_s_vlan()
(
	nx_ip_a_ifname 'i:e' "$@" || exit 2
	nx_ip_c_vid 1>/dev/null || exit 2
	tmpa="$NEX_k_d.$NEX_k_i"
	test -n "$(nx_ip_o_ifname "$tmpa")" || exit 2
	__nx_ip_dev -m 'add link' -p "name $tmpa" -v 'vlan' id $NEX_k_i
	tmpb="$NEX_k_d"
	NEX_k_d="$tmpa"
	nx_ip_s_group 999
	nx_ip_s_alt "vlan${NEX_k_i}n"
	nx_ip_s_master -m "$tmpb"
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
			printf("%s%s;", ex, __nx_stringify_var("G_NEX_NET_VID" , nm))
		}
	'
)

