

nx_dbus_send_fdtp()
{
	h_nx_cmd dbus-send && dbus-send --session --dest=org.freedesktop.DBus \
		--type=method_call --print-reply \
		/org/freedesktop/DBus org.freedesktop.DBus.ListNames
}

