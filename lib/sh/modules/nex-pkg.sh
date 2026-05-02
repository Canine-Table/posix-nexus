
__nx_pkg_one()
{
	__nx_pkg_$tmpa "$sudoer" "$tmpa" "$1" "$2"
}

__nx_pkg_two()
{
	__nx_pkg_$tmpa "$sudoer" "$tmpa" "$1" "$2"
	__nx_pkg_$tmpb "$sudoer" "$tmpb" "$1" "$2"
}

__nx_pkg_three()
{
	__nx_pkg_$tmpb "$sudoer" "$tmpb" "$1" "$2"
}

nx_pkg()
(
	sudoer="$(nx_cmd_sudo)"
	if tmpa="$(nx_cmd_aurmgr | _g_nx_cmd_nm_)"; then
		tmpb="$(nx_cmd_pkgmgr | _g_nx_cmd_nm_)"
	else
		tmpa="$(nx_cmd_pkgmgr | _g_nx_cmd_nm_)"
	fi

	test -n "$tmpa" || {
		nx_tty_print -E "could not find a system package manager that we support, please review the list of commands within the nx_cmd_aurmgr and nx_cmd_pkgmgr functions within the '$NEXUS_ENV/sh/nex-cmd.sh' file."
		exit 226
	}

	$sudoer printf '' || {
		nx_tty_print -E 'permission denied to use the nx_pkg tool, super user access required.'
		exit 227
	}

	test -n "$tmpb" && tpl='__nx_pkg_two' || tpl='__nx_pkg_one'

	__nx_tty_div --double
	while test "$#" -gt 1; do
		$tpl "$1" "$2" && shift 2 || shift
	done

	test "$#" -eq 1 && $tpl "$1"
)

__nx_pkg_pacman()
{
	case "$3" in
		--not-aur|-A) {
			tpl='__nx_pkg_one'
			return 196
		};;
		--aur|-a) {
			test -n "$tmpb" && tpl='__nx_pkg_three'
			return 196
		};;
		--list|-Ss) {
			$1 $2 -Ss "$4" 2>/dev/null | sed '/^[[:space:]]/d;s/[[:space:]].*$//g;s/^[[:alnum:]]*[[:punct:]]//' | tr '\n' ' '
			__nx_tty_div --double
		};;
	esac
	true
}

__nx_pkg_apk()
{
	:
}

__nx_pkg_port()
{
	:
}

__nx_pkg_apt()
{
	:
}

__nx_pkg_zypper()
{
	:
}


__nx_pkg_yum()
{
	:
}

__nx_pkg_dnf()
{
	__nx_pkg_yum "$1" "$2" "$3" "$4"
}

__nx_pkg_brew()
{
	:
}

__nx_pkg_emerge()
{
	:
}

__nx_pkg_yay()
{
	__nx_pkg_pacman "" "$2" "$3" "$4"
}

__nx_pkg_pacaur()
{
	:
}

__nx_pkg_aurutils()
{
	:
}

__nx_pkg_trizen()
{
	:
}

__nx_pkg_pikaur()
{
	:
}

__nx_pkg_paru()
{
	:
}

