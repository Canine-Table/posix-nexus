#nx_include nex-misc.awk

function nx_to_environ(D, B,	m)
{
	D = nx_trim_str(D)
	if (B)
		D = toupper(D)
	gsub(/[ \t]/, "_", D)
	if (! sub(/^[.]/, "L_", D))
	if (! sub(/^[*]/, "G_", D))
	if (! sub(/^[@]/, "NEXUS_", D))
	if (! sub(/^[%]/, "P_", D))
		sub(/^[0-9]/, "_\\&", D)
	gsub(/[^0-9A-Za-z_]/, "", D)
	return D
}

function __nx_stringify_var(D1, D2)
{
	gsub("'", "\x27\x22\x27\x22\x27", D1)
	gsub("^'|'$", "", D1)
	return nx_to_environ(D1) "='" D2 "' "
}

function __nx_elif(B1, B2, B3, B4, B5, B6)
{
	if (B4) {
		B5 = __nx_else(B5, B4)
		B6 = __nx_else(B6, B5)
	}
	return (__nx_defined(B1, B4) == __nx_defined(B2, B5) && __nx_defined(B3, B6) != __nx_defined(B1, B4))
}

function __nx_or(B1, B2, B3, B4, B5, B6)
{
	if (B4) {
		B5 = __nx_else(B5, B4)
		B6 = __nx_else(B6, B5)
	}
	return ((__nx_defined(B1, B4) && __nx_defined(B2, B5)) || (__nx_defined(B3, B6) && ! __nx_defined(B1, B4)))
}

function __nx_xor(B1, B2, B3, B4)
{
	if (B3)
		B4 = __nx_else(B4, B3)
	return ((! __nx_defined(B2, B4) && __nx_defined(B1, B3)) || (__nx_defined(B2, B4) && ! __nx_defined(B1, B3)))
}

