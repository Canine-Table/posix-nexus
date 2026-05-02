#!/bin/sh

nx_fs_mount --run --command-prefix 'sudo' \
	--source-prefix "$NEXUS_LIB/php/wp/posix-nexus/assets" \
	--source 'css' \
	--umount \
	--source 'mjs' \
	--umount \
	--source 'wasm' \
	--umount \
	--source 'glsl' \
	--umount \
	--source 'svg' \
	--umount \
	--source 'img' \
	--umount \
	--source-prefix "$NEXUS_LIB/php/wp/posix-nexus" \
	--source 'posix-nexus' \
	--umount

(
	tmpa="$NEXUS_LIB/php/wp/posix-nexus/.nx-path"
	printf '' >> "$tmpa"
	G_NEX_TTOU=''
	G_NEX_TTIN=''
	read < "$tmpa"
	eval "$REPLY"
	test -p "$G_NEX_TTIN" && {
		printf '%s' 'EXIT' > "$G_NEX_TTIN"
	}
	printf '%s' '' > "$tmpa"
) 2> /dev/null

