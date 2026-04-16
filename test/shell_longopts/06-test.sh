
${AWK:-$(nx_cmd_awk)} "
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-sh-extras.awk")
"'
	BEGIN {
		#nx_lsh_optargs(" n&No&Not:<nx:null/>-n<nx:null/>hello world", 4)
		#nx_lsh_optargs(" n&No&Not:<nx:null/>--No=world hello", 4)
		nx_lsh_optargs(" n&No&Not:<nx:null/>i was here<nx:null/>-n<nx:null/>hello world<nx:null/>i am here<nx:null/>-n=world says hello<nx:null/>--No+= world hello<nx:null/>-n-1=hello<nx:null/>--Not-=world ", 4, arr)
		for (i = 0; i >= arr["-0"]; i -= 3)
			print i " = " arr[i]
	}
'

