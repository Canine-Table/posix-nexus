#nx_include "nex-misc.awk"
#nx_include "nex-str.awk"

function nx_str_opts(D, S1, S2, S3, B,		i, j, k, l, res, v, opts, flg, kw, param)
{
	# Check if the input string D is not empty
	if (D != "") {
		# Define default delimiters
		S1 = __nx_else(S1, ":") # Key delimiter
		S2 = __nx_else(S2, "<nx:null/>") # Used as boundary for arguments (quotes are stripped)
		S3 = __nx_else(S3, "=") # Used to separate key-value pairs
		# Split D into parameter array using the S2 delimiter
		if (l = split(D, param, S2)) { # Parsing option arguments
			# Process the first parameter to categorize flags and keys
			j = split(param[1], opts, "") 
			for (i = 1; i <= j; i++) {
				if (opts[i + 1] != S1) {
					if (opts[i] != S1) {
						flg[opts[i]] = ""
						res[opts[i]] = ""
					} # Mark single-character flags (e.g., `-a`) with possible arguments (e.g '-a="the value"`)
				} else {
					res[opts[i]] = ""
					kw[opts[i++]] = "" # Mark single-character flags that require arguments (e.g., `-k value`)
				}
			}
			# Reset opts array for further processing
			split("", opts, "")
			j = ""
			# Iterate over extracted parameters, starting from second element
			for (i = 2; i <= l; i++) {
				if (param[i] ~ /^-/) { # Check if param starts with `-`
					# Extract option name from parameter
					if ((S1 = nx_cut_str(param[i], "-", 0)) == "-")
						break # Skip processing if `--` is encountered
					# Split key-value pairs
					nx_pair_str(S1, v, S3)
					# Handle flags (keys with no values or optional values)
					if (v[v[0]] in flg) {
						if (! (S1 in opts)) {
							opts[++opts[0]] = S1
							delete res[S1]
						}
						opts[S1] = v[S1]
					# Handle keyword arguments (keys with assigned values)
					} else if (S1 in kw) {
						if (! (S1 in opts)) {
							opts[++opts[0]] = S1
							delete res[S1]
						}
						opts[S1] = nx_join_str(opts[S1], param[++i], S2)
					# Otherwise, combine parameters
					} else {
						j = nx_join_str(j, param[i], S2)
					}
				} else {
					# Join parameters that are not preceded by `-`
					j = nx_join_str(j, param[i], S2)
				}
			}
		}
		# Cleanup temporary storage arrays
		delete kw
		delete flg
		delete param
		j = "NX_OPT_TOP=\x27" opts[0] "\x27 NX_OPT_RMDR=\x27" j "\x27"
		# Construct output string from extracted options
		for (i = opts[0]; i > 0; i--)
			j = "NX_OPT_" i "=\x27" opts[i] "\x27 " opts[i] "=\x27" opts[opts[i]] "\x27 " j
		for (i in res)
			j = i "=\x27\x27 " j
		# Cleanup opts array
		if (! B) {
			delete opts
			delete res
		}
		# Print the final formatted options string
		return j
	}
}

function nx_file_map(V)
{
	V["b"] = "-b " # -b file — True if file is a block special file
	V["c"] = "-c " # -c file — True if file is a character special file
	V["d"] = "-d " # -d file — True if file is a directory
	V["e"] = "-e " # -e file — True if file exists
	V["f"] = "-f " # -f file — True if file is a regular file
	V["g"] = "-g " # -g file — True if file has set-group-ID flag set
	V["l"] = "-h " # -h file — True if file is a symbolic link
	V["p"] = "-p " # -p file — True if file is a named pipe
	V["u"] = "-u " # -u file — True if file has set-user-ID flag set
	V["t"] = "-t " # -t fd — True if file descriptor fd is open on a terminal
	V["s"] = "-S " # -S file — True if file is a socket
	V["h"] = "-s " # -s file — True if file has size greater than zero
	V["r"] = "-r " # -r file — True if file is readable
	V["w"] = "-w " # -w file — True if file is writable
	V["x"] = "-x " # -x file — True if file is executable
}

function nx_file_type(D,	trk, v1, v2, v3, i, j)
{
	nx_trim_split(D, v1, "<nx:null/>")
	nx_file_map(v3)
	trk["hld"] = 0
	trk["bl"] = "a"
	trk["gte"] = " || "
	for (i = 1; i <= v1[0]; i++) {
		if (sub(/^-/, "", v1[i])) {
			if ((trk["opt"] = tolower(v1[i])) == "f") {
				continue
			} else if (trk["opt"] ~ /^[ao]$/) {
				trk["ng"] = __nx_if(nx_is_upper(v1[i]), "! ", "")
				trk["gte"] = __nx_if(trk["opt"] == "a", " && ", " || ") trk["ng"]
			}
		} else if (trk["opt"] == "f") {
			trk["fl"] = v1[i]
			trk["hld"] = trk["hld"] + 1
			delete trk["opt"]
		} else {
			j = split(v1[i], v2, "")
			v2[0] = j
			if (! trk["fl"])
				trk["fl"] = "<nx:placeholder" __nx_if(trk["hld"], " index=" trk["hld"], "") "/>"
			trk["par"] = ""
			for (j = 1; j <= v2[0]; j++) {
				if ((trk["fg"] = tolower(v2[j])) ~ /^[ao]$/)
					trk["bl"] = tolower(v2[j])
				else if (trk["fg"] = v3[trk["fg"]])
					trk["par"] = nx_join_str(trk["par"], __nx_if(nx_is_upper(v2[j]), "! ", "") trk["fg"] "\x27" trk["fl"] "\x27 ", "-" trk["bl"] " ")
			}
			if (trk["par"]) {
				trk["par"] = "test " trk["par"]
				if (! trk["str"])
					trk["par"] = trk["ng"] trk["par"]
				trk["str"] = nx_join_str(trk["str"], trk["par"], trk["gte"])
			}
		}
	}
	D = trk["str"]
	delete trk
	delete v1
	delete v2
	delete v3
	return D
}


