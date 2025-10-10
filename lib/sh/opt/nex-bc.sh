
__nx_bc()
(
	eval "$(nx_str_optarg ':s:c:m:' "$@")"
	printf '%s\n' "$(nx_data_include -i "${NEXUS_LIB}/bc/nex-$m.bc")
		${s:+scale $s}
		$c
	" | bc -l
)

__nx_bc_trig()
(
	eval "$(nx_str_optarg 's:c:rd' "$@")"
	tmpa="${s:+-s "$s"}"
	if test -n "$r"; then
		__nx_bc -m 'trig' $tmpa -c "deg2rad($c)"
	elif test -n "$r"; then
		__nx_bc -m 'trig' $tmpa -c "$rad2deg($c)"
	else
		__nx_bc -m 'trig' $tmpa -c "$c"
	fi
)

nx_bc_trig()
{
	__nx_bc_trig $@
}

