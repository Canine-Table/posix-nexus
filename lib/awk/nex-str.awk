function __nx_load_char_map(V)
{
	V["upper"] = "A-Z"
	V["lower"] = "a-z"
	V["xupper"] = "A-F"
	V["xlower"] = "a-f"
	V["digit"] = "0-9"
	V["alpha"] = V["upper"] V["lower"]
	V["xdigit"] = V["digit"] V["xupper"] V["xlower"]
	V["alnum"] = V["digit"] V["alpha"]
	V["print"] = "\x20-\x7e"
	V["punct"] = "\x21-\x2f\x3a-\x40\x5b-\x60\x7b-\x7e"
}

function __nx_load_esc_map(V)
{
	V[" "] = "\x20"
	V["b"] = "\x08"
	V["t"] = "\x09"
	V["n"] = "\x0a"
	V["v"] = "\x0b"
	V["f"] = "\x0c"
	V["r"] = "\x0d"
	V["e"] = "\x1b"
}

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

function nx_escape_str(D)
{
	gsub(/./, "\\\\&", D)
	return D
}



function nx_trim_str(D, S)
{
	S = __nx_else(S, " \v\t\n\f")
	gsub("(^[" S "]+|[ " S "]+$)", "", D)
	return D
}

#function nx_totitle(D,	i, s, esc_map)
#{
#	__nx_load_esc_map(esc_map)
#	while (i = __first_index(D, esc_map, 1)) {
#		s = s toupper(substr(D, 1, 1)) tolower(substr(D, 2, i - 1))
#		D = substr(D, i + 1)
#	}
#	delete esc_map
#	return s
#}


