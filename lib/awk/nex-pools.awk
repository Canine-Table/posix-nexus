#nx_include nex-misc.awk

function nx_blk_flags(N, V, n, m, b, p)
{
	n = 1
	if ((N = int(N)) <= 1) {
		if (N == 0 || N == 1)
			return N
		N = -N
		p = 0
		do {
			m = N / 2
			N = int(m)
			if (m = N != m)
				V[p] = n
			b = m b
			++p
			n += n
		} while (N > 0)
		return b
	}
	do {
		m = n
		n += n
	} while (n < N)
	return m
}

function nx_blk_init(V, N1, N2,
	dir, blk, hdr, tp, pl, sn)
{
	sn = 1

	if (N1 < 0) {
		sn = -sn
		N1 = -N1
		if (N2 > 0)
			N2 = -N2
	} else if (N2 < 0) {
		N2 = -N2
	}

 	N1 = __nx_if((N1 = nx_blk_flags(N1) * 2) > 64, N1, 64)
 	hdr = N2 / 2
 	if ((N2 = int(N2)) > hdr)
 		N2 = hdr
 	else if (N2 < 8)
 		N2 = 8

	if (sn == 1) {
		blk = 0
		hdr = 1
		tp = 2
		dir = 4
		pl = N1
	} else {
		blk = "-0"
		hdr = -1
		tp = -2
		dir = -4
		pl = -N1
	}
	V[blk] = pl # set the pool size
	V[hdr] = N2 # set the header size
	V[tp] = pl
	V[dir] = sn
	V[pl] = pl + N2
	return pl
}

#################################################################

function nx_blk_realloc(V, N)
{
	if (N < 0)
		return nx_blk_rePalloc(V)
	return nx_blk_repalloc(V)
}

function nx_blk_repalloc(V)
{
	return _nx_blk_realloc(V, V[0], V[1], 2, 3, V[4])
}

function nx_blk_rePalloc(V)
{
	return _nx_blk_realloc(V, V["-0"], V[-1], -2, -3, V[-4])
}


# N1:	blk
# N2:	hdr
# N3:	top ptr
# N4:	free list index ptr
# N5 	direction
function _nx_blk_realloc(V, N1, N2, N3, N4, N5,
	cur, nxt, prv, nidx, pidx)
{
	if (N4 in V) { # [-+]3 in V?
		cur = V[N4]
		if (cur + N5 in V) { # has next?
			if (cur in V) { # has prev?
				pidx = -V[cur] + N5
				nidx = -V[cur + N5]
				nxt = V[nidx]
				prv = V[pidx]
				V[prv] = nxt
				V[nxt] = prv
			}
		} else if (cur in V) { # is tail?
			delete V[-V[cur] + N5]
		} else {
			delete V[N4]
		}
		delete V[cur]
	} else { # new pool needed
		print "aa"
		N1 = V[N3] + N1
		cur = N1
		V[N3] = N1
	}
	V[cur + N5] = cur + N2
	return cur
}
#################################################################
function nx_blk_pfree(V, N)
{
	return _nx_blk_free(V, N, V[0], V[1], 3, V[4])
}

function nx_blk_Pfree(V, N)
{
	return _nx_blk_free(V, N, V["-0"], V[-1], -3, V[-4])
}

function _nx_blk_free(V, N1, N2, N3, N4, N5,
	nidx, pidx, prv)
{
	nidx = V[N1 + N5]
	if (N1 in V) # has prev
		pidx = V[N1]
	else
		pidx = 0
	if (nidx && nidx % N2) { # not a next block?
		if (pidx + N5 in V)
			prv = V[pidx + N5]
		else
			prv = 0
		if (prv != prv % N2) # has prev?
			V[pidx + N5] = pidx + N2 - N5 # its now just a full pool
	} else {
		if (pidx && pidx % N2) { # not a prev block?
			delete V[nidx]
		} else {
			V[nidx] = pidx
			V[pidx + N5] = nidx
		}
	}
	if (N4 in V) {
		nidx = V[N4]
		V[N1 + N5] = -nidx
		V[nidx] = -N1
	} else {
		delete V[N1 + N5]
	}
	delete V[N1]
	V[N5] = N1
}

#################################################################

function nx_blk_push(V, N, D)
{
	if (N < 0)
		return nx_blk_Ppush(V, N, D)
	return nx_blk_ppush(V, N, D)
}

function nx_blk_Ppush(V, N, D)
{
	return _nx_blk_push(V, N, V["-0"], V[-4], D)
}

function nx_blk_ppush(V, N, D)
{
	return _nx_blk_push(V, N, V[0], V[4], D)
}

# N1:	blk
# N2:	hdr
# N3:	top ptr
# N4:	free list index ptr
function _nx_blk_push(V, N1, N2, N3, D,
	pl, cur, tp)
{
	pl = N1
	tp = V[N1] + N3
	if (!(tp % N2)) { # zero
		pl = nx_blk_realloc(V, N1)
		tp = V[pl + N3]
		V[N1 + N3] = pl
		V[pl] = N1
	}
	V[pl] = tp
	V[tp] = D
	return pl
}

# 
# function nx_blk_rvs_piter(V, N,
# 	blk, hdr, pl, iter, tp)
# {
# 	blk = V[0]
# 	hdr = V[1]
# 	N = N - N % blk + 1
# 	pl = __nx_if(N > blk * 2, N, blk * 2 + 1)
# 	if (pl > V[2])
# 		return
# 
# 	if (pl + 4 in V) {
# 		iter = --V[pl + 4]
# 		print iter
# 		print pl
# 		print V[pl+1]
# 		if (iter <= pl + hdr) {
# 			delete V[pl + 4]
# 			if (! (pl + 1 in V))
# 				return
# 			#print pl
# 			pl = V[pl]
# 			if (pl + 4 in V)
# 				delete V[pl + 4]
# 			#print pl
# 			return
# 			return nx_blk_rvs_piter(V, pl)
# 		}
# 		print iter
# 		N = iter
# 	} else {
# 		N = V[pl]
# 		while (N <= pl + hdr) {
# 			if (! (pl + 1 in V))
# 				return
# 			pl = V[pl + 1]
# 			N = V[pl]
# 		}
# 		if (N % blk == 1)
# 			N--
# 		V[pl + 4] = N
# 	}
# 	return N
# }
# 



#When the block is empty,
#V[pl] == pl + hdr

#When the block is full,
#V[pl] == pl + blk - 1

# 
# function nx_blk_rvs_piter(V, N,
# 	blk, hdr, pl, tp)
# {
# 	blk = V[0]
# 	hdr = V[1]
# 	pl = N - N % blk + 1
# 	if (! (pl + 4 in V))
# 		V[pl + 4] = V[pl] + 1
# 	tp = pl + hdr + 1
# 	N = --V[pl + 4]
# 	if (N < tp) {
# 		delete V[pl + 4]
# 		do {
# 			if (pl + 1 in V) {
# 				pl = V[pl + 1]
# 				N = V[pl]
# 			} else {
# 				return
# 			}
# 		} while (N <= pl + hdr)
# 		if (N % blk == 0)
# 			N--
# 	}
# 	V[pl + 4] = N
# 	return N
# }
# 
# function nx_blk_fwd_piter(V, N,
# 	blk, hdr, pl, iter, tp)
# {
# 	blk = V[0]
# 	if ((pl = N - N % blk) > V[2])
# 		return
# 	hdr = V[1]
# 
# 	if (pl + 4 in V)
# 		iter = ++V[pl + 4]
# 	else
# 		iter = pl + hdr
# 
# 	tp = V[pl]
# 	while (iter % blk == 0) {
# 
# 	}
# 		delete V[pl + 4]
# 		pl = tp
# 		N = pl + hdr
# 		if (N in V)
# 			V[pl + 4] = N
# 		else
# 			delete V[pl + 4]
# 	} else if (iter <= tp) {
# 		N = iter
# 	} else {
# 		delete V[pl + 4]
# 	}
# 	if (pl + 4 in V)
# 		V[pl + 4] = N
# 	else
# 		return
# 	} else {
# 	}
# 	return N
# }

