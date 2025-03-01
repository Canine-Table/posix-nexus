function __trim_precision(N1, N2)
{
	if (is_integral(N1 = __return_value(N1, 10)) && is_digit(N2, 1)) {
		N1 = sprintf("%." N1 "f", N2)
		gsub(/(00+$)/, "", N1)
		return N1
	}
}

function pi(N)
{
	return __trim_precision(N, atan2(0, -1))
}

function tau(N)
{
	return __trim_precision(N, 2 * atan2(0, -1))
}

function remainder(N1, N2)
{
	if ((N1 = (1 - (0 __return_if_value(__get_half(N1 / N2, "."), ".", 1))) * N2) < N2)
		return round(N1)
	return 0
}

function fibonacci(N, B,	n1, n2)
{
	if (__is_index(N)) {
		if (+N == 1)
			return 0
		else if (! int(n2))
			n2 = 1
		if (B)
			printf("%.f + %.f = %.f\n", 0 + n1, n2, n1 + n2)
		if (--N > 1)
			return fibonacci(N, b, n2, n2 + n1)
		else
			return sprintf("%.f", n1 + n2)
	}
}

function factoral(N, B,		n)
{
	if (is_integral(N) && is_integral(+n)) {
		if (N < 2) {
			return 1
		} else if (! length(n) || n  > 0) {
			if (! n)
				n = N - 1
			if (B)
				printf("%.f * %.f = %.f\n", N, n, N * n)
			return sprintf("%.f", factoral(N * n, B, n - 1))
		} else {
			return N
		}
	}
}

function absolute(N)
{
	if (N < 0)
		return N * -1
	return N
}

function ceiling(N)
{
	if (N != int(N))
		return int(N) + 1
	return N
}

function round(N)
{
	return int(N + 0.5)
}

# N1: The lower bound of the range
# N2: The upper bound of the range
# N3: The value to be distributed within the range
function distribution(N1, N2, N3)
{
	# Calculate the distribution value by dividing the difference between N1 and N3 by the difference between N2 and N3
	return ceiling((N1 - N3) / (N2 - N3))
}

function euclidean(N1, N2)
{
	if (is_digit(N1) && is_digit(N2)) {
		if (N2) {
			return euclidean(N2, N1 % N2)
		} else {
			return N1
		}
	}
}

function lcd(N1, N2)
{
	if (is_digit(N1) && is_digit(N2))
		return (N1 * N2) / euclidean(N1, N2)
}

# N1: The lower bound of the range
# N2: The upper bound of the range
# N3: The modulus value to adjust the lower bound
function modulus_range(N1, N2, N3)
{
	# If N1 is less than N2, adjust N1 to be within the range [N2, N3]
	if (N1 < N2)
		N1 = N2 + (N1 - N2 + N3) % (N3 - N2 + 1)
	# If N1 is greater than N3, adjust N1 similarly
	else if (N1 > N3)
		N1 = N2 + (N1 - N2) % (N3 - N2 + 1)
	# Return the adjusted value of N1
	return N1
}

# N1:	base
# N2:	exponent
# N3:	modulus
function modular_exponentiation(N1, N2, N3,	r)
{
	r = 1
	N3 = __return_value(N3, 100000007)
	while (N2 > 0) {
		if (N2 % 2 == 1)
			r = (r * N1) % N3
		N1 = (N1 * N1) % N3
		N2 = int(N2 / 2)
	}
	return r
}

function fermats_little_theorm(N,	v, i, p)
{
	if (is_integral(N)) {
		for (i = 1; i <= split("2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53", v, ","); i++) {
			if (! divisible(N, v[i], N)) {
				p = v[i]
				break
			}
		}
		delete v
		if (p) {
			return (p ** (N - 1)) % N
		}
	}
}

function divisible(N1, N2)
{
	if (is_integral(N1, 1) && is_integral(N2, 1)) {
		return ! is_float(N1 / N2, 1)
	}
}

# N:	Number to test
# T:	Trials to test number
# S:	Separator of trial numbers to test number
function miller_rabin(N, T, S,	 bases, t, d, s, a, x, i, j)
{
	if (is_integral(N)) {
		N = int(N)
		if (N < 2)
			return 0
		if (N <= 3)
			return 1
		# Use Fermat's Little Theorem as an initial filter
		if (! (N % 2 && N % 3) && fermats_little_theorm(N) == 0)
			return 0
		# Rewrite (N - 1) as d * 2^s
		d = N - 1
		s = 0
		while (d % 2 == 0) {
			d = d / 2
			s++
		}
		# Load prime bases based on the range of N or T
		t = trim_split(__return_value(T, __load_primes(N, S)), bases, S)
		# Perform Miller-Rabin test for each base in bases
		for (i = 1; i <= t; i++) {
			a = bases[i]
			x = modular_exponentiation(a, d, N)
			if (x == 1 || x == N - 1)
				continue
			for (j = 1; j < s; j++) {
				x = (x * x) % N
				if (x == N - 1)
					break
			}
			if (x != N - 1) {
				delete bases
				return 0
			}
		}
		delete bases
		return 1
	}
}

function __load_primes(N, S)
{
	if (is_integral(N) && (N = int(N)) > 1) {
		S = __return_value(S, ",")
		if (N < 2047)
			N = "2"
		else if (N < 1373653)
			N = "2" S "3"
		else if (N < 9080191)
			N = "31" S "73"
		else if (N < 25326001)
			N = "2" S "3" S "5"
		else if (N < 3215031751)
			N = "2" S "3" S "5" S "7"
		else if (N < 4759123141)
			N = "2" S "7" S "61"
		else if (N < 1122004669633)
			N = "2" S "13" S "23" S "1662803"
		else if (N < 2152302898747)
			N = "2" S "3" S "5" S "7" S "11"
		else if (N < 3474749660383)
			N = "2" S "3" S "5" S "7" S "11" S "13"
		else if (N < 341550071728321)
			N = "2" S "3" S "5" S "7" "11" S "13" S "17"
		else if (N < 3825123056546413051)
			N = "2" S "3" S "5" S "7" S "13" S "17" S "19" S "23"
		else if (N < 318665857834031151167461)
			N = "2" S "3" "5" S "7" S "11" S "13" S "17" S "19" S "23" S "29" S "31" S "37"
		else
			N = "2" S "3" S "5" S "7" S "11" S "13" S "17" S "19" S "23" S "29" S "31" S "37" S "41" S "43" S "47" S "53" 
		return N
	}
}

function random_prime(N, n)
{
	if (is_integral(N)) {
		if (N > 8)
			N = 8
		N = int(N)
		do {
			n = substr(entropy(N), 1, N)
		} while (! miller_rabin(n, "5,7,11,13,17,19,23,29,31,37,41,43,47,53"))
		return n
	}
}

