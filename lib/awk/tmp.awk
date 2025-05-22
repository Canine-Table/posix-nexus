


function nx_json_stack()
{
}

function nx_json_apply(V1, V2, V3)
{
	if (! ((V2["rec"] == "" || V2["dth"] == V2["stk"]) && "rt" in V2)) {
		if (V2["dth"] > V2["stk"]) {
			if (V2["cat"] == "NX_RBRACKET" && V3[V2["stk"]] == "\x5b") {
				sub(/[^\x5b]+$/, "", V2["rt"])
				sub(/\x5b$/, "", V2["rt"])
			} else {
				sub(/[^.]+$/, "", V2["rt"])
				sub(/[.]$/, "", V2["rt"])
			}
		} else {
			if (V3[V2["dth"]] == "\x5b") {
				V3[--V2["-stk"]] = V2["stk"]
				V3[V2["-stk"] "_rti"] = __nx_else(V2["rt"], ".")
				V1[V3[V2["-stk"] "_rti"] "\x5b0\x5d"] = 0
				V2["rt"] = ""
			} else if (V3[V2["dth"]] == "\x7b" && V2["nxt"] != "") {
				if (-(V2["stk"] - 1) in V3) {
					V2["rt"] = V2["nxt"] 
				V3[-(V2["stk"] - 1) "_rti"]
				}
				V2["rti"] "\x5b" ++V1[V2["rti"] "\x5b0\x5d"] "\x5d." V2["nxt"]
				} else {
					V2["rt"] = V2["rt"] "." V2["nxt"]
				}
			} else {
				if (V2["stk"] == "\x5b") {
					V3[--V2["-stk"]] = V2["stk"]
					V3[V2["-stk"] "_rti"] = ".nx"
					V2["rt"] = ""
				} else {
					V2["rt"] = ".nx"
				}
			}
		}
		V2["dth"] = V2["stk"]
	}
	if (V2["rec"] != "") {
		if (V3[V2["stk"]] == "\x5b") { # List
			# TODO List
		} else {
			if (V2["idx"] == "NX_KEY") {
				V2["nxt"] = V2["rec"]
			} else {
				# TODO value
			}
		}
		V2["rec"] = ""
	}
}


function nx_json_track_depth(V2, V3, V1) {
    if (V3[V2["dth"]] == "\x5b") {  
        V3[--V2["-stk"]] = V2["stk"]   # Track current depth level
        V3[V2["-stk"] "_rti"] = __nx_else(V2["rt"], ".") # Maintain reference tracking
        V1[V3[V2["-stk"] "_rti"] "\x5b0\x5d"] = 0  # Establish a base index for tracking elements
        V2["rt"] = ""  # Reset path tracker
    } else if (V3[V2["dth"]] == "\x7b" && V2["nxt"] != "") {
        if (-(V2["stk"] - 1) in V3) {
            V2["rt"] = V2["nxt"]  
            V3[-(V2["stk"] - 1) "_rti"]  # Reference previous stack index
        }
        V2["rti"] = V2["rti"] "\x5b" ++V1[V2["rti"] "\x5b0\x5d"] "\x5d." V2["nxt"]
    }
}


#function nx_json_apply(V1, V2, V3)
#{
#	# TODO work in progress
#	if (V3[V2["stk"]] == "\x5b") { # List
#		V1[__nx_else(V2["rt"], ".") "\x5b" ++V1[__nx_else(V2["rt"], ".") "\x5b0\x5d"] "\x5d"] = V2["rec"]
#	} else { # Object
#		if (V2["idx"] == "NX_KEY") {
#			V2["nxt"] = V2["rec"]
#			if (V3[V2["stk"] - 1] == "\x5b")
#				V2["rt"] = V2["rt"] "\x5b" V1[__nx_else(V2["prnt"], ".") "\x5b0\x5d"] "\x5d"
#		} else {
#			if (V2["rec"]) {
#				if (V2["nxt"])
#					V1[V2["rt"] "." V2["nxt"]] = V2["rec"]
#				else
#					V2["nxt"] = V2["rec"]
#			}
#		}
#	}
#	if (V2["dth"] != V2["stk"]) {
#		if (V2["dth"] < V2["stk"]) {
#			if (V2["nxt"] ~ /obj(a|b)/) {
#				print V2["rt"]
#				print V1[__nx_else(V2["prnt"], ".") "\x5b0\x5d"]
#				print V2["prnt"]
#				print V1[__nx_else(V2["rt"], ".") "\x5b0\x5d"]
#			}
#			V2["prnt"] = V2["rt"]
#			V2["rt"] = V2["rt"] "." V2["nxt"]
#			if (V2["nxt"] ~ /obj(a|b)/) {
#				print V2["rt"]
#				print V3[V2["dth"]]
#				print V3[V2["stk"]]
#			}
#		} else {
#			sub(/[^.]+$/, "", V2["rt"])
#			sub(/[.]$/, "", V2["rt"])
#		}
#		V2["dth"] = V2["stk"]
#	}





function nx_json_apply(V1, V2, V3)
{
	if (! (V2["rec"] == "" || V2["dth"] == V2["stk"])) {
		if (V2["dth"] > V2["stk"]) {
			if (V2["cat"] == "NX_RBRACKET" && V3[V2["stk"]] == "\x5b") {
				sub(/[^\x5b]+$/, "", V2["rt"])
				sub(/\x5b$/, "", V2["rt"])
			} else {
				sub(/[^.]+$/, "", V2["rt"])
				sub(/[.]$/, "", V2["rt"])
			}
		} else {
			if (V3[V2["dth"]] == "\x5b") {
				V2["rti"] = __nx_else(V2["rt"], ".")
				V2["rt"] = ""
				V2["rtl"] = nx_join_str(V2["rtl"], V2["stk"], ":")
			} else if (V2["nxt"]) {
				V2["rt"] = V2["rt"] "." V2["nxt"]
			}
		}
		V2["dth"] = V2["stk"]
	}
	if (V2["rec"] != "") {
		if (V3[V2["stk"]] == "\x5b") { # List
			if (V2["rtl"] ~ ":" V2["stk"] ":") {
				V1[V2["rti"] "\x5b" V1[V2["rti"] "\x5b0\x5d"] "\x5d" __nx_else(V2["rt"], ".") "\x5b" ++V1[V2["rt"] "\x5b0\x5d"] "\x5d"] = V2["rec"]
			} else {
				V1[__nx_else(V2["rt"], ".") "\x5b" ++V1[V2["rt"] "\x5b0\x5d"] "\x5d"] = V2["rec"]
			}
		} else {
			if (V2["idx"] == "NX_KEY") {
				V2["nxt"] = V2["rec"]
			} else {
				if (V2["rtl"] ~ ":" V2["stk"] - 1 ":") {
					V1[V2["rti"] "\x5b" ++V1[V2["rti"] "\x5b0\x5d"] "\x5d" V2["rt"] "." V2["nxt"]] = V2["rec"]
				} else {
					V1[V2["rt"] "." V2["nxt"]] = V2["rec"]
				}
			}
		}
		V2["rec"] = ""
	}
}


function nx_json_log(V, D)
{
	return "(\n\tFile: '" V["fl"] "'\n\tLine: '" V["ln"] "'\n\tCharacter: '" V["cr"] "'\n\tToken: '" V["rec"] "'\n\tDepth: '" V["stk"] "'\n\tCategory: '" V["cat"] "'\n\tWithin: '" V["ste"] "'\n\tIndex: '" V["idx"] "'\n): '" D "'"
}

function nx_json_error(V, D, B)
{
	print nx_log_error(nx_json_log(V, D), B)
}

function nx_json_success(V, D, B)
{
	print nx_log_success(nx_json_log(V, D), B)
}

function nx_json_warn(V, D, B)
{
	print nx_log_warn(nx_json_log(V, D), B)
}

function nx_json_info(V, D, B)
{
	print nx_log_info(nx_json_log(V, D), B)
}

function nx_json_debug(V, D, B)
{
	print nx_log_debug(nx_json_log(V, D), B)
}

function nx_json_alert(V, D, B)
{
	print nx_log_alert(nx_json_log(V, D), B)
}

function nx_json_black(V, D, B)
{
	print nx_log_black(nx_json_log(V, D), B)
}

function nx_json_light(V, D, B)
{
	print nx_log_light(nx_json_log(V, D), B)
}

function nx_json_apply(V1, V2, V3)
{
	if (V3[V3[0]] == "\x5b") { # List
	} else { # Object
	}
	print V2["rec"]
	V2["rec"] = ""
}

function nx_json_float(V1, V2, V3, V4, B)
{
	if (nx_is_digit(V3[V2["cr"]])) { # If current character is a digit
		V2["rec"] = V2["rec"] V3[V2["cr"]] # Append to recorded number
	} else {
		if (V2["rec"] ~ /[.]$/) # If last recorded value is a decimal point
			V2["rec"] = V2["rec"] 0 # Append a zero for valid float representation
		if (B > 6) # Debugging
			nx_json_debug(V2, V2["rec"])
		nx_json_apply(V1, V2, V4) # Apply the parsed value
		V1["ste"] = "NX_DELIMITER" # Move to delimiter state
		if (! nx_is_space(V3[V2["cr"]])) # If next character is not a space
			V2["cr"]-- # Step back to reevaluate
	}
}

function nx_json_number(V1, V2, V3, V4, B)
{
	if (V3[V2["cr"]] == ".") { # If the current character is a decimal point
		if (! V2["rec"]) # If we haven't recorded anything yet
			V2["rec"] = 0 # Start with zero
		V2["rec"] = V2["rec"] V3[V2["cr"]] # Append decimal point
		V1["ste"] = "NX_FLOAT" # Switch state to handle floating point numbers
	} else { # Otherwise, delegate to float handling
		nx_json_float(V1, V2, V3, V4, B)
	}
}

function nx_json_delimiter(V1, V2, V3, V4, V5, B)
{
	if (V3[V2["cr"]] ~ /[\[\{]/ || (V3[V2["cr"]] == "}" && V2["idx"] == "NX_KEY") || (V3[V2["cr"]] == "]" && V2["idx"] == "NX_ITEM")) {
		if (V2["err"] = nx_json_depth(V1, V2, V3, V4, V5, B))
			return V2["err"]
	} else if (V3[V2["cr"]] != V2["dlm"]) {
		V2["ste"] = "NX_ERR_UNEXPECTED_DELIM"
		if (B)
			nx_json_error(V2, "Unexpected delimiter found " V3[V2["cr"]] ".")
		return 51
	} else if (V4[V2["stk"]] == "[" || V2["dlm"] == ":") {
		V2["dlm"] = ","
		V2["idx"] = __nx_if(V4[V2["stk"]] == "{", "NX_KEY", "NX_ITEM")
	} else {
		V2["dlm"] = ":"
		V2["idx"] = "NX_VALUE"
	}
	V2["ste"] = "NX_DEFAULT" # Set state back to default
}

function nx_json_string(V1, V2, V3, V4, V5, B)
{
	if (V3[V2["cr"]] != V2["qte"]) {
		if (V2["qte"] == "\x27" || V3[V2["cr"]] != "\x5c" || ++V2["esc"] % 2 == 0) {
			V2["rec"] = V2["rec"] V3[V2["cr"]]
			V2["esc"] = 0
		}
	} else {
		if (V2["qte"] in V5 && V2["qte"] == V3[V2["cr"]]) {
			V2["ste"] = V5[V2["qte"]V2["qte"]]
		} else {
			V2["cat"] =  "NX_ERR_MISSING_QUOTE"
			nx_json_error(V2, "A string quote (" V2["qte"] ") was opened but never closed.")
			return 31
		}
		V2["qte"] = ""
		if (B > 6)
			nx_json_debug(V2, V1["rec"])
		nx_json_apply(V1, V2, V4)
		V2["ste"] = "NX_DELIMITER"
	}
}

function nx_json_identifier(V1, V2, V3, B,	t)
{
	if (nx_is_alpha(V3[V2["cr"]])) {
		V2["rec"] = V1["rec"] V3[V2["cr"]]
	} else {
		t = tolower(V2["rec"])
		if (t ~ /^(true|false)$/) {
			V2["cat"] = "NX_BOOLEAN"
		} else if (t ~ /^(nil|null|none|undefined)$/) {
			V2["cat"] = "NX_UNDEFINED"
		} else {
			V2["cat"] = "NX_ERR_INVALID_IDENTIFIER"
			if (B)
				nx_json_error(V2, "Found an invalid identifier " V2["rec"] ".")
			return 41
		}
		if (B > 6)
			nx_json_debug(V1, V1["rec"])
		nx_json_apply(V1, V2, V4)
		V1["ste"] = "NX_DELIMITER"
		if (! nx_is_space(V3[V2["cr"]]))
			V2["cr"]--
	}
}

function nx_json_depth(V1, V2, V3, V4, V5, B)
{
	if (V3[V2["cr"]] ~ /[\x5b|\x7b]/) {
		nx_json_apply(V1, V2, V4)
		V4[++V2["stk"]] = V3[V2["cr"]]
		V2["ste"] = "NX_DEFAULT"
	} else if (V3[V2["cr"]] == V5[V5[V3[V2["cr"]]]]) {
		if (V2["ste"] == "NX_NONE") { # Never pushed to stack
			return 21
		} else if (! V4[0]) { # Empty Stack
			return 11
		} else { # Matching Bracket
			delete V4[V2["stk"]--]
			V2["ste"] = "NX_DELIMITER"
			V2["dlm"] = ","
		}
	} else { # Invalid Bracket Pair
		V2["err"] = __nx_if(V2["ste"] == "NX_NONE", 22, 11)
		V1["cat"] = "NX_ERR_BRACKET_MISMATCH"
		if (B)
			nx_json_error(V2, "Expected (" V5[V4[V2["stk"]]] ") but received (" V3[V2["cr"]] ").")
		return V2["err"]
	}
}

function nx_json_default(V1, V2, V3, V4, V5, V6, B)
{
	if (nx_is_space(V3[V2["cr"]]))
		return 0
	if (V3[V2["cr"]] in V6) {
		V2["qte"] = V3[V2["cr"]]
		V2["ste"] = "NX_STRING"
		V3[V2["cr"]] = ""
	} else if (V3[V2["cr"]] in V5) {
		if (tok["err"] = nx_json_depth(V1, V2, V3, V4, V5, B))
			return tok["err"]
	} else if (nx_is_alpha(V3[V2["cr"]])) {
		V2["ste"] = "NX_IDENTIFIER"
		V2["rec"] = V3[V2["cr"]]
	} else if (nx_is_digit(V3[V2["cr"]]) || V3[V2["cr"]] ~ /[+]|[-]|[.]/) {
		V2["ste"] = "NX_NUMBER"
		nx_json_number(V1, V2)
	} else {
		tok["ste"] = "NX_ERR_UNEXPECTED_CHAR"
		nx_json_error(V2, "Encountered an unexpected character (" V3[V2["cr"]] ") that does not belong in JSON syntax.")
		return 61
	}
	if (V3[V2["cr"]] != "") {
		V2["esc"] = 0
		V2["qte"] = ""
	}
}

function nx_json_machine(V1, V2, V3, V4, V5, V6, B)
{
	for (V2["cr"] = 1
		if (V2["ste"] == "NX_DEFAULT") {
			if (V2["err"] = nx_json_default(V1, V2, V3, V4, V5, V6, V7))
				break
		} else if (V2["ste"] == "NX_NUMBER") {
			if (V2["err"] = nx_json_number(V1, V2))
				break
		} else if (V2["ste"] == "NX_FLOAT") {
			if (V2["err"] = nx_json_float(V1, V2))
				break
		} else if (V2["ste"] == "NX_DELIMITER") {
			if (V2["err"] = nx_json_delimiter(V1, V2))
				break
		} else if (V2["ste"] == "NX_STRING") {
			if (V2["err"] = nx_json_string(V1, V2))
				break
		} else if (V2["ste"] == "NX_IDENTIFIER") {
			if (V2["err"] = nx_json_identifier(V1, V2))
				break
		} else if (V2["ste"] == "NX_NONE") {
			if (nx_is_space(V3[V2["cr"]]))
				continue
			if (V2["err"] = nx_json_depth(V1, V2, V3, V4, V5, B))
				break
		}
	}
	return V2["err"]
}

function nx_json(D, V, B, tok, stk, rec, bm, qm)
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
		tok["ste"] = "NX_ERR_MISSING_QUOTE"
		nx_json_error(tok, stk, "A string quote (" tok["qte"] ") was opened but never closed.")
		tok["err"] = 2
	}
	if (stk[0] && ! tok["err"]) {
		tok["ste"] = "NX_ERR_BRACKET_MISMATCH"
		nx_json_error(tok, stk, "Bracket mismatch detected. Expected closing '" stk[stk[0]] "' but found unexpected character.")
		tok["err"] = 3
	}
	D = tok["err"]
	delete qm
	delete tok
	return D
}



































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
		for (tok["char"] = 1
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
		for (tok["char"] = 1
			print V[tok["char"]] " = " V[tok["char"] "_" V[tok["char"]]]
	}
	delete tok
	return D
}


































function nx_tui_escaped(V1, V2, V3)
{
	if (V1[V1["cr"]] == "\x09") { # Tab
		V2["ta"] = __nx_else(V1["rcnt"] % V1["tsz"], V1["tsz"])
		if ((V2["tb"] = V2["ta"] + V1["rcnt"]) >= V1["col"]) {
			if (V2["tc"] = V2["tb"] % V1["col"]) {
				V3[++V3[0]] = nx_append_str(" ", V2["ta"] - V2["tc"], V1["rec"], 0)
				V1["rec"] = nx_append_str(" ", V2["tc"])
			} else {
				V3[++V3[0]] = nx_append_str(" ", V2["ta"], V1["rec"], 0)
			}
			V3[V3[0] "_ln" ] = "~"
			V3[V3[0] "_pg"] = "~"
			V1["rcnt"] = 0
		} else {
			V1["rcnt"] = V["rcnt"] + V2["ta"]
			V1["rec"] = nx_append_str(" ", V2["ta"], V1["rec"], 0)
		}
	} else if (V1[V1["cr"]] == "\x0b") { # Vertical Tab
		V3[++V3[0]] = nx_append_str(" ", V1["rcnt"] % V1["col"], V1["rec"], 0)
		V1["rec"] = nx_append_str(" ", V1["rcnt"])
		V3[V3[0] "_ln" ] = "~"
		V3[V3[0] "_pg"] = "~"
	} else if (V1[V1["cr"]] == "\x0d") { # Carriage Return
		if (V1["len"] > V1["cr"] && V1[V1["char"] + 1] != "\n") {
			V1["ste"] = "NX_RETURN"
			V1["rcnt"] = 0
		}
	} else if (V1[V1["cr"]] == "\x08") { # Backspace
		if (V1["rcnt"]) {
			V1["rec"] = substr(V1["rec"], 1, --V1["rcnt"])
		} else if (V3[0]) {
			V1["rcnt"] = length(V3[V3[0]]) - 1
			V1["rec"] = substr(V3[V3[0]], 1, V1["rcnt"])
			delete V3[V3[0] "_ln"]
			delete V3[V3[0] "_pg"]
			delete V3[V3[0]--]
		}
	} else if (V1[V1["cr"]] ~ /[\x0a|\x0c]/) { # Newline or Formfeed
		V3[++V3[0]] = nx_append_str(" ", V1["rcnt"] % V1["col"], V1["rec"], 0)
		if (V1[V1["cr"]] == "\x0a") {
			V1["ll"] = V3[0]
			V3[V3[0] "_line"] = V1["ln"]++
			V3[V3[0] "_page"] = V1["pg"]
		} else {
			V1["lf"] = V3[0]
			V3[V3[0] "_ln"] = V1["ln"]
			V3[V3[0] "_pg"] = V1["pg"]++
		}
		V1["rec"] = ""
		V1["rcnt"] = 0
	} else if (V1[V1["cr"]] == "\x1b") { # Escape
		V1["ste"] = "NX_CODE"
	}
	if (V1["ste"] != "NX_CODE")
		V1["tcnt"] = 0
	if (V1["ste"] == "NX_ESCAPE")
		V1["ste"] = "NX_DEFAULT"
}


function nx_tui_escape(V1, V2, V3)
{
	if (V1[V1["char"]] == "\t") {
		V2["ta"] = __nx_else(nx_remainder(V1["lcount"], 8), 8)
		if ((V2["tb"] = V2["ta"] + V1["lcount"]) > V1["col"]) {
			V2["tc"] = V2["tb"] % V1["col"]
			V3[++V3[0]] = nx_append_str(" ", V2["ta"] - V2["tc"], V1["token"], 0)
			V3[V3[0] "_line" ] = V1["line"]
			V3[V3[0] "_page"] = V1["page"]
			V1["token"] = nx_append_str(" ", V2["tc"])
			V1["lcount"] = 0
		} else {
			V1["lcount"] = V["lcount"] + V2["ta"]
			V1["token"] = nx_append_str(" ", V2["ta"], V1["token"], 0)
		}
	} else if (V1[V1["char"]] == "\v") {
		V3[++V3[0]] = nx_append_str(" ", nx_remainder(V1["lcount"], V1["col"]), V1["token"], 0)
		V3[V3[0] "_line" ] = V1["line"]
		V3[V3[0] "_page"] = V1["page"]
		V1["token"] = nx_append_str(" ", V1["lcount"])
	} else if (V1[V1["char"]] ~ /[\n\f]/) {
		V3[++V3[0]] = nx_append_str(" ", nx_remainder(V1["lcount"], V1["col"]), V1["token"], 0)
		if (V1[V1["char"]] == "\n") {
			V3[V3[0] "_line"] = V1["line"]++
			V3[V3[0] "_page"] = V1["page"]
		} else {
			V3[V3[0] "_line"] = V1["line"]
			V3[V3[0] "_page"] = V1["page"]++
		}
		V1["token"] = ""
		V1["lcount"] = 0
	} else if (V1[V1["char"]] == "\r") {
		if (V1[V1["char"] + 1] != "\n") {
			V1["state"] = "NX_ESCAPE_RETURN"
			V1["rcount"] = 0
		}
	} else if (V1[V1["char"]] == "\b") {
		if (V2["ta"] = length(V1["token"])) {
			V1["token"] = substr(V1["token"], 1, V2["ta"] - 1)
			V1["lcount"]--
		} else if (V3[0]) {
			V1["token"] = substr(V3[V3[0]], 1, length(V3[V3[0]]) - 1)
			delete V3[V3[0] "_line"]
			delete V3[V3[0] "_page"]
			delete V3[V3[0]--]
		}
	}
	V1["tcount"] = 0
	if (V1["state"] == "NX_ESCAPE")
		V1["state"] = "NX_DEFAULT"
}



	#if (V["sstate"] == "") {
		#if (V[V["char"]] == "e") {
		#	V["sstate"] = "NX_TTY_ESCAPE"
		#} else 
		}# else if (V[V["char"]] == "t") {
		#} else if (V[V["char"]] == "v") {
		#} else if (V[V["char"]] == "r") {
		#} else if (V[V["char"]] == "n") {
		#} else if (V[V["char"]] == "f") {
		#} else if (V[V["char"]] == "0") {
		#} else if (V[V["char"]] ~ /[xX]/) {
		#}


function nx_tui_return(V1, V2, V3)
{

}


function nx_tui_escape(V1, V2, V3)
{
	if (V1[V1["char"]] == "\t") {
		V2["ta"] = __nx_else(nx_remainder(V1["lcount"], 8), 8)
		if ((V2["tb"] = V2["ta"] + V1["lcount"]) > V1["col"]) {
			V2["tc"] = V2["tb"] % V1["col"]
			V3[++V3[0]] = nx_append_str(" ", V2["ta"] - V2["tc"], V1["token"], 0)
			V3[V3[0] "_line" ] = V1["line"]
			V3[V3[0] "_page"] = V1["page"]
			V1["token"] = nx_append_str(" ", V2["tc"])
			V1["lcount"] = 0
		} else {
			V1["lcount"] = V["lcount"] + V2["ta"]
			V1["token"] = nx_append_str(" ", V2["ta"], V1["token"], 0)
		}
	} else if (V1[V1["char"]] == "\v") {
		V3[++V3[0]] = nx_append_str(" ", nx_remainder(V1["lcount"], V1["col"]), V1["token"], 0)
		V3[V3[0] "_line" ] = V1["line"]
		V3[V3[0] "_page"] = V1["page"]
		V1["token"] = nx_append_str(" ", V1["lcount"])
	} else if (V1[V1["char"]] ~ /[\n\f]/) {
		V3[++V3[0]] = nx_append_str(" ", nx_remainder(V1["lcount"], V1["col"]), V1["token"], 0)
		if (V1[V1["char"]] == "\n") {
			V3[V3[0] "_line"] = V1["line"]++
			V3[V3[0] "_page"] = V1["page"]
		} else {
			V3[V3[0] "_line"] = V1["line"]
			V3[V3[0] "_page"] = V1["page"]++
		}
		V1["token"] = ""
		V1["lcount"] = 0
	} else if (V1[V1["char"]] == "\r") {
		if (V1[V1["char"] + 1] != "\n") {
			V1["state"] = "NX_ESCAPE_RETURN"
			V1["rcount"] = 0
		}
	} else if (V1[V1["char"]] == "\b") {
		if (V2["ta"] = length(V1["token"])) {
			V1["token"] = substr(V1["token"], 1, V2["ta"] - 1)
			V1["lcount"]--
		} else if (V3[0]) {
			V1["token"] = substr(V3[V3[0]], 1, length(V3[V3[0]]) - 1)
			delete V3[V3[0] "_line"]
			delete V3[V3[0] "_page"]
			delete V3[V3[0]--]
		}
	}
	V1["tcount"] = 0
	if (V1["state"] == "NX_ESCAPE")
		V1["state"] = "NX_DEFAULT"
}


function nx_tui(B1, D2, V,	tok, scrt)
{
	D1 = split(D1, tok, "")
}



function nx_tui_fold(V1, V2, V3)
{

				} else if (tok["fcnt"] < tok["col"]) {
					# is it a really long unbroken word?
				} else {
					# it is an unbroken long word
				}
}

function nx_tui(D1, D2, V,	tok, scrt)
{
	D1 = split(D1, tok, "")
	tok["row"] = ENVIRON["G_NEX_TTY_ROWS"]
	tok["tsz"] = __nx_else(int(ENVIRON["G_NEX_TTY_TABS"]), 8)
	tok["len"] = D1
	tok["ln"] = 1
	tok["pg"] = 1
	for (tok["cr"] = 1
		if (tok["ste"] == "NX_DEFAULT") {
			if (tok[tok["cr"]] ~ /[\x09\x0b\x0d\x08\x0a\x0c\x1b]/) {
				nx_tui_escape(tok, scrt, V)
			} else {
				if (tok[tok["cr"]] == "\x20")
					tok["fcnt"] = 0
				if (++tok["rcnt"] < tok["col"]) {
					tok["rec"] = tok["rec"] tok[tok["cr"]]
				} else {
					nx_tui_fold(tok, scrt, V)
				}
			}
		} else if (tok["state"] == "NX_RETURN") {
			nx_tui_return(tok, scrt, V)
		} else if (tok["state"] == "NX_CODE") {
			nx_tui_terminal(tok, scrt, V)
		}
	}
	if (tok["rec"] != "") {
		V[++V[0]] = tok["rec"]
		V[V[0] "_ln" ] = "~"
		V[V[0] "_pg"] = "~"
	}
	delete tok
	delete scrt
}


function nx_tui_escape(V1, V2, V3)
{
	if (V1[V1["cr"]] == "\x09") { # Tab
		V2["ta"] = __nx_else(V1["rcnt"] % V1["tsz"], V1["tsz"])
		if ((V2["tb"] = V2["ta"] + V1["rcnt"]) >= V1["col"]) {
			if (V2["tc"] = V2["tb"] % V1["col"]) {
				V3[++V3[0]] = nx_append_str(" ", V2["ta"] - V2["tc"], V1["rec"], 0)
				V1["rec"] = nx_append_str(" ", V2["tc"])
			} else {
				V3[++V3[0]] = nx_append_str(" ", V2["ta"], V1["rec"], 0)
				V1["rec"] = ""
			}
			V3[V3[0] "_ln" ] = "~"
			V3[V3[0] "_pg"] = "~"
		} else {
			V1["rcnt"] = V["rcnt"] + V2["ta"]
			V1["rec"] = nx_append_str(" ", V2["ta"], V1["rec"], 0)
		}
		V1["rcnt"] = length(V1["rec"])
	} else if (V1[V1["cr"]] == "\x0b") { # Vertical Tab
		V3[++V3[0]] = nx_append_str(" ", V1["col"] - V1["rcnt"], V1["rec"], 0)
		V1["rec"] = nx_append_str(" ", --V1["rcnt"])
		V3[V3[0] "_ln" ] = "~"
		V3[V3[0] "_pg"] = "~"
	} else if (V1[V1["cr"]] == "\x0d") { # Carriage Return
		if (V1["len"] > V1["cr"] && V1[V1["char"] + 1] != "\n") {
			V1["ste"] = "NX_RETURN"
			V1["rcnt"] = 0
		}
	} else if (V1[V1["cr"]] == "\x08") { # Backspace
		if (V1["rcnt"]) {
			V1["rec"] = substr(V1["rec"], 1, --V1["rcnt"])
		} else if (V3[0]) {
			V1["rcnt"] = length(V3[V3[0]]) - 1
			V1["rec"] = substr(V3[V3[0]], 1, V1["rcnt"])
			delete V3[V3[0] "_ln"]
			delete V3[V3[0] "_pg"]
			delete V3[V3[0]--]
		}
	} else if (V1[V1["cr"]] ~ /[\x0a|\x0c]/) { # Newline or Formfeed
		V3[++V3[0]] = nx_append_str(" ", V1["col"] - V1["rcnt"], V1["rec"], 0)
		if (V1[V1["cr"]] == "\x0a") {
			V1["ll"] = V3[0]
			V3[V3[0] "_line"] = V1["ln"]++
			V3[V3[0] "_page"] = V1["pg"]
		} else {
			V1["lf"] = V3[0]
			V3[V3[0] "_ln"] = V1["ln"]
			V3[V3[0] "_pg"] = V1["pg"]++
		}
		V1["rec"] = ""
		V1["rcnt"] = 0
	} else if (V1[V1["cr"]] == "\x1b") { # Escape
		V1["ste"] = "NX_CODE"
	}
	V1["pd"] = 0
	if (V1["ste"] != "NX_CODE")
		V1["fcnt"] = 0
}


function nx_tui_fold(V1, V2, V3)
{
	# Check if there is space left in the column width
	if (V1["fcnt"] < V1["col"]) {
		# Calculate how much text remains to fit in the current line
		V2["ta"] = V1["rcnt"] - V1["fcnt"]
		# Determine padding needed for alignment
		V1["pd"] = V1["col"] - V2["ta"] + 1
		# Store the formatted line in V3 with appropriate padding
		V3[++V3[0]] = nx_append_str(" ", V1["pd"], substr(V1["rec"], 1, V2["ta"] - 1), 0)
		# Update the record string and counters
		V1["rec"] = substr(V1["rec"], V2["ta"] + 1)
		V1["rcnt"] = V1["fcnt"]
	} else {
		# Handle cases where padding is required
		if (V1["pd"]) {
			# Append leftover text to the previous entry
			V3[V3[0]] = substr(V3[V3[0]], 1, V1["col"] - V1["pd"] + 1) substr(V1["rec"], 1, V1["pd"] - 1)
			# Update remaining record text
			V1["rec"] = substr(V1["rec"], V1["pd"])
			V1["rcnt"] = length(V1["rec"])
			V1["pd"] = 0
		} else {
			# Store entire record as a separate entry if no padding is needed
			V3[++V3[0]] = V1["rec"]
			V1["rec"] = ""
			V1["rcnt"] = 0
		}
		# Update final character count for the current line
		V1["fcnt"] = V1["rcnt"]
	}
	# Add page and line markers for tracking purposes
	V3[V3[0] "_ln"] = "~"
	V3[V3[0] "_pg"] = "~"
}


function nx_tui_fold(V1, V2, V3)
{
	if (V1["fcnt"] < V1["col"]) {
		V2["ta"] = V1["rcnt"] - V1["fcnt"]
		V1["pd"] = V1["col"] - V2["ta"] + 1
		V3[++V3[0]] = nx_append_str(" ", V1["pd"], substr(V1["rec"], 1, V2["ta"] - 1), 0)
		V1["rec"] = substr(V1["rec"], V2["ta"] + 1)
		V1["rcnt"] = V1["fcnt"]
	} else {
		if (V1["pd"]) {
			V3[V3[0]] = substr(V3[V3[0]], 1, V1["col"] - V1["pd"] + 1) substr(V1["rec"], 1, V1["pd"] - 1)
			V1["rec"] = substr(V1["rec"], V1["pd"])
			V1["rcnt"] = length(V1["rec"])
			V1["pd"] = 0
		} else {
			V3[++V3[0]] = V1["rec"]
			V1["rec"] = ""
			V1["rcnt"] = 0
		}
		V1["fcnt"] = V1["rcnt"]
	}
	V3[V3[0] "_ln"] = "~"
	V3[V3[0] "_pg"] = "~"
}


function nx_tui_fold(V1, V2, V3)
{
	# Check if there is space left in the column width
	if (V1["fcnt"] < V1["col"]) {
		# Calculate how much text remains to fit in the current line
		V2["ta"] = V1["rcnt"] - V1["fcnt"]
		# Determine padding needed for alignment
		V1["pd"] = V1["col"] - V2["ta"] + 1
		# Store the formatted line in V3 with appropriate padding
		V3[++V3[0]] = nx_append_str(" ", V1["pd"], substr(V1["rec"], 1, V2["ta"] - 1), 0)
		# Update the record string and counters
		V1["rec"] = substr(V1["rec"], V2["ta"] + 1)
		V1["rcnt"] = V1["fcnt"]
	} else {
		# Handle cases where padding is required
		if (V1["pd"]) {
			# Append leftover text to the previous entry
			V3[V3[0]] = substr(V3[V3[0]], 1, V1["col"] - V1["pd"] + 1) substr(V1["rec"], 1, V1["pd"] - 1)
			# Update remaining record text
			V1["rec"] = substr(V1["rec"], V1["pd"])
			V1["rcnt"] = length(V1["rec"])
			V1["pd"] = 0
		} else {
			# Store entire record as a separate entry if no padding is needed
			V3[++V3[0]] = V1["rec"]
			V1["rec"] = ""
			V1["rcnt"] = 0
		}
		# Update final character count for the current line
		V1["fcnt"] = V1["rcnt"]
	}
	# Add page and line markers for tracking purposes
	V3[V3[0] "_ln"] = "~"
	V3[V3[0] "_pg"] = "~"
}


function nx_tui_prop(V1, V2, D)
{
	V1["pdr"] = 0
	V1["pdl"] = 0
	V1["mgr"] = 0
	V1["mgl"] = 0
	V1["row"] = ENVIRON["G_NEX_TTY_ROWS"]
	V1["col"] = ENVIRON["G_NEX_TTY_COLUMNS"]
	V1["tsz"] = __nx_else(int(ENVIRON["G_NEX_TTY_TABS"]), 8)  # Tab size defaults to 8.
	if (int(ENVIRON["G_NEX_TTY_PADDING"]) != 0) {
		V1["pdl"] = ENVIRON["G_NEX_TTY_PADDING"]
		V1["pdr"] = ENVIRON["G_NEX_TTY_PADDING"]
	} else {
		if (int(ENVIRON["G_NEX_TTY_PAD_LEFT"]) != 0)
			V1["pdl"] = ENVIRON["G_NEX_TTY_PAD_LEFT"]
		if (int(ENVIRON["G_NEX_TTY_PAD_RIGHT"]) != 0)
			V1["pdr"] = ENVIRON["G_NEX_TTY_PAD_RIGHT"]
	}
	if (int(ENVIRON["G_NEX_TTY_MARGINS"]) != 0) {
		V1["mgr"] =  ENVIRON["G_NEX_TTY_MARGINS"]
		V1["mgl"] = ENVIRON["G_NEX_TTY_MARGINS"]
	} else {
		if (int(ENVIRON["G_NEX_TTY_MARGIN_LEFT"]) != 0)
			V1["mgl"] =  ENVIRON["G_NEX_TTY_LEFT"]
		if (int(ENVIRON["G_NEX_TTY_MARGIN_RIGHT"]) != 0)
			V1["mgr"] =  ENVIRON["G_NEX_TTY_RIGHT"]
	}
	V1["col"] = V1["col"] - (V1["pdr"] + V1["pdl"] + V1["mgr"] + V1["mgl"])
	if (tolower(D) ~ /[sd]/) {
		__nx_box_map(V1, D)
		V1["col"] = V1["col"] - 2
		V2["hl"] = nx_append_str(V1["hl"], V1["col"] + V1["pdr"] + V1["pdl"])
		V1["pdr"] = nx_append_str(" ", V1["pdr"])
		V1["pdl"] = nx_append_str(" ", V1["pdl"])
		V1["mgr"] = nx_append_str(" ", V1["mgr"])
		V1["mgl"] = nx_append_str(" ", V1["mgl"])
		V2["lvl"] = "\x1b[0m" V1["pdl"] V1["vl"] V1["mgl"]
		V2["lvr"] = "\x1b[0m" V1["mgr"] V1["vl"] V1["pdr"]
		V2["tbdr"] = "\x1b[0m" V1["pdl"] V1["ulc"] V2["hl"] V1["urc"] V1["pdr"]
		V2["mbdr"] = "\x1b[0m" V1["pdl"] V1["vrl"] V2["hl"] V1["vll"] V1["pdr"]
		V2["dbdr"] = "\x1b[0m" V1["pdl"] V1["vl"] V2["hl"] V1["vl"] V1["pdr"]
		V2["bbdr"] = "\x1b[0m" V1["pdl"] V1["llc"] V2["hl"] V1["lrc"] V1["pdr"]
	}
}

