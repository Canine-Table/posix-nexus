function nx_get_package_list(D1, D2,	v, l)
{
	if (D1 != "" && D2 != "") {
		nx_uniq_vector(D2, v, " ", 1)
		if (D1 == "pacman")
			l = nx_get_pacman_list(v)
		else if (D1 == "port")
			l = nx_get_port_list(v)
		else if (D1 == "apt")
			l = nx_get_apt_list(v)
		else if (D1 == "zypper")
			l = nx_get_zypper_list(v)
		else if (D1 ~ /^(dnf|yum)$/)
			l = nx_get_yum_list(v)
		else if (D1 == "pkg")
			l = nx_get_pkg_list(v)
		else if (D1 == "brew")
			l = nx_get_brew_list(v)
		else if (D1 == "emerge")
			l = nx_get_emerge_list(v)
		else if (D1 ~ /^(yay|pacaur|aurutils|trizen|pikaur|paru)$/)
			l = nx_get_aur_list(v)
		delete v
		if (! l)
			return
		nx_uniq_vector(l, v)
		return nx_tostring_vector(v, " ", 1, "")
	}
}

function nx_get_list(V1, V2,	s, i)
{
	for (i = 1; i <= V1[0]; i++) {
		if (V1[i] in V2) {
			s = nx_join_str(s, V2[V1[i]], ",")
		}
	}
	delete V2
	return s
}

function nx_get_aur_list(V,		v)
{
	v["z80pack"] = "zasm-git mame-git simh-git"
	return nx_get_list(V, v)
}

function nx_get_pacman_list(V,		v)
{
	v["nfs"] = "nfs-utils gvfs-nfs nfsidmap libnfs mkinitcpio-nfs-utils"
	return nx_get_list(V, v)
}

function nx_get_pkg_list(V,	v)
{
	return nx_get_list(V, v)
}

function nx_get_brew_list(V,	v)
{
	v["z80pack"] = "mame"
	return nx_get_list(V, v)
}

function nx_get_emerge_list(V,		v)
{
	return nx_get_list(V, v)
}

function nx_get_zypper_list(V,		v)
{
	return nx_get_list(V, v)
}

function nx_get_yum_list(V,	v)
{
	return nx_get_list(V, v)
}

function nx_get_port_list(V,	v)
{
	return nx_get_list(V, v)
}

function nx_get_apt_list(V,	v)
{
	v["z80pack"] = "mame"
	return nx_get_list(V, v)
}

