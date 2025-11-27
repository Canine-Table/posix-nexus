#nx_include nex-struct.awk
#nx_include nex-map.awk
#nx_include nex-type.awk
#nx_include nex-type.awk
#nx_include nex-int.awk

function nx_boolean(V, D)
{
	if (V[D] == "<nx:true/>")
		V[D] = "<nx:false/>"
	else if (V[D] == "" || V[D] == "<nx:false/>")
		V[D] = "<nx:true/>"
}

function __nx_defined(D, B)
{
	return (D || (length(D) && B))
}

function __nx_else(D1, D2, B)
{
	if (D1 || __nx_defined(D1, B))
		return D1
	return D2
}

function __nx_only(D1, D2, B)
{
	if (D1 || __nx_defined(D1, B))
		return D2
}

function __nx_if(B1, D1, D2, B2)
{
	if (B1 || __nx_defined(B1, B2))
		return D1
	return D2
}

function __nx_compare(B1, B2, B3, B4)
{
	if (! B3) {
		if (length(B3)) {
			B1 = length(B1)
			B2 = length(B2)
		} else if (nx_digit(B1, 1) && nx_digit(B2, 1)) {
			B1 = +B1
			B2 = +B2
		} else {
			B1 = "a" B1
			B2 = "a" B2
		}
		B3 = 1
	}
	if (B4)
		return __nx_if(nx_digit(B4), B1 > B2, B1 < B2) || __nx_if(__nx_else(nx_digit(B4) == 1, tolower(B4) == "i"), B1 == B2, 0)
	if (length(B4))
		return B1 ~ B2
	return B1 == B2
}

function __nx_equality(B1, B2, B3,	b, e, g)
{
	b = substr(B2, 1, 1)
	if (b == ">") {
		e = 2
		g = 1
	} else if (b == "<") {
		e = "a"
		g = "i"
	} else if (b == "=") {
		e = ""
	} else if (b == "~") {
		e = 0
	} else {
		b = ""
	}
	if (b) {
		if (__nx_compare(substr(B2, 2, 1), "=", 1)) {
			b = g
		} else {
			b = e
		}
		e = substr(B2, length(B2), 1)
		if (__nx_compare(e, "a", 1))
			return __nx_compare(B1, B3, "", b)
		else if (__nx_compare(e, "_", 1))
			return __nx_compare(B1, B3, 0, b)
		else
			return __nx_compare(B1, B3, 1, b)
	}
	return __nx_compare(B1, B2)
}

