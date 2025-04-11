function __nx_is_signed(N)
{
	return N ~ /^([-]|[+])/
}

function __nx_is_integral(N, B)
{
	return __nx_or(B, N ~ /^([-]|[+])?[0-9]+$/, N ~ /^[0-9]+$/)
}

function __nx_is_float(N, B)
{
	return __nx_or(B, N ~ /^([-]|[+])?[0-9]+[.][0-9]+$/, N ~ /^[0-9]+[.][0-9]+$/)
}

function __nx_is_digit(N, B1, B2)
{
	return (__nx_is_integral(N, B1) || __nx_is_float(N, __nx_else(B2, B1)))
}

function __nx_is_natural(N, B)
{
	return (__nx_is_integral(N, B) && N > 0)
}

function __nx_not_zero(N, B)
{
	if (__nx_is_digit(N, B) && N != 0)
		return N
}

function __nx_precision(N1, N2)
{
	if (__nx_is_digit(N1, 1)) {
		N1 = sprintf("%." __nx_if(__nx_is_integral(N2), N2, "") "f", N1)
		if (__nx_is_float(N1, 1))
			gsub(/(00+$)/, "", N1)
		return N1
	}
}

function nx_pi(N)
{
	return __nx_precision(__nx_if(__nx_is_integral(N), N, 10), atan2(0, -1))
}

function nx_tau(N)
{
	if (N = nx_pi(N))
		return N * 2
}

function __nx_base(D, V)
{
	if (D ~ /^[a-zA-Z]$/) {
		if (! (length(V) && "Z" in V))
			__nx_upper_map(V)
		D = V[D]
	}
	if (__nx_is_natural(D)) {
		D = int(D)
		if (D >= 2 && D <= 62)
			return D
	}
}

function __nx_get_base(N1, V)
{
	return __nx_else(__nx_base(N1, V), 10)
}

function nx_summation(N1, N2, i)
{
	if ((N1 = int(N1)) > (N2 = __nx_else(int(N2), 1)) && __nx_is_natural(N1)) {
		i = N2
		while (N1 > i)
			N2 += N1--
		return N2
	}
}

function nx_factoral(N,		n)
{
	if (__nx_is_integral(N = int(N))) {
		if (N < 2)
			return 1
		n = 1
		do {
			n = n * N
		} while (--N > 0)
		return n
	}
}

function nx_fibonacci(N, n1, n2)
{
	if (__nx_is_natural(N = int(N))) {
		while (--N > 0) {
			n2 += n1
			if (n2)
				n1 = n2
			else
				n2 = 1
		}
		return __nx_else(n2, "0")
	}
}

function nx_euclidean(N1, N2,	n) {
	if (__nx_is_natural(N1 = int(N1)) && __nx_is_natural(N2 = int(N2))) {
		while (N1) {
			n = N1
			N1 = N2 % N1
			N2 = n
		}
		return n
	}
}

function nx_lcd(N1, N2,		n)
{
	if (n = nx_euclidean(N1, N2))
		return N1 * N2 / n
}

function nx_absolute(N)
{
	if (__nx_is_digit(N, 1)) {
		if (__nx_equality(N, "<0", 0))
			return N * -1
		return N
	}
}

function nx_ceiling(N)
{
	if (__nx_is_digit(N, 1)) {
		if (N != int(N))
			return int(N) + 1
		return N
	}
}

function nx_round(N)
{
	return __nx_if(__nx_is_digit(N, 1), int(N + 0.5), 0)
}

function nx_floor(N)
{
	if (__nx_is_digit(N, 1))
		return int(N)
}


function nx_divisible(N1, N2)
{
	if (__nx_is_digit(N1, 1) && __nx_is_digit(N2, 1)) {
		return ! __nx_is_float(N1 / N2, 1)
	}
}

function nx_percent(N1, N2, B)
{
	if (__nx_is_digit(N1) && __nx_is_digit(N2)) {
		if (B)
			return N2 / (N1 / 100)
		else
			return N1 / 100 * N2
	}
}

function nx_scaled_ratio(N1, N2, N3)
{
	if (__nx_not_zero(N1 = N1 - N3, 1) && __nx_not_zero(N2 = N2 - N3))
		return N1 / N2
}

function nx_modulus_range(N1, N2, N3)
{
	if (__nx_is_digit(N1, 1)) {
		if (__nx_is_digit(N2, 1) && N1 < N2)
			return N2 + (N1 - N2 + N3) % (N3 - N2 + 1)
		if (__nx_is_digit(N3, 1) && N1 > N3)
			return N2 + (N1 - N2) % (N3 - N2 + 1)
		return N1
	}
}

function nx_modular_exponentiation(N1, N2,	r, n)
{
	r = 1
	n = 100000007
	while (N2 > 0) {
		if (N2 % 2 == 1)
			r = (r * N1) % n
		N1 = (N1 * N1) % n
		N2 = int(N2 / 2)
	}
	return r
}

function nx_fermats_little_theorm(N, V,		i, p)
{
	if (__nx_is_integral(N)) {
		if (N < 2)
			return
		if (! length(V))
		l = split("2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53", V, ",")
		for (i = 1; i <= l; i++) {
			if (! (nx_divisible(N, v[i]) && N == v[i])) {
				p = v[i]
				break
			}
		}
		delete v
		if (p)
			return nx_modular_exponentiation(p, N - 1) % N
	}
}

function __nx_millers_witnesses(N, S)
{
	if ((N = nx_floor(N)) > 1) {
		S = __nx_else(S, ",")
		if (N < 2047)
			return "2"
		if (N < 1373653)
			return "2" S "3"
		if (N < 9080191)
			return "31" S "73"
		if (N < 25326001)
			return "2" S "3" S "5"
		if (N < 3215031751)
			return "2" S "3" S "5" S "7"
		if (N < 4759123141)
			return "2" S "7" S "61"
		if (N < 1122004669633)
			return "2" S "13" S "23" S "1662803"
		if (N < 2152302898747)
			return "2" S "3" S "5" S "7" S "11"
		if (N < 3474749660383)
			return "2" S "3" S "5" S "7" S "11" S "13"
		if (N < 341550071728321)
			return "2" S "3" S "5" S "7" "11" S "13" S "17"
		if (N < 3825123056546413051)
			return "2" S "3" S "5" S "7" S "13" S "17" S "19" S "23"
		if (N < 318665857834031151167461)
			return "2" S "3" "5" S "7" S "11" S "13" S "17" S "19" S "23" S "29" S "31" S "37"
		return "2" S "3" S "5" S "7" S "11" S "13" S "17" S "19" S "23" S "29" S "31" S "37" S "41" S "43" S "47" S "53"
	}
}

function nx_miller_rabin(N, S,		v, t, d, s, a, x, i, j)
{
	if ((N = nx_floor(N)) > 1) {
		if ((N = int(N)) <= 3)
			return 1
		# Use Fermat's Little Theorem as an initial filter
		if (! (N % 2 && N % 3) && nx_fermats_little_theorm(N) == 0)
			return 0
		# Rewrite (N - 1) as d * 2^s
		d = N - 1
		s = 0
		while (d % 2 == 0) {
			d = d / 2
			s++
		}
		# Load prime bases witnesses on the range of N
		t = nx_trim_split(__nx_millers_witnesses(N, S), v, S)
		# Perform Miller-Rabin test for each base in v
		for (i = 1; i <= t; i++) {
			a = v[i]
			x = nx_modular_exponentiation(a, d, N)
			if (x == 1 || x == N - 1)
				continue
			for (j = 1; j < s; j++) {
				x = (x * x) % N
				if (x == N - 1)
					break
			}
			if (x != N - 1) {
				delete v
				return 0
			}
		}
		delete v
		return 1
	}
}

function __nx_base_regex(N, V, B,	r)
{
	if (N = __nx_get_base(N, V)) {
		if (N < 10) {
			if (B)
				__nx_num_map(V)
			r = "[0-" N "]+"
		} else if (N < 36) {
			if (B)
				__nx_lower_map(V)
			r = "[0-9a-" V[N] "]+"
		} else {
			if (B)
				__nx_upper_map(V)
			r = "[0-9a-zA-" V[N] "]+"
		}
		return "^([+]|[-])?" r "([.]" r ")?$"
	}
}

function __nx_base_logarithm(N1, N2)
{
	return log(__nx_base(N1)) / log(__nx_base(N2))
}

function __nx_number_map(V1, N1, V2, N2, N3)
{
	if (__nx_is_digit(N1, 1)) {
		if (! (length(V) && 0 in V))
			V[0] = 0
		if (! (__nx_is_natural(N3) && N3 in V))
			N3 = V[0] + 1
		N2 = __nx_get_base(N2, V2)
		if (N2 >= 2 && N2 <= 62) {
			if (N2 > 10 && N2 < 37)
				N1 = tolower(N1)
			if (__nx_is_signed(N1)) {
				V1[N3 "_sn"] = substr(N1, 1, 1)
				N1 = substr(N1, 2)
			}
			if (__nx_is_float(N1))
				V1[N3 "_flt"] = nx_cut_str(N1, "[.]", 0)
			V1[N3 "_num"] = __nx_else(nx_cut_str(N1, "[.]", 1), N1)
		}
	}
}

function __nx_construct_number(V, N, B1, B2, B3,	t)
{
	if (N "_num" in V) {
		if (B1)
			t = __nx_else(V[N "_num"], 0)
		if (B2)
			t = __nx_else(t, 0) __nx_if(V[N "_flt"], ".", "") __nx_if(V[N "_flt"])
		if (B3)
			t = __nx_else(V[N "_sn"], "+") t
		return t
	}
}

