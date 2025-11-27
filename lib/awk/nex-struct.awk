#nx_include nex-misc.awk
#nx_include nex-str.awk

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

function nx_trim_split(D, V, S)
{
	D = split(nx_trim_str(D), V, "[ \v\t\n\f]*" __nx_else(S, ",") "[ \v\t\n\f]*")
	return V[0] = D
}

function nx_replace_pop(V, D)
{
	V[D] = V[V[0]]
	delete V[V[0]]
	return --V[0]
}

function nx_parr_stk(V, N, D)
{
	N = int(N)
	if (! (0 in V)) {
		if (N <= 0)
			N = 64
		V[0] = N
		do {
			V[N] = N
		} while (--N > 0)
	} else if (N > 0 && N <= V[0]) {
		if (D == "") {
			if (V[N] - V[0] >= V[V[N]]) {
				D = V[V[N]]
				delete V[V[N]]
				V[N] = V[N] - V[0]
				return D
			}
		} else {
			if (D == "<nx:null/>")
				D = ""
			V[N] = V[N] + V[0]
			V[V[N]] = D
			return V[N]
		}
	} else if (D == int(D) && (D = int(D)) >= 0 && D <= V[0]) {
		return V[D]
	}
	return -1
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


