#nx_include NEX_L:/sh/nex-ip.sh

###########################################################################################################
nx_ip_g_names()
(
	__nx_ip_a_netns 's:d:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip -json link show $NEX_k_d)" | ${AWK:-$(nx_cmd_awk)} \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
		'/^\.nx\[[1-9][0-9]*\]\.(ifname|altnames\[[1-9][0-9]*\]) = /{
			if (b++)
				printf("%s", sep)
			printf("%s", $NF)
		} END {
			exit b < 2
		}
	'
)

nx_ip_o_names()
(
	__nx_ip_a_netns 'o@' "$@"
	nx_data_match -o $(nx_ip_g_names -s " -o ") $NEX_S
)

###########################################################################################################
nx_ip_g_alt()
(
	__nx_ip_a_netns 's:d:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip -json link show $NEX_k_d)" | ${AWK:-$(nx_cmd_awk)} \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
		'/^\.nx\[[1-9][0-9]*\]\.altnames\[[1-9][0-9]*\] = /{
			if (b++)
				printf("%s", sep)
			printf("%s", $NF)
		} END {
			exit b < 2
		}
	'
)


__nx_ip_alt()
(
	nx_ip_a_ifname 'v:m:' "$@" || exit 2
	$(__nx_ip_x_netns) ip link property $NEX_k_m dev "$NEX_k_d" altname "${NEX_k_v:-$NEX_S}"
)

nx_ip_r_alt()
{
	__nx_ip_alt "$@" -m 'delete'
}

nx_ip_s_alt()
{
	__nx_ip_alt "$@" -m 'add'
}

nx_ip_o_alt()
(
	__nx_ip_a_netns 'o@' "$@"
	nx_data_match -o $(nx_ip_g_alt -s " -o ") $NEX_S
)

###########################################################################################################
nx_ip_g_name()
(
	__nx_ip_a_netns 's:d:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip -json link show $NEX_k_d)" | ${AWK:-$(nx_cmd_awk)}  \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
		'/^\.nx\[[1-9][0-9]*\]\.ifname = /{
			if (b++)
				printf("%s", sep)
			printf("%s", $NF)
		} END {
			exit b < 2
		}
	'
)

nx_ip_o_name()
(
	__nx_ip_a_netns 'o@' "$@"
	NEX_S="$(nx_data_match -o $(nx_ip_g_name -s " -o ") $NEX_S)"
	test -n "$NEX_S" || exit
	printf '%s' "$NEX_S"
)

nx_ip_s_name()
(
	nx_ip_a_ifname 'v:' "$@" || exit 2
	$(__nx_ip_x_netns) ip link set "$NEX_k_d" name "${NEX_k_v:-$NEX_S}"
	#__nx_ip_a_netns 'd:v:' "$@"
	#$(__nx_ip_x_netns) ip link set $(nx_ip_g_ifname -d "$NEX_k_d") name "$(nx_ip_c_name "${NEX_k_v:-$NEX_S}")"
)

###########################################################################################################
nx_ip_g_ifname()
(
	__nx_ip_a_netns 's:d:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip -json link show ${NEX_k_d:+$(nx_ip_o_names "$NEX_k_d")})" | ${AWK:-$(nx_cmd_awk)}  \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
		'/^\.nx\[[1-9][0-9]*\]\.ifname = /{
			if (b++)
				printf("%s", sep)
			printf("%s", $NF)
		} {
		} END {
			exit b < 2
		}
	'
)

nx_ip_o_ifname()
(
	__nx_ip_a_netns 'o@' "$@"
	NEX_S="$(nx_data_match -o $(nx_ip_g_ifname -s " -o ") $NEX_S)"
	test -n "$NEX_S" || exit
	printf '%s' "$NEX_S"
)

nx_ip_a_ifname()
{
	test "$1" = '--' && {
		NEX_R='<nx:true/>'
		shift
	} || NEX_R='<nx:false/>'
	test -n "$(nx_ip_o_ifname "$NEX_k_d")" && NEX_S="$1" || NEX_S="d:$1"
	test -z "$(nx_ip_o_ifname "$NEX_k_D")" && NEX_S="D:$NEX_S" || NEX_k_D=""
	shift
	if test "$NEX_R" = '<nx:false/>'; then
		__nx_ip_a_netns "$NEX_S" "$@"
	else
		nx_data_optargs "$NEX_S" "$@"
	fi
	NEX_k_d="$(nx_ip_o_ifname "$NEX_k_d")"
	test -n "$NEX_k_d" -o -n "$NEX_k_D"
}

###########################################################################################################
nx_ip_g_alias()
(
	nx_ip_a_ifname -- 's:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip -json link show $NEX_k_d)" | ${AWK:-$(nx_cmd_awk)}  \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
		'/\.nx\[[0-9]+\]\.ifalias = /{
			if (b++)
				printf("%s", sep)
			printf("%s", substr($0, index($0, "=") + 1))
		} END {
			exit b < 2
		}
	'
)

nx_ip_s_alias()
(
	nx_ip_a_ifname 'v:' "$@" || exit 2
	nx_ip_g_alias | grep -q '^'"$NEX_S"'$' && return 1
	$(__nx_ip_x_netns) ip link set "$NEX_k_d" alias "${NEX_k_v:-$NEX_S}"
)

###########################################################################################################
nx_ip_c_name()
(
	__nx_ip_a_netns 'v:' "$@"
	${AWK:-$(nx_cmd_awk)}  \
		-v nm="${NEX_k_v:-$NEX_S}" \
		-v nms="$(nx_ip_g_names -s '<nx/>')" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-data.awk")
	"'
		BEGIN {
			ln = 15
			if ((t = split(nm, links, ".")) == 2) {
				if (links[2] > 0 && links[2] < 4095) {
					suf = "." links[2]
					ln = 15 - length(suf)
				}
			}
			delete links
			if (nm !~ /^[a-zA-Z_][a-zA-Z0-9-_]{0,14}$/)
				nm = nx_to_environ(nm)
			if (nm == "") {
				lnk = "_" nx_random_str(ln - 1, "alnum")
				t = ""
			} else {
				lnk = nm
				gsub(/[0-9]+$/, "", lnk)
				t = 0
				ln--
			}
			lnk = substr(lnk, 1, ln)
			nx_arr_split(nms, links, "<nx/>")
			while (lnk "" t "" suf in links) {
				if (t == "")
					lnk = "_" nx_random_str(ln - 1, "alnum")
				else
					t++
				if (length(lnk "" t) > ln) {
					if (! sub(/.$/, "", lnk))
						t = ""
					else
						--t
				}
			}
			delete links
			printf("%s%s%s", lnk, t, suf)
		}
	'
)

