(
	nx_data_longopt -g='>'  -G='}' -k='*'  -K='+' -F='/' -l=' ' -s='!'  -v=4 ' 
		pi!PI alpha>+alpha:ON alpha:ON-OFF
			alpha:OFF-ON alpha:OFFL}beta:TF/theta:F+gamma:T*' \
		--alpha:ON+=hello --beta:TF --gamma:T hi  --alpha:OFF+=yes --alpha:OFF+=yes --theta:F truth --pi -P -I
	i=1
	while test "$i" -le "$NEX_ARGC"; do
		k="$(nx_data_ref "NEX_ARGV_$i")"
		echo "$i => $k => $(nx_data_ref "$k")"
		i=$((i+1))
	done
)

