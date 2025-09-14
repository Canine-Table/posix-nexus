
nx_gpg_reset()
{
	h_nx_cmd gpgcnf gpg-agent || return
	gpgconf --kill gpg-agent
	gpgconf --launch gpg-agent
}

