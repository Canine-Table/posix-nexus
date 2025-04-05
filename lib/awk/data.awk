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

function nx_first_index(D, S, B,	i, j, l, v, m, c)
{
	l = nx_uniq(S, v, "")
	for (i = 1; i <= l; i++) {
		c = D
		k = 0
		while (j = index(c, v[i])) {
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
	delete v
	if (! m && B)
		return length(D)
	return m
}

function nx_tokenize(D, V, S,		bg, cur, sep)
{
	S = __nx_else(S, "\t\v\n\f ")
	while (bg = nx_first_index(D, S "\x22\x27", 1)) {
		cur = substr(D, 1, bg)
		sep = substr(D, bg, 1)
		D = substr(D, bg + 1)
		if (sep ~ /\x22|\x27/) {
			if (bg = nx_first_index(D, "\x22|\x27", 1)) {
				cur = substr(D, 1, bg - 1)
				D = substr(D, bg + 2)
			}
			printf("[Warning]: Missing closing %s quote near position %d in token %d.\n", sep, bg, V[0]) > /dev/stderr
		}
		V[++V[0]] = cur
	}
	return V[0]
}

function nx_vector(D, V, S,	l, v)
{
	if (D ~ /^[ \t\v\n\f]*$/) {
		if (length(V)) {
			nx_tmpa = V[V[0]]
			if (S == "pop")
				delete V[V[0]--]
			else if (S == "empty")
				return V[0] > 1
			return nx_tmpa
		}
	} else {
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

#function vector_map(D, V, S1, S2)
#{
#
#}

