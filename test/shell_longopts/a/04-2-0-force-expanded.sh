(
	nx_data_longopt -v=4 -f=2  '
			,		alpha	@
				beta
		,theta	%
		great#
	lol	
	,	rate
			@	
			alpha		<
		hello,		
		hi,		
			greetings;h
			H,and
			;
			> A#>
				B	%        >C@
				>,
			bye<no
			;n  N
			,not		
					>
			xor		
		%' -H -n
	echo "R => $NEX_ARGV_R"
	echo "S => $NEX_ARGV_S"
	echo "0 => $NEX_ARGV_0"
	i=1
        while test "$i" -le "$NEX_ARGC"; do
                k="$(nx_data_ref "NEX_ARGV_$i")"
                echo "$i => $k => $(nx_data_ref "$k")"
                i=$((i+1))
        done
)

