#nx_include nex-misc.awk
#nx_include nex-struct.awk
#nx_include nex-log.awk
#nx_include nex-str.awk

# Difference = Minuend - Subtrahend
#
# Sum = Addend + Addend
# Product = Factor * Factor
# Power = Base ** Exponent
#
# Quotient = Dividend / Divisor
# Quotient = (Dividend - Remainder) / Divisor
# Dividend = (Divisor * Quotient) + Remainder
# Remainder = Dividend % Divisor

function __nx_is_integral(N, B)
{
	return __nx_if(B, N ~ /^([-]|[+])?[0-9]+$/, N ~ /^[0-9]+$/)
}

function __nx_is_float(N, B)
{
	return __nx_if(B, N ~ /^([-]|[+])?[0-9]+[.][0-9]+$/, N ~ /^[0-9]+[.][0-9]+$/)
}

function nx_digit(N, B1, B2)
{
	if (__nx_is_integral(N, B1) || __nx_is_float(N, __nx_else(B2, B1)))
		return +N
}

# N = number
# S = sep
# B1 = signage
# B2 = type
function nx_digit_guard(D1, B1, B2, D2, B3, B4, V,	trk)
{
	if (B4 == "") {
		nx_trim_split(D1, V, D2)
	} else {
		V[0] = 1
		V[1] = D1
	}
	B2 = int(B2)
	B1 = int(B1)
	trk["nm"] = __nx_if(B1 == 1 || B1 == 2, "optional signed", "required unsigned")
	trk["flt"] = __nx_if(B1 == 1 || B1 == 3, "optional signed", "required unsigned")
	trk["err"] = 0
	for (D1 = 1; D1 <= V[0]; ++D1) {
		if (B2 == 2 && ! __nx_is_integral(V[D1], trk["nm"] == "optional signed")) {
			nx_ansi_error(V[D1] " is not a valid " trk["nm"] " integral!\n")
			nx_replace_pop(V, D1)
			trk["err"]--
		} else if (B2 == 3 && ! __nx_is_float(V[D1], trk["flt"] == "optional signed")) {
			nx_ansi_error(V[D1] " is not a valid " trk["flt"] " floating point digit!\n")
			nx_replace_pop(V, D1)
			trk["err"]--
		} else if (! nx_digit(V[D1], B1, B2)) {
			nx_ansi_error(V[D1] " is not a valid " trk["nm"] "integral, nor is it a valid " trk["flt"] " floating point digit!\n")
			nx_replace_pop(V, D1)
			trk["err"]--
		}
	}
	if (! B3 || (B3 == 2 && trk["err"] < 0))
		delete V
	D1 = trk["err"]
	delete trk
	return D1
}

function nx_absolute(N)
{
	if (nx_digit_guard(N, 1) < 0)
		return -1
	if (__nx_equality(N, "<0", 0))
		return -N
	return +N
}

function nx_natural(N, B)
{
	if (__nx_is_integral(N, B) && +N > 0)
		return +N
}

