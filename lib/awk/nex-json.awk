function __nx_json_delim_map(V)
{
	V[","] = ":"
	V["\x7b"] = ":"
	V[":"] = ","
	V["\x5b"] = ","
}

function nx_json_log(V1, V2, D)
{
	return "(\n\tFile: '" V1["file"] "'\n\tLine: '" V1["line"] "'\n\tToken: '" V1["char"] "'\n\tDepth: '" V2[0] "'\n\tType: '" V1["state"] "'\n): '" D "'"
}

function nx_json_error(V1, V2, D, B)
{
	print nx_log_error(nx_json_log(V1, V2, D), B)
}

function nx_json_success(V1, V2, D, B)
{
	print nx_log_success(nx_json_log(V1, V2, D), B)
}

function nx_json_warn(V1, V2, D, B)
{
	print nx_log_warn(nx_json_log(V1, V2, D), B)
}

function nx_json_info(V1, V2, D, B)
{
	print nx_log_info(nx_json_log(V1, V2, D), B)
}

function nx_json_debug(V1, V2, D, B)
{
	print nx_log_debug(nx_json_log(V1, V2, D), B)
}

function nx_json_alert(V1, V2, D, B)
{
	print nx_log_alert(nx_json_log(V1, V2, D), B)
}

function nx_is_space(D)
{
	return D ~ /[ \t\n\f\r\v]/
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

function nx_json_next(D1, D2)
{
	if (D1 == "[" || D2 == ":")
		return ","
	return ":"
}

function nx_json_number(V1, V2, V3, B, V4)
{
	if (nx_is_digit(V2[V1["char"]])) {
		V1["token"] = V1["token"] V2[V1["char"]]
	} else if (V2[V1["char"]] == "." && V1["state"] != "NX_FLOAT") {
		V1["token"] = V1["token"] V2[V1["char"]]
		V1["state"] = "NX_FLOAT"
	} else {
		V3[++V3[0]] = V1["state"]
		V3[V3[0] "_" V1["state"]] = V1["token"]
		if (B)
			nx_json_debug(V1, V4, V1["token"])
		V1["state"] = "NX_DELIMITER"
		V1["char"]--
	}
}

function nx_json_identifier(V1, V2, V3, B, V4,		t)
{
	if (nx_is_alpha(V2[V1["char"]])) {
		V1["token"] = V1["token"] V2[V1["char"]]
	} else {
		t = tolower(V1["token"])
		if (t ~ /^(true|false)$/) {
			V1["state"] = "NX_BOOLEAN"
		} else if (t ~ /^(nil|null|none|undefined)$/) {
			V1["state"] = "NX_UNDEFINED"
		} else {
			V1["state"] = "NX_ERR_INVALID_IDENTIFIER"
			nx_json_error(V1, V4, "Found an invalid identifier " V1["token"] ".")
			return 4
		}
		V3[++V3[0]] = V1["state"]
		V3[V3[0] "_" V1["state"]] = V1["token"]
		if (B)
			nx_json_debug(V1, V4, V1["token"])
		V1["state"] = "NX_DELIMITER"
		V1["char"]--
	}
}

function nx_json_string(V1, V2, V3, B, V4)
{
	if (V2[V1["char"]] != V1["quote"] || (V1["quote"] != "'" && nx_modulo(V1["escape"], 2) == 1)) {
		if (V1["quote"] == "'" || V2[V1["char"]] != "\\" || nx_modulo(++V1["escape"], 2) == 0) {
			V1["escape"] = 0
			V1["token"] = V1["token"] V2[V1["char"]]
		}
	} else {
		if (V1["quote"] == "'")
			V1["state"] = "NX_SINGLE_STRING"
		else if (V1["quote"] == "\"")
			V1["state"] = "NX_DOUBLE_STRING"
		else if (V1["quote"] == "`")
			V1["state"] == "NX_TICK_STRING"
		else {
			V1["state"] =  "NX_ERR_MISSING_QUOTE"
			nx_json_error(V1, V4, "A string quote (" V1["quote"] ") was opened but never closed.")
			return 5
		}
		V1["quote"] = ""
		V3[++V3[0]] = V1["state"]
		V3[V3[0] "_" V1["state"]] = V1["token"]
		if (B)
			nx_json_debug(V1, V4, V1["token"])
		V1["state"] = "NX_DELIMITER"
	}
}

function nx_json_depth(V1, V2, V3, B, V4, V5,	t)
{
	if (V2[V1["char"]] ~ /[\[\{]/) {
		V4[++V4[0]] = V2[V1["char"]]
		V1["delim"] = nx_json_next(V4[V4[0]], V1["delim"])
		if (V2[V1["char"]] == "[")
			V1["state"] = "NX_LBRACKET"
		else
			V1["state"] = "NX_LBRACE"
		t = "NX_DEFAULT"
	} else if (V1["state"] != "NX_NONE" && V2[V1["char"]] == V5[V5[V2[V1["char"]]]]) {
		delete V4[V4[0]--]
		V1["delim"] = ","
		if (V2[V1["char"]] == "]")
			V1["state"] = "NX_RBRACKET"
		else
			V1["state"] = "NX_RBRACE"
		t = "NX_DELIMITER"
	} else {
		V1["state"] = "NX_ERR_BRACKET_MISMATCH"
		nx_json_error(V1, V4, "Expected (" V5[V4[V4[0]]] ") but received (" V2[V1["char"]] ").")
		return __nx_if(V1["state"] == "NX_NONE", 1, 2)
	}
	V3[++V3[0]] = V1["state"]
	V3[V3[0] "_" V1["state"]] = V4[0]
	if (B)
		nx_json_debug(V1, V4, V2[V1["char"]])
	V1["state"] = t
	V2[V1["char"]] = ""
}

function nx_json_delim(V1, V2, V3, B, V4)
{
	if (V2[V1["char"]] != V1["delim"]) {
		V1["state"] = "NX_ERR_UNEXPECTED_DELIM"
		nx_json_error(V1, V4, "Unexpected delimiter found " V2[V1["char"]] ".")
		return 8
	}
	if (V1["delim"] == nx_json_next(V4[V4[0]], V1["delim"]))
		V1["state"] = "NX_LIST_ITEM"
	else if (V1["delim"] == ":")
		V1["state"] = "NX_KEY_ITEM"
	else
		V1["state"] = "NX_VALUE_ITEM"
	V3[++V3[0]] = V1["state"]
	V1["delim"] = nx_json_next(V4[V4[0]], V1["delim"])
	V3[V3[0] "_" V1["state"]] = V1["delim"]
	if (B)
		nx_json_debug(V1, V4, V1["delim"])
	V1["state"] = "NX_DEFAULT"
	v2[V1["char"]] = ""
}

function nx_json(D, V, B,	chars, tok, depth, b_map, d_map, q_map)
{
	if (D == "")
		return 9
	tok["line"] = 1
	tok["file"] = D
	tok["state"] = "NX_NONE"
	__nx_json_delim_map(d_map)
	__nx_bracket_map(b_map, 1, 1)
	__nx_quote_map(q_map, 1, 1)
	while ((getline tok["length"] < tok["file"]) > 0) {
		tok["length"] = split(tok["length"], chars, "")
		for (tok["char"] = 1; tok["char"] <= tok["length"]; tok["char"]++) {
			if (tok["state"] == "NX_DEFAULT") {
				if (nx_is_space(chars[tok["char"]]))
					continue
				if (chars[tok["char"]] in q_map) {
					tok["quote"] = chars[tok["char"]]
					tok["state"] = "NX_STRING"
					chars[tok["char"]] = ""
				} else if (chars[tok["char"]] in b_map) {
					if (tok["error"] = nx_json_depth(tok, chars, V, B, depth, b_map))
						break
				} else if (nx_is_alpha(chars[tok["char"]])) {
					tok["state"] = "NX_IDENTIFIER"
				} else if (nx_is_digit(chars[tok["char"]]) || chars[tok["char"]] ~ /[+]|[-]/) {
					tok["state"] = "NX_NUMBER"
				} else if (chars[tok["char"]] == ".") {
					tok["state"] = "NX_FLOAT"
				} else {
					tok["state"] = "NX_ERR_UNEXPECTED_CHAR"
					nx_json_error(tok, depth, "Encountered an unexpected character (" chars[tok["char"]] ") that does not belong in JSON syntax.")
					tok["error"] = 3
					break
				}
				if (chars[tok["char"]] != "") {
					tok["escape"] = 0
					tok["quote"] = ""
				}
				tok["token"] = chars[tok["char"]]
			} else if (tok["state"] == "NX_DELIMITER") {
				if (nx_is_space(chars[tok["char"]]))
					continue
				if (chars[tok["char"]] ~ /[\]\}]/) {
					if (tok["error"] = nx_json_depth(tok, chars, V, B, depth, b_map))
						break
				} else if (chars[tok["char"]] in d_map) {
					if (tok["error"] = nx_json_delim(tok, chars, V, B, depth))
						break
				} else {
					tok["state"] = "NX_ERR_UNEXPECTED_CHAR"
					nx_json_error(tok, depth, "Encountered an unexpected character (" chars[tok["char"]] "), was looking for a delimiter.")
					tok["error"] = 10
					break
				}
			} else if (tok["state"] == "NX_NUMBER" || tok["state"] == "NX_FLOAT") {
				if (tok["error"] = nx_json_number(tok, chars, V, B, depth))
					break
			} else if (tok["state"] == "NX_STRING") {
				if (tok["error"] = nx_json_string(tok, chars, V, B, depth))
					break
			} else if (tok["state"] == "NX_IDENTIFIER") {
				if (tok["error"] = nx_json_identifier(tok, chars, V, B, depth))
					break
			} else if (tok["state"] == "NX_NONE") {
				if (nx_is_space(chars[tok["char"]]))
					continue
				if (tok["error"] = nx_json_depth(tok, chars, V, B, depth, b_map))
					break
			}
		}
		if (tok["error"])
			break
		++tok["line"]
	}
	close (D)
	if (tok["quote"] && ! tok["error"]) {
		tok["state"] = "NX_ERR_MISSING_QUOTE"
		nx_json_error(tok, depth, "A string quote (" tok["quote"] ") was opened but never closed.")
		tok["error"] = 6
	}
	if (depth[0] && ! tok["error"]) {
		tok["state"] = "NX_ERR_BRACKET_MISMATCH"
		nx_json_error(tok, depth, "Bracket mismatch detected. Expected closing '" depth[depth[0]] "' but found unexpected character.")
		tok["error"] = 7
	}
	delete b_map
	delete d_map
	delete q_map
	delete depth
	delete chars
	if (! (D = tok["error"]) && B) {
		for (tok["char"] = 1; tok["char"] <= V[0]; tok["char"]++)
			print V[tok["char"]] " = " V[tok["char"] "_" V[tok["char"]]]
	}
	delete tok
	return D
}

