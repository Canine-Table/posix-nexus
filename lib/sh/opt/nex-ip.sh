nx_ip_net()
{
	ls --color=never -l '/sys/class/net/' | ${AWK:-$(nx_cmd_awk)} -v ex="$1" -F '/' '
		BEGIN {
			if (ex == "-e")
				ex = "export "
			else
				ex = ""
			virt = ""
			phy = ""
		}
		/devices\/pci/{
			phy = phy " " $NF
		}
		/devices\/virtual/{
			virt = virt " " $NF
		}
		END {
			printf("%sG_NEX_NET_VIRT\x22=%s\x22\n%sG_NEX_NET_PHY=\x22%s\x22\n", ex, substr(virt, 2), ex, substr(phy, 2));
		}
	'
}

nx_ip_name()
(
	test -n "$1" || exit
	${AWK:-$(nx_cmd_awk)} -v name="$2" -v newname="$1" 'BEGIN {
		if (name ~ newname "[0-9]+")
			exit 1
		exit 0
	}' || exit
	tmpa=0
	while ip link show "$1$tmpa" 2>/dev/null 1>&2; do
		tmpa=$((tmpa+1))
	done
	printf '%s\n' "$1$tmpa"
)

nx_ip_netns()
{
	test -n "$1" || return
	ip netns | grep -q "$1" || ip netns add "$1"
}

nx_ip_exec()
{
	ip netns exec $*
}

nx_ip_group()
{
	ip link set "$1" group "$(nx_int_natural "$2" || printf '%s' 'default')"
}

nx_ip_alias()
{
	ip link set "$1" alias "$2"
}

