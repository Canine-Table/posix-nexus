#nx_include nex-cmd.sh
#nx_include nex-data.sh
#nx_include nex-int.sh

nx_data_jdump()
{
	${AWK:-$(nx_cmd_awk)} -v jdump="$*" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		BEGIN {
			nx_json(jdump, arr, 2)
			for (jdump in arr)
				printf("%s = %s\n", jdump, arr[jdump])
			delete arr;
		}
	'
}

nx_data_jtree()
(
	nx_data_longopt -- ',
	j<%json>
	<description JSON input to parse and flatten>

	n<%indent>
	<description Indentation level for flatten output>
	<type int>
	<default 4>
	<min 0>
	<max 32>

	r<%root>
	<description Optional root path to start flattening from>

	help<h>
	<description Show help>
	<build exit;>
	' "$@"
	${AWK:-$(nx_cmd_awk)} \
		-v jdump="$NEX_Gk_j" \
		-v root="$NEX_Gk_r" \
		-v indent="$NEX_Gk_n" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		BEGIN {
			if (err = nx_json(jdump, arr, 2))
				exit err
			print nx_json_flatten(root, arr, indent)
			delete arr
		}
	'
)

