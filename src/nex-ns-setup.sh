. "$(cat "$HOME/.nx-root" 2> /dev/null)"

test -n "$NEXUS_CNF" || {
	printf 'nex-init needs to loaded before using these tools.\n'
	return 1
}

test "$(id -u)" -eq 0 || {
	nx_io_printf -E "elevated privileges required!"
	return 2
}

sysctl --system 1> /dev/null 2>&1

test -z "$(g_nx_ip_ifname 'bridge0')" && {
	s_nx_ip_brtun -u 'user'
	s_nx_ip_inet -a '172.16.128.1/17' -l 'internal4' -i 'bridge0'
	s_nx_ip_inet -a 'dead:dead:beef:acad::1/113' -l 'internal6' -i 'bridge0'
}

test -n "$(getent passwd | ${AWK:-$(nx_cmd_awk)} -F ':' '{ if ($1 == "nex") { print; exit }}')" || {
        useradd -rm -d /var/tmp/nex -c 'Posix-Nexus' -G wheel -s /bin/sh nex
}

for tmpa in subuid subgid; do
        test -n "$(${AWK:-$(nx_cmd_awk)} -F ':' '/^nex:/{ print; exit }' "/etc/$tmpa")" || {
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


test -z "$(g_nx_ip_ifname 'bridge0' 'posix-nexus')" && {
	s_nx_ip_brtun -u 'nex' -n 'posix-nexus'
	s_nx_ip_inet -a '172.16.128.2/17' -l 'bridge4' -i 'bridge0' -n 'posix-nexus'
	s_nx_ip_inet -a 'dead:deaf:beef:acad::2/113' -l 'bridge6' -i 'bridge0' -n 'posix-nexus'
	s_nx_ip_route -n 'posix-nexus' -a '172.16.128.1' -i 'bridge0'
	s_nx_ip_route -n 'posix-nexus' -a 'dead:deaf:beef:acad::1' -i 'bridge0'
}

test -z "$(g_nx_ip_ifname 'nexus0' 'posix-nexus')" && {
	s_nx_ip_veth -N 'posix-nexus' -p 'nexus'
	s_nx_ip_master -m 'bridge0' -i 'nexus0' -n 'posix-nexus'
	s_nx_ip_master -m 'bridge0' -i 'nexus0'
}

NX_IDX=3
NX_IFACE=1
for NX_NS in \
	'pgadmin4' 'phpmyadmin' \
	'phpldapadmin' 'grafana' \
	'cups' 'papercut' 'cockpit'
do
	test -z "$(g_nx_ip_ifname "nexus$NX_IFACE" 'posix-nexus')" && {
		s_nx_ip_veth -N 'posix-nexus' -p 'nexus' -n "nexus-$NX_NS"
		s_nx_ip_master -m 'bridge0' -i "nexus$NX_IFACE" -n 'posix-nexus'
		s_nx_ip_inet -a "172.16.128.$NX_IDX/17" -l 'veth4' -i 'nexus0' -n "nexus-$NX_NS"
		s_nx_ip_inet -a "dead:deaf:beef:acad::$NX_IDX/113" -l 'veth6' -i 'nexus0' -n "nexus-$NX_NS"
		s_nx_ip_route -n "nexus-$NX_NS" -a '172.16.128.2' -i 'nexus0'
		s_nx_ip_route -n "nexus-$NX_NS" -a 'dead:deaf:beef:acad::2' -i 'nexus0'
	}
	test "$NX_IDX" -eq 254 && break
	NX_IDX="$((NX_IDX + 1))"
	NX_IFACE="$((NX_IFACE + 1))"
done
unset NX_IDX NX_IFACE NX_NS

