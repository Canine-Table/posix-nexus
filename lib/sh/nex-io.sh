#nx_include nex-data.sh

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

