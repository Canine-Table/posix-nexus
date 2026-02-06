
nx_gpg_full()
{
	h_nx_cmd gpg || {
		nx_io_printf -E "gpg not found! The cryptographic forge is sealed—no keys shall be conjured, no secrets bound." 1>&2
		return 192
	}
	gpg --full-generate --expert
}


#nx_gpg_get()
#(
	#nx_data_optargs 's:u' "$@"
	#test "$NEX_f_s" = '<nx:true/>' && NEX_f_s='-secret' || NEX_f_s=''
	
	#echo "$NEX_f_s"
	#gpg \
	#	--list-keys \
	#	--with-subkey-fingerprints \
	#	--with-keygrip \
	#	--with-colons \
	#	"$u"
#)
