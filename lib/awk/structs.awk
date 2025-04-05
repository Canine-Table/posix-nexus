

function insert_indexed_item(V, D, S, N1, N2, N3, 	j, l)
{
	if (TRUE__(D, 1)) {
		if (! is_array(V))
			split("", V, "")
		if (! is_integral(N1))
			N1 = size(V)
		if (LT__(+N2, N1))
			N2 = 0
		if (! __is_index(N3))
			N3 = 1
		j = N1
		l = trim_split(D, v, S)
		for (i = 1; i <= l; i++) {
			if (N2)
				j = modulus_range(j, N1, N2)
			V[j] = v[i]
			j = j + N3
		}
		delete v
		if (N2)
			return modulus_range(j, N1, N2)
		return j
	}
}

function unique_indexed_array(D, V, S, O, B,		v, s, dlm)
{
	__load_delim(dlm, S, O)
	array(D, v, dlm["s"])
	if (B)
		dlm["s"] = dlm["o"]
	s = __join_array(v, dlm["s"])
	delete v
	S = dlm["s"]
	delete dlm
	if (B)
		delete V
	else
		return split(s, V, S)
	return s
}

function remove_indexed_item(V, N1, N2, N3, N4,		i)
{
	if (is_array(V)) {
		if (! is_integral(N1))
			N1 = 1
		if (! is_integral(N2) || N2 > (i = size(V)) + N1)
			N2 = i
		if (! __is_index(absolute(N3)))
			N3 = 1
		if (! __is_index(N4))
			N4 = 1
		if (N3 < 0)
			i = modulus_range(N2, N1, N2)
		else
			i = modulus_range(N1, N1, N2)
		do {
			delete V[i]
			i = modulus_range(i + N3, N1, N2)
		} while (--N4)
		return i
	}
}

# V: The array.
# S: The delimiter.
function __join_array(V, S,	i, s)
{
	for (i in V)
		s =__join_str(s, i, S)
	return s
}

function __join_indexed_array(V, S,	i, s)
{
	for (i = 1; i <= size(V); i++)
		s =__join_str(s, V[i], S)
	return s
}

function flip_map(V, D1, D2, D3, S,   i, v)
{
	if (is_array(V) && FULL__(D3) && (FULL__(D1) || FULL__(D2))) {
		for (i = 1; i <= trim_split(D3, v, S); i++) {
			if (IN__(V, v[i] D1) || IN__(V, v[i] D2)) {
				__swap(V, v[i] D1, v[i] D2)
			}
		}
		delete v
	}
}

# V: The array.
function size(V,	i, n)
{
	for (i in V)
		++n
	return n
}

# V: The array.
function is_array(V) {
	for (i in V)
		return 1
	return 0
}

function __is_index(N)
{
	if (is_integral(N) && (N = int(N)) > 0)
		return N
	return 0
}

# V: 	The array (hashmap) to be resized.
# N1: 	The target size for the array. Determines the number of elements V should have after resizing.
# N2: 	N2 is the starting index for element distribution when resizing the array.
# S: 	Separator used when joining elements as part of the resizing process. Default value is ",".
# D:	Default value for new elements if the array size N1 is increased.
# resize_indexed_hashmap: Resize an indexed hashmap V based on conditions
function resize_indexed_hashmap(V, N1, N2, S, D,	crsz, nsz, s, i, j)
{
	# Check if V is an array
	if (is_array(V)) {
		# Confirm N1 is a valid index
		if (__is_index(N1)) {
			crsz = size(V) # Get the current size of V
			# Proceed if N1 is less than current size
			if (N1 < crsz) {
				# Validate N2 and set it appropriately
				if (__is_index(N2)) {
					if (N1 - N2 <= 0)
						N2 = N1 - 1
				}
				nsz = distribution(crsz, N1, N2) # Calculate new size distribution
				S = __return_value(S, ",") # Set separator S with default value ","
				j = N2
				# Loop through the array to resize and join elements
				for (i = 1; i <= crsz - N2; i++) {
					if (V[i + N2])
						s = __join_str(s, V[i + N2], S) 
					delete V[i + N2] # Delete old elements
					# Insert joined string into V[j] and reset s
					if (! (i % nsz) || i == crsz - N2) {
						V[++j] = s
						s = ""
					}
				}
			} else {
				j = crsz - N2# Set j to current size if N1 is not less
			}
			# Fill remaining elements with default value D if necessary
			if (j < N1) {
				do {
					V[j+=1] = D
				} while (j < N1)
			}
			return j 
		}
	}
}

function reverse_indexed_hashmap(V, N1, N2, D, S, O,	i)
{
	if (! is_array(V) && FULL__(D))
		trim_split(D, V, S)
	if ((i = size(V)) > 1) {
		N1 = __return_value(N1, 1)
		N2 = __return_value(N2, i)
		while (N1 < N2)
			__swap(V, N1++, N2--)
		if (length(O)) {
			i = __join_indexed_array(V, O)
			delete V
			return i
		}
	}
}

# V: The stack (implemented as an indexed hashmap).
# M: The operation mode (push, pop, peek, isempty).
# D: The data to push (if M is push).
# S: The delimiter for splitting data.


function stack(V, M, D, S,	c)
{
	if (M = match_option(M, "push, pop, peek, isempty")) {
		if (EQTL__(M == "push", D, 1)) {
			if (! is_array(V)) {
				split("", V, "")
				V[0] = 1
			}
			V[0] = insert_indexed_item(V, D, __return_value(S, ","), V[0])
		} else if (M == "isempty") {
			if (V[0] > 1)
				return 0
			else
				return 1
		} else if (V[0] > 1) {
			print V[0]
			c = V[V[0] - 1]
			if (M == "pop")
				V[0] = remove_indexed_item(V, "back", 1, V[0], 1, 1)
			return c
		}
	}
}

function queue(V, M, D1, S, D2)
{
	if (M = match_option(M, "enqueue, dequeue, isempty, size, resize")) {
		if (! (IN__(V, 0) || IN__(V, 1))) {
			split("", V, "")
			V[0] = 3
			V[1] = 3
			if (M == "size") {
				if (is_integral(D1))
					V[2] = D1 + V[0] - 1
				return
			}
		}
		if (M == "enqueue" && FULL__(D1)) {
			V[1] = insert_indexed_item(V, D1, __return_value(S, ","), V[0], V[2], 1)
		} else if (M == "resize" && is_integral(D1)) {
			V[2] = resize_indexed_hashmap(V, D1, V[0] - 1, S, D2)
		} else if (M == "isempty") {
			return ! FULL__(V[V[0]])
		} else {
			D2 = V[V[0]]
			if (M == "dequeue" && ! __queue(V, "isempty")) {
				if (V[2])
					V[2]++
				V[0] = remove_indexed_item(V, V[0], __return_value(V[2], V[1]), 1, 1)
			}
			return D2
		}
	}
}

function clone_array(V1, V2, B,		d, i, c)
{
	for (i in V1) {
		if (B)
			d = i
		else
			d = V1[i]
		V2[++c] = d
	}
	return c
}

function trim_split(D, V, S)
{
	gsub(/(^[ \t\v]+|[ \t\v]+$)/, "", D)
	return split(D, V, "[ \t\v]*" __return_value(S, ",") "[ \t\v]*")
}

function array(D, V, S,		i, k)
{
	S = __return_value(S, ",")
	while (D = trim(D, S)) {
		if (! (i = index(D, S)))
			i = length(D) + 1
		if (k = substr(D, 1, i - 1))
			V[k]++
		D = substr(D, i + 1)
	}
}

function split_parameters(D, V, S1, S2, B1,		i, j, v, k)
{
	S1 = __return_value(substr(S1, 1, 1),  ",")
	S2 = __return_value(substr(S2, 1, 1),  "=")
	if (! is_array(V))
		split("", V, "")
	l = unique_indexed_array(D, v, S1)
	for (i = 1; i <= l; i++) {
		k = __return_else_value(B, __return_value(__get_half(v[i], S2, 1), v[i]), __return_value(__get_half(v[i], S2, 1), i))
		trim(k)
		w = __return_else_value(B, __get_half(v[i], S2), __return_value(__get_half(v[i], S2), v[i]))
		trim(w)
		V[k] = w
		delete v[i]
	}
	delete v
}

function __join_parameters(V, S1, S2,	i, str)
{
	S1 = __return_value(substr(S1, 1, 1),  ",")
	S2 = __return_value(substr(S2, 1, 1),  "=")
	str = ""
	for (i in V)
		str = __join_str(str, i S2 V[i], S1)
	delete V
	return str
}

function compare_arrays(D1, D2, M, S, O,	dlm, v1, v2, s)
{
	__load_delim(dlm, S, O)
	if (M = match_option(M, "left, right, intersect, difference")) {
		if (M == "right") {
			array(D2, v1, dlm["s"])
			array(D1, v2, dlm["s"])
		} else {
			array(D1, v1, dlm["s"])
			array(D2, v2, dlm["s"])
		}
		for (i in v1) {
			if (EQTT__(i in v2, M == "intersect"))
				s = __join_str(s, i, dlm["o"])
		}
		if (M == "difference") {
			for (i in v2) {
				if (! (i in v1)) {
					s = __join_str(s, i, dlm["o"])
				}
			}
		}
		delete v1
		delete v2
	}
	delete dlm
	return s
}

