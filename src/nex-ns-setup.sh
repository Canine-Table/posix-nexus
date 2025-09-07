. "$(cat "$HOME/.nx-root" 2> /dev/null)"

test -n "$NEXUS_CNF" || {
	printf 'nex-init needs to loaded before using these tools.\n'
	return 1
}

test "$(id -u)" -eq 0 || {
	nx_io_printf -E "elevated privileges required!"
	return 2
}

ip netns | grep -q 'posix-nexus' || ip netns add posix-nexus
tmpa="$(ip -oneline link show nex0 type veth 2> /dev/null)"
test -z "$tmpa" && {
	ip link add nex0 type veth peer name nex1
	tmpa="$(ip -oneline link show nex0)"
	test -z "$tmpa" && return 1
}

G_NEX_BRIDGE="${G_NEX_BRIDGE:-"$(ip link show type bridge | awk -F ':' '{print substr($2, 2); exit}')"}"
test -z "$G_NEX_BRIDGE" && {
	printf '%s\n' 'G_NEX_BRIDGE was not specified and no bridge device was detected, creating br0.'
	ip link add name br0 type bridge
	ip address add "${G_NEX_PRIMARY_BRIDGE:-"172.16.0.1/16"}" dev br0
	ip link set dev br0 up
	G_NEX_BRIDGE='br0'
}

export G_NEX_DEFAULT_ROUTE="${G_NEX_DEFAULT_ROUTE:-"$(ip -family inet address show "$G_NEX_BRIDGE" | awk '/inet/{sub(/\/.+$/, "", $2); print $2; exit}')"}"
export G_NEX_PRIMARY_NETNS="${G_NEX_PRIMARY_NETNS:-"172.16.128.1/16"}"

ip -detail -oneline link show | grep -q 'tun type tap' || {
        ip tuntap add dev tap0 mode tap user "$LOGNAME"
        ip link set tap0 master "$G_NEX_BRIDGE"
        ip link set tap0 up
}


printf '%s' "$tmpa" | grep -q " master $G_NEX_BRIDGE " || {
	ip link set nex0 master "$G_NEX_BRIDGE"
}

ip -oneline -detail link show nex0 type veth | grep -q ' link-netns posix-nexus ' || {
	ip link set nex1 netns posix-nexus
	ip netns exec posix-nexus ip link set nex1 name nex0
}

printf '%s' "$tmpa" | grep -q ' state UP ' || {
	ip link set nex0 up
	ip netns exec posix-nexus ip link set nex0 up
	ip netns exec posix-nexus ip link set lo up
}

tmpa="$(ip netns exec posix-nexus ip -family inet address show nex0 primary)"
test -z "$tmpa" && {
	ip netns exec posix-nexus ip address add "$G_NEX_PRIMARY_NETNS" dev nex0
}

tmpa="$(ip netns exec posix-nexus ip -family inet route show default)"
test -z "$tmpa" && {
	ip netns exec posix-nexus ip route add default via "$G_NEX_DEFAULT_ROUTE" dev nex0
}

tmpa="$(ip netns exec posix-nexus ip link show "$G_NEX_BRIDGE" type bridge)"
test -z "$tmpa" && {
	ip netns exec posix-nexus ip link add name "$G_NEX_BRIDGE" type bridge
	ip netns exec posix-nexus ip link set dev br0 up
}

ip netns exec posix-nexus ip -detail -oneline link show | grep -q 'tun type tap' || {
	ip netns exec posix-nexus ip tuntap add dev tap0 mode tap user nex
	ip netns exec posix-nexus ip link set tap0 master "$G_NEX_BRIDGE"
	ip netns exec posix-nexus ip link set tap0 up
}

findmnt --type nsfs --target /run/netns/posix-nexus 1> /dev/null 2>&1 || {
	mount --bind /run/netns/posix-nexus /run/netns/posix-nexus
	mount --make-shared /run/netns/posix-nexus
}

tmpa="$(cat /var/run/posix-nexus.pid 2>/dev/null)"
test -n "$pid" && kill -0 "$tmpa" 2>/dev/null && kill -s SIGTERM "$tmpa"
nsenter --net=/var/run/netns/posix-nexus sh -c 'nohup setsid sleep infinity 1> /dev/null 2>&1 & printf $! > /var/run/posix-nexus.pid'
tmpa="$(cat /var/run/posix-nexus.pid 2>/dev/null)"

tmpb="posix-nexus.$(hostname | cut -d '.' -f 2-)"
nsenter --target "$tmpa" --uts hostname "$tmpb"

export G_NEX_CGROUP='/sys/fs/cgroup/posix-nexus'
printf '%d' "$tmpa" > "$G_NEX_CGROUP/cgroup.procs"

mkdir -p "$G_NEX_CGROUP"
chown -R nex:nex "$G_NEX_CGROUP"

eval "$(${AWK:-$(nx_cmd_awk)} -v json="$NEXUS_CNF/nx.json" "
	$(nx_data_include -i "$NEXUS_LIB/awk/nex-json.awk")
"'
	BEGIN {
		if (err = nx_json(json, arr, 2))
			exit err
		nx_json_split(".cgroup", arr, flgs)
		if (nx_json_type(".cgroup", arr) == 1) { # an object?
			for (i = 1; i <= flgs[0]; ++i) {
				if (arr[".nx.cgroup." flgs[i]] ~ /^([1-9][0-9]+([\t ]*[1-9][0-9]+)?|max)$/)
					print "printf \x27%s\x27 \x22" arr[".nx.cgroup." flgs[i]] "\x22 > " ENVIRON["G_NEX_CGROUP"] "/" flgs[i]
			}
		}
		delete flgs
		delete arr
	}
')"

test -n "$(getent passwd | ${AWK:-$(nx_cmd_awk)} -F ':' '{ if ($1 == "nex") { print; exit }}')" || {
	useradd -rm -d /var/tmp/nex -c 'Posix-Nexus' -G wheel -s /bin/sh nex
}

for tmpa in subuid subgid; do
	test -n "$(cat "/etc/$tmpa" | ${AWK:-$(nx_cmd_awk)} -F ':' '{ if ($1 == "nex") { print; exit }}')" || {
		printf '%s\n' 'nex:100000:65536' | tee -a "/etc/$tmpa"
	}
done

${AWK:-$(nx_cmd_awk)} -F ':' '
	/^nex:/{
		if ($2 == "!")
			exit 0
		exit 1
	}
' /etc/shadow || passwd --lock nex 1> /dev/null 2>&1
unset tmpb tmpa

