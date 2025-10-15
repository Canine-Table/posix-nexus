

#nx_dev_by()
#{

#}


nx_dev_usbguard()
{
	h_nx_cmd usbguard && {
		nx_io_printf -E 'usbguard not found in path' 1>&2
		exit 192
	}
	while test "$#" -gt 0; do
		case "$1" in
			-g) {
				nx_io_type -f "$2" r -a Dodx
			};;
		esac
		shift
	done
}

