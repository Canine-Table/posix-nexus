# __load_number_map: Load numbers into a map V1 based on the specified base N2 and value N1
function __load_number_map(V1, N1, V2, N2, N3,		idx)
{
	if (N1) {
		# Initialize V1[0] to 0 if not already set
		if (! (0 in V1)) {
			split("", V1, "")
			V1[0] = 0
		}
		if (__is_index(N3))
			idx = N3
		# Increment index for storing new number
		else
			idx = V1[0] + 1
		# Convert N2 to an integer base
		N2 = __set_base(N2, V2)
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
				if (! __is_index(N3))
					V1[0] = idx
				V1["bs" idx] = N2
				# Store the fractional part of N1, if it exists
				if (V1["f" idx] = __get_half(N1, "."))
					V1["n" idx] = __return_value(__get_half(N1, ".", 1), 0)
				else
					V1["n" idx] = N1
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

function __load_signs(V)
{
	V[""] = "-"
	V["+"] = "-"
	V["-"] = "+"
}

function __construct_number(V, N, B1, B2, B3,	t)
{
	if (0 in V && V[0] >= N) {
		if (B1)
			t = __return_value(V["n" N], 0)
		if (B2)
			t = __return_value(t, 0) __return_if_value(V["f" N], ".", 1)
		if (B3)
			t = __return_value(V["sn" N], "+") t
		else if (length(B3))
			t = V["sn" N] t
		return t
	}
}

function __get_base(D, V)
{
	if (! (is_array(V) && is_integral(D)))
		__load_upper_map(V)
	if (D ~ /^[a-zA-Z]$/)
		D = V[D]
	if (D >= 2 && D <= 62)
		return D
}

function __set_base(N, V)
{
	return int(__return_value(__get_base(N, V), 10))
}

# N:   The base for which the regular expression is to be generated.
# V:   A mapping array used for generating the regular expression.
# B:   A flag indicating whether to load the number, lower, or upper map.
function __base_regex(N, V, B, 		rg)
{
	if (N = __set_base(N, V)) {  # Check if N is an integral value
		if (N < 10) {
			if (B)
				__load_num_map(V)  # Load number map if B is true
			rg = "[0-" N "]+"  # Generate regex for base less than 10
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

function __load_lower_map(V,	    i)
{
	__load_num_map(V)
	for (i = 10; i < 36; i++) {
		V[i] = sprintf("%c", i + 87)
		V[V[i]] = i
	}
}

function __load_upper_map(V,	    i)
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

function __pad_bits(V, N1, N2)
{
	if (+N2 > 1 && __construct_number(V, N1, 1, 1) ~ __base_regex(1)) {
		N2 = __bit_width(N2)
		if (IN__(V, "n" N1))
			V["n" N1] = append_str(remainder(length(V["n" N1]), N2), "0") V["n" N1]
		if (IN__(V, "f" N1))
			V["f" N1] = V["f" N1] append_str(remainder(length(V["f" N1]), N2), "0")
		return __construct_number(V, N1, 1, 1)
	}
}

# N1: The number to be converted.
# N2: The base of the input number N.
# N3: The base to convert the number N to.
# N4: The precision (default: 32)
function convert_base(N1, N2, N3, N4,	base_map, num_map, n, cv, i, v, j)
{
	# Ensure the target base N3 is between 2 and 62
	if (N3 = __set_base(N3, base_map)) {
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

function compliment(N1, N2,	base_map, num_map, i, v, n)
{
	if (N2 = __set_base(N2, base_map)) {
		if (N1 = __load_number_map(num_map, N1, base_map, N2)) {
			delete num_map
			N2 = N2 - 1
			for (i = 1; i <= split(N1, v, ""); i++) {
				if (v[i] ~ /[.]|[+]|[-]/)
					n = n v[i]
				else
					n = n base_map[N2 - v[i]]
			}
			delete v
		delete base_map
			return n
		}
	}
}

function base_compliment(N1, N2, N3, D, B,		base_map, num_map, f, t1, t2, t3)
{
	if (N3 = __set_base(N3, base_map)) {
		if (! __is_signed(D))
			D = ""
		if (LOR__(N1, N2, 0, "length") || (EQ__(N1, N2, 0) && LT__(N1, N2))) {
			if (__return_value(D, "+") == "+")
				D = "-"
			else
				D = ""
			t1 = N1
			N1 = N2
			N2 = t1
		}
		if (B)
			D = __return_value(D, "+")
		N1 = convert_base(N1, N3, 2)
		N2 = convert_base(N2, N3, 2)
		if (__load_number_map(num_map, N1, base_map, N3) && __load_number_map(num_map, N2, base_map, N3)) {
			__pad_bits(num_map, 1, N3)
			num_map["n2"] = compliment(append_str(length(num_map["n1"]) - length(num_map["n2"]), "0") num_map["n2"], 2)
			if (IN__(num_map, "f2"))
				num_map["f2"] = compliment(num_map["f2"], 2)
			N1 = num_map["n1"] __return_if_value(num_map["f1"], ".", 1)
			N2 = add_base(num_map["n2"] __return_if_value(num_map["f2"], ".", 1), 1, N3)
			delete base_map
			delete num_map
			t2 = add_base(N1, N2, 2)
			if ((t3 = length(N1) - length(t2)) < 0)
				t2 = substr(t2, 1 + absolute(t3))
			else if (t3)
				t2 = append_str(t3, "0") t2
			if ((t2 = convert_base(t2, 2, N3)) != 0)
				t2 = D t2
			return t2
		}
	}
}

function base_subtract_base(N1, N2, N3,	 	base_map, num_map, sn, n, sn1, sn2)
{
	if (N3 = __set_base(N3, base_map)) {
		if (sn1 = __get_sign(N1))
			N1 = substr(N1, 2)
		if (sn2 = __get_sign(N2))
			N2 = substr(N2, 2)
		if (__return_value(sn1, "+") == __return_value(sn2, "+"))
			sn = substr(sn1 sn2, 1, 1)
		else
			sn = sn1
		if (XNOR__(sn1 == "-", __return_value(sn2, "+") != "-")) {
			if (n = add_base(N1, N2, N3))
				return sn n
		} else {
			return base_compliment(N1, N2, sn1)
		}
	}
}

function add_base(N1, N2, N3,		num_map, base_map, sn, f, n, c, t1, t2, v1, v2, i)
{
	if (N3 = __set_base(N3, base_map)) {
		if (__load_number_map(num_map, N1, base_map, N3) && __load_number_map(num_map, N2, base_map, N3)) {
			if (__return_value(num_map["sn1"], "+") == __return_value(num_map["sn2"], "+")) {
				sn = substr(num_map["sn1"] num_map["sn2"], 1, 1)
				f = even_lengths(num_map, "f1", "f2")
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
				if (absolute(length(num_map["n1"]) - length(num_map["n2"])))
					t2 = match_length(num_map["n1"] "," num_map["n2"], 1)
				else
					t2 = ""
				split(reverse_str(num_map["n1"]), v1, "")
				split(reverse_str(num_map["n2"]), v2, "")
				num_map["n1"] = __return_value(num_map["n1"], 0)
				num_map["n2"] = __return_value(num_map["n2"], 0)
				i = 1
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
				n = sn substr(t2, 1, length(t2) - length(n)) n __return_if_value(f, ".", 1)
			} else {
				print N1 "  +  " N2
				# TODO
				# -N1 + N2
				# N1 + -N2
				# callback after compliment method 
			}
			delete v1
			delete v2
		}
		delete num_map
	}
	delete base_map
	return n
}

