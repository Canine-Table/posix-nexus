
${AWK:-$(nx_cmd_awk)} \
	-v "$(nx_str_chain "f@h:f:a:s:b car bar;v:r" "abcd")" \
	"
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-shell.awk")
"'
	BEGIN {;
		nx_lsh_optargs("f@h:f:a:s:b car bar;v:r#d <nx:null/>abcd", 4)
	}
'

