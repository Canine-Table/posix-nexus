function __return_value(DA, DB)
{
	if (DA)
		return DA
	return DB
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

