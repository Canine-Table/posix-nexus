read -p "for who? "
ip tuntap add dev tap0 mode tap user "$REPLY"
ip link set tap0 up
ip link add name br0 type bridge
ip link set dev br0 up
ip link set tap0 master br0
ip link set tap0 up

# Create veth pair
ip netns add posix-nexus
ip link add posix-nexus type veth peer name podman

# Attach one end to bridge
ip link set posix-nexus master br0
ip link set posix-nexus up

# Move other end to namespace
ip link set podman netns posix-nexus
ip netns exec posix-nexus ip link set podman up
