#!/usr/bin/bash
export NEXUS_ROOT="/opt/posix-nexus/"
export NEXUS_SRC="/opt/posix-nexus/src"
export NEXUS_LIB="/opt/posix-nexus/lib"
export NEXUS_ENV="/opt/posix-nexus/env"
export NEXUS_CNF="/opt/posix-nexus/cnf"
export NEXUS_DOC="/opt/posix-nexus/docs"
export NEXUS_LOG="/opt/posix-nexus/env"
export NEXUS_SBIN="/opt/posix-nexus/sbin"
export NEXUS_BIN="/opt/posix-nexus/bin"
export ENV="/opt/posix-nexus/cnf/.nex-rc"

nx_asm_export()
{
	case "$(nx_str_case -l "$(uname -m)")" in
		*'x86_64'*)
			{
				export G_NEX_ASM_ARCH='amd64'
				export G_NEX_ASM_ENDIAN='0'
				export G_NEX_ASM_BIT='64'
			};;
		'i686')
			{
				export G_NEX_ASM_ARCH='x86'
				export G_NEX_ASM_ENDIAN='0'
				export G_NEX_ASM_BIT='32'
			};;
		'armv7l')
			{
				export G_NEX_ASM_ARCH='arm'
				export G_NEX_ASM_ENDIAN='0'
				export G_NEX_ASM_BIT='32'
			};;
		'aarch64')
			{
				export G_NEX_ASM_ARCH='arm64'
				export G_NEX_ASM_ENDIAN='0'
				export G_NEX_ASM_BIT='64'
			};;
		'armv8l')
			{
				export G_NEX_ASM_ARCH='arm84'
				export G_NEX_ASM_ENDIAN='0'
				export G_NEX_ASM_BIT='64'
			};;
		'mips')
			{
				export G_NEX_ASM_ARCH='mips'
				export G_NEX_ASM_ENDIAN='1'
				export G_NEX_ASM_BIT='32'
			};;
		'mips64')
			{
				export G_NEX_ASM_ARCH='mips64'
				export G_NEX_ASM_ENDIAN='1'
				export G_NEX_ASM_BIT='64'
			};;
		'ppc')
			{
				export G_NEX_ASM_ARCH='powerpc'
				export G_NEX_ASM_ENDIAN='1'
				export G_NEX_ASM_BIT='32'
			};;
		'ppc64')
			{
				export G_NEX_ASM_ARCH='powerpc64'
				export G_NEX_ASM_ENDIAN='1'
				export G_NEX_ASM_BIT='64'
			};;
		'riscv64')
			{
				export G_NEX_ASM_ARCH='riscv'
				export G_NEX_ASM_ENDIAN='0'
				export G_NEX_ASM_BIT='64'
			};;
		*)
			{
				nx_tty_print -e "Unknown architecture: $(uname -m)"
				return 1
			};;
	esac
}

nx_bc_cmb()
(
	__nx_bc "$@" -m 'combinatorics'
)
nx_bc_fact()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'combinatorics' -c "nx_fact(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'factoral input < 0 detected!!!\n'
		exit 227
	}
)
nx_bc_ln()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'combinatorics' -c "nx_de_ln(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'ln(x) domain breach — x ≤ 0\n'
		exit 227
	}
)
nx_bc_log2()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'combinatorics' -c "nx_de_log2(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'log2(x) domain breach — x ≤ 0\n'
		exit 227
	}
)
nx_bc_fib()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'combinatorics' -c "nx_fib(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'Fibonacci sequence expects an integral number > 0\n'
		exit 227
	}
)


nx_bc_alg()
(
	__nx_bc "$@" -m 'algebra'
)
nx_bc_pow()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_alg "$@" -c "nx_erde_pow(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'pow(x, y) domain breach — x ≤ 0\n'
		exit 227
	}
)
nx_bc_sqrt()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_alg "$@" -c "nx_nr_sqrt(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'sqrt(x) domain breach — x ≤ 0\n'
		exit 227
	}
)
nx_bc_sqs()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_alg "$@" -c "nx_squares(${NEX_k_v:-$NEX_S})"
)
nx_bc_lcd()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_alg "$@" -c "nx_lcd(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'lcm(x,y) domain breach — x,y must be positive integers'
		exit 227
	}
)
nx_bc_gcd() { nx_bc_euc "$@"; }
nx_bc_euc()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_alg "$@" -c "nx_euc(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'euc(x,y) domain breach — x,y must be non‑negative integers\n'
		exit 227
	}
)
nx_bc_binom()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_alg "$@" -c "nx_binom(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'binomial(n,k) domain breach — n,k must be non‑negative integers with k ≤ n\n'
		exit 227
	}
)
nx_bc_part()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_alg "$@" -c "nx_part(${NEX_k_v:-$NEX_S})"
)
nx_bc_trunc()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_alg "$@" -c "nx_pt_trunc(${NEX_k_v:-$NEX_S})"
)
nx_bc_floor()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_alg "$@" -c "nx_pt_floor(${NEX_k_v:-$NEX_S})"
)
nx_bc_ceil()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_alg "$@" -c "nx_pt_ceil(${NEX_k_v:-$NEX_S})"
)
nx_bc_frac()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_alg "$@" -c "nx_pt_frac(${NEX_k_v:-$NEX_S})"
)
nx_bc_round()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_alg "$@" -c "nx_pt_round(${NEX_k_v:-$NEX_S})"
)
nx_bc_unround()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_alg "$@" -c "nx_pt_unround(${NEX_k_v:-$NEX_S})"
)
nx_bc_mod()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_alg "$@" -c "nx_pt_mod(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'modulo(a,b) domain breach — divisor must be non‑zero and both operands integral\n'
		exit 227
	}
)


nx_bc_geo()
(
	__nx_bc "$@" -m 'geometry'
)
nx_bc_pi()
(
	nx_data_optargs 'v:t' "$@"
	case "$(nx_data_match -o ramanujan -o rj -o leibniz -o lz "$NEX_k_v")" in
		ramanujan|rj) NEX_k_v='rj';;
		leibniz|lz) NEX_k_v='lz';;
		*) NEX_k_v='agm';;
	esac
	__nx_bc "$@" -m 'geometry' -c "nx_${NEX_k_v}_$(test "$NEX_f_t" = '<nx:true/>' && printf '%s' 'tau' || printf '%s' 'pi')()"
)
nx_bc_agm()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'geometry' -c "nx_agm(${NEX_k_v:-$NEX_S})" || {
		nx_tty_print -e 'agm(a,b) domain breach — inputs must be strictly positive reals'
		exit 227
	}
)

nx_bc_bs()
(
	__nx_bc "$@" -m 'bases'
)
nx_bc_from_dec()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'bases' -c "nx_from_dec(${NEX_k_v:-$NEX_S})" || case "$?" in
		227) {
			nx_tty_print -e 'base cannot be less than 2.\n'
			exit 227
		};;
		228) {
			nx_tty_print -e 'base cannot be greater than obase.\n'
			exit 228
		};;
	esac
)
nx_bc_rvs()
(
	nx_data_optargs 'v:' "$@"
	__nx_bc "$@" -m 'bases' -c "nx_reverse(${NEX_k_v:-$NEX_S})" || {
		exit 227
	}
)

nx_bc_ntn()
(
	__nx_bc "$@" -m 'notation'
)
nx_bc_sci()
(
	nx_data_optargs 'v:n<eE>' "$@"
	case "$NEX_g_n" in
		E) NEX_g_n=2;;
		e) NEX_g_n=1;;
		*) NEX_g_n=0;;
	esac
	nx_bc_ntn -c "nx_ntn_sci(${NEX_k_v:-$NEX_S},$NEX_g_n)" || {
		nx_tty_print -e 'scientific notation not defined for 0\n'
		exit 227
	}
)






__nx_bc()
{
	nx_return="$(
		eval "$(nx_tty_all)"
		export BC_LINE_LENGTH=$NX_TTY_COLUMNS
		nx_data_optargs 's:o:i:c:m:l' "$@"
		printf '%s' "
			scale = ${NEX_k_s:-20}
			${NEX_k_i:+ibase = $NEX_k_i}
			${NEX_k_o:+obase = $NEX_k_o}
			$(nx_data_include -i "${NEXUS_LIB}/bc/nex-${NEX_k_m:-algebra}.bc")
			${NEX_k_c:-$NEX_S}
		" | bc ${NEX_f_l:+-l} | ${AWK:-$(nx_cmd_awk)} '
			{
				if (sub(/^<nx:impurity/, "", $0) && sub(/\/>.*$/, "", $0)) {
					gsub(/[^0-9]*/, "", $0)
					if (($0 = int($0)) && $0 > 227 && $0 < 255)
						exit $0
					exit 227
				}
				print $0
			}
		' || exit $?
	)" || return $?
	test "$NEX_f_q" = '<nx:true/>' && return
	printf '%s' "$nx_return"
	test "$NEX_f_q" = '<nx:false/>' && unset nx_return
	return 0
}
nx_bc()
(
	__nx_bc "$@"
)
nx_bc_calc()
(
	__nx_bc "$@" -m 'calculus'
)
nx_bc_mc_esp()
(
	nx_data_optargs 'v:' "$@"
	nx_bc_calc "$@" -c "nx_mc_esp(${NEX_k_v:-$NEX_S})"
)
nx_bc_ts()
(
	nx_data_optargs 'v:f' "$@"
	NEX_k_v="${NEX_k_v:-$NEX_S}"
	case "$NEX_f_f" in
		'<nx:true/>') NEX_k_v="nx_ts_alt($NEX_k_v)";;
		*) NEX_k_v="nx_ts($NEX_k_v)";;
	esac
	nx_bc_calc "$@" -c "$NEX_k_v"
)
__nx_bc()
{
	nx_return="$(
		eval "$(nx_tty_all)"
		export BC_LINE_LENGTH=$NX_TTY_COLUMNS
		nx_data_optargs 's:o:i:c:m:l' "$@"
		printf '%s' "
			scale = ${NEX_k_s:-20}
			${NEX_k_i:+ibase = $NEX_k_i}
			${NEX_k_o:+obase = $NEX_k_o}
			$(nx_data_include -i "${NEXUS_LIB}/bc/nex-${NEX_k_m:-algebra}.bc")
			${NEX_k_c:-$NEX_S}
		" | bc ${NEX_f_l:+-l} | ${AWK:-$(nx_cmd_awk)} '
			{
				if (sub(/^<nx:impurity/, "", $0) && sub(/\/>.*$/, "", $0)) {
					gsub(/[^0-9]*/, "", $0)
					if (($0 = int($0)) && $0 > 227 && $0 < 255)
						exit $0
					exit 227
				}
				print $0
			}
		' || exit $?
	)" || return $?
	test "$NEX_f_q" = '<nx:true/>' && return
	printf '%s' "$nx_return"
	test "$NEX_f_q" = '<nx:false/>' && unset nx_return
	return 0
}
nx_bc()
(
	__nx_bc "$@"
)




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
	test -n "$CC" -a "$(nx_fs_path -b "$CC")" = 'gcc' && export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
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
	test -t 1 && case "${TERM}" in
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
h_nx_cmd()
{
	while test "$#" -gt 0; do
		command -v "$1" 1>/dev/null 2>&1 || return 1
		shift
	done
}
g_nx_cmd()
{
	while test "$#" -gt 0; do
		command -v "$1" && return
		shift
	done
	return 1
}
nx_cmd_pager()
{
	g_nx_cmd less more most tee
}
nx_cmd_awk()
{
	g_nx_cmd mawk nawk gawk awk
}
nx_cmd_shell()
{
	g_nx_cmd bash zsh dash sh ash mksh posh yash ksh loksh pdksh fish
}
nx_cmd_editor()
{
	g_nx_cmd vim nvim gvim vim.tiny vi
}
nx_cmd_cc()
{
	g_nx_cmd clang gcc cc
}
nx_cmd_pkgmgr()
{
	g_nx_cmd pacman apk port apt zypper dnf yum pkg brew emerge
}
nx_cmd_aurmgr()
{
	g_nx_cmd yay pacaur aurutils trizen pikaur paru
}
nx_cmd_container()
{
	g_nx_cmd podman docker-rootless docker
}
nx_cmd_sudo()
{
	g_nx_cmd doas sudo sudo-rs
}
nx_cmd_clipboard() {
	g_nx_cmd ${SSH_CLIENT:+lemonade} ${DISPLAY:+xsel xclip} ${WAYLAND_DISPLAY:+wl-copy wayclip} ${TMUX:+tmux}
}
nx_cmd_wget()
{
	g_nx_cmd curl wget
}
nx_cmd_sql()
{
	g_nx_cmd mariadb mysql
}
nx_cmd_sockets()
{
	g_nx_cmd ss netstat
}


nx_data_ref()
{
	test -n "$1" && eval "printf \$$1" 2> /dev/null
}
nx_data_ref_append()
(
	nx_data_optargs 'v:d@s:' "$@"
	NEX_k_v="$(nx_data_ref "$NEX_k_v")" || exit 65
	test -n "$NEX_k_v" -a -n "$NEX_K_d" && tmpa="${NEX_k_v}${NEX_k_s:-<nx:null/>}"
	printf '%s' "$tmpa$NEX_K_d"
)
nx_data_compare()
(
	nx_data_optargs 'l@r@m:s:c' "$@"
	${AWK:-$(nx_cmd_awk)} \
		-v lft="$NEX_K_l" \
		-v rgt="$NEX_K_r" \
		-v mde="$NEX_k_m" \
		-v sep="$NEX_k_s" \
		-v cnt="$NEX_f_c" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct-extras.awk")
	"'
		BEGIN {
			split(lft, larr, "<nx:null/>")
			nx_arr_flip(larr)
			split(rgt, rarr, "<nx:null/>")
			nx_arr_flip(rarr)
			split("", arr, "")
			nx_arr_compare(larr, rarr, arr, mde, sep, __nx_if(cnt != "<nx:true/>", 2, 3))
			delete larr
			delete rarr
			rgt = 0
			if (cnt != "<nx:true/>") {
				for (lft in arr) {
					gsub("\x27", "\\\\x27", lft)
					if (rgt++)
						printf(" \\\n\x27%s\x27", lft)
					else
						printf("\x27%s\x27", lft)
				}
				printf("; # Nex is done here!\n")
			} else {
				print arr[0]
			}
			delete arr
		}
	'
)
nx_data_optargs()
{
	eval "$(
		${AWK:-$(nx_cmd_awk)} \
			-v inpt="$(nx_str_chain "$@")" \
			"
				$(nx_data_include -i "${NEXUS_LIB}/awk/nex-sh-extras.awk")
			"'
				BEGIN {
					print nx_sh_optargs(inpt)
				}
			'
	)"
}
nx_data_dir()
{
	test -e "$1" || return 66 && {
		test -d "$1" && {
			printf '%s' "$(cd "$1" && pwd)"
			return 196
		} || {
			printf '%s' "$(cd $(dirname "$1") && pwd)"
		}
	}
}
nx_data_include()
(
	while :; do
		case "$1" in
			-t) {
				case "$2" in
					-*) {
						trm=' \\t'
					};;
					*) {
						trm="$2"
						shift
					};;
				esac
			};;
			-l) {
				lvl="$2"
				shift
			};;
			-d) {
				dir="$2"
				shift
			};;
			-s) {
				sig="$2"
				shift
			};;
			-i) {
				inpt="$2"
				shift
			};;
			-r) {
				rt="$2"
				shift
			};;
			-e) {
				ext="$2"
				shift
			};;
			*) {
				break
			};;
		esac
		shift
	done
	test -z "$inpt" && {
		inpt="$1"
		shift
	}
	rt="${rt:-$NEXUS_LIB}"
	${AWK:-$(nx_cmd_awk)} \
		-v inpt="$(nx_data_dir "$inpt")/$(basename "$inpt")" \
		-v exc="$ext" \
		-v trm="$trm" \
		-v lvl="$lvl" \
		-v sig="$sig" \
		-v dir="$dir" \
	"
		$(cat \
			"${rt}/awk/nex-misc.awk" \
			"${rt}/awk/nex-struct.awk" \
			"${rt}/awk/nex-io.awk" \
			"${rt}/awk/nex-int.awk" \
			"${rt}/awk/nex-log.awk" \
			"${rt}/awk/nex-str.awk"
		)
	"'
		BEGIN {
			nx_file_merge(inpt, exc, lvl, trm, sig, dir)
		}
	'
)
nx_data_path_append()
(
	nx_data_optargs 'v:s:' "$@"
	${AWK:-$(nx_cmd_awk)} \
		-v val="$(nx_data_ref "$NEX_k_v")" \
		-v sep="${NEX_k_s:-<nx:null/>}" \
		-v str="$NEX_R" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct.awk")
	"'
		BEGIN {
			nx_trim_split(str, strs, "<nx:null/>")
			strs["b4"] = 1
			for (i = 1; i <= strs[0]; ++i) {
				if (sub(/^-/, "", strs[i])) {
					if (strs[i] == "a")
						strs["b4"] = 0
					else
						strs["b4"] = 1
				} else if (sep val sep !~ sep strs[i] sep) {
					if (strs["b4"])
						val = nx_join_str(val, strs[i], sep)
					else
						val = nx_join_str(strs[i], val, sep)
				}
			}
			delete strs
			if (val)
				print val
			else
				exit 1
		}
	'
)
nx_data_word()
(
	nx_data_optargs 'k@p' "$@"
	${AWK:-$(nx_cmd_awk)} \
		-v str="$NEX_S" \
		-v sep="$NEX_K_k" \
		-v phdr="${NEX_f_p:+<nx:null/><nx:placeholder/>}" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct-extras.awk")
	"'
		BEGIN {
			if (! sep) {
				dlm["\x22"] = "\x22"
				dlm["\x27"] = "\x27"
				dlm["\x60"] = "\x60"
				dlm["\x09"] = ""
				dlm["\x20"] = ""
			}
			nx_find_pair(str, mth, dlm, sep __nx_only(sep, phdr))
			delete dlm
			for (i = 5; i <= mth[mth[0]]; i += mth[0]) {
				if (mth[i + 2] == "0")
					print substr(str, 1, mth[i] - 1)
				else
					print substr(str, mth[i] + mth[i + 1], mth[i + 2])
			}
			delete mth
		}
	'
)
nx_data_match()
(
	nx_data_optargs 'o@v:bli' "$@"
	${AWK:-$(nx_cmd_awk)} \
		-v str="${NEX_k_v:-$NEX_S}" \
		-v opt="$NEX_K_o" \
		-v bnd="${NEX_f_b:-'<nx:false/>'}" \
		-v ln="${NEX_f_l:-'<nx:false/>'}" \
		-v cse="${NEX_f_c:-'<nx:false/>'}" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct-extras.awk")
	"'
		BEGIN {
			nx_trim_split(opt, opts, "<nx:null/>")
			if (cse == "<nx:true/>")
				str = tolower(str)
			if ((str = nx_option(str, opts, res, bnd == "<nx:true/>", ln == "<nx:true/>")) != -1) {
				print str
				str = 0
			} else {
				str = 1
			}
			delete res
			delete opts
			exit str
		}
	'
)
nx_editor_export()
{
	export EDITOR="$(nx_cmd_editor)"
	export VISUAL="$EDITOR"
	case "$EDITOR" in
		*vim)
			{
				export VIMINIT="source ${NEXUS_LIB}/viml/nex-init.vim"
			};;
	esac
}
export E_NEX_EDITOR=true



nx_fs_canonize()
(
	nx_data_optargs 'p<:bdp>' "$@"
	case "$NEX_Gk_p" in
		b) NEX_Gk_p="";;
		d) NEX_Gk_p=1;;
		*) NEX_Gk_p=0;;
	esac
	${AWK:-$(nx_cmd_awk)} \
		-v nm="${NEX_Gl_p:-$NEX_S}" \
		-v prt="$NEX_Gk_p" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-io-extras.awk")
	"'
		BEGIN {
			print nx_file_path(nm, prt)
		}
	'
)
nx_fs_fifo()
(
        h_nx_cmd mkfifo || {
                nx_tty_print -W 'mkfifo not found! The realm of named pipes is closed to us.'
                exit 127
        }
        while test "$#" -gt 0; do
                if test "$1" = '-r' -a -p "$2"; then
                        rm "$2"
                        shift
                elif test "$1" = '-c'; then
                        tmpa=""
                        while test -z "$tmpa"; do
                                tmpa="$NEXUS_ENV/nx_$(nx_str_rand 32).fifo"
                                test -e "$tmpa" && unset tmpa
                        done
                        mkfifo "$tmpa"
                        printf '%s' "$tmpa"
                fi
                shift
        done
)
nx_fs_i_fd()
{
	case "$1" in
		-o) test -e "/proc/${3:-$$}/fd/$2" && return 1;;
		-c) test -e "/proc/${3:-$$}/fd/$2" || return 0;;
	esac
}
nx_fs_pipe()
(
	nx_data_optargs 'v:fcr' "$@"
	test "$NEX_f_f" = '<nx:true/>' && {
		test "$NEX_f_h" = '<nx:true/>' && {
			NEX_f_h='HUP'
		} || NEX_f_h=''
		trap 'nx_fs_fifo -r $NEX_f_f;' INT $NEX_f_h TERM
		NEX_f_f="$(nx_fs_fifo -c)"
		printf '%s' "$NEX_f_f"
	}
	test ! -p "$NEX_f_f" && {
                nx_tty_print -e 'fifo not provided! The realm of named pipes told us to get lost in a socket.'
		exit 2
	}
	test "$NEX_f_c" = '<nx:true/>' && {
		read -t 1 NEX_L <"$NEX_f_f" || true
		printf '%s' "$NEX_L"
	}
	test -n "$NEX_k_v" && printf '%s' "$NEX_k_v" >"$NEX_f_f" &
	test "$NEX_f_r" = '<nx:true/>' -a -p "$NEX_f_f" && nx_fs_fifo -r "$NEX_f_f"
)
nx_fs_path()
(
	nx_data_optargs 'p<:bdp>' "$@"
	tmpa="$(nx_data_dir "$NEX_Gl_p")"
	if test $? -eq 196; then
		NEX_pth_1="$tmpa"
		NEX_pth_2="$tmpa"
		NEX_pth_3="$(basename "$tmpa")"
	else
		tmpb="$(${AWK:-$(nx_cmd_awk)} \
			-v drnm="$tmpa" \
			-v nm="$NEX_Gl_p" \
			-v val="$NEX_Gk_p" \
		"
			$(nx_data_include -i "${NEXUS_LIB}/awk/nex-io-extras.awk")
		"'
			BEGIN {
				dnm = nx_file_path(drnm, 0)
				bnm = nx_file_path(nm)
				if (nx_file_store(fls, bnm, dnm) == -1)
				if (nx_file_store(fls,  nx_file_path(drnm, 1) "/" bnm) == -1) {
					nx_ansi_error("(nx_fs_path breach) file check failed: '" dnm "' (NEX_Gl_p=" nm ") either does not exist, is not readable, or is empty")
					delete fls
					exit 1
				}
				for (i = 1; i <= 3; ++i)
					printf("%s", __nx_stringify_var("NEX_pth_" i, fls[fls[i]]))
				delete fls
			}
		')" || {
			printf '%s' "$tmpb" 1>&2
			exit 1
		}
		eval "$tmpb"
	fi
	case "$NEX_Gk_p" in
		b) {
			printf '%s' "$NEX_pth_3"
		};;
		d) {
			printf '%s' "$NEX_pth_2"
		};;
		p) {
			printf '%s' "$NEX_pth_1"
		};;
	esac
)
__nx_fs_follow()
{
	printf '%s' "$tmpa" 1>&2
	exit 66
}
nx_fs_follow()
(
	nx_data_optargs 'r:' "$@"
	tmpa="$(nx_fs_path -p "$NEX_S")" || __nx_fs_follow
	nx_int_range -o -v "${NEX_k_r:-7}" -e -g 8 || NEX_f_r=16
	while test -h "$tmpa"; do
		tmpa="$(
			nx_fs_path -p "$(
				dirname "$tmpa"
			)/$(
				ls --color=never -l "$tmpa" | sed 's/^.*[\t ][ \t]*->[\t ][ \t]*//
			')"
		)"  || __nx_fs_follow
		test "$NEX_f_r" -gt 0 || {
			nx_tty_print -e 'too many redirects'
			exit 47
		} && {
			NEX_f_r=$((NEX_f_r - 1))
		}
	done
	printf '%s' "$tmpa"
)


nx_int_range()
(
	nx_data_optargs 'v@g:l:b<oa>e' "$@"
	NEX_K_v="${NEX_K_v:-$NEX_R}"
	${AWK:-$(nx_cmd_awk)} \
		-v lt="${NEX_k_l:-<nx:null/>}" \
		-v gt="${NEX_k_g:-<nx:null/>}" \
		-v bl="$NEX_g_b" \
		-v eql="$NEX_f_e" \
		-v val="$NEX_K_v" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-int-extras.awk")
	"'
		function nx_my_msg(D1, D2) {
				nx_ansi_warning("the passed " D1 " value \x27" D2 "\x27 is not a valid number in base 10, skipping...\n")
		}
		BEGIN {
			if ((val = nx_digit_guard(val, 1, 1, "<nx:null/>", 2, "", arr)) < 0)
				exit val
			if (gt != "<nx:null/>" && (gtv = int(gt)) != gt)
				nx_my_msg("(-g) greater than", gt)
			if (lt != "<nx:null/>" && (ltv = int(lt)) != lt)
				nx_my_msg("(-l) less than", lt)
			do {
				val = int(arr[arr[0]])
				if (val != arr[arr[0]])
					break
				if (eql == "<nx:true/>") {
					if (bl == "a") {
						if (val < gtv || val > ltv)
							break
					} else {
						if (gt != "" && gtv == gt && val < gtv)
							break
						if (lt != "" && ltv == lt && val > ltv)
							break
					}
				} else {
					if (bl == "a") {
						if (val <= gtv || val >= ltv)
							break
					} else {
						if (gt != "<nx:null/>" && gtv == gt && val <= gtv)
							break
						if (lt != "<nx:null/>" && ltv == lt && val >= ltv)
							break
					}
				}
			} while (--arr[0] > 0)
			val = arr[0]
			delete arr
			if (val > 0)
				exit 1
		}
	'
)
__nx_int_round_trunc() { tmpa="$tmpa\nif(n=nx_trunc($1))"; tmb="trunc"; }
__nx_int_round_round() { tmpa="$tmpa\nif(n=nx_round($1))"; tmpb="round"; }
__nx_int_round_floor() { tmpa="$tmpa\nif(n=nx_floor($1))"; tmpb="floor"; }
__nx_int_round_ceiling() { tmpa="$tmpa\nif(n=nx_ceiling($1))"; tmpb="ceiling"; }
nx_int_round()
(
	tmpa=""
	tmpb="round"
	while test "$#" -gt 0; do
		case "$1" in
			-t) __nx_int_round_trunc "$2"; shift;;
			-r) __nx_int_round_round "$2"; shift;;
			-c) __nx_int_round_ceiling "$2"; shift;;
			-f) __nx_int_round_floor "$2"; shift;;
			*) __nx_int_round_$tmpb "$1";;
		esac
		tmpa="$tmpa{print n}else{e=-1}"
		shift
	done
	test -n "$tmpa" && ${AWK:-$(nx_cmd_awk)} "
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-int.awk")
	"'
		BEGIN {
			'"$(printf "$tmpa")"'
		}
	'
)
nx_int_convert()
(
	nx_data_optargs 'i:o:n:' "$@"
	nx_int_range -l 64 -a -g 1 -v "$NEX_k_i" || NEX_k_i=10
	nx_int_range -l 64 -a -g 1 -v "$NEX_k_o" || NEX_k_o=16
	test -z "$NEX_k_n" && NEX_k_n="$NEX_R"
	nx_int_range -o -v "$NEX_k_n" || exit 2
	test -z "$NEX_k_n" && {
		nx_tty_print -e 'nx_int_convert: error — empty input (-n required)'
		exit 24
	}
	${AWK:-$(nx_cmd_awk)} \
		-v ibs="${NEX_k_i:-10}" \
		-v obs="${NEX_k_o:-16}" \
		-v num="$NEX_k_n" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-math-extras.awk")
	"'
		BEGIN {
			print nx_convert_base(num, ibs, obs)
		}
	'
)

nx_io_noclobber()
(
	nx_data_optargs 'p:s:n:bfrFRDM' "$@"
	NEX_k_n="${NEX_k_n:-8}"
	nx_int_range -g 1 -l 128 -e -a -v "$NEX_k_n" || NEX_k_n=8
	NEX_k_p="$(nx_fs_canonize -p "$NEX_k_p")"
	NEX_k_s="$(nx_fs_canonize -b "$NEX_k_s")"
	test -z "$NEX_k_p$NEX_k_s" && exit 66 || tmpc="$NEX_k_p$NEX_k_s"
	test "$NEX_f_D" = '<nx:true/>' && {
		mkdir -p "$(nx_fs_canonize -d "$NEX_k_p")" 2>/dev/null || {
			nx_tty_print -e 'mkdir failed or smth'
			exit 64
		}
	}
	test "$NEX_f_b" = '<nx:true/>' && tmpb="-$(nx_str_timestamp -f)" || tmpb=""
	test -e "$NEX_k_p$NEX_k_s" && tmpb="${tmpb}_"
	tmpa=""
	while test -e "$NEX_k_p$tmpa$NEX_k_s"; do
		tmpa="$tmpb$(nx_str_rand "$NEX_k_n")"
	done
	test "$NEX_f_R" = '<nx:true/>' && {
		rm ${NEX_f_F:+-f} ${NEX_f_r:+-r} "$tmpc" || {
			nx_tty_print -e 'file rm failed or smth'
			exit 65
		}
	}
	test "$NEX_f_M" = '<nx:true/>' && {
		mv "$tmpc" "$NEX_k_p$tmpa$NEX_k_s" || {
			nx_tty_print -e 'file mv failed or smth'
			exit 65
		}
	}
	printf '%s' "$NEX_k_p$tmpa$NEX_k_s"
)



# a:	args
# x:	exec
# e:	remove
# m:	move
# n:	new
# i:	is
# c:	check
# o:	options
# j:	json
# c:	create
# __nx_ip_a_netns -> __nx_ip_a_ifname
__nx_ip_a_netns()
{
	NEX_S="$(__nx_ip_c_netns "$NEX_k_n" && printf '%s' "$1" || printf '%s' "n:$1")"
	shift
	nx_data_optargs "$NEX_S" "$@"
	__nx_ip_c_netns "$NEX_k_n"
}
__nx_ip_x_netns()
(
	if __nx_ip_a_netns 'x' "$@"; then
		if test "$NEX_S" != ""; then
			case "$NEX_f_x" in
				'<nx:true/>') {
					ip netns exec "nex-$NEX_k_n" $NEX_S
				};;
				'<nx:false/>') {
					printf '%s' "ip netns exec 'nex-$NEX_k_n' $NEX_S"
				};;
			esac
		else
			printf '%s ' "ip netns exec nex-$NEX_k_n"
		fi
	elif test "$NEX_S" != ""; then
		case "$NEX_f_x" in
			'<nx:true/>') {
				eval $NEX_S
			};;
			'<nx:false/>') {
				printf '%s ' "$NEX_S"
			};;
		esac
	fi
)
__nx_ip_e_netns()
(
	test -n "$1" || exit
	__nx_ip_x_netns -n "$1" -e ${0#-}
)
__nx_ip_r_netns()
{
	__nx_ip_i_netns "$1" || return 0
	test -e "/var/run/nex-$1.pid" && {
		kill "$(cat /var/run/nex-$1.pid)"
		rm -f "/var/run/nex-$1.pid"
	} 2> /dev/null
	ip netns delete "nex-$1"
}
__nx_ip_i_netns()
{
	ip netns | grep -q "^nex-$1\([\\\t ]\+(id:[ \\\t]\+[0-9]\+)$\|$\)"
}
__nx_ip_c_netns()
{
	__nx_ip_i_netns "$1" || {
		test -n "$1" || return
		__nx_ip_n_netns "$1"
	}
	__nx_ip_i_netns "$1"
}
__nx_ip_n_netns()
{
	__nx_ip_i_netns "$1" && return
	ip netns add "nex-$1" && {
		ip netns exec "nex-$1" sysctl --system 1> /dev/null 2>&1
		ip netns exec "nex-$1" ip link set lo up
		nohup nsenter --net="/var/run/netns/nex-$1" -- ${0#-} -c 'while :; do sleep 18250; done' 1> /dev/null 2>&1 & printf '%d' $! > "/var/run/nex-$1.pid"
	}
}
nx_ip_netns()
(
	nx_data_optargs 're' "$@"
	NEX_R="$(
		${AWK:-$(nx_cmd_awk)} \
			-v str="$NEX_R" \
			-v rmve="${NEX_f_r:-<nx:false/>}" \
		"
			$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct.awk")
		"'
			BEGIN {
				nx_trim_split(str, args, "<nx:null/>")
				if (rmve == "<nx:true/>")
					rmve = "r"
				else
					rmve = "n"
				for (str = 1; str <= args[0]; ++str)
					print "__nx_ip_" rmve "_netns " args[str]
				delete args
			}
		'
	)"
	test "$NEX_f_e" != '<nx:true/>' && printf '%s' "$NEX_R" || eval "$NEX_R"
)
__nx_ip_m_netns()
(
	__nx_ip_a_netns 'd:N:' "$@"
	test "$NEX_k_N" != "$NEX_k_n" -a "$NEX_k_N" != "" || exit
	__nx_ip_c_netns "$NEX_k_N" || exit
	$(__nx_ip_x_netns) ip link set $(nx_ip_g_ifname -d "$NEX_k_d") netns "nex-$NEX_k_N"
)

###########################################################################################################
nx_ip_j_arp()
(
	__nx_ip_a_netns 'p:' "$@"
	$(__nx_ip_x_netns) ${AWK:-$(nx_cmd_awk)} '
		{
			if (! header) {
				header = 1
				next
			}
			iface[$NF] = iface[$NF] "{\x22ip\x22:\x22" $1 "\x22,\x22type\x22:\x22" $2 "\x22,\x22flags\x22:\x22" $3 "\x22,\x22hw\x22:\x22" $4 "\x22,\x22mask\x22:\x22" $5 "\x22},"
		} END {
			for (face in iface) {
				sub(/,$/,"]},", iface[face])
				s = s "{\x22" face "\x22:[" iface[face]
			}
			delete iface
			sub(/,$/, "]", s)
			if (s)
				printf("[%s", s)
			else
				exit 1
		}
	' "$(test -n "$NEX_k_p" -a -f "/proc/$NEX_k_p/net/arp" && printf '%s' "/proc/$NEX_k_p/net/arp" || printf '%s' '/proc/self/net/arp')"
)
nx_ip_g_arp_l2()
(
	nx_data_optargs 's:d:' "$@"
	NEX_k_d="${NEX_k_d:+$(nx_ip_o_names "$NEX_k_d")}"
	NEX_S="$(nx_ip_j_arp "$@")"
	test -n "$NEX_S" || exit 69
	nx_data_jdump "$NEX_S" | ${AWK:-$(nx_cmd_awk)}  \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
	'
		/^\.nx\[[1-9][0-9]*\]\.'"${NEX_k_d:-.+}"'\[[1-9][0-9]*\]\.hw = /{
			if (b++)
				printf("%s", sep)
			printf("%s", $NF)
		} END {
			exit b < 2
		}
	'
)
###########################################################################################################
nx_ip_g_l2()
(
	__nx_ip_a_netns 's:d:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip -json link show ${NEX_k_d:+$(nx_ip_o_names "$NEX_k_d")})" | ${AWK:-$(nx_cmd_awk)}  \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
	'
		/^\.nx\[[1-9][0-9]*\]\.address = /{
			if (b == 1)
				printf("%s", sep)
			else
				b = 1
			printf("%s", $NF)
		}
	'
)
nx_ip_g_n()
(
	__nx_ip_a_netns 's:d:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip -json neighbor show ${NEX_k_d:+$(nx_ip_o_names "$NEX_k_d")})" | ${AWK:-$(nx_cmd_awk)}  \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
	'
		/^\.nx\[[1-9][0-9]*\]\.lladdr = /{
			if (b == 1)
				printf("%s", sep)
			else
				b = 1
			printf("%s", $NF)
		}
	'
)
nx_ip_l_l2()
{
	nx_str_join "$({
		nx_ip_g_l2
		printf '\n'
		nx_ip_g_n
		printf '\n'
		nx_ip_g_arp_l2
	} | sort | uniq -iu)" "${1:-\n}"
}
nx_ip_n_l2()
{
	${AWK:-$(nx_cmd_awk)} \
			-v l2="${NEX_k_v:-${NEX_S:-$1}}" \
			-v addr="$(nx_ip_l_l2 "<nx/>")" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-data.awk")
	"'
		BEGIN {
			gsub(/:|-/, "", addr)
			addr = tolower(addr)
			nx_arr_split(addr, hexes, "<nx/>")
			l2 = substr(tolower(l2), 1, 12)
			gsub(/[^a-f0-9]*/, "", l2)
			if ((ln = 12 - length(l2)) == 0) {
				if (l2 in hexes) {
					ln = 8
					l2 = substr(l2, 1, 8)
				} else {
					ln = "<nx:true/>"
				}
			}
			if (ln != "<nx:true/>") {
				do {
					hex = l2 tolower(nx_random_str(ln, "xdigit"))
				} while (hex in hexes)
			}
			ln = split(hex, hexes, "")
			hex = hexes[1] hexes[2]
			for (ln = 3; ln <= 12; ln += 2)
				hex = hex ":" hexes[ln] hexes[ln + 1]
			delete hexes
			print hex
		}
	'
}
###########################################################################################################
nx_ip_s_l2()
(
	nx_ip_a_ifname 'v:' "$@" || exit
	$(__nx_ip_x_netns) ip link set dev "$NEX_k_d" address "$(nx_ip_n_l2 "${NEX_k_v:-$NEX_S}")"
)

nx_ip_a_inet()
{
	NEX_S="f:$1"
	shift
	nx_ip_a_ifname "$NEX_S" "$@"
	case "$NEX_f_f" in
		4|inet4|inet4) NEX_f_f='-family inet';;
		6|inet6) NEX_f_f='-family inet6';;
		*) NEX_f_f='';;
	esac
	test -n "$NEX_k_d"
}
nx_ip_a_family()
{
	NEX_S="f:$1"
	shift
	nx_ip_a_ifname "$NEX_S" "$@"
	case "$NEX_f_f" in
		4|inet4|inet4) NEX_f_f='-family inet';;
		6|inet6) NEX_f_f='-family inet6';;
		M|m|mpls) NEX_f_f='-family mpls';;
		B|b|bridge) NEX_f_f='-family bridge';;
		0|l|L|link) NEX_f_f='-family link';;
		*) NEX_f_f='';;
	esac
	test -n "$NEX_k_d"
}
nx_ip_g_local()
(
	nx_ip_a_family 's:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip $NEX_f_f -json address show $NEX_k_d)" | ${AWK:-$(nx_cmd_awk)} \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
		'/^\.nx\[[1-9][0-9]*\]\.addr_info\[[1-9][0-9]*\]\.local = /{
			if (b++)
				printf("%s", sep)
			printf("%s", $NF)
		} END {
			exit b < 2
		}
	'
)
nx_ip_o_local()
(
	nx_data_optargs 'o@' "$@"
	nx_data_match $(nx_ip_g_local " -o ") $NEX_S
)
###########################################################################################################
nx_ip_s_inet()
(
	nx_ip_a_inet 'l:v:' "$@" || exit
	test "$NEX_f_f" = '-family inet6' && NEX_k_l=""
	NEX_k_v="${NEX_k_v:-$NEX_S}"
	nx_ip_g_local | grep -q '^'"$NEX_k_v"'$' && return 1
	$(__nx_ip_x_netns) ip $NEX_f_f address add "$NEX_k_v" ${NEX_k_l:+label "$NEX_k_l"} dev "$NEX_k_d"
)
nx_ip_s_route()
(
	nx_ip_a_inet 'v:r:c' "$@" || exit
	if test -n "$($(__nx_ip_x_netns) ip $NEX_f_f route show default)"; then
		if "$NEX_f_c" = '<nx:true/>'; then
			$(__nx_ip_x_netns) ip route delete ${NEX_k_r:-default} dev
			return
		fi
		act='replace'
	fi
	$(__nx_ip_x_netns) ip $NEX_f_f route ${act:-add} ${NEX_k_r:-default} via "${NEX_k_v:-$NEX_S}" dev "$NEX_k_d"
)

###########################################################################################################
nx_ip_g_names()
(
	__nx_ip_a_netns 's:d:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip -json link show $NEX_k_d)" | ${AWK:-$(nx_cmd_awk)} \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
		'/^\.nx\[[1-9][0-9]*\]\.(ifname|altnames\[[1-9][0-9]*\]) = /{
			if (b++)
				printf("%s", sep)
			printf("%s", $NF)
		} END {
			exit b < 2
		}
	'
)
nx_ip_o_names()
(
	__nx_ip_a_netns 'o@' "$@"
	nx_data_match -o $(nx_ip_g_names -s " -o ") $NEX_S
)
###########################################################################################################
nx_ip_g_alt()
(
	__nx_ip_a_netns 's:d:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip -json link show $NEX_k_d)" | ${AWK:-$(nx_cmd_awk)} \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
		'/^\.nx\[[1-9][0-9]*\]\.altnames\[[1-9][0-9]*\] = /{
			if (b++)
				printf("%s", sep)
			printf("%s", $NF)
		} END {
			exit b < 2
		}
	'
)
__nx_ip_alt()
(
	nx_ip_a_ifname 'v:m:' "$@" || exit 2
	$(__nx_ip_x_netns) ip link property $NEX_k_m dev "$NEX_k_d" altname "${NEX_k_v:-$NEX_S}"
)
nx_ip_r_alt()
{
	__nx_ip_alt "$@" -m 'delete'
}
nx_ip_s_alt()
{
	__nx_ip_alt "$@" -m 'add'
}
nx_ip_o_alt()
(
	__nx_ip_a_netns 'o@' "$@"
	nx_data_match -o $(nx_ip_g_alt -s " -o ") $NEX_S
)
###########################################################################################################
nx_ip_g_name()
(
	__nx_ip_a_netns 's:d:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip -json link show $NEX_k_d)" | ${AWK:-$(nx_cmd_awk)}  \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
		'/^\.nx\[[1-9][0-9]*\]\.ifname = /{
			if (b++)
				printf("%s", sep)
			printf("%s", $NF)
		} END {
			exit b < 2
		}
	'
)
nx_ip_o_name()
(
	__nx_ip_a_netns 'o@' "$@"
	NEX_S="$(nx_data_match -o $(nx_ip_g_name -s " -o ") $NEX_S)"
	test -n "$NEX_S" || exit
	printf '%s' "$NEX_S"
)
nx_ip_s_name()
(
	nx_ip_a_ifname 'v:' "$@" || exit 2
	$(__nx_ip_x_netns) ip link set "$NEX_k_d" name "${NEX_k_v:-$NEX_S}"
	#__nx_ip_a_netns 'd:v:' "$@"
	#$(__nx_ip_x_netns) ip link set $(nx_ip_g_ifname -d "$NEX_k_d") name "$(nx_ip_c_name "${NEX_k_v:-$NEX_S}")"
)
###########################################################################################################
nx_ip_g_ifname()
(
	__nx_ip_a_netns 's:d:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip -json link show ${NEX_k_d:+$(nx_ip_o_names "$NEX_k_d")})" | ${AWK:-$(nx_cmd_awk)}  \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
		'/^\.nx\[[1-9][0-9]*\]\.ifname = /{
			if (b++)
				printf("%s", sep)
			printf("%s", $NF)
		} {
		} END {
			exit b < 2
		}
	'
)
nx_ip_o_ifname()
(
	__nx_ip_a_netns 'o@' "$@"
	NEX_S="$(nx_data_match -o $(nx_ip_g_ifname -s " -o ") $NEX_S)"
	test -n "$NEX_S" || exit
	printf '%s' "$NEX_S"
)
nx_ip_a_ifname()
{
	test "$1" = '--' && {
		NEX_R='<nx:true/>'
		shift
	} || NEX_R='<nx:false/>'
	test -n "$(nx_ip_o_ifname "$NEX_k_d")" && NEX_S="$1" || NEX_S="d:$1"
	test -z "$(nx_ip_o_ifname "$NEX_k_D")" && NEX_S="D:$NEX_S" || NEX_k_D=""
	shift
	if test "$NEX_R" = '<nx:false/>'; then
		__nx_ip_a_netns "$NEX_S" "$@"
	else
		nx_data_optargs "$NEX_S" "$@"
	fi
	NEX_k_d="$(nx_ip_o_ifname "$NEX_k_d")"
	test -n "$NEX_k_d" -o -n "$NEX_k_D"
}
###########################################################################################################
nx_ip_g_alias()
(
	nx_ip_a_ifname -- 's:' "$@"
	nx_data_jdump "$($(__nx_ip_x_netns) ip -json link show $NEX_k_d)" | ${AWK:-$(nx_cmd_awk)}  \
		-v sep="${NEX_k_s:-\n}" \
		-F '= ' \
		'/\.nx\[[0-9]+\]\.ifalias = /{
			if (b++)
				printf("%s", sep)
			printf("%s", substr($0, index($0, "=") + 1))
		} END {
			exit b < 2
		}
	'
)
nx_ip_s_alias()
(
	nx_ip_a_ifname 'v:' "$@" || exit 2
	nx_ip_g_alias | grep -q '^'"$NEX_S"'$' && return 1
	$(__nx_ip_x_netns) ip link set "$NEX_k_d" alias "${NEX_k_v:-$NEX_S}"
)
###########################################################################################################
nx_ip_c_name()
(
	__nx_ip_a_netns 'v:' "$@"
	${AWK:-$(nx_cmd_awk)}  \
		-v nm="${NEX_k_v:-$NEX_S}" \
		-v nms="$(nx_ip_g_names -s '<nx/>')" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-data.awk")
	"'
		BEGIN {
			ln = 15
			if ((t = split(nm, links, ".")) == 2) {
				if (links[2] > 0 && links[2] < 4095) {
					suf = "." links[2]
					ln = 15 - length(suf)
				}
			}
			delete links
			if (nm !~ /^[a-zA-Z_][a-zA-Z0-9-_]{0,14}$/)
				nm = nx_to_environ(nm)
			if (nm == "") {
				lnk = "_" nx_random_str(ln - 1, "alnum")
				t = ""
			} else {
				lnk = nm
				gsub(/[0-9]+$/, "", lnk)
				t = 0
				ln--
			}
			lnk = substr(lnk, 1, ln)
			nx_arr_split(nms, links, "<nx/>")
			while (lnk "" t "" suf in links) {
				if (t == "")
					lnk = "_" nx_random_str(ln - 1, "alnum")
				else
					t++
				if (length(lnk "" t) > ln) {
					if (! sub(/.$/, "", lnk))
						t = ""
					else
						--t
				}
			}
			delete links
			printf("%s%s%s", lnk, t, suf)
		}
	'
)

nx_ip_s_master()
(
	test -n "$(nx_ip_o_ifname "$NEX_k_m")" && NEX_S='' || NEX_S='m:'
	nx_ip_a_ifname "$NEX_S" "$@" || exit 2
	test -n "$(nx_ip_o_ifname "$NEX_k_m")" || exit 2
	$(__nx_ip_x_netns) ip link set "$NEX_k_d" up
	$(__nx_ip_x_netns) ip link set "$NEX_k_d" master "$NEX_k_m"
)
nx_ip_s_state()
(
	nx_ip_a_ifname 'v:m:' "$@" || exit
	NEX_k_v="$(nx_ip_o_state "${NEX_k_v:-$NEX_S}" || printf '%s' 'down')"
	NEX_S="$(test "$NEX_k_v" = 'up' && printf '%d' 1 || printf '%d' 0)"
	$(__nx_ip_x_netns) ip link set "$NEX_k_d" $NEX_k_m  "$NEX_k_v" || $(__nx_ip_x_netns) ip link set "$NEX_k_d" $NEX_k_m  "$NEX_k_v"
)
nx_ip_s_active()
(
	nx_ip_a_ifname 'v:m:' "$@" || exit
	NEX_k_v="$(nx_ip_o_active "${NEX_k_v:-$NEX_S}" || printf '%s' 'off')"
	NEX_S="$(test "$NEX_k_v" = 'on' && printf '%d' 1 || printf '%d' 0)"
	$(__nx_ip_x_netns) ip link set "$NEX_k_d" $NEX_k_m  "$NEX_k_v" || $(__nx_ip_x_netns) ip link set "$NEX_k_d" $NEX_k_m  "$NEX_k_v"
)
nx_ip_s_promisc()
{
	nx_ip_s_active "$@" -m 'promisc'
}
nx_ip_s_arp()
{
	nx_ip_s_active "$@" -m 'arp'
}
nx_ip_s_multicast()
{
	nx_ip_s_active "$@" -m 'multicast'
}
nx_ip_s_allmulticast()
{
	nx_ip_s_active "$@" -m 'allmulticast'
}
nx_ip_s_carrier()
{
	nx_ip_s_active "$@" -m 'carrier'
}
nx_ip_s_dynamic()
{
	nx_ip_s_active "$@" -m 'dynamic'
}
nx_ip_s_group()
(
	nx_ip_a_ifname 'v:' "$@" || exit
	$(__nx_ip_x_netns) ip link set "$NEX_k_d" group "$(nx_int_range -g 0 -v "${NEX_k_v:-$NEX_S}" && printf '%s' "${NEX_k_v:-$NEX_S}" || printf '%s' 'default')"
)
nx_ip_s_txqueuelen()
(
	nx_ip_a_ifname 'v:' "$@" || exit
	NEX_k_v="${NEX_k_v:-$NEX_S}"
	$(__nx_ip_x_netns) ip link set dev "$NEX_k_d" txqueuelen "$(nx_int_range -v "$NEX_k_v" -l 1 -g 4294967295 -e -a "$NEX_k_v" || printf '%d' 1000)"
)
nx_ip_s_lld_gen()
(
	nx_ip_a_ifname 'v:' "$@" || exit
	NEX_k_v="${NEX_k_v:-$NEX_S}"
	$(__nx_ip_x_netns) ip link set dev "$NEX_k_d" addrgenmode "$(nx_ip_o_lld_gen "${NEX_k_v:-$NEX_S}" || printf '%s' 'stable-privacy')"
)
nx_ip_s_mtu()
(
	nx_ip_a_ifname 'v:' "$@" || exit
	NEX_k_v="${NEX_k_v:-$NEX_S}"
	$(__nx_ip_x_netns) ip link set dev "$NEX_k_d" mtu "$(nx_int_range -v "$NEX_k_v" -l 65535 -g 68 -e -a && printf '%d' "$NEX_k_v" || printf '%d' 1500)"
)

###########################################################################################################
nx_ip_o_dev()
(
	nx_data_optargs 'o@' "$@"
	NEX_S="$(
		nx_data_match -o ipip -o sit -o vti -o xfrm -o ip6tnl -o gre -o gretap -o ip6gre -o ip6gretap \
			-o erspan -o ip6erspan -o geneve -o vxlan -o vxcan -o nlmon -o veth -o vcan -o dummy \
			-o ifb -o nlmon -o vlan -o vrf -o ipvlan -o ipvtap -o macvlan -o macvtap -o macsec \
			-o netdevsim -o netkit -o virt_wifi -o gtp -o pfcp -o rmnet -o wwan -o ipoib \
			-o bridge -o bridge_slave -o bond -o bond_slave -o team -o team_slave -o hsr $NEX_S
	)"
	test -n "$NEX_S" && printf '%s' "$NEX_S"
)
nx_ip_o_lld_gen()
(
	nx_data_optargs 'o@' "$@"
	NEX_S="$(
		nx_data_match -o eui64 -o none -o stable-privacy -o random $NEX_S
	)"
	test -n "$NEX_S" && printf '%s' "$NEX_S"
)
nx_ip_o_state()
(
	nx_data_optargs 'o@' "$@"
	NEX_S="$(
		nx_data_match -o up -o down "$(nx_str_case -l "$NEX_S")"
	)"
	test -n "$NEX_S" && printf '%s' "$NEX_S"
)
nx_ip_o_active()
(
	nx_data_optargs 'o@' "$@"
	NEX_S="$(
		nx_data_match -o on -o off "$(nx_str_case -l "$NEX_S")"
	)"
	test -n "$NEX_S" && printf '%s' "$NEX_S"
)















nx_ip_g_net()
{
	eval "$(
		ls --color=never -l '/sys/class/net/' | ${AWK:-$(nx_cmd_awk)} \
			-v ex="$1" \
			-F '/' \
		"
			$(nx_data_include -i "${NEXUS_LIB}/awk/nex-misc-extras.awk")
		"'
			BEGIN {
				if (ex == "-e")
					ex = "export "
				else
					ex = ""
				virt = ""
				phy = ""
			}
			/devices\/pci/{
				phy = phy " " $NF
			}
			/devices\/virtual/{
				virt = virt " " $NF
			} END {
				printf("%s%s; %s%s", ex, __nx_stringify_var("G_NEX_NET_VIRT" , substr(virt, 2)), ex, __nx_stringify_var("G_NEX_NET_PHY" , substr(phy, 2)))
			}
		'
	)"
}
###########################################################################################################
nx_ip_g_phy()
(
	__nx_ip_a_netns 's:w' "$@"
	nx_ip_g_net
	NEX_k_s="${NEX_k_s:- }"
	tmpb='0'
	for tmpa in $G_NEX_NET_PHY; do
		test "$tmpb" = '1' && printf '%s' "$NEX_k_s"
		if test "$NEX_f_w" = '<nx:true/>'; then
			test -d "/sys/class/net/$tmpa/wireless" && {
				printf '%s' "$tmpa"
				tmpb='1'
			}
		else
			test -e "/sys/class/net/$tmpa/wireless" || {
				printf '%s' "$tmpa"
				tmpb='1'
			}
		fi
	done
)
nx_ip_g_lo()
(
	nx_ip_g_net
	for tmpa in $G_NEX_NET_VIRT; do
		test "$(cat "/sys/class/net/$tmpa/type")" = '772' && {
			printf '%s' "$tmpa"
			exit
		}
	done
	exit 1
)
nx_ip_s_phy()
(
	__nx_ip_a_netns 'E:W:L:' "$@"
	NEX_k_E="${NEX_k_E:-ethernet}"
	NEX_k_W="${NEX_k_W:-wireless}"
	NEX_k_L="${NEX_k_L:-loopback}"
	for tmpa in $(nx_ip_g_phy); do
		case "$tmpa" in
			"$NEX_k_E"*);;
			*) {
				NEX_k_E="$(nx_ip_c_name -v "$NEX_k_E")"
				nx_ip_s_name -d "$tmpa" -v "$NEX_k_E"
				nx_ip_n_dev -t 'ethernet' -l "$NEX_k_E"
			};;
		esac
	done
	for tmpa in $(nx_ip_g_phy -w); do
		case "$tmpa" in
			"$NEX_k_W"*);;
			*) {
				NEX_k_W="$(nx_ip_c_name -v "$NEX_k_W")"
				nx_ip_s_name -d "$tmpa" -v "$NEX_k_W"
				nx_ip_n_dev -t 'wireless' -l "$NEX_k_W"
			};;
		esac
	done
	tmpa="$(nx_ip_g_lo)"
	case "$tmpa" in
		"$NEX_k_L"*);;
		*) {
			NEX_k_L="$(nx_ip_c_name -v "$NEX_k_L")"
			nx_ip_s_name -d "$tmpa" -v "$NEX_k_L"
			nx_ip_n_dev -t 'loopback' -l "$NEX_k_L"
		};;
	esac
)
nx_ip_n_dev()
(
	__nx_ip_a_netns 'l:t:qh' "$@"
	case "$NEX_k_t" in
		ethernet|wireless|loopback) {
			NEX_k_l="${NEX_k_l:-$NEX_k_t}"
		};;
		*) {
			NEX_k_t="$(nx_ip_o_dev "$NEX_k_t" || printf '%s' 'dummy')"
			NEX_k_l="$(nx_ip_c_name "${NEX_k_l:-$NEX_k_t}")"
			$(__nx_ip_x_netns) ip link add "$NEX_k_l" type "$NEX_k_t" || exit
		};;
	esac
	NEX_k_d="$NEX_k_l"
	NEX_E=0
	case "$NEX_f_q" in
		'<nx:true/>'|'<nx:false/>') {
			NEX_S="$(__nx_ip_n_builder)" || {
				printf '%s' "$NEX_S" 1>&2
				exit 2
			}
			if test "$NEX_f_q" = '<nx:true/>'; then
				nohup eval "$NEX_S" \
					2>"$NEXUS_ENV/proc/err-$NEX_PID.log" \
					1>"$NEXUS_ENV/proc/err-$NEX_PID.log" \
					& printf '%d' "$!" > "$NEXUS_ENV/proc/pid-$NEX_PID.log"
				exit
			else
				eval "$NEX_S" || NEX_E=1
			fi
		};;
		*) {
			NEX_S="$(__nx_ip_n_builder '<nx:null/>')" || {
				printf '%s' "$NEX_S" 1>&2
				exit 2
			}
			for i in $(nx_str_od -x -s ' ' "$NEX_S"); do
				cmdstr="$(printf "$i")"
				nx_tty_print -i "$cmdstr\n"
				cmdres="$(eval "$cmdstr" 2>&1)" || {
					for j in $(nx_str_od -x -s ' ' "$cmdres"); do
						nx_tty_print -e "$(printf '%s' "$j")\n"
						NEX_E=$((NEX_E + 1))
					done
				}
			done
		}
	esac
	test "$NEX_E" -gt 0 && {
		nx_tty_print -w "$NEX_E errors while creating $NEX_k_d of type $NEX_k_t! D:\n"
	} || {
		nx_tty_print -s "$NEX_k_d was created without errors! :D\n"
	}
)
__nx_ip_dev()
(
	nx_ip_a_ifname 'v:p:m:' "$@" || exit
	test "$NEX_k_m" = 'delete' && {
		NEX_k_v=$(nx_ip_t_dev)
	}
	if NEX_k_v="$(nx_ip_o_dev "$NEX_k_v")"; then
		$(__nx_ip_x_netns) ip link $NEX_k_m "${NEX_k_d:-$NEX_k_D}" $NEX_k_p type "$NEX_k_v" $NEX_S || exit
	else
		$(__nx_ip_x_netns) ip link $NEX_k_m "${NEX_k_d:-$NEX_k_D}" $NEX_S || exit
	fi
)
nx_ip_s_dev()
{
	__nx_ip_dev "$@" -m 'set'
}
__nx_ip_n_dev()
{
	__nx_ip_dev "$@" -m 'add'
}
nx_ip_t_dev()
(
	nx_ip_a_ifname '' "$@" || exit
	tmpa="$(nx_data_jdump "$($(__nx_ip_x_netns) ip -detail -json link show $NEX_k_d)" | ${AWK:-$(nx_cmd_awk)} '/\.nx\[1\]\.linkinfo\.info_kind = /{printf("%s", $NF); exit}')"
	test -n "$tmpa" && printf '%s' "$tmpa"
)
nx_ip_r_dev()
(
	__nx_ip_dev "$@" -m 'delete'
)
nx_ip_r_dev()
(
	__nx_ip_dev "$@" -m 'delete'
)
__nx_ip_n_builder()
(
	nx_base="${NEXUS_CNF}/json/network/"
	${AWK:-$(nx_cmd_awk)} \
		-v sep="$(test "$1" = '<nx:blank/>' && printf '%s' '' || printf '%s' "${1:-\n}")" \
		-v lnk="$NEX_k_l" \
		-v typ="$NEX_k_t" \
		-v json="${nx_base}${NEX_k_t}.json" \
		-v base="${nx_base}base.json" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		BEGIN {
			if (err = nx_json(base, cfg, 2))
				exit err
			if (err = nx_json(json, cfg, 2))
				exit err
			if (tolower(cfg[".nx.l2.address"]) == "random")
				printf("nx_ip_s_l2 %s%s", cfg[".nx.l2.prefix"], sep)
			nx_json_delete(".l2", cfg)
			if (".nx.name.alias" in cfg) {
				gsub("<nx:placeholder/>", lnk, cfg[".nx.name.alias"])
				printf("nx_ip_s_alias %s%s", cfg[".nx.name.alias"], sep)
			}
			if (nx_json_type(".attributes", cfg) == 1) { # an object??
				nx_json_split(".attributes", cfg, arr)
				for (i = 1; i <= arr[0]; ++i)
					printf("nx_ip_s_%s %s%s", arr[i], cfg[".nx.attributes." arr[i]], sep)
			}
			nx_json_delete(".attributes", cfg)
			if (nx_json_type(".values", cfg) == 1) { # an object??
				nx_json_split(".values", cfg, arr)
				for (i = 1; i <= arr[0]; ++i)
					printf("nx_ip_s_dev -v %s %s %s%s", typ, arr[i], cfg[".nx.values." arr[i]], sep)
			}
			nx_json_delete(".values", cfg)
			printf("nx_ip_s_state %s", cfg[".nx.state"])
			delete cfg
			delete arr
		}
	'
)
nx_ip_g_net()
{
	eval "$(
		ls --color=never -l '/sys/class/net/' | ${AWK:-$(nx_cmd_awk)} \
			-v ex="$1" \
			-F '/' \
		"
			$(nx_data_include -i "${NEXUS_LIB}/awk/nex-misc-extras.awk")
		"'
			BEGIN {
				if (ex == "-e")
					ex = "export "
				else
					ex = ""
				virt = ""
				phy = ""
			}
			/devices\/pci/{
				phy = phy " " $NF
			}
			/devices\/virtual/{
				virt = virt " " $NF
			} END {
				printf("%s%s; %s%s", ex, __nx_stringify_var("G_NEX_NET_VIRT" , substr(virt, 2)), ex, __nx_stringify_var("G_NEX_NET_PHY" , substr(phy, 2)))
			}
		'
	)"
}
###########################################################################################################
nx_ip_g_phy()
(
	__nx_ip_a_netns 's:w' "$@"
	nx_ip_g_net
	NEX_k_s="${NEX_k_s:- }"
	tmpb='0'
	for tmpa in $G_NEX_NET_PHY; do
		test "$tmpb" = '1' && printf '%s' "$NEX_k_s"
		if test "$NEX_f_w" = '<nx:true/>'; then
			test -d "/sys/class/net/$tmpa/wireless" && {
				printf '%s' "$tmpa"
				tmpb='1'
			}
		else
			test -e "/sys/class/net/$tmpa/wireless" || {
				printf '%s' "$tmpa"
				tmpb='1'
			}
		fi
	done
)
nx_ip_g_lo()
(
	nx_ip_g_net
	for tmpa in $G_NEX_NET_VIRT; do
		test "$(cat "/sys/class/net/$tmpa/type")" = '772' && {
			printf '%s' "$tmpa"
			exit
		}
	done
	exit 1
)
nx_ip_s_phy()
(
	__nx_ip_a_netns 'E:W:L:' "$@"
	NEX_k_E="${NEX_k_E:-ethernet}"
	NEX_k_W="${NEX_k_W:-wireless}"
	NEX_k_L="${NEX_k_L:-loopback}"
	for tmpa in $(nx_ip_g_phy); do
		case "$tmpa" in
			"$NEX_k_E"*);;
			*) {
				NEX_k_E="$(nx_ip_c_name -v "$NEX_k_E")"
				nx_ip_s_name -d "$tmpa" -v "$NEX_k_E"
				nx_ip_n_dev -t 'ethernet' -l "$NEX_k_E"
			};;
		esac
	done
	for tmpa in $(nx_ip_g_phy -w); do
		case "$tmpa" in
			"$NEX_k_W"*);;
			*) {
				NEX_k_W="$(nx_ip_c_name -v "$NEX_k_W")"
				nx_ip_s_name -d "$tmpa" -v "$NEX_k_W"
				nx_ip_n_dev -t 'wireless' -l "$NEX_k_W"
			};;
		esac
	done
	tmpa="$(nx_ip_g_lo)"
	case "$tmpa" in
		"$NEX_k_L"*);;
		*) {
			NEX_k_L="$(nx_ip_c_name -v "$NEX_k_L")"
			nx_ip_s_name -d "$tmpa" -v "$NEX_k_L"
			nx_ip_n_dev -t 'loopback' -l "$NEX_k_L"
		};;
	esac
)
nx_ip_n_dev()
(
	__nx_ip_a_netns 'l:t:qh' "$@"
	case "$NEX_k_t" in
		ethernet|wireless|loopback) {
			NEX_k_l="${NEX_k_l:-$NEX_k_t}"
		};;
		*) {
			NEX_k_t="$(nx_ip_o_dev "$NEX_k_t" || printf '%s' 'dummy')"
			NEX_k_l="$(nx_ip_c_name "${NEX_k_l:-$NEX_k_t}")"
			$(__nx_ip_x_netns) ip link add "$NEX_k_l" type "$NEX_k_t" || exit
		};;
	esac
	NEX_k_d="$NEX_k_l"
	NEX_E=0
	case "$NEX_f_q" in
		'<nx:true/>'|'<nx:false/>') {
			NEX_S="$(__nx_ip_n_builder)" || {
				printf '%s' "$NEX_S" 1>&2
				exit 2
			}
			if test "$NEX_f_q" = '<nx:true/>'; then
				nohup eval "$NEX_S" \
					2>"$NEXUS_ENV/proc/err-$NEX_PID.log" \
					1>"$NEXUS_ENV/proc/err-$NEX_PID.log" \
					& printf '%d' "$!" > "$NEXUS_ENV/proc/pid-$NEX_PID.log"
				exit
			else
				eval "$NEX_S" || NEX_E=1
			fi
		};;
		*) {
			NEX_S="$(__nx_ip_n_builder '<nx:null/>')" || {
				printf '%s' "$NEX_S" 1>&2
				exit 2
			}
			for i in $(nx_str_od -x -s ' ' "$NEX_S"); do
				cmdstr="$(printf "$i")"
				nx_tty_print -i "$cmdstr\n"
				cmdres="$(eval "$cmdstr" 2>&1)" || {
					for j in $(nx_str_od -x -s ' ' "$cmdres"); do
						nx_tty_print -e "$(printf '%s' "$j")\n"
						NEX_E=$((NEX_E + 1))
					done
				}
			done
		}
	esac
	test "$NEX_E" -gt 0 && {
		nx_tty_print -w "$NEX_E errors while creating $NEX_k_d of type $NEX_k_t! D:\n"
	} || {
		nx_tty_print -s "$NEX_k_d was created without errors! :D\n"
	}
)
__nx_ip_dev()
(
	nx_ip_a_ifname 'v:p:m:' "$@" || exit
	test "$NEX_k_m" = 'delete' && {
		NEX_k_v=$(nx_ip_t_dev)
	}
	if NEX_k_v="$(nx_ip_o_dev "$NEX_k_v")"; then
		$(__nx_ip_x_netns) ip link $NEX_k_m "${NEX_k_d:-$NEX_k_D}" $NEX_k_p type "$NEX_k_v" $NEX_S || exit
	else
		$(__nx_ip_x_netns) ip link $NEX_k_m "${NEX_k_d:-$NEX_k_D}" $NEX_S || exit
	fi
)
nx_ip_s_dev()
{
	__nx_ip_dev "$@" -m 'set'
}
__nx_ip_n_dev()
{
	__nx_ip_dev "$@" -m 'add'
}
nx_ip_t_dev()
(
	nx_ip_a_ifname '' "$@" || exit
	tmpa="$(nx_data_jdump "$($(__nx_ip_x_netns) ip -detail -json link show $NEX_k_d)" | ${AWK:-$(nx_cmd_awk)} '/\.nx\[1\]\.linkinfo\.info_kind = /{printf("%s", $NF); exit}')"
	test -n "$tmpa" && printf '%s' "$tmpa"
)
nx_ip_r_dev()
(
	__nx_ip_dev "$@" -m 'delete'
)
nx_ip_r_dev()
(
	__nx_ip_dev "$@" -m 'delete'
)



nx_data_jdump()
{
	${AWK:-$(nx_cmd_awk)} -v jdump="$*" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		BEGIN {
			nx_json(jdump, arr, 2)
			for (jdump in arr)
				printf("%s = %s\n", jdump, arr[jdump])
			delete arr;
		}
	'
}
nx_data_jtree()
(
	nx_data_optargs 'r:j:n:' "$@"
	NEX_k_n="$(nx_int_range -o -g '-1' -v "$NEX_k_n")"
	${AWK:-$(nx_cmd_awk)} -v jdump="$NEX_k_j" -v root="${NEX_k_r:-}" -v indent="$NEX_k_n" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		BEGIN {
			if (err = nx_json(jdump, arr, 2))
				exit err
			print nx_json_flatten(root, arr, indent)
			delete arr
		}
	'
)

nx_misc_shift()
{
	${AWK:-$(nx_cmd_awk)} \
		-v st="$1" \
		-v ed="${2:-<nx:null/>}" \
		-v shft="$(nx_data_ref ${3:-nx_shft})" \
	'
		BEGIN {
			shft = int(shft)
			if (st != int(st) || (st = int(st)) <= 0)
				exit 0
			if (ed != "<nx:null/>" && ed == int(ed)) {
				ed = int(ed)
				if (ed > 0 && ed < 256 - shft && ed < st)
					exit ed + shft
			}
			if (st < 256 - shft)
				exit st + shft
		}
	' || {
		eval "${3:-nx_shft}=$?"
		return
	}
	return 1
}
h_nx_nnn()
{
	h_nx_cmd nnn || (
		cd /tmp
		git clone https://github.com/jarun/nnn.git
		cd nnn
		make O_NERD=1
		cp nnn "$NEXUS_BIN"
	)
	test -p "$NEXUS_ENV/proc/nnn-$(id -u).fifo" || mkfifo "$NEXUS_ENV/proc/nnn-$(id -u).fifo"
	export NNN_FIFO="$NEXUS_ENV/proc/nnn-$(id -u).fifo"
}
nx_pod_id()
{
	$G_NEX_CONTAINER inspect --filter='{{.ID}}' "$1"
}
nx_pod_isUp()
{
	test "$($G_NEX_CONTAINER  inspect --format='{{.State.Running}}' "$1")" = 'true'
}
nx_pod_run()
{
	if nx_pod_isUp "$1"; then
		$G_NEX_CONTAINER restart "$1"
	else
		$G_NEX_CONTAINER start "$1"
	fi
}
nx_py_venv()
{
	tmpa="$NEXUS_LIB/py"
	tmpb=""
	tmpc="run.py"
	while test "$#" -gt 0; do
		case "$1" in
			-N) {
				test -f "$tmpa/$tmpb/$2" && tmpc="$2"
				shift
			};;
			-R) {
				test -d "$2" && tmpa="$2"
				shift
			};;
			-A) {
				test -d "$tmpa/$2" && tmpb="$2"
				shift
			};;
			-a) {
				. "$tmpa/$tmpb/.env/bin/activate"
			};;
			-d) {
				. "$tmpa/$tmpb/.env/bin/deactivate"
			};;
			-c) {
				python -m venv "$tmpa/$tmpb/.env/"
			};;
			*) {
				if test "$VIRTUAL_ENV" = "$tmpa/$tmpb/.env"; then
					case "$1" in
						-s) {
							python "$tmpa/$tmpb/$tmpc"
						};;
						-r) {
							test -f "$tmpa/$tmpb/requirements.txt" -a -r "$tmpa/$tmpb/requirements.txt" && {
								pip install -r "$tmpa/$tmpb/requirements.txt"
								pip install --upgrade pip
							}
						};;
					esac
				else
					printf '%s\n' "($1) unknown argument" 1>&2
				fi
			};;
		esac
		shift
	done
}
nx_str_od()
(
	nx_asm_export
	h_nx_cmd od || {
		nx_tty_print -e 'o no od was not found'
		exit 127
	}
	test "$NEX_k_s" = '<nx:blank/>' && NEX_k_s='' || NEX_k_s="${NEX_k_s:- }"
	nx_data_optargs 'd<ox>s:' "$@"
	test "$G_NEX_ASM_ENDIAN" -eq 1 && G_NEX_ASM_ENDIAN="big" || G_NEX_ASM_ENDIAN="little"
	NEX_g_d="${NEX_g_d:-x}"
	${AWK:-$(nx_cmd_awk)} \
		-v dlm="$NEX_k_s" \
		-v args="$(printf '%s' "$NEX_R" | od --endian="$G_NEX_ASM_ENDIAN" --address-radix=none --format="${NEX_g_d}1")" \
		-v cnv="$NEX_g_d" \
	'
		BEGIN {
			if (cnv == "x")
				gsub(/ /, "\\x", args)
			else
				gsub(/ /, "\\0", args)
			gsub(/\n/, "", args)
			if (cnv == "x")
				gsub(/\\x3c\\x6e\\x78\\x3a\\x6e\\x75\\x6c\\x6c\\x2f\\x3e/, dlm, args)
			else
				gsub(/\\0074\\0156\\0170\\0072\\0156\\0165\\0154\\0154\\0057\\0076/, dlm, args)
			printf("%s", args)
		}
	'
)
nx_str_join()
{
	printf '%s' "$1" | ${AWK:-$(nx_cmd_awk)} -v dlm="$2" 'NR==1{printf "%s",$0; next}{printf "%s", dlm $0}'
}
nx_str_cnt()
(
	nx_data_optargs 'd:' "$@"
	${AWK:-$(nx_cmd_awk)} \
		-v dlm="${NEX_k_d:-,}" \
		-v str="$NEX_S" \
		'BEGIN {print gsub(dlm, "\\\&", str)}'
)
nx_str_chain()
{
	printf '%s' "$1"
	shift
	while test "$#" -gt 0; do
		printf '%s' "<nx:null/>$1"
		shift
	done
}
nx_str_timestamp()
{
	while test "$#" -gt 0; do
		case "$1" in
			-a) date +"%Y-%m-%d %H:%M:%S %Z (%A)";;
			-n) date +"%Y-%m-%d %H:%M:%S.%N";;
			-u) date +"%Y-%m-%dT%H:%M:%SZ";;
			-l) date +"%Y-%m-%dT%H:%M:%S%z";;
			-s) date +"%b %d %H:%M:%S";;
			-e) date +"%s";;
			-f) date +"%Y%m%d_%H%M%S";;
			-w) date +"%a_%Y%m%d_%H%M";;
			-z) date +"%Y-%m-%d %H:%M:%S %Z";;
		esac
		shift
	done
}
nx_str_case()
(
	nx_data_optargs 'c<ult>v:' "$@"
	${AWK:-$(nx_cmd_awk)} \
		-v cse="$NEX_g_c" \
		-v str="${NEX_k_v:-$NEX_S}" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str-extras.awk")
	"'
		BEGIN {
			if (cse == "t")
				printf("%s", nx_str_totitle(str))
			else if (cse == "u")
				printf("%s", toupper(str))
			else
				printf("%s", tolower(str))
		}
	'
)
nx_str_rand()
{
	${AWK:-$(nx_cmd_awk)} \
		-v num="${1:-8}" \
		-v chars="${2:-alnum}" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str-extras.awk")
	"'
		BEGIN {
			num __nx_if(__nx_is_integral(num), num, 8)
			if (val = nx_random_str(num, chars))
				print val
			else
				exit 1
		}
	'
}
nx_str_grep()
(
	nx_data_optargs 'd:f:S:r:m:s:c:b:a:o@wgiC' "$@"
	$NEX_S | ${AWK:-$(nx_cmd_awk)} \
		-v fnd="$NEX_k_f" \
		-v mth="$NEX_k_m" \
		-v rpl="$NEX_k_r" \
		-v sep="$NEX_k_s" \
		-v osep="$NEX_k_S" \
		-v delm="${NEX_k_d:-<nx:null/>}" \
		-v cnt="$NEX_k_c" \
		-v bfre="$NEX_k_b" \
		-v aftr="$NEX_k_a" \
		-v ofst="$NEX_K_o" \
		-v wrp="${NEX_f_w:-<nx:false/>}" \
		-v gbl="${NEX_f_g:-<nx:true/>}" \
		-v inc="${NEX_f_i:-<nx:false/>}" \
		-v cse="${NEX_f_C:-<nx:false/>}" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str-extras.awk")
	"'
		{
			nx_str_grep($0, flds, delm, fnd delm mth delm rpl delm sep delm osep, inc delm wrp delm gbl delm cse, bfre delm aftr delm cnt, ofst)
		} END {
			delete flds
		}
	'
)

nx_tex_gls()
(
	makeglossaries \
		-d "$NEXUS_DOC" \
		-t "$NEXUS_ENV/log/vimtex_gls.log" "$@"
)

nx_tex_lua_path()
{
	h_nx_cmd luatex || return 127
	G_NEX_LUA_ROCKS="$(
		tmpa="$(luatex --luaonly "$NEXUS_LIB/lua/luatex/version.lua")"
		nx_data_path_append -v G_NEX_LUA_ROCKS -s ':' \
			$(h_nx_cmd luarocks && printf '%s' "$HOME/.luarocks/lib/lua/$tmpa") \
			"/usr/lib/lua/$tmpa"
	)"
	test -n "$G_NEX_LUA_ROCKS" && {
		export G_NEX_LUA_ROCKS
		return 0
	} || {
		unset G_NEX_LUA_ROCKS
		return 1
	}
}
nx_tex_export()
{
	export G_NEX_TEX_VIEWER="$(g_nx_cmd zathura mupdf evince skim)"
	export G_NEX_TEX_COMPILER="$(g_nx_cmd lualatex luatex latexmk pdflatex xelatex)"
	export G_NEX_TEX_BACKEND="$(g_nx_cmd latexmk latexrun tectonic arara)"
	export G_NEX_BIB_BACKEND="$(g_nx_cmd biber bibtex bibparse bibtexparser)"
	export TEXMFHOME="${NEXUS_LIB}/tex"
	export TEXINPUTS="${TEXMFHOME}/sty//://:"
	nx_tex_lua_path && export CLUAINPUTS="${G_NEX_LUA_ROCKS}//://:"
	export LUAINPUTS="${G_NEX_LUA_ROCKS}${G_NEX_LUA_ROCKS:+//:}${NEXUS_LIB}/lua://:"
	unset E_NEX_TEX
}
export E_NEX_TEX=true
nx_tex_gls()
(
	makeglossaries \
		-d "$NEXUS_DOC" \
		-t "$NEXUS_ENV/log/vimtex_gls.log" "$@"
)

nx_tex_lua_path()
{
	h_nx_cmd luatex || return 127
	G_NEX_LUA_ROCKS="$(
		tmpa="$(luatex --luaonly "$NEXUS_LIB/lua/luatex/version.lua")"
		nx_data_path_append -v G_NEX_LUA_ROCKS -s ':' \
			$(h_nx_cmd luarocks && printf '%s' "$HOME/.luarocks/lib/lua/$tmpa") \
			"/usr/lib/lua/$tmpa"
	)"
	test -n "$G_NEX_LUA_ROCKS" && {
		export G_NEX_LUA_ROCKS
		return 0
	} || {
		unset G_NEX_LUA_ROCKS
		return 1
	}
}
nx_tex_export()
{
	export G_NEX_TEX_VIEWER="$(g_nx_cmd zathura mupdf evince skim)"
	export G_NEX_TEX_COMPILER="$(g_nx_cmd lualatex luatex latexmk pdflatex xelatex)"
	export G_NEX_TEX_BACKEND="$(g_nx_cmd latexmk latexrun tectonic arara)"
	export G_NEX_BIB_BACKEND="$(g_nx_cmd biber bibtex bibparse bibtexparser)"
	export TEXMFHOME="${NEXUS_LIB}/tex"
	export TEXINPUTS="${TEXMFHOME}/sty//://:"
	nx_tex_lua_path && export CLUAINPUTS="${G_NEX_LUA_ROCKS}//://:"
	export LUAINPUTS="${G_NEX_LUA_ROCKS}${G_NEX_LUA_ROCKS:+//:}${NEXUS_LIB}/lua://:"
	unset E_NEX_TEX
}
export E_NEX_TEX=true


nx_tty_print()
(
	${AWK:-$(nx_cmd_awk)} \
		-v inpt="$(nx_str_chain "$@")" \
		"
			$(nx_data_include -i "${NEXUS_LIB}/awk/nex-log-extras.awk")
		"'
			BEGIN {
				ln = split(inpt, flds, "<nx:null/>")
				trk["sig"] = "<nx:true/>"
				trk["bg"] = "<nx:false/>"
				for (i = 1; i <= ln; i++) {
					if (sub(/^-/, "", flds[i])) {
						inpt = tolower(flds[i])
						trk["col"] = flds[i]
						if (inpt == "l") {
							nx_ansi_light(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "b") {
							nx_ansi_dark(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "s") {
							nx_ansi_success(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "w") {
							nx_ansi_warning(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "e") {
							nx_ansi_error(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "d") {
							nx_ansi_debug(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "a") {
							nx_ansi_alert(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "i") {
							nx_ansi_info(flds[++i], trk["sig"], trk["bg"] "" trk["col"])
						} else if (inpt == "g") {
							if (flds[i+1] == "-R") {
								trk["bg"] = ""
								i++
							} else {
								nx_boolean(trk, "bg")
							}
						} else if (flds[i] == "c") {
							if (flds[i+1] == "-R") {
								trk["sig"] = ""
								i++
							} else {
								nx_boolean(trk, "sig")
							}
						}
					} else {
						nx_ansi_print(flds[i] "<nx:null/>" flds[i])
					}
				}
				delete flds
			}
		'
)
nx_tty_all()
{
	h_nx_cmd tty stty && test -t 1 && {
		${AWK:-$(nx_cmd_awk)} \
			-v tt="$(stty --all)" \
		"
			$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str.awk")
		"'
			BEGIN {
				gsub(/ = |[\t\n\v\f\r]/, " ", tt)
				tt = split (tt, arr, "; *")
				l = split(arr[tt], flgv, " ")
				do {
					if (sub(/-/, "", flgv[l]))
						v = "<nx:false/>"
					else
						v = "<nx:true/>"
					r = nx_join_str(r, "G_NEX_TTY_" toupper(flgv[l]) "=\x27" v "\x27", " ")
				} while (--l)
				split("", flgv, "")
				while(--tt) {
					if (arr[tt] !~ /^ *$/) {
						nx_pair_str(arr[tt], flgv, " ")
						r = nx_join_str(r, "G_NEX_TTY_" toupper(flgv[flgv[0]]) "=\x27" flgv[flgv[flgv[0]]] "\x27", " ")
					}
				}
				print r
			}
		'
	}
}
