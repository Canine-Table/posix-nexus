function nx_json_log(V, D)
{
	return "(\n\tFile: '" V["fl"] "'\n\tLine: '" V["ln"] "'\n\tCharacter: '" V["cr"] "'\n\tToken: '" V["rec"] "'\n\tDepth: '" V["stk"] "'\n\tCategory: '" V["cat"] "'\n\tWithin: '" V["ste"] "'\n\tIndex: '" V["idx"] "'\n): '" D "'"
}

function nx_json_apply(V1, V2, V3)
{
	if (V3[V3[0]] == "\x5b") { # List
	} else { # Object
	}
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
	for (V2["cr"] = 1; V2["cr"] <= V2["len"]; V2["cr"]++) {
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
	delete qm; delete bm, delete dm
	delete tok; delete stk, delete rec
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
	tok["row"] = ENVIRON["G_NEX_TTY_ROWS"]; tok["col"] = ENVIRON["G_NEX_TTY_COLUMNS"]
	tok["tsz"] = __nx_else(int(ENVIRON["G_NEX_TTY_TABS"]), 8)
	tok["len"] = D1; tok["ste"] = "NX_DEFAULT"
	tok["ln"] = 1; tok["ll"] = 1
	tok["pg"] = 1; tok["lf"] = 1
	for (tok["cr"] = 1; tok["cr"] <= tok["len"]; tok["cr"]++) {
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

