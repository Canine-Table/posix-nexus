function nx_uniq(D, V, S, B,	v, i, l)
{
	l = split(D, v, S)
	for (i = 1; i <= l; i++) {
		if (! (v[i] in V)) {
			++V[0]
			V[v[i]] = __nx_if(B, 0, V[0])
			V[V[0]] = v[i]
		}
		if (B)
			V[v[i]]++
	}
	delete v
	return V[0]
}

function nx_first_index(D, S, B1, V, B2,	i, j, k, l, m, c)
{
	if (! (length(V) && 0 in V) || B2)
		nx_uniq(S, V, "")
	for (i = 1; i <= V[0]; i++) {
		c = D
		k = 0
		while (j = index(c, V[i])) {
			k = k + j
			if (j) {
				if (! match((n = substr(c, 1, j - 1)), /\\+$/) || int(RLENGTH % 2) == 0)
					break
			}
			c = substr(c, j + 1)
		}
		if (k && k < m || ! m)
			m = k
	}
	if (! m && B1)
		return length(D)
	return m
}

function nx_tokenize(D, V, S, B,	bg, cur, sep, v)
{
	S = __nx_else(S, "\t\v\n\f ")
	while (bg = nx_first_index(D, S "\x22\x27", 1, v)) {
		cur = substr(D, 1, bg)
		sep = substr(D, bg, 1)
		D = substr(D, bg + 1)
		if (sep ~ /[\x22\x27]/) {
			if (bg = nx_first_index(D, "[\x22\x27]", 1)) {
				cur = substr(D, 1, bg - 1)
				D = substr(D, bg + 2)
			}
			__nx_error(sprintf("[Warning]: Missing closing %s quote near position %d in token %d.\n", sep, bg, V[0]), V, 4)
		}
		V[++V[0]] = cur
	}
	if (__nx_null(B))
		delete v
	return V[0]
}

function nx_vector(D, V, S,	l, v)
{
	if (D !~ /^[ \t\v\n\f]*$/) {
		l = int(V[0])
		S = __nx_else(S, ",")
		nx_tokenize(D, v, S)
		for (i = 1; i <= v[0]; i++) {
			if (v[i] !~ /^[ \t\v\n\f]*$/) {
				if (v[i] ~ /(\x22|\x27)$/)
					V[++l] = v[i]
				else if (v[i] ~ S "$")
					V[++l] = nx_trim_str(substr(v[i], 1, length(v[i]) - 1))
				else
					V[++l] = nx_trim_str(v[i])
			}
		}
		V[0] = l
		delete v
		return l
	}
}

function __nx_vector_check(D1, V, S, D2, D3,	l, v)
{
	if (! (length(V) && 0 in V) || D1) {
		S = __nx_else(S, ",")
		if (__nx_null(D1))
			return __nx_error(__nx_else("data is required", D2), V, __nx_else(D3, 3))
		nx_vector(D1, V, S)
	}
	return V[0]
}

function nx_length(V, D, S, B,		i, m, cur)
{
	if (! __nx_vector_check(D, V, S))
		return 0
	for (i = 1; i <= V[0]; i++) {
		cur = length(arr[i])
		if (! m || __nx_or(B, m < cur, m > cur))
			m = cur
	}
	return m
}

function nx_boundary(D1, V, S, D2, B1, B2,	v, i, l, s)
{
	if (! __nx_vector_check(D2, V, S))
		return 0
	if (D1) {
		S = __nx_else(S, ",")
		l = length(D1)
		for (i = 1; i <= V[0]; i++) {
			if (__nx_or(B1, D1 == substr(V[i], length(V[i]) + 1 - l), D1 == substr(V[i], 1, l)))
				s = nx_join_str(s, V[i], S)
		}
	}
	if (__nx_null(B2))
		delete V
	return s
}

function nx_filter(D1, D2, V, S, B,	i, s)
{
	if (length(V) && 0 in V) {
		for (i = 1; i <= V[0]; i++) {
			print V[i]
			if (__nx_equality(D1, D2, V[i]))
				s = nx_join_str(s, V[i], S)
		}
		if (__nx_null(B))
			delete V
		return s
	}
}

function nx_option(D1, V, S, D2, B1, B2,  B3,	m)
{
	S = __nx_else(S, ",")
	if (m = nx_boundary(D1, V, S, D2, B1)) {
		nx_tokenize(m, V, S, 1)
		if (V[0] > 1) {
			delete V
			nx_tokenize(nx_filter(nx_append_str("0", nx_length(V, "", S, B2, 1)), "=_", V, S), V, S, 1)
			if (V[0] == 1)
				m = V[V[0]]
		} else {
			m = V[V[0]]
		}
		if (__nx_null(B3))
			delete V
		return m
	}
}

