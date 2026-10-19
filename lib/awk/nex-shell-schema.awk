function __nx_shell_schema_str(V, D, B)
{
	V["-u"] = "<nx:false/>"
	D = ",u<unset>"
	D = D "<type toggle>"
	D = D "<default <nx:false/\\>>"
	D = D "<description Clear all NEX_ARGV_* NEX_ARGC and group variables in the current scope before processing new arguments>"

	V["-q"] = "<nx:false/>"
	D = D "q<quote>"
	D = D "<default <nx:false/\\>>"
	D = D "<type toggle>"
	D = D "<description Use double-quoted values instead of single-quoted shell-safe literals; enables interpolation and requires careful escaping>"

	V["-C"] = "<nx:false/>"
	D = D "C<null-concat>"
	D = D "<default <nx:false/\\>>"
	D = D "<type toggle>"
	D = D "<description Treat empty values as valid concatenation operands instead of skipping them. Useful when building strings with intentional empty segments.>"

	V["-o"] = "<nx:false/>"
	D = D "o<override type-override>"
	D = D "<default <nx:false/\\>>"
	D = D "<type toggle>"
	D = D "<description Preserve the original group form and type when a group is redefined; forces the parser to reuse the existing symbol and prevents form switching.>"

	V["-e"] = "<nx:false/>"
	D = D "e<export>"
	D = D "<default <nx:false/\\>>"
	D = D "<type toggle>"
	D = D "<description Emit export VAR=value; instead of VAR=value during environment construction.>"

	V["-b"] = "<nx:false/>"
	D = D "b<backtrack>"
	D = D "<default <nx:false/\\>>"
	D = D "<type toggle>"
	D = D "<description  When a short-form bundle contains characters that are not valid options, preserve the leftover characters and push them into the remainder instead of discarding them. This does not affect value consumption; only kwarg-style consumer flags take values (e.g., -abc 1 2 3 → a=1, b=2, c=3 only when a, b, c are consumer flags).>"

	V["-a"] = __nx_if(B, "3", "0")
	D = D "a<abort>"
	D = D "<default 0>"
	D = D "<type int>"
	D = D "<description Abort parsing when encountering invalid or conflicting arguments. Accepts levels 0–3 controlling strictness.>"

	V["-v"] = "1"
	D = D "v<%verbose>"
	D = D "<default 1>"
	D = D "<type int>"
	D = D "<description Set verbosity level (0–5). Higher levels print schema, parse flow, and full IR dumps.>"

	V["-f"] = "0"
	D = D "f<force-group>"
	D = D "<default 0>"
	D = D "<type int>"
	D = D "<description Controls how existing group declarations are handled when a group opener is encountered again.\n\tgfr=0: do not modify the existing group; skip new entries.\n\tgfr=1: reuse the existing group’s type symbol for new entries (type-forcing).\n\tgfr=2: override the existing group leader; promote the new declaration to leader and rewire the group mapping.>"

	V["-d"] = "<nx:null/>"
	D = D "d<%delimiter delimiter-separator>"
	D = D "<default <nx:null\\>>"
	D = D "<type str>"
	D = D "<description Set the delimiter used to separate schema fields.>"

	V["-k"] = "%"
	D = D "k<%key key-separator>"
	D = D "<default %>"
	D = D "<type char>"
	D = D "<description Character used to separate key/value pairs in long‑form arguments.>"

	V["-g"] = "<"
	D = D "g<%open group-open>"
	D = D "<default <>"
	D = D "<type char>"
	D = D "<description Character marking the start of a group.>"

	V["-G"] = ">"
	D = D "G<%close group-close>"
	D = D "<default \\>>"
	D = D "<type char>"
	D = D "<description Character marking the end of a group.>"

	V["-F"] = "@"
	D = D "F<%flag-array flag-array-separator>"
	D = D "<default @>"
	D = D "<type char>"
	D = D "<description Separator used for flag arrays (multiple boolean flags grouped together).>"

	V["-K"] = "#"
	D = D "K<%key-array key-array-separator>"
	D = D "<default #>"
	D = D "<type char>"
	D = D "<description Separator used for key/value arrays (multiple key/value pairs grouped together).>"

	V["-l"] = ","
	D = D "l<%long>"
	D = D "<default ,>"
	D = D "<type char>"
	D = D "<description Character that begins or continues long‑option mode.>"

	V["-s"] = ";"
	D = D "s<%short>"
	D = D "<default ;>"
	D = D "<type char>"
	D = D "<description Character that continues short-option mode or ends long‑option mode and returns to short‑option parsing.>"

	V["-p"] = "<nx:null/>"
	D = D "p<%param parameter-separator>"
	D = D "<default <nx:null/\\>>"
	D = D "<type char>"
	D = D "<description Parameter separator used to split arguments into schema fields.>"

	V["-S"] = "="
	D = D "S<%set>"
	D = D "<default =>"
	D = D "<type char>"
	D = D "<description Symbol used to assign values to keys (e.g., --opt=value).>"

	V["-A"] = "+"
	D = D "A<%add push>"
	D = D "<default +>"
	D = D "<type char>"
	D = D "<description Push modifier symbol. Appends values to arrays or repeated options.>"

	V["-D"] = "-"
	D = D "D<%remove pop delete>"
	D = D "<default ->"
	D = D "<type char>"
	D = D "<description Pop/delete modifier symbol. Removes values or unsets options.>"

	V["-M"] = "@"
	D = D "M<%match find>"
	D = D "<default @>"
	D = D "<type char>"
	D = D "<description Symbol used to mark the match/find modifier in expressions; selects which character denotes the match pattern buffer.>"

	V["-R"] = "~"
	D = D "R<%subtitute replace>"
	D = D "<default ~>"
	D = D "<type char>"
	D = D "<description Symbol used to mark the substitute/replace modifier in expressions; selects which character denotes replacement operations using the match buffer.>"

	V["-I"] = "#"
	D = D "I<%index idx>"
	D = D "<default #>"
	D = D "<type char>"
	D = D "<description Symbol used to mark the index-of-match modifier in expressions; selects which character denotes queries for the first match position.>"

	V["-N"] = "%"
	D = D "N<%number count>"
	D = D "<default %>"
	D = D "<type char>"
	D = D "<description Directive that injects build metadata (version, date, VCS tag) into the schema.>"

	V["-c"] = " "
	D = D "c<%concat concatenate concatenation-separator>"
	D = D "<default \\ >"
	D = D "<type str>"
	D = D "<description String used to join remainder arguments when flattening or emitting environment variables.>"

	V["-y"] = "="
	D = D "y<%assign assign-separator>"
	D = D "<default =>"
	D = D "<type str>"
	D = D "<description Separator inserted between variable name and value in generated environment assignments.>"

	V["-L"] = "._-:"
	D = D "L<%extra-long-characters>"
	D = D "<default ._-:>"
	D = D "<type str>"
	D = D "<description Additional characters allowed inside long‑form option names beyond alphabetic characters.>"

	V["-w"] = " \t\n\v\f\r"
	D = D "w<%whitespace>"
	D = D "<default \\\\\\t\\\\\\n\\\\\\v\\\\\\f\\\\\\r >"
	D = D "<type str>"
	D = D "<description Characters treated as ignorable whitespace during parsing.>"

	V["-O"] = "<nx:false/>"
	D = D "O<output out>"
	D = D "<default <nx:false/\\>>"
	D = D "<type toggle>"
	D = D "<description Emit environment output via echo instead of raw VAR=value lines.>"

	V["-P"] = "-"
	D = D "P<%prefix argument-prefix>"
	D = D "<default ->"
	D = D "<type char>"
	D = D "<description Prefix used for both short and long options.>"

	V["-h"] = ""
	D = D "h<help>"
	D = D "<default null constant>"
	D = D "<type void>"
	D = D "<description Display schema, metadata, and usage information for all options.>"

	V["--type"] = "type"
	D = D "type<%directive-type>"
	D = D "<default type>"
	D = D "<type str>"
	D = D "<description Directive that sets or overrides the type metadata for the next schema element.>"

	V["--default"] = "default"
	D = D "default<%directive-default>"
	D = D "<default default>"
	D = D "<type str>"
	D = D "<description Directive that assigns a default value to the next schema element.>"

	V["--epilog"] = "epilog"
	D = D "epilog<%directive-epilog>"
	D = D "<default epilog>"
	D = D "<type str>"
	D = D "<description Directive that appends epilog text to the generated help output.>"

	V["--usage"] = "usage"
	D = D "usage<%directive-usage>"
	D = D "<default usage>"
	D = D "<type str>"
	D = D "<description Directive that sets the usage string for the schema.>"

	V["--description"] = "description"
	D = D "description<%directive-description>"
	D = D "<default description>"
	D = D "<type str>"
	D = D "<description Directive that sets the description block for the schema or group.>"

	V["--build"] = "build"
	D = D "build<%directive-build>"
	D = D "<default build>"
	D = D "<type str>"
	D = D "<description Enables build‑time placeholder expansion; replaces matching tokens in the schema with their evaluated variable values.>"

	V["--macro-prefix"] = "<nx@"
	D = D "macro-prefix<%directive-macro-prefix>"
	D = D "<default <nx@>"
	D = D "<type str>"
	D = D "<description Directive that sets the prefix used for macro expansion in build snippets.>"

	V["--macro-suffix"] = "/>"
	D = D "macro-suffix<%directive-macro-suffix>"
	D = D "<default /\\>>"
	D = D "<type str>"
	D = D "<description Directive that sets the suffix used for macro expansion in build snippets.>"

	V["--true"] = "<nx:true/>"
	D = D "true<%yes on>"
	D = D "<default <nx:true/\\>>"
	D = D "<type toggle>"
	D = D "<description This is the value that represents false.>"

	V["--false"] = "<nx:false/>"
	D = D "false<%no off>"
	D = D "<default <nx:false/\\>>"
	D = D "<type toggle>"
	D = D "<description This is the value that represents true.>"

	V["--nil"] = "<nx:nil/>"
	D = D "nil<%null>"
	D = D "<default <nx:nil/\\>>"
	D = D "<type str>"
	D = D "<description Sentinel literal that represents an explicit null value within the schema system.>"

	V["--min"] = "min"
	D = D "min<%directive-min>"
	D = D "<default min>"
	D = D "<type str>"
	D = D "<description Specifies the minimum numeric value allowed for this option.>"

	V["--regex"] = "regex"
	D = D "regex<%directive-regex>"
	D = D "<default regex>"
	D = D "<type str>"
	D = D "<description Pattern constraint applied to the value; the value must match the given regular expression.>"

	V["--max"] = "max"
	D = D "max<%directive-max>"
	D = D "<default max>"
	D = D "<type str>"
	D = D "<description Specifies the maximum numeric value allowed for this option.>"

	V["--lazy-defaults"] = __nx_if(B, "<nx:true/>", "<nx:false/>")
	D = D "lazy-defaults<lazy-assign-defaults>"
	D = D "<default <nx:false/\\>>"
	D = D "<type str>"
	D = D "<description when enabled, defaults are not applied during schema load; instead, if the option appears on the command line, its default value is applied immediately before the first user-provided value. If the option is never used, the default is never applied or exported. If the option is typed and the first user value fails type validation, the default remains. Subsequent valid values override the default.>"

	V["--lazy"] = ""
	D = D "lazy<%directive-lazy Lazy Directive-Lazy>"
	D = D "<type str>"
	D = D "<description apply this option's default only if the option is used at least once; the default is assigned immediately before the first valid value and is not exported if the option is never invoked>"

	V["--append"] = "append"
	D = D "append<%>"
	D = D "<type str>"
	D = D "<default append>"
	D = D "<description Append a literal suffix to the option’s final validated value>"

	V["--prepend"] = "prepend"
	D = D "prepend<%>"
	D = D "<type str>"
	D = D "<default prepend>"
	D = D "<description Prepend a literal prefix to the option’s final validated value>"

	V["--post-before"] = "post-before"
	D = D "post-before<%post-eval-before eval-before>"
	D = D "<type str>"
	D = D "<default post-before>"
	D = D "<description Insert text before the final emitted assignment after all options have been parsed>"

	V["--post-after"] = "post-after"
	D = D "post-after<%post-eval-after eval-after>"
	D = D "<type str>"
	D = D "<default post-after>"
	D = D "<description Insert text after the final emitted assignment after all options have been parsed>"

	V["--post-awk-before"] = "post-awk-before"
	D = D "post-awk-before<%post-awk-eval-before eval-awk-before>"
	D = D "<type str>"
	D = D "<default post-awk-before>"
	D = D "<description Evaluate AWK code before appending or prepending; if it fails, the value is skipped>"

	V["--post-awk-after"] = "post-awk-after"
	D = D "post-awk-after<%post-awk-eval-after eval-awk-after>"
	D = D "<type str>"
	D = D "<default post-awk-after>"
	D = D "<description Evaluate AWK code after appending or prepending; if it fails, the value is skipped>"

	V["--directive-suffix-trim"] = "<nx:true/>"
	D = D "directive-suffix-trim<>"
	D = D "<type toggle>"
	D = D "<default directive-prefix-trim>"
	D = D "<description Trim leading flow‑whitespace from directive values before parsing them>"

	V["--directive-prefix-trim"] = "<nx:true/>"
	D = D "directive-prefix-trim<>"
	D = D "<type toggle>"
	D = D "<default directive-prefix-trim>"
	D = D "<description Trim trailing flow‑whitespace from directive values before storing them>"

	V["--chain-eval"] = "1"
	D = D "chain-eval<%>"
	D = D "<type int>"
	D = D "<min 0>"
	D = D "<max 3>"
	D = D "<default 1>"
	D = D "<description TODO>"

	return D
}

function __nx_shell_schema_cat(V, D)
{
	# 1	key-value
	# 2	flag
	# 3	key-value array
	# 4	group open
	# 5	group close
	# 6	long form
	# 7	short form
	return V["-k"] D V["-F"] D V["-K"] D V["-g"] D V["-G"] D V["-l"] D V["-s"]
}

function __nx_shell_schema_tog(V, D, B)
{
	# 1	unset
	# 2	override
	# 3	backtrack
	# 4	export
	# 5	double quote
	# 6	concat flag
	# 7	lazy defaults flag
	D = V["-u"] D V["-o"] D V["-b"] D V["-e"] D V["-q"] D V["-C"] D V["--lazy-defaults"] D V["--directive-prefix-trim"] D V["--directive-suffix-trim"]
	if (B)
		V["--lazy-defaults"] = "<nx:false/>"
	return D
}

function __nx_shell_schema_flg(V, D, B)
{
	# 1	force [0-3]
	# 2	abort [0-3]
	D = V["-f"] D V["-a"] D V["--chain-eval"]
	if (B)
		V["-a"] = "0"
	return D
}

function __nx_shell_schema_act(V, D)
{
	# 1	push modifier symbol
	# 2	pop modifier symbol
	# 3	match substitute find modifier symbol
	# 4	match substitute replace modifier symbol
	# 5	starting index of match modifier symbol
	# 6	number of matches modifier symbol
	return V["-A"] D V["-D"] D V["-M"] D V["-R"] D V["-I"] D V["-N"]
}

function __nx_shell_schema_mic(V, D)
{
	# 1	argument prefix character
	# 2	extra valid long form characters outside alpha class allowed between alpha characters
	# 3	characters to ignore/skip defaults to whitespace characters
	# 4	the concat string to format the string remainder
	# 5	set symbol
	# 6	group count
	# 7	assign separator
	# 8	macro prefix
	# 9	macro suffix
	return V["-P"] D V["-L"] D V["-w"] D V["-c"] D V["-S"] D V["-y"] D V["--macro-prefix"] D V["--macro-suffix"]
}

function __nx_shell_schema_dir(V, D)
{
	# 1 type directive
	# 2 default directive
	# 3 epilog directive
	# 4 usage directive
	# 5 description directive
	# 6 build directive
	# 7 regex directive
	# 8 min directive
	# 9 max directive
	# 10 lazy directive
	# 11 post before
	# 12 post after
	# 13 post awk eval before
	# 14 post awk eval after
	# 15 append
	# 16 prepend
	return V["--type"] D V["--default"] D V["--epilog"] D V["--usage"] D V["--description"] D V["--build"] D V["--regex"] D V["--min"] D V["--max"] D V["--lazy"] D V["--post-before"] D V["--post-after"] D V["--post-awk-before"] D V["--post-awk-after"] D V["--append"] D V["--prepend"]
}


function __nx_shell_schema_rep(V, D)
{
	# 1 true representation
	# 2 false representation
	# 3 none representation
	return V["--true"] D V["--false"] D V["--none"]
}

