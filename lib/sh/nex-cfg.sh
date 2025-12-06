#nx_include nex-fs.sh
#nx_include nex-data.sh
#nx_include nex-io.sh
#nx_include nex-tty.sh

nx_cfg_export()
{
	nx_cfg_dirs || return


	test -f "${NEXUS_CNF}/.nex-rc" -a -r "${NEXUS_CNF}/.nex-rc" -a -z "$ENV" && {
		export ENV="${NEXUS_CNF}/.nex-rc"
		nx_tty_print -i "exporting ENV as $ENV\n"
	}

	nx_cfg_path
	nx_cfg_login

	export LS_COLORS='rs=0:di=1;93:ln=01;96:mh=44;38;5;15:pi=40;38;5;11:so=38;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5;9:mi=05;48;5;232;38;5;15:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;5;196;38;5;226:tw=48;5;10;38;5;16:ow=01;103;30:st=01;92:ex=38;5;34:*.tar=38;5;9:*.tgz=38;5;9:*.arc=38;5;9:*.arj=38;5;9:*.taz=38;5;9:*.lha=38;5;9:*.lz4=38;5;9:*.lzh=38;5;9:*.lzma=38;5;9:*.tlz=38;5;9:*.txz=38;5;9:*.tzo=38;5;9:*.t7z=38;5;9:*.zip=38;5;9:*.z=38;5;9:*.Z=38;5;9:*.dz=38;5;9:*.gz=38;5;9:*.lrz=38;5;9:*.lz=38;5;9:*.lzo=38;5;9:*.xz=38;5;9:*.bz2=38;5;9:*.bz=38;5;9:*.tbz=38;5;9:*.tbz2=38;5;9:*.tz=38;5;9:*.deb=38;5;9:*.rpm=38;5;9:*.jar=38;5;9:*.war=38;5;9:*.ear=38;5;9:*.sar=38;5;9:*.rar=38;5;9:*.alz=38;5;9:*.ace=38;5;9:*.zoo=38;5;9:*.cpio=38;5;9:*.7z=38;5;9:*.rz=38;5;9:*.cab=38;5;9:*.jpg=38;5;13:*.jpeg=38;5;13:*.gif=38;5;13:*.bmp=38;5;13:*.pbm=38;5;13:*.pgm=38;5;13:*.ppm=38;5;13:*.tga=38;5;13:*.xbm=38;5;13:*.xpm=38;5;13:*.tif=38;5;13:*.tiff=38;5;13:*.png=38;5;13:*.svg=38;5;13:*.svgz=38;5;13:*.mng=38;5;13:*.pcx=38;5;13:*.mov=38;5;13:*.mpg=38;5;13:*.mpeg=38;5;13:*.m2v=38;5;13:*.mkv=38;5;13:*.webm=38;5;13:*.ogm=38;5;13:*.mp4=38;5;13:*.m4v=38;5;13:*.mp4v=38;5;13:*.vob=38;5;13:*.qt=38;5;13:*.nuv=38;5;13:*.wmv=38;5;13:*.asf=38;5;13:*.rm=38;5;13:*.rmvb=38;5;13:*.flc=38;5;13:*.avi=38;5;13:*.fli=38;5;13:*.flv=38;5;13:*.gl=38;5;13:*.dl=38;5;13:*.xcf=38;5;13:*.xwd=38;5;13:*.yuv=38;5;13:*.cgm=38;5;13:*.emf=38;5;13:*.axv=38;5;13:*.anx=38;5;13:*.ogv=38;5;13:*.ogx=38;5;13:*.aac=38;5;45:*.au=38;5;45:*.flac=38;5;45:*.mid=38;5;45:*.midi=38;5;45:*.mka=38;5;45:*.mp3=38;5;45:*.mpc=38;5;45:*.ogg=38;5;45:*.ra=38;5;45:*.wav=38;5;45:*.axa=38;5;45:*.oga=38;5;45:*.spx=38;5;45:*.xspf=38;5;45:fi=01;97:'
	for tmpa in "${NEXUS_CNF}/nex-export.cnf" "${NEXUS_CNF}/nex-alias.cnf"; do
		test -f "$tmpa" -a -r "$tmpa" && {
			nx_tty_print -i "exporting $tmpa\n"
			. "$tmpa"
		}
	done
	nx_cfg_ps1
	nx_cfg_gcc
	unset tmpa
}

nx_cfg_gcc()
{
	test -n "$G_NEX_CC" -a "$(nx_fs_path -b "$G_NEX_CC")" = 'gcc' && export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
}


nx_cfg_banner()
(
	test -d "$NEXUS_CNF/banner" || exit 72
	eval "export $(nx_tty_all)"
	if nx_int_range -g 64 -v "$G_NEX_TTY_COLUMNS"; then
		if nx_int_range -g 288 -v "$G_NEX_TTY_COLUMNS"; then
			G_NEX_TTY_COLUMNS=288
		elif nx_int_range -g 256 -v "$G_NEX_TTY_COLUMNS"; then
			G_NEX_TTY_COLUMNS=256
		elif nx_int_range -g 224 -v "$G_NEX_TTY_COLUMNS"; then
			G_NEX_TTY_COLUMNS=224
		elif nx_int_range -g 196 -v "$G_NEX_TTY_COLUMNS"; then
			G_NEX_TTY_COLUMNS=196
		elif nx_int_range -g 160 -v "$G_NEX_TTY_COLUMNS"; then
			G_NEX_TTY_COLUMNS=160
		elif nx_int_range -g 128 -v "$G_NEX_TTY_COLUMNS"; then
			G_NEX_TTY_COLUMNS=128
		elif nx_int_range -g 96 -v "$G_NEX_TTY_COLUMNS"; then
			G_NEX_TTY_COLUMNS=96
		else
			G_NEX_TTY_COLUMNS=64
		fi
		G_NEX_TTY_COLUMNS="$NEXUS_CNF/banner/banner${G_NEX_TTY_COLUMNS}.txt"
		test -f "$G_NEX_TTY_COLUMNS" -a -r "$G_NEX_TTY_COLUMNS" && nx_tty_print -c -R -e "\n$(cat "$G_NEX_TTY_COLUMNS")\n"
	fi
)

nx_cfg_path()
{
	PATH="$(nx_data_path_append -v PATH -s ':' \
		"/bin" \
		"/sbin" \
		"/usr/bin"\
		"/usr/sbin"\
		"/usr/local/bin" \
		"/usr/local/sbin" \
		"$HOME/.local/bin" \
		"$HOME/.local/sbin" \
		"$NEXUS_BIN" \
		"$NEXUS_CNF" \
		"$NEXUS_SBIN"
	)"

	export PATH
}

nx_cfg_login()
{
	tmpa="/run/user/$(id -u)"
	test -d  "$tmpa" -a -r "$tmpa" && {
		export XDG_RUNTIME_DIR="$tmpa"
		export DBUS_SESSION_BUS_ADDRESS="unix:path=$tmpa/bus"
	}
}

nx_cfg_ps1()
{
	test -n "$G_NEX_MNT_CHROOT" && tmpa='chroot' || tmpa=''
	test -n "$VIRTUAL_ENV" && tmpa="$(nx_data_path_append -v tmpa -s ',' 'venv')"
	tty -s && case "${TERM}" in
		screen*|Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|tmux*|xterm*)
			{
				export PS1="$(
					printf "\n\[\e[1;37m\]┌──\[\e[m\]%s%s%s%s%s%s\[\e[1;37m\]\n│\n└\[\e[m\]$ " \
						"\[\e[4;1;37m\][$(whoami)]\[\e[m\]${tmpa:+\[\e[4;1;34m\]($tmpa)\[\e[m\]}" \
						"\[\e[4;1;35m\]{@}\[\e[m\]" \
						"\[\e[4;1;32m\][\H]\[\e[m\]" \
						"\[\e[4;1;31m\](\@)\[\e[m\]" \
						"\[\e[4;1;33m\][\!]\[\e[m\]" \
						"\[\e[4;1;36m\](\w)\[\e[m\]"
				)"
			};;
		*) export PS1="\n┌──[$(whoami)]${tmpa:+($tmpa)}{@}[\H](\@)(\w)\n│\n└$ ";;
	esac
}

nx_cfg_dirs()
(
	nx_err=0
	for tmpa in \
		"$NEXUS_BIN" \
		"$NEXUS_SBIN" \
		"$NEXUS_SRC" \
		"$NEXUS_DOC" \
		"$NEXUS_ENV"
	do
		test -z "$tmpa" && {
			nx_tty_print -e "the Nexus env has not been properly loaded, have you used the nex-bundle.sh and loaded it via your bashrc, nex-init or directly?"
			exit 2
		}
	done
	for tmpa in \
		"$NEXUS_BIN" \
		"$NEXUS_SBIN" \
		"$NEXUS_SRC" \
		"$NEXUS_DOC" \
		"$NEXUS_DOC/auxiliary" \
		"$NEXUS_DOC/pages" \
		"$NEXUS_DOC/pdfs" \
		"$NEXUS_DOC/txt" \
		"$NEXUS_ENV" \
		"$NEXUS_ENV/log" \
		"$NEXUS_ENV/proc" \
		"$NEXUS_BIN" \
		"$NEXUS_SBIN"
	do
		test -d "$tmpa" || {
			test -e "$tmpa" && nx_io_noclobber -p "$tmpa" -b -M
			mkdir -p "$tmpa" || nx_err=$((nx_err + 1))
		}
	done
	test "$nx_err" -eq 0 && exit
	nx_tty_print -w "$nx_err errors occured during directory setup."
	exit 1

)

