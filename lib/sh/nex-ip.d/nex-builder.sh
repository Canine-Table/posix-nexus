#nx_include nex-dev.d/nex-bond.sh
#nx_include nex-dev.d/nex-veth.sh
#nx_include nex-dev.d/nex-bridge.sh
#nx_include nex-dev.d/nex-vlan.sh
#nx_include nex-dev.d/nex-tuntap.sh
#nx_include nex-wpa.sh
#nx_include NEX_L:/sh/nex-ip.sh

__nx_ip_n_builder()
(
	nx_base="${NEXUS_CNF}/json/network/"
	${AWK:-$(nx_cmd_awk)} \
		-v sep="$(test "$1" = '<nx:blank/>' && printf '%s' '' || printf '%s' "${1:-\n}")" \
		-v lnk="$NEX_k_l" \
		-v typ="$NEX_k_t" \
		-v json="${nx_base}${NEX_k_t}.json" \
		-v base="${nx_base}base.json" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		BEGIN {
			if (err = nx_json(base, cfg, 2))
				exit err
			if (err = nx_json(json, cfg, 2))
				exit err
			if (tolower(cfg[".nx.l2.address"]) == "random")
				printf("nx_ip_s_l2 %s%s", cfg[".nx.l2.prefix"], sep)
			nx_json_delete(".l2", cfg)
			if (".nx.name.alias" in cfg) {
				gsub("<nx:placeholder/>", lnk, cfg[".nx.name.alias"])
				printf("nx_ip_s_alias %s%s", cfg[".nx.name.alias"], sep)
			}
			if (nx_json_type(".attributes", cfg) == 1) { # an object??
				nx_json_split(".attributes", cfg, arr)
				for (i = 1; i <= arr[0]; ++i)
					printf("nx_ip_s_%s %s%s", arr[i], cfg[".nx.attributes." arr[i]], sep)
			}
			nx_json_delete(".attributes", cfg)
			if (nx_json_type(".values", cfg) == 1) { # an object??
				nx_json_split(".values", cfg, arr)
				for (i = 1; i <= arr[0]; ++i)
					printf("nx_ip_s_dev -v %s %s %s%s", typ, arr[i], cfg[".nx.values." arr[i]], sep)
			}
			nx_json_delete(".values", cfg)
			printf("nx_ip_s_state %s", cfg[".nx.state"])
			delete cfg
			delete arr
		}
	'
)

