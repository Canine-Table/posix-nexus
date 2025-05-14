function __nx_box_map(V, D)
{
	D = tolower(D)
	if (D == "s") {
		V["ulc"] = "┌"
		V["llc"] = "└"
		V["urc"] = "┐"
		V["lrc"] = "┘"
		V["vr"] = "├"
		V["vl"] = "┤"
		V["hd"] = "┬"
		V["hu"] = "┴"
		V["hv"] = "┼"
		V["hl"] = "─"
		V["vl"] = "│"
	} else if (D == "d") {
		V["ulc"] = "╔"
		V["llc"] = "╚"
		V["urc"] = "╗"
		V["lrc"] = "╝"
		V["vr"] = "╠"
		V["vl"] = "╣"
		V["hd"] = "╦"
		V["hu"] = "╩"
		V["hv"] = "╬"
		V["hl"] = "═"
		V["vl"] = "║"
	}
	if (B) {
		V["thb"] = "▀"
		V["bs"] = "■"
		V["bhb"] = "▄"
		V["gb"] = "█"
		V["ldd"] = "░"
		V["mdd"] = "▒"
		V["hdd"] = "▓"
		V["vbb"] = "¦"
		V["ldi"] = "ı"
		V["ms"] = "¯"
		V["ln"] = "¬"
	}
}

function nx_tui_terminal(V1, V2, V3)
{
	#\033[H\033[J
}


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

function nx_tui(D1, D2, V,	tok, scrt)
{
	D1 = split(D1, tok, "")
	tok["length"] = D1
	tok["state"] = "NX_DEFAULT"
	tok["line"] = 1
	tok["page"] = 1
	tok["row"] = ENVIRON["G_NEX_TTY_ROWS"]
	tok["col"] = ENVIRON["G_NEX_TTY_COLUMNS"]
	__nx_box_map(tok, __nx_if(tolower(D2) ~ /[sd]/, D2, "s"))
	for (tok["char"] = 1; tok["char"] <= tok["length"]; tok["char"]++) {
		if (tok["state"] == "NX_DEFAULT") {
			if (tok[tok["char"]] ~ /[ \t\n\f\r\v\b]/) {
				tok["state"] = "NX_ESCAPE"
				tok["char"]--
			} else if (tok[tok["char"]] == "\e") {
				tok["state"] = "NX_TERMINAL"
				tok["char"]--
			} else {
				tok["lcount"]++
				tok["token"] = tok["token"] tok[tok["char"]]
			}
		} else if (tok["state"] == "NX_ESCAPE") {
			nx_tui_escape(tok, scrt, V)
		} else if (tok["state"] == "NX_RETURN") {
			nx_tui_return(tok, scrt, V)
		} else if (tok["state"] == "NX_TERMINAL") {
			nx_tui_terminal(tok, scrt, V)
		}
	}
	if (tok["token"] != "")
		V[++V[0]] = tok["token"]
	delete tok
	delete scrt
	for (D1 = 1; D1 <= V[0]; D1++) {
		print V[D1]
	}
}

