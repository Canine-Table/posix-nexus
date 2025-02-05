#!/bin/sh

get_pkgmgr()
{
	[ -n "$PKGMGR" ] && (
		#	-u: Update and upgrade all packages
		#	-q: Query package information
		#	-s: Search the database
		#	-i: Install a package
		#	-r: Remove a package
		#	-c: Clean the cache
		TTY_DIV=$(add_str_div)
		PKGMGR=$(get_content_leaf $PKGMGR)
		while getopts :s:i:r:q:uc OPT; do
			case $OPT in
				s|i|r|q|u|c) eval "$OPT"="'${OPTARG:-true}'";;
			esac
		done
		shift $((OPTIND - 1))
		echo $TTY_DIV
		__set_pkgmgr ${s:+s} ${q:+q} ${i:+i} ${r:+r} ${u:+u} ${c:+c}
	)
}

__set_pkgmgr()
{
	[ ${#@} -gt 0 ] && {
		V="$(get_struct_ref $1)"
		[ "${V:-false}" = true ] && {
			case $1 in
				u|c) V="";;
			esac
		}
		__get_pkgmgr_$PKGMGR $1
		$PKGMGR $K $V
		echo $TTY_DIV
		shift
		__set_pkgmgr $@
	}
}

__get_pkgmgr_pacman()
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

__get_pkgmgr_apk()
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

__get_pkgmgr_apt()
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

__get_pkgmgr_zypper()
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


__get_pkgmgr_yum()
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

__get_pkgmgr_emerge()
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

alias get_pkgmgr_dnf=get_pkgmgr_yum
alias get_pkgmgr_apt-get=get_pkgmgr_apt

