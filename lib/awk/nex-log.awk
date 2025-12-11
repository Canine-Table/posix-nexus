#nx_include nex-misc.awk

function nx_ansi_print(D, B,	stk, ansi, args)
{
	# D has no more use, lets store the index counter in it
	if ((D = split(D, args, "<nx:null/>")) < 2) {
		delete args
		return -1
	}
	args[1] = split("2" args[1], ansi, "")
	ansi[0] = args[1]

	args[0] = D # varargs count
	args[1] = 2 # varargs index
	D = ""

	stk[0] = 2
	stk[1] = ">"
	stk[2] = "\0"
	stk[3] = "<nx:false/>"
	do {
		if (ansi[ansi[1]] ~ /[<>_\0]/) {
			stk[1] = ansi[ansi[1]]
		} else if (ansi[ansi[1]] == "^") {
			stk[2] = __nx_ansi_pmap(ansi[++ansi[1]])
		} else if (ansi[ansi[1]] == "%") {
			D = D __nx_if(stk[3] == "<nx:false/>", "", "m") __nx_if(stk[1] == "\0" || stk[2] == "\0", "", "[" stk[2] "]\x1b[37m: ") __nx_if(stk[4], stk[4] "m", "") args[args[1]++]
			stk[3] = "<nx:false/>"
			stk[4] = ""
		} else {
			if (stk[1] ~ /[<>_]/) {
				stk[5] = __nx_if(stk[3] == "<nx:false/>", "\x1b[", ";") __nx_if(stk[1] == "_", __nx_ansi_smap(ansi[ansi[1]]), __nx_ansi_cmap(ansi[ansi[1]], stk[1]))
				D = D stk[5]
				stk[4] = stk[4] stk[5]
				stk[3] = "<nx:true/>"
			} else {
				D = D __nx_if(stk[3] == "<nx:false/>", "", "m") ansi[ansi[1]]
				stk[3] = "<nx:false/>"
			}
		}
	} while (args[1] <= args[0] && ++ansi[1] <= ansi[0])
	if (B != "<nx:true/>") {
		nx_fd_stderr(D "\x1b[0m")
		D = args[1]
	}
	delete args
	delete stk
	delete ansi
	return D
}

function __nx_ansi_cmap(D1, D2,		c)
{
	if (D2 == "<")
		c = 10
	else
		c = 0
	if ((D2 = tolower(D1)) == "c")
		return c + 39
	if (D2 == "r")
		return c + 38
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

function __nx_ansi_smap(D,	c)
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
	return 0
}

function __nx_ansi_pmap(D)
{
	if (D == "b") { # emphasis
		D = "#"
	} else if (D == "B") { # pipeline
		D = "|"
	} else if (D == "e") { # minor error
		D = "x"
	} else if (D == "E") { # critical error needs attention like yesterday
		D = "X"
	} else if (D == "s") { # success
		D = "v"
	} else if (D == "S") { # great success
		D = "V"
	} else if (D == "w") { # warning
		D = "!"
	} else if (D == "W") { # warning but not sure
		D = "?"
	} else if (D == "d") { # debug
		D = "*"
	} else if (D == "D") { # trace
		D = ">"
	} else if (D == "i") { # info
		D = "i"
	} else if (D == "I") { # verbose
		D = "."
	} else if (D == "l") { # log
		D = "%"
	} else if (D == "L") { # detailed log
		D = "$"
	} else if (D == "a") { # alert
		D = "@"
	} else if (D == "A") { # more info alert
		D = "&"
	} else {
		return "\0"
	}
	return nx_ansi_print("_uir%_UIR%<nx:null/>" D "<nx:null/>", "<nx:true/>")
}

function nx_fd_stderr(D)
{
	if (D) {
		gsub(/"/, "\\\"" D)
		system("printf \"" D "\" 1>&2")
	}
}

function nx_ansi_error(D1, B, D2)
{
	if (B == "<nx:true/>")
		B = "^E"
	else if (B == "<nx:false/>")
		B = "^e"
	else
		B = ""
	if (D2 == "<nx:true/>E")
		nx_ansi_print("<E_b" B "%<nx:null/>" D1)
	else if (D2 == "<nx:true/>e")
		nx_ansi_print("<e_b" B "%<nx:null/>" D1)
	else if (D2 == "<nx:false/>e")
		nx_ansi_print("e_b" B "%<nx:null/>" D1)
	else
		nx_ansi_print("E_b" B "%<nx:null/>" D1)
}

