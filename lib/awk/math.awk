function ones_compliment(N,     i, b, s) {
	if (N ~ __base_regex(1, "", 1)) {
		for (i = 1; i <= length(N); i++) {
                	s = substr(N, i ,1)
                	if (s ~ /[01]/) {
                		if (int(s))
                        		b = b "0"
                		else
                        		b = b "1"
			} else {
                        	b = b s
			}
        	}
        	return b
	}
}

function twos_compliment(N,     l, b, c, t) {
        if (l = length(N = ones_compliment(N))) {
        	c = 1
        	do {
                	b = substr(N, l)
			N = substr(N, 1, l - 1)
                	if (b ~ /[01]/) {
                		if (int(c + b) == 2) {
                        		t = "0" t
                		} else {
                        		t = N c t
                        		c = 0
				}
                        } else {
				t = b t
                	}
        	} while (c && --l)
        	return t
	}
}

function range(N, A, B)
{
        if ((length(A) && +N < +A) || (length(B) && +N > +B))
                return
        return N
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

function modulus_range(N1, N2, N3)
{
	return N3 % N2 + N1
}

function fibonacci(N, B,	n1, n2)
{
	if (is_integral(N) && N > 0) {
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

# N1:	base
# N2:	exponent
# N3:	modulus
function modular_exponentiation(N1, N2, N3,     r)
{
    	r = 1
    	while (N2 > 0) {
        	if (N2 % 2 == 1)
            		r = (r * N1) % N3
        	N1 = (N1 * N1) % N3
        	N2 = int(N2 / 2)
	}
	return r
}

# N:	Number to test
# T:	Trials to test number
# S: 	Separator of trial numbers to test number
function miller_rabin(N, T, S,   bases, t, d, s, a, x, i, j)
{
	if (is_integral(N)) {
		N = int(N)
		if (N < 2)
        		return 0
    		if (N <= 3)
        		return 1
		# Use Fermat's Little Theorem as an initial filter
    		if (! (N % 2 && N % 3) && (2 ** (N - 1) % N) != 1)
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

