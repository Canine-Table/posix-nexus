#nx_include nex-struct.awk
#nx_include nex-io.awk


function nx_jsn_mach(V1, V2,
	idx, ln, dep, ptr,
	cr)
{
	ln = V[6]
	dep = V[8]
	ptr = V[10]
	for (idx = 1; idx <= ln; ++idx) {
		cr = 
		if (ste == 1) {
			print V1[idx]
		} else if (ste == 2) {
		}
	}
}

# D1	data to add
# V1	the json structure
# V2	
function nx_jsn(D, V, B,
	stk, tok,
	fl,
	rec, ln, ste, dep)
{
	if (D == "") {
		return 226
	}

	# object:	1
	# array:	2
	# string:	3
	# number:
	# boolean
	# # null


	nx_parr_stk(stk, 2)
	nx_parr_stk(stk, 2, 0)
	stk[2] = "}"
	stk[4] = "]"
	stk[6] = 0 # length
	stk[8] = 0 # depth

	ste = 1
	if (nx_is_file(D, 1)) {
		fl = D
		print D
		while ((getline rec < fl) > 0) {
			stk[8] = split(rec, tok, "")
			nx_jsn_mach(stk, tok)
		}
		close(fl)
	} else {
		ln = split(D, tok, "")
		nx_jsn_mach(ln, tok)
	}
}
