
set_vm_vbox()
{
	has_vm_vbox 2>&1 && {
		get_pkgmgr -i \
			phpvirtualbox \
			libvirt \
			virtualbox \
			virtualbox-ext-vnc \
			virtualbox-guest-iso \
			virtualbox-guest-utils \
			virtualbox-host-dkms \
			virtualbox-sdk wget || return
		case "$(cat /etc/os-release | awk -F '"' '$1=="NAME="{print $2; exit}')" in
			'Arch Linux')
				{
					get_pkgmgr -i \
						virtualbox-host-modules-arch || return
				};;
		esac
		! [ -e '/dev/vboxdrv' ] && {
			modprobe vboxdrv
		}
		(
			VBOX_VERSION="$(vboxmanage -v | cut -d 'r' -f '1')"
			command -v wget 1>/dev/null 2>&1 && {
				wget "https://download.virtualbox.org/virtualbox/$VBOX_VERSION/Oracle_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack"
				vboxmanage extpack install Oracle_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack
				rm Oracle_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack
			}
		)
	}
}

get_vm_lst()
{
	has_vm_vbox && (
		case "$1" in
			'-rv') tmp='runningvms';;
			'-cp') tmp='cpu-profiles';;
			'-ds') tmp='dhcpservers';;
			'-dvd') tmp='dhcpservers';;
			'-os') tmp='ostypes';;
			'-net') tmp='ostypes';;
			*) tmp='vms';;
		esac
		shift
		VBoxManage list "$tmp"
		[ ${#@} -gt 0 ] && {
			get_vm_lst $@
		}
	)
}

has_vm_vbox()
{
	command -v vboxmanage 1>/dev/null 2>&1
}

