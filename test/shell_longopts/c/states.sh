(
	nx_data_longopt -- ',
		i<#in input>

		o<%out output>
		
		a<@all another Things All things stuff>
	' "$@"

	echo "in: $NEX_GK_i"
	echo "out: $NEX_Gk_o"
	echo "a: $NEX_GF_a"

	#test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
)

