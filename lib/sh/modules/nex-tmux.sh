#nx_include nex-tmux.d/nex-init.sh
#nx_include nex-tmux.d/nex-window.sh
#nx_include nex-tmux.d/nex-pane.sh
#nx_include nex-tmux.d/nex-key.sh
#nx_include nex-tmux.d/nex-pane.sh
#nx_include nex-tmux.d/nex-client.sh

nx_tmux()
(
	test -n "$TMUX" || {
		nex_i_ses='posix-nexus'
		nex_i_cmd="${0#-}"
		nex_i_grp='nx0'
		nex_i_win='nex0'
		nex_i_dir="$HOME"
	}
	__nx_tmux "$@"
)

#new-session

__nx_tmux()
{
	while test "$#" -gt 0; do
		nx_flg="$1"
		shift
		nx_shft=0
		case "$nx_flg" in
			-i|i|--init|init) {
				__nx_tmux_log "$@"
			};;
			-s|s|--session|session) {
				__nx_tmux_remote "$@"
			};;
			-w|w|--window|window) {
				__nx_tmux_commit "$@"
			};;
			-p|p|--pane|pane) {
				__nx_tmux_config "$@"
			};;
			-c|c|--client|client) {
				__nx_tmux_config "$@"
			};;
			-k|k|--key|key) {
				__nx_tmux_config "$@"
			};;
			.) return;;
			-h|h|--help|help) {
				nx_tty_print \
					-i 'Usage: nx_tmux [sub-command] [options]\n\n' \
					-s '-i | i | --init | init\n' \
					-i '    Initialize tmux environment (logging, bootstrap)\n\n' \
					-w '-s | s | --session | session\n' \
					-i '    Manage sessions (create, attach, list)\n\n' \
					-w '-w | w | --window | window\n' \
					-i '    Manage windows (create, split, navigate)\n\n' \
					-w '-p | p | --pane | pane\n' \
					-i '    Manage panes (split, resize, move)\n\n' \
					-m '-c | c | --client | client\n' \
					-i '    Manage client connections (attach, detach)\n\n' \
					-m '-k | k | --key | key\n' \
					-i '    Manage key bindings (set, unset, list)\n\n' \
					-c -R \
					-i 'Color legend:\n' \
					-s '    [green]   initialization / bootstrap\n' \
					-w '    [yellow]  session, window, pane management\n' \
					-w '    [magenta]  client and key binding management\n' \
				2>&1 | ${PAGER:-tee}
			};;
		esac
		test "$nx_shft" -gt 0 && shift "$nx_shft"
	done
}

