
${AWK:-$(nx_cmd_awk)} "
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-pools.awk")
"'
	BEGIN {
		print nx_blk_flags(-482, flgs)
		for (f in flgs)
			print f " = " flgs[f]
	}
'

