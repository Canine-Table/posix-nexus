function nx_find_index(D1, S, D2,		f, m)
{
	if (__nx_defined(D1, 1)) {
		m = 0
		f = 0
		S = __nx_else(S, "\x20")
		D2 = __nx_else(D2, "\\")
		while (match(D1, S)) {
			f = f + RSTART
			if (! (match(substr(D1, 1, RSTART - 1), D2 "+$") && __nx_defined(D2, 1)) || int(RLENGTH % 2) == 0) {
				m = 1
				break
			} else {
				f = f + RLENGTH
				D1 = substr(D1, f + 1)
			}
		}
		return f
	}
}

function nx_next_index(D1, V, S, D2, B1, B2,	i, m, f)
{
	if (__nx_defined(D1, 1)) {
		if (! length(V)) {
			if (S)
				split(S, V, "")
			else
				return 0
		}
		for (i in V) {
			m = nx_find_index(D1, V[i], D2)
			if (! f || __nx_or(B1, m > f, m < f))
				f = m
		}
		if (B2)
			delete V
		return f
	}
}

function nx_token_group(D1, V1, V2, D2, B,	s, e, i, t)
{
	if (length(V1) && length(D1)) {
		V2[0] = int(V2[0])
		for (i in V1) {
			s = i
			gsub(//, "\\", s)
			if ((s = nx_find_index(D1, substr(s, 1, length(s) - 1), D2)) && (e = V1[i])) {
				gsub(//, "\\", e)
				t = s + length(i)
				if (e = nx_find_index(substr(D1, t), substr(e, 1, length(e) - 1), D2)) {
					V2[++V2[0] "_s"] = s
					V2[V2[0] "_c"] = substr(D1, t, e - 1)
					V2[V2[0] "_e"] = t + e + length(V1[i]) - 1
				}
			}
		}
		if (B)
			delete V1
		return V2[0]
	}
}

