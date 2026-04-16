
${AWK:-$(nx_cmd_awk)} "
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-sh-extras.awk")
"'
	BEGIN {
		nx_lsh_optargs(" A&AND&and&And&a O&o&or&Or&OR&o<nx:null/>-a<nx:null/>-o", 4, arr)
	}
'

