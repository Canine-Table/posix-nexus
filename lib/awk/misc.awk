function __return_value(D1, D2)
{
	if (D1)
		return D1
	return D2
}

function __return_if_value(D1, D2, B)
{
	if (D1) {
		if (B)
			D1 = D2 D1
		else
			D1 = D1 D2
		return D1
	}
}

function __return_else_value(D1, D2, B)
{
	if (TRUE__(D1, B))
		return D2
}

function __load_value(V, K, DA, DB)
{
	if (DA != "NULL") {
		if (! (V[K] = DA))
			V[K] = DB
	}
}

function __load_delim(V, S, O)
{
	__load_value(V, "s", S, ",")
	__load_value(V, "o", O, "\x0a")
}

function __load_tag(V, L, R)
{
	__load_value(V, "l", L, "<")
	__load_value(V, "r", R, ">")
}

