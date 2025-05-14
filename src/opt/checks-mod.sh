
nx_check_count()
{
	${AWK:-$(nx_cmd_awk)} \
		-v mch="$1" '
		BEGIN {
			counter = 0
		} {
			counter = counter + gsub(mch, "", $0)
		} END {
			print counter
		}
	' < "${2:-$TMPDIR/count.txt}"
}
