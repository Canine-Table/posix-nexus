function nx_json(D, V,		chars, tok, depth, b_map, d_map, q_map)
{
	if (D == "")
		return
	tok["line"] = 1
	tok["char"] = 0
	tok["length"] = 0
	tok["error"] = 0
	tok["escape"] = 0
	tok["token"] = 0
	tok["state"] = "NX_NONE"
	tok["delim"] = ""
	tok["quote"] = ""
	tok["file"] = D
	depth[0] = 0
	d_map[","] = ":"
	d_map["\x7b"] = ":"
	d_map[":"] = ","
	d_map["\x5b"] = ","
	__nx_bracket_map(b_map, 1, 1)
	__nx_quote_map(q_map, 1, 1)
	while ((getline tok["length"] < D) > 0) {
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
					if (chars[tok["char"]] ~ /[\\[\\{]/) {
						depth[++depth[0]] = chars[tok["char"]]
						tok["delim"] = d_map[chars[tok["char"]]]
					} else if (chars[tok["char"]] == b_map[b_map[chars[tok["char"]]]]) {
						delete depth[depth[0]--]
						tok["delim"] = ","
					} else {
						nx_json_error(tok, depth, "Expected (" b_map[depth[depth[0]]] ") but received (" chars[tok["char"]] ").")
						tok["error"] = 2
						break
					}
					chars[tok["char"]] = ""
				} else if (nx_is_alpha(chars[tok["char"]])) {
					tok["state"] = "NX_IDENTIFIER"
				} else if (nx_is_digit(chars[tok["char"]]) || chars[tok["char"]] ~ /[+]|[-]/) {
					tok["state"] = "NX_NUMBER"
				} else if (chars[tok["char"]] == ".") {
					tok["state"] = "NX_FLOAT"
				} else if (chars[tok["char"]] in d_map) {
					tok["delim"] = nx_json_next(depth[depth[0]], tok["delim"])
					chars[tok["char"]] = ""
				} else {
					nx_json_error(tok, depth, "I don't know what to do with this (" chars[tok["char"]] "), giving up.")
					tok["error"] = 3
					break
				}
				tok["escape"] = 0
				tok["quote"] = ""
				if (chars[tok["char"]] != "")
					tok["token"] = chars[tok["char"]]
			} else if (tok["state"] == "NX_NUMBER" || tok["state"] == "NX_FLOAT") {
				if (tok["error"] = nx_json_number(tok, chars, V))
					break
			} else if (tok["state"] == "NX_STRING") {
				if (tok["error"] = nx_json_string(tok, chars, V)) {
					nx_json_error(tok, depth, "Invalid quote " tok["quote"] ".")
					break
				}
			} else if (tok["state"] == "NX_IDENTIFIER") {
				if (tok["error"] = nx_json_identifier(tok, chars, V)) {
					nx_json_error(tok, depth, "Invalid identifier " tok["token"] ".")
					break
				}
			} else if (tok["state"] == "NX_NONE") {
					if (nx_is_space(chars[tok["char"]]))
						continue
					if (chars[tok["char"]] ~ /[\\[\\{]/) {
						tok["state"] = "NX_DEFAULT"
						depth[++depth[0]] = chars[tok["char"]]
					} else {
						nx_json_error(tok, depth, "Expected object ({) or array ([) before " chars[tok["char"]])
						tok["error"] = 1
						break
					}
				}
			}
			if (tok["error"])
				break
		}
		++tok["line"]
	}
	close (D)
	if (tok["quote"] && ! tok["error"]) {
		nx_json_error(tok, depth, "Quote " tok["quote"] " was never terminated.")
		tok["error"] = 6
	}
	if (depth[0] && ! tok["error"]) {
