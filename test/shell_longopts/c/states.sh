(
	nx_data_longopt -- '
		<default int>
		<description Introspect a DBus service (raw XML)>
		<regex ^[A-Za-z0-9_.]+$>
		<build echo <nx@1/\\>"a";>
		<epilog things to test>
		<usage for the stuff>
		<min 0>
		<max 1>
		<type str>
		<default yes>

		a	@
				b
		;c#
			d%
		E<%e>,
		alpha<@beta;fgh><lazy>,
		help<>
		i@j%k@l%m#opq,rest<%long;rs@t!uv>
		<lazy>
		<description EOF>
		<type char[2]>
		<default no>

	' "$@"
	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
)

