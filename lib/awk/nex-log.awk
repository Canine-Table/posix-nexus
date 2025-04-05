function load_symbols(V)
{
	V[30] = "-"
	V[31] = "X"
	V[32] = "V"
	V[33] = "!"
	V[34] = "i"
	V[35] = "*"
	V[36] = "+"
	V[37] = "?"
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

function __error(D, V, N)
{
	l = -int(V[-0])
	print l
	#if (__defined(D))
}
