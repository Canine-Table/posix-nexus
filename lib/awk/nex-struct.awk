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
	if (D1 != "") {
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
}

function nx_find_index(D1, S, D2,	f)
{
	if (D1 != "") {
		f = 0
		S = __nx_else(S, "")
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

function nx_tokenize(D1, V1, S1, S2, V2, D2, B1, B2,	v1, v2, c, s, i, l, t, k)
{
	if (D1 != "") {
		if (! length(V2))
			__nx_quote_map(V2)
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
								nx_bool(V1, V1[V1[0]])
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
							if (t == S1 || (s == D1 && c = S1)) {
								nx_bool(V1, V1[V1[0]])
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

function nx_tostring_vector(V, S, B,	i, s)
{
	if (length(V) && 0 in V && V[0] > 0) {
		S = __nx_else(S, ",")
		for (i = 1; i <= V[0]; i++)
			s = nx_join_str(s, V[i], S, 0)
		if (B)
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
	return (V[0] = split(nx_trim_str(D), V, "[ \v\t\n\f]*" __nx_else(S, ",") "[ \v\t\n\f]*"))
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

