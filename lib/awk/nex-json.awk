#nx_include "nex-misc.awk"
#nx_include "nex-struct.awk"
#nx_include "nex-str.awk"
#nx_include "nex-log.awk"
#nx_include "nex-math.awk"

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
		nx_grid_stack(V, "JSON expected data but received… nothing. Silence isn't golden when parsing—please provide input!", 1)
		nx_grid_stack(V, "Parsing failure: JSON expected data but received… absolutely nothing. Bold move!", 1)
		nx_grid_stack(V, "Critical error—attempted to process an empty input. JSON refuses to work with the void.", 1)
		nx_grid_stack(V, "System integrity compromised! JSON encountered a complete absence of data—possible breach in reality detected.", 1)
		nx_grid_stack(V, "Warning: No JSON data received. Either the input got lost in another dimension, or someone forgot to send anything at all.", 1)

		# Quote error (2)
		nx_grid_stack(V, "A string quote (<nx:placeholder/>) was opened but never closed. It seems to have escaped—should we report it missing?", 2)
		nx_grid_stack(V, "You opened a quote (<nx:placeholder/>), but forgot to close it. If this was intentional, congratulations—you've invented quantum uncertainty in JSON.", 2)
		nx_grid_stack(V, "A quote (<nx:placeholder/>) has entered the parsing realm but failed to find an exit. It may be trapped forever—unless you rescue it.", 2)
		nx_grid_stack(V, "Unterminated string detected. The quote (<nx:placeholder/>) began its journey, but closure eludes it. Such is the fate of forgotten syntax.", 2)
		nx_grid_stack(V, "A quote (<nx:placeholder/>) was opened but never closed. JSON requires balance—please provide the missing pair.", 2)
		nx_grid_stack(V, "Expected a closing quote to match (<nx:placeholder/>), but found nothing. JSON objects prefer symmetry!", 2)
		nx_grid_stack(V, "A quote '<nx:placeholder/>' was started but never finished. JSON is waiting… patiently… for closure.", 2)
		nx_grid_stack(V, "Syntax failure! A missing closing quote '<nx:placeholder/>' has left JSON stranded in uncertainty. Please restore balance!", 2)

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
		nx_grid_stack(V, "Delimiter mismatch! Encountered '<nx:placeholder/>' but expected '<nx:placeholder/>'. Possible corruption in JSON’s structural matrix!", 4)
		nx_grid_stack(V, "Found '<nx:placeholder/>' instead of '<nx:placeholder/>'. This is not what JSON signed up for today.", 4)
		nx_grid_stack(V, "Delimiter crisis detected! Found '<nx:placeholder/>' when '<nx:placeholder/>' was expected. This is why JSON has trust issues.", 4)
		nx_grid_stack(V, "Syntax integrity failure! Expected delimiter '<nx:placeholder/>' but encountered '<nx:placeholder/>'. JSON's structural balance is at stake!", 4)
		nx_grid_stack(V, "Parsing anomaly detected—delimiter misalignment! Expected '<nx:placeholder/>' but intercepted '<nx:placeholder/>'. Syntax grid destabilizing!", 4)
		nx_grid_stack(V, "Delimiter mismatch! JSON was ready for '<nx:placeholder/>' but got '<nx:placeholder/>' instead. Let’s try that again, shall we?", 4)

		# Invalid Identifier error (5)
		nx_grid_stack(V, "Invalid identifier detected: '<nx:placeholder/>'. JSON looked at it, scratched its head, and decided it wants no part of this mess.", 5)
		nx_grid_stack(V, "Critical identifier failure! JSON was expecting a proper name but stumbled upon '<nx:placeholder/>'. This betrayal will not be forgotten.", 5)
		nx_grid_stack(V, "Unknown identifier '<nx:placeholder/>' encountered. Syntax matrix destabilizing—JSON requests immediate structural recalibration!", 5)
		nx_grid_stack(V, "Found an invalid identifier: '<nx:placeholder/>'. JSON is trying to act professional, but deep down, it's judging you.", 5)
		nx_grid_stack(V, "Identifier '<nx:placeholder/>' detected, but JSON refuses to acknowledge its existence. Try again with something valid.", 5)
		nx_grid_stack(V, "Identifier '<nx:placeholder/>' attempted to join JSON, but it didn't meet the membership requirements. Try again with something valid!", 5)
		nx_grid_stack(V, "Critical syntax breach! JSON detected an unauthorized identifier '<nx:placeholder/>'. Structural integrity at risk!", 5)
		nx_grid_stack(V, "Unknown identifier '<nx:placeholder/>' encountered. Syntax security protocols activated—JSON is rejecting this anomaly!", 5)

		# Never Push to Stack (6)
		nx_grid_stack(V, "Stack operation failed: '<nx:placeholder/>' was never pushed. Either it ghosted us, or JSON is playing hard to get.", 6)
		nx_grid_stack(V, "Expected '<nx:placeholder/>' in the stack, but it was never added. Somewhere, an error is silently laughing at us.", 6)
		nx_grid_stack(V, "Critical failure: '<nx:placeholder/>' was never pushed to the stack. Perhaps it was afraid of commitment?", 6)
		nx_grid_stack(V, "Stack operation failed—'<nx:placeholder/>' decided to stay independent. No stack life for this one!", 6)
		nx_grid_stack(V, "Stack operation failed: '<nx:placeholder/>' never made it in. Either it ran away, or JSON decided it wasn’t worthy.", 6)
		nx_grid_stack(V, "Critical stack failure! '<nx:placeholder/>' was supposed to be pushed but never arrived. Chaos in the parsing pipeline!", 6)
		nx_grid_stack(V, "Stack anomaly detected—expected '<nx:placeholder/>' but it was never pushed. Possible quantum fluctuation in JSON space-time!", 6)
		nx_grid_stack(V, "Expected '<nx:placeholder/>' in the stack, but it was never added. If this was a test, JSON is officially disappointed.", 6)

		# Empty Stack (7)
		nx_grid_stack(V, "Attempted to access an empty stack. It's like reaching into a cookie jar only to find it’s empty—deeply disappointing.", 7)
		nx_grid_stack(V, "Stack retrieval failed! JSON checked, double-checked, and confirmed: there's absolutely nothing here.", 7)
		nx_grid_stack(V, "Stack access attempt failed! JSON reached in, found nothing, and is now questioning reality.", 7)
		nx_grid_stack(V, "Stack underflow detected! JSON expected data, but all it found was an empty void. Perhaps existence itself is broken?", 7)
		nx_grid_stack(V, "Critical stack failure! JSON attempted retrieval but found only emptiness. Possible wormhole anomaly detected.", 7)
		nx_grid_stack(V, "Stack retrieval unsuccessful. JSON checked once, twice, thrice—still nothing. Do you actually want this to work?", 7)
		nx_grid_stack(V, "Stack access denied. If there’s truly nothing here, did JSON ever really exist in the first place?", 7)
		nx_grid_stack(V, "Stack is empty. JSON suggests adding data before trying again.", 7)

		# Invalid Key (8)
		nx_grid_stack(V, "Unexpected character detected in key: '<nx:placeholder/>'. JSON raised an eyebrow and decided this one does not belong.", 8)
		nx_grid_stack(V, "Syntax integrity compromised! Encountered '<nx:placeholder/>' in a key name—this violates the sacred laws of structured data.", 8)
		nx_grid_stack(V, "Key integrity breach detected! Unexpected character '<nx:placeholder/>' found where it does not belong—syntax firewall engaged.", 8)
		nx_grid_stack(V, "Found '<nx:placeholder/>' in a key name. JSON is questioning your life choices, but mostly just wants this fixed.", 8)
		nx_grid_stack(V, "Unexpected character '<nx:placeholder/>' found in key definition. Was this intentional, or did someone spill coffee on their keyboard?", 8)
		nx_grid_stack(V, "Unexpected character '<nx:placeholder/>' found in key name. Unless this is a secret code, JSON isn’t decoding it." , 8)
		nx_grid_stack(V, "Unexpected character '<nx:placeholder/>' found in a key name. JSON is just standing here, shaking its head in disappointment.", 8)
		nx_grid_stack(V, "Syntax violation! '<nx:placeholder/>' appeared where a valid key name should be—this is an unforgivable error in the world of structured data!", 8)

		# Invalid Character (9)
		nx_grid_stack(V, "Unexpected character '<nx:placeholder/>' detected in JSON syntax. It has no business being here—kindly escort it out.", 9)
		nx_grid_stack(V, "Syntax violation! '<nx:placeholder/>' was found lurking where it does not belong. JSON demands order—this must be corrected!", 9)
		nx_grid_stack(V, "Critical parsing failure—unexpected character '<nx:placeholder/>' detected! Syntax firewall engaged to restore JSON stability.", 9)
		nx_grid_stack(V, "JSON syntax rejection: '<nx:placeholder/>' does not belong here. Either it wandered in by accident, or someone is testing JSON’s patience.", 9)
		nx_grid_stack(V, "Unexpected character '<nx:placeholder/>' detected. JSON is deeply confused and wondering how this happened.", 9)
		nx_grid_stack(V, "Syntax breach detected! '<nx:placeholder/>' appeared where it absolutely should not be. JSON is calling for an immediate correction!", 9)
		nx_grid_stack(V, "Parsing failure—unexpected entity '<nx:placeholder/>' intercepted. JSON's structural integrity is under threat!", 9)
		nx_grid_stack(V, "Invalid character '<nx:placeholder/>' detected. Remove it, and let's get this syntax back on track.", 9)

		# Duplicate key (10)
		nx_grid_stack(V, "Duplicate key detected: '<nx:placeholder/>'. Either time is looping, or someone got a little too happy with copy-paste.", 10)
		nx_grid_stack(V, "A paradox has emerged—'<nx:placeholder/>' appeared more than once! JSON is now questioning the fabric of reality.", 10)
		nx_grid_stack(V, "System anomaly detected! Duplicate key '<nx:placeholder/>' found. Possible timeline distortion or unintended recursion.", 10)
		nx_grid_stack(V, "Duplicate key '<nx:placeholder/>' detected. JSON would like to remind you that ‘Ctrl+C, Ctrl+V’ has consequences.", 10)
		nx_grid_stack(V, "Duplicate key '<nx:placeholder/>' detected. JSON wonders if this is an intentional loop or just an overzealous paste.", 10)
		nx_grid_stack(V, "Syntax paradox detected—'<nx:placeholder/>' appears more than once! JSON cannot allow such reality-breaking behavior.", 10)
		nx_grid_stack(V, "Duplicate key '<nx:placeholder/>' identified. Possible data cloning or recursive corruption in JSON memory structures!", 10)
		nx_grid_stack(V, "Warning: Duplicate key '<nx:placeholder/>' found. JSON suggests using unique identifiers before things get messy.", 10)

		# Trail comma (11)
		nx_grid_stack(V, "A trailing comma detected before '<nx:placeholder/>'. JSON doesn’t appreciate loose ends—please remove it before things get messy." , 11)
		nx_grid_stack(V, "Syntax error! A rogue comma before '<nx:placeholder/>' is threatening JSON’s structural integrity. Immediate removal recommended!" , 11)
		nx_grid_stack(V, "System anomaly detected: Unnecessary comma found before '<nx:placeholder/>'. Possible timeline corruption—JSON requests urgent repairs!" , 11)
		nx_grid_stack(V, "Trailing comma detected before '<nx:placeholder/>'. JSON would like to remind you that commas need closure—remove it before things escalate." , 11)
		nx_grid_stack(V, "Trailing comma detected before '<nx:placeholder/>'—JSON prefers tidy endings, not hanging syntax!" , 11)
		nx_grid_stack(V, "Trailing comma detected before '<nx:placeholder/>'—this isn’t a dramatic pause, just a syntax problem. Remove it!", 11)
		nx_grid_stack(V, "Syntax error! A rogue comma has appeared before '<nx:placeholder/>'—JSON demands immediate correction!", 11)
		nx_grid_stack(V, "Parsing instability detected! Unexpected comma before '<nx:placeholder/>'—syntax framework destabilizing!", 11)
	}
}

function nx_json_split(D1, V1, V2, D2)
{
	if (! length(V1) && nx_json(D2, V1, 2)) {
		delete V1
		return 0
	}
	if (".nx" D1 "[0]" in V1) {
		V2[0] = 0
		for (D2 = 1; D2 <= V1[".nx" D1 "[0]"]; D2++) {
			V2[++V2[0]] = V1[".nx" D1 "[" D2 "]"]
		}
		D2 = 1
	} else if (".nx" D1 in V1) {
		D2 = split(V1[".nx" D1], V2, "<nx:null/>")
		V2[0] = D2
		D2 = 2
	} else {
		return 0
	}
	return D2
}

function nx_json_keep(D1, V1, V2, D2)
{
	if (0 in V2) {
		return 0
	} else if (nx_json_split(D1, V1, V2, D2)) {
		delete V2
		return 2
	} else {
		return 1
	}
}

function nx_json_length(D1, V1, B, V2, D2,	i, j, k)
{
	if ((D2 = nx_json_keep(D1, V1, V2, D2)) < 2) {
		for (i = 1; i <= V2[0]; i++) {
			j = length(V2[i])
			if (! k || __nx_if(B, k < j, k > j))
				k = j
		}
		V1[".nx" D1 "(" __nx_if(B, "longest", "shortest") ")"] = int(k)
	}
	if (D2)
		delete V2
	return int(k)
}

function nx_json_reverse(D1, V1, V2, D2,	i, j)
{
	if ((D2 = nx_json_keep(D1, V1, V2, D2)) < 2) {
		if (".nx" D1 "[0]" in V1) {
			i = V1[".nx" D1 "[0]"]
			do {
				V1[".nx" D1 "[" ++j "]"] = V2[i]
				V1[".nx" D1 "[" i "]"] = V2[j]
			} while (--i > j)
		}
	}
	if (D2)
		delete V2
}

function nx_json_filter(D1, D2, D3, V1, V2, D4,		i)
{
	if ((D4 = nx_json_keep(D1, V1, V2, D4)) < 2) {
		for (i = 1; i <= V2[0]; i++) {
			if (__nx_equality(D2, D3, V2[i]))
				V1[".nx" D1 "(filter)"] = nx_join_str(V1[".nx" D1 "(filter)"], V2[i], "<nx:null/>")
		}
	}
	if (D4)
		delete V2
	return V1[".nx" D1 "(filter)"]
}

function nx_json_anchor(D1, D2, V1, B, V2, D3,	i)
{
	if ((D3 = nx_json_keep(D1, V1, V2, D3)) < 2) {
		for (i = 1; i <= V2[0]; i++) {
			if (__nx_if(B, V2[i] ~ D2 "$", V2[i] ~ "^" D2))
				V1[".nx" D1 "(anchor)"] = nx_join_str(V1[".nx" D1 "(anchor)"], V2[i], "<nx:null/>")
		}
	}
	if (D3)
		delete V2
	return V1[".nx" D1 "(anchor)"]
}

function nx_json_match(D1, D2, V1, V2, D3, B1, B2,	v)
{
	if ((D3 = nx_json_keep(D1, V1, V2, D3)) < 2) {
		if ((B1 = split(nx_json_anchor(D1, D2, V1, B1, V2, D3), v, "<nx:null/>")) > 1) {
			v[0] = B1
			if ((B2 = split(nx_json_filter(D1, nx_append_str("0", nx_json_length(D1, V1, B2, v, D3)), "=_", V1, v, D3), v, "<nx:null/>")) > 1) {
				do {
					V1[".nx" D1 "(match)"] = nx_join_str(V1[".nx" D1 "(match)"], v[B2], "<nx:null/>")
				} while (--B2 > 0)
				delete v
			}
		}
	}
	if (length(v)) {
		B1 = v[1]
		V1[".nx" D1 "(match)"] = B1
		delete v
	} else {
		B1 = ""
	}
	if (D3)
		delete V2
	return B1
}

function nx_json_stack(D1, V, D2)
{
	if (length(V) && ".nx" D1 "[0]" in V) {
		if (D2) {
			V[".nx" D1 "[" ++V[".nx" D1 "[0]"] "]"] = D2
		} else if (V[".nx" D1 "[" V[".nx" D1 "[0]"] "]"]) {
			if (D2 == "") {
				D2 = V[".nx" D1 "[" V[".nx" D1 "[0]"] "]"]
				delete V[".nx" D1 "[" V[".nx" D1 "[0]"]-- "]"]
				return D2
			}
			return V[".nx" D1 "[" V[".nx" D1 "[0]"] "]"]
		}
	}
}

function nx_json_root(V1, V2, V3)
{
	if (! ("rt" in V2)) {
		V2["rt"] = ".nx"
	} else if (V2["dth"] != V2["stk"]) {
		if (V2["dth"] > V2["stk"]) {
			if (V3[V2["stk"]] == "\x5b") {
				sub(/[^\x5b]+$/, "", V2["rt"])
				sub(/\x5b$/, "", V2["rt"])
			} else {
				sub(/[^.]+$/, "", V2["rt"])
				sub(/[.]$/, "", V2["rt"])
			}
		} else {
			if (V3[V2["dth"]] == "\x5b") {
				V2["rt"] = V2["rt"] "\x5b" ++V1[V2["rt"] "\x5b0\x5d"] "\x5d"
			} else {
				V2["rt"] = V2["rt"] "." V2["nxt"]
			}
		}
	}
	V2["dth"] = V2["stk"]
}

function nx_json_apply(V1, V2, V3, B, V4)
{
	nx_json_root(V1, V2, V3)
	if (V2["rec"] != "") {
		if (V3[V2["stk"]] == "\x5b") { # List
			V1[V2["rt"] "\x5b" ++V1[V2["rt"] "\x5b0\x5d"] "\x5d"] = V2["rec"]
		} else {
			if (V2["idx"] == "NX_KEY") {
				V2["nxt"] = V2["rec"]
				if (V2["rt"] "." V2["nxt"] in V1) {
					if (B > 1)
						print nx_log_warn(nx_json_log(V2, nx_json_log_db(V4, 10, V2["rt"] "." V2["nxt"])))
				} else {
					V1[V2["rt"]] = nx_join_str(V1[V2["rt"]], V2["nxt"], "<nx:null/>")
				}
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
		if (B > 2) # Debugging
			print nx_log_alert(nx_json_log(V2, V2["rec"]))
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
			return 21
		}
		V2["qte"] = ""
		if (B > 2)
			print nx_log_alert(nx_json_log(V2, V2["rec"]))
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
			return 50
		}
		if (B > 2)
			print nx_log_alert(nx_json_log(V2, V2["rec"]))
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
		V2["cat"] = "NX_ERR_UNEXPECTED_DELIM"
		if (B)
			print nx_log_error(nx_json_log(V2, nx_json_log_db(V6, 4, V3[V2["cr"]] "<nx:null/>" V2["dlm"])))
		return 40
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
	if (B > 3)
		print nx_log_debug(nx_json_log_delim(V2, V3[V2["cr"]]))
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
		if (V2["lcr"] == "\x2c" && B > 1)
			print nx_log_warn(nx_json_log_delim(V2, nx_json_log_db(V6, 11, V3[V2["cr"]])))
		V2["cat"] = V5[V4[V2["stk"]]V5[V4[V2["stk"]]]]
		delete V4[V2["stk"]--]
		V2["ste"] = "NX_DELIMITER"
		V2["dlm"] = ","
	} else if (V2["ste"] == "NX_NONE") { # Never pushed to stack
		if (B)
			print nx_log_error(nx_json_log_delim(V2, nx_json_log_db(V6, 6, "[' or '{<nx:null/>" V3[V2["cr"]])))
		return 60
	} else if (! V2["stk"]) { # Empty Stack
		if (B)
			print nx_log_error(nx_json_log_delim(V2, nx_json_log_db(V6, 7, V3[V2["cr"]])))
		return 70
	} else { # Invalid Bracket Pair
		V2["cat"] = "NX_ERR_BRACKET_MISMATCH"
		if (B)
			print nx_log_error(nx_json_log(V2, nx_json_log_db(V6, 3, V5[V4[V2["stk"]]] "<nx:null/>" V3[V2["cr"]])))
		return __nx_if(V2["ste"] == "NX_NONE", 31, 30)
	}
	if (V4[V2["stk"]] == "\x7b")
		V2["idx"] = "NX_KEY"
	else if (V2["stk"])
		V2["idx"] = "NX_ITEM"
	else
		V2["idx"] = ""
	nx_json_apply(V1, V2, V4, B, V6)
	if (B > 3)
		print nx_log_debug(nx_json_log_delim(V2, V3[V2["cr"]]))
}

function nx_json_default(V1, V2, V3, V4, V5, V6, B, V7)
{
	if (V3[V2["cr"]] in V6) {
		V2["qte"] = V3[V2["cr"]]
		V2["ste"] = "NX_STRING"
	} else if (V2["idx"] == "NX_KEY" && V3[V2["cr"]] != V5[V4[V2["stk"]]]) {
		V2["cat"] = "NX_ERR_UNEXPECTED_KEY"
		if (B)
			print nx_log_error(nx_json_log(V2, nx_json_log_db(V7, 8, V3[V2["cr"]])))
		return 80
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
			print nx_log_error(nx_json_log(V2, nx_json_log_db(V7, 9, V3[V2["cr"]])))
		return 90
	}
}

function nx_json_machine(V1, V2, V3, V4, V5, V6, B, V7)
{
	for (V2["cr"] = 1; V2["cr"] <= V2["len"]; V2["cr"]++) {
		if (V2["ste"] == "NX_DEFAULT") {
			if (nx_is_space(V3[V2["cr"]]))
				continue
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
		V2["lcr"] = V3[V2["cr"]]
	}
	return V2["err"]
}

function nx_json(D, V, B,	tok, stk, rec, bm, qm, db)
{
	nx_json_log_db(db)
	if (D == "") {
		if (B)
			print nx_log_error(nx_json_log_db(db, 1, "", 1))
		return 10
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
		if (B)
			print nx_log_error(nx_json_log(tok, nx_json_log_db(db, 2, tok["qte"])))
		tok["err"] = 20
	}
	if (stk[tok["stk"]] && ! tok["err"]) {
		tok["cat"] = "NX_ERR_BRACKET_MISMATCH"
		if (B)
			print nx_log_error(nx_json_log(tok, nx_json_log_db(db, 3, bm[stk[tok["stk"]]], "<nx:null/>" rec[tok["cr"]])))
		tok["err"] = 30
	}
	D = tok["err"]
	delete qm; delete bm; delete db
	delete tok; delete stk; delete rec
	return D
}

