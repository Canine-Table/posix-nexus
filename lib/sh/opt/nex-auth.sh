
nx_auth_ss_inspect()
{
	h_nx_cmd busctl && busctl --user introspect org.freedesktop.secrets /org/freedesktop/secrets
}
