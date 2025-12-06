#!/bin/sh

nx_err()
{
	printf '\x1b[1;31m[x] %s\x1b[0m\n' "$1" 2>&1
}

nx_success()
{
	printf '\x1b[1;32m[v] %s\x1b[0m\n' "$1" 2>&1
}

nx_init_install()
{
	u=6
	g=4
	o=4
	U=7
	G=5
	O=5
	a="$(whoami)"
	A="$a"
	c=""
	while test "$#" -gt 0; do
		case "$1" in
			-c|-C) {
				test $1 "-C" && c="" || b="1"
			};;
			-b) {
				test -d "$2" && b="$2"
				shift
			};;
			-a|-A) {
				eval "$(printf '%s' "$1" | cut -d '-' -f 2)"="$2"
				shift
			};;
			-u|-g|-o|-U|-G|-O) {
				if awk -v prm="$2" 'BEGIN{if(perm >= 0 && perm <= 7){exit 0}else{exit 1}}'; then
					eval "$(printf '%s' "$1" | cut -d '-' -f 2)"="$2"
					shift
				else
					nx_err "expected an octal number,  received $1."
				fi
			};;
			*) {
				test -d "$b$1" || {
					test -e "$b$1" && {
						while :; do
							tmpd="$b$1-$(date '+%s').bak"
							test -e "$tmpd" || break
						done
						mv "$b$1" "$tmpd" || {
							nx_err "The path to '$1' must be either be a directory or a path that does not yet exist, manual intervention required."
							exit 2
						}
					}
					mkdir -p "$b$1" || {
						nx_err "The path to '$1' could not be created, manual intervention required."
						exit 3
					}
					nx_success "$b$1 was created"
				}
				test -n "$c" && {
					chmod "$U$G$O" "$b$1"
					chown "$a:$A" "$b$1"
				}
			};;
		esac
		shift
	done
}

nx_env()
(
	tmpa="$(basename "$0")"
	tmpb="$("${AWK:-awk}" -v path="$(cd "$(dirname "$0")" && pwd)/${tmpa}" 'BEGIN {
		if (sub("lib/sh/.+[.]sh$", "", path)) {
			gsub("//", "/", path)
			print path
		} else {
			printf("\x1b[1;31m[x] Please make sure the initiator file is executable before proceeding.\x1b[0m")
			exit 1
		}
	}')" || {
		printf '%s\n' "$tmpb"
		exit 1
	}

	cat > "${tmpb}env/.nexus-shell.bundles.sh" <<- EOF
		#!${SHELL:-$(command -v sh)}
		export NEXUS_ROOT="$tmpb"
		export NEXUS_SRC="${tmpb}src"
		export NEXUS_LIB="${tmpb}lib"
		export NEXUS_ENV="${tmpb}env"
		export NEXUS_CNF="${tmpb}cnf"
		export NEXUS_DOC="${tmpb}docs"
		export NEXUS_LOG="${tmpb}env"
		export NEXUS_SBIN="${tmpb}sbin"
		export NEXUS_BIN="${tmpb}bin"
	EOF
	tmpc="${tmpb}cnf/.nex-rc"
	test -f "$tmpc" -a -r "$tmpc" && printf 'export ENV="%s"\n' "${tmpc}" >> "${tmpb}env/.nexus-shell.bundles.sh"
	umask 022
	nx_init_install -o 0 -O 0 -b "$tmpb" cnf env src docs bin sbin img -b "$HOME/" ".nx/ssl" ".nx/csr"
	for tmpc in "${tmpb}lib/sh/"*".sh"; do
		test ! "$tmpc" = "${tmpb}lib/sh/${tmpa}" -a  -r "$tmpc" && {
			tmpe="$tmpe<nx:null/>$tmpc"
			cat "$tmpc"
		}
	done 2> /dev/null 1> "${tmpb}env/.nexus-shell.bundles"
	. "${tmpb}lib/sh/nex-cmd.sh"
	export AWK="$(nx_cmd_awk)"
	. "${tmpb}lib/sh/nex-data.sh"
	nx_data_include -t \
		-r "${tmpb}lib" \
		-s "#" \
		-d "include" \
		-i "${tmpb}env/.nexus-shell.bundles" \
	>> "${tmpb}env/.nexus-shell.bundles.sh"
	rm "${tmpb}env/.nexus-shell.bundles"
	printf '%s' "${tmpb}env/.nexus-shell.bundles.sh" | tee "$HOME/.nx/.nx-root"
)

test "$1" = '-d' && set -x
if test "$(command -v time)" = 'time'; then
	time nx_env
else
	nx_env
fi
test "$1" = '-d' && set +x

