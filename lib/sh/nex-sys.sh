
nx_sys_sudo()
{
	# TODO this kind of sucks, needs some work
	export G_NEX_SYS_SUDO="$(nx_cmd_sudo)"
	if [ "$(id -u)" = 0 -o -z "$G_NEX_SYS_SUDO" ]; then
		eval "$*"
	else
		if h_nx_cmd dialog; then
			nx_dialog_factory -v 'yesno' -l '
				"yes": "Proceed",
				"title": "Privilege escalation alert",
				"no": "Cancel"
			' -m "
				\r \tYou are about to execute:
				\r\t$(nx_info_path -b "$G_NEX_SYS_SUDO") $*
				\r \tAre you sure?
			"
		else
			nx_tui_yn "you sure" "a" "q" "a"
			return
		fi && eval "$G_NEX_SYS_SUDO $SHELL -c '
			. \"$NEXUS_ENV/.nexus-shell.bundle.sh\"
			$*
		'"
	fi
}

nx_sys_getent()
{
	[ -n "$1" ] && h_nx_cmd getent && {
		getent "$1"
	} || [ -n "$2" -a -f "$2" -a -r "$2" ] && {
		cat "$2"
	} 2>/dev/null
}

nx_sys_user()
{
	nx_sys_getent 'passwd' '/etc/passwd' | ${AWK:-$(nx_cmd_awk)} -F ':' -v num="$1" "
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		{
			gsub(/(^[ \t]+$|#.*$)/, "", $0)
			if ($0) {
				if (s)
					s = s ","
				else
					s = "["
				s = s "{\x22username\x22:\x22" $1 "\x22,\x22password\x22:\x22" $2 "\x22,\x22uid\x22:" $3 ",\x22gid\x22:" $4 ",\x22gecos\x22:\x22" $5 "\x22,\x22home\x22:\x22" $6 "\x22,\x22shell\x22:\x22" $7 "\x22}"
			}
		} END {
			nx_json(s "]", js, 2)
			print nx_json_flatten("", js, num)
			delete js
		}
	'
}

nx_sys_group()
{
	nx_sys_getent 'group' '/etc/group' | ${AWK:-$(nx_cmd_awk)} -F ':' -v num="$1" "
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		{
			gsub(/(^[ \t]+$|#.*$)/, "", $0)
			if ($0) {
				if (s)
					s = s ","
				else
					s = "["
				s = s "{\x22group\x22:\x22" $1 "\x22,\x22password\x22:\x22" $2 "\x22,\x22gid\x22:" $3 ",\x22members\x22:["
				gsub(/,/, "\x22,\x22", $4)
				s = s "\x22" $4 "\x22]}"
			}
		} END {
			nx_json(s "]", js, 2)
			print nx_json_flatten("", js, num)
			delete js
		}
	'
}

nx_sys_hosts()
{
	(
		[ "$1" = '-4' ] && {
			h='ahostsv4'
		}
		[ "$1" = '-6' ] && {
			h='ahostsv6'
		}
		[ "$1" = '-' ] && {
			h='ahostsv6'
		}
		[ -z "$h" ] && {
			h='hosts'
		} || shift
		nx_sys_getent "$h" '/etc/hosts' | ${AWK:-$(nx_cmd_awk)} -v num="$1" "
			$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
		"'
			{
				gsub(/(^[ \t]+$|#.*$)/, "", $0)
				if ($0 && ! ($1 in addr)) {
					addr[$1] = 1
					if (s)
						s = s ","
					else
						s = "["
					s = s "{\x22address\x22:\x22" $1 "\x22,\x22mappings\x22:[\x22"
					sub("[ \t]*" $1 "[ \t]*", "", $0)
					gsub(/[ \t]+/, "\x22,\x22", $0)
					s = s $0 "\x22]}"
				}
			} END {
				nx_json(s "]", js, 2)
				print nx_json_flatten("", js, num)
				delete js
				delete addr
			}
		'
	)
}

nx_sys_protocols()
{
	nx_sys_getent 'protocols' '/etc/protocols' | ${AWK:-$(nx_cmd_awk)} -v num="$1" "
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		{
			gsub(/(^[ \t]+$|#.*$)/, "", $0)
			if ($0) {
				if (s)
					s = s ","
				else
					s = "["
				s = s"{\x22protocol name\x22:\x22" $1 "\x22,\x22protocol number\x22:" $2
				if ($3)
					s = s ",\x22alias\x22:\x22" $3 "\x22}"
				else
					s = s "}"
			}
		} END {
			nx_json(s "]", js, 2)
			print nx_json_flatten("", js, num)
			delete js
			delete addr
		}
	'
}

nx_sys_services()
{
	nx_sys_getent 'services' '/etc/services' | ${AWK:-$(nx_cmd_awk)} -v num="$1" "
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		{
			gsub(/(^[ \t]+$|#.*$)/, "", $0)
			if ($0) {
				if ($1 != S) {
					if (S)
						s = s "]},"
					if (! s)
						s = "["
					S = ""
				}
				if (S) {
					s = s ",\x22" $2 "\x22"
				} else {
					S = $1
					s = s "{\x22service\x22:\x22" $1 "\x22,\x22port/protocol\x22:[\x22" $2 "\x22"
				}
			}
		} END {
			nx_json(s "]}]", js, 2)
			print nx_json_flatten("", js, num)
			delete js
		}
	'
}

nx_sys_rpc()
{
	nx_sys_getent 'rpc' '/etc/rpc' | ${AWK:-$(nx_cmd_awk)} -v num="$1" "
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		{
			gsub(/(^[ \t]+$|#.*$)/, "", $0)
			if ($0) {
				if (s)
					s = s ","
				else
					s = "["
				s = s"{\x22program name\x22:\x22" $1 "\x22,\x22program number\x22:" $2
				if ($3)
					s = s ",\x22alias\x22:\x22" $3 "\x22}"
				else
					s = s "}"
			}
		} END {
			nx_json(s "]", js, 2)
			print nx_json_flatten("", js, num)
			delete js
		}
	'
}


nx_sys_shadow()
{
	nx_sys_sudo nx_sys_getent 'shadow' '/etc/shadow' | ${AWK:-$(nx_cmd_awk)} -F ':' -v num="$1" "
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		{
			gsub(/(^[ \t]+$|#.*$)/, "", $0)
			if ($0) {
				if (s)
					s = s ","
				else
					s = "["
				s = s "{\x22username\x22:\x22" $1 "\x22,\x22encrypted password\x22:\x22" __nx_if($2 == "!*", "<nx:disabled/>", __nx_if($2 == "!", "<nx:locked/>", $2)) "\x22,\x22last password change\x22:" __nx_else($3, 0) ",\x22minimum age\x22:" __nx_else($4, 0) ",\x22maximum age\x22:"  __nx_else($5, 0) ",\x22warning period\x22:" __nx_else($6, 0) ",\x22inactive period\x22:" __nx_else($7, 0) ",\x22experation date\x22:" __nx_else($8, 0) ",\x22reserved\x22:" __nx_else($9, 0) "}"
			}
		} END {
			nx_json(s "]", js, 2)
			print nx_json_flatten("", js, num)
			delete js
		}
	'
}

nx_sys_gshadow()
{
	nx_sys_sudo nx_sys_getent 'gshadow' '/etc/gshadow' | ${AWK:-$(nx_cmd_awk)} -F ':' -v num="$1" "
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		{
			gsub(/(^[ \t]+$|#.*$)/, "", $0)
			if ($0) {
				if (s)
					s = s ","
				else
					s = "["
				s = s "{\x22username\x22:\x22" $1 "\x22,\x22encrypted password\x22:\x22" __nx_if($2 == "!*", "<nx:disabled/>", __nx_if($2 == "!", "<nx:locked/>", $2)) "\x22,\x22group administrators\x22:\x22" $3 "\x22,\x22group members\x22:\x22" $4 "\x22}"
			}
		} END {
			nx_json(s "]", js, 2)
			print nx_json_flatten("", js, num)
			delete js
		}
	'
}


nx_sys_cgroups()
{
	nx_sys_getent '' '/proc/cgroups' | ${AWK:-$(nx_cmd_awk)} -v num="$1" "
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		{
			gsub(/(^[ \t]+$|#.*$)/, "", $0)
			if ($0) {
				if (s)
					s = s ","
				else
					s = "["
				s = s "{\x22subsystem name\x22:\x22" $1 "\x22,\x22hierarchy\x22:\x22" $2 "\x22,\x22number of cgroups\x22:\x22" $3 "\x22,\x22enabled\x22:\x22" __nx_if($4 == 1, "<nx:true/>", "<nx:false/>") "\x22}"
			}
		} END {
			nx_json(s "]", js, 2)
			print nx_json_flatten("", js, num)
			delete js
		}
	'
}

