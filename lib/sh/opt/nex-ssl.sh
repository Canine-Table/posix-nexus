

g_nx_ssl_ecparam()
{
	h_nx_cmd openssl && openssl ecparam -list_curves | ${AWK:-$(nx_cmd_awk)} '
		{
			sub(/:$/, "", $1)
			json = json ",\x22" $1 "\x22"
		} END {
			print "[" substr(json, 2) "]"
		}
	'
}

nx_ssl_ecparam()
{
	${AWK:-$(nx_cmd_awk)} -v inpt="$1" -v json="$(g_nx_ssl_ecparam)" "
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		BEGIN {
			if (! inpt)
				exit 1
			if (err = nx_json(json, opts, 2))
				exit err
			nx_json_split("", opts, kw)
			if (inpt in kw)
				err = 0
			else
				err = 2
			delete kw
			delete opts
		}
	' || {
		nx_io_printf -E "Curve '$1' not found. The cryptographic gods scoff at your offering. Consult g_nx_ssl_ecparam for the sacred list of acceptable elliptic incantations." 1>&2
		return 1
	}
	tmpa="$(nx_io_noclobber -d "$HOME" -s ".key" -p "/.nx-ssl/$(whoami)_$1")"
	openssl ecparam -name "$1" -genkey -out "$tmpa"
	echo $tmpa
	openssl req -new -key "$tmpa" -out "$(nx_io_noclobber -d "$HOME" -s ".csr" -p "/.nx-ssl/$(nx_info_path -b "$tmpa")")"
}

