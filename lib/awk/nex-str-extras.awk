#nx_include nex-log.awk
#nx_include nex-str.awk
#nx_include nex-int.awk
#nx_include nex-math-extras.awk


function nx_same_length(N1, N2, V, B1, B2,		k, n, n1, n2, l, l1, l2, b, b1, b2)
{
	if (N1 in V)
		b1 = 1
	l1 = length(n1 = __nx_if(b1, V[N1], __nx_if(B2, "", N1)))
	if (N2 in V)
		b2 = 1
	l2 = length(n2 = __nx_if(b2, V[N2], __nx_if(B2, "", N2)))
	if ((l = l1 - l2) > 0) {
		if (b = b1)
			k = N1
		n = n1
	} else if ((l = nx_absolute(l)) > 0) {
		if (b = b2)
			k = N2
		n = n2
	} else {
		return
	}
	if (b)
		V[k] = nx_slice_str(n, l, "", !B1)
	return nx_slice_str(n, l, "", B1)
}

function nx_reap_str(D1, N1, D2, N2)
{
	if (int(N1) != N1 || N1 == 0) {
		gsub(D2, "", D1)
	} else {
		N1 = nx_absolute(N1)
		if (N2) {
			D1 = nx_reverse_str(D1)
			D2 = nx_reverse_str(D2)
			while (sub(D2, "", D1) && N1 > 1)
				N1--
			D1 = nx_reverse_str(D1)
		} else {
			while (sub(D2, "", D1) && N1 > 1)
				N1--
		}
	}
	return D1
}

function nx_reap_str_match(D1, N1, D2, N2)
{
	if (int(N1) != N1 || N1 == 0)
		N1 = -1
	if (N2) {
		D1 = nx_reverse_str(D1)
		D2 = nx_reverse_str(D2)
		while (match(D1, D2) && (N1-- > 0 || N1 < -1))
			D1 = substr(D1, RSTART + RLENGTH)
		D1 = nx_reverse_str(D1)
	} else {
		while (match(D1, D2) &&  (N1-- > 0 || N1 < -1))
			D1 = substr(D1, RSTART + RLENGTH)
	}
	return D1
}

function nx_slice_str(D, N, B1, B2,	s, e, l)
{
	if (nx_natural(N) && N <= (l = length(D))) {
		if (B1) {
			if (B2) {
				s = N + 1
				e = l - N
			} else {
				s = 1
				e = N
			}
		} else if (length(B1) && N * 2 <= l) {
			if (B2) {
				return substr(D, 1, N) substr(D, l - N + 1)
			} else {
				s = N + 1
				e = l - N * 2
			}
		} else {
			if (B2) {
				s = 1
				e = l - N
			} else {
				s = l - N + 1
				e = N
			}
		}
		return substr(D, s, e)
	}
}

function nx_nesc_match(D1, D2, B, D3, D4,	trk)
{
	if (D1 == "")
		return -1
	trk["fm"] = 0
	trk["tl"] = 0
	D2 = __nx_else(D2, " ")
	if ((D3 = __nx_else(D3, "\\\\")) == "\\\\")
		trk["ln"] = 1
	else
		trk["ln"] = length(D3)
	B = int(B)
	while (match(D1, D2)) {
		trk["fm"] = trk["fm"] + RSTART
		trk["tl"] = trk["tl"] + RSTART
		if (! (match(substr(D1, 1, RSTART - 1), D3 "+$") && D3) || int(RLENGTH % 2) == 0)
			break
		trk["fm"] = trk["fm"] + RLENGTH - nx_count_str(substr(D1, 1, V["fm"] - 1), D3) * trk["ln"]
		D1 = substr(D1, trk["fm"] + 1)
	}
	D1 = __nx_if(B && D1 == "", -1, trk["fm"] - nx_count_str(substr(D1, 1, trk["fm"] - 1), D3) * trk["ln"])
	D2 = trk["tl"]
	delete trk
	if (B == 1)
		return D1
	if (B == 2)
		return D2
	return D1 __nx_else(D4, "<nx:null/>") D2
}

function nx_find_next(D1, V, B1, B2, D2,	i, f, m)
{
	if (D1 == "")
		return -1
	B1 = __nx_if(B1, ">0", "<0")
	for (i in V) {
		m = nx_nesc_match(D1, V[i], D2)
		if (! f || __nx_equality(m, B1, f))
			f = __nx_if(m > 0, m, f)
	}

	if (f == length(D1))
		return __nx_if(B2, -1, f)
	return f + 1
}

function __nx_str_map(V)
{
	nx_bijective(V, ++V[0], "upper", "A-Z")
	nx_bijective(V, ++V[0], "lower", "a-z")
	nx_bijective(V, ++V[0], "xupper", "A-F")
	nx_bijective(V, ++V[0], "xlower", "a-f")
	nx_bijective(V, ++V[0], "digit", "0-9")
	nx_bijective(V, ++V[0], "alpha", V["upper"] V["lower"])
	nx_bijective(V, ++V[0], "xdigit", V["digit"] V["xupper"] V["xlower"])
	nx_bijective(V, ++V[0], "alnum", V["digit"] V["alpha"])
	nx_bijective(V, ++V[0], "print", "\x20-\x7e")
	nx_bijective(V, ++V[0], "punct", "\x21-\x2f\x3a-\x40\x5b-\x60\x7b-\x7e")
}

function nx_random_str(N, D, S, B,	i, v1, v2, v3, s, r, f)
{
	N = int(__nx_if(nx_natural(N), N, 8))
	__nx_str_map(v1)
	nx_trim_split(__nx_else(D, "print"), v2, ",")
	for (i = 1; i <= v2[0]; i++) {
		if (D = nx_option(v2[i], v1, v3))
			r = r v1[D]
	}
	r = __nx_else(r, v1["print"])
	split("/dev/urandom,/dev/random", v1, ",")
	if (B)
		__nx_swap(v1, 1, 2)
	do {
		if (! (getline line < v1[1])) {
			if (! (getline line < v1[2]))
				return
		}
		for (i = 1; i <= split(line, v2, ""); i++) {
			if (v2[i] ~ "^[" r "]$")
				s = s v2[i]
		}
	} while (length(s) < N)
	delete v1
	delete v2
	delete v3
	return substr(s, 1, N)
}

function nx_str_totitle(D,	v, i, s)
{
	if (D == "")
		return -1
	D = " " D " "
	split(" \n\v\t\r", v, "")
	do {
		if ((i = nx_find_next(D, v, 0, 0, 2)) == 0)
			break
		if (i == length(D)) {
			s = s tolower(D)
			D = ""
		} else {
			s = s tolower(substr(D, 1, i - 1)) toupper(substr(D, i, 1))
			D = substr(D, i + 1)
		}
	} while (D != "")
	delete v
	gsub(/(^ )|( $)/, "", s)
	return s
}

# Work in progress
function nx_str_grep(D1, V, D2, D3, B, N, D4,	trk)
{
	if (! ("fnd" in V)) {
		D2 = __nx_else(D2, "<nx:null/>")
		split(D3, trk, D2)
		V["fnd"] = trk[1]
		if (trk[2] != "") {
			V["mth"] = trk[2]
			V["rpl"] = trk[3]
		}
		V["sep"] = __nx_else(trk[4], "[\t ]*")
		V["osep"] = __nx_else(trk[5], "\n")
		split(B, trk, D2)
		V["inc"] = trk[1]
		V["wp"] = trk[2]
		V["gbl"] = trk[3]
		if (trk[4] == "<nx:true/>")
			IGNORECASE=1
		split(N, trk, D2)
		if (int(trk[1]) == trk[1])
			V["bfre"] = trk[1]
		else
			V["bfre"] = ""
		if (int(trk[2]) == trk[2])
			V["aftr"] = trk[2]
		else
			V["aftr"] = ""
		V["pd"] = 0
		if (int(trk[3]) == trk[3])
			V["cnt"] = trk[3]
		if (D4 != "") {
			B = split(D4, trk, D2) + 1
			for (D4 = 1; D4 <= B; ++D4) {
				if (! ("o=" trk[D4] in trk)) {
					V["o=" ++V["o"]] = trk[D4]
					trk["o=" trk[D4]] = D4
				}
			}
		}
	}
	if ("o" in V) {
		N = split(D1, trk, V["sep"])
		for (D2 = 0; D2 <= V["o"]; ++D2)
			print V["o=" D2] "  =  " trk[V["o=" D2]]
		D3 = ""
		B = ""
		for (D2 = 1; D2 <= V["o"]; ++D2) {
			if (V["wp"] == "<nx:true/>") {
				B = trk[(V["o=" D2] - 1) % N +  + 11]
			} else {
				B = __nx_if(V["wp"] == "<nx:false/>" && trk[V["o=" D2]] > N, D1, trk[V["o=" D2]])
			}
			if ("mth" in V) {
				if (V["gbl"] == "<nx:true/>") {
					gsub(V["mth"], V["rpl"], B)
				} else {
					sub(V["mth"], V["rpl"], B)
				}
			}
			D3 = nx_join_str(D3, B, V["osep"])
		}
		V[--V["-0"]] =  D3
	} else {
		if ("mth" in V) {
			if (V["gbl"] == "<nx:true/>") {
				gsub(V["mth"], V["rpl"], D1)
			} else {
				sub(V["mth"], V["rpl"], D1)
			}
		}
		V[--V["-0"]] = D1
	}
	if (D1 ~ V["fnd"] && (! ("cnt" in V) || V["cnt"]-- > 0)) {
		if ("bfre" in V) {
			for (N = V["-0"] + V["bfre"]; N > V["-0"]; --N) {
				if (N in V)
					print V[N]
			}
		}
		if (V["inc"] != "<nx:true/>")
			delete V[V["-0"]++]
		else
			print V[V["-0"]]
		if ("aftr" in V)
			V["pd"] = V["aftr"]
	} else if (V["pd"]-- > 0 && V[V["-0"]] != "") {
		print V[V["-0"]]
	} else if ("cnt" in V && V["cnt"] < 0) {
		delete trk
		delete V
		return -1
	}
	return 1
}

