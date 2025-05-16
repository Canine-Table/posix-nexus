

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

