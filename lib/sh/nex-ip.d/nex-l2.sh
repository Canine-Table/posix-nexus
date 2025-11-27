#nx_include NEX_L:/sh/nex-ip.sh

###########################################################################################################
nx_ip_j_arp()
(
	__nx_ip_a_netns 'p:' "$@"
	$(__nx_ip_x_netns) ${AWK:-$(nx_cmd_awk)} '
		{
			if (! header) {
				header = 1
				next
			}
			iface[$NF] = iface[$NF] "{\x22ip\x22:\x22" $1 "\x22,\x22type\x22:\x22" $2 "\x22,\x22flags\x22:\x22" $3 "\x22,\x22hw\x22:\x22" $4 "\x22,\x22mask\x22:\x22" $5 "\x22},"
		} END {
			for (face in iface) {
				sub(/,$/,"]},", iface[face])
				s = s "{\x22" face "\x22:[" iface[face]
			}
			delete iface
			sub(/,$/, "]", s)
			if (s)
				printf("[%s", s)
			else
				exit 1
		}
	' "$(test -n "$NEX_k_p" -a -f "/proc/$NEX_k_p/net/arp" && printf '%s' "/proc/$NEX_k_p/net/arp" || printf '%s' '/proc/self/net/arp')"
)

nx_ip_g_arp_l2()
(
	nx_data_optargs 's:d:' "$@"
	NEX_k_d="${NEX_k_d:+$(nx_ip_o_names "$NEX_k_d")}"
	NEX_S="$(nx_ip_j_arp "$@")"
	test -n "$NEX_S" || exit 69
	nx_data_jdump "$NEX_S" | ${AWK:-$(nx_cmd_awk)}  \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
	'
		/^\.nx\[[1-9][0-9]*\]\.'"${NEX_k_d:-.+}"'\[[1-9][0-9]*\]\.hw = /{
			if (b++)
				printf("%s", sep)
			printf("%s", $NF)
		} END {
			exit b < 2
		}
	'
)

###########################################################################################################
nx_ip_g_l2()
(
	__nx_ip_a_netns 's:d:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip -json link show ${NEX_k_d:+$(nx_ip_o_names "$NEX_k_d")})" | ${AWK:-$(nx_cmd_awk)}  \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
	'
		/^\.nx\[[1-9][0-9]*\]\.address = /{
			if (b == 1)
				printf("%s", sep)
			else
				b = 1
			printf("%s", $NF)
		}
	'
)

nx_ip_g_n()
(
	__nx_ip_a_netns 's:d:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip -json neighbor show ${NEX_k_d:+$(nx_ip_o_names "$NEX_k_d")})" | ${AWK:-$(nx_cmd_awk)}  \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
	'
		/^\.nx\[[1-9][0-9]*\]\.lladdr = /{
			if (b == 1)
				printf("%s", sep)
			else
				b = 1
			printf("%s", $NF)
		}
	'
)

nx_ip_l_l2()
{
	nx_str_join "$({
		nx_ip_g_l2
		printf '\n'
		nx_ip_g_n
		printf '\n'
		nx_ip_g_arp_l2
	} | sort | uniq -iu)" "${1:-\n}"
}

nx_ip_n_l2()
{
	${AWK:-$(nx_cmd_awk)} \
			-v l2="${NEX_k_v:-${NEX_S:-$1}}" \
			-v addr="$(nx_ip_l_l2 "<nx/>")" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-data.awk")
	"'
		BEGIN {
			gsub(/:|-/, "", addr)
			addr = tolower(addr)
			nx_arr_split(addr, hexes, "<nx/>")
			l2 = substr(tolower(l2), 1, 12)
			gsub(/[^a-f0-9]*/, "", l2)
			if ((ln = 12 - length(l2)) == 0) {
				if (l2 in hexes) {
					ln = 8
					l2 = substr(l2, 1, 8)
				} else {
					ln = "<nx:true/>"
				}
			}
			if (ln != "<nx:true/>") {
				do {
					hex = l2 tolower(nx_random_str(ln, "xdigit"))
				} while (hex in hexes)
			}
			ln = split(hex, hexes, "")
			hex = hexes[1] hexes[2]
			for (ln = 3; ln <= 12; ln += 2)
				hex = hex ":" hexes[ln] hexes[ln + 1]
			delete hexes
			print hex
		}
	'
}

###########################################################################################################

nx_ip_s_l2()
(
	nx_ip_a_ifname 'v:' "$@" || exit
	$(__nx_ip_x_netns) ip link set dev "$NEX_k_d" address "$(nx_ip_n_l2 "${NEX_k_v:-$NEX_S}")"
)

