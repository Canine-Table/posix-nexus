${AWK:-$(nx_cmd_awk)} "
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-shell.awk")
"'
	BEGIN {
		ds = ","  # Define default delimiters
		ks = ":"  # key sep
		fas = "@" # appendable arr sep
		kas = "#" # appendable kwds sep
		go = "<"  # begin group
		gc = ">"  # eng group
		lo = " "  # begin or continue long option mode
		lc = ";"  # end long option mode

		dbg = 4

		seps = ks ds fas ds kas ds go ds gc ds lo ds lc
		flgs = dbg
		str = " hello<hi greet;hH> wazzup@;a:cd:e:f# good# bye<:done run;bB>"

		nx_shell_opts(str, arr, ds, flgs, seps)
	}
'

