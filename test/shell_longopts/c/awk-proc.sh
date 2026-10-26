(
	nx_data_longopt -- '
		r<@tfc, trunc round floor ceiling>
		<type str>
		<regex ^(trunc|round|floor|ceiling|t|r|f|c)$>
		<default round>
		<description Default rounding mode: trunc, round, floor, ceiling (or t/r/f/c); default round>

		help<h>
		<description Show help for nx_int_round>
		<build exit;>
	' "$@"
)


