function __is_signed(D)
{
	return D ~ /^([-]|[+])/
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

function is_signed_integral(I,		e)
{
	if (__is_signed(I) && is_integral(I, 1))
		e = 1
	return e
}

function is_float(I, S,		e)
{
	if ((S && I ~ /^([-]|[+])?[0-9]+[.][0-9]+/) || (! S && I ~ /^[0-9]+[.][0-9]+/))
		e = 1
	return e
}

function is_signed_float(I,		e)
{
	if (__is_signed(I) && is_float(I, 1))
		e = 1
	return e
}

function is_digit(I, S,		e)
{
	if (is_integral(I, S) || is_float(I, S))
		e = 1
	return e
}

function is_signed_digit(I, 	e)
{
	if (__is_signed(I) && is_digit(I, 1))
		e = 1
	return e
}

