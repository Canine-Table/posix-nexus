#nx_include nex-misc-extras.awk
#nx_include nex-struct-extras.awk
#nx_include nex-int-extras.awk
#nx_include nex-str-extras.awk
#nx_include nex-log-extras.awk

function nx_is_file(D, B)
{
	if (D == "")
		return 0
	if ((getline < D) > __nx_if(B == "", 0, -1))
		close(D)
	else
		return 0
	return 1
}

function nx_file_path(D1, B, D2, V,	i, j)
{
	D2 = __nx_else(D2, "/")
	if (match(D1, /^(-|~|NE?X_[A-Z]+:)\//)) {
		if (! ("-/" in V)) {
			V["-/"] = ENVIRON["OLDPWD"] D2
			V["~/"] = ENVIRON["HOME"] D2
			V["NX_L:/"] = ENVIRON["NEXUS_LIB"] D2
			V["NX_C:/"] = ENVIRON["NEXUS_CNF"] D2
			V["NX_D:/"] = ENVIRON["NEXUS_DOCS"] D2
			V["NX_E:/"] = ENVIRON["NEXUS_ENV"] D2
			V["NX_SB:/"] = ENVIRON["NEXUS_SBIN"] D2
			V["NX_B:/"] = ENVIRON["NEXUS_BIN"] D2
			V["NX_L:/"] = ENVIRON["NEXUS_LIB"] D2
			V["NX_S:/"] = ENVIRON["NEXUS_SRC"] D2
			V["NX_J:/"] = V["NX_L:/"] "java" D2 ENVIRON["G_NEX_JAVA_PROJECT"] D2
			for (i in V)
				gsub(D2 "+", D2, V[i])
		}
		i = substr(D1, 1, RLENGTH)
		j = i
		sub(/^NEX_/, "NX_", j)
		if (j in V)
			sub(i, V[j], D1)
	}
	gsub(D2 "+", D2, D1)
	gsub(D2 "+$", "", D1)
	i = D1
	if (! sub("[^" D2 "]+$", "", i))
		return D1
	i = length(i)
	j = length(D2)
	if (B == "")
		return substr(D1, i + j)
	if (B == 0)
		return D1
	return substr(D1, 1, i - j)
}

function nx_file_path_expand(D1, D2, D3, D4, D5, V1, V2, B1, B2,
	rvs, len, bs, ext, ret)
{
	D4 = __nx_else(D4, "[.]", 1)
	D5 = __nx_else(D5, "/", 1)
	rvs = nx_reverse_str(D3)
	len = length(D3)
	bs = D3
	ret = -1
	while (match(rvs, D4)) {
		len = len - RSTART
		ext = ext D5 substr(bs, len + RLENGTH + 1)
		bs = substr(bs, 1, len)
		rvs = substr(rvs, RSTART + 1)
		if (nx_file_store(V1, D1 ext D5 bs, D2, V2, B1, B2) == 1 || nx_file_store(V1, D2 ext D5 D3, D1, V2, B1, B2) == 1) {
			ret = 1
			break
		}
	}
	return ret
}

function nx_file_store(V1, D1, D2, V2, D3, B1, B2, D4,
	rlp, orlp, bs, drp, i, j, k)
{
	if (D1 == "")
		return -1
	if (! (0 in V1) || int(V1[0]) < 3)
		nx_parr_stk(V1, 3)
	B1 = int(B1)
	D3 = __nx_else(D3, "/")
	rlp = nx_file_path(D2 __nx_only(D2, D3) D1, 0, D3, V2)
	orlp = nx_file_path(D1, 0, D3, V2)
	bs = nx_file_path(D1, "", D3, V2)
	if (nx_is_file(rlp, B2)) {
		drp = nx_file_path(rlp, 1, D3, V2)
	} else if (nx_is_file(orlp, B2)) {
		drp = nx_file_path(orlp, 1, D3, V2)
		rlp = orlp
	} else if (B1 == 2) {
		j = V1[2]
		k = V1[0]
		for (i = 2 + k; i <= j; i += k) {
			rlp = nx_file_path(V1[i] D3 D1, 0, D3, V2)
			if (nx_is_file(rlp, B2) && ! (rlp in V1)) {
				drp = nx_file_path(rlp, 1, D3, V2)
				break
			}
		}
	} else if (B1 == 1 || B1 == 3) {
		return nx_file_path_expand(nx_file_path(rlp, 1, D3, V2),
			nx_file_path(orlp, 1, D3, V2),
			bs, D4, D3, V1, V2, B1 - 1, B2)
	}
	D1 = -1
	if (drp != "") {
		D1 = 0
		if (! (rlp in V1)) {
			nx_bijective(V1 , rlp, nx_parr_stk(V1, 1, rlp))
			D1 = 1
		}
		if (! (drp in V1))
			nx_bijective(V1 , drp, nx_parr_stk(V1, 2, drp))
		if (! (bs in V1))
			nx_bijective(V1 , bs, nx_parr_stk(V1, 3, bs))
	}
	return D1
}

function nx_file_merge(D1, D2, D3, D4, B, N,
		incd, flsp, sig, ps, ds, drp, rlp,
		cnt, eret, wret, ln, nxt, cr, nr,
		stk, fls, stre, trk)
{
	ds = __nx_else(D3, ",") # Define default delimiters
	if ((D3 = split(D4, stk, ds)) > 0) {
		wret = 0
		eret = 0
		if (D3 > 5) {
			D3 = D3 - 5
			if (N > 1)
				nx_ansi_error("separator to separate the separators was was either used within the separators as a separator or you passed '" D3 "' separators more than you should have, only the first 5 positions will be used\n")
			wret = -2
		}
	}

	# file exclude sep
	ps = __nx_else(stk[1], "<nx:null/>", 1)

	# the directive sigil
	sig = __nx_else(stk[2], "#", 1)

	# the directory sep
	flsp = __nx_else(stk[3], "/", 1)

	# the file extention sep
	extsp = __nx_else(stk[4], "[.]", 1)
	if (stk[4] != "")
		gsub(".", "[\\\&]", extsp)

	# the include directive name
	incd = __nx_else(stk[5], "nx_include", 1)

	eret = 0
	split("", stk, "")
	if (nx_delim_sep(ps, "file exclusion", stk, N) == -1)
		eret = -1
	if (nx_delim_sep(sig, "directive sigial", stk, N) == -1)
		eret = -1
	if (nx_delim_sep(flsp, "directory", stk, N) == -1)
		eret = -1
	if (nx_delim_sep(extsp, "file extention", stk, N) == -1)
		eret = -1
	if (nx_delim_sep(incd, "include directive", stk, N) == -1)
		eret = -1
	if (eret == -1) {
		delete stk
		return -1
	}

	B = int(B)
	if (nx_file_store(fls, D1, "", stre, flsp, B, "", extsp) != 1) {
		delete stre
		delete stk
		delete fls
		return -1
	}
	drp = fls[fls[2]]
	rpl = fls[fls[1]]

	# are there files to omit if founds after the directive??
	if (D2 = nx_trim_split(D2, stk, ps)) {
		do {
			if (nx_file_store(fls, stk[D2], drp, stre, flsp, B1, "", extsp) == 1)
				drp = fls[fls[2]]
		} while (--D2 > 0)
	}

	split("", stk, "")
	rt = "."
	D1 = sig incd
	D2 = "([ \t]+|^)" D1
	D3 = D1 "[ \t]+"
	nxt = 0
	cnt = 0
	do {
		while ((getline ln < rpl) > 0) {
			if (ln ~ D2 && match(ln, D3)) {
				cr = substr(ln, 1, RSTART - 1)
				ln = substr(ln, RSTART + RLENGTH)
				if (match(ln, /^[^ \t]+/)) {
					nr = substr(ln, RSTART, RLENGTH)
					ln = substr(ln, RSTART + RLENGTH)
					D1 = nx_file_store(fls, nr, drp, stre, flsp, B1)
					if (D1 > -1)
						drp = fls[fls[2]]
					if (D1 == 1) {
						stk[rt "" ++cnt] = cr
						D1 = fls[fls[1]]
						trk[++nxt] = D1
						trk[D1] = rt "" ++cnt "."
						if (ln !~ /^[ \t]*$/)
							stk[rt "" ++cnt] = ln "\n"
					} else {
						# directive match, but either the arg was not a file or its already been passed
						# add the line without the directive
						stk[rt "" ++cnt] = cr "\n"
					}
				} else if (cr !~ /^[ \t]*$/) {
					# directive match, but no file provided, add the cr
					stk[rt "" ++cnt] = cr "\n"
				}
			} else if (ln !~ /^[ \t]*$/) {
				stk[rt "" ++cnt] = ln "\n"
			}
		}
		close(rpl)
		stk[rt "0"] = cnt
		cnt = 0
		rpl = trk[nxt]
		rt = trk[rpl]
	} while (nxt-- > 0)
	delete stre
	delete fls
	delete trk
	nx_dfs(stk) # flattens the dfs stack into indexes
	nxt = stk[0]
	for (D2 = 1; D2 <= nxt; ++D2)
		printf("%s", stk[stk[D2]])
	delete stk
}

