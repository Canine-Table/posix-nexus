function nx_json_log(V, D)
{
	return "(\n\tFile: '" V["fl"] "'\n\tLine: '" V["ln"] "'\n\tCharacter: '" V["cr"] "'\n\tToken: '" V["rec"] "'\n\tDepth: '" V["stk"] "'\n\tCategory: '" V["cat"] "'\n\tWithin: '" V["ste"] "'\n\tIndex: '" V["idx"] "'\n): '" D "'"
}

function nx_json_log_delim(V, D)
{
	return "(\n\tFile: '" V["fl"] "'\n\tLine: '" V["ln"] "'\n\tCharacter: '" V["cr"] "'\n\tDepth: '" V["stk"] "'\n\tCategory: '" V["cat"] "'\n\tWithin: '" V["ste"] "'\n): '" D "'"
}

function nx_json_stack_push(V1, V2, V3)
{
	print -(V2["stk"])

	if (-(V2["stk"]) in V3) {
		V2["rdi"] = V3[-(V2["stk"] - 1)] "\x5b" ++V1[V3[-(V2["stk"] - 1)] "\x5b0\x5d"] "\x5d"
		V1[V2["rdi"]] = V2["nxt"]
	}
	print V1[V2["rdi"]] V2["rt"] "   [g]"
}

function nx_json_stack_pop(V1, V2, V3)
{
	print V2["rec"] "   [l]"
}

function nx_json_stack(V1, V2, V3)
{
	if (! (V2["rec"] == "" || V2["dth"] == V2["stk"])) {
		print "hi"
		if (V2["dth"] > V2["stk"]) {
			nx_json_stack_pop(V1, V2, V3)
		} else {
			nx_json_stack_push(V1, V2, V3)
		}
		V2["dth"] = V2["stk"]
	} else if (! ("rt" in V2)) {
		V3[-V2["stk"]] = ".nx"
		V2["rti"] = ""
		V2["rtl"] = V2["stk"]
		V2["rt"] = V3[-V2["stk"]]
	}
}

function nx_json_apply(V1, V2, V3)
{
	nx_json_stack(V1, V2, V3)
	if (V2["rec"] != "") {
		if (V3[V2["stk"]] == "\x5b") { # List
			print V2["rec"] "   [k]"
		} else if (V2["rec"] != "") {
			if (V2["idx"] == "NX_KEY") {
				V2["nxt"] = V2["rec"]

			} else {
				V2["rt"] = V2["rt"] "." V2["nxt"]
				print V2["rt"] "   [v]"
			}
		}
		V2["rec"] = ""
	}
}

function nx_json_float(V1, V2, V3, V4, B)
{
	if (nx_is_digit(V3[V2["cr"]])) { # If current character is a digit
		V2["rec"] = V2["rec"] V3[V2["cr"]] # Append to recorded number
	} else {
		if (V2["rec"] ~ /[.]$/) # If last recorded value is a decimal point
			V2["rec"] = V2["rec"] 0 # Append a zero for valid float representation
		V2["cat"] = "NX_DIGIT"
		if (B > 6) # Debugging
			print nx_log_debug(nx_json_log(V2, V2["rec"]))
		nx_json_apply(V1, V2, V4) # Apply the parsed value
		V2["ste"] = "NX_DELIMITER" # Move to delimiter state
		if (! nx_is_space(V3[V2["cr"]])) # If next character is not a space
			V2["cr"]-- # Step back to reevaluate
	}
}

function nx_json_number(V1, V2, V3, V4, B)
{
	if (V2["rec"] == "" && V3[V2["cr"]] ~ /[+]|[-]/) {
		V2["rec"] = V3[V2["cr"]]
	} else if (V3[V2["cr"]] == ".") { # If the current character is a decimal point
		if (V2["rec"] == "") # If we haven't recorded anything yet
			V2["rec"] = 0 # Start with zero
		V2["rec"] = V2["rec"] V3[V2["cr"]] # Append decimal point
		V2["ste"] = "NX_FLOAT" # Switch state to handle floating point numbers
	} else { # Otherwise, delegate to float handling
		nx_json_float(V1, V2, V3, V4, B)
	}
}

function nx_json_string(V1, V2, V3, V4, V5, B)
{
	if (V3[V2["cr"]] != V2["qte"] || int(V2["esc"]) % 2 == 1) {
		if (V2["qte"] == "\x27" || V3[V2["cr"]] != "\x5c" || ++V2["esc"] % 2 == 0) {
			V2["rec"] = V2["rec"] V3[V2["cr"]]
			V2["esc"] = 0
		}
	} else {
		if (V2["qte"] in V5 && V2["qte"] == V3[V2["cr"]]) {
			V2["ste"] = V5[V2["qte"]V2["qte"]]
		} else {
			V2["cat"] =  "NX_ERR_MISSING_QUOTE"
			print nx_log_error(nx_json_log(V2, "A string quote (" V2["qte"] ") was opened but never closed."))
			return 31
		}
		V2["qte"] = ""
		V2["esc"] = 0
		V2["cat"] = "NX_STRING"
		if (B > 6)
			print nx_log_debug(nx_json_log(V2, V2["rec"]))
		nx_json_apply(V1, V2, V4)
		V2["ste"] = "NX_DELIMITER"
	}
}

function nx_json_identifier(V1, V2, V3, V4, B,		t)
{
	if (nx_is_alpha(V3[V2["cr"]])) {
		V2["rec"] = V2["rec"] V3[V2["cr"]]
	} else {
		t = tolower(V2["rec"])
		if (t ~ /^(true|false)$/) {
			V2["cat"] = "NX_BOOLEAN"
		} else if (t ~ /^(nil|null|none|undefined)$/) {
			V2["cat"] = "NX_UNDEFINED"
		} else {
			V2["cat"] = "NX_ERR_INVALID_IDENTIFIER"
			if (B)
				print nx_log_error(nx_json_log(V2, "Found an invalid identifier " V2["rec"] "."))
			return 41
		}
		if (B > 6)
			print nx_log_debug(nx_json_log(V2, V2["rec"]))
		nx_json_apply(V1, V2, V4)
		V2["ste"] = "NX_DELIMITER"
		if (! nx_is_space(V3[V2["cr"]]))
			V2["cr"]--
	}
}

function nx_json_delimiter(V1, V2, V3, V4, V5, B)
{
	if (nx_is_space(V3[V2["cr"]]))
		return 0
	if (V3[V2["cr"]] in V5) {
		V2["err"] = nx_json_depth(V1, V2, V3, V4, V5, B)
		return V2["err"]
	} else if (V3[V2["cr"]] != V2["dlm"]) {
		print V3[V2["cr"]]
		V2["cat"] = "NX_ERR_UNEXPECTED_DELIM"
		if (B)
			print nx_log_error(nx_json_log(V2, "Unexpected delimiter found " V3[V2["cr"]] "."))
		return 51
	} else if (V4[V2["stk"]] == "[" || V2["dlm"] == ":") {
		V2["dlm"] = ","
		if (V4[V2["stk"]] == "{") {
			V2["idx"] = "NX_VALUE"
			V2["cat"] = "NX_OBJECT"
		} else {
			V2["idx"] = "NX_ITEM"
			V2["cat"] = "NX_LIST"
		}
	} else {
		V2["dlm"] = ":"
		V2["idx"] = "NX_KEY"
		V2["cat"] = "NX_OBJECT"
	}
	if (B > 5)
		print nx_log_alert(nx_json_log_delim(V2, V3[V2["cr"]]))
	V2["ste"] = "NX_DEFAULT" # Set state back to default
}

function nx_json_depth(V1, V2, V3, V4, V5, B)
{
	if (V3[V2["cr"]] ~ /[\x5b|\x7b]/) {
		if (V2["idx"] == "NX_KEY") {
			V2["cat"] = "NX_ERR_UNEXPECTED_KEY"
			if (B)
				print nx_log_error(nx_json_log(V2, "Encountered an unexpected character (" V3[V2["cr"]] ") that does not belong in a key."))
			return 13
		}
		V4[++V2["stk"]] = V3[V2["cr"]]
		V2["cat"] = V5[V5[V4[V2["stk"]]]V4[V2["stk"]]]
		V2["dlm"] = __nx_if(V3[V2["cr"]] == "\x7b", ":", ",")
		V2["ste"] = "NX_DEFAULT"
	} else if (V3[V2["cr"]] == V5[V5[V3[V2["cr"]]]]) {
		if (V2["ste"] == "NX_NONE") { # Never pushed to stack
			return 21
		} else if (! V2["stk"]) { # Empty Stack
			return 11
		} else { # Matching Bracket
			V2["cat"] = V5[V4[V2["stk"]]V5[V4[V2["stk"]]]]
			delete V4[V2["stk"]--]
			V2["ste"] = "NX_DELIMITER"
			V2["dlm"] = ","
		}
	} else { # Invalid Bracket Pair
		V2["err"] = __nx_if(V2["ste"] == "NX_NONE", 22, 12)
		V2["cat"] = "NX_ERR_BRACKET_MISMATCH"
		if (B)
			print nx_log_error(nx_json_log(V2, "Expected (" V5[V4[V2["stk"]]] ") but received (" V3[V2["cr"]] ")."))
		return V2["err"]
	}
	if (V4[V2["stk"]] == "\x7b")
		V2["idx"] = "NX_KEY"
	else if (V2["stk"])
		V2["idx"] = "NX_ITEM"
	else
		V2["idx"] = ""
	nx_json_apply(V1, V2, V4)
	if (B > 5)
		print nx_log_alert(nx_json_log_delim(V2, V3[V2["cr"]]))
}

function nx_json_default(V1, V2, V3, V4, V5, V6, B)
{
	if (nx_is_space(V3[V2["cr"]]))
		return 0
	if (V3[V2["cr"]] in V6) {
		V2["qte"] = V3[V2["cr"]]
		V2["ste"] = "NX_STRING"
	} else if (V3[V2["cr"]] in V5) {
		if (V2["err"] = nx_json_depth(V1, V2, V3, V4, V5, B))
			return V2["err"]
	} else if (nx_is_alpha(V3[V2["cr"]])) {
		V2["ste"] = "NX_IDENTIFIER"
		V2["rec"] = V3[V2["cr"]]
	} else if (nx_is_digit(V3[V2["cr"]]) || V3[V2["cr"]] ~ /[+]|[-]|[.]/) {
		V2["ste"] = "NX_NUMBER"
		nx_json_number(V1, V2, V3, V4, B)
	} else {
		V2["cat"] = "NX_ERR_UNEXPECTED_CHAR"
		if (B)
			print nx_log_error(nx_json_log(V2, "Encountered an unexpected character (" V3[V2["cr"]] ") that does not belong in JSON syntax."))
		return 61
	}
}

function nx_json_machine(V1, V2, V3, V4, V5, V6, B)
{
	for (V2["cr"] = 1; V2["cr"] <= V2["len"]; V2["cr"]++) {
		if (V2["ste"] == "NX_DEFAULT") {
			if (V2["err"] = nx_json_default(V1, V2, V3, V4, V5, V6, B))
				break
		} else if (V2["ste"] == "NX_NUMBER") {
			if (V2["err"] = nx_json_number(V1, V2, V3, V4, B))
				break
		} else if (V2["ste"] == "NX_FLOAT") {
			if (V2["err"] = nx_json_float(V1, V2, V3, V4, B))
				break
		} else if (V2["ste"] == "NX_DELIMITER") {
			if (V2["err"] = nx_json_delimiter(V1, V2, V3, V4, V5, B))
				break
		} else if (V2["ste"] == "NX_STRING") {
			if (V2["err"] = nx_json_string(V1, V2, V3, V4, V6, B))
				break
		} else if (V2["ste"] == "NX_IDENTIFIER") {
			if (V2["err"] = nx_json_identifier(V1, V2, V3, V4, B))
				break
		} else if (V2["ste"] == "NX_NONE") {
			if (nx_is_space(V3[V2["cr"]]))
				continue
			if (V2["err"] = nx_json_depth(V1, V2, V3, V4, V5, B))
				break
			if (V4[V2["stk"]] == "{") {
				V2["idx"] = "NX_KEY"
				V2["dlm"] = ":"
			} else {
				V2["idx"] = "NX_ITEM"
				V2["dlm"] = ","
			}
			V2["ste"] = "NX_DEFAULT"
		}
	}
	return V2["err"]
}

function nx_json(D, V, B,	tok, stk, rec, bm, qm)
{
	if (D == "")
		return 1
	tok["ste"] = "NX_NONE"
	tok["ln"] = 1
	__nx_bracket_map(bm, 2, 2)
	__nx_quote_map(qm, 2, 2)
	if (nx_is_file(D)) {
		tok["fl"] = D
		while ((getline tok["len"] < tok["fl"]) > 0) {
			tok["len"] = split(tok["len"], rec, "")
			if (nx_json_machine(V, tok, rec, stk, bm, qm, B))
				break
			++tok["ln"]
		}
		close(tok["fl"])
	} else {
		tok["fl"] = "-"
		tok["len"] = split(D, rec, "")
		nx_json_machine(V, tok, rec, stk, bm, qm, B)
	}
	if (tok["qte"] && ! tok["err"]) {
		tok["cat"] = "NX_ERR_MISSING_QUOTE"
		print nx_log_error(nx_json_log(tok, "A string quote (" tok["qte"] ") was opened but never closed."))
		tok["err"] = 2
	}
	if (stk[0] && ! tok["err"]) {
		tok["cat"] = "NX_ERR_BRACKET_MISMATCH"
		print nx_log_error(nx_json_log(tok, "Bracket mismatch detected. Expected closing '" stk[stk[0]] "' but found unexpected character."))
		tok["err"] = 3
	}
	D = tok["err"]
	delete qm; delete bm; delete dm
	delete tok; delete stk; delete rec
	for (i in V)
		print i "  =  " V[i]
	return D
}
