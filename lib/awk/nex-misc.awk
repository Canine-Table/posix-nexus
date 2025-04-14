function __nx_num_map(V,  i)
{
	for (i = 0; i < 10; i++)
		V[i] = i
}

function __nx_lower_map(V,	i)
{
	__nx_num_map(V)
	for (i = 10; i < 36; i++)
		nx_bijective(V, i, sprintf("%c", i + 87))
}

function __nx_upper_map(V,	i)
{
	__nx_lower_map(V)
	for (i = 36; i < 62; i++)
		nx_bijective(V, i, sprintf("%c", i + 29))
}

function __nx_quote_map(V)
{
	V["\""] = "\""
	V["'"] = "'"
	V["`"] = "`"
}

function __nx_bracket_map(V)
{
	V["\x5b"] = "\x5d"
	V["\x7b"] = "\x7d"
	V["\x28"] = "\x29"
}

function __nx_str_map(V)
{
	nx_bijective(V, ++V[0], "upper", "A-Z")
	nx_bijective(V, ++V[0], "lower", "a-z")
	nx_bijective(V, ++V[0], "xupper", "A-F")
	nx_bijective(V, ++V[0], "xlower", "a-f")
	nx_bijective(V, ++V[0], "digit", "0-9")
	nx_bijective(V, ++V[0], "alpha", V["upper"] V["lower"])
	nx_bijective(V, ++V[0], "xdigit", V["digit"] V["xupper"] V["xlower"])
	nx_bijective(V, ++V[0], "alnum", V["digit"] V["alpha"])
	nx_bijective(V, ++V[0], "print", "\x20-\x7e")
	nx_bijective(V, ++V[0], "punct", "\x21-\x2f\x3a-\x40\x5b-\x60\x7b-\x7e")
}

function __nx_escape_map(V)
{
	V["\x20"] = ""
	V["\x09"] = ""
	V["\x0a"] = ""
	V["\x0b"] = ""
	V["\x0c"] = ""
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

function __nx_if(B1, D1, D2, B2)
{
	if (B1 || __nx_defined(B1, B2))
		return D1
	return D2
}

function __nx_elif(B1, B2, B3, B4, B5, B6)
{
	if (B4) {
		B5 = __nx_else(B5, B4)
		B6 = __nx_else(B6, B5)
	}
	return (__nx_defined(B1, B4) == __nx_defined(B2, B5) && __nx_defined(B3, B6) != __nx_defined(B1, B4))
}

function __nx_or(B1, B2, B3, B4, B5, B6)
{
	if (B4) {
		B5 = __nx_else(B5, B4)
		B6 = __nx_else(B6, B5)
	}
	return ((__nx_defined(B1, B4) && __nx_defined(B2, B5)) || (__nx_defined(B3, B6) && ! __nx_defined(B1, B4)))
}

function __nx_xor(B1, B2, B3, B4)
{
	if (B3)
		B4 = __nx_else(B4, B3)
	return ((! __nx_defined(B2, B4) && __nx_defined(B1, B3)) || (__nx_defined(B2, B4) && ! __nx_defined(B1, B3)))
}

function __nx_compare(B1, B2, B3, B4)
{
	if (! B3) {
		if (length(B3)) {
			B1 = length(B1)
			B2 = length(B2)
		} else if (__nx_is_digit(B1, 1) && __nx_is_digit(B2, 1)) {
			B1 = +B1
			B2 = +B2
		} else {
			B1 = "a" B1
			B2 = "a" B2
		}
		B3 = 1
	}

	if (B4) {
		return __nx_if(__nx_is_digit(B4), B1 > B2, B1 < B2) || __nx_if(__nx_else(B4 == 1, tolower(B4) == "i"), B1 == B2, 0)
	} else if (length(B4)) {
		return B1 ~ B2
	} else {
		return B1 == B2
	}
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

function __nx_swap(V, D1, D2,	t)
{
	t = V[D1]
	V[D1] = V[D2]
	V[D2] = t
}

