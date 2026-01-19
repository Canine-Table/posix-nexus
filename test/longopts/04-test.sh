# flags

${AWK:-$(nx_cmd_awk)} "
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-sh-extras.awk")
"'
	BEGIN {
		str = " y&Y&yes n&N&no;xyz<nx:null/>-x=hi<nx:null/>-N<nx:null/>-n=\x22not today\x22<nx:null/>-N+= yes today<nx:null/>-y<nx:null/>-Y"
		nx_lsh_optargs(str, 4)
	}
'

