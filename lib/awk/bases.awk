# __load_number_map: Load numbers into a map V1 based on the specified base N2 and value N1
function __load_number_map(V1, N1, V2, N2, 	idx)
{
        if (N1) {
                # Initialize V1[0] to 0 if not already set
                if (! (0 in V1)) {
                        split("", V1, "")
                        V1[0] = 0
                }
                # Increment index for storing new number
                idx = V1[0] + 1
                # Convert N2 to an integer base
                N2 = int(__get_base(__return_value(N2, 10), V2))
                # Check if N2 is within a valid range (2 to 62)
                if (N2 >= 2 && N2 <= 62) {
                        # Convert N1 to lowercase if base is between 11 and 36
                        if (N2 > 10 && N2 < 37)
                                N1 = tolower(N1)
                        # Store the sign of N1
                        if (V1["sn" idx] = __get_sign(N1))
                                N1 = substr(N1, 2)
                        # Check if N1 is a valid number in the given base
                        if (0 N1 0 ~ __base_regex(N2 - 1, V2)) {
                                V1[0] = idx
                                V1["bs" idx] = N2
                                # Store the integer part of N1
                                if (! (V1["n" idx] = __return_value(__get_half(N1, ".", 1), 0)))
                                        V1["n" idx] = N1
                                # Store the fractional part of N1, if it exists
                                else
                                        V1["f" idx] = __get_half(N1, ".")
                        }
		}
        } else {
		idx = V1[0]
	}
	if (idx) {
        	# Reconstruct N1 with its sign and fractional part, if any
        	if ((N1 = V1["n" idx] __return_if_value(V1["f" idx], ".", 1)) != 0)
                	N1 = V1["sn" idx] N1
        	return N1
	}
}

function __get_base(D, V)
{
	if (! is_array(V))
		__load_upper_map(V)
	if (D ~ /^[a-zA-Z]$/)
		D = V[D]
	if (D >= 2 && D <= 62)
		return D
}

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

function __base_logarithm(N1, N2)
{
	return log(N1) / log(N2)
}

function __bit_width(N)
{
	return ceiling(__base_logarithm(N, 2))
}

function __pad_bits(N1, N2)
{
	if (+N2 > 1)
		N1 = append_str(length(N1) % __bit_width(N2), "0") N1
	return N1
}

# N1: The number to be converted.
# N2: The base of the input number N.
# N3: The base to convert the number N to.
# N4: The precision (default: 32)
function convert_base(N1, N2, N3, N4,	base_map, num_map, n, cv, i, v, j)
{
	# Ensure the target base N3 is between 2 and 62
	if (N3 = int(__return_value(__get_base(N3, base_map), 10))) {
		# Ensure input base is valid to prevent
		if (cv = __load_number_map(num_map, N1, base_map, N2)) {
			# No conversion needed if ibase equals obase
			if (num_map["bs1"] != N3) {
				# if ibase is not base 10, convert it to base 10
				if (num_map["bs1"] != 10) {
					for (i = split(num_map["n1"], v, ""); i > 0; i--) {
						n = sprintf("%.f", n + base_map[v[++j]] * num_map["bs1"] ** (i - 1))
					}
					num_map["n1"] = n
					n = 0
					for (i = 1; i <= split(num_map["f1"], v, ""); i++) {
						n = sprintf("%.501f", n + base_map[v[i]] * (num_map["bs1"] ** -i))
					}
					sub(/0+$/, "", n)
					num_map["f1"] = substr(n, 3)
					n = ""
				}
				if (N3 != 10) {
					do {
                                        	n = base_map[int(num_map["n1"] % N3)] n
                                        	num_map["n1"] = num_map["n1"] / N3
                                	} while (int(num_map["n1"]))
					num_map["n1"] = n
					if (num_map["f1"] = __return_if_value(num_map["f1"], "0.", 1)) {
						n = ""
						j = __return_value(int(N4), 32)
						do {
                                               		n = n base_map[i = int(num_map["f1"] = num_map["f1"] * N3)]
						} while((num_map["f1"] = num_map["f1"] - i) > 0.01 && --j)
						num_map["f1"] = n
					}
				}
				delete v
				cv = __load_number_map(num_map)
			}
		} else {
			cv = ""
		}
		delete num_map
	}
	delete base_map
	return cv
}

function base_compliment(N1, N2,	base_map, num_map, i, v, n)
{
	if (N2 = int(__return_value(__get_base(N2, base_map), 10))) {
		if (N1 = __load_number_map(num_map, N1, base_map, N2)) {
			delete num_map
			for (i = 1; i <= split(N1, v, ""); i++) {
				if (v[i] ~ /[.]|[+]|[-]/)
					n = n v[i]
				else
					n = n base_map[N2 - base_map[v[i]]]
			}
			delete v
			delete base_map
			return n
		}
	}
}

function __numbers_length(V, N1, N2,	t1, t2, t3, t4)
{
	if (t1 = absolute(length(V[N1]) - length(V[N2]))) {
                t2 = match_length(V[N1] "," V[N2], 1)
		t3 = length(t2)
		t4 = substr(t2, 1, t3 - t1)
		if (t2 == V[N1])
			V[N1] = t4
		else
			V[N2] = t4
		return substr(t2, t3 - t1 + 1)
	}
}

function __add_base(N1, N2, N3, B1, B2,         num_map, base_map, sn, f, n, c, t1, t2, t3, t4, v1, v2, i)
{
	if (N3 = int(__return_value(__get_base(N3, base_map), 10))) {
		if (__load_number_map(num_map, N1, base_map, N3) && __load_number_map(num_map, N2, base_map, N3)) {
                	if (__return_value(num_map["sn1"], "+") == __return_value(num_map["sn2"], "+")) {
				sn = substr(num_map["sn1"] num_map["sn2"], 1, 1)
                        	if (t1 = absolute(length(num_map["f1"]) - length(num_map["f2"]))) {
                        	        t2 = match_length(num_map["f1"] "," num_map["f2"], 1)
                        	        t3 = length(t2)
                        		f = substr(t2, 1, t3 - t1)
                                	if (t4 = t2 == t1)
                                	        num_map["f1"] = f
                                	else
                                		num_map["f2"] = f
                                	f = substr(t2, t3 - t1 + 1)
				}
				if (split(num_map["f1"], v1, "")) {
                        		for (i = split(num_map["f2"], v2, ""); i > 0; i--) {
                       	        		if ((t1 = c + base_map[v1[i]] + base_map[v2[i]]) > (N3 - 1)) {
                                        		f = base_map[int(t1 % N3)] f
                        	                	c = int(t1 / N3)
                                		} else {
                                        		f = base_map[t1] f
                                        		c = 0
                                		}
                        		}
				}
                        	if (t1 = absolute(length(num_map["n1"]) - length(Nnum_map["n1"])))
                        	        t2 = substr(match_length(num_map["n1"] "," num_map["n2"], 1), 1, t1)
				else
					t2 = ""
				i = 1
                        	split(reverse_str(num_map["n1"]), v1, "")
				split(reverse_str(num_map["n2"]), v2, "")
                        	do {
                        		if ((t1 = c + base_map[v1[i]] + base_map[v2[i]]) > (N3 - 1)) {
                        	                n = base_map[int(t1 % N3)] n
                        	                c = int(t1 / N3)
                        	        } else {
                        	                n = base_map[t1] n
                        	                c = 0
                        	        }
                                	i++
                        	} while ((length(v1[i]) && length(v2[i])) || c)
			}
			return sn t2 n __return_if_value(f, ".", 1)
		}
	}
}

function add_base(N1, N2, N3, B1, B2,         f1, f2, v1, v2, sn, sn1, sn2, t, tl, tn, f, fl, n, nb, nl, i, c, base_map)
{
	N3 = int(__get_base(__return_value(N3, 10), base_map))
	if (N3 >= 2 && N3 <= 62 ) {
		if (N3 > 10 && N3 < 37) {
			N1 = tolower(N1)
			N2 = tolower(N2)
		}
		if (0 N1 ~ __base_regex(N3 - 1, base_map) && 0 N2 ~ __base_regex(N3 - 1, base_map)) {
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
                       	        		if ((t = c + base_map[v1[i]] + base_map[v2[i]]) > (N3 - 1)) {
                                        		f = base_map[int(t % N3)] f
                        	                	c = int(t / N3)
                                		} else {
                                        		f = base_map[t] f
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
                        	        if ((t = c + base_map[v1[i]] + base_map[v2[i]]) > (N3 - 1)) {
                        	                n = base_map[int(t % N3)] n
                        	                c = int(t / N3)
                        	        } else {
                        	                n = base_map[t] n
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

function base_subtract(N1, N2, N3, B,    f1, f2, t, tl, sn, base_map)
{
	N3 = int(__get_base(__return_value(N3, 10), base_map))
	if (N3 >= 2 && N3 <= 62 ) {
		if (N3 > 10 && N3 < 37) {
			N1 = tolower(N1)
			N2 = tolower(N2)
		}
		if (0 N1 ~ __base_regex(N3 - 1, base_map) && 0 N2 ~ __base_regex(N3 - 1, base_map)) {
                	if (sn1 = __get_sign(N1))
                	        N1 = substr(N1, 2)
                	if (sn2 = __get_sign(N2))
                        	N2 = substr(N2, 2)
                	if (XNOR__(sn1 == "-", __return_value(sn2, "+") != "-"))
                        	return sn1 add_base(N1, N2, N3)
                	if (__return_value(sn1, "+") == __return_value(sn2, "+")) {
                        	if (sn1 == "-")
                                	sn = "-"
                        	else
                                	sn = substr(sn1 sn2, 1, 1)
                        	N1 = __pad_bits(convert_base(N1, N3, 2), N3)
                		N2 = __pad_bits(convert_base(N2, N3, 2), N3)
                        	if ((tl = length(N1) - length(N2)) > 0) {
                        	        N2 = append_str(tl - sub(/[.]/, "&", N2), "0") N2
                        	} else if (tl) {
                        	        t = append_str(absolute(tl) - sub(/[.]/, "&", N1), "0") N1
                        	        N1 = N2
                        	        N2 = t
                        	        if (sn != "-")
                                	        sn = "-"
                                	else
                                        	sn = substr(sn1 sn2, 1, 1)
                        	}
                	}
                	# TODO
        	}
	}
}

