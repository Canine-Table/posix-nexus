#nx_include nex-data.sh
#nx_include nex-str.sh
#nx_include nex-cmd.sh

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

