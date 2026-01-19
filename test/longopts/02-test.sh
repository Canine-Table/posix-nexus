

# ' alpha<beta gamma> delta<epsilon zeta>'
#
# --beta --gamma --alpha --gamma --beta --epsilon --gamma --zeta --delta --zeta
#
# NEX_gf_alpha => group 1 index, group 1 index + stride == beta<nx:null/>gamma
# group1 index => group 2 index, group 2 index + stride == gamma<nx:null/>beta<nx:null/>gamma
# NEX_gf_delta => group 1 index, group 1 index + stride == epsilon<nx:null/>zeta
# NEX_gf_delta => group 2 index, group 2 index + stride == zeta

${AWK:-$(nx_cmd_awk)} "
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-sh-extras.awk")
"'
	# ps = "<nx:null/>"
	# ds = ","
	# ks = __nx_else(trk[1], ":") # key sep
	# als = __nx_else(trk[2], "&") # alias / altname of option
	# fas = __nx_else(trk[3], "@") # appendable arr sep
	# kas = __nx_else(trk[4], "#") # appendable kwds sep
	# go = __nx_else(trk[5], "<") # begin group
	# gc = __nx_else(trk[6], ">") # eng group
	# lo = __nx_else(trk[7], " ") # begin or continue long option mode
	# lc = __nx_else(trk[8], ";") # end long option mode
	# fs = __nx_else(trk[9], "=") # optional set flag sep
	# fsa = __nx_else(trk[10], "+") # optional push flag sep
	# fsr = __nx_else(trk[11], "-") # optional pop flag sep
	
	BEGIN {
		ks = ":"
		als = "&"
		fas = "@"
		kas = "#"
		go = "<"
		gc = ">"
		lo = " "
		lc = ";"
		fs = "="
		fsa = "+"
		fsr = "-"
		ps = "<nx:null/>"
		ds = ","
		sepa = ks ds als ds fas ds kas ds go ds gc ds lo ds lc
		sepb = ps ds fs ds fsa ds fsr
		vrbos = 4
		str = "y" als "Y n" als "No" als "Not" als "no" ks "o" als "O" als "ok" ps "-y" ps "-Y" ps "--Not" ps "hello" ps "-o" ps "--ok"
		nx_lsh_optargs(str, vrbos, arr, sepb, ds, sepa)
		delete arr
	}
'
