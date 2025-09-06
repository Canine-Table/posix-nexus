

ip netns | grep -q 'posix-nexus' || ip netns add posix-nexus
tmpa="$(ip -oneline link show posix-nexus type veth 2> /dev/null)"
test -n "$tmpa" || {
	ip link add posix-nexus type veth peer name podman
	tmpa="$(ip -oneline link show posix-nexus)" || {
		return 1
	}
}

G_NEX_BRIDGE="${G_NEX_BRIDGE:-"$(ip link show type bridge | awk -F ':' '{print substr($2, 2); exit}')"}"
test -z "$G_NEX_BRIDGE" && {
	printf '%s\n' 'G_NEX_BRIDGE was not specified and no bridge device was detected, creating br0.'
	ip link add name br0 type bridge
	ip address add "${G_NEX_PRIMARY_BRIDGE:-"172.16.0.1/16"}" dev br0
	ip link set dev br0 up
	G_NEX_BRIDGE='br0'
}


ip -detail -oneline link show | grep -q 'tun type tap' || {
	ip tuntap add dev tap0 mode tap user "$LOGNAME"
	ip link set tap0 master "$G_NEX_BRIDGE"
	ip link set tap0 up
}

export G_NEX_DEFAULT_ROUTE="${G_NEX_DEFAULT_ROUTE:-"$(ip -family inet address show "$G_NEX_BRIDGE" | awk '/inet/{sub(/\/.+$/, "", $2); print $2; exit}')"}"
export G_NEX_PRIMARY_PODMAN="${G_NEX_PRIMARY_PODMAN:-"172.16.128.1/16"}"

printf '%s' "$tmpa" | grep -q ' link-netns posix-nexus ' || {
	ip link set podman netns posix-nexus
}


printf '%s' "$tmpa" | grep -q " master $G_NEX_BRIDGE " || {
	ip link set posix-nexus master "$G_NEX_BRIDGE"
}

printf '%s' "$tmpa" | grep -q ' state UP ' || {
	ip link set posix-nexus up
	ip netns exec posix-nexus ip link set podman up
}

ip netns exec posix-nexus ip -family inet address show podman primary | 1> /dev/null 2>&1 || {
	ip netns exec posix-nexus ip address add "$G_NEX_PRIMARY_PODMAN"
}

ip netns exec posix-nexus ip -family inet route show default 1> /dev/null 2>&1 || {
	ip netns exec posix-nexus ip route add default via "$G_NEX_DEFAULT_ROUTE" dev podman
}

tmpa="$(findmnt --type nsfs --target /run/netns/posix-nexus | sed -n '2p')"
test -n "$tmpa" || {
	mount --bind /run/netns/posix-nexus /run/netns/posix-nexus
	mount --make-shared /run/netns/posix-nexus
}

unset tmpa

