#nx_include nex-sh.awk
#nx_include nex-log-extras.awk

function nx_sh_opts_stringify(D, B)
{
	gsub("'", "\x27\x22\x27\x22\x27", D)
	gsub("^'|'$", "", D)
	if (B == "<nx:true/>")
		return D
	return "\x27" D "\x27"
}

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

function nx_sh_opts_alts(V1, V2, N1, N2, N3, N4, D, l)
{
	V2[++N3] = N1
	if (N4 > 2) {
		nx_ansi_alert("aliases for '" D "' start at '" N3 "', total aliases '" N1 "', with stride '" N2 "'\n")
		do {
			N4 = V1[N1]
			V2[N3 += N2] = N4
			l = V1[-N1]
			V2[N3 + 1] = l
			nx_ansi_alert(__nx_if(l == "--", "long", "short") " form alias number '" N1 "' for '" D "' is '" N4 "' at index '" N3 "'\n")
			V2[N4] = D
		} while (--N1 > 0)
	} else {
		do {
			V2[N3 += N2] = V1[N1]
			V1[N1] = D
			V2[N3 + 1] = V1[-N1]
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
		nx_ansi_info(str "\n")
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
	}
	nx_fd_stderr("\n")
}

function nx_sh_opts_sep(D1, D2, V, N)
{
	if (D1 in V) {
		if (N > 0)
			nx_ansi_error("the '" D2 "' separator '" D1 "' colides with the '" V[D1] "' separator\n")
		return -1
	}
	return 0
}

# D1	the options string
# N	debug level
# V	the array to return
# D2	sep sep
# D3	seps
function nx_sh_opts(D1, N, V, D2, D3,
	li, ds, ks, als, fas, kas, go, gc, lo, lc, op, iop,
	fmt, cg, cl, lcr, cr, fld, grp, crgrp, cgl, alti, eret, wret,
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
	if ((D3 = split(D3, trk, ds)) > 0) {
		wret = 0
		eret = 0
		if (D3 > 9) {
			D3 = D3 - 9
			if (N > 1)
				nx_ansi_warning("separator to separate the separators was was either used within the separators as a separator or you passed '" D3 "' separators more than you should have, only the first 9 positions will be used\n")
			D3 = 9
			wret = -2
		}
		do {
			D2 = trk[D3]
			if (D2 != "") {
				if (D2 ~ /^[A-Za-z]/) {
					if (N > 1)
						nx_ansi_warning("separator '" D2 "' must not be alphanumeric\n")
					trk[D3] = ""
					wret = -2
				} else if (D2 in trk) {
					if (N > 1)
						nx_ansi_warning("separator '" D2 "' already in use as separator number '" trk[D2] "'\n")
					trk[D3] = ""
					wret = -2
				} else if (length(D2) > 1) {
					if (N > 1)
						nx_ansi_warning("separator '" D2 "' must be a single character\n")
					nx_bijective(trk, substr(D2, 1, 1), D3)
					wret = -2
				} else {
					trk[D2] = D3
				}
			}
		} while (--D3 > 0)
		D3 = 1
	} else {
		D3 = 0
	}
	ks = __nx_else(trk[1], ":") # key sep
	als = __nx_else(trk[2], "&") # alias / altname of option
	fas = __nx_else(trk[3], "@") # appendable arr sep
	kas = __nx_else(trk[4], "#") # appendable kwds sep
	go = __nx_else(trk[5], "<") # begin group
	gc = __nx_else(trk[6], ">") # eng group
	lo = __nx_else(trk[7], " ") # begin or continue long option mode
	lc = __nx_else(trk[8], ";") # end long option mode
	if (D3) {
		split("", trk, "")
		if (ks in trk) {
			trk[ks] = "key value pair"
			if (nx_sh_opts_sep("alias", als, trk, N) == -1)
				eret = -1
			if (nx_sh_opts_sep("flag array", fas, trk, N) == -1)
				eret = -1
			if (nx_sh_opts_sep("key value pair array", kas, trk, N) == -1)
				eret = -1
			if (nx_sh_opts_sep("open group", go, trk, N) == -1)
				eret = -1
			if (nx_sh_opts_sep("close group", gc, trk, N) == -1)
				eret = -1
			if (nx_sh_opts_sep("long option", lo, trk, N) == -1)
				eret = -1
			if (nx_sh_opts_sep("short option", lc, trk, N) == -1)
				eret = -1
		}
		if (eret == -1) {
			delete trk
			return -1
		}
	}
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
	op = "-"

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
				wret = -2
			} else if (cr == als) {
				alt[++alti] = lcr
				alt[-alti] = __nx_if(length(lcr) > 1, "--", "-")
				D2 = nx_sh_long(trk, lo, lc, D2, fmt)
				if (D2 == 0) {
					if (N > 0)
						nx_ansi_error("The alias chain for was never completed\n")
					eret = -1
					break
				}
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
							wret = -2
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
						if (D3 != lo && ! nx_is_alpha(D3))
							D2++
						else
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
							wret = -2
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
					wret = -2
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
	delete trk
	delete alt
	if (N > 2) {
		if (eret)
			nx_ansi_light("done D:\n")
		else if (wret)
			nx_ansi_light("done :(\n")
		else
			nx_ansi_light("done :D\n")
		if (N > 3)
			nx_sh_opts_logger(N, V, strde, grp)
	}
	if (eret)
		return -1
	return wret
}

#V2, v1, x, y, opt, N1, num, cse
function nx_sh_opts_pre_act_fsa(V, D1, D2, D3, D4, N1, N2, B)
{
	if (N1 == 4)
		V[D4] = __nx_else(V[D4] "" D1, D2, 1)
	else if (N1 == 1 || N1 == 7 || N1 == 10)
		V[D4] = nx_append_str(D1, N2, D3, B, D2, "")
}

#V2, v1, x, y, opt, N1, num, cse
function nx_sh_opts_pre_act_fsr(V, D1, D2, D3, D4, N1, N2, B)
{
	if (N1 == 1) {
		V[D4] = nx_reap_str(D3, N2, D1, !B)
	} else if (N1 == 4) {
		V[D4] = __nx_else(D1, D3, 1)
	} else {
		if (N1 == 10)
			N2 = N2 * 2
		D3 = nx_reap_str_match(D3, N2, D2, !B)
		if (N1 != 7 || D1 != "")
			V[D4] = nx_append_str(D1, 1, D3, B, D2, "")
		else
			V[D4] = D3
	}
}

function nx_sh_opts_pre_act_fs(V, D1, D2, N, B)
{
	if (N == 4) {
		V[D2] = D1
		if (D1 == "")
			nx_boolean(V, D2, B)
	} else if (N == 1 || N == 7 || N == 10) {
		V[D2] = D1
	}
}

function nx_sh_opts_pre_act(V1, V2, D1, D2, N1, N2)
{
	if (N1 == 10) {
		V1[D2] = D1 V2[++N2]
	} else if (N1 == 1 || N1 == 7) {
		V1[D2] = V2[++N2]
	}
	return N2
}


function nx_sh_opts_grp_pre(V1, V2, V3, D1, D2, D3, N1, N2, N3, N4,
	opt, cse, pos, vl, act, num, x, y)
{
	print D1 " and " D2 " and " D3
	return N4
}

function nx_sh_opts_pre(V1, V2, V3, D1, D2, D3, N1, N2, N3, N4,
	opt, cse, pos, vl, act, num, x, y)
{
	opt = D1 "" D3
	pos = (V2["-0"] -= 3)
	cse = substr(D2, 1, 1)
	x = V3["ps"]
	if ((act = V3["a"]) != "") {
		vl = V3["v"]
		num = V3["n"]
		cse = cse == tolower(cse)
		y = V2[opt]
		if (N1 == 1) {
			x = ""
		} else if (N1 == 4) {
			if (cse) {
				x = "<nx:true/>"
				y = "<nx:false/>"
			} else {
				x = "<nx:false/>"
				y = "<nx:true/>"
			}
		} else if (N1 == 10) {
			vl = D2 x vl
		}
		if (act == V3["fsa"]) {
			nx_sh_opts_pre_act_fsa(V2, vl, x, y, opt, N1, num, cse)
		} else if (act == V3["fsr"]) {
			nx_sh_opts_pre_act_fsr(V2, vl, x, y, opt, N1, num, cse)
		} else {
			nx_sh_opts_pre_act_fs(V2, vl, opt, N1, cse)
		}
	} else {
		if (N1 == 4) {
			nx_boolean(V2, opt, cse == toupper(cse))
		} else {
			N4 = nx_sh_opts_pre_act(V2, V1, D2 x, opt, N1, N4)
		}
		vl = V2[opt]
	}
	if (N2 > 2)
		nx_fd_stderr("value of '" D2 "' is now '" V2[opt] "' \n")
	V2[pos++] = __nx_if(length(D2) > 1, "--", "-") D2
	V2[pos++] = V2[opt]
	V2[pos] = vl
	return N4
}

function nx_sh_opts_actions(D1, D2, D3, V, N,
	opt, num, val,
	trk)
{
	opt = D1
	if (match(D1, "^[A-Za-z]+((" D2 ")[0-9]*)?" D3)) {
		val = substr(D1, RLENGTH + 1)
		D2 = RLENGTH
		split(substr(D1, 1, --D2), trk, "")
		while (nx_is_digit(D1 = trk[D2])) {
			num = D1 num
			D2--
		}
		while (! nx_is_alpha(D1 = trk[D2])) {
			D3 = D1 D3
			D2--
		}
		delete trk
		opt = substr(opt, 1, D2)
	} else {
		D3 = ""
	}
	if (D3 !~ /^[A-Za-z]/) {
		V["o"] = opt
		V["v"] = val
		V["a"] = D3
		V["n"] = __nx_else(num, 1, 1)
		return opt
	}
	if (N > 0)
		nx_ansi_error("the action modifier cannot start with an alphabetic character.")
	return -1
}

# D1	input
# N	debug level
# D2	arg sep
# D2	sep sep
# D4	seps
function nx_lsh_optargs(D1, N, V, D2, D3, D4,
	ps, fs, fsa, fsr,
	strde, con, tok, r, idx, cat, grp, trm, dsh, vl, wret, eret, acrgx,
	agv, trk)
{
	# Check if the input string D1 is not empty,
	if (D1 == "")
		return -1
	D3 = __nx_else(D3, ",") # Define default delimiters
	wret = 0
	eret = 0
	if ((D2 = split(D2, trk, D3)) > 0) {
		do {
			tok = trk[D2]
			if (tok != "") {
				if (tok in trk) {
					if (N > 1)
						nx_ansi_warning("separator '" D2 "' already in use as separator number '" trk[tok] "'\n")
					trk[D2] = ""
					wret = -2
				} else {
					trk[tok] = D2
				}
			}
		} while (--D2 > 0)
		D2 = 1
	} else {
		D2 = 0
	}
	ps = __nx_else(trk[1], "<nx:null/>") # Param sep
	fs = __nx_else(trk[2], "=") # optional set flag sep
	fsa = __nx_else(trk[3], "+") # optional push flag sep
	fsr = __nx_else(trk[4], "-") # optional pop flag sep
	con = __nx_else(trk[5], " ", 1) # concat sep of remainder string
	con = __nx_if(con == "<nx_null/>", "", con)

	acrgx = "[" fsa "]|[" fsr "]"
	trk["fs"] = fs
	trk["ps"] = ps
	trk["fsa"] = fsa fs
	trk["fsr"] = fsr fs
	if (D2) {
		split("", trk, "")
		trk[ps] = "parameter"
		if (nx_sh_opts_sep("optional set flag", fs, trk, N) == -1)
			eret = -1
		if (nx_sh_opts_sep("optional push flag", fsa, trk, N) == -1)
			eret = -1
		if (nx_sh_opts_sep("optional pop flag", fsr, trk, N) == -1)
			eret = -1
		if (eret == -1) {
			delete trk
			return -1
		}
	}
	cnt = split(D1, agv, ps)
	nx_sh_opts(agv[1], N, V, D3, D4)
	strde = V[0]
	trm = 1
	for (D2 = 2; D2 <= cnt; ++D2) {
		tok = agv[D2]
		dsh = "-"
		vl = ""
		if (trm > 0 && sub(/^-/, "", tok)) {
			if (sub(/^-/, "", tok)) {
				if (tok == "") {
					trm = 0
					if (N > 2)
						nx_ansi_light("end of arguments detected  '--' appending remainder\n")
					continue
				}
				if (length(tok = nx_sh_opts_actions(tok, acrgx, fs, trk, N)) > 1 && tok in V) {
					if (N > 2)
						nx_ansi_debug("long form option '" tok "' was registered, preceding\n")
					trm = 2
				}
			} else if (length(tok = nx_sh_opts_actions(tok, acrgx, fs, trk, N)) == 1 && tok in V) {
				if (N > 2)
					nx_ansi_success("short form option '" tok "' was registered, preceding\n")
				trm = 2
			}
		}
		if (trm < 2) {
			tok = agv[D2]
			r = nx_join_str(r, tok, ps)
			if (N > 2)
				nx_ansi_alert("appending '" tok "' to remainder \n")
			continue
		}
		trm = 1
		cat = tok
		idx = V[cat]
		while (! nx_is_digit(idx)) {
			cat = idx
			idx = V[cat]
		}
		grp = idx % strde
		if (length(cat) > 1)
			dsh = "--"
		if (N > 2) {
			if (cat != tok)
				nx_ansi_alert("aliased token '" tok "' mapped to '" cat "'\n")
			nx_ansi_light("token index for '" cat "' registered under '" idx " and part of the '" grp "' id\n")
		}
		if (grp < 13) {
			D2 = nx_sh_opts_pre(agv, V, trk, dsh, tok, cat, grp, idx, N, D2)
		} else {
			D2 = nx_sh_opts_grp_pre(agv, V, trk, dsh, tok, cat, grp, idx, N, D2)
		}
	}
	V[-1] = r
	gsub(ps, con, r)
	V[-2] = r
	if (N > 2)
		nx_fd_stderr("remainder is '" r "' \n")
	delete agv
	delete trk
}

