
nx_tmux_export()
{
	export G_NEX_TMUX_MULTI="$(g_nx_cmd tmux screen)"
}

nx_tmux()
{
	[ ${#@} -gt 0 ] && {
		case "$1" in
			'-nw')
				{
					if [ "$2" = '1' ]; then
						shift
						tmux new-window -c "#{pane_current_path}"
					else
						tmux new-window
					fi
				};;
			'-fw')
				{
					tmux next-window
				};;
			'-bw')
				{
					tmux previous-window
				};;
			'-lk')
				{
					tmux previous-window
				};;
			'-ks')
				{
					tmux kill-server
				};;
			'-rl')
				{
					tmux source "$G_NEX_MOD_CNF/.tmux.conf"
				};;
			'-swv')
				{
					tmux split-window -v
				};;
			'-swh')
				{
					tmux split-window -h
				};;
		esac
		shift
		nx_tmux "$@"
	}
}

