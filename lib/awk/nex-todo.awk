#nx_include "nex-misc.awk"
#nx_include "nex-str.awk"
#nx_include "nex-math.awk"
#nx_include "nex-json.awk"

#function nx_struct_log_db(V, N, D, B)
#{
#	if (length(V)) {
#		return nx_log_db(N, D, B, V)
#	} else {
#
#	}
#}

#function nx_kwargs(D1, V1, S1, S2, V2,	v1, v2)
#{
#	if (D1 == "")
#		return
#	__nx_quote_map(V2, "0", "0")
#	S1 = __nx_else(S1, ",")
#	V2[S1] = S1
#	S2 = __nx_else(S2, "=")
#	V2[S2] = S2
#	nx_bijective(v1, S1, S2)
#	v2["cur"] = v1[S1]
#	while (D1) {
#		if (v2["cur"] == S2) {
#			v2["idx"] = nx_find_best(D1, V2)
#			v2["sep"] = substr(D1, v2["idx"], 1)
#			#if (v2["sep"] == S1)
#				#system("printf " nx_struct_log_db(,1) " >&2")
#		}
#	}
#}

