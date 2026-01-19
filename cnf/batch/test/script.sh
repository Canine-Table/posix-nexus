

cat > clean.batch << 'EOF'
netns delete nex-a
netns delete nex-b
EOF


cat > nex-ns.sh << 'EOF'
ip -batch clean.batch
ip -batch nex-default.batch

nsenter --net=/var/run/netns/nex-a -- ip -batch nex-a.batch
nsenter --net=/var/run/netns/nex-a -- bridge -batch nex-br-a.batch

nsenter --net=/var/run/netns/nex-b -- ip -batch nex-b.batch
nsenter --net=/var/run/netns/nex-b -- bridge -batch nex-br-b.batch

EOF

cat > nex-default.batch << 'EOF'
netns add nex-a
netns add nex-b
EOF

cat > nex-a.batch << 'EOF'
link add bridge0 type bridge \
vlan_default_pvid 999 \
vlan_filtering 1 \
vlan_protocol "802.1Q" \
mcast_igmp_version 3 \
mdb_offload_fail_notification 1 \
vlan_stats_per_port 1 \
mcast_stats_enabled 1 \
mcast_igmp_version 3 \
mcast_mld_version 1 \
mcast_mld_version 2 \
nf_call_iptables 1 \
nf_call_ip6tables 1 \
nf_call_arptables 1 \
vlan_stats_enabled 1

link add nexus1 type veth peer name nexus0
link set nexus1 netns nex-b
link set nexus0 master bridge0
link set bridge0 up
link set nexus0 up

link add link bridge0 name bridge0.176 type vlan id 176
address add 172.16.176.2/20 label "bridge0:a_gw" dev bridge0.176
link set bridge0.176 group 3
link set bridge0.176 up
route add default via 172.16.176.1 dev bridge0.176

EOF

cat > nex-br-a.batch << 'EOF'
#vlan add dev nexus0 vid 176 pvid untagged
#vlan add dev nexus0 vid 176-999
#vlan add dev vlan176 vid 176,999
#vlan add dev vlan176 vid 176 pvid untagged master
EOF

cat > nex-b.batch << 'EOF'
link add bridge0 type bridge \
mcast_igmp_version 3 \
vlan_stats_per_port 1 \
vlan_protocol "802.1Q" \
vlan_default_pvid 999 \
vlan_filtering 1 \
mdb_offload_fail_notification 1 \
mcast_stats_enabled 1 \
mcast_igmp_version 3 \
mcast_mld_version 1 \
mcast_mld_version 2 \
vlan_stats_enabled 1 \
nf_call_iptables 1 \
nf_call_ip6tables 1 \
nf_call_arptables 1

link set nexus1 name nexus0
link set nexus0 master bridge0
link set bridge0 up
link set nexus0 up

link add link bridge0 name bridge0.176 type vlan id 176
link add link nexus0 name nexus0.176 type vlan id 176
link set nexus0.176 master bridge0
link set nexus0.176 up
address add 172.16.176.1/20 label "bridge0:b_gw" dev bridge0.176
link set bridge0.176 group 3
link set bridge0.176 up
route add default via 172.16.176.2 dev bridge0.176
EOF

cat > nex-br-b.batch << 'EOF'
#vlan add dev bridge0.176 vid 176 pvid untagged
vlan add dev nexus0.176 vid 176 pvid untagged
vlan add dev nexus0 vid 176 pvid untagged
#vlan add dev nexus0 vid 999
#vlan add dev questing vid 176 pvid untagged
EOF

