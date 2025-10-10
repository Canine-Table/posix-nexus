
nx_mnt_chroot()
(
	eval "$(nx_str_optarg ':t:c' "$@")"
	t="$(nx_info_path -p "$t")" || t='/mnt'
	test "$c" = '<nx:false/>' && {
		umount -l "$t/dev/shm" "$t/dev/pts"
		umount -R "$t"
		exit
	}

	mount --types proc /proc "$t/proc"
	mount --rbind /sys "$t/sys"
	mount --make-rslave "$t/sys"
	mount --rbind /dev "$t/dev"
	mount --make-rslave "$t/dev"
	mount --bind /run "$t/run"
	mount --make-slave "$t/run"
	
	test -d "$t/tmp" && chmod 1777 "$t/tmp"
	test -h /dev/shm && rm /dev/shm && mkdir /dev/shm
	mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm 
	chmod 1777 /dev/shm /run/shm

	test "$c" = '<nx:true/>' && {
		export G_NEX_MNT_CHROOT='<nx:true/>'
		chroot "$t" "$SHELL"
	}
)

