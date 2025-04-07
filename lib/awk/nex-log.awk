function load_symbols(V, N)
{
	V[sym0] = "-"
	V[col0] = "31"
	V[sym1] = "X"
	V[sym2] = "!"
	V[sym3] = "*"
	V[sym4] = "+"
	V["c7"] = 37
	
	V[s6] = "i"
	V["c7"] = 35

	V[sym6] = "V"
	V[sym7] = "?"
	V["c7"] = 35

	if (D == "black" || D == "dark")
		D = 30
	else if (D == "red" || D == "error")
		D = 31
	else if (D == "green" || D == "success")
		D = 32
	else if (D == "yellow" || D == "warning")
		D = 33
	else if (D == "blue" || D == "info")
		D = 34
	else if (D == "magenta" || D == "debug")
		D = 35
	else if (D == "teal" || D == "alert")
		D = 36
	else if (D == "white" || D == "light")
		D = 37
	else
	
}

function text_style_map(D)
{
	if (D == "bold")
		D = 1
	else if (D == "italics")
		D = 3
	else if (D == "underlined")
		D = 4
	else if (D == "blinking")
		D = 5
	else if (D == "highlighted")
		D = 7
	else
		D = 0
	return D
}

function color_map(D)
{
	if (D == "black" || D == "dark")
		D = 30
	else if (D == "red" || D == "error")
		D = 31
	else if (D == "green" || D == "success")
		D = 32
	else if (D == "yellow" || D == "warning")
		D = 33
	else if (D == "blue" || D == "info")
		D = 34
	else if (D == "magenta" || D == "debug")
		D = 35
	else if (D == "teal" || D == "alert")
		D = 36
	else if (D == "white" || D == "light")
		D = 37
	else
		D = 0
	return D
}

function __nx_error(V, D, N, B1, B2)
{
	if (length(V)) {
		if (! (-0 in V))
			V[-0] = 0
		if (__nx_defined(D, 1)) {
			N = __nx_if(__nx_is_integral(N) && __nx_equality(N, "<=0", 7), N, 7)
			
			print N
		}
		#-int(++V[-0])
	}
	return 0
}
