#nx_include nex-data.sh

nx_misc_shift()
{
	${AWK:-$(nx_cmd_awk)} \
		-v st="$1" \
		-v ed="${2:-<nx:null/>}" \
		-v shft="$(nx_data_ref ${3:-nx_shft})" \
	'
		BEGIN {
			shft = int(shft)
			if (st != int(st) || (st = int(st)) <= 0)
				exit 0
			if (ed != "<nx:null/>" && ed == int(ed)) {
				ed = int(ed)
				if (ed > 0 && ed < 256 - shft && ed < st)
					exit ed + shft
			}
			if (st < 256 - shft)
				exit st + shft
		}
	' || {
		eval "${3:-nx_shft}=$?"
		return
	}
	return 1
}

