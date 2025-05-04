
g_nx_groups()
{
	h_nx_cmd getent && getent groups || cat /etc/group
}

g_nx_users()
{
	h_nx_cmd getent && getent passwd || cat /etc/passwd
}

