
function fish_prompt
	set_color normal
	echo

	# Top line
	echo -n (set_color brwhite)"┌──"(set_color normal)

	# [user]
	echo -n (set_color -u brwhite)"["(whoami)"]"(set_color normal)

	if set -q VIRTUAL_ENV
		set venv_name (basename $VIRTUAL_ENV)
		echo -n (set_color -u brblue)"($venv_name)"(set_color normal)
	end

	if test -f /etc/debian_chroot
		set chroot_name (cat /etc/debian_chroot)
		echo -n (set_color -u brred)"($chroot_name)"(set_color normal)
	end

	if test -f /.dockerenv
		echo -n (set_color -u brmagenta)"(docker)"(set_color normal)
	end

	if set -q G_NEX_NS
		echo -n (set_color -u brcyan)"($G_NEX_NS)"(set_color normal)
	end

	# {@}
	echo -n (set_color -u brmagenta)"{@}"(set_color normal)

	# [hostname]
	echo -n (set_color -u brgreen)"["(hostname)"]"(set_color normal)

	# (time)
	echo -n (set_color -u brred)"("(date "+%H:%M")")"(set_color normal)

	# [history]
	echo -n (set_color -u bryellow)"["(history --max=1 | wc -l)"]"(set_color normal)

	# (cwd)
	echo -n (set_color -u brcyan)"["(prompt_pwd)"]"(set_color normal)

	echo
	echo "│"
	echo -n '└$ '
end




#set -g fish_complete_path /my/repo/fish/completions $fish_complete_path



