
${AWK:-$(nx_cmd_awk)} "
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-io.awk")
"'
	BEGIN {
		nx_file_merge2("NX_L:/nex-io.awk", 2, "", ",", "<nx:null/>,#,/,.,nx_include", 1)
	}
'

