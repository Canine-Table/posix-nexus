function nx_reverse_str(D,	i, v)
{
	if ((i = split(D, v, "")) > 1) {
		D = ""
		do {
			D = D v[i]
		} while (--i)
	}
	delete v
	return D
}

function nx_escape_str(D)
{
	gsub(/./, "\\\\&", D)
	return D
}

function nx_join_str(D1, D2, S, D3)
{
	D3 = __nx_if(Q, "\x27", "\x22")
	if (D1 && D2)
		D1 = D1 S
	return D1 D3 D2 D3
}

function nx_trim_str(D, S)
{
	S = __nx_else(S, " \v\t\n\f")
	gsub("(^[" S "]+|[ " S "]+$)", "", D)
	return D
}

function nx_append_str(D, N,	s)
{
	if (__nx_is_natural(N) && __nx_defined(D, 1)) {
		do {
			s = s D
		} while (--N)
		return s
	}
}

function nx_cut_str(D1, D2, B)
{
	if (match(D1, D2)) {
		if (B)
			return substr(D1, 1, RSTART - 1)
		if (length(B))
			return substr(D1, RSTART + RLENGTH)
		return substr(D1, RSTART, RLENGTH)
	}
}

function nx_totitle(D, B1, B2,		j, i, s, v1, v2)
{
	__nx_escape_map(v1)
	while (D) {
		i = nx_next_pair(D, v1, v2, B1, 1)
		j = v2[i] + v2[i "_s"]
		k = substr(D, 1, j)
		s = toupper(substr(k, 1, 1)) tolower(substr(k, 2))
		D = substr(D, j + 1)
	}
	delete v1
	delete v2
	return s
}

function nx_random_str(N, D, S, B,	i, v1, v2, v3, s, r, f)
{
	N = int(__nx_if(__nx_is_natural(N), N, 8))
	__nx_str_map(v1)
	nx_trim_vector(__nx_else(D, "print"), v2, S)
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

