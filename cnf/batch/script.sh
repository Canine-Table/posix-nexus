#!/bin/sh
test -d "$NEXUS_CNF" || exit 1


#######( cleanup )#################################
cat > "$NEXUS_CNF/batch/clean.batch" <<- 'EOF'
	link delete nexus0 type veth
	link delete dummy0 type dummy
	link delete wireguard0 type wireguard
	netns delete nex-posix-128
	netns delete nex-qemu-176
	netns delete nex-pod-208
	netns delete nex-pod-208-adminer
	netns delete nex-pod-208-pgadmin
	netns delete nex-pod-208-ri
	netns delete nex-pod-208-jellyfin
	netns delete nex-pod-208-nextcloud
	netns delete nex-pod-208-talk
	netns delete nex-pod-208-cups
	netns delete nex-pod-208-penpot

	netns delete nex-vpn-192
	netns delete nex-iscsi-224
	netns delete nex-srv-240
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

	nsenter --net=/var/run/netns/nex-pod-208-adminer -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-adminer.batch"
	nsenter --net=/var/run/netns/nex-pod-208-pgadmin -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-pgadmin.batch"
	nsenter --net=/var/run/netns/nex-pod-208-ri -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-ri.batch"
	nsenter --net=/var/run/netns/nex-pod-208-jellyfin -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-jellyfin.batch"
	nsenter --net=/var/run/netns/nex-pod-208-cups -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-cups.batch"
	nsenter --net=/var/run/netns/nex-pod-208-nextcloud -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-nextcloud.batch"
	nsenter --net=/var/run/netns/nex-pod-208-penpot -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-penpot.batch"
	nsenter --net=/var/run/netns/nex-pod-208-talk -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-talk.batch"
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

	# Wireguad setup
	link add dummy0 type dummy
	link set dev dummy0 addrgenmode none
	link property add dev dummy0 altname wg_proxy
	link set dummy0 group 69
	link set dummy0 up
	link set dev dummy0 address de:ad:de:af:be:ef
	link add dev wireguard0 type wireguard

	netns add nex-qemu-176
	netns add nex-pod-208
	netns add nex-pod-208-adminer
	netns add nex-pod-208-pgadmin
	netns add nex-pod-208-ri
	netns add nex-pod-208-jellyfin
	netns add nex-pod-208-nextcloud
	netns add nex-pod-208-talk
	netns add nex-pod-208-cups
	netns add nex-pod-208-penpot

	netns add nex-vpn-192
	netns add nex-iscsi-224
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


	######( adminer )###############################
	link add nexus1 type veth peer name nexus0
	link property add dev nexus1 altname admr_net
	link set nexus1 alias "Virtual wired ethernet container holding adminer which is connected the podman network on vlan 208."
	link set nexus1 group 3
	link set nexus1 up
	link set nexus1 master bridge0
	link property add dev nexus0 altname admr_gw
	link set nexus0 alias "Virtual wired ethernet device refered to by nexus0 for the podman guess adminer."
	link set nexus0 group 3
	link set nexus0 netns nex-pod-208-adminer


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


	######( redisinsight )###############################
	link add nexus3 type veth peer name nexus0
	link property add dev nexus3 altname vk_net
	link set nexus3 alias "Virtual wired ethernet container holding redisinsight with valkey which is connected the podman network on vlan 208."
	link set nexus3 group 3
	link set nexus3 up
	link set nexus3 master bridge0
	link property add dev nexus0 altname vk_gw
	link set nexus0 alias "Virtual wired ethernet device refered to by nexus0 for the podman guess redisinsight with valkey."
	link set nexus0 group 3
	link set nexus0 netns nex-pod-208-ri


	######( jellyfin )###############################
	link add nexus4 type veth peer name nexus0
	link property add dev nexus4 altname jfn_net
	link set nexus4 alias "Virtual wired ethernet container holding jellyfin which is connected the podman network on vlan 208."
	link set nexus4 group 3
	link set nexus4 up
	link set nexus4 master bridge0
	link property add dev nexus0 altname jfn_gw
	link set nexus0 alias "Virtual wired ethernet device refered to by nexus0 for the podman guess jellyfin."
	link set nexus0 group 3
	link set nexus0 netns nex-pod-208-jellyfin


	######( nextcloud )###############################
	link add nexus5 type veth peer name nexus0
	link property add dev nexus5 altname nxtcld_net
	link set nexus5 alias "Virtual wired ethernet container holding nextcloud which is connected the podman network on vlan 208."
	link set nexus5 group 3
	link set nexus5 up
	link set nexus5 master bridge0
	link property add dev nexus0 altname nxtcld_gw
	link set nexus0 alias "Virtual wired ethernet device refered to by nexus0 for the podman guess nextcloud."
	link set nexus0 group 3
	link set nexus0 netns nex-pod-208-nextcloud


	######( cups )###############################
	link add nexus6 type veth peer name nexus0
	link property add dev nexus6 altname cups_net
	link set nexus6 alias "Virtual wired ethernet container holding cups which is connected the podman network on vlan 208."
	link set nexus6 group 3
	link set nexus6 up
	link set nexus6 master bridge0
	link property add dev nexus0 altname cups_gw
	link set nexus0 alias "Virtual wired ethernet device refered to by nexus0 for the podman guest cups."
	link set nexus0 group 3
	link set nexus0 netns nex-pod-208-cups


	######( penpot )###############################
	link add nexus7 type veth peer name nexus0
	link property add dev nexus7 altname pnpt_net
	link set nexus7 alias "Virtual wired ethernet container holding penpot which is connected the podman network on vlan 208."
	link set nexus7 group 3
	link set nexus7 up
	link set nexus7 master bridge0
	link property add dev nexus0 altname pnpt_gw
	link set nexus0 alias "Virtual wired ethernet device refered to by nexus0 for the podman guest penpot."
	link set nexus0 group 3
	link set nexus0 netns nex-pod-208-penpot


	######( penpot )###############################
	link add nexus8 type veth peer name nexus0
	link property add dev nexus8 altname talk_net
	link set nexus8 alias "Virtual wired ethernet container holding nextcloud talk which is connected the podman network on vlan 208."
	link set nexus8 group 3
	link set nexus8 up
	link set nexus8 master bridge0
	link property add dev nexus0 altname talk_gw
	link set nexus0 alias "Virtual wired ethernet device refered to by nexus0 for the podman guest talk."
	link set nexus0 group 3
	link set nexus0 netns nex-pod-208-talk

	###################################################
	link set nexus name nexus0
	link set nexus0 up
	link set nexus0 master bridge0
EOF

cat > "$NEXUS_CNF/batch/nex-br-pod-208.batch" <<- 'EOF'
	vlan add dev nexus0 vid 208
	vlan add dev nexus1 vid 208 pvid untagged
	vlan add dev nexus2 vid 208 pvid untagged
	vlan add dev nexus3 vid 208 pvid untagged
	vlan add dev nexus4 vid 208 pvid untagged
	vlan add dev nexus5 vid 208 pvid untagged
	vlan add dev nexus6 vid 208 pvid untagged
	vlan add dev nexus7 vid 208 pvid untagged
	vlan add dev nexus8 vid 208 pvid untagged
	vlan add dev bridge0 vid 208 self
EOF


######( adminer )###############################
cat > "$NEXUS_CNF/batch/nex-pod-208-adminer.batch" <<- 'EOF'
	link set lo name loopback0
	link property add dev loopback0 altname lo
	link set loopback0 alias "The loopback0 does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
	link set loopback0 group 772
	link set loopback0 up

	###################################################
	address add 172.16.208.4/20 label "nexus0:admr" dev nexus0
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


######( redisinsight )###############################
cat > "$NEXUS_CNF/batch/nex-pod-208-ri.batch" <<- 'EOF'
	link set lo name loopback0
	link property add dev loopback0 altname lo
	link set loopback0 alias "The loopback0 does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
	link set loopback0 group 772
	link set loopback0 up

	###################################################
	address add 172.16.208.5/20 label "nexus0:vk" dev nexus0
	link set nexus0 up
	route add default via 172.16.208.1 dev nexus0
EOF


######( jellyfin )###############################
cat > "$NEXUS_CNF/batch/nex-pod-208-jellyfin.batch" <<- 'EOF'
	link set lo name loopback0
	link property add dev loopback0 altname lo
	link set loopback0 alias "The loopback0 does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
	link set loopback0 group 772
	link set loopback0 up

	###################################################
	address add 172.16.208.6/20 label "nexus0:jfn" dev nexus0
	link set nexus0 up
	route add default via 172.16.208.1 dev nexus0
EOF

######( nextcloud )###############################
cat > "$NEXUS_CNF/batch/nex-pod-208-nextcloud.batch" <<- 'EOF'
	link set lo name loopback0
	link property add dev loopback0 altname lo
	link set loopback0 alias "The loopback0 does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
	link set loopback0 group 772
	link set loopback0 up

	###################################################
	address add 172.16.208.7/20 label "nexus0:nxtcld" dev nexus0
	link set nexus0 up
	route add default via 172.16.208.1 dev nexus0
EOF


######( cups )###############################
cat > "$NEXUS_CNF/batch/nex-pod-208-cups.batch" <<- 'EOF'
	link set lo name loopback0
	link property add dev loopback0 altname lo
	link set loopback0 alias "The loopback0 does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
	link set loopback0 group 772
	link set loopback0 up

	###################################################
	address add 172.16.208.8/20 label "nexus0:cups" dev nexus0
	link set nexus0 up
	route add default via 172.16.208.1 dev nexus0
EOF

######( penpot )###############################
cat > "$NEXUS_CNF/batch/nex-pod-208-penpot.batch" <<- 'EOF'
	link set lo name loopback0
	link property add dev loopback0 altname lo
	link set loopback0 alias "The loopback0 does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
	link set loopback0 group 772
	link set loopback0 up

	###################################################
	address add 172.16.208.9/20 label "nexus0:pnpt" dev nexus0
	link set nexus0 up
	route add default via 172.16.208.1 dev nexus0
EOF

######( aio )###############################
cat > "$NEXUS_CNF/batch/nex-pod-208-talk.batch" <<- 'EOF'
	link set lo name loopback0
	link property add dev loopback0 altname lo
	link set loopback0 alias "The loopback0 does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
	link set loopback0 group 772
	link set loopback0 up

	###################################################
	address add 172.16.208.10/20 label "nexus0:talk" dev nexus0
	link set nexus0 up
	route add default via 172.16.208.1 dev nexus0
EOF

