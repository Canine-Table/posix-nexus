#nx_include "nex-misc.awk"
#nx_include "nex-struct.awk"
#nx_include "nex-math.awk"

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

function nx_count_str(D, S)
{
	return gsub(__nx_else(S, "."), "&", D)
}

function nx_escape_str(D1, N, B, D2, D3,	e)
{
	N = __nx_else(nx_natural(N), 1)
	D2 = __nx_else(D2, "[\\[\\]\\{\\}\\(\\)\\.\\+\\-\\*\\?\\^\\$\\|\\&]|\\")
	D3 = __nx_else(D3, "\\")
	do {
		if (B)
			e = e D3
		else
			gsub(D2, D3 "\\&", D1)
	} while (--N)
	if (B)
		gsub(D2, e "\\&", D1)
	return D1
}

function nx_join_str(D1, D2, S, D3)
{
	if (length(D3))
		D3 = __nx_if(D3, "\x27", "\x22")
	if (D1 && D2)
		D1 = D1 S
	return D1 D3 D2 D3
}

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

function nx_trim_str(D, S)
{
	S = __nx_else(S, " \v\t\n\f")
	gsub("(^[" S "]+|[ " S "]+$)", "", D)
	return D
}

function nx_append_str(D1, N, D2, B,	s)
{
	if (nx_natural(N) && D1 != "") {
		if (D2 != "")
			s = D2
		do {
			if (B)
				s = D1 s
			else
				s = s D1

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

function nx_pair_str(D, V, S)
{
	if (D != "") {
		if (match(D, __nx_else(S, "="))) {
			V[++V[0]] = substr(D, 1, RSTART - 1)
			V[V[V[0]]] = substr(D, RSTART + RLENGTH)
		} else {
			V[++V[0]] = D
			nx_boolean(V, D)
		}
	} else {
		V[++V[0]] = "<nx:false/>"
	}
}

function nx_totitle(D, B1, V2,		j, i, s, v1, v2)
{
	__nx_escape_map(v1)
	while (D) {
		i = nx_next_pair(D, v1, v2, B1, 1)
		j = v2[i] + v2[i "_s"]
		k = substr(D, 1, j)
		s = s toupper(substr(k, 1, 1)) tolower(substr(k, 2))
		D = substr(D, j + 1)
	}
	delete v1
	delete v2
	return s
}

function nx_random_str(N, D, S, B,	i, v1, v2, v3, s, r, f)
{
	N = int(__nx_if(nx_natural(N), N, 8))
	__nx_str_map(v1)
	nx_vector(__nx_else(D, "print"), v2, S, 1)
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

function nx_word(D1, D2)
{
	if (D1 != "" && D2 != "") {
		if (match(D1, "(^|[ \r\b\v\t\n\f]+)" D2 "($|[ \v\t\n\f]+)"))
			return substr(D1, RSTART + RLENGTH)
		return D1
	}
}

function nx_include(D1, D2, D3, V,	tok, s)
{
	if (s = nx_word(D1, D2)) {
		if  (s == D1) {
			return s
		} else {
			if (s ~ /^[\x27\x22\x60]/) {
				s = split(s, tok, "")
				tok["qte"] = tok[1]
				for (tok["cr"] = 2; tok["cr"] <= s; tok["cr"]++) {
					if (tok[tok["cr"]] != tok["qte"] || int(tok["esc"]) % 2 == 1) {
						if (tok["qte"] == "\x27" || tok[tok["cr"]] != "\x5c" || ++tok["esc"] % 2 == 0) {
							tok["rec"] = tok["rec"] tok[tok["cr"]]
							tok["esc"] = 0
						}
					} else {
						break
					}
				}
				if (s > tok["cr"])
					tok["ed"] = substr(D1, RSTART + RLENGTH + tok["cr"])
				if (RSTART > 1)
					tok["st"] = substr(D1, 1, RSTART)
				s = ""
				tok["rec"] = nx_trim_str(tok["rec"])
				sub(/^[.]\//, "", tok["rec"])
				if (D3 != "") {
					V[D3] = 1
					match(D3, /.*\//)
					if (! ((tok["rec"] = substr(D3, 1, RLENGTH) tok["rec"]) in V)) {
						V[tok["rec"]] = 1
						tok["nw"] = 1
					}
				} else {
					if (tok["rec"] !~ /\//)
						tok["rec"] = "./" tok["rec"]
					if (! (tok["rec"] in V)) {
						V[tok["rec"]] = 1
						tok["nw"] = 1
					}
				}
				if ("nw" in tok && nx_is_file(tok["rec"])) {
					while ((getline tok["cr"] < tok["rec"]) > 0) {
						s = nx_join_str(s, nx_include(tok["cr"], D2, D3, V), "\x0a")
					}
				}
				if (s == "")
					s = tok["st"] tok["ed"]
				delete tok
				return s
			}
		}
	}
}

