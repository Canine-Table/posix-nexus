function nx_json_log(V, D)
{
	return "(\n\tFile: '" V["fl"] "'\n\tLine: '" V["ln"] "'\n\tCharacter: '" V["cr"] "'\n\tToken: '" V["rec"] "'\n\tDepth: '" V["stk"] "'\n\tCategory: '" V["cat"] "'\n\tWithin: '" V["ste"] "'\n\tIndex: '" V["idx"] "'\n): '" D "'"
}

function nx_json_log_delim(V, D)
{
	return "(\n\tFile: '" V["fl"] "'\n\tLine: '" V["ln"] "'\n\tCharacter: '" V["cr"] "'\n\tDepth: '" V["stk"] "'\n\tCategory: '" V["cat"] "'\n\tWithin: '" V["ste"] "'\n): '" D "'"
}

function nx_json_log_db(V, N, D, B)
{
	if (length(V)) {
		return nx_log_db(N, D, B, V)
	} else {
		# Empty input (1)
		nx_grid_stack(V, "Attempted to parse the void. Unfortunately, JSON is not a philosopher—it requires actual data.", 1)
		nx_grid_stack(V, "No JSON data received. Either the universe deleted your input or someone forgot to provide a valid string.", 1)
		nx_grid_stack(V, "JSON parser detected an empty input. Likelihood of spontaneous data existence: <1%.", 1)

		# Quote error (2)
		nx_grid_stack(V, "A string quote (<nx:placeholder/>) was opened but never closed. It seems to have escaped—should we report it missing?", 2)
		nx_grid_stack(V, "You opened a quote (<nx:placeholder/>), but forgot to close it. If this was intentional, congratulations—you've invented quantum uncertainty in JSON.", 2)
		nx_grid_stack(V, "A quote (<nx:placeholder/>) has entered the parsing realm but failed to find an exit. It may be trapped forever—unless you rescue it.", 2)
		nx_grid_stack(V, "Unterminated string detected. The quote (<nx:placeholder/>) began its journey, but closure eludes it. Such is the fate of forgotten syntax.", 2)
		nx_grid_stack(V, "A quote (<nx:placeholder/>) was opened but never closed. JSON requires balance—please provide the missing pair.", 2)
		nx_grid_stack(V, "Expected a closing quote to match (<nx:placeholder/>), but found nothing. JSON objects prefer symmetry!", 2)

		# Bracket Missmatch error (3)
		nx_grid_stack(V, "Bracket mismatch detected! Expected '<nx:placeholder/>', but instead got '<nx:placeholder/>'... whatever this is. Who invited chaos?", 3)
		nx_grid_stack(V, "Bracket mismatch! The sacred balance of JSON has been disturbed—expected '<nx:placeholder/>', but an intruder '<nx:placeholder/>' appeared instead!", 3)
		nx_grid_stack(V, "Bracket misalignment detected '<nx:placeholder/>'. Expected '<nx:placeholder/>', but timeline divergence has occurred. Syntax stability is at risk!", 3)
		nx_grid_stack(V, "Bracket mismatch! Expected closing '<nx:placeholder/>', but instead found '<nx:placeholder/>' that doesn’t belong. I don’t get paid enough for this.", 3)
		nx_grid_stack(V, "Bracket mismatch detected! Expected '<nx:placeholder/>' but got '<nx:placeholder/>'. I think JSON is officially questioning your choices.", 3)
		nx_grid_stack(V, "The sacred balance of brackets has been shattered! Expected '<nx:placeholder/>' but received '<nx:placeholder/>'. JSON is now mourning its structural integrity.", 3)
		nx_grid_stack(V, "Structural anomaly detected! Expected bracket '<nx:placeholder/>' but instead encountered '<nx:placeholder/>'. Possible timeline corruption detected—syntax integrity at risk!", 3)
		nx_grid_stack(V, "Expected '<nx:placeholder/>' but received '<nx:placeholder/>'. I don’t know what reality you’re operating in, but JSON isn’t buying it.", 3)

		# Delimiter Missmatch error (4)
		nx_grid_stack(V, "Unexpected delimiter found '<nx:placeholder/>', but I was expecting '<nx:placeholder/>'. I suppose surprises keep things interesting?", 4)
		nx_grid_stack(V, "Parsing anomaly detected! Found '<nx:placeholder/>' when '<nx:placeholder/>' was expected. The syntax gods are displeased!", 4)
		nx_grid_stack(V, "Delimiter mismatch! Encountered '<nx:placeholder/>' but expected '<nx:placeholder/>'. Possible corruption in JSON’s structural matrix!", 4)5		nx_grid_stack(V, "Found '<nx:placeholder/>' instead of '<nx:placeholder/>'. This is not what JSON signed up for today.", 4)

		# Invalid Identifier error (5)
		nx_grid_stack(V, "Invalid identifier detected: '<nx:placeholder/>'. JSON looked at it, scratched its head, and decided it wants no part of this mess.", 5)
		nx_grid_stack(V, "Critical identifier failure! JSON was expecting a proper name but stumbled upon '<nx:placeholder/>'. This betrayal will not be forgotten.", 5)
		nx_grid_stack(V, "Unknown identifier '<nx:placeholder/>' encountered. Syntax matrix destabilizing—JSON requests immediate structural recalibration!", 5)
		nx_grid_stack(V, "Found an invalid identifier: '<nx:placeholder/>'. JSON is trying to act professional, but deep down, it's judging you.", 5)

		# Never Push to Stack (6)
		nx_grid_stack(V, "Stack operation failed: '<nx:placeholder/>' was never pushed. Either it ghosted us, or JSON is playing hard to get.", 6)
		nx_grid_stack(V, "Expected '<nx:placeholder/>' in the stack, but it was never added. Somewhere, an error is silently laughing at us.", 6)
		nx_grid_stack(V, "Critical failure: '<nx:placeholder/>' was never pushed to the stack. Perhaps it was afraid of commitment?", 6)
		nx_grid_stack(V, "Stack operation failed—'<nx:placeholder/>' decided to stay independent. No stack life for this one!", 6)

		# Empty Stack (7)
		nx_grid_stack(V, "Attempted to access an empty stack. It's like reaching into a cookie jar only to find it’s empty—deeply disappointing.", 7)
		nx_grid_stack(V, "Stack retrieval failed! JSON checked, double-checked, and confirmed: there's absolutely nothing here.", 7)

		# Invalid Key (8)
		nx_grid_stack(V, "Unexpected character detected in key: '<nx:placeholder/>'. JSON raised an eyebrow and decided this one does not belong.", 8)
		nx_grid_stack(V, "Syntax integrity compromised! Encountered '<nx:placeholder/>' in a key name—this violates the sacred laws of structured data.", 8)
		nx_grid_stack(V, "Key integrity breach detected! Unexpected character '<nx:placeholder/>' found where it does not belong—syntax firewall engaged.", 8)
		nx_grid_stack(V, "Found '<nx:placeholder/>' in a key name. JSON is questioning your life choices, but mostly just wants this fixed.", 8)

		#nx_grid_stack(V, , 1)
		#nx_grid_stack(V, , 1)
		# errors
		#nx_grid_stack(V, "Invalid key (<nx:placeholder/>) syntax detected! Either this character doesn't belong, or JSON is testing your patience today.", 1)
		#nx_grid_stack(V, "Unexpected character (<nx:placeholder/>) found in key definition. Was this intentional, or did someone spill coffee on their keyboard?", 1)

		#"Syntax error detected—JSON fell down the stairs. Please send help."
	}
}

function nx_json_stack_push(V1, V2, V3)
{
	if (V3[V2["dth"]] == "\x5b") {
		V2["rt"] = V2["rt"] "\x5b" ++V1[V2["rt"] "\x5b0\x5d"] "\x5d"
	} else {
		V2["rt"] = V2["rt"] "." V2["nxt"]
	}
}

function nx_json_stack_pop(V1, V2, V3)
{
	if (V3[V2["stk"]] == "\x5b") {
		sub(/[^\x5b]+$/, "", V2["rt"])
		sub(/\x5b$/, "", V2["rt"])
	} else {
		sub(/[^.]+$/, "", V2["rt"])
		sub(/[.]$/, "", V2["rt"])
	}
}

function nx_json_stack(V1, V2, V3)
{
	if (! ("rt" in V2)) {
		if (V3[V2["stk"]] == "\x5b") { # List
			V1[".nx\x5b0\x5d"] = 0
		} else {
			V1[".nx"] = ""
		}
		V2["rt"] = ".nx"
	} else if (V2["dth"] != V2["stk"]) {
		if (V2["dth"] > V2["stk"]) {
			nx_json_stack_pop(V1, V2, V3)
		} else {
			nx_json_stack_push(V1, V2, V3)
		}
	}
	V2["dth"] = V2["stk"]
}

function nx_json_apply(V1, V2, V3, B, V4)
{
	nx_json_stack(V1, V2, V3)
	if (V2["rec"] != "") {
		if (V3[V2["stk"]] == "\x5b") { # List
			V1[V2["rt"] "\x5b" ++V1[V2["rt"] "\x5b0\x5d"] "\x5d"] = V2["rec"]
		} else {
			if (V2["idx"] == "NX_KEY") {
				V2["nxt"] = V2["rec"]
				if (V2["rt"] "." V2["nxt"] in V1 && B > 2)
					print nx_log_warn(nx_json_log(V2, "Duplicate key (" V2["rt"] "." V2["nxt"] ") detected. Either time is looping or someone copy-pasted too enthusiastically."))
				V1[V2["rt"]] = nx_join_str(V1[V2["rt"]], V2["nxt"], "<nx:null/>")
			} else {
				V1[V2["rt"] "." V2["nxt"]] = V2["rec"]
			}
		}
		V2["rec"] = ""
	}
}

function nx_json_float(V1, V2, V3, V4, B, V5)
{
	if (nx_is_digit(V3[V2["cr"]])) { # If current character is a digit
		V2["rec"] = V2["rec"] V3[V2["cr"]] # Append to recorded number
	} else {
		if (V2["rec"] ~ /[.]$/) # If last recorded value is a decimal point
			V2["rec"] = V2["rec"] 0 # Append a zero for valid float representation
		V2["cat"] = "NX_DIGIT"
		if (B > 6) # Debugging
			print nx_log_debug(nx_json_log(V2, V2["rec"]))
		nx_json_apply(V1, V2, V4, B, V5) # Apply the parsed value
		V2["ste"] = "NX_DELIMITER" # Move to delimiter state
		if (! nx_is_space(V3[V2["cr"]])) # If next character is not a space
			V2["cr"]-- # Step back to reevaluate
	}
}

function nx_json_number(V1, V2, V3, V4, B, V5)
{
	if (V2["rec"] == "" && V3[V2["cr"]] ~ /[+]|[-]/) {
		V2["rec"] = V3[V2["cr"]]
	} else if (V3[V2["cr"]] == ".") { # If the current character is a decimal point
		if (V2["rec"] == "") # If we haven't recorded anything yet
			V2["rec"] = 0 # Start with zero
		V2["rec"] = V2["rec"] V3[V2["cr"]] # Append decimal point
		V2["ste"] = "NX_FLOAT" # Switch state to handle floating point numbers
	} else { # Otherwise, delegate to float handling
		nx_json_float(V1, V2, V3, V4, B, V5)
	}
}

function nx_json_string(V1, V2, V3, V4, V5, B, V6)
{
	if (V3[V2["cr"]] != V2["qte"] || int(V2["esc"]) % 2 == 1) {
		if (V2["qte"] == "\x27" || V3[V2["cr"]] != "\x5c" || ++V2["esc"] % 2 == 0) {
			V2["rec"] = V2["rec"] V3[V2["cr"]]
			V2["esc"] = 0
		}
	} else {
		if (V2["qte"] in V5 && V2["qte"] == V3[V2["cr"]]) {
			V2["cat"] = V5[V2["qte"]V2["qte"]]
		} else {
			V2["cat"] =  "NX_ERR_MISSING_QUOTE"
			if (B)
				print nx_log_error(nx_json_log(V2, nx_json_log_db(V6, 2, V2["qte"])))
			return 2
		}
		V2["qte"] = ""
		if (B > 6)
			print nx_log_debug(nx_json_log(V2, V2["rec"]))
		nx_json_apply(V1, V2, V4, B, V6)
		V2["ste"] = "NX_DELIMITER"
	}
}

function nx_json_identifier(V1, V2, V3, V4, B, V5,	t)
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
				print nx_log_error(nx_json_log(V2, nx_json_log_db(V5, 5, V2["rec"])))
			return 5
		}
		if (B > 6)
			print nx_log_debug(nx_json_log(V2, V2["rec"]))
		nx_json_apply(V1, V2, V4, B, V5)
		V2["ste"] = "NX_DELIMITER"
		if (! nx_is_space(V3[V2["cr"]]))
			V2["cr"]--
	}
}

function nx_json_delimiter(V1, V2, V3, V4, V5, B, V6)
{
	if (nx_is_space(V3[V2["cr"]]))
		return 0
	if (V3[V2["cr"]] in V5)
		return nx_json_depth(V1, V2, V3, V4, V5, B, V6)
	if (V3[V2["cr"]] != V2["dlm"]) {
		print V3[V2["cr"]]
		V2["cat"] = "NX_ERR_UNEXPECTED_DELIM"
		if (B)
			print nx_log_error(nx_json_log(V2, nx_json_log_db(V6, 4, V3[V2["cr"]] "<nx:null/>" V2["dlm"])))
		return 4
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

function nx_json_depth(V1, V2, V3, V4, V5, B, V6)
{
	if (V3[V2["cr"]] ~ /[\x5b|\x7b]/) {
		V4[++V2["stk"]] = V3[V2["cr"]]
		V2["cat"] = V5[V5[V4[V2["stk"]]]V4[V2["stk"]]]
		V2["dlm"] = __nx_if(V3[V2["cr"]] == "\x7b", ":", ",")
		V2["ste"] = "NX_DEFAULT"
	} else if (V3[V2["cr"]] == V5[V4[V2["stk"]]]) { # Matching Bracket
		V2["cat"] = V5[V4[V2["stk"]]V5[V4[V2["stk"]]]]
		delete V4[V2["stk"]--]
		V2["ste"] = "NX_DELIMITER"
		V2["dlm"] = ","
	} else if (V2["ste"] == "NX_NONE") { # Never pushed to stack
		if (B)
			print nx_log_error(nx_json_log_delim(V2, nx_json_log_db(V6, 6, "[' or '{<nx:null/>" V3[V2["cr"]])))
		return 21
	} else if (! V2["stk"]) { # Empty Stack
		if (B)
			print nx_log_error(nx_json_log_delim(V2, nx_json_log_db(V6, 7, V3[V2["cr"]])))
		return 11
	} else { # Invalid Bracket Pair
		V2["cat"] = "NX_ERR_BRACKET_MISMATCH"
		if (B)
			print nx_log_error(nx_json_log(V2, nx_json_log_db(V6, 3, V5[V4[V2["stk"]]] "<nx:null/>" V3[V2["cr"]])))
		return __nx_if(V2["ste"] == "NX_NONE", 22, 12)
	}
	if (V4[V2["stk"]] == "\x7b")
		V2["idx"] = "NX_KEY"
	else if (V2["stk"])
		V2["idx"] = "NX_ITEM"
	else
		V2["idx"] = ""
	nx_json_apply(V1, V2, V4, B, V6)
	if (B > 5)
		print nx_log_alert(nx_json_log_delim(V2, V3[V2["cr"]]))
}

function nx_json_default(V1, V2, V3, V4, V5, V6, B, V7)
{
	if (nx_is_space(V3[V2["cr"]]))
		return 0
	if (V3[V2["cr"]] in V6) {
		V2["qte"] = V3[V2["cr"]]
		V2["ste"] = "NX_STRING"
	} else if (V3[V2["cr"]] ~ /[\x5b|\x7b]/ && V2["idx"] == "NX_KEY") {
		V2["cat"] = "NX_ERR_UNEXPECTED_KEY"
		if (B)
			print nx_log_error(nx_json_log(V2, nx_json_log_db(V7, 8, V3[V2["cr"]])))
		return 13
	} else if (V3[V2["cr"]] in V5) {
		return nx_json_depth(V1, V2, V3, V4, V5, B, V7)
	} else if (nx_is_alpha(V3[V2["cr"]])) {
		V2["ste"] = "NX_IDENTIFIER"
		V2["rec"] = V3[V2["cr"]]
	} else if (nx_is_digit(V3[V2["cr"]]) || V3[V2["cr"]] ~ /[+]|[-]|[.]/) {
		V2["ste"] = "NX_NUMBER"
		nx_json_number(V1, V2, V3, V4, B, V7)
	} else {
		V2["cat"] = "NX_ERR_UNEXPECTED_CHAR"
		if (B)
			print nx_log_error(nx_json_log(V2, "Encountered an unexpected character (" V3[V2["cr"]] ") that does not belong in JSON syntax."))
		return 61
	}
}

function nx_json_machine(V1, V2, V3, V4, V5, V6, B, V7)
{
	for (V2["cr"] = 1; V2["cr"] <= V2["len"]; V2["cr"]++) {
		if (V2["ste"] == "NX_DEFAULT") {
			if (V2["err"] = nx_json_default(V1, V2, V3, V4, V5, V6, B, V7))
				break
		} else if (V2["ste"] == "NX_NUMBER") {
			if (V2["err"] = nx_json_number(V1, V2, V3, V4, B, V7))
				break
		} else if (V2["ste"] == "NX_FLOAT") {
			if (V2["err"] = nx_json_float(V1, V2, V3, V4, B, V7))
				break
		} else if (V2["ste"] == "NX_DELIMITER") {
			if (V2["err"] = nx_json_delimiter(V1, V2, V3, V4, V5, B, V7))
				break
		} else if (V2["ste"] == "NX_STRING") {
			if (V2["err"] = nx_json_string(V1, V2, V3, V4, V6, B, V7))
				break
		} else if (V2["ste"] == "NX_IDENTIFIER") {
			if (V2["err"] = nx_json_identifier(V1, V2, V3, V4, B, V7))
				break
		} else if (V2["ste"] == "NX_NONE") {
			if (nx_is_space(V3[V2["cr"]]))
				continue
			if (V2["err"] = nx_json_depth(V1, V2, V3, V4, V5, B, V7))
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

function nx_json(D, V, B,	tok, stk, rec, bm, qm, db)
{
	nx_json_log_db(db)
	if (D == "") {
		print nx_log_error(nx_json_log_db(db, 1, "", 1))
		return 1
	}
	tok["ste"] = "NX_NONE"
	tok["ln"] = 1
	__nx_bracket_map(bm, 2, 2)
	__nx_quote_map(qm, 2, 2)
	if (nx_is_file(D)) {
		tok["fl"] = D
		while ((getline tok["len"] < tok["fl"]) > 0) {
			tok["len"] = split(tok["len"], rec, "")
			if (nx_json_machine(V, tok, rec, stk, bm, qm, B, db))
				break
			++tok["ln"]
		}
		close(tok["fl"])
	} else {
		tok["fl"] = "-"
		tok["len"] = split(D, rec, "")
		nx_json_machine(V, tok, rec, stk, bm, qm, B, db)
	}
	if (tok["qte"] && ! tok["err"]) {
		tok["cat"] = "NX_ERR_MISSING_QUOTE"
		print nx_log_error(nx_json_log(tok, nx_json_log_db(db, 2, tok["qte"])))
		tok["err"] = 2
	}
	if (stk[tok["stk"]] && ! tok["err"]) {
		tok["cat"] = "NX_ERR_BRACKET_MISMATCH"
		print nx_log_error(nx_json_log(tok, nx_json_log_db(db, 3, bm[stk[tok["stk"]]], "<nx:null/>" rec[tok["cr"]])))
		tok["err"] = 3
	}
	D = tok["err"]
	delete qm; delete bm; delete db
	delete tok; delete stk; delete rec
	for (i in V)
		print i "  =  " V[i]
	return D
}

