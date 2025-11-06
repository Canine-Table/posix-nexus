nx_wget_archive()
(
	h_nx_cmd wget || {
		nx_io_printf -E 'wget not found' 2>&1
		exit 192
	}
	eval "$(nx_str_optarg 'e:i:l:u:E:' "$@")"
	test -z "$u" && {
		nx_io_printf -E '(-u) not specified, installing the void is not yet supported.' 2>&1
		exit 1
	}
	l="$(nx_int_natural "$l")"
	wget -r -l${l:-1} -H -nd -A ${i:-mp4} -e "${e:-robots=off} ${E:+$E}" "$u"
)

