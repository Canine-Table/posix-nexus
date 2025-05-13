function __nx_color_map(D1, D2,		c)
{
	if (D2 == "<")
		c = 10
	else
		c = 0
	if ((D2 = tolower(D1)) == "c")
		return c + 39
	if (D1 != D2)
		c += 60
	if (D2 == "b")
		return c + 30
	if (D2 == "e")
		return c + 31
	if (D2 == "s")
		return c + 32
	if (D2 == "w")
		return c + 33
	if (D2 == "i")
		return c + 34
	if (D2 == "d")
		return c + 35
	if (D2 == "a")
		return c + 36
	if (D2 == "l")
		return c + 37
	return 0
}

function __nx_style_map(D,	c)
{
	if (D == "o") # overline
		return 53
	if (D == "O") # not overline
		return 55
	if (D != (c = tolower(D))) {
		D = c
		c = 20
	} else {
		c = 0
	}
	if (D == "n") # normal
		return "0"
	if (D == "b") # bold
		return c + 1
	if (D == "d") # dim
		return c + 2
	if (D == "i") # italic
		return c + 3
	if (D == "u") # underline
		return c + 4
	if (D == "f") # flash
		return c + 5
	if (D == "r") # reverse video
		return c + 7
	if (D == "h") # hide
		return c + 8
	if (D == "s") # strike
		return c + 9
}

function __nx_symbol_map(D,	c)
{
	if (D == "b") # emphasis
		return "#"
	if (D == "B") # pipeline
		return "|"
	if (D == "e") # minor error
		return "x"
	if (D == "E") # critical error needs attention like yesterday
		return "X"
	if (D == "s") # success
		return "v"
	if (D == "S") # great success
		return "V"
	if (D == "w") # warning
		return "!"
	if (D == "W") # warning but not sure
		return "?"
	if (D == "d") # debug
		return "*"
	if (D == "D") # trace
		return ">"
	if (D == "i") # info
		return "i"
	if (D == "I") # verbose
		return "."
	if (D == "l") # log
		return "%"
	if (D == "L") # detailed log
		return "$"
	if (D == "a") # alert
		return "@"
	if (D == "A") # more info alert
		return "&"
}

function nx_printf(D1, D2, S,	fv, i, l, stkv)
{
	if (D1 != "" && D2 != "") {
		l = split(D1, fv, "")
		stkv["s"] = ">"
		stkv["i"] = ""
		stkv["fmt"] = ""
		stkv["plhdr"] = ""
		for (i = 1; i <= l; i++) {
			if (fv[i] ~ /[<>_\\^]/) {
				stkv["s"] = fv[i]
			} else if (fv[i] == "%") {
				stkv["fmt"] = stkv["fmt"] __nx_if(stkv["plhdr"], "\x1b[" stkv["plhdr"] "m<nx:placeholder/>", "<nx:placeholder/>")
				stkv["plhdr"] = ""
			} else if (stkv["s"] ~ /[<>]/) {
				stkv["plhdr"] = nx_join_str(stkv["plhdr"], __nx_color_map(fv[i], stkv["s"]), ";")
			} else if (stkv["s"] == "^" && (stkv["i"] = __nx_symbol_map(fv[i]))) {
				stkv["i"] = "\x0a[" stkv["i"] "]: "
				stkv["fmt"] = stkv["fmt"] __nx_if(stkv["plhdr"], "\x1b[" stkv["plhdr"] "m" stkv["i"], stkv["i"])
				stkv["plhdr"] = ""
			} else if (stkv["s"] == "_") {
				stkv["plhdr"] = nx_join_str(stkv["plhdr"], __nx_style_map(fv[i]), ";")
			}
		}
		stkv["fmt"] = stkv["fmt"] __nx_if(stkv["plhdr"], "\x1b[" stkv["plhdr"] "m", "")
		S = nx_trim_split(D2, fv, __nx_else(S, "<nx:null/>"))
		for (i = 1; i <= S; i++) {
			if (! sub("<nx:placeholder/>", fv[i], stkv["fmt"]))
				break
		}
		gsub("<nx:placeholder/>", "", stkv["fmt"])
		l = stkv["fmt"] "\x1b[0m"
		delete stkv
		return l
	}
}

function nx_log_success(D, B)
{
	if (B)
		return nx_printf("S_bi^s_Iu%", D)
	return nx_printf("b<S_bi^s_Iu%", D)
}

function nx_log_warn(D, B)
{
	if (B)
		return nx_printf("W_bi^w_Iu%", D)
	return nx_printf("b<W_bi^w_Iu%", D)
}

function nx_log_error(D, B)
{
	if (B)
		return nx_printf("E_bi^e_Iu%", D)
	return nx_printf("b<E_bi^e_Iu%", D)
}

function nx_log_debug(D, B)
{
	if (B)
		return nx_printf("D_bi^d_Iu%", D)
	return nx_printf("b<D_bi^d_Iu%", D)
}

function nx_log_info(D, B)
{
	if (B)
		return nx_printf("I_bi^i_Iu%", D)
	return nx_printf("b<I_bi^i_Iu%", D)
}

function nx_log_alert(D, B)
{
	if (B)
		return nx_printf("A_bi^a_Iu%", D)
	return nx_printf("b<A_bi^a_Iu%", D)
}

