(
	nx_data_longopt -v 4 -- '
		<default int>
		<build echo;>

		a	@
				b
		;c#
			d%
		E<%e>,
		alpha<@beta;fgh>,
		help<>
		i@j%k@l%m#opq,rest<;long;rs@t!uv>
	' "$@"
)

#		
#		<description h>
#
#		i<#,is also>
