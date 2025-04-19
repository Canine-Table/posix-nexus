#!/bin/sh

nx_libimobiledevice_install()
{
	has_cmd libimobiledevice usbmuxd idevicerestore ||
		get_pkgmgr -i libimobiledevice usbmuxd idevicerestore ||
		return 2
}

