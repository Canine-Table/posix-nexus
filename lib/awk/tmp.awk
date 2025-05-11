
function nx_lex_number(V1, V2, N)
{
	if (V2[N] ~ /[0-9]/) {
		V1["t"] = V1["t"] V2[N]
	} else if (V2[N] == ".") {
		V1["s"] = "nx_float"
		V1["t"] = V1["t"] V2[N]
	} else {
		nx_printf("l<s_b^s_u%", "Number: " V1["t"])
		V1["s"] = "nx_default"
		V1["t"] = ""
		#return --N
	}
	return N
}

function nx_lex_float(V1, V2, V3)
{
	if (V2[N] ~ /[0-9]/) {
		V1["t"] = V1["t"] V2[N]
	} else {
		nx_printf("l<s_b^s_u%", "Float: " V1["t"])
		V1["s"] = "nx_default"
		V1["t"] = ""
		#return --N
	}
	return N
}

function nx_lex_keyword(V1, V2, N)
{
	if (V2[N] ~ /[A-Za-z]/) {
		V1["t"] = V1["t"] V2[N]
	} else {
		nx_printf("l<s_b^s_u%", "Keyword: " V1["t"])
		V1["s"] = "nx_default"
		V1["t"] = ""
		#return --N
	}
	return N
}

function nx_lex_block(V1, V2, V3, D)
{
	if (D ~ /[\\{\\[\\(]/) {
		V1[++V1[0]] = D
	} else if (D == V3[V3[D]]) {
		if (V1[0] > 0) {
			delete V1[V1[0]--]
		} else {
			return nx_printf("l<e_b^e_u%", "extra " D " incountered on line " V2["l"] ".")
		}
	} else {
		return nx_printf("l<e_b^e_u%", "expected " V3[V2[V2[0]]] ", received " D " on line " V2["l"] ".")
	}
}

function nx_lex_string(V1, V2, N)
{
	if (V2[N] != V1["q"]) {
		V1["t"] = V1["t"] V2[N]
	} else {
		nx_printf("l<s_b^s_u%", "Float: " V1["t"])
		V1["s"] = "nx_default"
		V1["t"] = ""
		#return --N
	}
	return N
}


