
nx_gpg_full()
{
	h_nx_cmd gpg || {
		nx_io_printf -E "gpg not found! The cryptographic forge is sealed—no keys shall be conjured, no secrets bound." 1>&2
		return 192
	}
	gpg --full-generate --expert
}

nx_gpg_fetch()
{
	nx_str_look \
		-c 'gpg --list-keys' \
		-r ".*$1.*@.*$2.*" \
		-s 1 -e 1 | ${AWK:-$(nx_cmd_awk)} '/<.*('"$1"'.*)?@('"$2"'.*)?.*>/{sub(/.*</,"", $NF); sub(/>.*/,"", $NF); if ($NF !~ /^([ \t\n\v]+|)$/) {print $NF; exit}}'
}

nx_gpg_keygrip()
{
	nx_str_look \
		-c 'gpg --list-keys --with-keygrip' \
		-r "$*" \
		-u -s 1 -b 1 -e 1 | ${AWK:-$(nx_cmd_awk)} '/Keygrip[ \t+]=[ \t]+/{print $NF}'
}

nx_gpg_id()
{
	nx_str_look \
		-c 'gpg --list-keys' \
		-r "$1" \
		-u -s 1 -b 1 -e 1 | ${AWK:-$(nx_cmd_awk)} '{print $NF}'
}

nx_gpg_del()
{
	tmpc="$(nx_gpg_fetch "$1" "$2")"
	test -n "$tmpc" && {
		nx_io_printf -W "$tmpc is about to be deleted!"
		gpg --delete-key "$tmpc"
		gpg --delete-secret-key "$tmpc"
	}
}

nx_gpg_armor_export()
(
	eval "$(nx_str_optarg ':u:h:sad' "$@")"
	tmpa="$(nx_gpg_id "$(nx_gpg_fetch "$u" "$h")")" && {
		if test "$a" = '<nx:true/>'; then
			nx_io_printf -I 'ssh mode active' 1>&2
			gpg --armor --export-ssh-secret-key "$tmpa"
		else
			gpg --armor --export${s:+-secret-keys} "$tmpa" | (test -n "$d" && gpg --dearmor || tee)
		fi
	}
)

nx_gpg_list_keys()
{
	h_nx_cmd gpg tty || {
		nx_io_printf -E "gpg not found! The cryptographic forge is sealed—no keys shall be conjured, no secrets bound." 1>&2
		return 192
	}
	gpg --list-${1:+secret-}keys --keyid-format LONG
}

nx_gpg_ssh_agent()
{
	h_nx_cmd gpg tty gpgconf || {
		nx_io_printf -E "gpg not found! The cryptographic forge is sealed—no keys shall be conjured, no secrets bound." 1>&2
		return 192
	}
	gpgconf --kill gpg-agent
	gpgconf --launch gpg-agent
	mkdir -p "$HOME/.gnupg/" || {
		nx_io_printf -E "Failed to prepare the cryptographic altar at '$HOME/.gnupg/'. No directory, no daemon, no invocation." 1>&2
		return 2
	}
	grep -q 'enable-ssh-support' "$HOME/.gnupg/gpg-agent.conf" || {
		printf '\n%s\n' 'enable-ssh-support' >> "$HOME/.gnupg/gpg-agent.conf"
	}
	export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
	export GPG_AGENT_SOCK="$(gpgconf --list-dirs agent-socket)"
	export GPG_TTY="$(tty)"
	gpg-connect-agent updatestartuptty /bye >/dev/null
	tmpa="$(nx_str_look \
		-c 'gpg --list-keys --with-keygrip' \
		-r "$1" \
		-u -s 1 -b 1 -e 1 | ${AWK:-$(nx_cmd_awk)} '/Keygrip[ \t+]=[ \t]+/{print $NF}')"
	test -n "$tmpa" || {
		nx_io_printf -E "No keygrip found for '$1'. The cryptographic scroll is blank—no grip, no glyph, no export." 1>&2
		return 2
	} && {
		gpg-connect-agent 'keyinfo --list' /bye | grep -q "$tmpa" || {
			nx_io_printf -W "Keygrip '$tmpa' not bound to ssh-agent. The daemon awaits your offering—bind or be forgotten." 1>&2
		}
		grep -q "$tmpa" "$HOME/.gnupg/sshcontrol" || {
			printf '\n%s\n' "$tmpa" >> "$HOME/.gnupg/sshcontrol"
		}
		gpg --export-ssh-key $(nx_str_look \
			-c 'gpg --list-secret-keys' \
			-r "$1" \
			-u -s 1 -b 1 -e 1) || {
			nx_io_printf -E "Failed to export SSH key! The scroll remains sealed—no public glyph, no transmission." 1>&2
			return 3
		}
		gpg-connect-agent reloadagent /bye
	}
}

