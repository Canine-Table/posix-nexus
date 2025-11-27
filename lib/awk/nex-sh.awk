#nx_include nex-str.awk
#nx_include nex-misc.awk
#nx_include nex-struct.awk
#nx_include nex-type.awk
#nx_include nex-log.awk

function __nx_stringify_opts(V, D1, D2, D3, D4, D5, N,	i, j)
{
	for (i in V) {
		gsub("'", "\x27\x22\x27\x22\x27", V[i])
		gsub("^'|'$", "", V[i])
		D1 = nx_join_str(D1, "NEX_" D2 "" ++j "=\x27" i "\x27 NEX_" D2 "_" i "=\x27" V[i] "\x27", D4)
		if (N > 2)
			nx_ansi_info("(" D3 ") " i " = " V[i] "\n")
	}
	return nx_join_str(D1, "NEX_" D2 "=\x27" trk["i"] "\x27" D5, D4)
}

function nx_sh_optargs(D1, N, D2, D3, D4, args, trk, stk, kwdas, kwds, grp, grps, flgs, grpa, grpas, grpka, grpakwds, grpakwlnk)
{
	# Check if the input string D1 is not empty
	if (D1 == "")
		return -1

	trk["ps"] = __nx_else(D2, "<nx:null/>") # Param sep
	trk["ag"] = split(D1, args, trk["ps"])
	if (N > 2)
		print args[1]

	# Define default delimiters
	trk["ds"] = __nx_else(D3, ",")
	split(D4, stk, trk["ds"])
	trk["ks"] = __nx_else(stk[1], ":") # key sep
	trk["fs"] = __nx_else(stk[2], "=") # optional set flag sep
	trk["as"] = __nx_else(stk[3], "@") # appendable kwds sep

	trk["fa"] = __nx_else(stk[4], "+") # optional push flag sep
	trk["fr"] = __nx_else(stk[5], "-") # optional pop flag sep

	# groups
	trk["go"] = __nx_else(stk[6], "<") # begin group
	trk["gc"] = __nx_else(stk[7], ">") # eng group
	nx_bijective(trk, trk["gc"], trk["go"]) # bijective  results
	trk["gs"] = trk["go"] # initial state

	trk["lo"] = __nx_else(stk[8], "~") # begin long option
	trk["lc"] = __nx_else(stk[9], "-") # end long option
	nx_bijective(trk, trk["lc"], trk["lo"]) # bijective  results
	trk["ls"] = trk["lo"] # initial state

	trk["ln"] = split(args[1], stk, "")

	for (trk["i"] = 1;  trk["i"] <= trk["ln"]; ++trk["i"]) {
		if (nx_is_alpha(stk[trk["i"]]) && (stk[trk["i"] + 1] != trk["as"] && stk[trk["i"] + 1] != trk["go"] && stk[trk["i"] + 1] != trk["ks"])) {
			if (trk["gl"]) {
				if (trk["glj"] == 1) {
					grp[stk[trk["i"]]] = trk["gl"]
					if (N > 3)
						nx_ansi_debug("(group member added) " trk["gl"] ": " stk[trk["i"]] "\n")
				} else if (trk["glj"] == 2) {
					grpa[stk[trk["i"]]] = trk["gl"]
					if (N > 3)
						nx_ansi_debug("(group array member added) " trk["gl"] ": " stk[trk["i"]] "\n")
				} else if (trk["glj"] == 3) {
					grpka[stk[trk["i"]]] = trk["gl"]
					if (N > 3)
						nx_ansi_debug("(group array member added) " trk["gl"] ": " stk[trk["i"]] "\n")
				
				} else {
					if (N > 0)
						nx_ansi_error("an overflow or a you forgot somethiing here in nex-sh!" "\n")
					D1 = -1
					break
				}
			} else {
				flgs[stk[trk["i"]]] = ""
				if (N > 3)
					print "(flag detected) " stk[trk["i"]]
			}
		} else if (stk[trk["i"]] == trk["gs"]) { # group?
			if (stk[trk["i"]] == trk["go"] && ! trk["glj"]) { # is it the begining of a group??
				trk["gl"] = stk[trk["i"] - 1] # group leader
				if (stk[trk["i"] + 1] == trk["as"]) {
					trk["i"]++
					if (N > 3)
						nx_ansi_debug("(group array toggle on) " trk["gl"] "\n")
					grpas[trk["gl"]] = ""
					trk["glj"] = 2
				} else if (stk[trk["i"] + 1] == trk["ks"]) {
					trk["i"]++
					if (N > 3)
						nx_ansi_debug("(group keyword toggle on) " trk["gl"] "\n")
					grpakwds[trk["gl"]] = ""
					trk["glj"] = 3
				} else {
					grps[trk["gl"]] = ""
					if (N > 3)
						nx_ansi_debug("(group toggle on) " trk["gl"] "\n")
					trk["glj"] = 1
				}
			} else if (trk["glj"] && stk[trk["i"]] == trk["gc"]) {
				if (N > 3) {
					if (trk["glj"] == 1)
						nx_ansi_debug("(group toggle off) " trk["gl"] "\n")
					else if (trk["glj"] == 2)
						nx_ansi_debug("(group array toggle off) " trk["gl"] "\n")
					else if (trk["glj"] == 3)
						nx_ansi_debug("(group keyword toggle off) " trk["gl"] "\n")
				}
				trk["gl"] = "" # unset the group leader
				trk["glj"] = 0
			} else {
				if (N > 0)
					nx_ansi_error("im not sure whats going on over here!\n")
				D1 = -1
				break
			}
			trk["gs"] = trk[trk["gs"]]
		} else if (nx_is_alpha(stk[trk["i"]])) {
			if (stk[trk["i"] + 1] == trk["ks"]) {
				if (N > 3)
					nx_ansi_debug("(key word detected) " stk[trk["i"]] "\n")
				kwds[stk[trk["i"]++]] = ""
			} else if (stk[trk["i"] + 1] == trk["as"]) {
				if (N > 3)
					nx_ansi_debug("(key word array detected) " stk[trk["i"]] "\n")
				kwdas[stk[trk["i"]++]] = ""
			}
		}
		D1 = 0
	}

	if (D1 != -1) {
		D1 = ""
		for (trk["i"] = 2; trk["i"] <= trk["ag"]; ++trk["i"]) {
			if (args[trk["i"]] == "--")
				break
			trk["ln"] = split(args[trk["i"]], stk, "")
			if (stk[1] == "-") {
				if (N > 3)
					nx_ansi_debug("(param) " args[trk["i"]] "\n")
				if (stk[2] in grpa) {
					grpas[grpa[stk[2]]] = nx_join_str(grpas[grpa[stk[2]]] , stk[2], trk["ps"])
					if (N > 3)
						nx_ansi_debug("(group array member of '" grpa[stk[2]] "') " stk[2] "\n")
				} else if (stk[2] in grpka) {
					grpakwds[grpka[stk[2]]] = stk[2]
					grpakwlnk[grpka[stk[2]]] = args[++trk["i"]]
					args[trk["i"]] = ""
					if (N > 3)
						nx_ansi_debug("(group member of '" grpka[stk[2]] "') " stk[2] " with link value " args[trk["i"]] "\n")
				} else if (stk[2] in grp) {
					grps[grp[stk[2]]] = stk[2]
					if (N > 3)
						nx_ansi_debug("(group member of '" grp[stk[2]] "') " stk[2] "\n")
				} else if (stk[2] in flgs) {
					if (N > 3)
						nx_ansi_debug("(flag) %s: " stk[2])
					if (stk[3] == trk["fs"]) {
						flgs[stk[2]] = substr(args[trk["i"]], 4)
					} else if (stk[3] == trk["fa"]) {
						flgs[stk[2]] = nx_join_str(flgs[stk[2]], substr(args[trk["i"]], 4), trk["ps"])
					} else if (stk[3] == trk["fr"]) {
						if (match(flgs[stk[2]], "^.*" trk["ps"])) {
							if (substr(args[trk["i"]], 4) == "")
								flgs[stk[2]] = substr(flgs[stk[2]], RSTART, RLENGTH - length(trk["ps"]))
							else
								flgs[stk[2]] = substr(flgs[stk[2]], RSTART, RLENGTH)
						}
						flgs[stk[2]] = flgs[stk[2]] substr(args[trk["i"]], 4)
					} else if (trk["ln"] > 2) {
						flgs[stk[2]] = substr(args[trk["i"]], 3)
					} else {
						nx_boolean(flgs, stk[2])
					}
					if (N > 3)
						nx_ansi_print("D%\0\n" flgs[stk[2]])
				} else if (stk[2] in kwds) {
					kwds[stk[2]] = args[++trk["i"]]
					if (N > 3)
						nx_ansi_debug("(key words) " stk[2] ": " args[trk["i"]] "\n")
				} else if (stk[2] in kwdas) {
					kwdas[stk[2]] = nx_join_str(kwdas[stk[2]], args[++trk["i"]], trk["ps"])
					if (N > 3)
						nx_ansi_debug("(key word array) " stk[2] ": " kwdas[stk[2]] "\n")
				} else {
					D1 = nx_join_str(D1, args[trk["i"]], trk["ps"])
					if (N > 1)
						nx_ansi_warning("(unknown arg) " args[trk["i"]] "\n")
				}
			} else {
				D1 = nx_join_str(D1, args[trk["i"]], trk["ps"])
				if (N > 3)
					nx_ansi_debug("(remainder) " args[trk["i"]] "\n")
			}
		}

		delete grp
		if (N > 2)
			nx_ansi_info("(rmdr) " D1)
		gsub("'", "\x27\x22\x27\x22\x27", D1)
		gsub("^'|'$", "", D1)
		D3 = D1
		gsub(trk["ps"], " ", D3)
		D1 = "NEX_R=\x27" D1 "\x27 \\\n NEX_S=\x27" D3 "\x27 \\\n"
		D1 = __nx_stringify_opts(kwds, D1, "k", "kwds", " ", " \\\n", N)
		D1 = __nx_stringify_opts(kwdas, D1, "K", "kwdas", " ", " \\\n", N)
		D1 = __nx_stringify_opts(grps, D1, "g", "grps", " ", " \\\n", N)
		D1 = __nx_stringify_opts(grpas, D1, "G", "grpas", " ", " \\\n", N)
		D1 = __nx_stringify_opts(grpakwds, D1, "Gk", "grpakwds", " ", " \\\n", N)
		D1 = __nx_stringify_opts(grpakwlnk, D1, "Gl", "grpakwlnk", " ", " \\\n", N)
		D1 = __nx_stringify_opts(flgs, D1, "f", "flgs", " ", "; # Nex is done here\n", N)
	}
	delete trk
	delete stk
	delete args
	return D1
}


#nx_sh_look(V, D)
#{

#}

