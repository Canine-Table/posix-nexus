
nx_data_ref()
{
	test -n "$1" && eval "printf \$$1"
}

nx_data_ref_append()
{
	tmpa="$(nx_data_ref "$1")"
	test -n "$tmpa" -a -n "$2" && v="${tmpa}${3:-,}"
	printf '%s\n' "$v$2"
}

nx_data_include()
(
	eval "$(nx_str_optarg ':d:f:s:o:i:' "$@")"
	test -e "$o" -a -n "$f" && mv "$o" "${o}-$(date +"%s").bak"
	test -z "$o" && o='/dev/stdout'
	i="$(nx_info_path -p "${i:-"$1"}")"
	[ -f "$i" -a -r "$i" ] && {
		cat "$i" | ${AWK:-$(nx_cmd_awk)} \
			-v sig="${s:-#}" \
			-v dir="${d:-nx_include}" \
			-v inpt="$i" \
		"
			$(cat \
				"${NEXUS_LIB}/awk/nex-misc.awk" \
				"${NEXUS_LIB}/awk/nex-struct.awk" \
				"${NEXUS_LIB}/awk/nex-log.awk" \
				"${NEXUS_LIB}/awk/nex-json.awk" \
				"${NEXUS_LIB}/awk/nex-str.awk" \
				"${NEXUS_LIB}/awk/nex-math.awk"
			)
		"'
			BEGIN {
				d = sig dir
			} {
				if (s = nx_include($0, d, inpt, arr))
					print s
			} END {
				delete arr
			}
		' > "$o"
	}
)

nx_data_repeat()
{
	${AWK:-$(nx_cmd_awk)} -v cmd="$1" -v repeat="$2" '
		BEGIN {
			for (i = split(repeat, arr, "<nx:null/>"); i > 0; --i)
				printf("NEX_ARG=\x22%s\x22; %s\n", arr[i], cmd)
			delete arr
		}
	'
}

nx_data_append()
{
	printf '%s\n' "$(
		v="$(nx_data_ref "$1")"
		test -z "$2" && {
			printf '%s' "$v"
			exit
		}
		s="${3:-:}"
		case "$s$v$s" in
			*"$s$2$s"*) printf '%s' "$v";;
			*) {
				if test -n "$4"; then
					printf '%s' "$2${v:+"$s$v"}"
				else
					printf '%s' "${v:+"$v$s"}$2"
				fi
			};;
		esac
	)"
}

nx_data_jdump()
{
	${AWK:-$(nx_cmd_awk)} -v jdump="$*" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		BEGIN {
			nx_json(jdump, arr, 2)
			for (jdump in arr)
				printf("%s = %s\n", jdump, arr[jdump])
			delete arr;
		}
	'
}

nx_data_jtree()
(
	eval "$(nx_str_optarg ':r:j:n:' "$@")"
	test "$n" = '0' || n="$(nx_int_natural "$n")"
	${AWK:-$(nx_cmd_awk)} -v jdump="$j" -v root="${r:-}" -v indent="$n" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		BEGIN {
			if (err = nx_json(jdump, arr, 2))
				exit err
			print nx_json_flatten(root, arr, indent)
			delete arr
		}
	'
)

nx_data_pair()
{
	${AWK:-$(nx_cmd_awk)} -v str="$@" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct.awk")
	"'
		BEGIN {
			sep["\x22"] = "\x22"
			sep["\x27"] = "\x27"
			sep["\x09"] = ""
			sep["\x20"] = ""
			nx_find_pair(str, sep, arr)
			print substr(str, arr["osidx"] + arr["oeidx"], arr["csidx"] + arr["ceidx"] - 1)
			delete arr
			delete sep
		}
	'
}

nx_data_entries()
{
	${AWK:-$(nx_cmd_awk)} -v str="$1" -v ed="$2" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct.awk")
	"'
		BEGIN {
			if (ed = nx_entries(str, ed))
				print ed
			else
				exit 1
		}
	'
}

nx_data_uniq()
(
	eval "$(nx_str_optarg ':f:i:' "$@")"
	${AWK:-$(nx_cmd_awk)} -v fl="$f" -v inpt="$i" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct.awk")
	"'
		BEGIN {
			lns[0] = 0
			if (i = split(fl, fls, "<nx:null/>")) {
				do {
					while ((getline fl < fls[i]) > 0) {
						if (! (fl in lns))
							nx_bijective(lns, ++lns[0], fl)
					}
				} while (--i > 0)
			}
			if (i = split(inpt, fls, "\n|<nx:null/>")) {
				do {
					if (! (fls[i] in lns))
						nx_bijective(lns, ++lns[0], fls[i])
				} while (--i > 0)
			}
			delete fls
			do {
				print lns[lns[0]]
			} while (--lns[0] > 0)
			delete lns
		}
	'
)

nx_data_import()
{
	${AWK:-$(nx_cmd_awk)} -v fl="NX_C:/file7.txt" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-misc.awk")
	"'
		BEGIN {
			arr["h"] = " "
			arr["t"] = ","
			str = "\o\o\o\,bar\ baz,\ and\ was\ ,w"
			#print nx_find_next(str, arr, 1)
			print nx_file_merge("/opt/posix-nexus/env/file1.txt")
		}
	'
}

