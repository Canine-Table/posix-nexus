#nx_include "nex-misc.awk"
#nx_include "nex-str.awk"

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

function __nx_is_signed(N)
{
	return N ~ /^([-]|[+])/
}

function __nx_is_integral(N, B)
{
	return __nx_if(B, N ~ /^([-]|[+])?[0-9]+$/, N ~ /^[0-9]+$/)
}

function __nx_is_float(N, B)
{
	return __nx_if(B, N ~ /^([-]|[+])?[0-9]+[.][0-9]+$/, N ~ /^[0-9]+[.][0-9]+$/)
}

function nx_natural(N, B)
{
	if (__nx_is_integral(N, B) && +N > 0)
		return +N
}

function nx_not_zero(N, B)
{
	if (nx_digit(N, B) && +N != 0)
		return +N
}

function nx_digit(N, B1, B2)
{
	if (__nx_is_integral(N, B1) || __nx_is_float(N, __nx_else(B2, B1)))
		return +N
}

function __nx_precision(N1, N2)
{
	if (nx_digit(N1, 1)) {
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

function nx_square_root(N,	n1, n2)
{
	if ((N = nx_digit(N)) >= 0) {
		n1 = N
		while (n1 * n1 > N)
			n1 = (n1 + N / n1) / 2
		n2 = n1
		while (n2 * n2 < n1)
			n2 = (n2 + n1) / 2
		return n2
	}
}

function nx_summation(N1, N2,	i)
{
	if ((N1 = int(N1)) > (N2 = __nx_else(int(N2), 1)) && nx_natural(N1)) {
		i = N2
		while (N1 > i)
			N2 += N1--
		return N2
	}
}

function nx_factoral(N,		n)
{
	if (__nx_is_integral(N = nx_digit(N))) {
		if (N < 2)
			return 1
		n = 1
		do {
			n = n * N
		} while (--N > 0)
		return n
	}
}

function nx_fibonacci(N,	n1, n2, n3)
{
	if (nx_natural(N = int(N))) {
		while (--N > 0) {
			n3 = n2
			n2 = n1 + n2
			if (n2)
				n1 = n3
			else
				n2 = 1
		}
		return __nx_else(n2, "0")
	}
}

function nx_euclidean(N1, N2,	n) {
	if (nx_natural(N1 = int(N1)) && nx_natural(N2 = int(N2))) {
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
	if (nx_digit(N, 1)) {
		if (__nx_equality(N, "<0", 0))
			return N * -1
		return N
	}
}

function nx_ceiling(N)
{
	if (N = nx_digit(N, 1)) {
		if (N > int(N))
			return int(N) + 1
		return int(N)
	}
}

function nx_floor(N)
{
	if (N = nx_digit(N, 1)) {
		if (N < int(N))
			return int(N - 1)
		return int(N)
	}
}

function nx_round(N)
{
	if (N = nx_digit(N, 1))
		return nx_floor(N + 0.5)
}

function nx_trunc(N)
{
	if (N = nx_digit(N, 1)) {
		if (N > 0)
			return nx_floor(N)
		return nx_ceiling(N)
	}
}

function nx_divisible(N1, N2)
{
	if (nx_digit(N1, 1) && nx_digit(N2, 1))
		return ! __nx_is_float(N1 / N2, 1)
}

function nx_percent(N1, N2, B)
{
	if ((N1 = nx_digit(N1)) && (N2 = nx_digit(N2))) {
		if (B)
			return N2 / (N1 / 100)
		else
			return N1 / 100 * N2
	}
}

function nx_remainder(N1, N2)
{
	if (nx_digit(N1) && nx_natural(N2))
		return (N2 - N1 % N2) % N2
}

function nx_generator(V, N1, N2, N3, B1, B2)
{
	if (! (length(V) && 0 "_idx" in V) && (N1 = nx_digit(N1, 1)) != "") {
		N2 = __nx_else(nx_digit(N2, 1), 0)
		N3 = __nx_else(nx_not_zero(N3, 1), 1)
		if (N1 > N2) {
			N3 = nx_absolute(N3)
			V[0 "_cmp"] = "<=0"
		} else if (N2 > N1) {
			N3 = -nx_absolute(N3)
			V[0 "_cmp"] = ">=0"
		} else {
			return "" N2
		}
		V[0 "_ed"] = N1
		V[0 "_st"] = N2
		V[0 "_idx"] = V[0 "_st"]
		V[0 "_sk"] = N3
		if (B1 != "")
			delete V[0 "_cmp"]
		else
			delete V[0 "_st"]
		return "" V[0 "_idx"]
	} else {
		if (! (0 "_cmp" in V)) {
			if (B1 == 0)
				return "" (V[0 "_idx"] = V[0 "_idx"] + V[0 "_sk"])
			return "" (V[0 "_idx"] = nx_modulus_range(V[0 "_idx"], V[0 "_ed"], V[0 "_st"], V[0 "_sk"]))
		} else if (i = __nx_equality((V[0 "_idx"] = V[0 "_idx"] + V[0 "_sk"]), V[0 "_cmp"], V[0 "_ed"])) {
			return "" V[0 "_idx"]
		} else if (B2) {
			delete V
		}
	}
}

function nx_scaled_ratio(N1, N2, N3)
{
	if (nx_not_zero(N1 = N1 - N3, 1) && nx_not_zero(N2 = N2 - N3))
		return N1 / N2
}

function nx_modulo(N1, N2)
{
	if (nx_not_zero((N2 = nx_digit(N2, 1))) != "" && (N1 = nx_digit(N1, 1)))
		return N1 - nx_trunc(N1 / N2) * N2
}

function nx_modulus_range(N1, N2, N3, N4)
{
	if ((N1 = nx_digit(N1, 1)) != "") {
		if ((N2 = nx_digit(N2, 1)) != "") {
			if ((N3 = nx_digit(N3, 1)) == "")
				return N1 % N2
			N2 = N2 - N3
			return (N1 - N3 + (__nx_else(nx_digit(N4, 1), 0) % N2) + N2) % N2 + N3
		}
		return N1
	}
}

function nx_modular_exponentiation(N1, N2,	r, n, b)
{
	if ((N1 = nx_digit(N1, 1)) != "") {
		if ((N2 = nx_digit(N2, 1)) != "") {
			if (N1 == 0)
				return 0
			if (N2 == 0)
				return 1
			if (N2 < 0) {
				N2 = nx_absolute(N2)
				b = 1
			}
			r = 1
			n = 100000007
			N1 = (N1 % n) + n
			while (N2 > 0) {
				if (N2 % 2 == 1)
					r = (r * N1) % n
				N1 = (N1 * N1) % n
				N2 = int(N2 / 2)
			}
			if (b)
				return 1.0 / r
			return r
		}
	}
}

function nx_fermats_little_theorm(N, V, B,		i, p, l)
{
	if (__nx_is_integral(N)) {
		if ((N = int(N)) < 2)
			return
		if (! (l = length(V)))
			l = split("2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53", V, ",")
		for (i = 1; i <= l; i++) {
			if (! (nx_divisible(N, V[i]) && N == V[i])) {
				p = V[i]
				break
			}
		}
		if (B)
			delete V
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

function __nx_entropy(N,	s)
{
	if (s = nx_convert_base(nx_random_str(N, "alnum"), 62, 10))
		return substr(s, 1, N)
}

function nx_prime(N,	n)
{
	if (nx_natural(N = nx_digit(N, 1))) {
		do {
			n = substr(__nx_entropy(N), 1, N)
		} while (! nx_miller_rabin(n))
		return n
	}
}

function __nx_base(D, V)
{
	if (D ~ /^[a-zA-Z]$/) {
		if (! (length(V) && "Z" in V))
			__nx_upper_map(V)
		D = V[D]
	}
	if (nx_natural(D)) {
		D = int(D)
		if (D >= 2 && D <= 62)
			return D
	}
}

function __nx_load_base(N, V)
{
	if (N > 36 && ! ("Z" in V))
		__nx_upper_map(V)
	else if (N > 10 && ! ("z" in V))
		__nx_lower_map(V)
	else if (! (9 in V))
		__nx_num_map(V)
}

function __nx_get_base(N, V)
{
	return __nx_else(__nx_base(N, V), 10)
}

function __nx_base_regex(N, V, B)
{
	if (N = __nx_get_base(N, V)) {
		if (N < 10) {
			if (B)
				__nx_num_map(V)
			B = "[0-" N "]+"
		} else if (N < 36) {
			if (B)
				__nx_lower_map(V)
			B = "[0-9a-" V[N] "]+"
		} else {
			if (B)
				__nx_upper_map(V)
			B = "[0-9a-zA-" V[N] "]+"
		}
		return "^([+]|[-])?" B "([.]" B ")?$"
	}
}

function __nx_base_logarithm(N1, N2)
{
	return log(__nx_base(N1)) / log(__nx_base(N2))
}

function __nx_bit_width(N)
{
	return nx_ceiling(__nx_base_logarithm(N, 2))
}

function __nx_pad_bits(V, N1, N2)
{
	if (N1 "_bs" in V && V[N1 "_bs"] == 2 && nx_natural(N2)) {
		N2 = __nx_bit_width(N2)
		if (N1 "_num" in V && V[N1 "_num"]) {
			V[N1 "_num"] = nx_append_str("0", nx_remainder(length(V[N1 "_num"]), N2)) V[N1 "_num"]
		}
		if (N1 "_flt" in V && V[N1 "_flt"])
			V[N1 "_flt"] = V[N1 "_flt"] nx_append_str("0", nx_remainder(length(V[N1 "_flt"]), N2))
	}
}

function __nx_reuse_number(N1, V1, N2, V2)
{
	return nx_natural(N1) && N1 "_bs" in V1 && V1[N1 "_bs"] == __nx_get_base(N2, V2)
}

function nx_number_map(V1, N1, V2, N2, N3,	b)
{
	if (! (length(V1) && 0 in V1))
		V1[0] = 0
	if (! (nx_natural(N3) && N3 <= V1[0]))
		N3 = V1[0] + 1
	else
		b = 1
	N2 = __nx_get_base(N2, V2)
	if (N2 >= 2 && N2 <= 62) {
		__nx_load_base(N2, V2)
		if (N2 > 10 && N2 < 37)
			N1 = tolower(N1)
		if (N1 ~ __nx_base_regex(N2 - 1, V2)) {
			V1[N3 "_bs"] = N2
			if (__nx_is_signed(N1)) {
				V1[N3 "_sn"] = substr(N1, 1, 1)
				N1 = substr(N1, 2)
			}
			if (__nx_is_float(N1))
				V1[N3 "_flt"] = nx_cut_str(N1, "[.]", 0)
			V1[N3 "_num"] = __nx_else(nx_cut_str(N1, "[.]", 1), N1)
			if (! b)
				V1[0] = N3
			return V1[0]
		}
	}
}

function nx_number(V, N, B1, B2, B3,	t)
{
	if (length(V) && 0 in V) {
		if (__nx_is_integral(N, 1) && __nx_is_signed(N)) {
			sub(/[+]/, "", N)
			N = nx_modulus_range(V[0] + N, 1, V[0])
		} else {
			N = __nx_else(N, V[0])
		}
		if (N "_num" in V && B1)
			t = __nx_else(V[N "_num"], 0)
		if (N "_flt" in V && B2)
			t = __nx_else(t, 0) __nx_if(V[N "_flt"], "." V[N "_flt"], "")
		if (N "_sn" in V && B3)
			t = __nx_else(V[N "_sn"], "") t
		return t
	}
}

function nx_compliment(N1, N2, V1, V2, N3,	i, v, n, l)
{
	if (N2 = __nx_get_base(N2, V2)) {
		if (! __nx_reuse_number(N3, V1, N2, V2))
			N3 = nx_number_map(V1, N1, V2, N2)
		if (N3) {
			N2 = N2 - 1
			l = split(nx_number(V1, N3, 1, 1, 1), v, "")
			for (i = 1; i <= l; i++) {
				if (v[i] ~ /[.]|[+]|[-]/)
					n = n v[i]
				else
					n = n V2[N2 - v[i]]
			}
			delete v
			nx_number_map(V1, n, V2, N2 + 1, N3)
			return n
		}
	}
}

function nx_convert_base(N1, N2, N3, N4, V1, V2, N5,	v, l, n, i, j)
{
	if (N3 = __nx_get_base(N3, V2)) {
		if (! N5)
			N5 = nx_number_map(V1, N1, V2, N2)
		if (N5) {
			if (V1[N5 "_bs"] != N3) {
				__nx_load_base(N3, V2)
				N4 = __nx_else(nx_floor(N4), 64)
				if (V1[N5 "_bs"] != 10) {
					l = split(V1[N5 "_num"], v, "")
					for (i = l; i > 0; i--) {
						n = __nx_precision(n + nx_modular_exponentiation(V2[v[++j]] * V1[N5 "_bs"], i - 1))
					}
					V1[N5 "_num"] = n
					n = 0
					if (N5 "_flt" in V1 && nx_natural(V1[N5 "_flt"])) {
						l = split(V1[N5 "_flt"], v, "")
						for (i = 1; i <= l; i++)
							n = __nx_precision(n + V2[v[i]] * nx_modular_exponentiation(V1[N5 "_bs"], -i), N4)
						V1[N5 "_flt"] = substr(n, 3)
					}
				}
				if (N3 != 10) {
					n = ""
					do {
						n = V2[int(V1[N5 "_num"] % N3)] n
						V1[N5 "_num"] = V1[N5 "_num"] / N3
					} while (int(V1[N5 "_num"]))
					V1[N5 "_num"] = n
					n = ""
					if (N5 "_flt" in V1 && nx_natural(V1[N5 "_flt"])) {
						j = N4
						V1[N5 "_flt"] = "0." V1[N5 "_flt"]
						do {
							n = n V2[i = int(V1[N5 "_flt"] = V1[N5 "_flt"] * N3)]
						} while((V1[N5 "_flt"] = V1[N5 "_flt"] - i) > 0.01 && --j)
						V1[N5 "_flt"] = n
					}
				}
				delete v
				V1[N5 "_bs"] = N3
				return nx_number(V1, N5, 1, 1, 1)
			}
		}
	}
}

function nx_add(N1, N2, N3, N4, V1, V2, N5, N6,		j, i, c, d, e, v1, v2)
{
	if (N3 = __nx_get_base(N3, V2)) {
		if (! __nx_reuse_number(N5, V1, N3, V2))
			N5 = nx_number_map(V1, N1, V2, N3)
		if (! __nx_reuse_number(N6, V1, N3, V2))
			N6 = nx_number_map(V1, N2, V2, N3)
		if (N5 && N6) {
			if (__nx_else(V1[N5 "_sn"], "+") == __nx_else(V1[N6 "_sn"], "+")) {
				V1[N5 "_sn"] = substr(V1[N5 "_sn"] V1[N6 "_sn"], 1, 1)
				d = nx_same_length(N5 "_flt", N6 "_flt", V1, 0, 1)
				if (split(V1[N5 "_flt"], v1, "")) {
					for (i = split(V1[N6 "_flt"], v2, ""); i > 0; i--) {
						if ((j = c + V2[v1[i]] + V2[v2[i]]) > (N3 - 1))
							c = int(j / N3)
						else
							c = 0
						d = V2[int(j % N3)] d
					}
				}
				V1[N5 "_flt"] = d
				if ((j = split(nx_reverse_str(V1[N5 "_num"]), v1, "") - split(nx_reverse_str(V1[N6 "_num"]), v2, "")) > 0)
					e = V1[N5 "_num"]
				else if (j < 0)
					e = V1[N6 "_num"]
				V1[N5 "_num"] = ""
				i = 1
				do {
					if ((j = c + V2[v1[i]] + V2[v2[i]]) > (N3 - 1))
						c = int(j / N3)
					else
						c = 0
					++i
					V1[N5 "_num"] = V2[int(j % N3)] V1[N5 "_num"]
				} while (c || (v1[i] != "" && v2[i] != ""))
				if ((j = length(e) - i + 1) > 0)
					V1[N5 "_num"] = substr(e, 1, j) V1[N5 "_num"]
				delete v1
				delete v2
				nx_pop_vector("_bs,_flt,_num,_sn", V1, ",")
				return nx_number(V1, N5, 1, 1, 1)
			} else {
				# TODO
				if (__nx_equality(nx_number(V1, N5, 1, 1), ">0", nx_number(V1, N6, 1, 1)))
					V1[N5 "_sn"] = V1[N6 "_sn"]
				else
					V1[N6 "_sn"] = V1[N5 "_sn"]
				return nx_subtract(0, 0, N3, N4, V1, V2, N5, N6)
			}
		}
	}
}

function nx_subtract(N1, N2, N3, N4, V1, V2, N5, N6,	sn, j, i, f, c, d, e, v1, v2)
{
	if (N3 = __nx_get_base(N3, V2)) {
		if (! __nx_reuse_number(N5, V1, N3, V2))
			N5 = nx_number_map(V1, N1, V2, N3)
		if (! __nx_reuse_number(N6, V1, N3, V2))
			N6 = nx_number_map(V1, N2, V2, N3)
		if (N5 && N6) {
			if (__nx_else(V1[N5 "_sn"], "+") != __nx_else(V1[N6 "_sn"], "+")) {
				V1[N6 "_sn"] = V1[N5 "_sn"]
				return nx_add(0, 0, N3, N4, V1, V2, N5, N6)
			} else {
				if (__nx_equality(V1[N5 "_num"], "<0", V1[N6 "_num"])) {
					__nx_swap(V1, N5 "_flt", N6 "_flt")
					__nx_swap(V1, N5 "_num", N6 "_num")
					sn = __nx_if(V1[N5 "_sn"] == "-", "", "-")
				} else {
					sn = V1[N5 "_sn"]
				}
				nx_convert_base(N1, N3, 2, N4, V1, V2, N5)
				__nx_pad_bits(V1, N5, N3)
				nx_convert_base(N2, N3, 2, N4, V1, V2, N6)
				__nx_pad_bits(V1, N6, N3)
				if ((i = length(V1[N5 "_num"]) - length(V1[N6 "_num"])) > 0)
					V1[N6 "_num"] = nx_append_str("0", i) V1[N6 "_num"]
				else if (i = nx_absolute(i))
					V1[N5 "_num"] = nx_append_str("0", i) V1[N5 "_num"]
				if ((i = length(V1[N5 "_flt"]) - length(V1[N6 "_flt"])) > 0)
					V1[N6 "_flt"] = nx_append_str("0", i) V1[N6 "_flt"]
				else if (i = nx_absolute(i))
					V1[N5 "_flt"] = nx_append_str("0", i) V1[N5 "_flt"]
				i = length(V1[N5 "_num"])
				nx_compliment(0, 2, V1, V2, N6)
				nx_add(0, 1, 2, N4, V1, V2, N6)
				nx_add(0, 0, 2, N4, V1, V2, N5, N6)
				V1[N5 "_num"] = substr(V1[N5 "_num"], length(V1[N5 "_num"]) - i + 1)
				V1[N5 "_sn"] = sn
				nx_convert_base(0, 2, N3, N4, V1, V2, N5)
				return nx_number(V1, N5, 1, 1, 1)
			}
		}
	}
}

