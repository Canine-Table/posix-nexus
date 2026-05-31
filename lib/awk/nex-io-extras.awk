#nx_include nex-io.awk


#function __nx_file_schema_str(V, D)
#{
#
#	V["-d"] = "<nx:null/>"
#	D = D ",d<%delimiter delimiter-separator>"
#	D = D "<default <nx:null\>>"
#	D = D "<type string>"
#	D = D "<description Set the delimiter used to separate schema fields.>"
#
#	V["-h"] = ""
#	D = D "h<help>"
#	D = D "<default null constant>"
#	D = D "<type void>"
#	D = D "<description Display schema, metadata, and usage information for all options.>"
#
#	V["-v"] = "1"
#	D = D "v<%verbose>"
#	D = D "<default 1>"
#	D = D "<type number>"
#	D = D "<description Set verbosity level (0–5). Higher levels print schema, parse flow, and full IR dumps.>"
#
#	V["-x"] = ""
#	D = D "x<%exclude exclude-files>"
#	D = D "<type string|list[string]>"
#	D = D "<expects file>"
#	D = D "<description >"
#
#	V["-i"] = ""
#	D = D "i<%input input-files>"
#	D = D "<type string|list[string]>"
#	D = D "<expects file>"
#	D = D "<description >"
#
#	V["-g"] = ""
#	D = D "g<%getline getline-method>"
#	D = D "<type toggle>"
#	D = D "<description >"
#
#	V["-C"] = "#"
#	D = D "C<%comment>"
#	D = D "<type string>"
#	D = D "<default #>"
#	D = D "<description >"
#
#	V["-S"] = ":<<-'NX'"
#	D = D "S<%comment-start>"
#	D = D "<type str>"
#	D = D "<default :<<-'NX'>"
#	D = D "<description >"
#
#	V["-E"] = "NX"
#	D = D "E<%comment-end>"
#	D = D "<type str>"
#	D = D "<default NX>"
#	D = D "<description >"
#
#	V["-s"] = "#"
#	D = D "s<%sigil>"
#	D = D "<type string>"
#	D = D "<default #>"
#	D = D "<description >"
#
#	V["-e"] = "."
#	D = D "e<%extention file-extention-separator extention-separator>"
#	D = D "<type string>"
#	D = D "<description >"
#
#	V["-f"] = "/"
#	D = D "e<%extention file-extention-separator extention-separator>"
#	D = D "<type string>"
#	D = D "<description >"
#
#	V["-T"] = "<nx:false/>"
#	D = D "T<t Truncate truncate>"
#	D = D "<type toggle>"
#	D = D "<default <nx:false/\>>"
#	D = D "<description >"
#
#	V["-r"] = ""
#	D = D "r<%root>"
#	D = D "<type str>"
#	D = D "<expects directory>"
#	D = D "<build tmpa=$(nx_data_dir <nx@r/\>); test $? -ne 66 && NEX_Gk_r=$tmpa>"
#	D = D "<description >"
#
#	V["-m"] = "2"
#	D = D "m<%method>"
#	D = D "<type int>"
#	D = D "<expects [0-3]>"
#	D = D "<description >"
#
#	V["-I"] = "nx_include"
#	D = D "I<%directive-include>"
#	D = D "<type str>"
#	D = D "<default nx_include>"
#	D = D "<description >"
#
	#lstsp='<nx:null/>'
	#dir='nx_include'
	#sig='#' sep=',' vb='1'
	#inpt='' extsp='' exfl=''
	#mth='2' rt='' flsp='/'
	#gtln='' trnk=''
	#scmnt= ecmnt=



#	return D

#			-r|--lib-root) {

#			};;

#
#			-S|--separator) {
#				sep="$2"
#			};;
#
#			-l|--list-separator) {
#				lstsp="$2"
#			};;
#
#			-f|--file-separator) {
#				flsp="$2"
#			};;
#
#


#			-d|--directive) {
#				dir="$2"
#			};;

#}

#function __nx_file_schema()
#{
	# PARAMETERS
	# ----------
	# SCALAR PARAMETERS
	# D1	the parameter separator
	# N	debug level

	# STRING SPLIT ARRAY PARAMETERS
	# D2	include files
	# D3	exclude files
	# D4	directives
	# D5	toggles
	# D6	flags
	# D8	misc symbols

	# REFERENCE ARRAYS
	# V1	the symbol structure vector
	# V2	the parameters stack

#}



#function nx_file_merge(D1, D2, D3, D4, B,
#		incd, flsp, sig, ps, ds, drp, rlp,
#		cnt, eret, wret, ln, nxt, cr, nr,
#		dbg, mth, trnk, gtln, srt, ed, sbng,
#		stk, fls, stre, trk)
#{
#	ds = __nx_else(D3, ",") # Define default delimiters
#	if ((D3 = split(D4, stk, ds)) > 0) {
#		wret = 0
#		eret = 0
#		if (D3 > 7) {
#			D3 = D3 - 7
#			if (N > 1)
#				nx_ansi_error("separator to separate the separators was was either used within the separators as a separator or you passed '" D3 "' separators more than you should have, only the first 5 positions will be used\n")
#			wret = -2
#		}
#	}
#
#	# file exclude sep
#	ps = __nx_else(stk[1], "<nx:null/>", 1)
#
#	# the directive sigil
#	sig = __nx_else(stk[2], "#", 1)
#
#	# the directory sep
#	flsp = __nx_else(stk[3], "/", 1)
#
#	# the file extention sep
#	extsp = __nx_else(stk[4], "[.]", 1)
#	if (stk[4] != "")
#		extsp = nx_str_esc(extsp)
#
#	# the include directive name
#	incd = __nx_else(stk[5], "nx_include", 1)
#
#	srt = __nx_else(stk[6], "[/][*]", 1)
#	if (stk[6] != "")
#		srt = nx_str_esc(sig srt)
#	srt = "^" srt
#
#	ed = __nx_else(stk[7], "[*][/]", 1)
#	if (stk[7] != "")
#		ed = nx_str_esc(sig ed)
#	ed = ed "$"
#
#	split(B, stk, ds)
#	mth = __nx_else(int(stk[1]), 3)
#	dbg = int(stk[2])
#	trnk = int(stk[3])
#	gtln = stk[4]
#
#	split("", stk, "")
#	eret = 0
#	if (nx_delim_sep(ps, "file exclusion", stk, dbg) == -1)
#		eret = -1
#	if (nx_delim_sep(sig, "directive sigial", stk, dbg) == -1)
#		eret = -1
#	if (nx_delim_sep(flsp, "directory", stk, dbg) == -1)
#		eret = -1
#	if (nx_delim_sep(extsp, "file extention", stk, dbg) == -1)
#		eret = -1
#	if (nx_delim_sep(incd, "include directive", stk, dbg) == -1)
#		eret = -1
#	if (eret == -1) {
#		delete stk
#		return -1
#	}
#
#	if (nx_file_store(fls, D1, "", stre, flsp, mth, gtln, extsp) != 1) {
#		delete stre
#		delete stk
#		delete fls
#		return -1
#	}
#
#	drp = fls[fls[2]]
#	rpl = fls[fls[1]]
#
#	# are there files to omit if founds after the directive??
#	if (D2 = nx_trim_split(D2, stk, ps)) {
#		do {
#			if (nx_file_store(fls, stk[D2], drp, stre, flsp, mth, gtln, extsp) == 1)
#				drp = fls[fls[2]]
#		} while (--D2 > 0)
#	}
#
#	split("", stk, "")
#	rt = "."
#	D1 = sig incd
#	D2 = "([ \t]+|^)" D1
#	D3 = D1 "[ \t]+"
#	nxt = 0
#	cnt = 0
#	do {
#		while ((getline ln < rpl) > 0) {
#			if (ln ~ D2 && match(ln, D3)) {
#				cr = substr(ln, 1, RSTART - 1)
#				ln = substr(ln, RSTART + RLENGTH)
#				if (match(ln, /^[^ \t]+/)) {
#					nr = substr(ln, RSTART, RLENGTH)
#					ln = substr(ln, RSTART + RLENGTH)
#					D1 = nx_file_store(fls, nr, drp, stre, flsp, mth, gtln, exts)
#					if (D1 > -1)
#						drp = fls[fls[2]]
#					if (D1 == 1) {
#						stk[rt "" ++cnt] = cr
#						D1 = fls[fls[1]]
#						trk[++nxt] = D1
#						trk[D1] = rt "" ++cnt "."
#						if (ln !~ /^[ \t]*$/)
#							stk[rt "" ++cnt] = ln "\n"
#					} else {
#						# directive match, but either the arg was not a file or its already been passed
#						# add the line without the directive
#						stk[rt "" ++cnt] = cr "\n"
#					}
#				} else if (cr !~ /^[ \t]*$/) {
#					# directive match, but no file provided, add the cr
#					stk[rt "" ++cnt] = cr "\n"
#				}
#			} else if (ln !~ /^[ \t]*$/) {
#				stk[rt "" ++cnt] = ln "\n"
#			}
#		}
#		close(rpl)
#		stk[rt "0"] = cnt
#		cnt = 0
#		rpl = trk[nxt]
#		rt = trk[rpl]
#	} while (nxt-- > 0)
#	delete stre
#	delete fls
#	delete trk
#	nx_dfs(stk) # flattens the dfs stack into indexes
#	nxt = stk[0]
#
#	sbng = "^[#][!][/]"
#	cnt = 0
#
#	if (trnk == 1) {
#		D4 = 0
#		for (D2 = 1; D2 <= nxt; ++D2) {
#			D3 = nx_trim_str(stk[stk[D2]], " \r\v\t\f\n")
#			if (D4) {
#				if (D3 ~ ed)
#					D4 = 0
#			} else if (D3 ~ srt) {
#				D4 = 1
#			} else if (D3 != "") {
#				if (!cnt) {
#					cnt = 1
#					printf("%s\n", D3)
#				} else if (D3 !~ sbng) {
#					printf("%s\n", D3)
#				}
#			}
#		}
#	} else {
#		for (D2 = 1; D2 <= nxt; ++D2)
#			printf("%s", stk[stk[D2]])
#	}
#	delete stk
#}
#
#
