function nx_bijective(V, D1, B, D2)
{
	if (D1 != "") {
		if (D2 != "") {
			if (length(B)) {
				V[D1] = B
				V[B] = D2
				if (B)
					V[D2] = D1
			} else {
				V[D1] = D2
				V[D2] = D1
			}
		} else {
			V[V[D1]] = D1
			if (B)
				delete V[D1]
		}
	}
}

function nx_find_index(D1, S, D2,	f, m)
{
	if (__nx_defined(D1, 1)) {
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
		if (! s && B1) {
			s = length(D1) + 1
		}
		V2[++V2[0]] = s
		V2[V2[0] "_" s] = s_l
		V2[++V2[0]] = e
		V2[V2[0] "_" e] = e_l
		return V2[0] - 1
	}
}

function nx_tokenize(D1, V1, V2, D2, B1, B2,	i, j, m, v, s)
{
	if (D1 != "") {
		while (D1) {
			i = nx_next_pair(D1, V2, v, D2, 1, B1)
			m = substr(D1, v[i], v[i "_" v[i]])
			j = v[i] + v[i "_" v[i]]
			s = s substr(D1, 1, v[i] - 1)
			if (length(V2[m])) {
				s = s substr(D1, j, v[++i])
				j = j + v[i] + v[i "_" v[i]]
			} else {
				V1[++V1[0]] = __nx_if(B2, nx_trim_str(s), s)
				s = ""
			}
			D1 = substr(D1, j)
		}
		if (s != "")
			V1[++V1[0]] = __nx_if(B2, nx_trim_str(s), s)
		delete v
		return V1[0]
	}
}

function nx_vector(D, V1, S, V2)
{
	if (D != "") {
		__nx_quote_map(V2)
		V2[__nx_else(S, ",")] = ""
		return nx_tokenize(D, V1, V2)
	}
}

function nx_trim_vector(D, V1, S, V2,	i)
{
	if (nx_vector(D, V1, S, V2)) {
		for (i = 1; i <= V1[0]; i++)
			V1[i] = nx_trim_str(V1[i])
		return V1[0]
	}
}

function nx_uniq_vector(D, V1, S, V2, B1, B2,	v, i)
{
	if (B1)
		i = nx_vector(D, v, S, V2)
	else
		i = nx_trim_vector(D, v, S, V2)
	if (i) {
		for (i = 1; i <= v[0]; i++) {
			if (! (v[i] in V1)) {
				V1[v[i]] = __nx_if(B2, 0, ++V1[0])
				V1[V1[0]] = v[i]
			}
			if (B2)
				V1[v[i]]++
		}
		i = V1[0]
	}
	delete v
	return i
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

function nx_map(D1, V1, S1, S2, V2, D2, B1, B2,		v1, v2, c, s, i, j, m)
{
	if (__nx_defined(D1)) {
		__nx_quote_map(V2)
		S1 = __nx_else(S1, ",")
		V2[S1] = ""
		S2 = __nx_else(S2, "=")
		V2[S2] = ""
		nx_bijective(v1, S1, "", S2)
		c = v1[S1]
		while (D1) {
			i = nx_next_pair(D1, V2, v2, D2, 1, B1)
			m = substr(D1, v2[i], v2[i "_" v2[i]])
			j = v2[i] + v2[i "_" v2[i]]
			s = s substr(D1, 1, v2[i] - 1)
			if (length(V2[m])) {
				s = s substr(D1, j, v2[++i])
				j = j + v2[i] + v2[i "_" v2[i]]
			} else {
				if (m == c) {
					if (m == S2) {
						V1[++V1[0]] = __nx_if(B2, s, nx_trim_str(s))
					} else {
						V1[V1[V1[0]]] = __nx_if(B2, s, nx_trim_str(s))
					}
					c = v1[c]
					s = ""
				}
			}
			D1 = substr(D1, j)
		}
		if (s != "") {
			if (c == S1)
				V1[V1[V1[0]]] = __nx_if(B2, s, nx_trim_str(s))
			else
				V1[++V1[0]] = __nx_if(B2, s, nx_trim_str(s))
		}
		return V1[0]
	}
}

function nx_trim_split(D, V, S)
{
	return split(nx_trim_str(D), V, "[ \v\t\n\f]*" __nx_else(S, ",") "[ \v\t\n\f]*")
}

