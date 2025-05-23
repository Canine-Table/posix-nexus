#!/bin/sh

nx_algor_qsort() {
	(
		while getopts :s:o:l:m:c OPT; do
			case $OPT in
				o|s|m|c) eval "$OPT"="'${OPTARG:-true}'";;
				l) l="$(nx_struct_ref_append l "$OPTARG")";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(nx_cmd_awk)} \
			-v meh="$m" \
			-v lst="${l:-"$*"}" \
			-v sep="$s" \
			-v cs="$c" \
			-v osep="$o" \
		"
			$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-algor.awk")
		"'
			BEGIN {
				sep = __nx_else(sep, ",")
				osep = __nx_else(osep, "\x0a")
				meh = __nx_else(meh, ">=_")
				nx_vector(lst, arr, sep, "", 1)
				if (! cs) {
					ics = IGNORECASE
					IGNORECASE = 1
				}
				nx_quick_sort(arr, 1, arr[0], meh)
				if (isc != "")
					IGNORECASE = isc
				if (str = nx_tostring_vector(arr, osep, 1))
					print str
				else
					exit 1
			}
		'
	)
}

nx_algor_compare()
{
	(
		while getopts :s:o:l:r:itcd OPT; do
			case $OPT in
				i|d) m="$OPT";;
				c|s|o|t) eval "$OPT"="'${OPTARG:-true}'";;
				l|r) eval "$OPT"="'$(nx_struct_ref_append $OPT "$OPTARG")'";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(nx_cmd_awk)} \
			-v inptlst="${l:-"$1"}" \
			-v reflst="${r:-"$2"}" \
			-v mde="$m" \
			-v tm="$t" \
			-v cs="$c" \
			-v sep="$s" \
			-v osep="$o" \
		"
			$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-struct.awk")
		"'
			BEGIN {
				if (! (inptlst && reflst))
					exit 1
				sep = __nx_else(sep, ",")
				osep = __nx_else(sep, "\x0a")
				if (! cs) {
					ics = IGNORECASE
					IGNORECASE = 1
				}
				nx_uniq_vector(inptlst, arra, sep, tm)
				nx_uniq_vector(reflst, arrb, sep, tm)
				nx_compare_vector(mde, arra, arrb, arrc, 1)
				if (isc != "")
					IGNORECASE = isc
				if (str = nx_tostring_vector(arrc, osep, 1))
					print str
				else
					exit 2
			}
		'
	)
}

nx_algor_opt() {
	(
		while getopts :i:k:s:o:l:m:ctbev OPT; do
			case $OPT in
				t|i|k|o|s|m|c|b|v|e) eval "$OPT"="'${OPTARG:-true}'";;
				l) l="$(nx_struct_ref_append l "$OPTARG")";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(nx_cmd_awk)} \
			-v inpt="$i" \
			-v lst="$l" \
			-v sep="$s" \
			-v ksep="$k" \
			-v cs="$c" \
			-v bnd="$b" \
			-v ed="$e" \
			-v tm="$t" \
			-v vrb="$v" \
			-v osep="$o" \
		"
			$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-struct.awk")
		"'
			BEGIN {
				sep = __nx_else(sep, ",")
				osep = __nx_else(osep, "\x0a")
				nx_vector(lst, arra, sep, ksep, tm)
				if (! cs) {
					ics = IGNORECASE
					IGNORECASE = 1
				}
				if (str = nx_option(inpt, arra, arrb, bnd, ed))
					str = __nx_if(str in arra, arra[str], str)
				else if (vrb)
					vrb = nx_tostring_vector(arrb, osep)
				if (isc != "")
					IGNORECASE = isc
				delete arra
				delete arrb
				if (str)
					print str
				else if (! vrb)
					exit 1
				print vrb
				exit 2
			}
		'
	)
}

nx_algor_list() {
	(
		while getopts :i:k:s:o:l:m:ctbev OPT; do
			case $OPT in
				t|i|k|o|s|m|c|b|v|e) eval "$OPT"="'${OPTARG:-true}'";;
				l) l="$(nx_struct_ref_append l "$OPTARG")";;
			esac
		done
		shift $((OPTIND - 1))
		${AWK:-$(nx_cmd_awk)} \
			-v inpt="$i" \
			-v lst="$l" \
			-v sep="$s" \
			-v ksep="$k" \
			-v cs="$c" \
			-v bnd="$b" \
			-v ed="$e" \
			-v tm="$t" \
			-v vrb="$v" \
			-v osep="$o" \
		"
			$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-struct.awk")
		"'
			BEGIN {
				sep = __nx_else(sep, ",")
				osep = __nx_else(osep, "\x0a")
				if (! cs) {
					ics = IGNORECASE
					IGNORECASE = 1
				}
				nx_vector(lst, arra, sep, ksep, tm)
				for (i = 1; i <= arra[0]; i++) {
					if (arra[i] in arra) {
						s = arra[i]
						r = r sprintf("\x22%s\x22%s\x22%s\x22", s, ksep, arra[s])
						s = s "." arra[s]
						while(k = arra[s]) {
							r = r sprintf("->\x22%s\x22", k)
							s = s "." k
						}
					} else {
						r = r sprintf("\x22%s\x22", arra[i])
					}
					if (i < arra[0])
						r = r sprintf("%s", osep)
				}
				if (isc != "")
					IGNORECASE = isc
				delete arra
				if (r)
					print r
				else
					exit 1
			}
		'
	)
}

