function __nx_keyword_map(V)
{
	# Control Flow
	V["do"] = "flow"
	V["while"] = "flow"
	V["until"] = "flow"
	V["for"] = "flow"
	V["if"] = "flow"
	V["else"] = "flow"
	V["switch"] = "flow"
	V["case"] = "flow"
	V["default"] = "flow"

	# Function Handling
	V["function"] = "func"
	V["return"] = "func"
	V["exit"] = "func"

	# Loop & Jump Control
	V["break"] = "loop"
	V["continue"] = "loop"
	V["goto"] = "loop"
	V["in"] = "loop"

	# Error Handling
	V["try"] = "exception"
	V["throw"] = "exception"
	V["catch"] = "exception"
	V["finally"] = "exception"

	# Import & Inclusion
	V["include"] = "import"

	# Data Types
	V["const"] = "type"
	V["char"] = "type"
	V["str"] = "type"
	V["int"] = "type"
	V["float"] = "type"
	V["bool"] = "type"
	V["signed"] = "type"
	V["unsigned"] = "type"
}

function nex_tok_log(V, D)
{
	return "( File: '" V["fle"] "', Line: '" V["ln"] "', Token: '" V["tok"] "' ) " D
}

function nx_tok_error(V, D, B)
{
	print nx_log_error(nex_tok_log(V, D), B)
}

function nx_tok_success(V, D, B)
{
	print nx_log_success(nex_tok_log(V, D), B)
}

function nx_tok_warn(V, D, B)
{
	print nx_log_warn(nex_tok_log(V, D), B)
}

function nx_tok_info(V, D, B)
{
	print nx_log_info(nex_tok_log(V, D), B)
}

function nx_tok_debug(V, D, B)
{
	print nx_log_debug(nex_tok_log(V, D), B)
}

function nx_tok_alert(V, D, B)
{
	print nx_log_alert(nex_tok_log(V, D), B)
}

function nx_lexer_number(V1, V2, N)
{
	if (V2[N] ~ /[0-9]/) {
		V1["tok"] = V1["tok"] V2[N]
	} else if (V2[N] == ".") {
		V1["tok"] = V1["tok"] V2[N]
		V1["cur"] = "nx_float"
	} else {
		nx_tok_success(V1, "Number: " V1["tok"], 1)
		V1["cur"] = "nx_default"
		return --N
	}
	return N
}

function nx_lexer_float(V1, V2, N)
{
	if (V2[N] ~ /[0-9]/) {
		V1["tok"] = V1["tok"] V2[N]
	} else {
		nx_tok_success(V1, "Float: " V1["tok"], 1)
		V1["cur"] = "nx_default"
		return --N
	}
	return N
}

function nx_lexer_string(V1, V2, N)
{
	if (V2[N] != V1["qte"]) {
		V1["tok"] = V1["tok"] V2[N]
	} else {
		nx_tok_success(V1, "String: " V1["tok"], 1)
		V1["qte"] = ""
		V1["cur"] = "nx_default"
	}
	return N
}

function nx_lexer_keyword(V1, V2, N, V3)
{
	if (V2[N] ~ /[a-zA-Z_]/) {
		V1["tok"] = V1["tok"] V2[N]
	} else {
		if (V1["tok"] in V3)
			nx_tok_debug(V1, "Keyword: " V1["tok"], 1)
		else
			nx_tok_alert(V1, "Identifier: " V1["tok"], 1)
		V1["cur"] = "nx_default"
		return --N
	}
	return N
}

function nx_lexer_environ(V1, V2, N,	t)
{
	if (__nx_if(V1["tok"] == "", V2[N] ~ /[a-zA-Z_]/, V2[N] ~ /[a-zA-Z0-9_]/)) {
		V1["tok"] = V1["tok"] V2[N]
	} else {
		if (t = ENVIRON[V1["tok"]])
			nx_tok_info(V1, "Environ: "  V1["tok"] " == " t, 1)
		else
			nx_tok_warn(V1, "Environ " V1["tok"] " is either invalid or was never defined.", 1)
		V1["cur"] = "nx_default"
		return --N
	}
	return N
}

function nx_lexer_operator(V1, V2, N,	t1, t2, t3)
{
	t1 = V2[N] # Start with the first operator character
	if (N + 1 <= V1["chr"]) {
		t2 = V2[N + 1]
		if (N + 2 <= V1["chr"]) {
			t3 = V2[N + 2]
		}
	}
	if (t1 ~ /[<>]/) {
		if (t1 == t2) {
			if (t3 == "=") {
				V2[N + 2] = t1 t2 t3
				return N + 2
			}
		} else if (t2 == "=") {
			V2[N + 1] = t1 t2
			return N + 1
		}
		return N
	} else if (t1 == "~" || t2 == "~") {
		if (t1 == "!") {
			V2[N + 1] = t1 t2
			return N + 1
		}
		return N
	} else if (t1 ~ /[*^%!|-+\/=&]/) {
		if ((t2 ~ /[+-=|&*]/ && t1 == t2) || (t1 != "=" && t2 == "=")) {
			V2[N + 1] = t1 t2
			return N + 1
		}
		return N
	} else if (t1 ~ /[:;?]/) {
		return N
	}
	# Default single-character operator
	nx_tok_error(state, "Expected an an operator, but '" b_map[depth[depth[0]]] "' was received instead.", 1)
	state["err"] = 3
	return 0
}

function nx_lexer(D,	l, ln, i, state, depth, q_map, b_map, k_map, chars)
{
	if (D == "")
		return
	state["cur"] = "nx_default"
	state["esc"] = 0
	state["qte"] = ""
	state["skp"] = 0
	state["tok"] = ""
	state["err"] = 0
	state["fle"] = D
	__nx_quote_map(q_map)
	__nx_bracket_map(b_map)
	__nx_keyword_map(k_map)
	while ((getline l < D) > 0) {
		++state["ln"]
		ln = split(l, chars, "")
		state["chr"] = ln
		for (i = 1; i <= ln; i++) {
			if (state["cur"] == "nx_default") {
				if ((chars[i] ~ /[ \r\b\v\f\n\t]/) || (chars[i] == "\\" && nx_modulo(++state["esc"], 2) == 1)) {
					continue
				} else if (chars[i] in q_map) {
					state["cur"] = "nx_string"
					state["qte"] = chars[i]
					chars[i] = ""
				} else if (chars[i] in b_map) {
					if (chars[i] ~ /[\\{\\[\\(]/) {
						depth[++depth[0]] = chars[i]
					} else if (chars[i] == b_map[depth[depth[0]]]) {
						delete depth[depth[0]--]
					} else {
						nx_tok_error(state, "Expected '" b_map[depth[depth[0]]] "', received '" chars[i] "'.", 1)
						state["err"] = 1
						break
					}
				} else if (chars[i] == "$") {
					state["cur"] = "nx_environ"
					chars[i] = ""
				} else if (chars[i] ~ /[0-9]/) {
					state["cur"] = "nx_number"
				} else if (chars[i] ~ /[a-zA-Z_]/) {
					state["cur"] = "nx_keyword"
				} else if (i = nx_lexer_operator(state, chars, i)) {
					nx_tok_info(state, "Operator: " chars[i], 1)
				} else {
					break
				}
				state["esc"] = 0
				state["tok"] = chars[i]
			} else if (state["cur"] == "nx_environ") {
				i = nx_lexer_environ(state, chars, i)
			} else if (state["cur"] == "nx_keyword") {
				i = nx_lexer_keyword(state, chars, i, k_map)
			} else if (state["cur"] == "nx_string") {
				i = nx_lexer_string(state, chars, i)
			} else if (state["cur"] == "nx_operator") {
				if (! (i = nx_lexer_operator(state, chars, i)))
					break
			} else if (state["cur"] == "nx_number") {
				i = nx_lexer_number(state, chars, i)
			} else if (state["cur"] == "nx_float") {
				i = nx_lexer_float(state, chars, i)
			}
		}
		if (state["err"])
			break
	}
	close(D)
	l = state["err"]
	if (state["qte"] && ! state["err"]) {
		nx_tok_error(state, " (" state["qte"] ") was never closed.", 1)
		l = l + 4
	}
	if (depth[0] && ! state["err"]) {
		nx_tok_error(state, "Expected '" b_map[depth[depth[0]]] "', but never received.", 1)
		l = l + 2
	}
	delete b_map
	delete q_map
	delete state
	delete depth
	delete chars
	return l
}

