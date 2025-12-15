
${AWK:-$(nx_cmd_awk)} "
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-sh-extras.awk")
"'
	BEGIN {
		nx_lsh_optargs("f@h:f:a:s:b car bar;v:r#d <nx:null/>abcd", 4)
	}
'

