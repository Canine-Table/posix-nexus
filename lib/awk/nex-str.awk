#nx_include nex-misc.awk
#nx_include nex-struct.awk
#nx_include nex-int.awk
#nx_include nex-log.awk

function nx_append_str(D1, N1, D2, N2, D3, D4)
{
	if (! nx_natural(N1) || D1 == "")
		return D2
	if (N2) {
		while (N1--)
			D2 = nx_join_str(D1, D2, D3, D4)
	} else {
		while (N1--)
			D2 = nx_join_str(D2, D1, D3, D4)
	}
	return D2

}

function nx_count_str(D, S)
{
	return gsub(__nx_else(S, "."), "&", D)
}

function nx_join_str(D1, D2, D3, D4)
{
	if (D4 != "")
		D3 = __nx_if(D4, "\x27", "\x22")
	if (D1 != "" && D2 != "")
		D1 = D1 D3
	return D1 D4 D2 D4
}

function nx_trim_str(D, S)
{
	S = __nx_else(S, " \v\t\n\f")
	gsub("(^[" S "]+|[ " S "]+$)", "", D)
	return D
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

function nx_reverse_str(D,
	s, i,
	v)
{
	if (D == "")
		return ""
	D = split(D,  v, "") + 1
	D = int(D / 2 + 0.5)
	i = D--
	s = v[i]
	do {
		s = v[++i] s v[D]
	} while (--D > 0)
	delete v
	return s
}

