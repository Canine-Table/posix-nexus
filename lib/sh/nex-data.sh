#nx_include nex-str.sh
#nx_include nex-cmd.sh

nx_data_ref()
{
	test -n "$1" && eval "printf \$$1" 2> /dev/null
}

nx_data_ref_append()
(
	nx_data_optargs 'v:d@s:' "$@"
	NEX_k_v="$(nx_data_ref "$NEX_k_v")" || exit 65
	test -n "$NEX_k_v" -a -n "$NEX_K_d" && tmpa="${NEX_k_v}${NEX_k_s:-<nx:null/>}"
	printf '%s' "$tmpa$NEX_K_d"
)

nx_data_unset()
{
	while test "$#" -gt 0; do
		unset "$1"
		shift
	done 2>&1 1>/dev/null
}

_nx_data_unset()
{
	eval "$(while read -r; do
		nx_data_ref "$REPLY" | grep -q '.*' && printf 'unset %s;' "$REPLY"
	done)"
}

_nx_data_unset_()
{
	nx_data_unset "$@"
	_nx_data_unset
}

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

nx_data_longopt()
{
	eval "$(${AWK:-$(nx_cmd_awk)} \
		-v inpt="$(nx_str_chain "$@")" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-shell.awk")
	"'
		BEGIN {
			p["-u"] = ""
			pstr = " u<unset>"

			p["-q"] = "<nx:false/>"
			pstr = pstr "q<quote>"

			p["-o"] = "<nx:false/>"
			pstr = pstr "o<override type-override>"

			p["-e"] = "<nx:false/>"
			pstr = pstr "e<export>"

			p["-b"] = "<nx:false/>"
			pstr = pstr "b<backtrack>"

			p["-a"] = "0"
			pstr = pstr "a<abort>"

			p["-v"] = "1"
			pstr = pstr "v<verbose>"

			p["-f"] = "0"
			pstr = pstr "f<force-group>"

			p["-d"] = ","
			pstr = pstr "d<%delimiter delimiter-separator>"

			p["-k"] = "%"
			pstr = pstr "k<%key key-separator>"

			p["-g"] = "<"
			pstr = pstr "g<%open group-open>"

			p["-G"] = ">"
			pstr = pstr "G<%close group-close>"

			p["-F"] = "@"
			pstr = pstr "F<%flag-array flag-array-separator>"

			p["-K"] = "#"
			pstr = pstr "K<%key-array key-array-separator>"

			p["-l"] = " "
			pstr = pstr "l<%long>"

			p["-s"] = ";"
			pstr = pstr "s<%short>"

			p["-p"] = "<nx:null/>"
			pstr = pstr "p<%param parameter-separator>"

			p["-S"] = "="
			pstr = pstr "S<%flag-set>"

			p["-A"] = "+"
			pstr = pstr "A<%add flag-add>"

			p["-R"] = "-"
			pstr = pstr "R<%remove flag-remove>"

			p["-c"] = " "
			pstr = pstr "c<%concat concatenation-separator>"

			p["-L"] = "._-:"
			pstr = pstr "L<%extra-long-characters>"

			s = p["-d"]
			seps = p["-k"] s p["-F"] s p["-K"] s p["-g"] s p["-G"] s p["-l"] s p["-s"] s p["-L"]
			acts = p["-p"] s p["-S"] s p["-A"] s p["-R"] ds p["-c"]
			togs = p["-v"] s (p["-o"] == "<nx:true/>") s (p["-b"]  == "<nx:true/>") s (p["-e"]  == "<nx:true/>") s (p["-q"] == "<nx:true/>") s p["-f"] s 2
			nx_shell_args(pstr p["-p"] inpt, arr, s, togs, acts, seps)
			ln = arr["-0"]
			for (idx = -4; idx >= ln; idx = idx - 3)
				p[arr[idx]] = arr[idx - 2]

			if (arr["-3"] > 0) {
				s = p["-d"]
				r = arr["-2"]
				split("", arr, "")
				seps = p["-k"] s p["-F"] s p["-K"] s p["-g"] s p["-G"] s p["-l"] s p["-s"] s p["-L"]
				acts = p["-p"] s p["-S"] s p["-A"] s p["-R"] ds p["-c"]
				togs = p["-v"] s (p["-o"] == "<nx:true/>") s (p["-b"]  == "<nx:true/>") s (p["-e"]  == "<nx:true/>") s (p["-q"] == "<nx:true/>") s p["-f"] s p["-a"]
				print nx_shell_environ(r, arr, s, togs, acts, seps)
			}
			delete arr
		}
	')"
}

nx_data_longopts()
(
	ds=',' ks='%' fas='@' kas='#' go='<' gc='>' lo=' ' lc=';'
	ps='<nx:null/>' fs='=' fa='+' fr='-' con=' '
	vb='1' ovr='0' bk='0' qt='0' ex='0' gfr='0' ab='0'
	us=''

	while test "$#" -gt 1; do
		case "$1" in
			-u|--unset) {
				us="$2"
			};;

			-a|--abort) {
				ab="$2"
			};;

			-q|--quote) {
				qt="$2"
			};;

			-e|--export) {
				ex="$2"
			};;

			-o|--override|--type-override) {
				ovr="$2"
			};;

			-d|--delimiter|--delimiter-separator) {
				ds="$2"
			};;

			-b|--backtrack) {
				bk="$2"
			};;

			-k|--key|--key-separator) {
				ks="$2"
			};;

			-F|--flag-array|--flag-array-separator) {
				fas="$2"
			};;

			-K|--key-array|--key-array-separator) {
				kas="$2"
			};;

			-g|--open|--group-open) {
				go="$2"
			};;

			-G|--close|--group-close) {
				gc="$2"
			};;

			-f|--force-group) {
				gfr="$2"
			};;

			-l|--long) {
				lo="$2"
			};;

			-s|--short) {
				lc="$2"
			};;

			p-|--param|--parameter-separator) {
				ps="$2"
			};;

			-S|--flag-set) {
				fs="$2"
			};;

			-A|--add|--flag-add) {
				fa="$2"
			};;

			-R|--remove|--flag-remove) {
				fr="$2"
			};;

			-c|--concat|--concatenation-separator) {
				con="$2"
			};;

			-v|--verbose) {
				vb="$2"
			};;

			--) {
				shift
				break
			};;

			*) {
				break
			};;
		esac
		shift 2
	done

	${AWK:-$(nx_cmd_awk)} \
		-v sep="$ds" \
		-v seps="$ks$ds$fas$ds$kas$ds$go$ds$gc$ds$lo$ds$lc" \
		-v acts="$ps$ds$fs$ds$dsa$ds$dsr$ds$con" \
		-v togs="$vb$ds$ovr$ds$bk$ds$ex$ds$dq$ds$gfr$ds$ab" \
		-v inpt="$(nx_str_chain "$@")" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-shell.awk")
	"'
		BEGIN {
			if (! (err = nx_shell_environ(inpt, arr, sep, togs, acts, seps)) < 2) {
				print err
				err = 0
			}
			delete arr
			exit -err
		}
	'
)

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
	lstsp='<nx:null/>'
	dir='nx_include'
	sig='#' sep=',' vb='1'
	inpt='' extsp='' exfl=''
	mth='2' rt='' flsp='/'
	gtln='' trnk=''
	scmnt=":<<-'NX'" ecmnt='NX'

	while test "$#" -gt 1; do
		case "$1" in
			-i|--input) {
				tmpa="$(nx_data_dir "$2")" && inpt="$tmpa/$(basename "$2")"
			};;

			-x|--exclude) {
				tmpa="$(nx_data_dir "$2")" && exfl="$exfl${exfl:+$ps}$tmpa/$(basename "$2")"
			};;

			-g|--getline-method) {
				gtln="$2"
			};;

			-S|--separator) {
				sep="$2"
			};;

			-l|--list-separator) {
				lstsp="$2"
			};;

			-f|--file-separator) {
				flsp="$2"
			};;

			-s|--sigil) {
				sig="$2"
			};;

			-e|--extention-separator) {
				extsp="$2"
			};;

			-r|--lib-root) {
				tmpa=""$(nx_data_dir "$2")
				test "$?" != 66 && rt="$tmpa"
			};;

			-v|--verbose) {
				vb="$2"
			};;

			-m|--method) {
				mth="$2"
			};;

			-T|--no-truncate) {
				trnk='0'
				shift
				continue
			};;

			-t|--truncate) {
				trnk='1'
				shift
				continue
			};;

			-d|--directive) {
				dir="$2"
			};;

			-c|--comment-start) {
				scmnt="$2"
				ecmnt="$2"
			};;

			-C|--comment-end) {
				ecmnt="$2"
			};;

			*) {
				break
			};;
		esac
		shift 2
	done

	test -z "$inpt" -a "$#" -gt 0 && {
		tmpa="$(nx_data_dir "$1")" && inpt="$tmpa/$(basename "$1")" || return 227
		shift
	}

	rt="$(nx_data_dir "${rt:-$NEXUS_LIB}")"
	test "$?" -eq 66 && return 228

	${AWK:-$(nx_cmd_awk)} \
		-v inpt="$inpt" \
		-v exfl="$exfl" \
		-v sep="$sep" \
		-v seps="$lstsp$sep$sig$sep$flsp$sep$extsp$sep$dir$sep$scmnt$sep$ecmnt" \
		-v flgs="$mth$sep$vb$sep$trnk$sep$gtln" \
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
			nx_file_merge(inpt, exfl, sep, seps, flgs)
		}
	'
)

nx_data_path_append()
(
	nx_data_optargs 'v:s:' "$@"
	${AWK:-$(nx_cmd_awk)} \
		-v val="$(nx_data_ref "$NEX_k_v")" \
		-v sep="${NEX_k_s:-<nx:null/>}" \
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

