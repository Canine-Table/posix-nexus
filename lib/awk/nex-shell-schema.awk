

function __nx_shell_schema_hoster(D1, D2, D3, N,
	D4, D5, D6, D7, D8, D9, D10, D11,
	V1, V2,
	l, n, i, m, lns, zn, phlst, phsrt, phskp,
	acm, nogrps, lpgrp, grpsrt, grplst,
	eret, wret, ab,
	cycln, cychd, cycskp,
	ks, fas, kas, go, gc, lo, lc, iga,
	tpe, dft, epi, use, dsc, blt, regx, min, max, lzy, pafr, pbfr, apafr, apbfr, ap, pap,
	fa, fd, fm, fr, fi, fn,
	pref, ext, skp, ncn, fs, as, psrt, mpre, msuf, menv, mels, mif, mcls, mexp,
	tru, fls, non, amp,
	rgx, acrgx,
	v_ta, v_tb)
{

	if (D1 ~ /^[ \t\n\v\r\f]*$/) {
		nx_ansi_error("please provide something to work with, '" D1 "' is not understood here yet\n")
		return -1
	}

	D2 = __nx_else(D2, "<nx:null/>")
	D3 = __nx_else(D3, D2)

	i = int(N)
	N = __nx_if(i < 0 || i > 5, 1, i)

	wret = 0

	split(D11, v_ta, D2)

	#lane spacing (changable but must be greater than the largest lane)
	i = nx_bit_round(int(v_ta[1]), v_tb)
	m = __nx_if(i < 32, 256, i)

	# number of entries used in lane 0 (the access lane); lane 0 has no regular lane count
	i = int(v_ta[2])
	zn = __nx_if(i < 3, 3, i)

	# number of content lanes (lanes 1..lns; lane 0 is special, counted by zn)
	i = int(v_ta[3])
	lns = __nx_if(i < 12, 12, i)

	# group region starts at slot grpsrt
	i = int(v_ta[4])
	grpsrt = __nx_if(i < 1, 1, i)

	# number of reserved group slots (4 category groups: ks, lo, fas, kas)
	i = int(v_ta[5])
	nogrps = __nx_if(i < 4, 4, i)

	# lanes per group; also the stride increment per group and per schema construct
	i = int(v_ta[6])
	lpgrp = __nx_if(i < 3, 3, i)

	# last slot of the reserved group region; first group slot is grpsrt, each group takes lpgrp slots
	grplst = grpsrt + nogrps * lpgrp

	# parameter header size in slots; heap step psrt = phsrt * strde
	i = int(v_ta[7])
	i = -nx_bit_round(__nx_if(i < 0, -i, i), v_tb)
	phsrt = __nx_if(i > -16, -16, i)

	i = int(v_ta[8])
	phlst = __nx_if(i < 0, i, -1)

	i = int(v_ta[9])
	cychd = __nx_if(i < 1, 9, i)

	i = int(v_ta[10])
	cycskp = __nx_else(i, 1)

	split("", v_tb, "")

	# CATEGORY (D4) SECTION ###########################
	n = 8
	if ((l = split(D4, v_ta, D2)) > 0) {
		i = __nx_if(l > n, n, l)
		if (N > 1) {
			if (l > n + 1)
				nx_ansi_warning("<nx:null/>'" D4 "' separator to separate the separators was was either used within the separators as a separator or you passed '"  l - n  "' separators more than you should have, only the first '" n "' positions will be used\n")
			l = i
			for (i = 1; i <= l; ++i) {
				acm = v_ta[i]
				if (acm != "") {
					eret = 1
					if (acm in v_ta) {
						nx_ansi_warning("separator '" acm "' already in use as separator number '" v_ta[acm] "'\n")
					} else if (length(acm) > 1) {
						nx_ansi_warning("separator '" acm "' must be a single character\n")
					} else if (nx_is_alpha(acm)) {
						nx_ansi_warning("separator '" acm "' must not be alphabetic\n")
					} else {
						eret = 0
						v_ta[acm] = i
					}
					if (eret)
						wret = -2
				}
			}
		} else {
			l = i
			for (i = 1; i <= l; ++i) {
				acm = v_ta[i]
				if (acm in v_ta || nx_is_alnum(acm) || length(acm) > 1) {
					wret = -2
				} else {
					v_ta[acm] = i
				}
			}
		}
	}

	ks = __nx_else(v_ta[1], "%") # key sep
	fas = __nx_else(v_ta[2], "@") # appendable arr sep
	kas = __nx_else(v_ta[3], "#") # appendable kwds sep
	go = __nx_else(v_ta[4], "<") # begin group
	gc = __nx_else(v_ta[5], ">") # eng group
	lo = __nx_else(v_ta[6], ",") # begin or continue long option mode
	lc = __nx_else(v_ta[7], ";") # end long option mode
	iga = __nx_else(v_ta[7], "|") # inner group alias

	if (nx_delim_sep("key value pair", ks, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("flag array", fas, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("key value pair array", kas, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("open group", go, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("close group", gc, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("long option", lo, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("short option", lc, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("inner group alias option", iga, v_tb, N) == -1)
		eret = -1

	if (eret == -1) {
		delete v_tb
		delete v_ta
		return -1
	}
	split("", v_tb, "")

	i = split(D1, V2, D2)
	V2[0] = i
	if ((i = nx_shell_stride(V2[1], go, gc, lpgrp)) == -1) {
		if (N > 0)
			nx_ansi_error("the group terminator '" gc "' ran away\n")
		delete v_ta
		delete v_tb
		return -1
	}

	strde = nogrps * lpgrp + i
	nx_parr_stk(V1, strde)

	i = grpsrt
	V1[ks] = nx_parr_stk(V1, i, ks)

	i = i + lpgrp
	V1[lo] = nx_parr_stk(V1, i, lo)

	i = i + lpgrp
	V1[fas] = nx_parr_stk(V1, i, fas)

	i = i + lpgrp
	V1[kas] = nx_parr_stk(V1, i, kas)

	##################################################

	# CATEGORY (D4) SECTION ###########################
	oft = m * 4
	V1[(oft + 0) * strde] = n
	# 1	key-value pair
	# 2	flag array
	# 3	key-value pair array
	# 4	group open
	# 5	group close
	# 6	long form / toggle flag
	# 7	short form
	V1[(oft + 1) * strde] = ks
	V1[(oft + 2) * strde] = fas
	V1[(oft + 3) * strde] = kas
	V1[(oft + 4) * strde] = go
	V1[(oft + 5) * strde] = gc
	V1[(oft + 6) * strde] = lo
	V1[(oft + 7) * strde] = lc
	##################################################

	# REPRESENTATION (D10) SECTION ###################
	n = 5
	wret = __nx_else(nx_unique_check(D10, v_ta, D2, n, N, " representation"), wret)
	tru = __nx_else(v_ta[1], "<nx:true/>")
	fls = __nx_else(v_ta[2], "<nx:false/>")
	non = __nx_else(v_ta[3], "<nx:none/>")
	amp = __nx_else(v_ta[4], "<nx:x26/>")
	blnk = __nx_else(v_ta[5], "<nx:blank/>")





}

function __nx_shell_schema(D1, D2, D3, N,
	D4, D5, D6, D7, D8, D9, D10,
	V1, V2,
	l, n, i, m, lns, zn, phlst, phsrt, phskp,
	acm, nogrps, lpgrp, grpsrt, grplst,
	eret, wret, ab,
	cycln, cychd, cycskp,
	ks, fas, kas, go, gc, lo, lc,
	tpe, dft, epi, use, dsc, blt, regx, min, max, lzy, pafr, pbfr, apafr, apbfr, ap, pap,
	fa, fd, fm, fr, fi, fn,
	pref, ext, skp, ncn, fs, as, psrt, mpre, msuf, menv, mels, mif, mcls, mexp,
	tru, fls, non, amp,
	rgx, acrgx,
	v_ta, v_tb)
{

	# PARAMETERS
	# ----------
	# SCALAR PARAMETERS
	# D1	the input
	# D2	the parameter separator
	# D3	the remainder separator
	# N	debug level

	# STRING SPLIT ARRAY PARAMETERS
	# D4	category symbols
	# D5	toggles
	# D6	action symbols
	# D7	flags
	# D8	misc symbols
	# D9	directives
	# D10	type representations

	# REFERENCE ARRAYS
	# V1	the symbol structure vector
	# V2	the parameters stack

	# LANES
	# (0) schelars
	# (1) (unused)
	# (2) representation
	# (3) directives
	# (4) categories
	# (5) toggles
	# (6) actions
	# (7) flags
	# (8) misc
	# (9) regex
	# (10) geometry
	# (11) defaults
	# (12) positionals

	if (nx_delim_sep("false representation", fls, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("true representation", tru, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("none representation", non, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("ampersand representation", amp, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("blank representation", blnk, v_tb, N) == -1)
		eret = -1
	delete v_tb

	# REPRESENTATION (D10) SECTION ###################
	oft = m * 2
	V1[(oft + 0) * strde] = n
	# 1 true representation
	# 2 false representation
	# 3 none representation
	# 4 ampersand representation
	# 5 blank representation
	V1[(oft + 1) * strde] = tru
	V1[(oft + 2) * strde] = fls
	V1[(oft + 3) * strde] = non
	V1[(oft + 4) * strde] = amp
	V1[(oft + 5) * strde] = blnk

	##################################################

	# MISC (D8) SECTION ##############################
	split(D8, v_ta, D2)
	pref = __nx_else(v_ta[1], "-") # prefix for long/short options
	ext = __nx_else(v_ta[2], "-_:.") # extra characters allowed between alpha characters in long option mode
	skp = __nx_else(v_ta[3], "\n\v\f\t\r ") # extra characters that hold no meaning and should be skipped
	ncn = __nx_else(v_ta[4], " ", 1) # concat sep of remainder string
	ncn = __nx_if(ncn == blnk, "", ncn)
	fs = __nx_else(v_ta[5], "=") # set symbol
	as = __nx_else(v_ta[6], "=") # assign symbol
	mpre = __nx_else(v_ta[7], "<nx@") # macro prefix
	msuf = __nx_else(v_ta[8], "/>") # macro suffix
	menv = __nx_else(v_ta[9], "$")
	mels = __nx_else(v_ta[10], ":-")
	mif = __nx_else(v_ta[11], ":+")
	mcls = __nx_else(v_ta[12], ":=")
	mexp = __nx_else(v_ta[13], mpre)

	split("", v_ta, "")
	if (nx_delim_sep("macro prefix", mpre, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("macro suffix", msuf, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("macro environ modifier", menv, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("macro else modifier", mels, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("macro if modifier", mif, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("macro coalescing modifier", mcls, v_tb, N) == -1)
		eret = -1
	delete v_tb

	split("", v_ta, "")
	ext = nx_shell_diff(ext, v_ta, "", v_tb)
	skp = nx_shell_diff(skp, v_ta, "", v_tb)
	delete v_tb
	split(D8, v_ta, D2)

	n = 14
	oft = m * 8
	V1[(oft + 0) * strde] = n
	# 1	argument prefix character
	# 2	extra valid long form characters outside alpha class allowed between alpha characters
	# 3	characters to ignore/skip defaults to whitespace characters
	# 4	the concat string to format the string remainder
	# 5	the action init symbol
	# 6	assign symbol
	# 7	macro prefix
	# 8	macro suffix
	# 9	the remainder separator
	# 10	macro env modifier
	# 11	macro else modifier
	# 12	macro if modifier
	# 13	macro coalescing modifier
	# 14	macro expand continuation
	V1[(oft + 1) * strde] = pref
	V1[(oft + 2) * strde] = ext
	V1[(oft + 3) * strde] = skp
	V1[(oft + 4) * strde] = ncn
	V1[(oft + 5) * strde] = fs
	V1[(oft + 6) * strde] = as
	V1[(oft + 7) * strde] = mpre
	V1[(oft + 8) * strde] = msuf
	V1[(oft + 9) * strde] = D3
	V1[(oft + 10) * strde] = menv
	V1[(oft + 11) * strde] = mels
	V1[(oft + 12) * strde] = mif
	V1[(oft + 13) * strde] = mcls
	V1[(oft + 14) * strde] = mexp
	##################################################

	# TOGGLES (D5) SECTION ###########################
	split(D5, v_ta, D2)
	n = 11
	oft = m * 5
	V1[oft * strde] = n
	# 1	unset
	# 2	override
	# 3	backtrack
	# 4	export
	# 5	double quote
	# 6	concat flag
	# 7	lazy defaults flag
	# 8	directive-prefix-trim
	# 9 	directive-suffix-trim
	# 10 	dump
	# 11	cycle-back
	for (i = 1; i <= n; ++i) {
		oft = oft + 1
		V1[oft * strde] = v_ta[i] == "<nx:true/>"
	}
	ncn = V1[(m * 5 + 6) * strde]
	##################################################


	# FLAGS (D7) SECTION #############################
	split(D7, v_ta, D2)
	n = 4
	oft = m * 7
	V1[(oft + 0) * strde] = n
	# 1	force [0-3]
	# 2	abort [0-3]
	# 3	chain-eval [0-2]
	# 4	period [1-m]
	i = int(v_ta[1])
	V1[(oft + 1) * strde] = __nx_if(i < 0 || i > 3, 0, i)
	i = int(v_ta[2])
	V1[(oft + 2) * strde] = (ab = __nx_if(i < 0 || i > 3, 0, i))
	i = int(v_ta[3])
	V1[(oft + 3) * strde] = __nx_if(i < 0 || i > 2, 1, i)
	i = int(v_ta[4])
	V1[(oft + 4) * strde] = (cycln = __nx_if(i < 1 || i > m - cychd, 9, i))
	##################################################

	# ACTION CATEGORY (D6) SECTION ###################
	n = 6
	wret = __nx_else(nx_unique_check(D6, v_ta, D2, n, N, "action"), wret)

	fa = __nx_else(v_ta[1], "+") # push modifier symbol
	fd = __nx_else(v_ta[2], "-") # pop modifier symbol
	fm = __nx_else(v_ta[3], "@") # match find modifier symbol
	fr = __nx_else(v_ta[4], "~") # match replace modifier symbol
	fi = __nx_else(v_ta[5], "%") # match index of match modifier symbol
	fn = __nx_else(v_ta[6], "#") # match number modifier symbol
	if (nx_delim_sep("push modifier symbol", fa, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("pop modifier symbol", fd, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("match find modifier symbol", fm, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("match replace modifier symbol", fr, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("match index modifier symbol", fi, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("match number modifier symbol", fn, v_tb, N) == -1)
		eret = -1
	delete v_tb
	if (eret == -1) {
		delete v_ta
		return -1
	}

	# start of params when invoking the function nx_shell_args and nx_shell_environ
	psrt = phsrt * strde
	V1["-0"] = __nx_if(V1["-0"] < psrt, V1["-0"], psrt)
	##################################################


	# ACTION (D6) SECTION ############################
	oft = m * 6
	V1[(oft + 0) * strde] = n
	# 1	push modifier symbol
	# 2	pop modifier symbol
	# 3	match substitute find modifier symbol
	# 4	match substitute replace modifier symbol
	# 5	starting index of match modifier symbol
	# 6	number of matches modifier symbol
	V1[(oft + 1) * strde] = fa
	V1[(oft + 2) * strde] = fd
	V1[(oft + 3) * strde] = fm
	V1[(oft + 4) * strde] = fr
	V1[(oft + 5) * strde] = fi
	V1[(oft + 6) * strde] = fn
	##################################################

	# SCELAR SECTION #################################
	# 1	the parameter separator
	# 2	debug level
	# 3	map boundary
	V1[1 * strde] = D2
	V1[2 * strde] = N
	V1[3 * strde] = m
	##################################################

	skp = "(" nx_str_esc(skp, 2) ")+"
	acm = "([a-zA-Z]"
	if (ext) {
		rgx = nx_str_esc(ext, 2)
		ext = "([a-zA-Z]|" rgx
		acm = acm ext ")*)?[A-Za-z]+"
		rgx = rgx")+$"
		ext = ext ")+"
		rgx = "(" rgx
	} else {
		ext = "[a-zA-Z]+"
	}

	for (i = 1; i <= n; ++i)
		acrgx = acrgx "|[" V1[(oft + i) * strde] "]"
	mpre = nx_str_esc(mpre)
	msuf = nx_str_esc(msuf)

	# REGEX SECTION ##################################
	n = 9
	oft = m * 9
	V1[(oft + 0) * strde] = n
	# 1	the action modifier match regex
	# 2	extended + alphabetic long option character regex
	# 3	extended long option character regex
	# 4	skip regex defaults to whitespace
	# 5	action regex
	# 6	skip regex defaults to whitespace with anchors
	# 7	macro regex
	# 8	macro remove pre suf regex
	# 9	macro remove pre suf positional regex
	V1[(oft + 1) * strde] = acm
	V1[(oft + 2) * strde] = ext "$"
	V1[(oft + 3) * strde] = rgx
	V1[(oft + 4) * strde] = skp
	V1[(oft + 5) * strde] = substr(acrgx, 2)
	V1[(oft + 6) * strde] = "^" skp "$"
	V1[(oft + 7) * strde] = mpre ext msuf
	V1[(oft + 8) * strde] = "(^" mpre "|" msuf "$)"
	V1[(oft + 9) * strde] = mpre "[1-9][0-9]*" msuf
	##################################################

	# CATEGORY (D9) SECTION ###########################
	n = 16
	wret = __nx_else(nx_unique_check(D9, v_ta, D2, n, N, "directive"), wret)
	tpe = __nx_else(v_ta[1], "type")
	dft = __nx_else(v_ta[2], "default")
	epi = __nx_else(v_ta[3], "epilog")
	use = __nx_else(v_ta[4], "usage")
	dsc = __nx_else(v_ta[5], "description")
	blt = __nx_else(v_ta[6], "build")
	regx = __nx_else(v_ta[7], "regex")
	min = __nx_else(v_ta[8], "min")
	max = __nx_else(v_ta[9], "max")
	lzy = __nx_else(v_ta[10], "lazy")
	pbfr = __nx_else(v_ta[11], "post-before")
	pafr = __nx_else(v_ta[12], "post-after")
	apbfr = __nx_else(v_ta[13], "post-awk-before")
	apafr = __nx_else(v_ta[14], "post-awk-after")
	ap = __nx_else(v_ta[15], "append")
	pap = __nx_else(v_ta[16], "prepend")

	if (nx_delim_sep("type directive", tpe, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("default directive", dft, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("epilog directive", epi, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("usage directive", use, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("description directive", dsc, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("build directive", blt, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("regex directive", rgx, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("min directive", min, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("max directive", max, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("lazy directive", lzy, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("post before directive", pbfr, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("post after directive", pafr, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("post awk eval before directive", apbfr, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("post awk eval after directive", apafr, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("append directive", ap, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("prepend directive", pap, v_tb, N) == -1)
		eret = -1
	delete v_tb

	if (eret == -1) {
		delete v_ta
		return -1
	}

	# DIRECTIVE SECTION ##############################
	oft = m * 3
	V1[(oft + 0) * strde] = n
	# 1 type directive
	# 2 default directive
	# 3 epilog directive
	# 4 usage directive
	# 5 description directive
	# 6 build directive
	# 7 regex directive
	# 8 min directive
	# 9 max directive
	# 10 lazy directive
	# 11 post before
	# 12 post after
	# 13 post awk eval before
	# 14 post awk eval after
	# 15 append
	# 16 prepend
	V1[(oft + 1) * strde] = tpe
	V1[(oft + 2) * strde] = dft
	V1[(oft + 3) * strde] = epi
	V1[(oft + 4) * strde] = use
	V1[(oft + 5) * strde] = dsc
	V1[(oft + 6) * strde] = blt
	V1[(oft + 7) * strde] = regx
	V1[(oft + 8) * strde] = min
	V1[(oft + 9) * strde] = max
	V1[(oft + 10) * strde] = lzy
	V1[(oft + 11) * strde] = pbfr
	V1[(oft + 12) * strde] = pafr
	V1[(oft + 13) * strde] = apbfr
	V1[(oft + 14) * strde] = apafr
	V1[(oft + 15) * strde] = ap
	V1[(oft + 16) * strde] = pap
	##################################################

	# GEOMETRY SECTION ###############################
	n = 10
	oft = m * 10
	V1[(oft + 0) * strde] = n

	# 1	group count
	# 2	positional parameter starting index and assigned block size
	# 3	starting group index
	# 4	number of groups
	# 5	lanes per group
	# 6	0 scaled lanes
	# 7	entries in special lane 0
	# 8	positional parameter header starting ending index and assigned block size
	# 9	positional parameter header ending index and assigned block size
	# 10	positional parameter skip size

	V1[(oft + 1) * strde] = 0
	V1[(oft + 2) * strde] = psrt
	V1[(oft + 3) * strde] = grpsrt
	V1[(oft + 4) * strde] = nogrps
	V1[(oft + 5) * strde] = lpgrp
	V1[(oft + 6) * strde] = lns
	V1[(oft + 7) * strde] = zn
	V1[(oft + 8) * strde] = phsrt
	V1[(oft + 9) * strde] = phlst
	V1[(oft + 10) * strde] = phskp
	##################################################

	# POSITIONAL PARAMETERS SECTION ##################
	# 1	lower bound
	# 2	upper bound
	# 3	skip size
	# 4	head index
	# 5	tail index
	# 6	cycle counter
	n = cycln + cychd
	oft = m * 12
	i = (oft + cychd) * strde
	V1[(oft + 0) * strde] = n
	V1[(oft + 1) * strde] = i
	V1[(oft + 2) * strde] = (oft + n) * strde
	V1[(oft + 3) * strde] = cycskp * strde
	V1[(oft + 4) * strde] = i + strde
	V1[(oft + 5) * strde] = i
	V1[(oft + 6) * strde] = 0

	# DEFAULTS SECTION ###############################
	n = 3
	oft = m * 11
	V1[(oft + 0) * strde] = n
	# 1: back-pointer slot (holds the base)
	# 2: base slot
	# 3: name slot (what gcr points at)
	V1[(oft + 1) * strde] =  (oft + 3) * strde
	V1[(oft + 3) * strde] = (oft + 3) * strde

	##################################################

	delete v_ta
	if (ab > 2)
		return __nx_else(eret, wret)
	return eret
}

