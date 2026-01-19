# flags

${AWK:-$(nx_cmd_awk)} -v str="$1" "
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-sh-extras.awk")
"'
	BEGIN {
		print nx_sh_opts_actions("arg-0=\x22hello world\x22", "[-]|[+]", "=", arr)
		for (i in arr)
			print i "  =  " arr[i]
		delete arr
	}
'

