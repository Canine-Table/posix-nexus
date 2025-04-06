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

function __nx_is_natural(N)
{
	return (__nx_is_integral(N) && N > 0)
}

function __nx_number_map(V, N1, N2)
{
	if (! (length(V) && 0 in V))
		V[0] = 0
	if (__nx_is_digit(N1)) {
		if ("n" N2 in V)
			i = N2
		else
			i = V[0] + 1
	}
}

#function __load_number_map(V1, N1, V2, N2, N3,		idx)
#{
#	if (N1) {
#		# Initialize V1[0] to 0 if not already set
#		if (! (0 in V1)) {
#			split("", V1, "")
#			V1[0] = 0
#		}
#		if (__is_index(N3))
#			idx = N3
#		# Increment index for storing new number
#		else
#3\			idx = V1[0] + 1
		# Convert N2 to an integer base
#		N2 = __set_base(N2, V2)
		# Check if N2 is within a valid range (2 to 62)
#		if (N2 >= 2 && N2 <= 62) {
##			# Convert N1 to lowercase if base is between 11 and 36
##			if (N2 > 10 && N2 < 37)
#				N1 = tolower(N1)
#			# Store the sign of N1
#			if (V1["sn" idx] = __get_sign(N1))
#				N1 = substr(N1, 2)
#			# Check if N1 is a valid number in the given base
#			if (0 N1 0 ~ __base_regex(N2 - 1, V2)) {
#				if (! __is_index(N3))
#					V1[0] = idx
#				V1["bs" idx] = N2
#				# Store the fractional part of N1, if it exists
#				if (V1["f" idx] = __get_half(N1, "."))
#					V1["n" idx] = __return_value(__get_half(N1, ".", 1), 0)
#				else
#					V1["n" idx] = N1
#			}
#		}
#	} else {
#		idx = V1[0]
#	}
#	if (idx) {
#		# Reconstruct N1 with its sign and fractional part, if any
#		if ((N1 = V1["n" idx] __return_if_value(V1["f" idx], ".", 1)) != 0)
#			N1 = V1["sn" idx] N1
#		return N1
#	}
#}

