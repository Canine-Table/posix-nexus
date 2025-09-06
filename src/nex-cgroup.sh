
test -n "$NEXUS_CNF" || {
	printf 'nex-init needs to loaded before using these tools.\n'
	return 1
}

test "$(id -u)" -eq 0 || {
	nx_io_printf -E "elevated privileges required!"
	return 2
}

export G_NEX_CGROUP='/sys/fs/cgroup/posix-nexus'
export G_NEX_NETNS="$(nx_info_path -b "$G_NEX_CGROUP")"

ip netns | grep -q "$G_NEX_NETNS" || ip netns add "$NEX_NETNS"

mkdir -p "$G_NEX_CGROUP"
chown -R nex:nex "$G_NEX_CGROUP"

tmpa="$(${AWK:-$(get_cmd_awk)} -v json="$NEXUS_CNF/nx.json" "
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

test "$1" = "-d" && printf '%s\n' "$tmpa" || eval "$tmpa"
test -n "$(getent passwd | ${AWK:-$(get_cmd_awk)} -F ':' '{ if ($1 == "nex") { print; exit }}')" || {
	useradd -rm -d /var/tmp/nex -c 'Posix-Nexus' -G wheel -s /bin/sh nex
}

for tmpa in subuid subgid; do
	test -n "$(cat "/etc/$tmpa" | ${AWK:-$(get_cmd_awk)} -F ':' '{ if ($1 == "nex") { print; exit }}')" || {
		printf '%s\n' 'nex:100000:65536' | tee -a "/etc/$tmpa"
	}
done

unset tmpa

# usermod -s /usr/sbin/nologin nex
# usermod -s /bin/false nex

