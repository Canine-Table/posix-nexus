#nx_include nex-struct.awk
#nx_include nex-io.awk


function nx_jsn_mach(N,
	idx)
{
	for (idx = 1; idx <= N; ++idx) {
		#if (ste == 1) {
			print tok[idx]
		#} else if (ste == 2) {
		#}
	}
}

function nx_jsn(D, V, B,
	stk, tok,
	fl,
	rec, ln, ste, dep)
{
	if (D == "") {
		return 226
	}

	# obj: 1
	# arr: 2
	nx_parr_stk(stk, 2)
	nx_parr_stk(stk, 2, 0)
	dep = 1
	ste = 1
	if (nx_is_file(D, 1)) {
		fl = D
		print D
		while ((getline rec < fl) > 0) {
			nx_jsn_mach(split(rec, tok, ""))
		}
		close(fl)
	}
}
