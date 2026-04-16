#nx_include nex-sh.awk
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
function nx_sh_stride(D1, D2, D3,
	cnt)
{
	cnt = 0
	while (match(D1, D2)) {
		# TODO is it 3 still?
		cnt += 3
		D1 = substr(D1, RSTART + RLENGTH)
		if (! match(D1, D3))
			return -1
		D1 = substr(D1, RSTART + RLENGTH)
	}
	return cnt
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

function nx_shell_opts(D1, V, D2, N, D3,
	acm, lop, li, ds, ks, fas, kas, go, gc, lo, lc, op, iop,
	fmt, cg, cl, lcr, cr, fld, grp, crgrp, cgl, idx, eret, wret,
	trk, dbg)
{
	# Check if the input string D1 is not empty,
	if (D1 == "")
		return -1
	ds = __nx_else(D2, ",") # Define default delimiters
	split(N, trk, ds)
	dbg = int(trk[1])

	if ((D3 = split(D3, trk, ds)) > 0) {
		wret = 0
		eret = 0
		if (D3 > 7) {
			D3 = D3 - 7
			if (dbg > 1)
				nx_ansi_warning("separator to separate the separators was was either used within the separators as a separator or you passed '" D3 "' separators more than you should have, only the first 9 positions will be used\n")
			D3 = 7
			wret = -2
		}
		do {
			D2 = trk[D3]
			if (D2 != "") {
				if (D2 in trk) {
					if (dbg > 1)
						nx_ansi_warning("separator '" D2 "' already in use as separator number '" trk[D2] "'\n")
					trk[D3] = ""
					wret = -2
				} else if (length(D2) > 1) {
					if (dbg > 1)
						nx_ansi_warning("separator '" D2 "' must be a single character\n")
					nx_bijective(trk, substr(D2, 1, 1), D3)
					wret = -2
				} else if (nx_is_alpha(D2)) {
					if (dbg > 1)
						nx_ansi_warning("separator '" D2 "' must not be alphanumeric\n")
					trk[D3] = ""
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
	fas = __nx_else(trk[2], "@") # appendable arr sep
	kas = __nx_else(trk[3], "#") # appendable kwds sep
	go = __nx_else(trk[4], "<") # begin group
	gc = __nx_else(trk[5], ">") # eng group
	lo = __nx_else(trk[6], " ") # begin or continue long option mode
	lc = __nx_else(trk[7], ";") # end long option mode

	if (D3) {
		split("", trk, "")
		trk[ks] = "key value pair"
		if (nx_delim_sep("flag array", fas, trk, dbg) == -1)
			eret = -1
		if (nx_delim_sep("key value pair array", kas, trk, dbg) == -1)
			eret = -1
		if (nx_delim_sep("open group", go, trk, dbg) == -1)
			eret = -1
		if (nx_delim_sep("close group", gc, trk, dbg) == -1)
			eret = -1
		if (nx_delim_sep("long option", lo, trk, dbg) == -1)
			eret = -1
		if (nx_delim_sep("short option", lc, trk, dbg) == -1)
			eret = -1
		if (eret == -1) {
			delete trk
			return -1
		}
	}

	if ((D2 = nx_sh_stride(D1, go, gc)) == -1) {
		if (dbg > 0)
			nx_ansi_error("the group terminator '" gc "' ran away\n")
		delete trk
		return -1
	}

	fmt = split(D1, trk, "")
	strde = 12 + D2
	nx_parr_stk(V, strde)
	if (dbg > 2)
		nx_ansi_alert("passed param string was " D1 "\n")
	D2 = nx_sh_long(trk, lo, lc, 0, fmt)
	grp = 13
	cg = 0

	for (idx = 1; idx <= fmt; ++idx) {
		cr = trk[idx]
		D1 = cr == lo
		if (D1 || cr == lc) {
			lop = D1
			cr = trk[++idx]
		}
		if (nx_is_alpha(cr)) {
			acm = cr
			cr = trk[++idx]
			if (lop) {
				while (nx_is_alpha(cr)) {
					acm = acm cr
					cr = trk[++idx]
				}
				D1 = 0
			} else {
				D1 = nx_is_alpha(cr)
			}

			if (D1 || cr == lo || cr == lc || cr == "" || cg) {
				if (D1)
					idx = idx - !lop
				else
					lop = cr == lo
				if (cg) {
					D1 = nx_parr_stk(V, grp, acm)
					if (cr == gc) {
						cg = 0
						grp = grp + 3
						if (dbg > 2)
							nx_ansi_debug(acm " is end of group leader type '" cgl "' with leader " lcr " position " D1 "'\n")
					}
				} else {
					D1 = nx_parr_stk(V, 4, acm)
					if (N > 2)
						nx_ansi_success("passed param '" acm "' was registered as a flag at position '" D1 "'\n")
				}
			} else if (cr == go) {
				lcr = acm
				cg = 1
				cgl = trk[idx + 1]
				if (nx_is_alpha(cgl))
					cgl = ""
				else
					++idx
				D1 = nx_parr_stk(V, grp, acm)
				if (dbg > 2)
					nx_ansi_light("passed param '" acm "' was registered as a group leader at position '" D1 "'\n")
			} else if (cr == ks) {
				D1 = nx_parr_stk(V, 1, acm)
				if (dbg > 2)
					nx_ansi_debug("passed param '" acm "' was registered as a keyword argument at position '" D1 "'\n")
			} else if (cr == fas) {
				D1 = nx_parr_stk(V, 7, acm)
				if (dbg > 2)
					nx_ansi_success("passed param '" acm "' was registered as a flag array (appendable) at position '" D1 "'\n")
			} else if (cr == kas) {
				D1 = nx_parr_stk(V, 10, acm)
				if (dbg > 2)
					nx_ansi_debug("passed param '" acm "' was registered as a keyword array (appendable) at position '" D1 "'\n")
			} else if (dbg > 1) {
				nx_ansi_warning("passed param '" acm "' was not registered, '" cr "' is not a known group\n")
				wret = -2
				continue
			}

			V[acm] = D1
		}
	}
	delete trk
	if (dbg > 2) {
		if (eret)
			nx_ansi_light("done D:\n")
		else if (wret)
			nx_ansi_light("done :(\n")
		else
			nx_ansi_light("done :D\n")
		if (dbg > 3)
			nx_sh_opts_logger(N, V, strde, grp)
	}
	if (eret)
		return -1
	return wret
}

function nx_shell_args(D1, V, D2, N, D3, D4,
	ds, ps, fs, fsa, fsr, dbg,
	strde, con, tok, r, idx, cat, grp, trm, dsh, vl, wret, eret, acrgx,
	agv, trk)
{
	# Check if the input string D1 is not empty,
	if (D1 == "")
		return -1
	ds = __nx_else(D2, ",") # Define default delimiters
	split(N, trk, ds)
	dbg = int(trk[1])

	wret = 0
	eret = 0
	if ((D2 = split(D3, trk, ds)) > 0) {
		do {
			tok = trk[D2]
			if (tok != "") {
				if (tok in trk) {
					if (dbg > 1)
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
		if (nx_delim_sep("optional set flag", fs, trk, dbg) == -1)
			eret = -1
		if (nx_delim_sep("optional push flag", fsa, trk, dbg) == -1)
			eret = -1
		if (nx_delim_sep("optional pop flag", fsr, trk, dbg) == -1)
			eret = -1
		if (eret == -1) {
			delete trk
			return -1
		}
	}

	cnt = split(D1, agv, ps)
	nx_shell_opts(agv[1], V, ds, N, D4)
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
					if (dbg > 2)
						nx_ansi_light("end of arguments detected  '--' appending remainder\n")
					continue
				}
				if (length(tok = nx_shell_actions(tok, acrgx, fs, trk, dbg)) > 1 && tok in V) {
					if (dbg > 2)
						nx_ansi_debug("long form option '" tok "' was registered, preceding\n")
					trm = 2
				}
			} else if (length(tok = nx_shell_actions(tok, acrgx, fs, trk, dbg)) == 1 && tok in V) {
				if (dbg > 2)
					nx_ansi_success("short form option '" tok "' was registered, preceding\n")
				trm = 2
			}
		}
		if (trm < 2) {
			tok = agv[D2]
			r = nx_join_str(r, tok, ps)
			if (dbg > 2)
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
		if (dbg > 2) {
			if (cat != tok)
				nx_ansi_alert("aliased token '" tok "' mapped to '" cat "'\n")
			nx_ansi_light("token index for '" cat "' registered under '" idx " and part of the '" grp "' id\n")
		}
		print grp
	}
	V[-1] = r
	gsub(ps, con, r)
	V[-2] = r
	if (N > 2)
		nx_fd_stderr("remainder is '" r "' \n")
	delete agv
	delete trk
}

function nx_shell_actions(D1, D2, D3, V, N,
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
		nx_ansi_error("the action modifier cannot start with an alphabetic character.\n")
	return -1
}

