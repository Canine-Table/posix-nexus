${AWK:-$(nx_cmd_awk)} -v x="$1" -v y="$2" -v b="${3:-0}" \
	-v dit="$NEX_Gk_d" \
"
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-bits.awk")
"'
	BEGIN {
		print "assign: " nx_bit_assign(x, y, b)
		print "flip: " nx_bit_flip(x, y)
		print "on: " nx_bit_on(x, y)
		print "off: " nx_bit_off(x, y)
	}
'
