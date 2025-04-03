__chk_inet_opt()
{
	set_struct_opt -i "$1" -r "$($2)"
}

__get_inet_opt()
{
	get_struct_list -u -s ',' -o ',' "$1"
}

__get_inet_dev()
{
	ip --color=never "$1" show "$(chk_inet_dev_names "$2")"
}

get_inet_dev_names()
{
	(
		[ "$1" != false ] && l_tmpa="$(
			get_str_search \
				-o ',' \
				-f '/altname/,1' \
				ip --color=never link show
		)"
		[ "$2" != false ] && l_tmpb="$(
			get_str_search \
				-o ',' \
				-f '/mtu/(@.*|:)/,-2' \
				ip --color=never link show
		)"
		echo -n "$l_tmpa${l_tmpa:+${l_tmpb:+,}}$l_tmpb"
	)
}

chk_inet_dev_names() { __chk_inet_opt "$1" get_inet_dev_names }
get_inet_dev_family() { __get_inet_opt 'inet6,inet,link,mpls,bridge' }
chk_inet_dev_family() { __chk_inet_opt "$1" get_inet_dev_family }


get_inet_dev_real()
{
	(
		while getopts :d:pa OPT; do
			case $OPT in
				p) c="(.*@|:)";;
				a) c=":";;
				d) d="$OPTARG";;
			esac
		done
		shift $((OPTIND -1))
		get_str_search -o ',' -f "/mtu/${c:-(@.*|:)}/g,-2" __get_inet_dev link "${d:-$1}"
	)
}

get_inet_dev_alt()
{
	get_str_search -o ',' -f '/altname/,1' __get_inet_dev link "$1"
}

