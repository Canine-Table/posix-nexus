#!/bin/sh

g_nx_pkgmgr()
{
	[ -n "$@" ] && (
		packs="$(
			mgr="$(nx_content_leaf "${PKGMGR:-$(nx_cmd_pkgmgr)}")"
			[ "$mgr" = 'pacman' -a "$(whoami)" != 'root' ] && {
				mgr="$(nx_content_leaf "$(nx_cmd_aurmgr)")"
			}
			${AWK:-$(nx_cmd_awk)} \
				-v pkg="$*" \
				-v mgr="$mgr" "
				$(cat \
					"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
					"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
					"$G_NEX_MOD_LIB/awk/nex-str.awk" \
					"$G_NEX_MOD_LIB/awk/nex-math.awk" \
					"$G_NEX_MOD_LIB/awk/nex-pkgmgr.awk"
				)
			"'
				BEGIN {
					print nx_get_package_list(mgr, pkg)
				}
			'
		)"
		[ -n "$packs" ] && nx_pkgmgr -i "$packs"
	)
}

nx_pkgmgr()
{
	[ -n "$PKGMGR" ] && (
		#	-u: Update and upgrade all packages
		#	-q: Query package information
		#	-s: Search the database
		#	-i: Install a package
		#	-r: Remove a package
		#	-c: Clean the cache
		TTY_DIV=$(nx_str_div)
		PKGMGR=$(nx_content_leaf $PKGMGR)
		[ "$PKGMGR" = 'pacman' -a "$(whoami)" != 'root' ] && {
			PKGMGR="$(nx_content_leaf "$(nx_cmd_aurmgr)")"
		}
		while getopts :s:i:r:q:uc OPT; do
			case $OPT in
				s|i|r|q|u|c) eval "$OPT"="'${OPTARG:-true}'";;
			esac
		done
		shift $((OPTIND - 1))
		echo $TTY_DIV
		__nx_set_pkgmgr ${s:+s} ${q:+q} ${i:+i} ${r:+r} ${u:+u} ${c:+c}
	)
}

__nx_set_pkgmgr()
{
	[ ${#@} -gt 0 ] && {
		V="$(nx_struct_ref $1)"
		[ "${V:-false}" = true ] && {
			case $1 in
				u|c) V="";;
			esac
		}
		__nx_pkgmgr_$PKGMGR $1
		$PKGMGR $K $V
		echo $TTY_DIV
		shift
		__nx_set_pkgmgr $@
	}
}

__nx_pkgmgr_pacman()
{
	case $1 in
		q) K='-Si';;
		u) K='-Syu';;
		s) K='-Ss';;
		r) K='-Rns';;
		i) K='-S';;
		c) K='-Scc';;
	esac
}

__nx_pkgmgr_apk()
{
	case $1 in
		s) K='search';;
		q) K='info';;
		u) K="update && $PKGMGR upgrade";;
		r) K='del';;
		i) K='add';;
		c) K='cache clean';;
	esac
}

__nx_pkgmgr_apt()
{
	case $1 in
		s) K='search';;
		q) K='cache show';;
		u) K="update && $PKGMGR upgrade";;
		r) K='remove';;
		i) K='install';;
		c) K='get clean';;
	esac
}

__nx_pkgmgr_zypper()
{
	case $1 in
		s) K='search';;
		q) K='info';;
		u) K="refresh && $PKGMGR update";;
		r) K='remove';;
		i) K='install';;
		c) K='clean -a';;
	esac
}

__nx_pkgmgr_yum()
{
	case $1 in
		s) K='search';;
		q) K='info';;
		u) K="update && $PKGMGR upgrade -y";;
		r) K='remove';;
		i) K='install';;
		c) K='clean all';;
	esac
}

__nx_pkgmgr_emerge()
{
	case $1 in
		s) K='--search';;
		q) K='--info';;
		u) K='--update --deep --with-bdeps=y @world';;
		r) K='--unmerge';;
		i) K='--ask n --quiet-build';;
		c) K='--depclean';;
	esac
}

__nx_pkgmgr_pkg()
{
    case $1 in
	s) K='search';;
	q) K='info';;
	u) K="update && $PKGMGR upgrade";;
	r) K='delete';;
	i) K='install';;
	c) K='clean';;
    esac
}

__nx_pkgmgr_brew()
{
	case $1 in
		s) K='search';;
		q) K='info';;
		u) K="update && $PKGMGR upgrade";;
		r) K='uninstall';;
		i) K='install';;
		c) K='cleanup';;
	esac
}

__nx_pkgmgr_port()
{
	case $1 in
		s) K='search';;
		q) K='info';;
		u) K="selfupdate && $PKGMGR upgrade outdated";;
		r) K='uninstall';;
		i) K='install';;
		c) K='clean --all';;
	esac
}

_nx_pkgmgr_dnf()
{
	__nx_pkgmgr_yum "$@"
}

__nx_pkgmgr_yay()
{
	__nx_pkgmgr_pacman "$@"
}
__nx_pkgmgr_paru()
{
	__nx_pkgmgr_pacman "$@"
}

__nx_pkgmgr_aurutils()
{
	__nx_pkgmgr_pacman "$@"
}

__nx_pkgmgr_trizen()
{
	__nx_pkgmgr_pacman "$@"
}

__nx_pkgmgr_pikaur()
{
	__nx_pkgmgr_pacman "$@"
}


