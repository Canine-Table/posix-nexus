#nx_include nex-log-extras.awk

# D1	the string
# D2	the opening group
# D3	the closing group
function nx_shell_stride(D1, D2, D3,
	cnt)
{
	cnt = 0
	while (match(D1, D2)) {
		cnt += 3
		D1 = substr(D1, RSTART + RLENGTH)
		if (! match(D1, D3))
			return -1
		D1 = substr(D1, RSTART + RLENGTH)
	}
	return cnt
}

function nx_shell_diff(D1, V1, D2, V2,
	carr, cr)
{
	if (! split(D1, carr, __nx_else(D2, "", 1))) {
		delete carr
		return ""
	}

	D2 = ""
	for (D1 in carr) {
		cr = carr[D1]
		if (! (cr in V2 || cr in V1)) {
			V1[cr] = D1
			D2 = D2 cr
		}
	}
	delete carr
	return D2
}

function __nx_shell_skip(D1, V, D2, N1, N2)
{
	if (D1 ~ D2) {
		while (D1 ~ D2)
			D1 = V[++N1]
		return N1 + int(N2)
	}
	return N1
}

function nx_shell_opts_logger(N, V, D1, D2,
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
				str = "\ngroup '" V[j + D1] "' " V[j] ":"
				srt = V[i]
				for (j += D1 + D1; j <= srt; j += D1)
					str = str " " V[j]
				nx_ansi_info(str)
			}
		}
	}
	nx_fd_stderr("\n")
}

function nx_shell_opts(D1, V1, D2, N, D3, V2,
	obol, lo, lc,
	gfr, gcr, gsym, goff, gbse, gpos, gbol, grp, cgrp, go, gc, gent,
	dbol, djmp, dmov,
	acm, rgx, rcr, lcr, cr,
	vb2, vb2msg,
	ds, fas, ext,
	sln, smx,
	ks, kas,
	fmt, idx, bol,
	eret, wret,
	ovr, dbg,
	flw, skp, sbol,
	trk)
{
	if (D1 ~ /^[ \t\n\v\r\f]*$/) {
		nx_ansi_error("please provide something to work with, '" D1 "' is not understood here yet\n")
		return -1
	}

	ds = __nx_else(D2, "<nx:null/>")
	split(N, trk, ds)
	dbg = int(trk[1])
	ovr = int(trk[2])
	gfr = int(trk[6])

	if ((sln = split(D3, trk, ds)) > 0) {
		smx = 7
		if (dbg > 1) {
			if (sln > smx + 1)
				nx_ansi_warning("'" D3 "' separator to separate the separators was was either used within the separators as a separator or you passed '"  sidx - smn  "' separators more than you should have, only the first '" smx "' positions will be used\n")
			for (idx = 1; idx <= smx; ++idx) {
				acm = trk[idx]
				if (acm != "") {
					eret = 1
					if (acm in trk) {
						nx_ansi_warning("separator '" acm "' already in use as separator number '" trk[acm] "'\n")
					} else if (length(acm) > 1) {
						nx_ansi_warning("separator '" acm "' must be a single character\n")
					} else if (nx_is_alnum(acm)) {
						nx_ansi_warning("separator '" acm "' must not be alphanumeric\n")
					} else {
						eret = 0
						trk[acm] = idx
					}
					if (eret)
						wret = -1
				}
			}
		} else {
			for (idx = 1; idx <= smx; ++idx) {
				if (acm in trk || nx_is_alnum(acm) || length(acm) > 1) {
					wret = -2
				} else {
					trk[acm] = idx
				}
			}
		}
	}

	ks = __nx_else(trk[1], "%") # key sep
	fas = __nx_else(trk[2], "@") # appendable arr sep
	kas = __nx_else(trk[3], "#") # appendable kwds sep
	go = __nx_else(trk[4], "<") # begin group
	gc = __nx_else(trk[5], ">") # eng group
	lo = __nx_else(trk[6], ",") # begin or continue long option mode
	lc = __nx_else(trk[7], ";") # end long option mode
	ext = __nx_else(trk[8], "-_:.") # extra characters allowed between alpha characters in long option mode
	skp = __nx_else(trk[9], "\n\v\f\t\r ") # extra characters that hold no meaning and should be skipped

	if (nx_delim_sep("key value pair", ks, V2, dbg) == -1)
		eret = -1
	if (nx_delim_sep("flag array", fas, V2, dbg) == -1)
		eret = -1
	if (nx_delim_sep("key value pair array", kas, V2, dbg) == -1)
		eret = -1
	if (nx_delim_sep("open group", go, V2, dbg) == -1)
		eret = -1
	if (nx_delim_sep("close group", gc, V2, dbg) == -1)
		eret = -1
	if (nx_delim_sep("long option", lo, V2, dbg) == -1)
		eret = -1
	if (nx_delim_sep("short option", lc, V2, dbg) == -1)
		eret = -1

	if (eret == -1) {
		delete trk
		return -1
	}

	if ((idx = nx_shell_stride(D1, go, gc)) == -1) {
		if (dbg > 0)
			nx_ansi_error("the group terminator '" gc "' ran away\n")
		delete trk
		return -1
	}

	strde = 12 + idx
	nx_parr_stk(V1, strde)
	V1[ks] = nx_parr_stk(V1, 1, ks)
	V1[lo] = nx_parr_stk(V1, 4, lo)
	V1[fas] = nx_parr_stk(V1, 7, fas)
	V1[kas] = nx_parr_stk(V1, 10, kas)
	goff = strde + strde

	split("", trk, "")
	rgx = nx_shell_diff(ext, trk, "", V2)
	flw = "(" nx_str_esc(nx_shell_diff(skp, trk, "", V2), 2) ")+"

	acm = "([a-zA-Z]"
	if (lcr = rgx) {
		rcr = nx_str_esc(lcr, 2)
		rgx = "([a-zA-Z]|" rcr
		acm = acm rgx ")*"
		rcr = rcr ")+$"
		rgx = rgx ")+$"
		rcr = "(" rcr
	} else {
		rgx = "[a-zA-Z]+$"
	}

	V1[strde] = acm ")?"
	V1[goff] = ext
	V1[goff + strde] = flw
	V1[goff + goff] = skp

	fmt = split(D1, trk, "")
	if (dbg > 2)
		nx_ansi_alert("passed param string was " D1 "\n")

	grp = 13
	gbol = 0

	for (idx = 1; idx <= fmt; ++idx) {
		cr = trk[idx = __nx_shell_skip(trk[idx], trk, flw, idx)]
		if (idx > fmt)
			break

		bol = cr == lo
		if (bol || cr == lc) {
			if (obol != bol) {
				if (dbg > 2)
					nx_ansi_info(__nx_if(obol == "", "applying form to " __nx_if(bol, "long form", "short form"), "updating form from " __nx_if(obol, "long form to short form", "short form to long form")) "\n")
				obol = bol
			}
			cr = trk[idx = __nx_shell_skip(trk[++idx], trk, flw, idx)]
		}

		if (nx_is_alpha(cr)) {
			acm = cr
			cr = trk[++idx]
			if (obol) {
				while (cr ~ rgx) {
					acm = acm cr
					cr = trk[++idx]
				}
				if (lcr && gsub(rcr, "", acm) && dbg > 1)
					nx_ansi_alert("trailing '" lcr "' found after '" acm "'\n")
				if (cr ~ flw)
					cr = trk[idx = __nx_shell_skip(cr, trk, flw, idx)]
			}
			bol = nx_is_alpha(cr)

			if (acm in V1) {
				dmov = 0
				if (gbol) {
					if (dbg > 1)
						nx_ansi_warning("argument '" acm "' was already registered\n")
					idx--
				} else {
					gpos = V1[acm]
					gbse = gpos % strde
					if (gbse > 12 && gbse + goff == gpos && cr == go) {
						gcr = acm
						gbol = 1

						if (nx_is_alpha(gsym = trk[__nx_shell_skip(trk[idx], trk, flw, idx)]) || gsym == gc) {
							if (gsym == gc)
								--idx
							gsym = lo
						}

						if (ovr)
							V1[gbse + strde] = gsym
						else
							gsym = V1[gbse + strde]
						cgrp = grp
						grp = gbse
						if (dbg > 2)
							nx_ansi_light("adding on to '" acm "' of type '" gsym "'\n")
					} else if (cr == go) {
						gsym = trk[__nx_shell_skip(trk[++idx], trk, flw, idx)]
						if (nx_is_alpha(gsym) || gsym == gc) {
							--idx
							gsym = lo
						}

						if (gfr == 1) {
							if (ovr) {
								if (dbg > 1)
									nx_ansi_warning("replacing '" V1[gbse + strde] "' with '" gsym "' type for group entries within the schelar once refered to as '" acm "'\n")
							} else {
								cr = gsym
								gsym = V1[gbse + strde]
								if (dbg > 1)
									nx_ansi_warning("discarding old type '" cr "' and reusing '" gsym "' type for original entry '" acm "' first declaration\n")
							}
							dbol = V1[gsym] - strde
						} else if (gfr == 2) {
							dmov = 1
							dbol = 0
							cr = nx_parr_stk(V1, gbse)
							if (cr == acm) {
								delete V1[V1[cr]]
							} else {
								dmov = V1[acm]
								V1[cr] = dmov
								V1[dmov] = cr
								delete V1[acm]
							}

							if (ovr) {
								if (dbg > 2)
									nx_ansi_light("param override disabled\n")
								gsym = V1[gbse + strde]
								cr = trk[idx + 1];
								if (nx_is_alpha(cr) || cr == gc) {
									trk[idx] = gsym
									trk[--idx] = go
								} else {
									trk[idx + 1] = gsym
								}
							} else {
								if (dbg > 2)
									nx_ansi_light("param override enabled\n")
							}

							cr = go
							if (dbg > 2)
								nx_ansi_light("param override of '" acm "' was prepaired to be registered as a group leader'\n")
						} else {
							D1 = acm
							acm = ""
							D2 = ""
							while (++idx <= fmt) {
								if ((cr = trk[idx = __nx_shell_skip(trk[idx], trk, flw, idx)]) == gc)
									break
								dbol = cr == lo
								if (dbol || cr == lc)
									D2 = dbol
								acm = acm cr
							}

							if (ovr && D2 != "" && D2 != obol) {
								if (dbg > 2)
									nx_ansi_info("ovrride was set, " __nx_if(obol == "", "applying form to " __nx_if(D2, "long form", "short form"), "updating form from " __nx_if(obol, "long form to short form", "short form to long form")) "\n")
								obol = D2
							}

							if (dbg > 1) {
								D2 = V1[V1[D1] % strde + strde]
								nx_ansi_warning("skipping past '" D1 "' group entries '" acm "' as '" D1 "' is already of type '" V2[D2] "' assigned the symbol '" D2 "'\n")
							}
							dbol = 0
						}
					} else {
						if (dbg > 1)
							nx_ansi_warning("argument '" acm "' was already registered\n")
						idx--
					}
				}
				if (!dmov)
					continue
			}

			# skip characters are implicit flags with sbol
			sbol = nx_is_alpha(cr = trk[idx = __nx_shell_skip(cr, trk, flw, idx)])

			if (dbol) {
				djmp = cr == lo
				if ((djmp || cr == lc) && djmp != obol) {
					if (dbg > 2)
						nx_ansi_info(__nx_if(obol == "", "setting form to " __nx_if(djmp, "long form", "short form"), "updating form from " __nx_if(obol, "long form to short form", "short form to long form")) "\n")
					obol = djmp
				}
				djmp = cr
				cr = gsym
				if (djmp != gc)
					djmp = ""
			}

			if (cr == gc && !gbol) {
				cr = __nx_if(obol, lo, lc)
				if (dbg > 2)
					nx_ansi_warning("extra '" gc "' detected after '" acm "' changing type to '" cr "'\n")
			}

			if (sbol || bol || cr == lo || cr == lc || cr == "" || gbol) {
				if (sbol) {
					if (dbg > 2)
						nx_ansi_info("sbol 'true', '" acm "' and '" cr "' backtracking next iteration\n")
					--idx
				} else if (cr != gc) {
					bol = cr == lo
					if ((bol || cr == lc) && bol != obol) {
						if (dbg > 2)
							nx_ansi_info(__nx_if(obol == "", "applying form to " __nx_if(bol, "long form", "short form"), "updating form from " __nx_if(obol, "long form to short form", "short form to long form")) "\n")
						obol = bol
						--idx
					}
				}
				if (gbol) {
					gpos = nx_parr_stk(V1, grp, acm)
					if (cr == gc) {
						gbol = 0
						if (cgrp > grp) {
							if (dbg > 2)
								nx_ansi_info("group reset from '" grp "' to '" cgrp "'\n")
							grp = cgrp
						} else {
							grp = grp + 3
						}
						if (dbg > 2)
							nx_ansi_debug("member '" acm "' is end of group leader type '" gsym "' with leader '" gcr "' at position '" gpos "'\n")
					}
				} else if (dbol) {
					gpos = nx_parr_stk(V1, dbol, acm)
					if (dbg > 2)
						nx_ansi_success("passed param '" acm "' was modified to from type '" cr "'  to type '" gsym "' at position '" gpos "'\n")
				} else {
					gpos = nx_parr_stk(V1, 4, acm)
					if (dbg > 2)
						nx_ansi_success("passed param '" acm "' was registered as a flag at position '" gpos "'\n")
				}
			} else if (cr == go) {
				gcr = acm
				gbol = 1
				gsym = trk[idx + 1]
				cr = trk[idx = __nx_shell_skip(gsym, trk, flw, idx)]
				if (nx_is_alpha(gsym) || gsym == gc) {
					gsym = lo
				} else if (nx_is_alpha(cr) || cr == gc) {
					gsym = lo
					--idx
				} else {
					++idx
				}
				nx_parr_stk(V1, grp, gsym)
				gpos = nx_parr_stk(V1, grp, acm)
				if (dbg > 2)
					nx_ansi_light("passed param '" acm "' was registered as a group leader of type '" gsym "' at position '" gpos "'\n")
			} else if (cr == ks) {
				gpos = nx_parr_stk(V1, 1, acm)
				if (dbg > 2)
					nx_ansi_debug("passed param '" acm "' was registered as a keyword argument at position '" gpos "'\n")
			} else if (cr == fas) {
				gpos = nx_parr_stk(V1, 7, acm)
				if (dbg > 2)
					nx_ansi_success("passed param '" acm "' was registered as a flag array (appendable) at position '" gpos "'\n")
			} else if (cr == kas) {
				gpos = nx_parr_stk(V1, 10, acm)
				if (dbg > 2)
					nx_ansi_debug("passed param '" acm "' was registered as a keyword array (appendable) at position '" gpos "'\n")
			} else if (dbg > 1) {
				nx_ansi_warning("passed param '" acm "' was not registered, '" cr "' is not a known group\n")
				wret = -2
				continue
			}
			V1[acm] = gpos
			D2 = V1[2 + strde]
			if (djmp)
				--idx
		} else if (cr == gc) {
			if (gbol) {
				gbol = 0
				if (cgrp > grp) {
					grp = cgrp
				} else {
					grp = grp + 3
				}
				if (dbg > 2)
					nx_ansi_debug(acm " is end of group leader type '" gsym "' with leader " gcr " position " gpos "'\n")
			} else if (dbol) {
				dbol = 0
				djmp = ""
			} else if (dbg > 1) {
				nx_ansi_warning("extra '" gc "' detected after '" acm __nx_if(nx_is_alpha(trk[idx - 1]), cr, trk[idx - 1]) "', discarding\n")
			}
		} else if (cr == go && gcr != "") {
			#TODO
			#type
			#default
			#epilog
			#usage
			#description
			#help

			
			acm = trk[idx = __nx_shell_skip(trk[++idx], trk, flw, idx)]
			while (nx_is_alpha(cr = trk[++idx]))
				acm = acm cr
			if (acm == "type") {
				gent = 0
			} else if (acm == "default") {
				gent = 1
			} else if (acm == "epilog") {
				gent = 2
			} else if (acm == "usage") {
				gent = 3
			} else if (acm == "description") {
				gent = 4
			} else {
				nx_ansi_warning("provided '" acm "' is garbage, what do you wish this to mean? discarding\n")
				continue
			}
			
			acm = trk[idx = __nx_shell_skip(trk[++idx], trk, flw, idx)]

			while ((cr = trk[++idx]) != gc) {
				if (cr == "\x5c")
					cr = trk[++idx]
				acm = acm cr
			}
			V1[(V1[V1[gcr] - goff] + 1) + strde * gent] = acm

		} else {
			if (dbg > 1)
				nx_ansi_warning("provided '" cr "' is garbage, what do you wish this to mean? discarding\n")
			wret = -2
		}
	}

	delete trk
	if (dbg > 3)
		nx_shell_opts_logger(dbg, V1, strde, grp)
	if (eret = int(eret))
		return eret
	return int(wret)
}

function nx_shell_args(D1, V, D2, N, D3, D4,
	ds, ps,
	fs, fa, fr,
	dbg, bk, ovr, ab,
	ctp, cidx,
	oln, oidx,
	strde, con, tok,
	r, s, n,
	idx, cat, grp, trm,
	dsh, vl,
	wret, eret,
	acrgx, eacrgx,
	agv, trk)
{
	if (D1 ~ /^[ \t\n\v\r\f]*$/) {
		nx_ansi_error("please provide something to work with, '" D1 "' is not understood here yet\n")
		return -1
	}

	ds = __nx_else(D2, "<nx:null/>")
	split(N, trk, ds)
	dbg = int(trk[1])
	ovr = int(trk[2])
	bk = int(trk[3])
	ab = int(trk[7])

	sub("^<nx:null/><nx:null/>", "<nx:null/>", D3)
	if ((idx = split(D3, trk, ds)) > 0) {
		amx = 3
		if (dbg > 1) {
			do {
				tok = trk[idx]
				if (tok != "") {
					if (tok in trk) {
						nx_ansi_warning("separator '" tok "' already in use as separator number '" trk[tok] "'\n")
						trk[idx] = ""
						wret = -2
					} else {
						trk[tok] = idx
					}
				}
			} while (--idx > 0)
		} else {
			do {
				if (trk[idx] != "") {
					if (tok in trk) {
						trk[idx] = ""
						wret = ""
					} else {
						trk[tok] = idx
					}
				}
			} while (--idx > 0)
		}
	}

	ps = __nx_else(trk[1], "<nx:null/>") # Param sep
	fs = __nx_else(trk[2], "=") # optional set flag sep
	fa = __nx_else(trk[3], "+") # optional push flag sep
	fr = __nx_else(trk[4], "-") # optional pop flag sep
	con = __nx_else(trk[5], " ", 1) # concat sep of remainder string
	con = __nx_if(con == "<nx_null/>", "", con)
	acrgx = "[" fa "]|[" fr "]"

	V["-0"] = __nx_if(V["-0"] < -3, V["-0"], -3)
	cnt = split(D1, agv, ps) + 1

	if (nx_shell_opts(agv[1], V, ds, N, D4) == -1)
		return -2

	strde = V[0]

	split("", trk, "")
	if (nx_delim_sep("parameter", ps, trk, dbg) == -1)
		eret = -1
	if (nx_delim_sep("optional set flag", fs, trk, dbg) == -1)
		eret = -1
	if (nx_delim_sep("optional push flag", fa, trk, dbg) == -1)
		eret = -1
	if (nx_delim_sep("optional pop flag", fr, trk, dbg) == -1)
		eret = -1

	if (eret == -1) {
		delete trk
		return -1
	}

	eacrgx = V[strde] "[A-Za-z]+"
	V[strde * 5] = eacrgx
	V[strde * 6] = ps
	V[strde * 7] = con
	V[strde * 8] = fa
	V[strde * 9] = fr

	trm = 1
	ctp = cnt
	cidx = cnt
	idx = 10
	do {
		agv["-" V[idx + strde]] = idx
		idx = idx - 3
	} while (idx > 1)
	agv["-" V[idx + strde]] = idx
	while (idx < cnt) {
		if (ctp > cnt) {
			if (cidx == ctp) {
				ctp = cnt
				cidx = cnt
				continue
			}
			tok = agv[++cidx]
		} else {
			tok = agv[++idx]
		}

		if (trm > 0 && sub(/^-/, "", tok)) {
			if (sub(/^-/, "", tok)) {
				if (tok == "") {
					trm = 0
					if (dbg > 2)
						nx_ansi_light("end of arguments detected  '--' appending remainder\n")
					continue
				} else if (length(tok = nx_shell_actions(tok, acrgx, fs, agv, dbg, eacrgx)) > 1 && tok in V) {
					if (dbg > 2)
						nx_ansi_debug("long form option '" tok "' was registered, preceding\n")
					trm = 2
				}
			} else if (nx_shell_actions(tok, acrgx, fs, agv, dbg, eacrgx) != -1) {
				opt = agv["opt"]
				if (length(opt) > 1) {
					vl = agv["mod"] agv["num"] agv["act"] agv["val"]
					oln = split(opt, trk, "")
					opt = ""
					for (oidx = 1; oidx <= oln; ++oidx) {
						tok = trk[oidx]
						if (tok in V) {
							if (dbg > 2)
								nx_ansi_alert("short form bundle option '-" tok vl "' was registered, preceding\n")
							agv[++ctp] = "-" tok vl
						} else {
							opt = opt tok
						}
					}
					trm = 2
					if (bk && opt)
						agv[idx--] = opt
					continue
				} else if (opt in V) {
					if (dbg > 2)
						nx_ansi_success("short form option '" opt "' was registered, preceding\n")
					trm = 2
					tok = opt
				}
			}
		}

		if (trm < 2) {
			if (ab) {
				if (ab == 1)
					break
				trm = 0
			}
			tok = agv[idx]
			s = nx_join_str(s, tok, ps)
			r = nx_join_str(r, tok, con)
			++n
			if (dbg > 2)
				nx_ansi_alert("appending '" tok "' to remainder \n")
			continue
		}

		trm = 1
		cat = V[tok]
		grp = cat % strde

		if (dbg > 2) {
			if (grp < 13)
				nx_ansi_light("token index for '" tok "' registered under '" cat "' and part of the '" grp "' id\n")
			else
				nx_ansi_light("token index for '" tok "' registered under '" cat "' and part of the '" grp "' id, with the group leader of type '" V[grp + strde] "' being '" V[grp + strde + strde] "'\n")
		}
		idx = nx_shell_dispatch(V, agv, idx, grp)
	}

	V[-1] = r
	V[-2] = s
	V[-3] = n - 1
	if (dbg > 2)
		nx_ansi_alert("remainder is '" r "' \n")
	delete agv
	delete trk
	if (eret = int(eret))
		return eret
	return int(wret)
}

function nx_shell_help(V,
	str, srt, strde, soff, moff,
	ldr,
	i, j)
{
	strde = V[0]
	soff = strde + strde
	srt = V[1]
	for (i = 1 + soff; i <= srt; i += strde)
		str = str " " V[i]
	if (str != "") {
		nx_ansi_info("\n(" V[1 + strde] ") keywords:" str)
		str = ""
	}

	srt = V[4]
	for (i = 4 + soff; i <= srt; i += strde)
		str = str " " V[i]
	if (str) {
		nx_ansi_info("\n(" V[4 + strde] ") flags:" str)
		str = ""
	}

	srt = V[7]
	for (i = 7 + soff; i <= srt; i += strde)
		str = str " " V[i]
	if (str) {
		nx_ansi_info("\n(" V[7 + strde] ") flag arrays:" str)
		str = ""
	}

	srt = V[10]
	for (i = 10 + soff; i <= srt; i += strde)
		str = str " " V[i]
	if (str) {
		nx_ansi_info("\n(" V[10 + strde] ") keyword arrays:" str)
		str = ""
	}


	if (strde > 13) {
		for (i = 13; i <= strde; i =  i + 3) {
			j = i + strde

			ldr = V[j + strde]
			# TODO find the bug causing this
			if (!(ldr in V))
				break

			str = "\n("  V[j] ") group '" ldr "' ->"
			srt = V[i]
			for (j += soff; j <= srt; j += strde)
				str = str " " V[j]
			nx_ansi_info(str)

			moff = V[i] + 1
			j = 0
			if (moff in V) {
				nx_ansi_debug("\ntype:\n\t'" V[moff] "'")
				j = 1
			}

			moff = moff + strde
			if (moff in V) {
				nx_ansi_debug("\ndefault:\n\t'" V[moff] "'")
				j = 1
			}

			moff = moff + strde
			if (moff in V) {
				nx_ansi_success("\nepilog:\n\t'" V[moff] "'")
				j = 1
			}

			moff = moff + strde
			if (acm == "usage") {
				nx_ansi_alert("\usage:\n\t'" V[moff] "'")
				j = 1
			}

			moff = moff + strde
			if (moff in V) {
				nx_ansi_light("\ndescription:\n\t'" V[moff] "'")
				j = 1
			}

			if (j)
				nx_fd_stderr("\n")
		}
	}
	nx_fd_stderr("\n")
}

function nx_shell_dispatch(V1, V2, N1, N2,
	strde, cat, sym, arg, opt, act, mod, val, num, cse, dsh, cur, idx,
	con, ps, vr)
{
	strde = V1[0]
	sym = "-" V1[N2 + strde]
	cat = V2[sym]
	ps = V2["ps"]

	if (N2 < 13) {
		opt = V2["opt"]
		con = ""
	} else {
		opt = V1[N2 + strde + strde]
		con = "G"
	}

	if (length(opt) > 1)
		dsh = "--"
	else
		dsh = "-"

	if (! (dsh opt in V1)) {
		idx = V1["-0"] - 1
		V1[idx] = dsh opt
		V1[dsh opt] = idx--
		if (cat == 1)
			V1[idx] = "NEX_" con "k_" opt
		else if (cat == 4)
			V1[idx] = "NEX_" con "f_" opt
		else if (cat == 7)
			V1[idx] = "NEX_" con "F_" opt
		else if (cat == 10)
			V1[idx] = "NEX_" con "K_" opt
		else
			V1[idx] = "NEX_" con "_" opt
		V1["-0"] = --idx
	} else {
		idx = V1[dsh opt] - 2
	}

	vr = opt
	opt = V2["opt"]
	cse = nx_is_lower(substr(opt, 1, 1))
	ps =  V1[strde * 6]
	con = V1[strde * 7]
	cur = V1[idx]

	if ((act = V2["act"])  == "") {
		if (cat == 1) {
			V1[idx] = V2[++N1]
		} else if (cat == 4) {
			if (vr == "help" || vr == "h") {
				#print "echo help needed"
				nx_shell_help(V1)
			}
			nx_boolean(V1, idx, !cse)
		} else if (cat == 7) {
			if (N2 < 13)
				nx_boolean(V1, idx, cse)
			else
				V1[idx] = opt
		} else if (cat == 10) {
			if (cse)
				V1[idx] = opt ps V2[++N1]
			else
				V1[idx] = V2[++N1] ps opt
		}
	} else {
		val = V2["val"]
		num = V2["num"]
		if ((mod = V2["mod"]) == "") {
			if (cat == 1 || cat == 4 || cat == 7) {
				V1[idx] = val
				if (cat == 4)
					nx_boolean(V1, idx, !cse)
			} else if (cat == 10) {
				if (cse)
					V1[idx] = opt ps val
				else
					V1[idx] = val ps opt
			}
		} else if (mod == V1[strde * 8]) {
			if (cat == 1) {
				if (cse) {
					if (N2 < 13)
						V1[idx] = V2[++N1] opt
					else
						V1[idx] = V2[++N1] ps opt
				} else {
					if (N2 < 13)
						V1[idx] = opt V2[++N1]
					else
						V1[idx] = opt ps V2[++N1]
				}
			} else if (cat == 4) {
				if (cse)
					V1[idx] = cur opt
				else
					V1[idx] = opt cur
			} else if (cat == 7) {
				if (cse)
					V1[idx] = nx_join_str(cur, opt, con)
				else
					V1[idx] = nx_join_str(opt, cur, con)
			} else if (cat == 10) {
				if (cse)
					V1[idx] = nx_join_str(cur, opt ps V2["val"], ps)
				else
					V1[idx] = nx_join_str(opt ps V2["val"], cur, ps)
			}
		} else if (mod == V1[strde * 9]) {
			#TODO
		}
	}
	return N1
}

function nx_shell_actions(D1, D2, D3, V, N, D4,
	opt, num, val, mod,
	trk)
{
	opt = D1
	if (match(D1, "^" D4 "((" D2 ")[0-9]*)?" D3)) {
		val = substr(D1, RLENGTH + 1)
		D2 = RLENGTH
		split(substr(D1, 1, --D2), trk, "")
		while (nx_is_digit(D1 = trk[D2])) {
			num = D1 num
			D2--
		}
		while (! nx_is_alpha(D1 = trk[D2])) {
			mod = D1 mod
			D2--
		}
		delete trk
		opt = substr(opt, 1, D2)
	} else {
		if (opt !~ "^" D4 "$") {
			if (N > 0)
				nx_ansi_error("the action '" opt "' modifier cannot start with an alphabetic character.\n")
			return -1
		}
		D3 = opt
	}

	if (D3 !~ "^" D4 "$") {
		V["opt"] = opt
		V["val"] = val
		V["act"] = D3
		V["mod"] = mod
		V["num"] = __nx_else(num, 1, 1)
		return opt
	}

	V["opt"] = D3
	V["val"] = ""
	V["act"] = ""
	V["mod"] = ""
	V["num"] = ""
	return D3
}

function nx_shell_sanitize(D, V,
	v1, v2, i)
{
	for (i in V)
		gsub(i, V[i], D)
	if (i != "")
		return D
	for (i = 0; i <= 64; ++i)
		v1[sprintf("%c", i)] = i
	for (i = 91; i <= 96; ++i)
		v1[sprintf("%c", i)] = i
	for (i = 123; i <= 127; ++i)
		v1[sprintf("%c", i)] = i
	gsub(/[_A-Za-z0-9]/, "", D)
	i = split(D, v2, "")
	do {
		D = v2[i]
		V["[" D "]"] = v1[D]
	} while (--i > 0)
	delete v1
	delete v2
}

function nx_shell_environ(D1, V, D2, N, D3, D4,
	ds, dbg, ln, idx, asn, err, dq, trk, pre, post,
	vr, vl, nm, pos, acm)
{
	if ((err = nx_shell_args(D1, V, D2, N, D3, D4)) < 0)
		return err

	ds = __nx_else(D2, ",")
	split(N, trk, ds)
	dbg = int(trk[1])
	if (int(trk[4])) {
		pre = "export "
		post = ";"
	} else {
		pre = ""
		post = " "
	}
	dq = int(trk[5])

	split(D3, trk, ds)
	fs = __nx_else(trk[2], "=")

	ln = V["-0"]
	acm = pre __nx_stringify_var("NEX_ARGC", -ln / 3 - 1, dq, fs, post)
	acm = acm pre __nx_stringify_var("NEX_ARGV_R", V[-1], dq, fs, post)
	acm = acm pre __nx_stringify_var("NEX_ARGV_S", V[-2], dq, fs, post)
	acm = acm pre __nx_stringify_var("NEX_ARGV_0", V[-3], dq, fs, post)

	split("", trk, "")
	nx_shell_sanitize(V[V[0] * 2], trk)
	for (idx = -4; idx >= ln; idx = idx - 3) {
		nm = "NEX_ARGV_" ++pos
		vr = nx_shell_sanitize(V[idx - 1], trk)
		vl = V[idx - 2]
		acm = acm pre __nx_stringify_var(nm, vr, dq, fs, post)
		acm = acm pre __nx_stringify_var(vr, vl, dq, fs, post)
	}
	delete trk
	return acm
}

