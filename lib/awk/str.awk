# D1:	The first string.
# D2:	The second string to be appended to the first.
# S:	The separator to be used between D1 and D2 if D1 is not empty.
function __join_str(D1, D2, S)
{
	if (D1)
		D1 = D1 S
	return D1 D2
}

# N:  The number of times to append the string D.
# D:  The string to be appended.
# B:  A flag indicating the direction of append (1 for appending at the end, 0 for appending at the beginning).
# s:  Temporary string used for the append operation.
function append_str(N, D, B,	s)
{
	if (is_integral(N) && __is_index(N = int(N))) {
		D = __return_value(D, " ")
		do {
			if (B)
				s = s D
			else
				s = D s
		} while (--N)
		return s
	} else if (length(B) && B == 0)
		return D
}

function reverse_str(D,		i, v)
{
	if ((i = split(D, v, "")) > 1) {
		D = ""
		do {
			D = D v[i]
		} while (--i)
	}
	delete v
	return D
}

# D1:	The main string to be formatted.
# D2:	The format string containing placeholders.
# S:	The delimiter used to split the format string.
# L:	The left tag delimiter to identify placeholders.
# R:	The right tag delimiter to identify placeholders.
# B:	A flag indicating whether to remove unmatched placeholders.
function format_str(D1, D2, S, L, R, B,		dlm, fmt)
{
	__load_delim(dlm, S, "NULL")
	__load_tag(dlm, L, R)
	for (i = 1; i <= trim_split(D2, fmt, dlm["s"]); i++) {
		if (! gsub(dlm["l"] i dlm["r"], fmt[i], D1)) {
			sub(dlm["l"] dlm["r"], fmt[i], D1)
		}
	}
	if (! B)
		gsub(dlm["l"] dlm["r"], "", D1)
	delete dlm
	delete fmt
	return D1
}

# D:   The input string to be processed.
# C:   The character used to determine the split point in the input string.
# B1:  A flag indicating which half of the string to return (1 for the first half, 0 for the second half).
# B2:  The number of characters to adjust around the split point.
function __get_half(D, C, B1, B2, i)
{
    if (C = substr(C, 1, 1)) {	# Extract the first character of C
	if (i = index(D, C)) {	# Find the position of C in the input string I
	    if (! length(B2))
		B2 = 1	# Default B2 to 1 if not provided 
	    if (B1)
		return substr(D, 1, i - B2)  # Return the substring from the start to just before the split point
	    else
		return substr(D, i + B2)  # Return the substring from just after the split point to the end
	}
    }
}

# D:   The string to search within.
# V:   The array of substrings to search for.
# B:   A flag indicating what to return if no substring is found.
function __first_index(D, V, B,		i, j, c)
{
	if (is_array(V)) {
		for (i in V) {	# Iterate over each element in array V
			if (j = index(D, V[i])) {  # Find the position of V[i] in D
				if (! c || c > j)
					c = j
			}
		} if (B && ! c)
			c = length(D)  # If B is set and no match is found, set c to the length of D
		return c  # Return the position of the first match or the length of D
	}
}

function __load_quote_map(V)
{
	V["sq"] = "\x27"
	V["dq"] = "\x22"
}

function __load_str_map(V)
{
	V["upper"] = "A-Z"
	V["lower"] = "a-z"
	V["xupper"] = "A-F"
	V["xlower"] = "a-f"
	V["digit"] = "0-9"
	V["alpha"] = V["upper"] V["lower"]
	V["xdigit"] = V["digit"] V["xupper"] V["xlower"]
	V["alnum"] = V["digit"] V["alpha"]
	V["print"] = "\x20-\x7e"
	V["punct"] = "\x21-\x2f\x3a-\x40\x5b-\x60\x7b-\x7e"
}

function __load_esc_map(V)
{
	V[" "] = "\x20"
	V["b"] = "\x08"
	V["t"] = "\x09"
	V["n"] = "\x0a"
	V["v"] = "\x0b"
	V["f"] = "\x0c"
	V["r"] = "\x0d"
	V["e"] = "\x1b"
}

# V:  The array of strings whose lengths are to be compared.
# B:  A flag indicating the comparison direction (1 for finding the maximum length, 0 for finding the minimum length).
function __compare_lengths(V, B,	i, l, ln)
{
	for (i in V) {	# Iterate over each element in array V
		l = length(i)  # Get the length of the current element
		if (! ln)
			ln = l	# Initialize ln with the length of the first element
		else if (LOR__(l, ln, B))
			ln = l	# Update ln based on the comparison
	}
	return ln  # Return the final length
}

function escape_str(D)
{
	gsub(/./, "\\\\&", D)
	return D
}

# N:   The desired length of the random string.
# C:   A string containing characters that will define the character set for the random string.
# S:   A delimiter used to split the character set string `C`.
# B:   A flag to determine the order of reading from random devices.
function random_str(N, C, S, B,		str_map, s, v, i, rg, line)
{
	if (C && is_integral(N)) {
		__load_str_map(str_map)  # Load the string map
		array(C, v, S)	# Split the character set string C using the delimiter S into array v
		for (i in v) {
			if (i in str_map) {
				rg = rg str_map[i]  # Build the regular expression character set
				delete str_map[i]  # Delete the used entry from the string map
			}
			delete v[i]  # Clean up the temporary array v
		}
		delete v
		delete str_map
		if (rg) {
			split("/dev/urandom,/dev/random", str_map, ",")  # Define random device files
			if (B)
				__swap(str_map, 1, 2)  # Swap the device order if B is true
			N = int(N)  # Ensure N is an integer
			do {
				if (! (getline line < str_map[1])) {  # Read random data
					if (! (getline line < str_map[2])) {
						return
					}
				}
				for (i = 1; i <= split(line, v, ""); i++) {  # Split the random data into characters
					if (v[i] ~ "^[" rg "]$")  # Check if the character matches the regex
						s = s v[i]  # Append the character to the result string s
				}
			} while (length(s) < N)  # Repeat until the string is of desired length
			delete v
			delete str_map
			return substr(s, 1, N)	# Return the random string of length N
		}
	}
}

function totitle(D,	i, s, esc_map)
{
	__load_esc_map(esc_map)
	while (i = __first_index(D, esc_map, 1)) {
		s = s toupper(substr(D, 1, 1)) tolower(substr(D, 2, i - 1))
		D = substr(D, i + 1)
	}
	delete esc_map
	return s
}

function trim(D, S)
{
	gsub(/(^[ \v\t]+|[ \v\t]+$)/, "", D)
	gsub("[ \v\t]*" S "[ \v\t]*", S, D)
	return D
}

# D:   The input string to search within.
# B:   A flag indicating the sorting order (1 for ascending, 0 for descending).
# S:   The delimiter for splitting the input string.
# O:   The output delimiter for joining matched strings.
function match_length(D, B, S, O,	dlm, c, v, i, l, j, k, s)
{
	__load_delim(dlm, S, O)  # Load the delimiter mappings
	c = unique_indexed_array(D, v, dlm["s"])  # Create a unique indexed array from the input string D
	quick_sort(v, 1, c, B, "length")  # Sort the array v based on length
	for (i = 1; i <= c; i++) {
		j = length(v[i])  # Get the length of the current element
		if (! l) {
			l = j
			k = i
		} else if (LOR__(j, l, B)) {
			l = j
			delete v[k]  # Delete the previous element if its length doesn't match the criteria
			k = i
		} else if (j != l) {
			delete v[i]  # Delete the current element if its length doesn't match the criteria
		}
	}
	for (i in v)
		s = __join_str(s, v[i], dlm["o"])  # Join the remaining elements with the output delimiter
	delete v
	delete dlm
	return s  # Return the joined string of matched elements
}

# D1:	The boundary substring to match.
# D2:	The input string to search within.
# B:	A flag indicating whether to match the end (1) or the start (0) of the strings.
# S:	The delimiter for splitting the input string.
# O:	The output delimiter for joining matched strings.
function match_boundary(D1, D2, B, S,	O, v, i, l, dlm, s)
{
    if (D1 && D2) {
	__load_delim(dlm, S, O)  # Load the delimiter mappings
	array(D2, v, dlm["s"])	# Split the input string DB into array v using delimiter S
	l = length(D1)	# Get the length of the boundary substring DA
	for (i in v) {
	    if ((B && D1 != substr(i, length(i) + 1 - l)) || (! B && D1 != substr(i, 1, l))) {
		# Delete element if it doesn't match the boundary condition
		delete v[i]
	    } else {
		# Join matched elements with delimiter
		s = __join_str(s, i, dlm["o"])
	    }
	}
	delete v
	delete dlm
	# Return the joined string of matched elements
	return s
    }
}

# D1:	The boundary substring to match.
# D2:	The input string to search within.
# S:	The delimiter for splitting the input string.
# O:	The output delimiter for joining matched strings.
# B1:	Verbose
# B2:	A flag indicating whether to match the end (1) or the start (0) of the strings.
# B3:	A flag indicating the sorting order (1 for ascending, 0 for descending).
function match_option(D1, D2, S, O, B1, B2, B3,		dlm, s)
{
	__load_delim(dlm, S, O)  # Load the delimiter mappings
	if (s = match_length(match_boundary(D1, D2, B2, dlm["s"], dlm["s"]), B3, dlm["s"], dlm["o"])) {
		if (s ~ dlm["o"] && ! B1)
			s = ""
	}
	delete dlm
	return s
}

# even_lengths: Ensure the lengths of V[D1] and V[D2] are even by trimming the longer string
function even_lengths(V, D1, D2, B,	t1, t2, t3, t4)
{
	if (is_array(V)) {
		# Calculate the absolute difference in lengths between V[D1] and V[D2]
		if (t1 = absolute(length(V[D1]) - length(V[D2]))) {
			t2 = match_length(V[D1] "," V[D2], 1)
			t3 = length(t2)
			if (B)
				t4 = substr(t2, t1 + 1)
			else
				t4 = substr(t2, 1, t3 - t1)
			if (t2 == V[D1])
				V[D1] = t4
			else
				V[D2] = t4
			if (B)
				return substr(t2, 1, t1)
			return substr(t2, t3 - t1 + 1)
		}
	}
}

function str_search(D1, S1, S2, S3, O, D2, D3,	arr, i, j, l, n, o, dtn, fnd, mth, rpl, reg, idx, rtn)
{
	S1 = __return_value(S1, "\x20")
	O = __return_value(O, "\x0a")
	if (D2) {
		rtn = ""
		S2 = __return_value(S2, "/")
		S3 = __return_value(S3, ",")
		l = split(D1, arr, S1)
		if (idx = __get_half(D2, S3)) {
			D2 = __get_half(D2, S3, 1)
		}
		if (! (is_integral(idx, 1))) {
			arr[0] = D1
			idx = 0
		}
		if (reg = __get_half(D2, S2, 0, 0)) {
			n = str_group(reg, fnd, S2)
			o = str_group(substr(reg, 2), mth, S2)
			split_parameters(D3, rpl)
			if (reg ~ /g$/)
				glb = 1
			for (i = 1; i <= l; i++) {
				for (j = 1; j <= n; j++) {
					if (arr[i] ~ fnd[j]) {
						if (idx == 0) {
							reg = arr[0]
						} else {
							reg = arr[modulus_range(i + idx, 1, l)]
							if (mth[j]) {
								if (glb)
									gsub(mth[j], __return_value(rpl[fnd[j]], ""), reg)
								else
									sub(mth[j], __return_value(rpl[fnd[j]], ""), reg)
							}
							rtn = __join_str(rtn, reg, O)
						}

					}
				}
			}
			delete fnd
			delete mth
			delete rpl
			return rtn
		}
	} else if (D1) {
		return D1 O
	}
}

function str_parser(D1, D2,	i, k, l, m, opts, arr, kw, rtn, rmdr)
{
	split("", arr, "")
	split("", kw, "")
	l = split(D1, opts, "")
	for (i = 1; i <= l; i++) {
		if (opts[i + 1] != ":") {
			if (opts[i] != ":")
				arr[opts[i]] = ""
		} else {
			kw[opts[i++]] = ""
		}
	}
	rmdr = ""
	split("", rtn, "")
	l = split(D2, opts, "<NULL>")
	for (i = 1; i <= l; i++) {
		if (opts[i] ~ /^-/) {
			if ((k = __get_half(opts[i], "-")) == "-") {
				break
			} else if (k in arr) {
				if (opts[i] ~ /[A-Z]+/)
					rtn[tolower(k)] = "false"
				else
					rtn[k] = "true"
			} else if (k in kw) {
					rtn[k] = __join_str(rtn[k], opts[++i], ",")
			} else {
				rmdr = rmdr " \x22" opts[i] "\x22"
			}
		} else {
			rmdr = rmdr " \x22" opts[i] "\x22"
		}
	}
	while (i < l) {
		rmdr = rmdr " \x22" opts[++i] "\x22"
	}
	delete opts
	delete arr
	delete kw
	rmdr = "rmdr=\x27" rmdr "\x27"
	for (i in rtn)
		rmdr = rmdr " " i "=\x22" rtn[i] "\x22"
	delete rtn
	return rmdr
}

function str_group(D1, V, D2, S,	i, idx, m, arr)
{
	idx = 0
	if (! is_array(V))
		split("", V, "")
	split(__return_value(D2, "\x20,\x22,\x27"), arr, __return_value(S, ","))
	while (D1) {
		i = __first_index(D1, arr, 1)
		if ((m = substr(D1, i, 1)) == " ") {
			V[++idx] = substr(D1, 1, i)
		} else if (match(D1, m "[^\\\\" m "]*"  m)) {
			V[++idx] = substr(D1, RSTART + 1, RLENGTH - 2)
			i = RSTART + RLENGTH
		}
		D1 = substr(D1, i + 1)
	}
	delete arr
	return idx
}

