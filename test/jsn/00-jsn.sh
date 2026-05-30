awk "
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-jsn.awk")
"'
	{
		nx_jsn($0)
	}
' sample.json


