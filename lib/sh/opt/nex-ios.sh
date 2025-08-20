#!/bin/sh

g_nx_ios_info()
{
	[ -n "$1" ] && h_nx_cmd ideviceinfo && ideviceinfo | awk -F ': ' '/'"$1"'/{print $2}'
}

nx_ios_mount()
{
	h_nx_cmd ifuse ideviceinfo mount && {
		tmpa="${NEXUS_ENV}/$(g_nx_ios_info 'UniqueDeviceID')"
		test -d "$tmpa" || mkdir -p "$tmpa" || return
		if test -z "$(mount | ${AWK:-$(nx_cmd_awk)} -v ipath="$tmpa" '/ifuse on/{if ($0 ~ ipath) print }')"; then
			ifuse "$tmpa"
		elif test "$1" = "-u"; then
			h_nx_cmd fusermount && fusermount -u "$tmpa" || fusermount -uz "$tmpa" || pkill ifuse || return 3
		fi
	}
}

nx_ios_validate()
{
	h_nx_cmd idevicepair && idevicepair validate && {
		[ "$1" = '-m' ] && {
			nx_ios_mount -u
			nx_ios_mount
		}
	}
}

