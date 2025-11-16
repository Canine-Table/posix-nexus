#nx_include "nex-misc.awk"
#nx_include "nex-str.awk"
#nx_include "nex-math.awk"
#nx_include "nex-json.awk"

###########################################
# O(1)			Contant Time
# O(log(n))		Logarithmic Time
# O(n)			Leanear Time
# O(nlog(n)		Linearithmic Time
# O(n^2)		Quadratic Time
# O(n^3)		Cubic Time
# O(b^n), b > 1		Exponential Time
# O(n!):		Factoral Time
###########################################

function nx_bijective(V, D1, D2, D3)
{
	if (D1 == "")
		return -1
	if (D2) {
		if (D3 != "") {
			V[D1] = D2
			V[D2] = D3
			V[D3] = D1
		} else {
			V[D1] = D2
			V[D2] = D1
		}
	} else if (D3 != "") {
			V[V[D1]] = D3
		if (D2 != "")
			delete V[D1]
	}

}

function nx_find_best(D1, V, B, D2,	i, f, m)
{
	D2 = __nx_else(__nx_defined(D2, 1), "\\\\")
	for (i in V) {
		m = nx_find_index(D1, V[i], D2)
		if (! f || B && m > f)
			f = m
	}
	return f
}


# Argument	Purpose
# D1		The input string to search within.
# S		The pattern or delimiter to search for (e.g. "=", ",", etc.).
# D2		The escape sequence pattern (e.g. "\\\\" for backslashes).
# f		The cumulative offset/index of the match (used internally and returned).
function nx_find_index(D1, S, D2,	f)
{
	if (D1 != "") {
		f = 0
		S = __nx_else(S, " ")
		D2 = __nx_else(__nx_defined(D2, 1), "\\\\")
		while (match(D1, S)) {
			f = f + RSTART
			if (! (match(substr(D1, 1, RSTART - 1), D2 "+$") && D2) || int(RLENGTH % 2) == 0)
				break
			f = f + RLENGTH
			D1 = substr(D1, f + 1)
		}
		return f
	}
}

function nx_find_pair(D1, V1, V2, D2, B1, B2,	s)
{
	if (D1 == "")
		return ""
	V2["csidx"] = ""
	V2["ceidx"] = ""
	V2["osidx"] = ""
	V2["oeidx"] = ""
	for (s in V1) {
		if ((V2["idx"] = nx_find_index(D1, s, D2)) && (! V2["osidx"] || __nx_if(B2, V2["idx"] > V2["osidx"], V2["idx"] < V2["osidx"]))) {
			V2["osidx"] = V2["idx"]
			V2["oeidx"] = length(s)
			if (length(V1[s]) && (V2["idx"] = nx_find_index(substr(D1, V2["osidx"] + V2["oeidx"] + 1), V1[s], D2))) {
				V2["csidx"] = V2["idx"]
				V2["ceidx"] = length(V1[s])
			} else {
				V2["csidx"] = ""
				V2["ceidx"] = ""
			}
		}
	}
	if (! V2["osidx"] && B1)
		V2["osidx"] = length(D1) + 1
}

function nx_entries(D1, D2, D3,		trk)
{
	if (! nx_is_file(D1))
		return
	D3 = __nx_else(__nx_defined(D3, 1), "\\\\")
	D2 = __nx_else(D2, ";")
	while ((getline trk["ln"] < D1) > 0) {
		if (D2 != "" && (trk["idx"] = nx_find_index(trk["ln"], D2))) {
			if (trk["nl"])
				trk[trk[0]] = trk[trk[0]] substr(trk["ln"], 1, trk["idx"] - 1)
			else
				trk[++trk[0]] = substr(trk["ln"], 1, trk["idx"] - 1)
			break
		}
		if (D3 && match(trk["ln"], D3 "+$") && int(RLENGTH % 2) == 1) {
			sub(D3 "$", "", trk["ln"])
			if (trk["nl"]) {
				trk[trk[0]] = trk[trk[0]] trk["ln"]
			} else {
				trk[++trk[0]] = trk["ln"]
				trk["nl"] = 1
			}
		} else {
			if (trk["nl"])
				trk[trk[0]] = trk[trk[0]] trk["ln"]
			else
				trk[++trk[0]] = trk["ln"]
			trk["nl"] = 0
		}
	}
	close(D1)
	for (trk["ln"] = 1; trk["ln"] <= trk[0]; ++trk["ln"])
		trk["str"] = trk["str"] "<nx:null/>" trk[trk["ln"]]
	D1 = trk["str"]
	delete trk
	return D1
}

# Argument	Purpose
# D1		The input string to parse.
# V1		An associative array of start delimiters as keys and their matching end delimiters as values.
# V2		An output array where results (positions and lengths) are stored.
# D2		Escape sequence pattern (same as above).
# B1		Boolean flag: if no match is found, use end of string as fallback.
# B2		Boolean flag: determines whether to prefer earlier or later matches.
# s		Start position of the match (used internally).
# s_l		Length of the start delimiter.
# e		End position of the match (used internally).
# e_l		Length of the end delimiter.
# f		Temporary index used during matching.
# i		Iterator for looping through V1.
function nx_next_pair(D1, V1, V2, D2, B1, B2,	s, s_l, e, e_l, f, i)
{
	if (D1 != "") {
		for (i in V1) {
			if ((f = nx_find_index(D1, i, D2)) && (! s || __nx_if(B2, f > s, f < s))) {
				s = f
				s_l = length(i)
				if (length(V1[i]) && (f = nx_find_index(substr(D1, s + s_l + 1), V1[i], D2))) {
					e = f
					e_l = length(V1[i])
				} else {
					e = ""
					e_l = ""
				}
			}
		}
		if (! s && B1)
			s = length(D1) + 1
		V2[++V2[0]] = s
		V2[V2[0] "_" s] = s_l
		V2[++V2[0]] = e
		V2[V2[0] "_" e] = e_l
		return V2[0] - 1
	}
}

# Argument	Role
# D1		The input string to tokenize.
# V1		Output array to store tokens or key-value pairs.
# S1		Primary delimiter (e.g. , or =).
# S2		Secondary delimiter (e.g. : or closing quote).
# V2		Delimiter map used by nx_next_pair to find token boundaries.
# D2		Escape character pattern (e.g. \\).
# B1		Boolean: controls behavior when no end delimiter is found.
# B2		Boolean: whether to trim tokens (via nx_trim_str).
# v1		Internal map of start → end delimiters (bijective).
# v2		Internal array for storing positions from nx_next_pair.
# c		Current expected delimiter (used for pairing logic).
# s		Accumulator for current token string.
# i		Index of current delimiter pair.
# l		Position offset for substring slicing.
# t		Current delimiter token.
# k		Key for key-value assignment.
function nx_tokenize(D1, V1, S1, S2, V2, D2, B1, B2,	v1, v2, c, s, i, l, t, k)
{
	if (D1 != "") {
		if (! length(V2))
			__nx_quote_map(V2, "0", "0", "0")
		S1 = __nx_else(S1, ",")
		V2[S1] = ""
		if (S2) {
			V2[S2] = ""
			nx_bijective(v1, S1, S2)
			c = v1[S1]
		}
		while (D1) {
			i = nx_next_pair(D1, V2, v2, D2, 1, B1)
			t = substr(D1, v2[i], v2[i "_" v2[i]])
			l = v2[i] + v2[i "_" v2[i]]
			s = s substr(D1, 1, v2[i] - 1)
			if (V2[t] == "" || s == D1) {
				s = __nx_if(B2, nx_trim_str(s), s)
				if (S2 && (t in v1 || s == D1)) {
					if (c == t || s == D1) {
						if (c == S2) {
							V1[++V1[0]] = s
							if (s == D1)
								nx_boolean(V1, V1[V1[0]])
						} else if (k) {
							V1[k] = s
						} else {
							V1[V1[V1[0]]] = s
						}
						c = v1[c]
						k = ""
					} else {
						if (t == S2) {
							if (k) {
								V1[k] = s
							} else {
								V1[V1[V1[0]]] = s
								k = V1[V1[0]]
							}
							k = nx_join_str(k, s, ".")
						} else {
							V1[++V1[0]] = s
							if (t == S1 || (s == D1 && c == S1)) {
								nx_boolean(V1, V1[V1[0]])
							}
						}
					}
				} else {
					V1[++V1[0]] = s
				}
				s = ""
			} else {
				s = s substr(D1, l, v2[++i])
				l = l + v2[i] + v2[i "_" v2[i]]
			}
			D1 = substr(D1, l)
		}
		delete v1
		delete v2
		return V1[0]
	}
}

function nx_vector(D1, V1, S1, S2, B1, V2, D2, B2)
{
	if (D1 != "")
		return nx_tokenize(D1, V1, S1, S2, V2, D2, B2, B1)
}

function nx_uniq_vector(D1, V1, S, B1, V2, D2, B2, B3,	v, i)
{
	if (i = nx_vector(D1, v, S, "", B1, V2, D2, B2)) {
		for (i = 1; i <= v[0]; i++) {
			if (! (v[i] in V1)) {
				V1[v[i]] = __nx_if(B3, 0, ++V1[0])
				V1[V1[0]] = v[i]
			}
			if (B3)
				V1[v[i]]++
		}
		i = V1[0]
	}
	delete v
	return i
}

function nx_tostring_vector(V, S, B1, B2,	i, s)
{
	if (length(V) && 0 in V && V[0] > 0) {
		S = __nx_else(S, ",")
		for (i = 1; i <= V[0]; i++)
			s = nx_join_str(s, V[i], S, B2)
		if (B1)
			delete V
		return s
	}
}

function nx_reverse_vector(V,	i, j)
{
	if (length(V) && 0 in V && V[0] > 0) {
		for (i = V[0]; i > j; i--)
			__nx_swap(V, ++j, i)
	}
}

function nx_pop_vector(D, V1, S, B1, V2, D2, B2, V3,	v)
{
	if (length(V1) && 0 in V1 && V1[0] > 0) {
		if (D != "") {
			nx_uniq_vector(D, V3, S, B1, V2, D2, B2)
			for (i = 1; i <= v[0]; i++) {
				if (V1[0] v[i] in V1)
					delete V1[V1[0] v[i]]
			}
			delete v
		}
		delete V1[V1[0]--]
		return V1[0]
	}
}

function nx_length(V, B,	i, j, k)
{
	if (length(V) && 0 in V) {
		for (i = 1; i <= V[0]; i++) {
			j = length(V[i])
			if (! k || __nx_if(B, k < j, k > j))
				k = j
		}
		return int(k)
	}
}

function nx_boundary(D, V1, V2, B1, B2,		i)
{
	if (length(V1) && 0 in V1 && D != "") {
		for (i = 1; i <= V1[0]; i++) {
			if (__nx_if(B1, V1[i] ~ D "$", V1[i] ~ "^" D))
				V2[++V2[0]] = V1[i]
		}
		if (B2)
			delete V1
		return V2[0]
	}
}

function nx_filter(D1, D2, V1, V2, B,	i, v1, v2)
{
	if (length(V1) && 0 in V1) {
		for (i = 1; i <= V1[0]; i++) {
			if (__nx_equality(D1, D2, V1[i]))
				V2[++V2[0]] = V1[i]
		}
		if (B)
			delete V1
		return V2[0]
	}
}

function nx_option(D, V1, V2, B1, B2,	i, v1)
{
	if (length(V1) && 0 in V1 && D != "") {
		if (nx_boundary(D, V1, v1, B1) > 1) {
			if (nx_filter(nx_append_str("0", nx_length(v1, B2)), "=_", v1, V2, 1) == 1) {
				i = V2[1]
				delete V2
				return i
			}
		} else {
			i = v1[1]
			delete v1
			return i
		}
	}
}

function nx_trim_split(D, V, S)
{
	D = split(nx_trim_str(D), V, "[ \v\t\n\f]*" __nx_else(S, ",") "[ \v\t\n\f]*")
	return V[0] = D
}

function nx_compare_vector(D, V1, V2, V3, B,		i, v)
{
	if (length(V1) && 0 in V1 && length(V2) && 0 in V2) {
		nx_vector("left,intersect,difference", v)
		if (D = __nx_else(nx_option(D, v), "left")) {
			for (i = 1; i <= V1[0]; i++) {
				if ((V1[i] in V2) == (D == "intersect")) {
					V3[++V3[0]] = V1[i]
				}
			}
			if (D == "difference") {
				for (i = 1; i <= V2[0]; i++) {
					if (! (V2[i] in V1))
						V3[++V3[0]] = V2[i]
				}
			}
		}
		delete v
		if (B) {
			delete V1
			delete V2
		}
		return V3[0]
	}
}

function nx_map(V1, V2, B)
{
	if (length(V1) && 0 in V1 && length(V2) && 0 in V2 && V2[0] == V1[0]) {
		for (i = 1; i <= V1[0]; i++)
			V1[V1[i]] = V2[i]
		if (B)
			delete V2
	}
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

function nx_dfs(V, trk, stk)
{
	if (! (".0" in V && int(V[".0"]) > 0))
		return -1
	stk[++stk[0]] = 1
	stk[++stk[0]] = V[".0"]
	V[0] = 0
	do {
		for (; stk[1] <= stk[2]; ++stk[1]) {
			trk["ky"] = trk["rt"] "." stk[1]
			V[++V[0]] = trk["ky"]
			if (trk["ky"] ".0" in V && int(V[trk["ky"] ".0"]) > 0) {
				trk["rt"] = trk["ky"]
				stk[++stk[0]] = stk[1]
				stk[++stk[0]] = stk[2]
				stk[1] = 0
				stk[2] = V[trk["rt"] ".0"]
			}
		}
		if (stk[1] > 0 && sub(/[^.]+$/, "", trk["rt"])) {
			sub(/[.]$/, "", trk["rt"])
			stk[2] = stk[stk[0]--]
			stk[1] = stk[stk[0]--] + 1
		}
	} while (stk[0] > 2 || stk[1] <= stk[2])
	delete trk
	delete stk
}

