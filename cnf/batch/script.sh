#######( cleanup )#################################

test -d "$NEXUS_CNF" || exit 1

cat > "$NEXUS_CNF/batch/clean.batch" <<- 'EOF'
	link delete nexus0 type veth
	netns delete nex-posix-128
	netns delete nex-qemu-176
	netns delete nex-pod-208
	netns delete nex-pod-208-phpmyadmin
	netns delete nex-pod-208-pgadmin

	netns delete nex-vpn-192
	netns delete nex-iscsi-224
	netns delete nex-srv-240
EOF

cat > "$NEXUS_CNF/batch/nex-dnsmasq.conf" <<- 'EOF'

	cache-size=10000
	port=0

	############################################
	# VLAN 176 — DHCP = upper /21
	############################################
	interface=bridge0.176
	dhcp-range=bridge0.176,172.16.184.1,172.16.191.254,12h
	dhcp-option=bridge0.176,3,172.16.176.1
	dhcp-option=bridge0.176,6,172.16.128.1,172.31.0.120,172.31.0.1
	dhcp-option=bridge0.176,42,172.16.128.1
	dhcp-option=bridge0.176,66,172.16.128.1
	dhcp-option=bridge0.176,15,tufa16.home.lab
	dhcp-option=bridge0.176,119,tufa16.home.lab,nex-qemu-176.tufa16.home.lab


	############################################
	# VLAN 192 — DHCP = upper /21
	############################################
	interface=bridge0.192
	dhcp-range=bridge0.192,172.16.200.1,172.16.207.254,12h
	dhcp-option=bridge0.192,3,172.16.192.1
	dhcp-option=bridge0.192,6,172.16.128.1,172.31.0.120,172.31.0.1
	dhcp-option=bridge0.192,42,172.16.128.1
	dhcp-option=bridge0.192,66,172.16.128.1
	dhcp-option=bridge0.192,15,tufa16.home.lab
	dhcp-option=bridge0.192,119,tufa16.home.lab,nex-vpn-192.tufa16.home.lab


	############################################
	# VLAN 208 — DHCP = upper /21
	############################################
	interface=bridge0.208
	dhcp-range=bridge0.208,172.16.216.1,172.16.223.254,12h
	dhcp-option=bridge0.208,3,172.16.208.1
	dhcp-option=bridge0.208,6,172.16.128.1,172.31.0.120,172.31.0.1
	dhcp-option=bridge0.208,42,172.16.128.1
	dhcp-option=bridge0.208,66,172.16.128.1
	dhcp-option=bridge0.208,15,tufa16.home.lab
	dhcp-option=bridge0.208,119,tufa16.home.lab,nex-pod-208.tufa16.home.lab
	
	############################################
	# VLAN 224 — DHCP = upper /21
	############################################
	interface=bridge0.224
	dhcp-range=bridge0.224,172.16.232.1,172.16.239.254,12h
	dhcp-option=bridge0.224,3,172.16.224.1
	dhcp-option=bridge0.224,6,172.16.128.1,172.31.0.120,172.31.0.1
	dhcp-option=bridge0.224,42,172.16.128.1
	dhcp-option=bridge0.224,66,172.16.128.1
	dhcp-option=bridge0.224,15,tufa16.home.lab
	dhcp-option=bridge0.224,119,tufa16.home.lab,nex-iscsi-224.tufa16.home.lab

	############################################
	# VLAN 240 — DHCP = upper /21
	############################################
	interface=bridge0.240
	dhcp-range=bridge0.240,172.16.248.1,172.16.255.254,12h
	dhcp-option=bridge0.240,3,172.16.240.1
	dhcp-option=bridge0.240,6,172.16.128.1,172.31.0.120,172.31.0.1
	dhcp-option=bridge0.240,42,172.16.128.1
	dhcp-option=bridge0.240,66,172.16.128.1
	dhcp-option=bridge0.240,15,tufa16.home.lab
	dhcp-option=bridge0.240,119,tufa16.home.lab,nex-srv-240.tufa16.home.lab

	dhcp-sequential-ip
	log-dhcp
	dhcp-authoritative
	bind-dynamic
EOF


#######( main )#################################
cat > "$NEXUS_CNF/batch/nex-ns.sh" <<- 'EOF'
	ip -batch "$NEXUS_CNF/batch/clean.batch"
	ip -batch "$NEXUS_CNF/batch/nex-default.batch"
	nsenter --net=/var/run/netns/nex-posix-128 -- ip -batch "$NEXUS_CNF/batch/nex-posix-128.batch"
	nsenter --net=/var/run/netns/nex-posix-128 -- bridge -batch "$NEXUS_CNF/batch/nex-br-posix-128.batch"
	nsenter --net=/var/run/netns/nex-posix-128 -- nft -f "$NEXUS_CNF/nft/nat.nft"

	nsenter --net=/var/run/netns/nex-qemu-176 -- ip -batch "$NEXUS_CNF/batch/nex-qemu-176.batch"
	nsenter --net=/var/run/netns/nex-qemu-176 -- bridge -batch "$NEXUS_CNF/batch/nex-br-qemu-176.batch"

	nsenter --net=/var/run/netns/nex-pod-208 -- ip -batch "$NEXUS_CNF/batch/nex-pod-208.batch"
	nsenter --net=/var/run/netns/nex-pod-208 -- bridge -batch "$NEXUS_CNF/batch/nex-br-pod-208.batch"

	nsenter --net=/var/run/netns/nex-pod-208-phpmyadmin -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-phpmyadmin.batch"
	nsenter --net=/var/run/netns/nex-pod-208-pgadmin -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-pgadmin.batch"

EOF

: <<- 'EOF'
	h_nx_cmd dnsmasq && (
		h_nx_cmd pidof && for i in $(ip netns exec nex-posix-128 ps -fp $(pidof dnsmasq) 2>/dev/null | sed -n '2,$p' | awk '{print $2}'); do
			kill -9 $i
		done
		ip netns exec nex-posix-128 sh -c '
			while $(ip -4 address show dev bridge0.176 | grep -q "inet " && exit 1 || exit 0); do
				sleep 0.1 || sleep 1
			done
			while $(ip -4 address show dev bridge0.192 | grep -q "inet " && exit 1 || exit 0); do
				sleep 0.1 || sleep 1
			done
			while $(ip -4 address show dev bridge0.224 | grep -q "inet " && exit 1 || exit 0); do
				sleep 0.1 || sleep 1
			done
			while $(ip -4 address show dev bridge0.240 | grep -q "inet " && exit 1 || exit 0); do
				sleep 0.1 || sleep 1
			done
		'
		ip netns exec nex-posix-128 dnsmasq \
				--conf-file="$NEXUS_CNF/batch/nex-dnsmasq.conf" \
				--user=dnsmasq \
				--log-facility="$NEXUS_ENV/log/nex-dnsmasq.log"
	)

EOF



#######( default )#################################
cat > "$NEXUS_CNF/batch/nex-default.batch" <<- 'EOF'
	netns add nex-posix-128
	link add name nexus1 type veth peer name nexus0
	link property add dev nexus0 altname nex_gateway
	link set nexus0 alias "Virtual wired ethernet device within the nex-posix-128 namespace refered to by nexus0."
	link set nexus0 netns nex-posix-128

	link set nexus1 name nexus0
	link property add dev nexus0 altname nex_lab
	link set nexus0 alias "Virtual wired ethernet device refered to by nexus0."
	address add 172.16.128.1/17 label "nexus0:lab" dev nexus0
	link set nexus0 up
	route replace 172.16.128.0/17 via 172.16.128.2 dev nexus0

	netns add nex-qemu-176
	netns add nex-pod-208
	netns add nex-pod-208-phpmyadmin
	netns add nex-pod-208-pgadmin

	netns add nex-vpn-192
	netns add  nex-iscsi-224
	netns add nex-srv-240
EOF


#######( posix-128 )#################################
cat > "$NEXUS_CNF/batch/nex-posix-128.batch" <<- 'EOF'
	link set nexus0 name nexus


	link set lo name loopback0
	link property add dev loopback0 altname lo
	link set loopback0 alias "The loopback0 does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
	link set loopback0 group 772
	link set loopback0 up


	link add bridge0 type bridge \
		vlan_default_pvid 999 \
		vlan_filtering 1 \
		vlan_protocol "802.1Q" \
		mdb_offload_fail_notification 1 \
		vlan_stats_per_port 1 \
		mcast_stats_enabled 1 \
		mcast_igmp_version 3 \
		mcast_mld_version 1 \
		mcast_mld_version 2 \
		vlan_stats_enabled 1
	link property add dev bridge0 altname backbone128
	link set bridge0 alias "Logical software bridge device aggregating multiple interfaces refered to as bridge0."
	link set bridge0 group 1
	link set bridge0 up


	# qemu ###############################################################
	link add vlan176 type veth peer name nexus0
	link property add dev vlan176 altname qemu_net
	link set vlan176 alias "Virtual wired ethernet device connecting the qemu network on vlan 176 to the backbone switch."
	link set vlan176 group 3
	link set vlan176 up
	link set vlan176 master bridge0
	link property add dev nexus0 altname qemu_gw
	link set nexus0 alias "Virtual wired ethernet device refered to by nexus0 for the qemu virtual machines."
	link set nexus0 group 3
	link set nexus0 up
	link set nexus0 netns nex-qemu-176
	link add link bridge0 name bridge0.176 type vlan id 176
	address add 172.16.176.1/20 label "vlan176:qemu" dev bridge0.176
	link set bridge0.176 group 3
	link set bridge0.176 up


	# vpn ###############################################################
	link add vlan192 type veth peer name nexus0
	link property add dev vlan192 altname vpn_net
	link set vlan192 alias "Virtual wired ethernet device connecting the vpn network on vlan 192 to the backbone switch."
	link set vlan192 group 3
	link set vlan192 up
	link set vlan192 master bridge0
	link property add dev nexus0 altname vpn_gw
	link set nexus0 alias "Virtual wired ethernet device refered to by nexus0 for the wiregard and openvpn."
	link set nexus0 group 3
	link set nexus0 netns nex-vpn-192
	link add link bridge0 name bridge0.192 type vlan id 192
	address add 172.16.192.1/20 label "vlan192:vpn" dev bridge0.192
	link set bridge0.192 group 3
	link set bridge0.192 up


	# pods ###############################################################
	link add vlan208 type veth peer name nexus0
	link property add dev vlan208 altname pod_net
	link set vlan208 alias "Virtual wired ethernet device connecting the podman network on vlan 208 to the backbone switch."
	link set vlan208 group 3
	link set vlan208 up
	link set vlan208 master bridge0
	link property add dev nexus0 altname pod_gw
	link set nexus0 alias "Virtual wired ethernet device refered to by nexus0 for the podman pods and containers."
	link set nexus0 group 3
	link set nexus0 netns nex-pod-208
	link add link bridge0 name bridge0.208 type vlan id 208
	address add 172.16.208.1/20 label "vlan208:pod" dev bridge0.208
	link set bridge0.208 group 3
	link set bridge0.208 up


	# iscsi ###############################################################
	link add vlan224 type veth peer name nexus0
	link property add dev vlan224 altname iscsi_net
	link set vlan224 alias "Virtual wired ethernet device connecting the iscsi storage network on vlan 224 to the backbone switch."
	link set vlan224 group 3
	link set vlan224 up
	link set vlan224 master bridge0
	link property add dev nexus0 altname iscsi_gw
	link set nexus0 alias "Virtual wired ethernet device refered to by nexus0 for the iscsi storage network"
	link set nexus0 group 3
	link set nexus0 netns nex-iscsi-224
	link add link bridge0 name bridge0.224 type vlan id 224
	address add 172.16.224.1/20 label "vlan224:iscsi" dev bridge0.224
	link set bridge0.224 group 3
	link set bridge0.224 up


	# services ###############################################################
	link add vlan240 type veth peer name nexus0
	link property add dev vlan240 altname srv_net
	link set vlan240 alias "Virtual wired ethernet device connecting the management and services network on vlan 240 to the backbone switch."
	link set vlan240 group 3
	link set vlan240 up
	link set vlan240 master bridge0
	link property add dev nexus0 altname srv_gw
	link set nexus0 alias "Virtual wired ethernet device refered to by nexus0 for services and managment."
	link set nexus0 group 3
	link set nexus0 netns nex-srv-240
	link add link bridge0 name bridge0.240 type vlan id 240
	address add 172.16.240.1/20 label "vlan240:srv" dev bridge0.240
	link set bridge0.240 group 3
	link set bridge0.240 up


	######################################################################
	link set nexus name nexus0
	address add 172.16.128.2/17 label "nexus0:gateway" dev nexus0
	link set nexus0 group 3
	link set nexus0 up
	route add default via 172.16.128.1 dev nexus0
EOF

cat > "$NEXUS_CNF/batch/nex-br-posix-128.batch" <<- 'EOF'
	vlan add dev vlan176 vid 176
	vlan add dev vlan192 vid 192
	vlan add dev vlan208 vid 208
	vlan add dev vlan224 vid 224
	vlan add dev vlan240 vid 240
	vlan add dev bridge0 vid 176 self
	vlan add dev bridge0 vid 192 self
	vlan add dev bridge0 vid 208 self
	vlan add dev bridge0 vid 224 self
	vlan add dev bridge0 vid 240 self
EOF


#######( qemu-176 )#################################
cat > "$NEXUS_CNF/batch/nex-qemu-176.batch" <<- 'EOF'
	link set lo name loopback0
	link property add dev loopback0 altname lo
	link set loopback0 alias "The loopback0 does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
	link set loopback0 group 772
	link set loopback0 up


	link add bridge0 type bridge \
		vlan_default_pvid 176 \
		vlan_filtering 1 \
		vlan_protocol "802.1Q" \
		mdb_offload_fail_notification 1 \
		vlan_stats_per_port 1 \
		mcast_stats_enabled 1 \
		mcast_igmp_version 3 \
		mcast_mld_version 1 \
		mcast_mld_version 2 \
		vlan_stats_enabled 1
	link property add dev bridge0 altname backbone176
	link set bridge0 alias "Logical software bridge device aggregating multiple interfaces refered to as bridge0."
	link set bridge0 group 1
	link set bridge0 up
	address add 172.16.176.2/20 label "bridge0:qemu_gw" dev bridge0
	route add default via 172.16.176.1 dev bridge0


	link set nexus0 group 3
	link set nexus0 master bridge0
	link set nexus0 up


	# Create TAP device for QEMU
	tuntap add dev questing mode tap user user group user
	link set questing master bridge0
	link set questing up


	tuntap add dev wdc2022 mode tap user user group user
	link set wdc2022 master bridge0
	link set wdc2022 up
EOF

cat > "$NEXUS_CNF/batch/nex-br-qemu-176.batch" <<- 'EOF'
	vlan add dev nexus0 vid 176
	vlan add dev bridge0 vid 176 self
	vlan add dev questing vid 176 pvid untagged
	vlan add dev wdc2022 vid 176 pvid untagged
EOF



#######( pods )#################################
cat > "$NEXUS_CNF/batch/nex-pod-208.batch" <<- 'EOF'
	link set nexus0 name nexus


	link set lo name loopback0
	link property add dev loopback0 altname lo
	link set loopback0 alias "The loopback0 does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
	link set loopback0 group 772
	link set loopback0 up


	link add bridge0 type bridge \
		vlan_default_pvid 208 \
		vlan_filtering 1 \
		vlan_protocol "802.1Q" \
		mdb_offload_fail_notification 1 \
		vlan_stats_per_port 1 \
		mcast_stats_enabled 1 \
		mcast_igmp_version 3 \
		mcast_mld_version 1 \
		mcast_mld_version 2 \
		vlan_stats_enabled 1
	link property add dev bridge0 altname backbone208
	link set bridge0 alias "Logical software bridge device aggregating multiple interfaces refered to as bridge0."
	link set bridge0 group 1
	link set bridge0 up
	link add link bridge0 name bridge0.208 type vlan id 208
	address add 172.16.208.2/20 label "bridge0:qemu" dev bridge0.208
	link set bridge0.208 group 3
	link set bridge0.208 up
	route add default via 172.16.208.1 dev bridge0.208


	######( phpmyadmin )###############################
	link add nexus1 type veth peer name nexus0
	link property add dev nexus1 altname pma_net
	link set nexus1 alias "Virtual wired ethernet container holding phpmyadmin which is connected the podman network on vlan 208."
	link set nexus1 group 3
	link set nexus1 up
	link set nexus1 master bridge0
	link property add dev nexus0 altname pma_gw
	link set nexus0 alias "Virtual wired ethernet device refered to by nexus0 for the podman guess phpmyadmin."
	link set nexus0 group 3
	link set nexus0 netns nex-pod-208-phpmyadmin


	######( pgadmin )###############################
	link add nexus2 type veth peer name nexus0
	link property add dev nexus2 altname pg_net
	link set nexus2 alias "Virtual wired ethernet container holding pgadmin which is connected the podman network on vlan 208."
	link set nexus2 group 3
	link set nexus2 up
	link set nexus2 master bridge0
	link property add dev nexus0 altname pg_gw
	link set nexus0 alias "Virtual wired ethernet device refered to by nexus0 for the podman guess phpmyadmin."
	link set nexus0 group 3
	link set nexus0 netns nex-pod-208-pgadmin


	###################################################
	link set nexus name nexus0
	link set nexus0 up
	link set nexus0 master bridge0
EOF

cat > "$NEXUS_CNF/batch/nex-br-pod-208.batch" <<- 'EOF'
	vlan add dev nexus0 vid 208
	vlan add dev nexus1 vid 208 pvid untagged
	vlan add dev bridge0 vid 208 self
EOF


######( phpmyadmin )###############################
cat > "$NEXUS_CNF/batch/nex-pod-208-phpmyadmin.batch" <<- 'EOF'
	link set lo name loopback0
	link property add dev loopback0 altname lo
	link set loopback0 alias "The loopback0 does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
	link set loopback0 group 772
	link set loopback0 up

	###################################################
	address add 172.16.208.4/20 label "nexus0:pma" dev nexus0
	link set nexus0 up
	route add default via 172.16.208.1 dev nexus0
EOF


######( pgadmin )###############################
cat > "$NEXUS_CNF/batch/nex-pod-208-pgadmin.batch" <<- 'EOF'
	link set lo name loopback0
	link property add dev loopback0 altname lo
	link set loopback0 alias "The loopback0 does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
	link set loopback0 group 772
	link set loopback0 up

	###################################################
	address add 172.16.208.3/20 label "nexus0:pg" dev nexus0
	link set nexus0 up
	route add default via 172.16.208.1 dev nexus0
EOF

