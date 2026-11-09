(

			#<build echo "captain=<nx@captain/ crew=<nx@cre\n">

	nx_data_longopt -- ',
		<description Silly demo of macro expansion across groups and positionals>

		captain<%Captain>
			<description The captain; macro-expands as <nx@captain/\\> in build strings>
			<build echo "captain=<nx@captain/\\> crew=<nx@crew/\\> mode=<nx@mode/\\> cycle=<nx@cycle-back/\\> period=<nx@period/\\>">

		crew<%>
			<default Spock>
			<description The first officer; macro-expands as <nx@crew/\\>>

		mode<%>
			<default explore>
			<regex ^(explore|engage|retreat)$>
			<description Ship mode; constrained to a few values>

		period<%>
			<type int>
			<default 5>
			<min 1>
			<description Ring buffer for the leftover parameter>

		h<help>

		cycle-back<#Cycle-Back>
			<type toggle>
			<default <nx:true/\\>>
			<description Ring direction for the leftover parameter>

	' "$@"
	echo "$_CNT_NEX_Gk_captain"
	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
)

