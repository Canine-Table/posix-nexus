#nx_include "nex-struct.awk"
#nx_include "nex-str.awk"
#nx_include "nex-math.awk"

function nx_to_environ(D,	m)
{
	D = toupper(nx_trim_str(D))
	gsub(/[ \t]/, "_", D)
	if (! (m = sub(/^[.]/, "L_", D)))
	if (! (m = sub(/^[*]/, "G_", D)))
	if (! (m = sub(/^[@]/, "NEXUS_", D)))
	if (! (m = sub(/^[%]/, "P_", D)))
		sub(/^[0-9]/, "_\\&", D)
	gsub(/[^0-9A-Z_]/, "", D)
	return D
}

function nx_is_file(D)
{
	if ((getline < D) > 0)
		close(D)
	else
		return 0
	return 1
}

function nx_is_space(D)
{
	return D ~ /[ \t\n\f\r\v\b]/
}

function nx_is_upper(D)
{
	return D ~ /[A-Z]/
}

function nx_is_lower(D)
{
	return D ~ /[a-z]/
}

function nx_is_alpha(D)
{
	return nx_is_lower(D) || nx_is_upper(D)
}

function nx_is_digit(D)
{
	return D ~ /[0-9]/
}

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

function __nx_quote_map(V, B1, B2, B3)
{
	if (B1) {
		if (B1 > 1)
			V["\x22\x22"] = "NX_DOUBLE_STRING"
		V["\x22"] = "\x22"
	}
	if (B2) {
		if (B2 > 1)
			V["\x27\x27"] = "NX_SINGLE_STRING"
		V["\x27"] = "\x27"
	}
	if (B3) {
		if (B3 > 1)
			V["\x60\x60"] = "NX_TICK_STRING"
		V["\x60"] = "\x60"
	}
}

function __nx_bracket_map(V, B1, B2, B3, B4)
{
	if (B1) {
		if (B1 > 1) {
			V["\x5b\x5d"] = "NX_RBRACKET"
			V["\x5d\x5b"] = "NX_LBRACKET"
		}
		nx_bijective(V, "\x5b", "\x5d")
	}
	if (B2) {
		if (B2 > 1) {
			V["\x7b\x7d"] = "NX_RBRACE"
			V["\x7d\x7b"] = "NX_LBRACE"
		}
		nx_bijective(V, "\x7b", "\x7d")
	}
	if (B3) {
		if (B3 > 1) {
			V["\x29\x28"] = "NX_LPARENTHESES"
			V["\x28\x29"] = "NX_RPARENTHESES"
		}
		nx_bijective(V, "\x28", "\x29")
	}
	if (B4) {
		if (B4 > 1) {
			V["\x3e\x3c"] = "NX_XML_LTAG"
			V["\x2f\x3e"] = "NX_XML_STAG"
			V["\x3c\x3e"] = "NX_XML_RTAG"
		}
		nx_bijective(V, "\x3c", "\x3e")
	}
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

function __nx_swap(V, D1, D2,	t)
{
	t = V[D1]
	V[D1] = V[D2]
	V[D2] = t
}

