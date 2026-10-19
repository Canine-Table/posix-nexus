#!/bin/sh

nx_bundle_init()
(
	test "$(command -v "${0#-}")" != "$SHELL" && {
		bnm="$(basename "$0")"
		dnm="$("${AWK:-awk}" -v path="$(cd "$(dirname "$0")" && pwd)/${bnm}" 'BEGIN {
			if (!sub("lib/sh/.+[.]sh$", "", path))
				exit 226
			gsub("//", "/", path)
			printf("%s", path)
		}')"
	} || {
		printf '\x1b[1;31m[x] Please make sure the initiator file is executable before proceeding\x1b[0m\n' "$1" 2>&1
		exit 226
	}

	export NEXUS_LIB="${dnm}lib"
	. "$NEXUS_LIB/sh/nex-cmd.sh"
	. "$NEXUS_LIB/sh/nex-data.sh"
	. "$NEXUS_LIB/sh/nex-str.sh"
	. "$NEXUS_LIB/sh/nex-tty.sh"
	. "$NEXUS_LIB/sh/nex-fs2.sh"
	. "$NEXUS_LIB/sh/nex-fs.sh"

	export AWK="$(nx_cmd_awk)"
	export NEXUS_BUNDLE="${dnm}lib/sh/$bnm"

	nx_fs2_install \
		--mode 755 \
		--prefix "$dnm" \
		--target src \
		--target docs \
		--target bin \
		--target cnf \
		--target env \
		--prefix "$HOME/.nx/" \
		--target csr \
		--target ssl \
		--target kdbx \
		--target db \
		--prefix "${dnm}env/" \
		--target log \
		--target run \
		--target cache \
		--target nnn \
		--target vim \
		--target ssl \
		--target bak \
		--mode 777 \
		--target tmp

	cat > "${dnm}env/.nexus-shell.bundles.sh" <<- EOF
		#!${SHELL:-"$(command -v sh)"}
		export NEXUS_ROOT="$dnm"
		export NEXUS_SRC="${dnm}src"
		export NEXUS_LIB="${dnm}lib"
		export NEXUS_ENV="${dnm}env"
		export NEXUS_CNF="${dnm}cnf"
		export NEXUS_DOC="${dnm}docs"
		export NEXUS_LOG="${dnm}env"
		export NEXUS_SBIN="${dnm}sbin"
		export NEXUS_BIN="${dnm}bin"
		export NEXUS_TEST="${dnm}/tests"
		export NEXUS_INIT="${dnm}lib/sh/nex-init"
		export NEXUS_BUNDLE="$NEXUS_BUNDLE"
	EOF

	for tmpc in "${dnm}lib/sh/"*".sh"; do
		test ! "$tmpc" = "${dnm}lib/sh/${bnm}" -a  -r "$tmpc" && {
			tmpe="$tmpe<nx:null/>$tmpc"
			cat "$tmpc"
		}
	done 2> /dev/null 1> "${dnm}env/.nexus-shell.bundles"

	nx_data_include \
		--truncate \
		--verbose 1 \
		--method 2 \
		--directive 'nx_include' \
		--comment-start ":<<-'NX'" \
		--comment-end 'NX' \
		--lib-root "${dnm}lib" \
		--sigil '#' \
		--list-separator '<nx:null/>' \
		--file-separator '/' \
		--separator ',' \
		--input "${dnm}env/.nexus-shell.bundles" \
	>> "${dnm}env/.nexus-shell.bundles.sh"
	rm "${dnm}env/.nexus-shell.bundles"
	printf '%s' "${dnm}env/.nexus-shell.bundles.sh" | tee "$HOME/.nx/.nx-root"
)

test "$1" = '-d' && set -x
if test "$(command -v time)" = 'time'; then
	time nx_bundle_init
else
	nx_bundle_init
fi
test "$1" = '-d' && set +x

