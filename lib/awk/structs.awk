# V:	The array.
# N1:	starting index
# N2:	end index
# N3:	skip value 
# D:	the data to split into an array
# S:	the separator
# insert_indexed_item: Insert elements into array V based on conditions
function insert_indexed_item(V, D, S, N1, N2, N3, B,		v, l, i, j)
{
	# Check if V is an array and D is true using EQTL__
	if (EQTL__(is_array(V), D, 1)) {
		# If N1 is not an integral, set it to size of V
		if (! is_integral(N1))
			N1 = size(V)
		# Verify N2 is a valid index and greater than N1
		if ((N2 = __return_value(N2, 0)) && __is_index(N2) && N2 > N1)
			j = modulus_range(N1, N1, N2)
		else
			j = N1
		# Set N3 to 1 if it's not a valid index
		if (! __is_index(N3))
			N3 = 1
		# Loop through elements split from D based on S
		for (i = 1; i <= trim_split(D, v, __return_value(S, ",")); i++) {
			if (B) {
				printf("[%s] = ", j)
				if (length(V[j]))
					printf("%s -> ", V[j])
				printf("%s\n", v[i])
			}
			V[j] = v[i]
			# Update j using modulus range if N2 is valid, otherwise increment by N3
			if (N2)
				j = modulus_range(j + N3, N1, N2)
			else
				j = j + N3
		}
		delete v
		return j
	}
}

function unique_indexed_array(D, V, S,		v, s)
{
	S = __return_value(S, ",")
	array(D, v, S)
	s = __join_array(v, S)
	delete v
	return split(s, V, S)
}

# remove_indexed_item: Remove elements from array V based on conditions
function remove_indexed_item(V, M, N1, N2, N3, N4, B, 		i, j)
{
	# Check if V is an array and match M with "front" or "back" option
	if (is_array(V) && (M = match_option(M, "front, back"))) {
		# Set N1 to 0 if it is not an integral
		if (!is_integral(N1))
			N1 = 0
		# Validate N2 and set it to the size of V if necessary
		if (!__is_index(N2) || N2 < N1)
			N2 = size(V)
		# Set N3 to 1 if it is not a valid index and absolute value
		if (!__is_index(N3 = absolute(N3)))
			N3 = 1
		# Set N4 to 1 if it is not a valid index
		if (!__is_index(N4))
			N4 = 1
		# Determine starting point for removal based on "front" or "back" option
		if (M == "back") {
			i = modulus_range(N2, N1, N2)
			N3 = -N3 # Negative step for backward iteration
		} else { # Default to "front"
			i = modulus_range(N1, N1, N2)
		}
		# Loop to remove N4 items
		while (N4-- > 0) {
			if (B) # Print removed item if B is true
				printf("[%s] = %s\n", i, V[i])
			delete V[i] # Remove the item at index i
			i = modulus_range(i + N3, N1, N2) # Update index i
		}
		return i # Return the last index used
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

# V: The array.
function size(V,	i, n)
{
	for (i in V)
		++n
	return +n
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

# resize_indexed_hashmap: Resize an indexed hashmap V based on conditions
function resize_indexed_hashmap(V, N1, N2, S, D, 	crsz, nsz, s, i, j)
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
					s = __join_str(s, V[i + N2], S) # Join elements with separator S
					delete V[i + N2] # Delete old elements
					# Insert joined string into V[j] and reset s
					if (! (i % nsz) || i == crsz - N2) {
						V[++j] = s
						s = ""
					}
				}
			} else {
				j = crsz # Set j to current size if N1 is not less
			}
			# Fill remaining elements with default value D if necessary
			if (j < N1) {
				D = __return_value(D, "0") # Default value for D
				do {
					V[++j] = D
				} while (j < N1)
			} else if (j > N1) {
				for (; j > N1; j--) {
					delete V[j]
				}
			}
			return j # Return new size of V
		}
	}
}

function reverse_indexed_hashmap(V, N1, N2,	i)
{
	if ((i = size(V)) > 1) {
		N1 = __return_value(N1, 1)
		N2 = __return_value(N2, i)
		while (N1 < N2)
			__swap(V, N1++, N2--)
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
			c = V[V[0] - 1]
			if (M == "pop")
				V[0] = remove_indexed_item(V, "back", 1, V[0], 1, 1)
			return c
		}
	}
}

# V: The queue, represented as an indexed hashmap.
# M: The operation mode (enqueue, dequeue, peek, isempty).
# D: The data to enqueue (if M is enqueue).
# S: The delimiter for splitting the data.
function queue(V, M, D, S,	c, idx)
{
	if (M = match_option(M, "enqueue, dequeue, peek, isempty, size")) {
		if (NOR__(0 in V, 1 in V)) {
			V[0] = 3
			V[1] = 3
			if (M == "size" && is_integral(D)) {
				if (D = int(absolute(D)))
					V[2] = D
				return D
			}
		}
		if (EQTL__(M == "enqueue", D, 1)) {
			S = __return_value(S, ",")
			if (2 in V)
				V[1] = __loop_indexed_hashmap(V[0], V[2], V[1], V, D, S)
			else
				V[1] = __append_indexed_hashmap(V, V[1], D, S)
		} else if (M == "isempty") {
			if (V[1] - V[0] > 0)
				return 1
			else
				return 0
		} else if (! queue(V, "isempty")){
			if (2 in V) {
				idx = (V[1], V[2], V[0])

			} else {
				idx = V[0]
				c = V[idx + 1]
			}
			if (M == "dequeue")
				V[0] = __delete_indexed_hashmap(V, idx, "front")
			return c
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
	gsub(/(^ *| *$)/, "", D)
	return split(D, V, " *" __return_value(S, ",") " *")
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

function split_parameters(D, V, S1, S2,		i, j, v, k)
{
	S2 = __return_value(substr(S2, 1, 1),  "=")
	for (i = 1; i <= unique_indexed_array(D, v, S1); i++) {
		if (j = index(v[i], S2)) {
			k = substr(v[i], 1, j - 1)
			trim(k)
			w = substr(v[i], j + 1)
			trim(w)
			V[k] = w
		}
		delete v[i]
	}
	delete v
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

