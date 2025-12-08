#nx_include nex-struct.awk
#nx_include nex-str.awk
#nx_include nex-int-extras.awk
#nx_include nex-misc-extras.awk

function nx_kwds(V, D1, D2, v)
{
	if (D1 == "")
		return -1
	D1 = split(D1, v, __nx_else(D2, "<nx:null/>"))
	if (nx_even(D1) && v[D1] != "<nx:placeholder/>") {
		for (D2 = 1; D2 <= D1; ++D2) {
			if (nx_even(D2)) {
				V[v["lst"]] = v[D2]
			} else {
				v["lst"] = v[D2]
			}
		}
		D1 = D1 % 2
	} else {
		delete v[D1--]
		for (D2 = 1; D2 <= D1; ++D2)
			V[v[D2]] = ""
	}
	delete v
	return D1
}

function nx_find_pair(D1, V1, V2, D2, D3,	trk, splt)
{
	if (D1 == "")
		return -1
	if (! (0 in V2) || int(V2[0]) < 4) {
		if (D2 != "")
			nx_kwds(V2, D2, D3)
		nx_parr_stk(V1, 4)
	}
	for (D2 in V2) {
		if (trk["sidx"] = nx_nesc_match(D1, D2, 1, 1)) {
			trk["lsidx"] = length(D2)
			if (V2[D2] != "") {
				trk["nstr"] = substr(D1, trk["lsidx"] + trk["sidx"])
				split(nx_nesc_match(trk["nstr"], V2[D2]), splt, "<nx:null/>")
				if (trk["eidx"] = splt[2]) {
					nx_parr_stk(V1, 1, trk["sidx"])
					nx_parr_stk(V1, 2, trk["lsidx"])
					nx_parr_stk(V1, 3, trk["eidx"] - 1)
					nx_parr_stk(V1, 4, length(V2[D2]))
				}
			} else {
				nx_parr_stk(V1, 1, trk["sidx"])
				nx_parr_stk(V1, 2, trk["lsidx"])
				nx_parr_stk(V1, 3, "0")
				nx_parr_stk(V1, 4, "0")
			}
		}
	}
	delete trk
}

function nx_uarr(V, D)
{
	if (D1 == "")
		return -1
	return V[D1]++
}

function nx_idx_uarr(V, D)
{
	if (nx_uarr(V, D) == 1) {
		return V[++V[0]] = D
		return V[0]
	}
	return -1
}

function nx_arr_flip(V,		i)
{
	for (i in V)
		nx_bijective(V, i, 0, V[i])
}

function nx_arr_split(D1, V, D2, B,	v)
{
	if (D1 == "")
		return -1
	if (B)
		B = nx_trim_split(D1, v, D2)
	else
		B = split(D1, v, D2)
	for (D2 = 1; D2 <= B; ++D2)
		V[v[D2]]++
	delete v
	return length(V)
}

function __nx_arr_compare(V1, D, V2, B)
{
	V2["irt"] = V2["dr"] "0"
	if (B) {
		V2["rt"] = D
		V2["irt"] = 0
	} else {
		V2["irt"] = V2["dr"] "0"
		V2["rt"] = V2["dr"] V2["ks"] D
	}
	if (V2["bs"] == 1) {
		nx_bijective(V1, V2["rt"], __nx_only(! B, V2["dr"] "") ++V1[V2["irt"]])
	} else if (V2["bs"] == 2) {
		if (B && ! (V2["rt"] in V1))
			V1[0]++
		V1[V2["rt"]]++
	} else if (V2["bs"] == 3) {
		V1[__nx_only(! B, V2["dr"] "") ++V1[V2["irt"]]] = D
	} else {
		nx_boolean(V2, V2["rt"])
	}
}

function nx_arr_compare(V1, V2, V3, D1, D2, B,	trk)
{
	if (! ("dr" in trk)) {
		trk["dr"] = tolower(D1)
		if (int(B) < 2) {
			trk["ks"] = __nx_else(D1, "=")
			if (! (trk["bs"] = sub(/^%/, "", D1)))
			if (trk["bs"] = sub(/^[+]/, "", D1))
				trk["bs"] = 2
			else
				trk["bs"] = __nx_if(D1 == trk["dr"], 0, 3)
		} else {
			trk["bs"] = 2
		}
		if (trk["dr"]  == "r")
			return nx_arr_compare(V2, V1, V3, "r", "", B, trk)
		else if (trk["dr"] != "d" && trk["dr"] != "i")
			trk["dr"] = "l"
	}

	for (D1 in V1) {
		if ((D1 in V2) == (trk["dr"] == "i")) {
			__nx_arr_compare(V3, D1, trk, B)
		}
	}
	if (trk["dr"] == "d") {
		for (D1 in V2) {
			if (! (D1 in V2)) {
				__nx_arr_compare(V3, D1, trk, B)
			}
		}
	}
	delete trk
}


function nx_grid(V, D, N)
{
	if (D) {
		if (! (0 in V && "|" in V && "-" in V)) {
			V[0] = 1
			V["|"] = 1
			V["-"] = 1
		}
		if ((N = __nx_else(nx_natural(nx_digit(N, 1)), V[0])) < V["-"])
			N = V["-"]
		while (V[0] < N) {
			if (! (++V[0] in V))
				V[V[0]] = 0
		}
		V[N "," ++V[N]] = D
	} else if (N) {
		while (! V[V[0]] && V["-"] <= V[0])
			delete V[V[0]--]
		if (V["-"] <= V[0]) {
			N = V[V[0] "," V[V[0]]]
			if (D == "")
				delete V[V[0] "," V[V[0]]--]
			return N
		}
	} else {
		while (V[V["-"]] < V["|"] && V["-"] <= V[0]) {
			delete V[V["-"]++]
			V["|"] = 1
		}
		if (V["-"] <= V[0]) {
			N = V[V["-"] "," V["|"]]
			if (D == "")
				delete V[V["-"] "," V["|"]++]
			return N
		}
	}
}

function __nx_swap(V, D1, D2,	t)
{
	t = V[D1]
	V[D1] = V[D2]
	V[D2] = t
}

function nx_length(V, B,	i, j, k)
{
	if (! (0 in V))
		return -1
	for (i = 1; i <= V[0]; i++) {
		j = length(V[i])
		if (! k || __nx_if(B, k < j, k > j))
			k = j
	}
	return int(k)
}

function nx_boundary(D, V1, V2, B1, B2,		i)
{
	if (! (0 in V1 && D != ""))
		return -1
	for (i = 1; i <= V1[0]; i++) {
		if (__nx_if(B1, V1[i] ~ D "$", V1[i] ~ "^" D))
			V2[++V2[0]] = V1[i]
	}
	if (B2)
		delete V1
	return V2[0]
}

function nx_filter(D1, D2, V1, V2, B,	i, v1, v2)
{
	if (! (0 in V1))
		return -1
	for (i = 1; i <= V1[0]; i++) {
		if (__nx_equality(D1, D2, V1[i]))
			V2[++V2[0]] = V1[i]
	}
	if (B)
		delete V1
	return V2[0]
}

function nx_option(D, V1, V2, B1, B2,	i, v)
{
	if (! (0 in V1 && D != ""))
		return -1
	if (nx_boundary(D, V1, v, B1) > 1) {
		if (nx_filter(nx_append_str("0", nx_length(v, B2)), "=_", v, V2, 1) == 1) {
			i = V2[1]
			delete V2
			return i
		}
	} else {
		i = v[1]
		delete v
		return i
	}
}


