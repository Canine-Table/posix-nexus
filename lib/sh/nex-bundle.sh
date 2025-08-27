#!/bin/sh

nx_init_env()
{
	tmpa="$(basename "$0")"
	tmpb="$("${AWK:-awk}" -v path="$(cd "$(dirname "$0")" && pwd)/${tmpa}" 'BEGIN {
		if (sub("lib/sh/.+[.]sh$", "", path)) {
			print path
		} else {
			printf("\x1b[1;31m[x] Please make sure the initiator file is executable before proceeding.\x1b[0m");
			exit 1
		}
	}')" || {
		printf '%s\n' "$tmpb"
		exit 1
	}
	cat > "${tmpb}env/.nexus-shell.bundle.sh" <<- EOF
		#!${SHELL:-$(command -v sh)}
		export NEXUS_ROOT="$tmpb"
		export NEXUS_SRC="${tmpb}src"
		export NEXUS_LIB="${tmpb}lib"
		export NEXUS_ENV="${tmpb}env"
		export NEXUS_CNF="${tmpb}cnf"
		export NEXUS_DOC="${tmpb}docs"
		export NEXUS_LOG="${tmpb}env"
		nx_cnf_export()
		{
			for tmpa in "\${NEXUS_CNF}/nex-export.cnf" "\${NEXUS_CNF}/nex-alias.cnf"; do
				test -f "\$tmpa" -a -r "\$tmpa" && . "\$tmpa"
			done
		}
	EOF
	for tmpc in "${tmpb}lib/sh/"*".sh"; do
		! [ "$tmpc" = "${tmpb}lib/sh/${tmpa}" ] \
		&& [ -r "$tmpc" ] \
		&& cat "$tmpc"
	done 2> /dev/null | tee "${tmpb}env/.nexus-shell.bundle" | \
	awk -v inpt="${tmpb}env/.nexus-shell.bundle" "
		$(cat \
			"${tmpb}lib/awk/nex-misc.awk" \
			"${tmpb}lib/awk/nex-struct.awk" \
			"${tmpb}lib/awk/nex-log.awk" \
			"${tmpb}lib/awk/nex-json.awk" \
			"${tmpb}lib/awk/nex-str.awk" \
			"${tmpb}lib/awk/nex-math.awk"
		)
	"'
		{
			if (s = nx_include($0, "#nx_include", inpt, arr))
				print s
		} END {
			delete arr
		}
	' >> "${tmpb}env/.nexus-shell.bundle.sh"
	rm "${tmpb}env/.nexus-shell.bundle"
	printf '%s' "${tmpb}env/.nexus-shell.bundle.sh"
}

nx_init_env

