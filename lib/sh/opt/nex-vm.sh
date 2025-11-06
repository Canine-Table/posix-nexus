
nx_vm_iso()
{
	while test "$#" -gt 0; do
		${AWK:$(nx_cmd_awk)} -v fn="$1" '
			BEGIN {
				if (fl ~ /ISO 9660 CD-ROM filesystem|ext[234] filesystem data|FAT filesystem|ISOHybrid/ || fl ~ /x86 boot sector/ && fl ~ /ISO 9660/)
					exit 0
				else
					exit 1
			}
		}' || return 1
		shift
	done
}

nx_vm_extract()
(
	eval "$(nx_str_optarg ':i:e:' "$@")"
	test -z "$i" -o ! -e "$i" && {
		nx_io_printf -E "$i isnt a fike we can work with" 1>&2
		exit 1
	}
	nx_vm_iso "$i" || {
		nx_io_printf -E "$i isnt mountable" 1>&2
		exit 2
	}
	tmpa="$(nx_io_noclobber -p "$NEXUS_ENV/$(nx_str_rand 8)")"
	mkdir -p "$tmpa" || {
		nx_io_printf -E "$tmpa failed to be created" 1>&2
		exit 3
	}
	nx_info_file -f "$e" dw || e="$(nx_io_noclobber -p "$NEXUS_ENV/$i-$(nx_str_rand 8)")"
	mkdir -p "$e" || test -e "$e" || {
		nx_io_printf -E "$e failed to be created" 1>&2
		exit 4
	}
	mount -o loop "$i" "$tmpa"
	find "$tmpa" -name '*vmlinuz*' -exec cp '{}' "$e" \;
	find "$tmpa" -name '*initrd*' -exec cp '{}' "$e" \;
	umount "$tmpa"
	rmdir "$tmpa"
)

nx_vm_extract_libvirt()
{
	mkdir -p '/var/lib/libvirt/images/'
	nx_vm_extract -i "$1" -e '/var/lib/libvirt/images/'
}

#mount -o loop /srv/vm/soaring-phoenix/iso/ubuntu-25.10-live-server-amd64.iso

