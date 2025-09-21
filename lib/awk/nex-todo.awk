#nx_include "nex-misc.awk"
#nx_include "nex-str.awk"


# B2	if B1 it look for the furthest match from the start of D1


function nx_parser_machine(V1, V2, V3, V4, V5)
{
	if (match(V1["ln"], V1["sig"] "nx_")) {
		V1["cr"] = V1["cr"] =  substr(V1["ln"], 1, RSTART - 1)
		if (match((V1["ln"] = substr(V1["ln"], RSTART)), "^[^ \t]+")) {
			V1["ta"] = substr(V1["ln"], 1, RLENGTH)
			if (V1["ta"] == V1["sig"] "nx_include") {
				V1["ln"] = substr(V1["ln"], RSTART + RLENGTH)
				gsub(/^[ \t]*/, "", V1["ln"])
				V1["ta"] = ""
				nx_find_pair(V1["ln"], V4, V1)
				if (! V1["osidx"]) {
					if (nx_is_file(V1["dir"] V1["ln"]))
						V1["ta"] = V1["dir"] V1["ln"]
					else if (nx_is_file(V1["ln"]))
						V1["ta"] = V1["ln"]
					V1["ln"] = ""
				} else {
					V1["odlm"] = substr(V1["ln"], V1["osidx"], V1["oeidx"])
					if (V1["odlm"] ~ /^['"]$/) {
						V1["cdlm"] = substr(V1["ln"], V1["osidx"] + V1["oeidx"] + V1["csidx"], V1["ceidx"])
						V1["ta"] = substr(V1["ln"], V1["osidx"] + V1["oeidx"], V1["csidx"])
						V1["ln"] = substr(V1["ln"], V1["osidx"] + V1["oeidx"] + V1["csidx"] + V1["ceidx"])
						if (V1["cdlm"] == V1["odlm"]) {
							if (nx_is_file(V1["dir"] V1["ta"]))
								V1["ta"] = V1["dir"] V1["ta"]
							else if (! nx_is_file(V1["ta"]))
								V1["ta"] = ""
						} else {
							# TODO multi file entries
						}
					} else {
						V1["odlm"] = substr(V1["ln"], 1, V1["osidx"] - 1)
						if (nx_is_file(V1["dir"] V1["odlm"]))
							V1["ta"] = V1["dir"] V1["odlm"]
						else if (nx_is_file(V1["odlm"]))
							V1["ta"] = V1["odlm"]
						V1["ln"] = substr(V1["ln"], V1["osidx"] + V1["oeidx"])
					}
				}
				if (V1["ta"]) {
					# TODO mangage the spare dfs as a flat map for nested included without recursion
					V5[V1["rt"] "." ++V1[V1["rt"] ".0"]] = V1["cr"]
				}
			}
		}
	}
}

#D1 = entry file
#D2 = files to omit
#D3 = Sigil
#D4 = root directory to append to within the include directive entries
function nx_parse(D1, D2, D3, D4,	trk, stk, fl, arr, qte, que)
{
	if (nx_trim_split(D2, fl, "<nx:null/>")) {
		do {
			nx_bijective(fl, fl[0], 0, fl[fl[0]])
		} while (--fl[0] > 0)
		delete fl[0]
	}
	qte["\x22"] = "\x22"
	qte["\x27"] = "\x27"
	qte["\x5c"] = ""
	qte["\x20"] = ""
	qte["\x09"] = ""
	trk["sig"] = __nx_else(D3, "#")
	if (nx_is_file(D1)) {
		if (! D4) {
			D4 = D1
			sub(/[^/]+$/, "", D4)
		}
		trk["dir"] = D4
		while ((getline trk["ln"] < D1) > 0) {
			if (nx_parser_machine(trk, stk, fl, qte, que))
				break
		}
		close(D1)
	} else {
		trk["dir"] = D4
		D1 = split(D1, arr, "<nx:null/>")
		for (arr["idx"] = 1; arr["idx"] <= D1; ++arr["idx"]) {
			trk["ln"] = arr[arr["idx"]]
			if (nx_parser_machine(trk, stk, fl, qte, que))
				break
		}
	}
}

