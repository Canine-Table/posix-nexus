# N:   The base for which the regular expression is to be generated.
# V:   A mapping array used for generating the regular expression.
# B:   A flag indicating whether to load the number, lower, or upper map.
function __base_regex(N, V, B, rg)
{
        if (is_integral(N)) {  # Check if N is an integral value
                N = int(N)
                if (N < 10) {
                        if (B)
                                __load_num_map(V)  # Load number map if B is true
                        rg = "[0-" V[N] "]+"  # Generate regex for base less than 10
                } else if (N < 36) {
                        if (B)
                                __load_lower_map(V)  # Load lower map if B is true
                        rg = "[0-9a-" V[N] "]+"  # Generate regex for base between 10 and 36
                } else {
                        if (B)
                                __load_upper_map(V)  # Load upper map if B is true
                        rg = "[0-9a-zA-" V[N] "]+"  # Generate regex for base greater than 36
                }
                return "^([+]|[-])?" rg "([.]" rg ")?$"  # Return the complete regex
        }
}

function __load_num_map(V,  i)
{
        for (i = 0; i < 10; i++)
                V[i] = i
}

function __load_lower_map(V,        i)
{
	__load_num_map(V)
        for (i = 10; i < 36; i++) {
                V[i] = sprintf("%c", i + 87)
                V[V[i]] = i
        }
}

function __load_upper_map(V,        i)
{
        __load_lower_map(V)
        for (i = 36; i < 62; i++) {
                V[i] = sprintf("%c", i + 29)
                V[V[i]] = i
        }
}

function __get_base(D, V)
{
	if (D ~ /^[a-zA-Z]$/) 
		D = V[D]
	return D
}

# N: The number to be converted.
# F: The base of the input number N.
# T: The base to convert the number N to.
function convert_base(N, F, T, 	base_map, sn, l, f, n, c, cv)
{
	__load_upper_map(base_map)
	F = int(__get_base(F, base_map))
	T = int(__get_base(T, base_map))
	if (T >= 2 && T <= 62) {
		if (F > 9 && F < 36)
			N = tolower(N)
		if (N ~ __base_regex(F - 1, base_map)) {
			if (F == T)
				return N
			if (sn = __get_sign(N))
				N = substr(N, 2)
			if (f = __get_half(N, ".", 0, 0))
				N = __get_half(N, ".", 1)
			if (F == 10) {
				if (f)
					f = "0" f
				cv = N
			} else {
				l = length(N)
				do {
					n = sprintf("%.f", n + base_map[substr(N, ++c, 1)] * F ** (l - 1))
				} while (--l)
				cv = n
				if (f) {
					n = "0" f
					f = 0
					for (l = 1; l <= length(n); l++) {
                                        	f = sprintf("%.64f", f + base_map[substr(n, 3, 1)] * (F ** -l))
					}
					sub(/00+$/, "", f)
				}
			}
			if (T == 10) {
				if ((f = __get_half(f, ".", 0)) > 0)
					cv = cv "." f
				return sn cv
			} else {
				n = ""
				do {
                                        n = base_map[int(cv % T)] n
                                        cv = cv / T
                                } while (int(cv))
				cv = n
				if (f) {
					cv = cv "."
					do {
                                                cv = cv base_map[n = int(f = f * T)]
					} while(f -= n)
				}
				return sn cv
			}
		}
	}
}

