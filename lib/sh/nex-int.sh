
nx_int_natural()
{
	${AWK:-$(nx_cmd_awk)} \
		-v num="$1" \
		'BEGIN { if (num ~ /^[1-9]+[0-9]*$/) {print num} else {exit 1} }'
}

