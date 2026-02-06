

cat > clean.batch << 'EOF'
link delete nexus0 type veth
netns delete nex-posix-128
netns delete nex-qemu-176
netns delete nex-pod-208

#netns delete nex-vpn-192
#netns delete  nex-iscsi-224
#netns delete nex-srv-240
EOF

cat > nex-ns.sh << 'EOF'
ip -batch "$NEXUS_CNF/batch/clean.batch"
ip -batch "$NEXUS_CNF/batch/nex-default.batch"

nsenter --net=/var/run/netns/nex-posix-128 -- ip -batch "$NEXUS_CNF/batch/nex-posix-128.batch"
nsenter --net=/var/run/netns/nex-posix-128 -- bridge -batch "$NEXUS_CNF/batch/nex-br-posix-128.batch"
nsenter --net=/var/run/netns/nex-posix-128 -- nft -f /etc/nftables.d/nex-posix-128/nat.nft

nsenter --net=/var/run/netns/nex-qemu-176 -- ip -batch "$NEXUS_CNF/batch/nex-qemu-176.batch"
nsenter --net=/var/run/netns/nex-qemu-176 -- bridge -batch "$NEXUS_CNF/batch/nex-br-qemu-176.batch"

nsenter --net=/var/run/netns/nex-pod-208 -- ip -batch "$NEXUS_CNF/batch/nex-pod-208.batch"
nsenter --net=/var/run/netns/nex-pod-208 -- bridge -batch "$NEXUS_CNF/batch/nex-br-pod-208.batch"
EOF

cat > nex-default.batch << 'EOF'
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

netns add nex-qemu-176
netns add nex-pod-208
EOF

cat > nex-posix-128.batch << 'EOF'
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


#nf_call_iptables 1 \
#nf_call_ip6tables 1 \
#nf_call_arptables 1 \

link property add dev bridge0 altname backbone128
link set bridge0 alias "Logical software bridge device aggregating multiple interfaces refered to as bridge0."
link set bridge0 group 1
link set bridge0 up



link add link bridge0 name bridge.176 type vlan id 176
address add 172.16.176.1/20 label "vlan176:qemu" dev bridge.176
link set bridge.176 group 3
link set bridge.176 up

link set nexus0 name nexus


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


# pods ###############################################################
link add link bridge0 name bridge.208 type vlan id 208
address add 172.16.208.1/20 label "vlan208:pods" dev bridge.208
link set bridge.208 group 3
link set bridge.208 up

link add vlan208 type veth peer name nexus0
link property add dev vlan208 altname pod_net
link set vlan208 alias "Virtual wired ethernet device connecting the podman network on vlan 208 to the backbone switch."
link set vlan208 group 3
link set vlan208 up
link set vlan208 master bridge0

link property add dev nexus0 altname pod_gw
link set nexus0 alias "Virtual wired ethernet device refered to by nexus0 for the podman pods and containers."
link set nexus0 group 3
link set nexus0 up

link set nexus0 netns nex-pod-208

######################################################################

link set nexus name nexus0
address add 172.16.128.2/17 label "nexus0:gateway" dev nexus0
link set nexus0 group 3
link set nexus0 up
route add default via 172.16.128.1 dev nexus0

link set bridge0 up

EOF

cat > nex-br-posix-128.batch << 'EOF'
vlan add dev vlan176 vid 176
vlan add dev vlan208 vid 208
vlan add dev bridge0 vid 176,208,176,224,240 self
EOF

cat > nex-qemu-176.batch << 'EOF'
link set lo name loopback0
link property add dev loopback0 altname lo
link set loopback0 alias "The loopback0 does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
link set loopback0 group 772
link set loopback0 up

link add bridge0 type bridge \
        vlan_filtering 1 \
        vlan_default_pvid 176

link property add dev bridge0 altname backbone176
link set bridge0 alias "Logical software bridge device aggregating multiple interfaces refered to as bridge0."
link set bridge0 group 1
link set bridge0 up

address add 172.16.176.2/20 label "bridge0:qemu_gw" dev bridge0
link set bridge0 group 1
link set bridge0 up
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

cat > nex-br-qemu-176.batch << 'EOF'
vlan add dev nexus0 vid 176
vlan add dev bridge0 vid 176 self
vlan add dev questing vid 176 pvid untagged
vlan add dev wdc2022 vid 176 pvid untagged
EOF

cat > nex-pod-208.batch << 'EOF'
link set lo name loopback0
link property add dev loopback0 altname lo
link set loopback0 alias "The loopback0 does not traverse wires. It does not blink with LEDs. It does not care for MAC addresses or ARP. It is pure essence—an idea made manifest. A metaphysical interface, looping endlessly, like Ouroboros devouring its own tail."
link set loopback0 group 772
link set loopback0 up

link add bridge0 type bridge \
        vlan_filtering 1 \
        vlan_default_pvid 208

link property add dev bridge0 altname backbone208
link set bridge0 alias "Logical software bridge device aggregating multiple interfaces refered to as bridge0."
link set bridge0 group 1
link set bridge0 up

address add 172.16.208.2/20 label "bridge0:pod_gw" dev bridge0
link set bridge0 group 1
link set bridge0 up
route add default via 172.16.208.1 dev bridge0

link set nexus0 group 3
link set nexus0 master bridge0
link set nexus0 up
EOF

cat > nex-br-pod-208.batch << 'EOF'
vlan add dev nexus0 vid 208
vlan add dev bridge0 vid 208 self
EOF


