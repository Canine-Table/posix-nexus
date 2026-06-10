

pth='hello/{world,{greet,meet,seek,heat}ings}leaf '
# .0 = 1
# .1 = hello/
# .1.0 = 1
# .1.1 = hello/world
# .1.1.. = .1
# .1.1. = .1.1
# .1.1.0 = 4
# .1.1.1 = hello/greet
# .1.1.2 = hello/meet
# .1.1.3 = hello/meet
# .1.1.4 = hello/meet
#


awk -v ex="$pth" '
BEGIN {
	l = split(ex, V1, "")

	ste = 0
	for (i = 1; i <= l; ++i) {
		cr = V1[i]

		} if (cr == ",") {
			if (ste == 3) {

			} else {
				t_rt = rt "" cnt "."
				t_l = V2[t_rt "0"]
				do {
					for (j = 1; j <= t_l; ++j) {
						V2[t_rt j] = V2[t_rt j] acm
						if (t_rt j ".0" in V2) {
							stk[++dth] = j
							t_rt = t_rt j "."
							j = 0
							t_l = V2[t_rt "0"]
						}
					}
					t_rt = V2[t_rt]
					j = stk[--dth]
				} while (dth > 0)
				dbol = 0
			}
			ste = 1
		} else if (cr == "{") {
			if (ste == 1) {
				V2[rt "" ++cnt] = V2[V2[rt]]
			}
			V2[rt "" ++cnt] = V2[V2[rt]] acm
			nrt = rt "" cnt
			V2[rt "0"] = cnt
			V2[nrt ".."] = rt
			V2[nrt "."] = nrt
			rt = nrt "."
			cnt = 0
			ste = 2
		} else if (cr == "}") {
			if (ste == 1) {

			}
			ste = 3
		} else {
			acm = acm cr
		}
	}
}'


##
##	do {
##		while ((getline ln < rpl) > 0) {
##			if (ln ~ D2 && match(ln, D3)) {
##				cr = substr(ln, 1, RSTART - 1)
##				ln = substr(ln, RSTART + RLENGTH)
##				if (match(ln, /^[^ \t]+/)) {
##					nr = substr(ln, RSTART, RLENGTH)
##					ln = substr(ln, RSTART + RLENGTH)
##					D1 = nx_file_store(fls, nr, drp, stre, flsp, mth, gtln, exts)
##					if (D1 > -1)
##						drp = fls[fls[2]]
##					if (D1 == 1) {
##						stk[rt "" ++cnt] = cr
##						D1 = fls[fls[1]]
##						trk[++nxt] = D1
##						trk[D1] = rt "" ++cnt "."
##						if (ln !~ /^[ \t]*$/)
##							stk[rt "" ++cnt] = ln "\n"
##					} else {
##						# directive match, but either the arg was not a file or its already been passed
##						# add the line without the directive
##						stk[rt "" ++cnt] = cr "\n"
##					}
##				} else if (cr !~ /^[ \t]*$/) {
##					# directive match, but no file provided, add the cr
##					stk[rt "" ++cnt] = cr "\n"
##				}
##			} else if (ln !~ /^[ \t]*$/) {
##				stk[rt "" ++cnt] = ln "\n"
##			}
##		}
##		close(rpl)
##		stk[rt "0"] = cnt
##		cnt = 0
##		rpl = trk[nxt]
##		rt = trk[rpl]
##	} while (nxt-- > 0)
#
#	sbo = "["
#	sbc = "]"
#	sqo = "{"
#	sqc = "}"
#	sp = ","
#
#	l = split(pth, V1, "")
#	rt = "."
#	nrt = "."
#	cnt = 0
#
#	for (i = 1; i <= l; ++i) {
#		cr = V1[i]
#
#		bol = cr == sqo
#		ibol = i == l
#		sbol = cr == sp
#		if (sbol || ibol || bol) {
#
#			if (cr = sp) {
#				dbol = 2
#			}
#
#			if (acm) {
#				if (dbol == 1) {
#					trt = rt "" cnt "."
#					lj = V2[trt "0"]
#					do {
#						for (j = 1; j <= lj; ++j) {
#							V2[trt j] = V2[trt j] acm
#							if (trt j ".0" in V2) {
#								stk[++dth] = j
#								trt = trt j "."
#								j = 0
#								lj = V2[trt "0"]
#							}
#						}
#						trt = V2[trt]
#						j = stk[--dth]
#					} while (dth > 0)
#					dbol = 0
#				} else {
#					V2[rt "" ++cnt] = V2[V2[rt]] acm
#				}
#			}
#
#			if (bol) {
#				if (!acm)
#					V2[rt "" ++cnt] = V2[V2[rt]]
#				nrt = rt "" cnt
#				V2[rt "0"] = cnt
#				V2[nrt ".."] = rt
#				V2[nrt "."] = nrt
#				rt = nrt "."
#				cnt = 0
#			}
#			acm = ""
#		} else if (cr == sqc) {
#			if (acm == "ings")
#				print rt " aaaha"
#
#			if (cr = sp) {
#				dbol = 0
#			}
#			#if (dbol == 2) {
#				trt = rt "" cnt "."
#				lj = V2[trt "0"]
#				do {
#					for (j = 1; j <= lj; ++j) {
#						V2[trt j] = V2[trt j] acm
#						if (trt j ".0" in V2) {
#							stk[++dth] = j
#							trt = trt j "."
#							j = 0
#							lj = V2[trt "0"]
#						}
#					}
#					trt = V2[trt]
#					j = stk[--dth]
#				} while (dth > 0)
#				dbol = 0
#			#}
#
#
#
#			V2[rt "" ++cnt] = acm
#
#			V2[rt "0"] = cnt
#			rt = V2[rt "."]
#			cnt = V2[rt "0"]
#			dbol = 1
#			acm = ""
#		} else {
#			acm = acm cr
#		}
#
#		V2[rt "0"] =  cnt
#	}
#
#	for (i in V2)
#		print i " = " V2[i]
#}
#'
#
#
