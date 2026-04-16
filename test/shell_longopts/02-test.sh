

run()
{
	${AWK:-$(nx_cmd_awk)} \
		-v args="$(nx_str_chain "$@")" \
	"
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



			ps =  "<nx:null/>" # Param sep
			fs =  "=" # optional set flag sep
			fsa = "+" # optional push flag sep
			fsr = "-" # optional pop flag sep
			con = " "  # concat sep of remainder string


			seps = ks ds fas ds kas ds go ds gc ds lo ds lc
			flgs = dbg
			aseps = ps ds fs ds fsa ds fsr ds con

			nx_shell_args(args, arr, ds, flgs, aseps, seps)

		}
	'
}

			
run " hello<hi greet;hH> wazzup@;a:cd:e:f# good# bye<:done run;bB>" \
	--hi \
	-a 'aa'


