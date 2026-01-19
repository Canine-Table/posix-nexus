
${AWK:-$(nx_cmd_awk)} "
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-pools.awk")
"'
	BEGIN {
		n = nx_blk_init(stk, 64, 8)
		n = nx_blk_push(stk, n, "hello")
		n = nx_blk_push(stk, n, "hello")
		n = nx_blk_push(stk, n, "world")
		n = nx_blk_push(stk, n, "world")

		#p = nx_blk_ppush(stk, n, "hello")
		#n = nx_blk_ppush(stk, p, "world")
		#n = nx_blk_ppush(stk, n, "this")
		#n = nx_blk_ppush(stk, n, "is")
		#n = nx_blk_ppush(stk, n, "tom")
		#n = nx_blk_ppush(stk, n, "hello")
		#i = n
		#n = nx_blk_ppush(stk, n, "another world")
		#nx_blk_pfree(stk, i)
		#n = nx_blk_ppush(stk, n, "this")
		#n = nx_blk_ppush(stk, n, "is")
		#n = nx_blk_ppush(stk, n, "still tom")
		#i = nx_blk_fwd_piter(stk, p)
		for (k in stk)
			print k " = " stk[k]
		#do {
		#	print i " is " stk[i]
		#	n = i
		#	i = nx_blk_fwd_piter(stk, i)
		#} while (i != "")
		#i = n
		#while (i != "") {
		#	i = nx_blk_rvs_piter(stk, i)
		#
		#	print i " is rvs " stk[i]
		#}
	}
'

