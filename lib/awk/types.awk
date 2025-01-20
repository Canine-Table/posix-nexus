function __is_signed(N)
{
	return N ~ /^([-]|[+])/
}

function __get_sign(N)
{
	if (__is_signed(N)) {
		return substr(N, 1, 1)
	}
}

function is_integral(N, B,	e)
{
	if ((B && N ~ /^([-]|[+])?[0-9]+$/) || (! B && N ~ /^[0-9]+$/))
		e = 1
	return e
}

function is_signed_integral(N,		e)
{
	if (__is_signed(N) && is_integral(N, 1))
		e = 1
	return e
}

function is_float(N, B,		e)
{
	if ((B && N ~ /^([-]|[+])?[0-9]+[.][0-9]+/) || (! B && N ~ /^[0-9]+[.][0-9]+/))
		e = 1
	return e
}

function is_signed_float(N,		e)
{
	if (__is_signed(N) && is_float(N, 1))
		e = 1
	return e
}

function is_digit(N, B,		e)
{
	if (is_integral(N, B) || is_float(N, B))
		e = 1
	return e
}

function is_signed_digit(N, 	e)
{
	if (__is_signed(N) && is_digit(N, 1))
		e = 1
	return e
}

