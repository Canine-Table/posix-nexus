#nx_include nex-misc.awk
#nx_include nex-struct.awk
#nx_include nex-int.awk
#nx_include nex-log.awk

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

function nx_count_str(D, S)
{
	return gsub(__nx_else(S, "."), "&", D)
}

function nx_join_str(D1, D2, S, D3)
{
	if (length(D3))
		D3 = __nx_if(D3, "\x27", "\x22")
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

