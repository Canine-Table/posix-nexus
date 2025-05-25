

function nx_grid(V, D,	v)
{
	if (D != "") {
		nx_json("{" D "}", v, 2)
		if (".nx.data" in v) {
			if (! (0 in V && "|" in V && "-" in V)) {
				V[0] = 1
				V["|"] = 1
				V["-"] = 1
			}
		}

		delete v
	}
}


		#if (! (V[0] "," V[V[0]] in V))
		#	delete V[V[0]--]
		#	N = V[V[0] "," V[V[0]]]
		#	if (D != "")
		#		delete V[V[0] "," V[V[0]]--]
		#} else {
		#	if (! (V["-"] "," V["|"] in V)) {
		#		delete V[V["-"]++]
		#		V["|"] = 1
		#	}
		#	if (V["-"] <= V[0]) {
		#		N = V[V["-"] "," V["|"]]
		#		if (D != "")
		#			delete V[V["-"] "," V["|"]++]
		#	} else {
		#		return 0
		#	}
		#}
		#return N
function nx_json_build(D, V,	v1, v2, v3, i)
{
	print D
	#v3[":"] = ","
	#while (v2["st"] = nx_json_split(D, V, v1)) {
	#	if (v2["st"] == 1) {
	#		v3["+" ++v3["+0"]] = "["
	#		v3["-" --v3["-0"]] = "]"
	#	} else {
	#		v3["+" ++v3["+0"]] = "{"
	#		v3["-" --v3["-0"]] = "}"
	#	}
	#	v2["dlm"] = ","
	#	for (i = 1; i <= v1[0]; i++) {
	#		v2["dlm"] = v3[v2["dlm"]]
	#		if (v3["+" v3["+0"]] == "{" && (".nx" D "." v1[i] in V || ".nx" D "." v1[i] "[0]" in V)) {
	#			v3[++v3[0]] = D "." v1[i]
	#			v1[i] = "\x22" v1[i] "\x22:<nx:placeholder index=" v3[0] "/>"
	#			v2["pl"] = 0
	#		} else if (v3["+" v3["+0"]] == "[" && (".nx" D "[" i "]." v1[i] in V || ".nx" D "[" i "]." v1[i] "[0]" in V)) {
	#			v3[++v3[0]] = D "[" i "]." v1[i]
	#			v1[i] = "<nx:placeholder index=" v3[0] "/>"
	#			v2["pl"] = 0
	#		} else if (! (nx_digit(v1[i], 1) || v1[i] ~ /^(true|false|null)$/)) {
	#			v1[i] = "\x22" v1[i] "\x22"
	#			v2["pl"] = 1
	#		} else {
	#			v2["pl"] = 1
	#		}
	#		v2["rec"] = v2["rec"] v1[i]
	#		if (i < v1[0])
	#			v2["rec"] = v2["rec"] ","
	#	}
	#	if (! (v2["pl"] && v3["+" v3["+0"]] == "{"))
	#		v2["rec"] = v3["+" v3["+0"]] v2["rec"] v3["-" v3["-0"]]
	#	if (v3[0]) {
	#		if (! v2["rrec"])
	#			v2["rrec"] = v2["rec"]
	#		else
	#			sub("<nx:placeholder index=" v2["id"] "/>", v2["rec"], v2["rrec"])
	#		v2["rec"] = ""
	#		v2["id"] = v3[0]
	#		D = v3[v3[0]]
	#	} else {
	#		sub("<nx:placeholder index=" v2["id"] "/>", v2["rec"], v2["rrec"])
	#		print v2["rrec"]
	#		break
	#	}
	#}
}

