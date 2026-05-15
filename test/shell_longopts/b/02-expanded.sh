(
	nx_data_longopt -v=4 ',
		alpha<@
			beta
			theta
		>
		<
			description this is what this group does
		>
		<
			type no buddy knows
		>
		<
			usage we will let you know maybe
		>
	' --beta --theta
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
