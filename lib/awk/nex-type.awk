
function nx_is_space(D)
{
	return D ~ /[ \t\v]/
}

function nx_is_escape(D)
{
	return D ~ /^[\t\n\f\r\v\b]+$/
}

function nx_is_upper(D)
{
	return D ~ /^[A-Z]+$/
}

function nx_is_lower(D)
{
	return D ~ /^[a-z]+$/
}

function nx_is_digit(D)
{
	return D ~ /^[0-9]+$/
}

function nx_is_print(D)
{
	return D ~ /^[ -~]+$/
}

function nx_is_alpha(D)
{
	return D ~ /^[a-zA-Z]+$/
}

function nx_is_alnum(D)
{
	return D ~ /[a-zA-Z0-9]/
}

