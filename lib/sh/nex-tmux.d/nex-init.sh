#nx_include NX_L:/sh/nex-tmux.sh

__nx_tmux_i_ses()
{
	nex_i_ses="${1:-posix-nexus}"
	nx_misc_shift 1
}

__nx_tmux_i_cmd()
{
	nex_i_cmd="${1:-${0#-}}"
	nx_misc_shift 1
}

__nx_tmux_i_dir()
{
	tmpa="$(nx_data_dir "${1:-$HOME}")"
	test -n "$tmpa" && {
		nex_i_dir="${1:-${0#-}}"
	}
	nx_misc_shift 1
}

__nx_tmux_i_grp()
{
	nex_i_grp="${1:-nx0}"
	nx_misc_shift 1
}

__nx_tmux_i_win()
{
	nex_i_win="${1:-nex0}"
	nx_misc_shift 1
}

__nx_tmux_init_new()
{
	test -n "$TMUX" && {
		tmux kill-session
		unset TMUX
	}
	tmux new-session \
		-n "$nex_i_name" \
		-t "$nex_i_grp" \
		-s "$nex_i_ses" \
		-d "$nex_i_dir" -- $nex_i_cmd
}

__nx_tmux_init()
{
	while :; do
		case "$1" in
			.) {
				nx_misc_shift 1
				return
			};;
			*) {
				test -n "$nx_flg" && __nx_tmux_init_new
				return 0
			};;
		esac
		test "$#" -eq 0 && return
		nx_flg=""
		shift
	done
}

