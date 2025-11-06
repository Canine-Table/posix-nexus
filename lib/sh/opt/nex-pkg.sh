
__nx_pkg_mgr()
{
	tmpb="$(nx_info_path -b "$(nx_cmd_aur_mgr)")"
	test "$(id -u)" -eq 0 && tmpd="" || tmpd="$(nx_info_path -b "$(nx_cmd_sudo)")"
	case "$tmpb" in
		yay|pacaur|aurutils|trizen|pikaur|paru);;
		*) tmpb="";;
	esac
	tmpa="$(nx_info_path -b "$(nx_cmd_pkgmgr)")"
	case "$tmpa" in
		pacman|apk|port|apt|zypper|dnf|yum|pkg|brew|emerge);;
		*) test -n "$tmpb" && tmpa="$tmpb" || {
			nx_io_printf -E "You may be on some esoteric operating system, We lacked the foresight to include your package manager :(" 2>&1
			exit 192
		};;
	esac
}

nx_pkg_mgr()
(
	__nx_pkg_mgr || exit
	tmpc="$tmpd${tmpd:+ }$tmpa"
	test -n "$tmpb" || tmpb="$tmpc"
	while test "$#" -gt 0; do
		case "$1" in
			-a|--aur) tmpc="$tmpb";;
			-p|--pkg) tmpc="$tmpd${tmpd:+ }$tmpa";;
			-s|--sync|-r|--refresh) __nx_pkg_mgr_$tmpc $1;;
			-q|--qry) {
				__nx_pkg_mgr_$tmpc $1 "$2"
				shift
			};;
		esac
		shift
	done
)
####### PKG ####### PKG ####### PKG ####### PKG #######
__nx_pkg_mgr_pacman()
{
	case "$1" in
		-s|--sync) $tmpc -Syu;;
		-r|--refresh) $tmpc -Syyu;;
		*) return 1;;
	esac
}

__nx_pkg_mgr_apk()
{
	nx_io_printf -A "One day maybe $tmpa" 2>&1
}

__nx_pkg_mgr_port()
{
	nx_io_printf -A "One day maybe $tmpa" 2>&1
}

__nx_pkg_mgr_zypper()
{
	nx_io_printf -A "One day maybe $tmpa" 2>&1
}

__nx_pkg_mgr_apt()
{
	nx_io_printf -A "One day maybe $tmpa" 2>&1
}

__nx_pkg_mgr_dnf()
{
	nx_io_printf -A "One day maybe $tmpa" 2>&1
}

__nx_pkg_mgr_yum()
{
	nx_io_printf -A "One day maybe $tmpa" 2>&1
}

__nx_pkg_mgr_pkg()
{
	nx_io_printf -A "One day maybe $tmpa" 2>&1
}

__nx_pkg_mgr_brew()
{
	nx_io_printf -A "One day maybe $tmpa" 2>&1
}

__nx_pkg_mgr_emerge()
{
	nx_io_printf -A "One day maybe $tmpa" 2>&1
}

####### AUR ####### AUR ####### AUR ####### AUR #######
__nx_pkg_mgr_yay()
{
	nx_io_printf -A "One day maybe $tmpa" 2>&1
}

__nx_pkg_mgr_pacaur()
{
	nx_io_printf -A "One day maybe $tmpa" 2>&1
}

__nx_pkg_mgr_aurutils()
{
	nx_io_printf -A "One day maybe $tmpa" 2>&1
}

__nx_pkg_mgr_trizen()
{
	nx_io_printf -A "One day maybe $tmpa" 2>&1
}

__nx_pkg_mgr_pikaur()
{
	nx_io_printf -A "One day maybe $tmpa" 2>&1
}

__nx_pkg_mgr_paru()
{
	nx_io_printf -A "One day maybe $tmpa" 2>&1
}

