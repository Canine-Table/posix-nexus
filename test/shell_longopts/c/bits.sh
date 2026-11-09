${AWK:-$(nx_cmd_awk)} -v x="$1" \
	-v dit="$NEX_Gk_d" \
"
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-bits.awk")
"'
	BEGIN {
		print "next * 1: " nx_bit_next(x*1)
		print "prev * 1: " nx_bit_prev(x*1)
		print "round * 1: " nx_bit_round(x*1)
		print "next * 2: " nx_bit_next(x*2)
		print "prev * 2: " nx_bit_prev(x*2)
		print "round * 2: " nx_bit_round(x*2)
	}
'
