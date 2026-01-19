#nx_include nex-struct.awk
#nx_include nex-str.awk
#nx_include nex-int-extras.awk
#nx_include nex-misc-extras.awk

function nx_kwds(V, D1, D2, v)
{
	if (D1 == "")
		return -1
	D1 = split(D1, v, __nx_else(D2, "<nx:null/>"))
	if (nx_even(D1) && v[D1] != "<nx:placeholder/>") {
		for (D2 = 1; D2 <= D1; ++D2) {
			if (nx_even(D2)) {
				V[v["lst"]] = v[D2]
			} else {
				v["lst"] = v[D2]
			}
		}
		D1 = D1 % 2
	} else {
		delete v[D1--]
		for (D2 = 1; D2 <= D1; ++D2)
			V[v[D2]] = ""
	}
	delete v
	return D1
}

function nx_find_pair(D1, V1, V2, D2, D3,	trk, splt)
{
	if (D1 == "")
		return -1
	if (! (0 in V2) || int(V2[0]) < 4) {
		if (D2 != "")
			nx_kwds(V2, D2, D3)
		nx_parr_stk(V1, 4)
	}
	for (D2 in V2) {
		if (trk["sidx"] = nx_nesc_match(D1, D2, 1, 1)) {
			trk["lsidx"] = length(D2)
			if (V2[D2] != "") {
				trk["nstr"] = substr(D1, trk["lsidx"] + trk["sidx"])
				split(nx_nesc_match(trk["nstr"], V2[D2]), splt, "<nx:null/>")
				if (trk["eidx"] = splt[2]) {
					nx_parr_stk(V1, 1, trk["sidx"])
					nx_parr_stk(V1, 2, trk["lsidx"])
					nx_parr_stk(V1, 3, trk["eidx"] - 1)
					nx_parr_stk(V1, 4, length(V2[D2]))
				}
			} else {
				nx_parr_stk(V1, 1, trk["sidx"])
				nx_parr_stk(V1, 2, trk["lsidx"])
				nx_parr_stk(V1, 3, "0")
				nx_parr_stk(V1, 4, "0")
			}
		}
	}
	delete trk
}

function nx_uarr(V, D)
{
	if (D1 == "")
		return -1
	return V[D1]++
}

function nx_idx_uarr(V, D)
{
	if (nx_uarr(V, D) == 1) {
		return V[++V[0]] = D
		return V[0]
	}
	return -1
}

function nx_arr_flip(V,		i)
{
	for (i in V)
		nx_bijective(V, i, 0, V[i])
}

function nx_arr_split(D1, V, D2, B,	v)
{
	if (D1 == "")
		return -1
	if (B)
		B = nx_trim_split(D1, v, D2)
	else
		B = split(D1, v, D2)
	for (D2 = 1; D2 <= B; ++D2)
		V[v[D2]]++
	delete v
	return length(V)
}

function __nx_arr_compare(V1, D, V2, B)
{
	V2["irt"] = V2["dr"] "0"
	if (B) {
		V2["rt"] = D
		V2["irt"] = 0
	} else {
		V2["irt"] = V2["dr"] "0"
		V2["rt"] = V2["dr"] V2["ks"] D
	}
	if (V2["bs"] == 1) {
		nx_bijective(V1, V2["rt"], __nx_only(! B, V2["dr"] "") ++V1[V2["irt"]])
	} else if (V2["bs"] == 2) {
		if (B && ! (V2["rt"] in V1))
			V1[0]++
		V1[V2["rt"]]++
	} else if (V2["bs"] == 3) {
		V1[__nx_only(! B, V2["dr"] "") ++V1[V2["irt"]]] = D
	} else {
		nx_boolean(V2, V2["rt"])
	}
}

function nx_arr_compare(V1, V2, V3, D1, D2, B,	trk)
{
	if (! ("dr" in trk)) {
		trk["dr"] = tolower(D1)
		if (int(B) < 2) {
			trk["ks"] = __nx_else(D1, "=")
			if (! (trk["bs"] = sub(/^%/, "", D1)))
			if (trk["bs"] = sub(/^[+]/, "", D1))
				trk["bs"] = 2
			else
				trk["bs"] = __nx_if(D1 == trk["dr"], 0, 3)
		} else {
			trk["bs"] = 2
		}
		if (trk["dr"]  == "r")
			return nx_arr_compare(V2, V1, V3, "r", "", B, trk)
		else if (trk["dr"] != "d" && trk["dr"] != "i")
			trk["dr"] = "l"
	}

	for (D1 in V1) {
		if ((D1 in V2) == (trk["dr"] == "i")) {
			__nx_arr_compare(V3, D1, trk, B)
		}
	}
	if (trk["dr"] == "d") {
		for (D1 in V2) {
			if (! (D1 in V2)) {
				__nx_arr_compare(V3, D1, trk, B)
			}
		}
	}
	delete trk
}


function nx_grid(V, D, N)
{
	if (D) {
		if (! (0 in V && "|" in V && "-" in V)) {
			V[0] = 1
			V["|"] = 1
			V["-"] = 1
		}
		if ((N = __nx_else(nx_natural(nx_digit(N, 1)), V[0])) < V["-"])
			N = V["-"]
		while (V[0] < N) {
			if (! (++V[0] in V))
				V[V[0]] = 0
		}
		V[N "," ++V[N]] = D
	} else if (N) {
		while (! V[V[0]] && V["-"] <= V[0])
			delete V[V[0]--]
		if (V["-"] <= V[0]) {
			N = V[V[0] "," V[V[0]]]
			if (D == "")
				delete V[V[0] "," V[V[0]]--]
			return N
		}
	} else {
		while (V[V["-"]] < V["|"] && V["-"] <= V[0]) {
			delete V[V["-"]++]
			V["|"] = 1
		}
		if (V["-"] <= V[0]) {
			N = V[V["-"] "," V["|"]]
			if (D == "")
				delete V[V["-"] "," V["|"]++]
			return N
		}
	}
}

function __nx_swap(V, D1, D2,	t)
{
	t = V[D1]
	V[D1] = V[D2]
	V[D2] = t
}

function nx_length(V, B,	i, j, k)
{
	if (! (0 in V))
		return -1
	for (i = 1; i <= V[0]; i++) {
		j = length(V[i])
		if (! k || __nx_if(B, k < j, k > j))
			k = j
	}
	return int(k)
}

function nx_boundary(D, V1, V2, B1, B2,		i)
{
	if (! (0 in V1 && D != ""))
		return -1
	for (i = 1; i <= V1[0]; i++) {
		if (__nx_if(B1, V1[i] ~ D "$", V1[i] ~ "^" D))
			V2[++V2[0]] = V1[i]
	}
	if (B2)
		delete V1
	return V2[0]
}

function nx_filter(D1, D2, V1, V2, B,	i, v1, v2)
{
	if (! (0 in V1))
		return -1
	for (i = 1; i <= V1[0]; i++) {
		if (__nx_equality(D1, D2, V1[i]))
			V2[++V2[0]] = V1[i]
	}
	if (B)
		delete V1
	return V2[0]
}

function nx_option(D, V1, V2, B1, B2,	i, v)
{
	if (! (0 in V1 && D != ""))
		return -1
	if (nx_boundary(D, V1, v, B1) > 1) {
		if (nx_filter(nx_append_str("0", nx_length(v, B2)), "=_", v, V2, 1) == 1) {
			i = V2[1]
			delete V2
			return i
		}
	} else {
		i = v[1]
		delete v
		return i
	}
}


# V[cur + 1] = "\0" # block prev sibling
# V[cur + 2] = "\0" # block next sibling
# V[cur + 3] = "\0" # block parent
# V[cur + 4] = "\0" # block child
function nx_dfs_stk_walk(V, N1, N2,
	cur, hdr, i, j)
{
	hdr = V[-1]
	if (! (N2 in V) || V[int(N2) + 6] != N2)
		cur = V[0]
	else
		cur = N2
	if (V[cur + 6] != cur) {
		nx_ansi_error("im not touching pool id '" cur "', its beyond my understanding :(\n")
		return -1
	}
	# -> child -> sibling -> parent -> sibling -> done
	while (1) {
		j = V[cur]
		if (N1 > 2)
			nx_dfs_stk_hdr(V, N1, cur)

		for (i = cur + hdr; i <= j; ++i)
			nx_fd_stderr(V[i] "\n")
		if (cur + 4 in V) {
			cur = V[cur + 4]
			continue
		} else if (cur + 2 in V) {
			cur = V[cur + 2]
			continue
		} else if(cur + 3 in V) {
			cur = V[cur + 3]
			if (cur + 2 in V) {
				cur = V[cur + 2]
				continue
			}
		}
		break
	}
}

function nx_dfs_stk_hdr(V, N1, N2,
	hdr, id, idx, chld, parn, nxt, prv)
{
	if (! N2)
		N2 = V[0]
	N1 = int(N1)
	id = V[int(N2) + 6]
	if (N2 != id) {
		if (N1 > 0)
			nx_ansi_error(N2 " is not a pool id\n")
		return -1
	}
	hdr = V[-1] - 1
	idx = V[id]

	if (id + 4 in V)
		chld = V[id + 4]
	else
		chld = "nil"

	if (id + 3 in V)
		parn = V[id + 3]
	else
		parn = "nil"

	if (id + 2 in V)
		nxt = V[id + 2]
	else
		nxt = "nil"

	if (id + 1 in V)
		prv = V[id + 1]
	else
		prv = "nil"

	if (N1 > 2) {
		nx_ansi_error("\npool id: " id)
		nx_ansi_error("\nindexes: " idx - id - hdr)
		nx_ansi_error("\theader size: " hdr)
		nx_ansi_error("\ntop index: " idx)
		nx_ansi_error("\nprevious sibling: " prv)
		nx_ansi_error("\nnext sibling: " nxt)
		nx_ansi_error("\nparent: " parn)
		nx_ansi_error("\nchild: " chld)
		nx_ansi_error("\ndepth: " V[id + 5])
		nx_ansi_error("\nmeta store: " V[id + 7])
		nx_ansi_error("\ntop value: " V[idx] "\n")
	}
}

# with pool A, B, C
# 
# A is the initial share pool
# with link 0
# B -> A => B -> A
# C -> A => B -> A, C -> A
# 
# with link 1
# B -> A => A -> B
# C -> A => A -> B -> C
# 
# with link 2
# B -> A => A <-> B <- A
# C -> A => A <-> B <-> C <- A

		#D2 = __nx_if(D2 > 3, 1, D2)
		#V[-2] = D2
# 0:	no link
# 1:	single link
# 2 	double link
# D2 = nx_absolute(int(D2))
# V[-2 - D1] = "\0" # prev metadata block
# does what it says, unless its the first link, it points to to topmost block
# if doubling linked is disabled, it will be the link to node 1 in the chain
# V[-3 - D1] = "\0" # next metadata block
# when not negative and not == V[, the pool is not full,
# when negative, its a pointer to the next pool
# If no link is set and is full, its neg value with point to itself

# V[cur + 1] = "\0" # block prev sibling
# V[cur + 2] = "\0" # block next sibling
# V[cur + 3] = "\0" # block parent
# V[cur + 4] = "\0" # block child
#V[cur + 5] = 0     # block depth
#V[cur + 6]         # pool id
#V[cur + 7] = -D1 - D1  # meta store

#V[0] = cur  # the cursor
#V[cur] = cnt  # start of data block
#V[cnt] = D1


function nx_dfs_stk(V, D1, D2, N,
	cur, cnt, dep, meta, blk, hdr)
{
	if (! (0 in V)) {
		D2 = __nx_if(int(D2) > 9, D2, 9)
		V["-0"] = -1 # the meta data counter
		V[-1] = D2 # block data padding and metadata block size
		
		cur = D2 + 1
		V[cur + 5] = 0    # block depth
		V[cur + 6] = cur    # pool id
		V[cur + 7] = -D2 - 1 # meta store index
		cnt = cur + D2
		V[cur] = cnt
		V[cnt] = D1
		V[0] = cur
		
		nx_dfs_stk_hdr(V, N, cur)
		return cur
	}

	cur = V[0] # current cursor
	cnt = V[cur + 6] # pool id
	if (cur != cnt) {
		if (N > 0)
			nx_ansi_error(cur " is not a pool id\n")
		return -1
	}
	cnt = V[cur] + 1 # the next free index
	dep = V[cur + 5]

	if (! (D2 == "-" && dep > 0 || D2 == "+")) {
		V[cnt] = D1
		V[cur] = cnt
		nx_dfs_stk_hdr(V, N, cur)
		return cur
	}

	blk = V[-1] # block start, aka header size
	meta = --V["-0"] * blk - 1 # metadata index
	blk += cnt
	V[cnt] = blk # set start of block for the pool
	V[cnt + 7] = meta
	V[blk] = D1


	# TODO
	if (D2 == "+") {
		V[cnt + 5] = ++dep
		V[cur + 4] = cnt # child is of next idx, cnt is now cur of child
		V[cnt + 3] = cur # set the parent of child
	} else if (D2 == "-") {
		dep = __nx_if(--dep > 0, dep, 0)
		V[cnt + 5] = dep
		D2 = cur
		do {
			if (cur + 3 in V)
				cur = V[cur + 3]
		} while (V[cur + 5] != dep && --D2 > 0)
		if (D2 == 0)
			nx_ansi_error("something happended to " D2 " :(\n")
		V[cnt + 1] = cur # the parent of depth + 1 is sibling of depth
		V[cur + 2] = cnt
		if (cur + 3 in V)
			V[cnt + 3] = V[cur + 3] # siblings share a parent, confusing, I know...
	}
	V[0] = cnt # move the cursor to the pool head
	V[cnt + 6] = cnt
	nx_dfs_stk_hdr(V, N, cnt)
	return cnt
}

