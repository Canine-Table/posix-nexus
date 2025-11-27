#nx_include nex-int.awk
#nx_include nex-log-extras.awk

function __nx_is_signed(N)
{
	return N ~ /^([-]|[+])/
}

function nx_not_zero(N, B)
{
	if (nx_digit(N, B) && +N != 0)
		return +N
}

function nx_ceiling(N)
{
	if (nx_digit_guard(N, 1) != -1) {
		if (+N > int(N))
			return int(N) + 1
		return int(N)
	}
}

function nx_floor(N)
{
	if (nx_digit_guard(N, 1) != -1) {
		if (+N < int(N))
			return int(N) - 1
		return int(N)
	}
}

function nx_round(N)
{
	if (nx_digit_guard(N, 1) != -1)
		return nx_floor(+N + 0.5)
}

function nx_trunc(N)
{
	if (nx_digit_guard(N, 1) != -1) {
		if (+N > 0)
			return nx_floor(N)
		return nx_ceiling(N)
	}
}

function nx_even(D)
{
	if ((D = nx_absolute(D)) < 0)
		return -1
	return D % 2 == 0
}

