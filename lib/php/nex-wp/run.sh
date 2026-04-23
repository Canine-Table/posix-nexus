nx_fs_mount \
	-r \
	-c 'sudo' \
	-p "$NEXUS_LIB/php/nex-wp" \
	-P "$NEXUS_LIB" \
	-L 'css' -l 'css/css' -m \
	-L 'mjs' -l 'mjs/mjs' -m \
	-L '../img' -l 'img/img' -m \
	-p '/srv/wordpress/wp-content/themes/' \
	-P "$NEXUS_LIB/php/nex-wp" \
	-l 'nex' -L '.' -m

