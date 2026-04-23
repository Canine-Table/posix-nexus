#!/bin/sh

nx_fs_mount \
	-r \
	-c 'sudo' \
	-p "$NEXUS_LIB/php/nex-wp/" \
	-l 'css/css' -M \
	-l 'mjs/mjs' -M \
	-l 'img/img' -M
