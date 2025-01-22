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

function add_base(N1, N2, N3, B1, B2,         f1, f2, v1, v2, sn, sn1, sn2, t, tl, tn, f, fl, n, nb, nl, i, c, base_map)
{
	if ((N3 = __return_value(N3, 10)) <= 10) {
		if (0 N1 ~ __base_regex(N3 - 1, base_map, 1) && 0 N2 ~ __base_regex(N3 - 1, base_map)) {
                	if (sn1 = __get_sign(N1))
                	        N1 = substr(N1, 2)
                	if (sn2 = __get_sign(N2))
                	        N2 = substr(N2, 2)
                	if (__return_value(sn1, "+") == __return_value(sn2, "+")) {
                	        if((substr(sn1 sn2, 1, 1) == "+" || B1) && ! (length(B1) && B1 == 0))
                	                sn = "+"
				else if (substr(sn1 sn2, 1, 1) == "-")
					sn = "-"
                        	if (f1 = __get_half(N1, "."))
                        	        N1 = __get_half(N1, ".", 1)
                        	if (f2 = __get_half(N2, "."))
                        	        N2 = __get_half(N2, ".", 1)
                        	if (fl = absolute(length(f1) - length(f2))) {
                        	        t = match_length(f1  "," f2, 1)
                        	        tl = length(t)
                        		f = substr(t, 1, tl - fl)
                                	if (tn = t == f1)
                                	        f1 = f
                                	else
                                	        f2 = f
                                	f = substr(t, tl - fl + 1)
                        	}
				if (f) {
					if (B2)
						tl = f
                        		split(f1, v1, "")
                        		for (i = split(f2, v2, ""); i > 0; i--) {
                       	        		if ((t = c + v1[i] + v2[i]) > (N3 - 1)) {
                                        		f = int(t % N3) f
                        	                	c = int(t / N3)
                                		} else {
                                        		f = t f
                                        		c = 0
                                		}
                        		}
					if (B2) {
						if (tn)
							f1 = f1 tl
						else
							f2 = f2 tl
					}
				}
				N1 = __return_value(N1, "0")
				N2 = __return_value(N2, "0")
                        	if (tl = absolute(length(N1) - length(N2))) {
                        	        tn = substr(match_length(N1 "," N2, 1), 1, tl)
                        	}
                        	split(reverse_str(N1), v1, "")
                        	split(reverse_str(N2), v2, "")
				i = 1
                        	do {
                        	        if ((t = c + v1[i] + v2[i]) > (N3 - 1)) {
                        	                n = int(t % N3) n
                        	                c = int(t / N3)
                        	        } else {
                        	                n = t n
                        	                c = 0
                        	        }
                                	i++
                        	} while ((length(v1[i]) && length(v2[i])) || c)
                	} else {
                        	# TODO
                        	# N1 + -N2
                        	# -N1 + N2
                	}
                        delete v1
                        delete v2
		}
                delete base_map
                if (n = sn tn n __return_if_value(f, ".", 1)) {
			if (B2)
				printf("%s + %s = %s\n", sn1 N1 __return_if_value(f1, ".", 1), sn2 N2 __return_if_value(f2, ".", 1), n)
                	return n
		}
        }
}

