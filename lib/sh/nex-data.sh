#nx_include nex-str.sh
#nx_include nex-cmd.sh

nx_data_ref()
{
	test -n "$1" && eval "printf \$$1"
}

nx_data_ref_append()
(
	nx_data_optargs 'v:d@s:' "$@"
	NEX_k_v="$(nx_data_ref "$NEX_k_v")" || exit 65
	test -n "$NEX_k_v" -a -n "$NEX_K_d" && tmpa="${NEX_k_v}${NEX_k_s:-<nx:null/>}"
	printf '%s' "$tmpa$NEX_K_d"
)

nx_data_compare()
(
	nx_data_optargs 'l@r@m:s:c' "$@"
	${AWK:-$(nx_cmd_awk)} \
		-v lft="$NEX_K_l" \
		-v rgt="$NEX_K_r" \
		-v mde="$NEX_k_m" \
		-v sep="$NEX_k_s" \
		-v cnt="$NEX_f_c" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct-extras.awk")
	"'
		BEGIN {
			split(lft, larr, "<nx:null/>")
			nx_arr_flip(larr)
			split(rgt, rarr, "<nx:null/>")
			nx_arr_flip(rarr)
			split("", arr, "")
			nx_arr_compare(larr, rarr, arr, mde, sep, __nx_if(cnt != "<nx:true/>", 2, 3))
			delete larr
			delete rarr
			rgt = 0
			if (cnt != "<nx:true/>") {
				for (lft in arr) {
					gsub("\x27", "\\\\x27", lft)
					if (rgt++)
						printf(" \\\n\x27%s\x27", lft)
					else
						printf("\x27%s\x27", lft)
				}
				printf("; # Nex is done here!\n")
			} else {
				print arr[0]
			}
			delete arr
		}
	'
)

nx_data_optargs()
{
	eval "$(
		${AWK:-$(nx_cmd_awk)} \
			-v inpt="$(nx_str_chain "$@")" \
			"
				$(nx_data_include -i "${NEXUS_LIB}/awk/nex-sh-extras.awk")
			"'
				BEGIN {
					print nx_sh_optargs(inpt)
				}
			'
	)"
}

nx_data_dir()
{
	test -e "$1" || return 66 && {
		test -d "$1" && {
			printf '%s' "$(cd "$1" && pwd)"
			return 196
		} || {
			printf '%s' "$(cd $(dirname "$1") && pwd)"
		}
	}
}

nx_data_include()
(
	while :; do
		case "$1" in
			-t) {
				case "$2" in
					-*) {
						trm=' \\t'
					};;
					*) {
						trm="$2"
						shift
					};;
				esac

			};;
			-l) {
				lvl="$2"
				shift
			};;
			-d) {
				dir="$2"
				shift
			};;
			-s) {
				sig="$2"
				shift
			};;
			-i) {
				inpt="$2"
				shift
			};;
			-r) {
				rt="$2"
				shift
			};;
			-e) {
				ext="$2"
				shift
			};;
			*) {
				break
			};;
		esac
		shift
	done
	test -z "$inpt" && {
		inpt="$1"
		shift
	}
	rt="${rt:-$NEXUS_LIB}"
	${AWK:-$(nx_cmd_awk)} \
		-v inpt="$(nx_data_dir "$inpt")/$(basename "$inpt")" \
		-v exc="$ext" \
		-v trm="$trm" \
		-v lvl="$lvl" \
		-v sig="$sig" \
		-v dir="$dir" \
	"
		$(cat \
			"${rt}/awk/nex-misc.awk" \
			"${rt}/awk/nex-struct.awk" \
			"${rt}/awk/nex-io.awk" \
			"${rt}/awk/nex-int.awk" \
			"${rt}/awk/nex-log.awk" \
			"${rt}/awk/nex-str.awk"
		)
	"'
		BEGIN {
			nx_file_merge(inpt, exc, lvl, trm, sig, dir)
		}
	'
)

nx_data_path_append()
(
	nx_data_optargs 'v:s:' "$@"
	NEX_k_v="$(nx_data_ref "$NEX_k_v")" || exit 65
	test -n "$NEX_k_v" -a -n "$NEX_K_d" && tmpa="${NEX_k_v}${NEX_k_s:-<nx:null/>}"
	${AWK:-$(nx_cmd_awk)} \
		-v val="$NEX_k_v" \
		-v sep="$NEX_k_s" \
		-v str="$NEX_R" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct.awk")
	"'
		BEGIN {
			nx_trim_split(str, strs, "<nx:null/>")
			strs["b4"] = 1
			for (i = 1; i <= strs[0]; ++i) {
				if (sub(/^-/, "", strs[i])) {
					if (strs[i] == "a")
						strs["b4"] = 0
					else
						strs["b4"] = 1
				} else if (sep val sep !~ sep strs[i] sep) {
					if (strs["b4"])
						val = nx_join_str(val, strs[i], sep)
					else
						val = nx_join_str(strs[i], val, sep)
				}
			}
			delete strs
			if (val)
				print val
			else
				exit 1
		}
	'
)

nx_data_word()
(
	nx_data_optargs 'k@p' "$@"
	${AWK:-$(nx_cmd_awk)} \
		-v str="$NEX_S" \
		-v sep="$NEX_K_k" \
		-v phdr="${NEX_f_p:+<nx:null/><nx:placeholder/>}" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct-extras.awk")
	"'
		BEGIN {
			if (! sep) {
				dlm["\x22"] = "\x22"
				dlm["\x27"] = "\x27"
				dlm["\x60"] = "\x60"
				dlm["\x09"] = ""
				dlm["\x20"] = ""
			}
			nx_find_pair(str, mth, dlm, sep __nx_only(sep, phdr))
			delete dlm
			for (i = 5; i <= mth[mth[0]]; i += mth[0]) {
				if (mth[i + 2] == "0")
					print substr(str, 1, mth[i] - 1)
				else
					print substr(str, mth[i] + mth[i + 1], mth[i + 2])
			}
			delete mth
		}
	'
)

nx_data_match()
(
	nx_data_optargs 'o@v:bli' "$@"
	${AWK:-$(nx_cmd_awk)} \
		-v str="${NEX_k_v:-$NEX_S}" \
		-v opt="$NEX_K_o" \
		-v bnd="${NEX_f_b:-'<nx:false/>'}" \
		-v ln="${NEX_f_l:-'<nx:false/>'}" \
		-v cse="${NEX_f_c:-'<nx:false/>'}" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct-extras.awk")
	"'
		BEGIN {
			nx_trim_split(opt, opts, "<nx:null/>")
			if (cse == "<nx:true/>")
				str = tolower(str)
			if ((str = nx_option(str, opts, res, bnd == "<nx:true/>", ln == "<nx:true/>")) != -1) {
				print str
				str = 0
			} else {
				str = 1
			}
			delete res
			delete opts
			exit str
		}
	'
)

