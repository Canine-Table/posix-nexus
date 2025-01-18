
function color_map(c) {
	if (c == "black" || c == "dark")
		c = 30
	else if (c == "red" || c == "error")
		c = 31
	else if (c == "green" || c == "success")
		c = 32
	else if (c == "yellow" || c == "warning")
		c = 33
	else if (c == "blue" || c == "info")
		c = 34
	else if (c == "magenta" || c == "debug")
		c = 35
	else if (c == "teal" || c == "alert")
		c = 36
	else if (c == "white" || c == "light")
		c = 37
	else
		c = 0
	return c
}

function text_style_map(s) {
	if (s == "bold")
		s = 1
	else if (s == "italics")
		s = 3
	else if (s == "underlined")
		s = 4
	else if (s == "blinking")
		s = 5
	else if (s == "highlighted")
		s = 7
	else
		s = 0
	return s
}

function load_symbols() {
	sym_map[30] = "-"
	sym_map[31] = "X"
	sym_map[32] = "V"
	sym_map[33] = "!"
	sym_map[34] = "i"
	sym_map[35] = "*"
	sym_map[36] = "+"
	sym_map[37] = "?"
}

function color_style(i, f, b, t, c, s, F, B) {
	if (c) {
		str = "\x1b["
		if (t = text_style_map(t)) {
			str = str t ";"
		}

		if (f = color_map(f)) {
			if (F)
				f = int(f + 60)
			str = str f ";"
		}
		if (b = color_map(b)) {
			b = int(b + 10)
			if (B)
				b = int(b + 60)
			str = str b ";"
		}
		if (! sub(";$", "m", str))
		    str = ""
	}
	if (s) {
		load_symbols()
		if (s = sym_map[color_map(s)])
			str = str "[" s "]: "
	}
	return str i
}

