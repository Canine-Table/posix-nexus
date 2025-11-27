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
	nx_data_optargs 'r:j:n:' "$@"
	NEX_k_n="$(nx_int_range -o -g '-1' -v "$NEX_k_n")"
	${AWK:-$(nx_cmd_awk)} -v jdump="$NEX_k_j" -v root="${NEX_k_r:-}" -v indent="$NEX_k_n" \
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

