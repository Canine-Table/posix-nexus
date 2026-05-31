#nx_include nex-log-extras.awk

# D1	the string
# D2	the opening group
# D3	the closing group
function nx_shell_stride(D1, D2, D3,
	cnt)
{
	cnt = 0
	while (match(D1, D2)) {
		cnt += 3
		D1 = substr(D1, RSTART + RLENGTH)
		if (! match(D1, D3))
			return -1
		D1 = substr(D1, RSTART + RLENGTH)
	}
	return cnt
}

function nx_shell_diff(D1, V1, D2, V2,
	carr, cr)
{
	if (D1 == "")
		return ""
	split(D1, carr, __nx_else(D2, "", 1))
	D2 = ""
	for (D1 in carr) {
		cr = carr[D1]
		if (! (cr in V2 || cr in V1)) {
			V1[cr] = D1
			D2 = D2 cr
		}
	}
	delete carr
	return D2
}

function __nx_shell_skip(D1, V, D2, N1, N2)
{
	if (D1 ~ D2) {
		while (D1 ~ D2)
			D1 = V[++N1]
		return N1 + int(N2)
	}
	return N1
}

function __nx_shell_schema_str(V, D, B)
{
	V["-u"] = "<nx:false/>"
	D = ",u<unset>"
	D = D "<type toggle>"
	D = D "<default <nx:false/\>>"
	D = D "<description Clear all NEX_ARGV_* NEX_ARGC and group variables in the current scope before processing new arguments>"

	V["-q"] = "<nx:false/>"
	D = D "q<quote>"
	D = D "<default <nx:false/\>>"
	D = D "<type toggle>"
	D = D "<description Use double-quoted values instead of single-quoted shell-safe literals; enables interpolation and requires careful escaping>"

	V["-C"] = "<nx:false/>"
	D = D "C<null-concat>"
	D = D "<default <nx:false/\>>"
	D = D "<type toggle>"
	D = D "<description Treat empty values as valid concatenation operands instead of skipping them. Useful when building strings with intentional empty segments.>"

	V["-o"] = "<nx:false/>"
	D = D "o<override type-override>"
	D = D "<default <nx:false/\>>"
	D = D "<type toggle>"
	D = D "<description Preserve the original group form and type when a group is redefined; forces the parser to reuse the existing symbol and prevents form switching.>"

	V["-e"] = "<nx:false/>"
	D = D "e<export>"
	D = D "<default <nx:false/\>>"
	D = D "<type toggle>"
	D = D "<description Emit export VAR=value; instead of VAR=value during environment construction.>"

	V["-b"] = "<nx:false/>"
	D = D "b<backtrack>"
	D = D "<default <nx:false/\>>"
	D = D "<type toggle>"
	D = D "<description  When a short-form bundle contains characters that are not valid options, preserve the leftover characters and push them into the remainder instead of discarding them. This does not affect value consumption; only kwarg-style consumer flags take values (e.g., -abc 1 2 3 → a=1, b=2, c=3 only when a, b, c are consumer flags).>"

	V["-a"] = __nx_if(B, "3", "0")
	D = D "a<abort>"
	D = D "<default 0>"
	D = D "<type number>"
	D = D "<description Abort parsing when encountering invalid or conflicting arguments. Accepts levels 0–3 controlling strictness.>"

	V["-v"] = "1"
	D = D "v<%verbose>"
	D = D "<default 1>"
	D = D "<type number>"
	D = D "<description Set verbosity level (0–5). Higher levels print schema, parse flow, and full IR dumps.>"

	V["-f"] = "0"
	D = D "f<force-group>"
	D = D "<default 0>"
	D = D "<type number>"
	D = D "<description Controls how existing group declarations are handled when a group opener is encountered again.\n\tgfr=0: do not modify the existing group; skip new entries.\n\tgfr=1: reuse the existing group’s type symbol for new entries (type-forcing).\n\tgfr=2: override the existing group leader; promote the new declaration to leader and rewire the group mapping.>"

	V["-d"] = "<nx:null/>"
	D = D "d<%delimiter delimiter-separator>"
	D = D "<default <nx:null\>>"
	D = D "<type string>"
	D = D "<description Set the delimiter used to separate schema fields.>"

	V["-k"] = "%"
	D = D "k<%key key-separator>"
	D = D "<default %>"
	D = D "<type character>"
	D = D "<description Character used to separate key/value pairs in long‑form arguments.>"

	V["-g"] = "<"
	D = D "g<%open group-open>"
	D = D "<default <>"
	D = D "<type character>"
	D = D "<description Character marking the start of a group.>"

	V["-G"] = ">"
	D = D "G<%close group-close>"
	D = D "<default \>>"
	D = D "<type character>"
	D = D "<description Character marking the end of a group.>"

	V["-F"] = "@"
	D = D "F<%flag-array flag-array-separator>"
	D = D "<default @>"
	D = D "<type character>"
	D = D "<description Separator used for flag arrays (multiple boolean flags grouped together).>"

	V["-K"] = "#"
	D = D "K<%key-array key-array-separator>"
	D = D "<default #>"
	D = D "<type character>"
	D = D "<description Separator used for key/value arrays (multiple key/value pairs grouped together).>"

	V["-l"] = ","
	D = D "l<%long>"
	D = D "<default ,>"
	D = D "<type character>"
	D = D "<description Character that begins or continues long‑option mode.>"

	V["-s"] = ";"
	D = D "s<%short>"
	D = D "<default ;>"
	D = D "<type character>"
	D = D "<description Character that continues short-option mode or ends long‑option mode and returns to short‑option parsing.>"

	V["-p"] = "<nx:null/>"
	D = D "p<%param parameter-separator>"
	D = D "<default <nx:null\>>"
	D = D "<type character>"
	D = D "<description Parameter separator used to split arguments into schema fields.>"

	V["-S"] = "="
	D = D "S<%set>"
	D = D "<default =>"
	D = D "<type character>"
	D = D "<description Symbol used to assign values to keys (e.g., --opt=value).>"

	V["-A"] = "+"
	D = D "A<%add push>"
	D = D "<default +>"
	D = D "<type character>"
	D = D "<description Push modifier symbol. Appends values to arrays or repeated options.>"

	V["-D"] = "-"
	D = D "D<%remove pop delete>"
	D = D "<default ->"
	D = D "<type character>"
	D = D "<description Pop/delete modifier symbol. Removes values or unsets options.>"

	V["-M"] = "@"
	D = D "M<%match find>"
	D = D "<default @>"
	D = D "<type character>"
	D = D "<description Symbol used to mark the match/find modifier in expressions; selects which character denotes the match pattern buffer.>"

	V["-R"] = "~"
	D = D "R<%subtitute replace>"
	D = D "<default ~>"
	D = D "<type character>"
	D = D "<description Symbol used to mark the substitute/replace modifier in expressions; selects which character denotes replacement operations using the match buffer.>"

	V["-I"] = "#"
	D = D "I<%index idx>"
	D = D "<default #>"
	D = D "<type character>"
	D = D "<description Symbol used to mark the index-of-match modifier in expressions; selects which character denotes queries for the first match position.>"

	V["-N"] = "%"
	D = D "N<%number count>"
	D = D "<default %>"
	D = D "<type character>"
	D = D "<description Directive that injects build metadata (version, date, VCS tag) into the schema.>"

	V["-c"] = " "
	D = D "c<%concat concatenate concatenation-separator>"
	D = D "<default \ >"
	D = D "<type string>"
	D = D "<description String used to join remainder arguments when flattening or emitting environment variables.>"

	V["-y"] = "="
	D = D "y<%assign assign-separator>"
	D = D "<default =>"
	D = D "<type string>"
	D = D "<description Separator inserted between variable name and value in generated environment assignments.>"

	V["-L"] = "._-:"
	D = D "L<%extra-long-characters>"
	D = D "<default ._-:>"
	D = D "<type string>"
	D = D "<description Additional characters allowed inside long‑form option names beyond alphabetic characters.>"

	V["-w"] = " \t\n\v\f\r"
	D = D "w<%whitespace>"
	D = D "<default \\\\\\t\\\\\\n\\\\\\v\\\\\\f\\\\\\r >"
	D = D "<type string>"
	D = D "<description Characters treated as ignorable whitespace during parsing.>"

	V["-O"] = "<nx:false/>"
	D = D "O<output out>"
	D = D "<default <nx:false/\>>"
	D = D "<type toggle>"
	D = D "<description Emit environment output via echo instead of raw VAR=value lines.>"

	V["-P"] = "-"
	D = D "P<%prefix argument-prefix>"
	D = D "<default ->"
	D = D "<type character>"
	D = D "<description Prefix used for both short and long options.>"

	V["-h"] = ""
	D = D "h<help>"
	D = D "<default null constant>"
	D = D "<type void>"
	D = D "<description Display schema, metadata, and usage information for all options.>"

	V["--type"] = "type"
	D = D "type<%directive-type>"
	D = D "<default type>"
	D = D "<type string>"
	D = D "<description Directive that sets or overrides the type metadata for the next schema element.>"

	V["--default"] = "default"
	D = D "default<%directive-default>"
	D = D "<default default>"
	D = D "<type string>"
	D = D "<description Directive that assigns a default value to the next schema element.>"

	V["--epilog"] = "epilog"
	D = D "epilog<%directive-epilog>"
	D = D "<default epilog>"
	D = D "<type string>"
	D = D "<description Directive that appends epilog text to the generated help output.>"

	V["--usage"] = "usage"
	D = D "usage<%directive-usage>"
	D = D "<default usage>"
	D = D "<type string>"
	D = D "<description Directive that sets the usage string for the schema.>"

	V["--description"] = "description"
	D = D "description<%directive-description>"
	D = D "<default description>"
	D = D "<type string>"
	D = D "<description Directive that sets the description block for the schema or group.>"

	V["--build"] = "build"
	D = D "build<%directive-build>"
	D = D "<default build>"
	D = D "<type string>"
	D = D "<description Enables build‑time placeholder expansion; replaces matching tokens in the schema with their evaluated variable values.>"

	V["--macro-prefix"] = "<nx@"
	D = D "macro-prefix<%directive-macro-prefix>"
	D = D "<default <nx@>"
	D = D "<type string>"
	D = D "<description Directive that sets the prefix used for macro expansion in build snippets.>"

	V["--macro-suffix"] = "/>"
	D = D "macro-suffix<%directive-macro-suffix>"
	D = D "<default /\>>"
	D = D "<type string>"
	D = D "<description Directive that sets the suffix used for macro expansion in build snippets.>"

	V["--true"] = "<nx:true/>"
	D = D "true<%yes on>"
	D = D "<default <nx:true/\>>"
	D = D "<type toggle>"
	D = D "<description This is the value that represents false.>"

	V["--false"] = "<nx:false/>"
	D = D "false<%no off>"
	D = D "<default <nx:false/\>>"
	D = D "<type toggle>"
	D = D "<description This is the value that represents true.>"

	V["--nil"] = "<nx:nil/>"
	D = D "nil<%null>"
	D = D "<default <nx:nil/\>>"
	D = D "<type string>"
	D = D "<description Sentinel literal that represents an explicit null value within the schema system.>"

	V["--min"] = "min"
	D = D "min<%directive-min>"
	D = D "<default min>"
	D = D "<type number>"
	D = D "<description Specifies the minimum numeric value allowed for this option.>"

	V["--regex"] = "regex"
	D = D "regex<%directive-regex>"
	D = D "<default regex>"
	D = D "<type string>"
	D = D "<description Pattern constraint applied to the value; the value must match the given regular expression.>"

	V["--max"] = "max"
	D = D "max<%directive-max>"
	D = D "<default max>"
	D = D "<type number>"
	D = D "<description Specifies the maximum numeric value allowed for this option.>"

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

function __nx_shell_schema_tog(V, D)
{
	# 1	unset
	# 2	override
	# 3	backtrack
	# 4	export
	# 5	double quote
	# 6	concat flag
	return V["-u"] D V["-o"] D V["-b"] D V["-e"] D V["-q"] D V["-C"]
}

function __nx_shell_schema_flg(V, D, B)
{
	# 1	force [0-3]
	# 2	abort [0-3]
	D = V["-f"] D V["-a"]
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
	return V["--type"] D V["--default"] D V["--epilog"] D V["--usage"] D V["--description"] D V["--build"] D V["--regex"] D V["--min"] D V["max"]
}


function __nx_shell_schema_rep(V, D)
{
	# 1 true representation
	# 2 false representation
	# 3 none representation
	return V["--true"] D V["--false"] D V["--none"]
}

# D1	string
# V	map
# D2	sep
# N1	total
# N2	debug
# D3	what
function nx_unique_check(D1, V, D2, N1, N2, D3,
	l, i, acm, wret)
{
	if ((l = split(D1, V, D2)) > 0) {
		i = __nx_if(l > N1, N1, l)
		if (N2 > 1) {
			if (l > N1 + 1)
				nx_ansi_warning("'" D1 "' string contains more " D3 " than implemented. The " D3 " separator to separate the " D3 "s was either used as an as both separator and " D3 " or you passed '"  l - N1  "' " D3 "s more than you should have, only the first '" N1 "' positions will be used\n")
			l = i
			for (i = 1; i <= l; ++i) {
				acm = V[i]
				if (acm != "") {
					if (acm in V) {
						nx_ansi_warning(D3 " '" acm "' already in use at position '" V[acm] "'\n")
						V[i] = ""
						wret = -2
					} else {
						V[acm] = i
					}
				}
			}
		} else {
			l = i
			for (i = 1; i <= l; ++i) {
				acm = V[i]
				if (acm != "") {
					if (acm in V) {
						V[i] = ""
						wret = -2
					} else {
						V[acm] = i
					}
				}
			}
		}
	}

	return wret
}


function __nx_shell_schema(D1, D2, D3, N,
	D4, D5, D6, D7, D8, D9, D10,
	V1, V2,
	l, n, i, m,
	acm,
	eret, wret, ab,
	ks, fas, kas, go, gc, lo, lc,
	tpe, dft, epi, use, dsc, blt, regx, min, max,
	fa, fd, fm, fr, fi, fn,
	pref, ext, skp, ncn, fs, as, psrt, mpre, msuf,
	tru, fls, non,
	rgx, acrgx,
	v_ta, v_tb)
{

	# PARAMETERS
	# ----------
	# SCALAR PARAMETERS
	# D1	the input
	# D2	the parameter separator
	# D3	the remainder separator
	# N	debug level

	# STRING SPLIT ARRAY PARAMETERS
	# D4	category symbols
	# D5	toggles
	# D6	action symbols
	# D7	flags
	# D8	misc symbols
	# D9	directives
	# D10	type representations
	# D11	types

	# REFERENCE ARRAYS
	# V1	the symbol structure vector
	# V2	the parameters stack

	# LANES
	# (1) types
	# (2) representation
	# (3) directives
	# (4) categories
	# (5) toggles
	# (6) actions
	# (7) flags
	# (8) misc
	# (9) regex

	if (D1 ~ /^[ \t\n\v\r\f]*$/) {
		nx_ansi_error("please provide something to work with, '" D1 "' is not understood here yet\n")
		return -1
	}

	D2 = __nx_else(D2, "<nx:null/>")
	D3 = __nx_else(D3, "<nx:null/>")
	N = int(N)
	wret = 0
	m = 256
	psrt = -6


	# CATEGORY (D4) SECTION ###########################
	n = 7
	if ((l = split(D4, v_ta, D2)) > 0) {
		i = __nx_if(l > n, n, l)
		if (N > 1) {
			if (l > n + 1)
				nx_ansi_warning("'" D4 "' separator to separate the separators was was either used within the separators as a separator or you passed '"  l - n  "' separators more than you should have, only the first '" n "' positions will be used\n")
			l = i
			for (i = 1; i <= l; ++i) {
				acm = v_ta[i]
				if (acm != "") {
					eret = 1
					if (acm in v_ta) {
						nx_ansi_warning("separator '" acm "' already in use as separator number '" v_ta[acm] "'\n")
					} else if (length(acm) > 1) {
						nx_ansi_warning("separator '" acm "' must be a single character\n")
					} else if (nx_is_alpha(acm)) {
						nx_ansi_warning("separator '" acm "' must not be alphabetic\n")
					} else {
						eret = 0
						v_ta[acm] = i
					}
					if (eret)
						wret = -2
				}
			}
		} else {
			l = i
			for (i = 1; i <= l; ++i) {
				acm = v_ta[i]
				if (acm in v_ta || nx_is_alnum(acm) || length(acm) > 1) {
					wret = -2
				} else {
					v_ta[acm] = i
				}
			}
		}
	}

	ks = __nx_else(v_ta[1], "%") # key sep
	fas = __nx_else(v_ta[2], "@") # appendable arr sep
	kas = __nx_else(v_ta[3], "#") # appendable kwds sep
	go = __nx_else(v_ta[4], "<") # begin group
	gc = __nx_else(v_ta[5], ">") # eng group
	lo = __nx_else(v_ta[6], ",") # begin or continue long option mode
	lc = __nx_else(v_ta[7], ";") # end long option mode

	if (nx_delim_sep("key value pair", ks, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("flag array", fas, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("key value pair array", kas, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("open group", go, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("close group", gc, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("long option", lo, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("short option", lc, v_tb, N) == -1)
		eret = -1

	if (eret == -1) {
		delete v_ta
		return -1
	}

	split(D1, V2, D2)
	if ((i = nx_shell_stride(V2[1], go, gc)) == -1) {
		if (N > 0)
			nx_ansi_error("the group terminator '" gc "' ran away\n")
		delete v_ta
		delete v_tb
		return -1
	}

	strde = 12 + i
	nx_parr_stk(V1, strde)
	V1[ks] = nx_parr_stk(V1, 1, ks)
	V1[lo] = nx_parr_stk(V1, 4, lo)
	V1[fas] = nx_parr_stk(V1, 7, fas)
	V1[kas] = nx_parr_stk(V1, 10, kas)
	##################################################


	# SYMBOLS (D4) SECTION ###########################
	oft = m * 4
	V1[(oft + 0) * strde] = n
	# 1	key-value pair
	# 2	flag array
	# 3	key-value pair array
	# 4	group open
	# 5	group close
	# 6	long form / toggle flag
	# 7	short form
	V1[(oft + 1) * strde] = ks
	V1[(oft + 2) * strde] = fas
	V1[(oft + 3) * strde] = kas
	V1[(oft + 4) * strde] = go
	V1[(oft + 5) * strde] = gc
	V1[(oft + 6) * strde] = lo
	V1[(oft + 7) * strde] = lc
	##################################################


	# MISC (D8) SECTION ##############################
	split(D8, v_ta, D2)
	pref = __nx_else(v_ta[1], "-") # prefix for long/short options
	ext = __nx_else(v_ta[2], "-_:.") # extra characters allowed between alpha characters in long option mode
	skp = __nx_else(v_ta[3], "\n\v\f\t\r ") # extra characters that hold no meaning and should be skipped
	ncn = __nx_if(ncn, "", __nx_else(v_ta[4], " ", 1)) # concat sep of remainder string
	fs = __nx_else(v_ta[5], "=") # set symbol
	as = __nx_else(v_ta[6], "=") # assign symbol
	mpre = __nx_else(v_ta[7], "<nx@") # macro prefix
	msuf = __nx_else(v_ta[8], "/>") # macro suffix

	split("", v_ta, "")
	ext = nx_shell_diff(ext, v_ta, "", v_tb)
	skp = nx_shell_diff(skp, v_ta, "", v_tb)
	delete v_tb

	split(D8, v_ta, D2)
	n = 6
	oft = m * 8
	V1[(oft + 0) * strde] = n
	# 1	argument prefix character
	# 2	extra valid long form characters outside alpha class allowed between alpha characters
	# 3	characters to ignore/skip defaults to whitespace characters
	# 4	the concat string to format the string remainder
	# 5	the action init symbol
	# 6	assign symbol
	V1[(oft + 1) * strde] = pref
	V1[(oft + 2) * strde] = ext
	V1[(oft + 3) * strde] = skp
	V1[(oft + 4) * strde] = ncn
	V1[(oft + 5) * strde] = fs
	V1[(oft + 6) * strde] = as
	##################################################


	# TOGGLES (D5) SECTION ###########################
	split(D5, v_ta, D2)
	n = 6
	oft = m * 5
	V1[oft * strde] = n
	# 1	unset
	# 2	override
	# 3	backtrack
	# 4	export
	# 5	double quote
	# 6	concat flag
	for (i = 1; i <= n; ++i) {
		oft = oft + 1
		V1[oft * strde] = v_ta[i] == "<nx:true/>"
	}
	ncn = V1[(m * 5 + 6) * strde]
	##################################################


	# FLAGS (D7) SECTION #############################
	split(D7, v_ta, D2)
	n = 2
	oft = m * 7
	V1[(oft + 0) * strde] = n
	# 1	force [0-3]
	# 2	abort [0-3]
	V1[(oft + 1) * strde] = int(v_ta[1])
	V1[(oft + 2) * strde] = (ab = int(v_ta[2]))
	##################################################


	# ACTION CATEGORY (D6) SECTION ###################
	n = 6
	wret = __nx_else(nx_unique_check(D6, v_ta, D2, n, N, "action"), wret)

	fa = __nx_else(v_ta[1], "+") # push modifier symbol
	fd = __nx_else(v_ta[2], "-") # pop modifier symbol
	fm = __nx_else(v_ta[3], "@") # match find modifier symbol
	fr = __nx_else(v_ta[4], "~") # match replace modifier symbol
	fi = __nx_else(v_ta[5], "%") # match index of match modifier symbol
	fn = __nx_else(v_ta[6], "#") # match number modifier symbol
	if (nx_delim_sep("push modifier symbol", fa, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("pop modifier symbol", fd, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("match find modifier symbol", fm, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("match replace modifier symbol", fr, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("match index modifier symbol", fi, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("match number modifier symbol", fn, v_tb, N) == -1)
		eret = -1
	delete v_tb
	if (eret == -1) {
		delete v_ta
		return -1
	}

	# start of params when invoking the function nx_shell_args
	V1["-0"] = __nx_if(V1["-0"] < psrt, V1["-0"], psrt)
	##################################################


	# ACTION (D6) SECTION ############################
	oft = m * 6
	V1[(oft + 0) * strde] = n
	# 1	push modifier symbol
	# 2	pop modifier symbol
	# 3	match substitute find modifier symbol
	# 4	match substitute replace modifier symbol
	# 5	starting index of match modifier symbol
	# 6	number of matches modifier symbol
	V1[(oft + 1) * strde] = fa
	V1[(oft + 2) * strde] = fd
	V1[(oft + 3) * strde] = fm
	V1[(oft + 4) * strde] = fr
	V1[(oft + 5) * strde] = fi
	V1[(oft + 6) * strde] = fn
	##################################################


	# SCELAR SECTION #################################
	# 1	the parameter separator
	# 2	the remainder separator
	# 3	debug level
	# 4	map boundary
	# 5	group count
	# 6	positional parameter starting index
	V1[1 * strde] = D2
	V1[2 * strde] = D3
	V1[3 * strde] = N
	V1[4 * strde] = m
	V1[5 * strde] = 0
	V1[6 * strde] = psrt
	##################################################


	skp = "(" nx_str_esc(skp, 2) ")+"
	acm = "([a-zA-Z]"
	if (ext) {
		rgx = nx_str_esc(ext, 2)
		ext = "([a-zA-Z]|" rgx
		acm = acm ext ")*)?[A-Za-z]+"
		rgx = rgx")+$"
		ext = ext ")+"
		rgx = "(" rgx
	} else {
		ext = "[a-zA-Z]+"
	}

	for (i = 1; i <= n; ++i)
		acrgx = acrgx "|[" V1[(oft + i) * strde] "]"
	mpre = nx_str_esc(mpre)
	msuf = nx_str_esc(msuf)


	# REGEX SECTION ##################################
	n = 10
	oft = m * 9
	V1[(oft + 0) * strde] = n
	# 1	the action modifier match regex
	# 2	extended + alphabetic long option character regex
	# 3	extended long option character regex
	# 4	skip regex defaults to whitespace
	# 5	action regex
	# 6	skip regex defaults to whitespace with anchors
	# 7	macro prefix
	# 8	macro suffix
	# 9	macro regex
	# 9	macro remove pre suf regex
	V1[(oft + 1) * strde] = acm
	V1[(oft + 2) * strde] = ext "$"
	V1[(oft + 3) * strde] = rgx
	V1[(oft + 4) * strde] = skp
	V1[(oft + 5) * strde] = substr(acrgx, 2)
	V1[(oft + 6) * strde] = "^" skp "$"
	V1[(oft + 7) * strde] = mpre
	V1[(oft + 8) * strde] = msuf
	V1[(oft + 9) * strde] = mpre ext msuf
	V1[(oft + 10) * strde] = "(^" mpre "|" msuf "$)"
	##################################################


	# CATEGORY (D9) SECTION ###########################
	n = 6
	wret = __nx_else(nx_unique_check(D9, v_ta, D2, n, N, "directive"), wret)
	tpe = __nx_else(v_ta[1], "type")
	dft = __nx_else(v_ta[2], "default")
	epi = __nx_else(v_ta[3], "epilog")
	use = __nx_else(v_ta[4], "usage")
	dsc = __nx_else(v_ta[5], "description")
	blt = __nx_else(v_ta[6], "build")
	regx = __nx_else(v_ta[7], "regex")
	min = __nx_else(v_ta[8], "min")
	max = __nx_else(v_ta[9], "max")

	if (nx_delim_sep("type directive", tpe, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("default directive", dft, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("epilog directive", epi, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("usage directive", use, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("description directive", dsc, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("build directive", blt, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("regex directive", regx, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("min directive", min, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("max directive", max, v_tb, N) == -1)
		eret = -1
	delete v_tb

	if (eret == -1) {
		delete v_ta
		return -1
	}

	# DIRECTIVE SECTION ##############################
	n = 9
	oft = m * 3
	V1[(oft + 0) * strde] = n
	# 1 type directive
	# 2 default directive
	# 3 epilog directive
	# 4 usage directive
	# 5 description directive
	# 6 build directive
	# 7 regex directive
	# 8 min directive
	# 9 max directive
	V1[(oft + 1) * strde] = tpe
	V1[(oft + 2) * strde] = dft
	V1[(oft + 3) * strde] = epi
	V1[(oft + 4) * strde] = use
	V1[(oft + 5) * strde] = dsc
	V1[(oft + 6) * strde] = blt
	V1[(oft + 7) * strde] = regx
	V1[(oft + 8) * strde] = min
	V1[(oft + 9) * strde] = max
	##################################################


	# REPRESENTATION (D10) SECTION ###################
	n = 4
	wret = __nx_else(nx_unique_check(D10, v_ta, D2, n, N, " representation"), wret)
	tru = __nx_else(v_ta[1], "<nx:true/>")
	fls = __nx_else(v_ta[2], "<nx:false/>")
	non = __nx_else(v_ta[3], "<nx:none/>")
	if (nx_delim_sep("false representation", fls, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("true representation", tru, v_tb, N) == -1)
		eret = -1
	if (nx_delim_sep("none representation", non, v_tb, N) == -1)
		eret = -1
	delete v_tb

	# REPRESENTATION (D10) SECTION ###################
	n = 3
	oft = m * 2
	V1[(oft + 0) * strde] = n
	# 1 true representation
	# 2 false representation
	# 3 none representation
	# 4 not a number representation
	V1[(oft + 1) * strde] = tru
	V1[(oft + 2) * strde] = fls
	V1[(oft + 3) * strde] = non
	##################################################


	delete v_ta
	if (ab > 2)
		return __nx_else(eret, wret)
	return eret
}

function nx_shell_opts(V1, V2,
	m, oft, strde,
	fas,
	obol, lo, lc,
	gfr, gcr, gsym, goff, gbse, gpos, gbol, grp, cgrp, go, gc, gent,
	tpe, dft, epi, use, dsc, blt, regx, min, max,
	dbol, djmp, dmov,
	acm, lcr, rcr, cr,
	vb2, vb2msg,
	ks, kas,
	fmt, idx, bol,
	eret, wret,
	ovr, dbg,
	flw, sbol,
	trk)
{

	# LANES
	# (2) representation
	# (3) directives
	# (4) categories
	# (5) toggles
	# (6) actions
	# (7) flags
	# (8) misc
	# (9) regex

	strde = V1[0]
	dbg = V1[strde * 3]
	m = V1[strde * 4]

	# DIRECTIVES
	oft = m * 3
	tpe = V1[(oft + 1) * strde]
	dft = V1[(oft + 2) * strde]
	epi = V1[(oft + 3) * strde]
	use = V1[(oft + 4) * strde]
	dsc = V1[(oft + 5) * strde]
	blt = V1[(oft + 6) * strde]
	regx = V1[(oft + 7) * strde]
	min = V1[(oft + 8) * strde]
	max = V1[(oft + 9) * strde]

	# CATEGORIES
	oft = m * 4
	ks = V1[(oft + 1) * strde]
	fas = V1[(oft + 2) * strde]
	kas = V1[(oft + 3) * strde]
	go = V1[(oft + 4) * strde]
	gc = V1[(oft + 5) * strde]
	lo = V1[(oft + 6) * strde]
	lc = V1[(oft + 7) * strde]

	# TOGGLES
	oft = m * 5
	ovr = V1[(oft + 2) * strde]

	# FLAGS
	oft = m * 7
	gfr = V1[(oft + 1) * strde]

	# REGEX
	oft = m * 9
	ext = V1[(oft + 2) * strde]
	rcr = V1[(oft + 3) * strde]
	flw = V1[(oft + 4) * strde]

	# MISC
	oft = m * 8
	lcr = V1[(oft + 2) * strde]

	cr = V2[1]
	fmt = split(cr, trk, "")
	if (dbg > 2)
		nx_ansi_alert("passed param string was " cr "\n")

	grp = 13
	gbol = 0

	for (idx = 1; idx <= fmt; ++idx) {
		cr = trk[idx = __nx_shell_skip(trk[idx], trk, flw, idx)]
		if (idx > fmt)
			break

		bol = cr == lo
		if (bol || cr == lc) {
			if (obol != bol) {
				if (dbg > 2)
					nx_ansi_info(__nx_if(obol == "", "applying form to " __nx_if(bol, "long form", "short form"), "updating form from " __nx_if(obol, "long form to short form", "short form to long form")) "\n")
				obol = bol
			}
			cr = trk[idx = __nx_shell_skip(trk[++idx], trk, flw, idx)]
		}

		if (nx_is_alpha(cr)) {
			acm = cr
			cr = trk[++idx]
			if (obol) {
				while (cr ~ ext) {
					acm = acm cr
					cr = trk[++idx]
				}
				if (lcr && gsub(rcr, "", acm) && dbg > 1)
					nx_ansi_alert("trailing '" lcr "' found after '" acm "'\n")
				if (cr ~ flw)
					cr = trk[idx = __nx_shell_skip(cr, trk, flw, idx)]
			}
			bol = nx_is_alpha(cr)
			if (acm in V1) {
				dmov = 0
				if (gbol) {
					if (dbg > 1)
						nx_ansi_warning("argument '" acm "' was already registered\n")
					idx--
				} else {
					gpos = V1[acm]
					gbse = gpos % strde
					if (gbse > 12 && gbse + strde * 2 == gpos && cr == go) {
						gcr = acm
						gbol = 1

						if (nx_is_alpha(gsym = trk[__nx_shell_skip(trk[idx], trk, flw, idx)]) || gsym == gc) {
							if (gsym == gc)
								--idx
							gsym = lo
						}

						if (ovr)
							V1[gbse + strde] = gsym
						else
							gsym = V1[gbse + strde]
						cgrp = grp
						grp = gbse
						if (dbg > 2)
							nx_ansi_light("adding on to '" acm "' of type '" gsym "'\n")
					} else if (cr == go) {
						gsym = trk[__nx_shell_skip(trk[++idx], trk, flw, idx)]
						if (nx_is_alpha(gsym) || gsym == gc) {
							--idx
							gsym = lo
						}

						if (gfr == 1) {
							if (ovr) {
								if (dbg > 1)
									nx_ansi_warning("replacing '" V1[gbse + strde] "' with '" gsym "' type for group entries within the schelar once refered to as '" acm "'\n")
							} else {
								cr = gsym
								gsym = V1[gbse + strde]
								if (dbg > 1)
									nx_ansi_warning("discarding old type '" cr "' and reusing '" gsym "' type for original entry '" acm "' first declaration\n")
							}
							dbol = V1[gsym] - strde
						} else if (gfr == 2) {
							dmov = 1
							dbol = 0
							cr = nx_parr_stk(V1, gbse)
							if (cr == acm) {
								delete V1[V1[cr]]
							} else {
								dmov = V1[acm]
								V1[cr] = dmov
								V1[dmov] = cr
								delete V1[acm]
							}

							if (ovr) {
								if (dbg > 2)
									nx_ansi_light("param override disabled\n")
								gsym = V1[gbse + strde]
								cr = trk[idx + 1];
								if (nx_is_alpha(cr) || cr == gc) {
									trk[idx] = gsym
									trk[--idx] = go
								} else {
									trk[idx + 1] = gsym
								}
							} else {
								if (dbg > 2)
									nx_ansi_light("param override enabled\n")
							}

							cr = go
							if (dbg > 2)
								nx_ansi_light("param override of '" acm "' was prepaired to be registered as a group leader'\n")
						} else {
							D1 = acm
							acm = ""
							D2 = ""
							while (++idx <= fmt) {
								if ((cr = trk[idx = __nx_shell_skip(trk[idx], trk, flw, idx)]) == gc)
									break
								dbol = cr == lo
								if (dbol || cr == lc)
									D2 = dbol
								acm = acm cr
							}

							if (ovr && D2 != "" && D2 != obol) {
								if (dbg > 2)
									nx_ansi_info("ovrride was set, " __nx_if(obol == "", "applying form to " __nx_if(D2, "long form", "short form"), "updating form from " __nx_if(obol, "long form to short form", "short form to long form")) "\n")
								obol = D2
							}

							if (dbg > 1) {
								D2 = V1[V1[D1] % strde + strde]
								nx_ansi_warning("skipping past '" D1 "' group entries '" acm "' as '" D1 "' is already of type '" V2[D2] "' assigned the symbol '" D2 "'\n")
							}
							dbol = 0
						}
					} else {
						if (dbg > 1)
							nx_ansi_warning("argument '" acm "' was already registered\n")
						idx--
					}
				}
				if (!dmov)
					continue
			}

			# skip characters are implicit flags with sbol
			sbol = nx_is_alpha(cr = trk[idx = __nx_shell_skip(cr, trk, flw, idx)])

			if (dbol) {
				djmp = cr == lo
				if ((djmp || cr == lc) && djmp != obol) {
					if (dbg > 2)
						nx_ansi_info(__nx_if(obol == "", "setting form to " __nx_if(djmp, "long form", "short form"), "updating form from " __nx_if(obol, "long form to short form", "short form to long form")) "\n")
					obol = djmp
				}
				djmp = cr
				cr = gsym
				if (djmp != gc)
					djmp = ""
			}

			if (cr == gc && !gbol) {
				cr = __nx_if(obol, lo, lc)
				if (dbg > 2)
					nx_ansi_warning("extra '" gc "' detected after '" acm "' changing type to '" cr "'\n")
			}

			if (sbol || bol || cr == lo || cr == lc || cr == "" || gbol) {
				if (sbol) {
					if (dbg > 2)
						nx_ansi_info("skipping passed whitespace defined by the schema, continuing with the '" __nx_if(bol, "long", "short") "' form parse, proceeding with the '" acm "' schema entry\n")
					--idx
				} else if (cr != gc) {
					bol = cr == lo
					if ((bol || cr == lc) && bol != obol) {
						if (dbg > 2)
							nx_ansi_info(__nx_if(obol == "", "applying form to " __nx_if(bol, "long form", "short form"), "updating form from " __nx_if(obol, "long form to short form", "short form to long form")) "\n")
						obol = bol
						--idx
					}
				}
				if (gbol) {
					gpos = nx_parr_stk(V1, grp, acm)
					if (cr == gc) {
						gbol = 0
						if (cgrp > grp) {
							if (dbg > 2)
								nx_ansi_info("group reset from '" grp "' to '" cgrp "'\n")
							grp = cgrp
						} else {
							grp = grp + 3
						}
						if (dbg > 2)
							nx_ansi_debug("member '" acm "' is end of group type '" gsym "' with leader '" gcr "' at position '" gpos "'\n")
					} else if (dbg > 2) {
							nx_ansi_success("appending member '" acm "' to group type '" gsym "' with leader '" gcr "' at position '" gpos "'\n")
					}
				} else if (dbol) {
					gpos = nx_parr_stk(V1, dbol, acm)
					if (dbg > 2)
						nx_ansi_success("passed param '" acm "' was modified to from type '" cr "'  to type '" gsym "' at position '" gpos "'\n")
				} else {
					gpos = nx_parr_stk(V1, 4, acm)
					if (dbg > 2)
						nx_ansi_success("passed param '" acm "' was registered as a flag at position '" gpos "'\n")
				}
			} else if (cr == go) {
				gcr = acm
				gbol = 1
				gsym = trk[idx + 1]
				cr = trk[idx = __nx_shell_skip(gsym, trk, flw, idx)]
				if (nx_is_alpha(gsym) || gsym == gc) {
					gsym = lo
				} else if (nx_is_alpha(cr) || cr == gc) {
					gsym = lo
					--idx
				} else {
					++idx
				}
				nx_parr_stk(V1, grp, gsym)
				gpos = nx_parr_stk(V1, grp, acm)
				if (dbg > 2)
					nx_ansi_light("passed param '" acm "' was registered as a group leader of type '" gsym "' at position '" gpos "'\n")
			} else if (cr == ks) {
				gpos = nx_parr_stk(V1, 1, acm)
				if (dbg > 2)
					nx_ansi_debug("passed param '" acm "' was registered as a keyword argument at position '" gpos "'\n")
			} else if (cr == fas) {
				gpos = nx_parr_stk(V1, 7, acm)
				if (dbg > 2)
					nx_ansi_success("passed param '" acm "' was registered as a flag array (appendable) at position '" gpos "'\n")
			} else if (cr == kas) {
				gpos = nx_parr_stk(V1, 10, acm)
				if (dbg > 2)
					nx_ansi_debug("passed param '" acm "' was registered as a keyword array (appendable) at position '" gpos "'\n")
			} else if (dbg > 1) {
				nx_ansi_warning("passed param '" acm "' was not registered, '" cr "' is not a known group\n")
				wret = -2
				continue
			}
			V1[acm] = gpos
			D2 = V1[2 + strde]
			if (djmp)
				--idx
		} else if (cr == gc) {
			if (gbol) {
				gbol = 0
				if (cgrp > grp) {
					grp = cgrp
					if (dbg > 2)
						nx_ansi_debug(acm " is end of the current modification pass of the group type '" gsym "' with leader " gcr " at position " gpos "'\n")
				} else {
					grp = grp + 3
					if (dbg > 2)
						nx_ansi_debug(acm " is end of the initizlization of group type '" gsym "' with leader " gcr " at position " gpos "'\n")
				}
			} else if (dbol) {
				dbol = 0
				djmp = ""
			} else if (dbg > 1) {
				nx_ansi_warning("extra '" gc "' detected after '" acm __nx_if(nx_is_alpha(trk[idx - 1]), cr, trk[idx - 1]) "', discarding\n")
			}
		} else if (cr == go && gcr != "") {
			acm = trk[idx = __nx_shell_skip(trk[++idx], trk, flw, idx)]
			while (nx_is_alpha(cr = trk[++idx]))
				acm = acm cr
			if (acm == tpe) {
				gent = 0
			} else if (acm == dft) {
				gent = 1
			} else if (acm == epi) {
				gent = 2
			} else if (acm == use) {
				gent = 3
			} else if (acm == dsc) {
				gent = 4
			} else if (acm == blt) {
				gent = 5
			} else if (acm == regx) {
				gent = 6
			} else if (acm == min) {
				gent = 7
			} else if (acm == max) {
				gent = 8
			} else {
				if (dbg > 1)
					nx_ansi_warning("provided '" acm "' is garbage, what do you wish this to mean? '" cr "' discarding unimplemented metadata field\n")
				continue
			}

			cr = acm
			if ((acm = trk[idx = __nx_shell_skip(trk[++idx], trk, flw, idx)]) == "\x5c") {
				acm = trk[++idx]
			} else if (acm == gc) {
				nx_ansi_warning("provided '" cr "' for '" gcr "' is empty, is this intended? It wont be registered, discarding metadata field\n")
				continue
			}

			while ((cr = trk[++idx]) != gc) {
				if (cr == "\x5c")
					cr = trk[++idx]
				acm = acm cr
			}

			V1[(V1[V1[gcr] - strde * 2] + 1) + strde * gent] = acm
		} else {
			if (dbg > 1)
				nx_ansi_warning("provided '" cr "' is garbage or malformed, what do you wish this to mean? discarding\n")
			wret = -2
		}
	}
	delete trk
	V1[5 * strde] = grp
	if (eret = int(eret))
		return eret
	return int(wret)
}

function nx_shell_args(V1, V2,
	strde, dbg, m, oft,
	ps, pref,
	bk,
	ab,
	fs, fa, fd, fm, fr, fi, fn,
	ctp, cidx,
	oln, oidx,
	con, tok,
	r, s, n,
	idx, cat, grp, trm,
	dsh, vl,
	wret, eret,
	acrgx, eacrgx,
	trk)
{

	strde = V1[0]
	dbg = V1[strde * 3]
	ps = V1[strde * 2]
	m = V1[strde * 4]

	# ACTIONS
	oft = m * 6
	fa = V1[(oft + 1) * strde]
	fd = V1[(oft + 2) * strde]
	fm = V1[(oft + 3) * strde]
	fr = V1[(oft + 4) * strde]
	fi = V1[(oft + 5) * strde]
	fn = V1[(oft + 6) * strde]

	# MISC
	oft = m * 8
	pref = V1[(oft + 1) * strde]
	con = V1[(oft + 4) * strde]
	fs = V1[(oft + 6) * strde]

	# FLAGS
	oft = m * 7
	ab = V1[(oft + 2) * strde]

	# REGEX
	oft = m * 9
	eacrgx = V1[(oft + 1) * strde]
	acrgx = V1[(oft + 5) * strde]

	# TOGGLES
	oft = m * 5
	bk = V1[(oft + 3) * strde]

	cnt = length(V2)
	trm = 1
	ctp = cnt
	cidx = cnt
	idx = 1
	while (idx < cnt) {
		if (ctp > cnt) {
			if (cidx == ctp) {
				ctp = cnt
				cidx = cnt
				continue
			}
			tok = V2[++cidx]
		} else {
			tok = V2[++idx]
		}
		if (trm > 0 && substr(tok, 1, 1) == pref) {
			tok = substr(tok, 2)
			if (substr(tok, 1, 1) == pref) {
				if ((tok = substr(tok, 2)) == "") {
					trm = 0
					if (dbg > 2)
						nx_ansi_light("end of arguments detected  '" pref pref "' appending remainder\n")
					continue
				} else if (length(tok = nx_shell_actions(tok, acrgx, fs, V2, dbg, eacrgx)) > 1 && tok in V1) {
					if (dbg > 2)
						nx_ansi_debug("long form option '" tok "' was registered, preceding\n")
					trm = 2
				}
			} else if (nx_shell_actions(tok, acrgx, fs, V2, dbg, eacrgx) != -1) {
				opt = V2["opt"]
				if (length(opt) > 1) {
					vl = V2["mod"] V2["num"] V2["act"] V2["val"]
					oln = split(opt, trk, "")
					opt = ""
					for (oidx = 1; oidx <= oln; ++oidx) {
						tok = trk[oidx]
						if (tok in V1) {
							if (dbg > 2)
								nx_ansi_alert("short form bundle option '" pref tok vl "' was registered, preceding\n")
							V2[++ctp] = pref tok vl
						} else {
							opt = opt tok
						}
					}
					trm = 2
					if (bk && opt)
						V2[idx--] = opt
					continue
				} else if (opt in V1) {
					if (dbg > 2)
						nx_ansi_success("short form option '" opt "' was registered, preceding\n")
					trm = 2
					tok = opt
				}
			}
		}

		if (trm < 2) {
			if (ab && (ab != 3 || (ab == 3 && opt != "")) && trm) {
				if (dbg > 2)
					nx_ansi_success("option '" tok "' was never redistered, abort flag was set to '" ab "', preceding\n")
				if (ab == 1)
					break
				trm = 0
			}
			tok = V2[idx]
			s = nx_join_str(s, tok, con)
			r = nx_join_str(r, tok, ps)
			++n
			if (dbg > 2)
				nx_ansi_alert("appending '" tok "' to remainder \n")
			continue
		}

		trm = 1
		cat = V1[tok]
		grp = cat % strde

		if (dbg > 2) {
			if (grp < 13)
				nx_ansi_light("token index for '" tok "' registered under '" cat "' and part of the '" grp "' id\n")
			else
				nx_ansi_light("token index for '" tok "' registered under '" cat "' and part of the '" grp "' id, with the group leader of type '" V1[grp + strde] "' being '" V1[grp + strde * 2] "'\n")
		}
		idx = nx_shell_dispatch(V1, V2, idx, grp)
	}

	V1[-1] = r
	V1[-2] = s
	V1[-3] = int(n)
	if (dbg > 2)
		nx_ansi_alert("remainder is '" r "' \n")
	delete trk
	if (eret = int(eret))
		return eret
	return int(wret)
}

function nx_shell_help(V,
	str, srt, strde, soff,
	moff, grps,
	i, j)
{
	strde = V[0]
	grps = V[strde * 5]
	soff = strde + strde
	srt = V[1]

	for (i = 1 + soff; i <= srt; i += strde)
		str = str " " V[i]
	if (str != "") {
		nx_ansi_info("\n(" V[1 + strde] ") keywords:" str)
		str = ""
	}

	srt = V[4]
	for (i = 4 + soff; i <= srt; i += strde)
		str = str " " V[i]
	if (str) {
		nx_ansi_info("\n(" V[4 + strde] ") flags:" str)
		str = ""
	}

	srt = V[7]
	for (i = 7 + soff; i <= srt; i += strde)
		str = str " " V[i]
	if (str) {
		nx_ansi_info("\n(" V[7 + strde] ") flag arrays:" str)
		str = ""
	}

	srt = V[10]
	for (i = 10 + soff; i <= srt; i += strde)
		str = str " " V[i]
	if (str) {
		nx_ansi_info("\n(" V[10 + strde] ") keyword arrays:" str)
		str = ""
	}

	for (i = 13; i < grps; i =  i + 3) {
		j = i + strde

		str = "\n("  V[j] ") group '" V[j + strde] "' ->"
		srt = V[i]
		for (j += soff; j <= srt; j += strde)
			str = str " " V[j]
		nx_ansi_info(str)

		moff = V[i] + 1
		j = 0
		if (moff in V) {
			nx_ansi_debug("\ntype:\n\t'" V[moff] "'")
			j = 1
		}

		moff = moff + strde
		if (moff in V) {
			nx_ansi_debug("\ndefault:\n\t'" V[moff] "'")
			j = 1
		}

		moff = moff + strde
		if (moff in V) {
			nx_ansi_success("\nepilog:\n\t'" V[moff] "'")
			j = 1
		}

		moff = moff + strde
		if (acm == "usage") {
			nx_ansi_alert("\usage:\n\t'" V[moff] "'")
			j = 1
		}

		moff = moff + strde
		if (moff in V) {
			nx_ansi_light("\ndescription:\n\t'" V[moff] "'")
			j = 1
		}

		if (j)
			nx_fd_stderr("\n")
	}
	nx_fd_stderr("\n")
}


function nx_shell_build(V, N,
	strde, m, oft,
	pref,
	msuf, mstr, mrmrgx,
	mpr, mar, dsh, dq)
{
	strde = V[0]
	m = V[strde * 4]

	# REGEX
	oft = m * 9
	mrgx = V[(oft + 9) * strde]
	mrmrgx = V[(oft + 10) * strde]
	mstr = V[N]

	oft = m * 5
	dq = !V1[(oft + 5) * strde]

	# MISC
	oft = m * 8
	pref = V[(oft + 1) * strde]

	while (match(mstr, mrgx)) {
		mpr = substr(mstr, RSTART, RLENGTH)
		mar = mpr
		gsub(mrmrgx, "", mar)
		if (mar in V) {
			dsh = __nx_if(length(mar) > 1, pref pref, pref)
			sub(mpr, __nx_stringify_var("", V[V[dsh mar] - 2], dq, "", "", 1), mstr)
		}
	}
	V[-4] = V[-4] mstr
}

# V1	vec
# V2	agv
# N1	meta lane
# D1	current data
# D2	sep
# D3	stored data
# N2	direction
function nx_shell_type(V1, V2, N1, D1, D2, D3, N2,
	strde, dft, tpe, tru, fls,
	min, max, regx,
	dbg,
	m, oft, num)
{
	strde = V1[0]
	dbg = V1[strde * 3]
	if (N1 + strde in V1)
		dft = V1[N1 + strde]
	else
		dft = ""
	regx = N1 + strde * 6
	if (N1 in V1) {
		m = V1[strde * 4]

		# REPRESENTATION
		oft = m * 2
		tru = V1[(oft + 1) * strde]
		fls = V1[(oft + 2) * strde]

		tpe = V1[N1]
		if (tpe == "toggle") {
			if (D1 != tru && D1 != fls)
				D1 = dft
		} else if (tpe == "int") {
			num = 1
			if (! __nx_is_integral(D1, 1))
				D1 = ""
		} else if (tpe == "float") {
			num = 1
			if (! __nx_is_float(D1, 1))
				D1 = ""
		} else if (tpe == "real") {
			num = 1
			if (! __nx_is_real(D1, 1))
				D1 = ""
		}
		if (num) {
			sub(/^[+]/, "", D1)
			min = N1 + strde * 7
			max = N1 + strde * 8

			if (min in V1) {
				if (! (D1 >= V1[min])) {
					if (max in V1 && ! (D1 <= V1[max])) {
						if (dbg > 1)
							nx_ansi_warning("minmax breach\n")
					} else {
						if (dbg > 1)
							nx_ansi_warning("min breach\n")
					}
					D1 = ""
				}
			}

			if (D1 != "" && max in V1) {
				if (! (D1 <= V1[max])) {
					if (dbg > 1)
						nx_ansi_warning("min breach\n")
					D1 = ""
				}
			}
		}
	}

	if (regx in V1) {
		if (D1 !~ V1[regx])
			D1 = ""
	}

	if (D1 == "" && D3 == "")
		return V2["cur"]
	if (N2)
		return nx_join_str(D3, D1, D2)
	return nx_join_str(D1, D3, D2)
}

function nx_shell_dispatch(V1, V2, N1, N2,
	strde, cat, sym, arg, opt, act, mod, val, num, cse, pref, cur, idx,
	con, ps, vr, m, oft,
	tpe, bld, dft,
	tru, fls,
	fa, fd, fm, fr, fi, fn)
{

	strde = V1[0]
	ps = V1[strde * 2]
	m = V1[strde * 4]

	# ACTIONS
	oft = m * 6
	fa = V1[(oft + 1) * strde]
	fd = V1[(oft + 2) * strde]
	fm = V1[(oft + 3) * strde]
	fr = V1[(oft + 4) * strde]
	fi = V1[(oft + 5) * strde]
	fn = V1[(oft + 6) * strde]

	if (N2 < 13) {
		opt = V2["opt"]
		con = ""
		sym = V1[N2]
		cat = N2
	} else {
		opt = V1[N2 + strde * 2]
		con = "G"
		sym = V1[N2 + strde]
		cat = V1[sym] % strde
	}

	# MISC
	oft = m * 8
	pref = V1[(oft + 1) * strde]

	# REPRESENTATION
	oft = m * 2
	tru = V1[(oft + 1) * strde]
	fls = V1[(oft + 2) * strde]

	tpe = V1[V1[opt] - strde * 2] + 1
	bld = tpe + strde * 5

	if (length(opt) > 1)
		pref = pref pref
	if (! (pref opt in V1)) {
		idx = V1["-0"] - 1
		V1[idx] = pref opt
		V1[pref opt] = idx--
		dft = tpe + strde
		if (cat == 1)
			V1[idx] = "NEX_" con "k_" opt
		else if (cat == 4)
			V1[idx] = "NEX_" con "f_" opt
		else if (cat == 7)
			V1[idx] = "NEX_" con "F_" opt
		else if (cat == 10)
			V1[idx] = "NEX_" con "K_" opt
		else
			V1[idx] = "NEX_" con "_" opt
		V1["-0"] = --idx
		if (dft in V1)
			V1[idx] = V1[dft]
	} else {
		idx = V1[pref opt] - 2
	}

	vr = opt
	V2["gcr"] = vr
	opt = V2["opt"]
	cse = nx_is_lower(substr(opt, 1, 1))
	con = V1[(oft + 4) * strde]
	cur = V1[idx]
	V2["cur"] = cur

	if ((act = V2["act"])  == "") {
		if (cat == 1) {
			V1[idx] = nx_shell_type(V1, V2, tpe, V2[++N1], "", "", 0)
		} else if (cat == 4) {
			if (vr == "help" || vr == "h") {
				nx_shell_help(V1)
			}
			nx_boolean(V1, idx, !cse, tru, fls)
		} else if (cat == 7) {
			if (N2 < 13)
				nx_boolean(V1, idx, cse, tru, fls)
			else
				V1[idx] = nx_shell_type(V1, V2, tpe, opt, "", "", 0)
		} else if (cat == 10) {
			V1[idx] = nx_shell_type(V1, V2, tpe, opt, ps, V2[++N1], cse)

		}
	} else {
		val = V2["val"]
		num = V2["num"]
		if ((mod = V2["mod"]) == "") {
			if (cat == 1 || cat == 4 || cat == 7) {
				V1[idx] = val
				if (cat == 4)
					nx_boolean(V1, idx, !cse, tru, fls)
			} else if (cat == 10) {
				V1[idx] = nx_shell_type(V1, V2, tpe, opt, ps, val, cse)
				if (cse)
					V1[idx] = opt ps val
				else
					V1[idx] = val ps opt
			}
		} else if (mod == fa) {
			if (cat == 1) {
				if (N2 < 13)
					V1[idx] = nx_shell_type(V1, V2, tpe, opt, "", V2[++N1], cse)
				else
					V1[idx] = nx_shell_type(V1, V2, tpe, opt, ps, V2[++N1], cse)
			} else if (cat == 4) {
				V1[idx] = nx_shell_type(V1, V2, tpe, opt, "", cur, cse)
			} else if (cat == 7) {
				V1[idx] = nx_shell_type(V1, V2, tpe, opt, con, cur, cse)
			} else if (cat == 10) {
				V1[idx] = nx_shell_type(V1, V2, tpe, opt ps val, ps, cur, cse)
			}
		} else if (mod == fd) {
			# ...
		} # ...
	}
	if (bld in V1)
		nx_shell_build(V1, bld)
	return N1
}

function nx_shell_actions(D1, D2, D3, V, N, D4,
	opt, num, val, mod,
	trk)
{
	opt = D1
	if (match(D1, "^" D4 "((" D2 ")[0-9]*)?" D3)) {
		val = substr(D1, RLENGTH + 1)
		D2 = RLENGTH
		split(substr(D1, 1, --D2), trk, "")
		while (nx_is_digit(D1 = trk[D2])) {
			num = D1 num
			D2--
		}
		while (! nx_is_alpha(D1 = trk[D2])) {
			mod = D1 mod
			D2--
		}
		delete trk
		opt = substr(opt, 1, D2)
	} else {
		if (opt !~ "^" D4 "$") {
			if (N > 0)
				nx_ansi_error("the action '" opt "' modifier cannot start with an alphabetic character.\n")
			return -1
		}
		D3 = opt
	}

	V["gcr"] = ""
	V["cur"] = ""
	if (D3 !~ "^" D4 "$") {
		V["opt"] = opt
		V["val"] = val
		V["act"] = D3
		V["mod"] = mod
		V["num"] = __nx_else(num, 1, 1)
		return opt
	}

	V["opt"] = D3
	V["val"] = ""
	V["act"] = ""
	V["mod"] = ""
	V["num"] = ""
	return D3
}

function nx_shell_sanitize(D, V,
	v1, v2, i)
{
	for (i in V)
		gsub(i, V[i], D)
	if (i != "")
		return D
	for (i = 0; i <= 64; ++i)
		v1[sprintf("%c", i)] = i
	for (i = 91; i <= 96; ++i)
		v1[sprintf("%c", i)] = i
	for (i = 123; i <= 127; ++i)
		v1[sprintf("%c", i)] = i
	gsub(/[_A-Za-z0-9]/, "", D)
	i = split(D, v2, "")
	do {
		D = v2[i]
		V["[" D "]"] = v1[D]
	} while (--i > 0)
	delete v1
	delete v2
}

function nx_shell_environ(V1, V2, D,
	as, ln, idx, dq, trk, pre, post, ust, ept, ext, oft,
	vr, vl, nm, pos, acm, psrt,
	strde, m)
{

	strde = V1[0]
	m = V1[strde * 4]

	oft = m * 5
	ust = V1[(oft + 1) * strde]
	ept = V1[(oft + 4) * strde]
	dq = V1[(oft + 5) * strde]

	if (ept) {
		pre = "export "
		post = ";"
	} else {
		pre = ""
		post = " "
	}

	oft = m * 8
	as = V1[(oft + 6) * strde]
	ext = V1[(oft + 2) * strde]
	psrt = V1[strde * 6]

	if (ust) {
		ln = split(D, trk, " ")
		for (idx = 1; idx <= ln; ++idx)
			acm = acm pre __nx_stringify_var(trk[idx], "", dq, as, post)
		delete trk
	}

	ln = V1["-0"]
	idx = -psrt / 3
	acm = acm pre __nx_stringify_var("NEX_ARGC", -ln / 3 - idx, dq, as, post)
	acm = acm pre __nx_stringify_var("NEX_ARGV_R", V1[-1], dq, as, post)
	acm = acm pre __nx_stringify_var("NEX_ARGV_S", V1[-2], dq, as, post)
	acm = acm pre __nx_stringify_var("NEX_ARGV_0", V1[-3], dq, as, post)
	acm = acm pre __nx_stringify_var("NEX_ARGV_E", V1[-4], dq, as, post)
	idx = ""
	for (idx in V2)
		break
	if (idx == "")
		nx_shell_sanitize(ext, V2)
	for (idx = psrt - 1; idx >= ln; idx = idx - 3) {
		nm = "NEX_ARGV_" ++pos
		vr = nx_shell_sanitize(V1[idx - 1], V2)
		vl = V1[idx - 2]
		acm = acm pre __nx_stringify_var(nm, vr, dq, as, post)
		acm = acm pre __nx_stringify_var(vr, vl, dq, as, post)
	}
	return acm
}

