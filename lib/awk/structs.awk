# V: The array.
# N1:	starting index
# N2:	end index
# N3:	skip value 
# D: 	the data to split into an array
# S:	the separator 
function insert_indexed_item(V, D, S, N1, N2, N3,	v, l, i, j)
{
	if (EQTL__(is_array(V), D, 1)) {
		N1 = __return_value(N1, size(V) + 1)
		N2 = __return_value(N2, 0)
		N3 = __return_value(N3, 1)
		j = N1
		for (i = 1; i <= trim_split(D, v, __return_value(S, ",")); i++) {
			V[j] = v[i]
			j = j + N3
			if (N2) {
				j = j % N2
				if (j < N1)
					j = j + N1
			}
		}
		delete v
		return j
	}
}

function remove_indexed_item(V, M, N1, N2, N3, N4,	i, j)
{
	if (is_array(V) && (M = match_option(M, "front, back"))) {
		N1 = __return_value(N1, 1)
		N2 = __return_value(N2, size(V))
		N3 = __return_value(absolute(N3), 1)
		N4 = __return_value(N4, 1)
		i = N1
		if (M == "back") {
			i = N2
			N3 = -N3
		}
		while (N4-- > 0) {
			print i " = " V[i]
			delete V[i]
			i = (i + N3) % N2
			if (M == "front" && i < N1)
				i = (i + N1) % N2 + N1
			else if (M == "back" && i < N1)
				i = N1 + i + N2
		}
		return i
	}
}

# V: The hashmap.
# N: The current index.
# M: The mode indicating whether to delete from the front or the back.
function __delete_indexed_hashmap(V, N, M, 	n)
{
	if (is_integral(N)) {
		N = int(N)
        	if (N == 0) {
                	delete N
        	} else if (M = match_option(M, "front, back")) {
                	if (M == "front") {
                        	delete V[N++]
			} else if (M == "back") {
                        	delete V[N--]
			}
        	}
        	return N
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

function resize_indexed_hashmap(V, N1, N2, S, D,	crsz, nsz, s, i, j)
{
	if (is_array(V)) {
		if (__is_index(N1)) {
			crsz = size(V)
			if (N1 < crsz) {
				if (__is_index(N2)) {
					if (N1 - N2 <= 0)
						N2 = N1 - 1
				}
				nsz = ceiling((crsz - N2) / (N1 - N2))
				S = __return_value(S, ",")
				j = N2
				for (i = 1; i <= crsz - N2; i++) {
					s = __join_str(s, V[i + N2], S)
					delete V[i + N2]
					if (! (i % nsz) || i == crsz - N2) {
						V[++j] = s
						s = ""
					}
				}
			} else {
				j = crsz
			}
			if (j < N1) {
				D = __return_value(D, "0")
				do {
					V[++j] = D
				} while (j < N1)
			}
			return j
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
			V[0] = insert_indexed_item(V, D, __return_value(S, ","), int(V[0]))
		} else if (M == "isempty") {
			if (V[0])
				return 0
			else
				return 1
		} else if (V[0]) {
			c = V[V[0]]
			if (M == "pop")
				V[0] = __delete_indexed_hashmap(V, int(V[0]), "back")
			return c
		}
	}
}

# V: The queue, represented as an indexed hashmap.
# M: The operation mode (enqueue, dequeue, peek, isempty).
# D: The data to enqueue (if M is enqueue).
# S: The delimiter for splitting the data.
function queue(V, M, D, S, 	c, idx)
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

function unique_indexed_array(D, V, S,		v, s)
{
	S = __return_value(S, ",")
	array(D, v, S)
	s = __join_array(v, S)
	delete v
	return split(s, V, S)
}

function compare_arrays(DA, DB, M, S, O,	dlm, va, vb, s)
{
	__load_delim(dlm, S, O)
	if (M = match_option(M, "left, right, intersect, difference")) {
		if (M == "right") {
			array(DB, va, dlm["s"])
			array(DA, vb, dlm["s"])
		} else {
			array(DA, va, dlm["s"])
			array(DB, vb, dlm["s"])
		}
		for (i in va) {
			if (EQTT__(i in vb, M == "intersect"))
				s = __join_str(s, i, dlm["o"])
		}
		if (M == "difference") {
			for (i in vb) {
				if (! (i in va)) {
					s = __join_str(s, i, dlm["o"])
				}
			}
		}
		delete va
		delete vb
	}
	delete dlm
	return s
}

