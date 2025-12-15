#nx_include nex-sh.awk
#nx_include nex-log-extras.awk


# D1	the string
# D2	the opening group
# D3	the closing group
# D4	the alias symbol
function nx_sh_stride(D1, D2, D3, D4,
		str, cnt)
{
	cnt = 0
	while (match(D1, D2)) {
		cnt += 3
		D1 = substr(D1, RSTART + RLENGTH)
		if (! match(D1, D3))
			return -1
		str = substr(D1, 1, RSTART - 1)
		cnt += gsub(D4, "", str)
		D1 = substr(D1, RSTART + RLENGTH)
	}
	return cnt
}

# V	the array
# D1	long option on character
# D2	long option off character
# N1	current index
# N2	total length
function nx_sh_long(V, D1, D2, N1, N2,
	ste, cr)
{
	# The normalization loop ensures we only enter parsing if a valid alphabetic option exists.
	# If none is found, 'i' advances beyond 'fmt', so the parse loop never runs.
	# This is intentional: it prevents misclassification and keeps the option map clean.
	ste = ""
	do {
		cr = V[++N1]
		if (cr == D1)
			ste = D1
		else if (cr == D2)
			ste = D2
	} while (! nx_is_alpha(cr) && N1 <= N2)
	if (N1 > N2)
		return 0
	if (ste != "")
		V[-1] = ste
	return N1
}

# alti = nx_sh_opts_alts(alt, V, alti, strde, D1, N, fld)
function nx_sh_opts_alts(V1, V2, N1, N2, N3, N4, D)
{
	V2[++N3] = N1
	if (N4 > 2) {
		nx_ansi_alert("aliases for '" D "' start at '" N3 "', total aliases '" N1 "', with stride '" N2 "'\n")
		do {
			N4 = V1[N1]
			V2[N3 += N2] = N4
			nx_ansi_alert("alias number '" N1 "' for '" D "' is '" N4 "' at index '" N3 "'\n")
			V1[N1] = D
		} while (--N1 > 0)

	} else {
		do {
			V2[N3 += N2] = V1[N1]
			V1[N1] = D
		} while (--N1 > 0)
	}
	return 0
}

function nx_sh_opts_logger(N, V, D1, D2,
	str, srt, i, j)
{
	if (N > 4) {
		str = "\ndump:"
		for (i in V)
			str = str "\n" i "  =  " V[i]
		nx_ansi_info(str)
	} else if (N > 3) {
		str = "\nkeywords:"
		srt = V[1]
		for (i = 1 + D1; i <= srt; i += D1)
			str = str " " V[i]
		nx_ansi_info(str)
		str = "\nflags:"
		srt = V[4]
		for (i = 4 + D1; i <= srt; i += D1)
			str = str " " V[i]
		nx_ansi_info(str)
		str = "\nkeyword arrays:"
		srt = V[10]
		for (i = 10 + D1; i <= srt; i += D1)
			str = str " " V[i]
		nx_ansi_info(str)
		str = "\nflag arrays:"
		srt = V[7]
		for (i = 7 + D1; i <= srt; i += D1)
			str = str " " V[i]
		nx_ansi_info(str)
		if (D2 > 13) {
			for (i = 13; i < D2; i += 3) {
				j = i + D1
				str = "\ngroup '" V[i + 2] "' " V[j] ":"
				srt = V[i]
				for (j += D1; j <= srt; j += D1)
					str = str " " V[j]
				nx_ansi_info(str)
			}
		}
		print
	}
}

# D1	the options string
# N	debug level
# V	the array to return
# D2	sep sep
# D3	seps
function nx_sh_opts(D1, N, V, D2, D3,
	li, ds, ks, als, fas, kas, go, gc, lo, lc, fs, fsa, fsr,
	fmt, cg, cl, lcr, cr, fld, grp, crgrp, cgl, alti,
	trk, alt)
{
	# key => start index
	# start index => end index
	# start index + 1 => end alias index

	# (k = i + opts[0]; k <= opts[i]; k += opts[0])
	# i = 1 -> kwds
	# i = 4 -> flags
	# i = 7 -> kwd arrays
	# i = 10 -> flag array
	# i >= 13 inc of 3 skip of opr[i] -> group

	# Check if the input string D1 is not empty,
	if (D1 == "")
		return -1

	ds = __nx_else(D2, ",") # Define default delimiters
	split(D3, trk, ds)
	ks = __nx_else(trk[1], ":") # key sep
	als = __nx_else(trk[2], "&") # alias / altname of option
	fas = __nx_else(trk[3], "@") # appendable arr sep
	kas = __nx_else(trk[4], "#") # appendable kwds sep
	go = __nx_else(trk[5], "<") # begin group
	gc = __nx_else(trk[6], ">") # eng group
	lo = __nx_else(trk[7], " ") # begin or continue long option mode
	lc = __nx_else(trk[8], ";") # end long option mode
	fs = __nx_else(trk[9], "=") # optional set flag sep
	fsa = __nx_else(trk[10], "+") # optional push flag sep
	fsr = __nx_else(trk[11], "-") # optional pop flag sep
	if ((D2 = nx_sh_stride(D1, go, gc, als)) == -1) {
		if (N > 0)
			nx_ansi_error("the group terminator '" gc "' ran away\n")
		delete trk
		return -1
	}
	fmt = split(D1, trk, "") + 1
	strde = 12 + D2
	nx_parr_stk(V, strde)
	if (N > 2)
		nx_ansi_alert("passed param string was " D1 "\n")
	trk[-1] = lc
	D2 = nx_sh_long(trk, lo, lc, 0, fmt)
	cl = trk[-1]
	lcr = trk[D2]
	grp = 13
	cg = gc

	for (++D2; D2 <= fmt; ++D2) {
		cr = trk[D2]
		if (cr == lc) {
			cl = lc
			cr = ""
		}
		if (cl == lo && nx_is_alpha(cr)) {
			lcr = lcr cr
		} else if (nx_is_alpha(lcr)) {
			if (lcr in V) {
				# edge case for when the already registered lcr is next to gc
				if (cg == go && cr == gc) {
					grp += 3
					cg = gc
					cr = ""
				}
				if (N > 1)
					nx_ansi_warning("The '" lcr "' flag has already been registered, changing to '" cr "' as the new lcr\n")
				lcr = cr
			} else if (cr == als) {
				alt[++alti] = lcr
				D2 = nx_sh_long(trk, lo, lc, D2, fmt)
				if (D2 == 0)
					break
				lcr = trk[D2]
			} else {
				# save the last index for logging
				li = D2
				if (nx_is_alpha(cr) ||
					cr == "" || # reached the end of the last passed token
					(cl != lo && cr == lo) || # enter long option mode
					(cl == lo && (cr == lo || cr == lc)) || # continue/close long option mode
				(cg == go && cr == gc)) { # close group
					fld = lcr
					if (cg == go) {
						D1 = nx_parr_stk(V, grp, lcr)
						V[lcr] = cgl
						if (N > 2)
							nx_ansi_success("group member '" lcr  "' " __nx_only(D3, "of type '" D3 "' ") "was added to " crgrp " at position '" D1 "'\n")
						if (cr == gc) {
							grp += 3
							cg = gc
						}
					} else {
						D1 = nx_parr_stk(V, 4, lcr)
						if (N > 2)
							nx_ansi_success("passed param '" lcr "' was registered as a flag at position '" D1 "'\n")
						V[lcr] = D1
					}
					if (! nx_is_alpha(cr)) {
						D2 = nx_sh_long(trk, lo, lc, D2, fmt)
					}
					if (D2 != 0) {
						lcr = trk[D2]
						if (cr == "") {
							if (N > 2)
								nx_ansi_alert("short option state enabled at index '" li "'\n")
						} else if (cr == lo && cl != lo) {
							if (N > 2)
								nx_ansi_alert("long option state enabled at index '" li "'\n")
							cl = lo
						} else if (cg == gc) {
							if (N > 2)
								nx_ansi_light("lcr is now '" lcr "'\n")
						} else if (N > 1 && ! nx_is_alpha(cr)) {
							nx_ansi_warning("passed flag '" lcr "' was not registered, '" cr "' is not a known sigil, provide the code with tests and we will add it :)\n")
						}
					}
				} else {
					if (cr == ks) {
						D1 = nx_parr_stk(V, 1, lcr)
						if (N > 2)
							nx_ansi_debug("passed param '" lcr "' was registered as a keyword argument at position '" D1 "'\n")
					} else if (cr == go) {
						D1 = nx_parr_stk(V, grp, lcr)
						if (N > 2)
							nx_ansi_light("passed param '" lcr "' was registered as a group leader at position '" D1 "'\n")
						D3 = trk[D2 + 1]
						if (D3 != ks && D3 != kas && D3 != fas)
							D3 = lo
						V[grp + 2] = D3
						cg = go
						crgrp = lcr
						cgl = D1
					} else if (cr == fas) {
						D1 = nx_parr_stk(V, 7, lcr)
						if (N > 2)
							nx_ansi_success("passed param '" lcr "' was registered as a flag array (appendable) at position '" D1 "'\n")
					} else if (cr == kas) {
						D1 = nx_parr_stk(V, 10, lcr)
						if (N > 2)
							nx_ansi_debug("passed param '" lcr "' was registered as a keyword array (appendable) at position '" D1 "'\n")
					} else if (N > 1) {
							nx_ansi_warning("passed param '" lcr "' was not registered, '" cr "' is not a known group\n")
					}
					fld = lcr
					V[fld] = D1
					D2 = nx_sh_long(trk, lo, lc, D2, fmt)
					if (D2 != 0)
						lcr = trk[D2]
				}
				if (D1 == -1) {
					if (N > 0)
						nx_ansi_warning("overflow, starting index was greater than stride '" strde "'\n")
				} else {
					V[D1] = fld
				}
				if (alti)
					alti = nx_sh_opts_alts(alt, V, alti, strde, D1, N, fld)
				if (D2 == 0)
					break
			}
		} else {
			if (N > 2)
				nx_ansi_light("skipping non-alpha '" lcr "', setting lcr to '" cr "'\n")
			lcr = cr
		}
	}
	if (N > 2)
		nx_ansi_alert("done\n")
	nx_sh_opts_logger(N, V, strde, grp)
	delete trk
	delete alt
}

# D1	input
# N	debug level
# D2	arg sep
# D2	sep sep
# D4	seps
function nx_lsh_optargs(D1, N, D2, D3, D4,
	ps,
	agv, trk, opts)
{
	# Check if the input string D1 is not empty,
	if (D1 == "")
		return -1
	ps = __nx_else(D2, "<nx:null/>") # Param sep
	cnt = split(D1, agv, ps)
	nx_sh_opts(agv[1], N, opts, D3, D4)
	delete opts
	delete agv
}

