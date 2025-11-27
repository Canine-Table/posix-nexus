#nx_include nex-struct,awk

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

function __nx_escape_map(V)
{
	V["\x20"] = ""
	V["\x09"] = ""
	V["\x0a"] = ""
	V["\x0b"] = ""
	V["\x0c"] = ""
}

