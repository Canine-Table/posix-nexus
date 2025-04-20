#!/bin/sh

g_nx_ios_info()
{
	[ -n "$1" ] && h_nx_cmd ideviceinfo && ideviceinfo | awk -F ': ' '/'"$1"'/{print $2}'
}

nx_ios_mount()
{
	[ -d "$G_NEX_MOD_ENV" ] && h_nx_cmd ifuse ideviceinfo mount && (
		f="$G_NEX_MOD_ENV/$(g_nx_ios_info 'UniqueDeviceID')"
		[ -d "$f" ] || mkdir -p "$f"
		if [ -z "$(mount | ${AWK:-$(nx_cmd_awk)} -v ipath="$f" '/ifuse on/{if ($0 ~ ipath) print }')" ]; then
			ifuse "$f"
		elif [ "$1" = "-u" ]; then
			h_nx_cmd fusermount && fusermount -u "$f" || fusermount -uz "$f" || pkill ifuse || return 3
		fi
	) 
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

nx_ios_update()
{
	[ -d "$G_NEX_MOD_ENV" ] && h_nx_cmd curl ideviceinfo && (
		t="$(g_nx_ios_info 'ProductType')"
		b="$(g_nx_ios_info 'BuildVersion')"
		c="$(g_nx_ios_info 'ProductVersion')"
		u="https://ipsw.me"
		l="$(
			curl -s "$u/$t" | ${AWK:-$(nx_cmd_awk)} -v build="b" "
				$(cat \
					"$G_NEX_MOD_LIB/awk/nex-misc.awk" \
					"$G_NEX_MOD_LIB/awk/nex-struct.awk" \
					"$G_NEX_MOD_LIB/awk/nex-str.awk" \
					"$G_NEX_MOD_LIB/awk/nex-math.awk" \
					"$G_NEX_MOD_LIB/awk/nex-algor.awk"
				)
			"'
				/\/download\//{
					if ($0 !~ build) {
						arrb["onclick="] = ""
						nx_vector($0, arra, " ", "", 0, arrb)
						for (j = 1; j <= arra[0]; j++) {
							if (arra[j] ~ /\/download\//)
								break
						}
						m = arra[j]
						__nx_quote_map(arra)
						j = nx_next_pair(m, arra, arrb)
						print substr(m, arrb[j] + arrb[arrb[j] "_" j], arrb[j + 1])
						delete arra
						delete arrb
					}
					exit
				}
			' | sed 's/download/install/1' || exit 3
		)" || return
		[ -n "$l" ] && {
			udid="$(g_nx_ios_info 'UniqueDeviceID')"
			f="$G_NEX_MOD_ENV/${udid}_firmware"
			d="$(basename "$l")"
			[ -d "$f" ] || mkdir -p "$f"
			[ -f "$f/$d" ] || {
				echo "Downloading firmware..."
				curl "$(
					curl "$u$l" | ${AWK:-$(nx_cmd_awk)} -v ver="$d" '/'"$d"'.*ipsw/{
						l = split($0, arra, "[\x22|\x27]")
						for (i = 1; i <= l; i++) {
							if (arra[i] ~ ver ".*ipsw")
								break
						}
						print arra[i]
						delete arra
						exit
					}'
				)" -o "$f/$d"
			}
			h_nx_cmd idevicerestore && {
				echo "Initiating firmware installation..."
				idevicerestore -u "$udid" "$f/$d" || echo "Error: Failed to extract firmware download link."
			} || echo "Error: idevicerestore not found. Please install it first."
		}
	)
}

