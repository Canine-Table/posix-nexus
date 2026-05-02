#!/bin/sh

nx_fs_mount --run --command-prefix 'sudo' \
	--source-prefix "$NEXUS_LIB/php/wp/posix-nexus/assets" \
	--destination-prefix "$NEXUS_LIB" \
	--source 'css' \
	--destination 'css' \
	--mount \
	--source 'mjs' \
	--destination 'mjs' \
	--mount \
	--source 'wasm' \
	--destination 'wasm' \
	--mount \
	--source 'glsl' \
	--destination 'glsl' \
	--mount \
	--source 'svg' \
	--destination 'svg' \
	--mount \
	--source 'img' \
	--destination '../img' \
	--mount \
	--source-prefix "${NEXUS_WP:-/srv/wordpress}/wp-content/themes/" \
	--destination-prefix "$NEXUS_LIB/php/wp/posix-nexus" \
	--source 'posix-nexus' \
	--destination '.' \
	--mount

(
	tmpa="$NEXUS_LIB/php/wp/posix-nexus/.nx-path"
	printf '' >> "$tmpa"
	read < "$tmpa"
	test -p "$REPLY" || {
		nx_io_evlp > "$tmpa"
	}
)

