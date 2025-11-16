
nx_daemon_init()
(
	__nx_daemon_init_$(nx_info_path -b /usr/sbin/init) $@
)

__nx_daemon_init_systemd_reset()
{
	systemctl daemon-reload
	systemctl reset-failed
}

__nx_daemon_init_systemd_ctl()
{
	systemctl "$1" "$2"
}

__nx_daemon_init_systemd_state()
{
	tmpa="$2"
	__nx_daemon_init_systemd_ctl "$1" "$tmpa"
	tmpb="$?"
}

__nx_daemon_init_systemd()
{
	while test "$#" -gt 0; do
		case "$1" in
			-j) {
				if test "$tmpb" != '0'; then
					journalctl -xeu "$tmpa"
				else
					journalctl -xe -f
				fi
			};;
			-r) {
				__nx_daemon_init_systemd_reset
				__nx_daemon_init_systemd_state restart "$2"
				shift
			};;
			-b) {
				__nx_daemon_init_systemd_reset
				__nx_daemon_init_systemd_state start "$2"
				shift
			};;
			-e) {
				__nx_daemon_init_systemd_state stop "$2"
				shift
			};;
			-s) {
				__nx_daemon_init_systemd_state status $2 && shift
				tmpb='0'
			};;
		esac
		shift
	done
}
