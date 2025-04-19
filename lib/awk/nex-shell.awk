
function nx_parser(D, S,	i, l, p, s, toks, opts, v1, v2)
{
	if (l = split(D, toks, S)) {
		__nx_quote_map(v2)
		 l = length(toks[1])
		for (i = 1; i <= l; i++) {
			if ((s = substr(toks[1], i, 1)) in v2) {
				#print toks[1]
				print "a"
				#p = nx_next_pair(toks[1], v1, v2)
				#print substr(toks[1], 1, v1[p])
				#for (i in v1)
				#	print i
			} #else {
			print s
			#	#print s
				#opts[++opts[0]] = s
			#}
		}
	}
	delete toks
}
