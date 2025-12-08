#nx_include nex-log.awk
#nx_include nex-math-extras.awk

function __nx_ansi_templateA(D1, B, D2, D3,	l, u)
{
	l = tolower(D3)
	u = toupper(D3)
	if (B == "<nx:true/>")
		B = "^" u
	else if (B == "<nx:false/>")
		B = "^" l
	else
		B = ""
	if (D2 == "<nx:true/>" u)
		nx_ansi_print("<" u "_b" B "%<nx:null/>" D1)
	else if (D2 == "<nx:false/>" l)
		nx_ansi_print("<" l "_b" B "%<nx:null/>" D1)
	else if (D2 == "<nx:true/>" l)
		nx_ansi_print(l "_b" B "%<nx:null/>" D1)
	else
		nx_ansi_print(u "_b" B "%<nx:null/>" D1)
}

function __nx_ansi_templateB(D1, B, D2, D3,	l, u)
{
	l = tolower(D3)
	u = toupper(D3)
	if (B == "<nx:true/>")
		B = "^" u
	else if (B == "<nx:false/>")
		B = "^" l
	else
		B = ""
	if (D2 == "<nx:true/>" u)
		nx_ansi_print("b<" u "_b" B "%<nx:null/>" D1)
	else if (D2 == "<nx:false/>" l)
		nx_ansi_print("B<" l "_b" B "%<nx:null/>" D1)
	else if (D2 == "<nx:true/>" l)
		nx_ansi_print(l "_b" B "%<nx:null/>" D1)
	else
		nx_ansi_print(u "_b" B "%<nx:null/>" D1)
}

function __nx_ansi_templateC(D1, B, D2, D3,	l, u)
{
	l = tolower(D3)
	u = toupper(D3)
	if (B == "<nx:true/>")
		B = "^" u
	else if (B == "<nx:false/>")
		B = "^" l
	else
		B = ""
	if (D2 == "<nx:true/>" u)
		nx_ansi_print("l<" u "_b" B "%<nx:null/>" D1)
	else if (D2 == "<nx:false/>" l)
		nx_ansi_print("L<" l "_b" B "%<nx:null/>" D1)
	else if (D2 == "<nx:true/>" l)
		nx_ansi_print(l "_b" B "%<nx:null/>" D1)
	else
		nx_ansi_print(u "_b" B "%<nx:null/>" D1)
}

function nx_ansi_info(D1, B, D2)
{
	return __nx_ansi_templateA(D1, B, D2, "a")
}

function nx_ansi_debug(D1, B, D2)
{
	return __nx_ansi_templateA(D1, B, D2, "d")
}

function nx_ansi_dark(D1, B, D2)
{
	return __nx_ansi_templateC(D1, B, D2, "b")
}

function nx_ansi_light(D1, B, D2)
{
	return __nx_ansi_templateA(D1, B, D2, "l")
}

function nx_ansi_alert(D1, B, D2)
{
	return __nx_ansi_templateA(D1, B, D2, "a")
}

function nx_ansi_success(D1, B, D2)
{
	return __nx_ansi_templateA(D1, B, D2, "s")
}

function nx_ansi_warning(D1, B, D2)
{
	return __nx_ansi_templateB(D1, B, D2, "w")
}

function nx_log_db(N, D, B, V,		msg)
{
	if (0 in V)
		N = V[N "," nx_modulus_range(__nx_entropy(V[N]), V[N]) + 1]
	if (N != "") {
		B = split(D, msg, "<nx:null/>")
		for (D = 1; D <= B; D++) {
			if (! gsub("<nx:placeholder[ \t]+index=" D "[ \t]*/>", msg[D], N))
				sub("<nx:placeholder/>", msg[D], N)
		}
		gsub("<nx:placeholder.*/>", "", N)
		delete msg
		return N
	}
}

