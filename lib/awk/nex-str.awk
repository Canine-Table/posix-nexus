function nx_reverse_str(D,	i, v)
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

function nx_escape_str(D)
{
	gsub(/./, "\\\\&", D)
	return D
}

function nx_join_str(D1, D2, S, D3)
{
	D3 = __nx_if(Q, "\x27", "\x22")
	if (D1 && D2)
		D1 = D1 S
	return D1 D3 D2 D3
}

function nx_trim_str(D, S)
{
	S = __nx_else(S, " \v\t\n\f")
	gsub("(^[" S "]+|[ " S "]+$)", "", D)
	return D
}

function nx_append_str(D, N,	s)
{
	if (__nx_is_natural(N) && __nx_defined(D, 1)) {
		do {
			s = s D
		} while (--N)
		return s
	}
}

function nx_cut_str(D1, D2, B)
{
	if (match(D1, D2)) {
		if (B)
			return substr(D1, 1, RSTART - 1)
		if (length(B))
			return substr(D1, RSTART + RLENGTH)
		return substr(D1, RSTART, RLENGTH)
	}
}

#function nx_totitle(D, B,	i, s, v)
#{
#	__nx_escape_map(v)
#	while (i = nx_first_index(D, v, 1, v)) {
#		s = s toupper(substr(D, 1, 1)) tolower(substr(D, 2, i - 1))
#		D = substr(D, i + 1)
#	}
#	if (B)
#		delete v
#	return s
#}

#function nx_random_str(N, D, S, B,	v1, v2)
#{
	#if (__nx_is_natural(N)) {
	#	__load_str_map(v1)
	#	v1[0] = length(v1)
	#	nx_vector(D, v2, S)
	#	for (i = 1; i < v2[0]; i++) {
	#		nx_option(v1[i], v3, S, v3, 1)
	#	}
	#}
#}

#function random_str(N, C, S, B,		str_map, s, v, i, rg, line)
##{
#	if (C && is_integral(N)) {
#		__load_str_map(str_map)  # Load the string map
#		array(C, v, S)	# Split the character set string C using the delimiter S into array v
#		for (i in v) {
#			if (i in str_map) {
#				rg = rg str_map[i]  # Build the regular expression character set
#				delete str_map[i]  # Delete the used entry from the string map
#			}
#			delete v[i]  # Clean up the temporary array v
#		}
#		delete v
#		delete str_map
#		if (rg) {
#			split("/dev/urandom,/dev/random", str_map, ",")  # Define random device files
#			if (B)
#				__swap(str_map, 1, 2)  # Swap the device order if B is true
#			N = int(N)  # Ensure N is an integer
#			do {
#				if (! (getline line < str_map[1])) {  # Read random data
#					if (! (getline line < str_map[2])) {
#						return
#					}
#				}
#				for (i = 1; i <= split(line, v, ""); i++) {  # Split the random data into characters
#					if (v[i] ~ "^[" rg "]$")  # Check if the character matches the regex
#						s = s v[i]  # Append the character to the result string s
#				}
#			} while (length(s) < N)  # Repeat until the string is of desired length
#			delete v
#			delete str_map
#			return substr(s, 1, N)	# Return the random string of length N
#		}
#	}
#}

