#nx_include nex-misc.awk

function nx_bit_next(N, V, n)
{
	if (N > 0)
		return nx_bit_get(N, V) * 2
	n = nx_bit_get(-N, V) * 2
	return nx_bit_get(-n)
}

function nx_bit_round(N, V, n1, n2, b)
{
	if (b = N < 0)
		N = -N
	n1 = nx_bit_prev(N, V)
	n2 = nx_bit_next(N, V)
	if (N - n1 < n2 - N)
		N = n1
	else
		N = n2
	if (b)
		return nx_bit_get(-N, V)
	return N
}

function nx_bit_prev(N, V)
{
	if (N > 0)
		return nx_bit_get(N, V)
	return nx_bit_get(-nx_bit_get(-N, V))
}

function nx_bit_get(N, V, n, m, b, p)
{
	n = 1
	if ((N = int(N)) <= 1) {
		if (N == 0 || N == 1)
			return N
		N = -N
		p = 0
		do {
			m = N / 2
			N = int(m)
			if (m = N != m)
				V[p] = n
			b = m b
			++p
			n += n
		} while (N > 0)
		return b
	} else {
		N = int(N) + 1
	}
	do {
		m = n
		n += n
	} while (n < N)
	return m
}

function nx_bit_is(N1, N2)
{
	return int(+N1 / (+N2 + (+N2 == 0))) % 2 == 1
}

#	B	N2	result
#	1	1	1-1=0
#	1	0	1-0=1 set
#	0	0	0-0=0
#	0	1	0-1=-1 unset
function nx_bit_assign(N1, N2, B)
{
	return +N1 + ((B == 1) - nx_bit_is(N1, N2)) * N2
}

function nx_bit_on(N1, N2)
{
	return nx_bit_assign(N1, N2, 1)
}

function nx_bit_off(N1, N2)
{
	return nx_bit_assign(N1, N2, 0)
}

function nx_bit_flip(N1, N2)
{
	return nx_bit_assign(N1, N2, !nx_bit_is(N1, N2))
}

