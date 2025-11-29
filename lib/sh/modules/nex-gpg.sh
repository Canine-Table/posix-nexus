
nx_gpg_full()
{
        h_nx_cmd gpg || {
                nx_io_printf -E "gpg not found! The cryptographic forge is sealed—no keys shall be conjured, no secrets bound." 1>&2
                return 127
        }
        gpg --full-generate --expert
}



nx_gpg_fetch()
(
	# 1	Record type		uid This is a User ID record
	# 2	Validity		- No calculated validity (dash = unknown/undefined)
	# 3	Key length		(empty)	Not applicable for UID
	# 4	Algorithm		(empty)	Not applicable for UID
	# 5	KeyID	(empty)		Not applicable for UID
	# 6	Creation date		1190327874	Unix epoch timestamp (2007-09-20 21:57:54 UTC)
	# 7	Expiration date		(empty)	No expiration set
	# 8	UID hash		09FF7BFF13C81F1A0C2A6877511EB38E3EECF8D8	SHA-1 hash of the user ID string
	# 9	User ID signature class	(empty)	Not used here
	# 10	User ID string		Brian Behlendorf (LLNL) behlendorf1@llnl.gov>	The actual UID
	# 11	Signature class		(empty)	Reserved
	# 12	Key capabilities	(empty)	Reserved
	# 13	Key restrictions	(empty)	Reserved
	# 14	Key flags		(empty)	Reserved
	# 15	Revocation info		(empty)	Reserved
	# 16	Ownertrust		(empty)	Reserved
	# 17	Signature expiration	(empty)	Reserved
	# 18	Signature issuer	(empty)	Reserved
	# 19	Signature serial	(empty)	Reserved
	# 20	Last update		1757810965 Unix epoch timestamp (2025-10-14 01:49:25 UTC)
	# 21	Origin	1		Origin of the key (1 = keyserver)
	# 22	Comment
	nx_data_optargs 'v:l<sp>' "$@"
	case "$NEX_g_l" in
		s) NEX_g_l='--list-secret-keys';;
		*) NEX_g_l='--list-keys';;
	esac
	gpg  $NEX_g_l --with-colons | ${AWK:-$(nx_cmd_awk)} \
		-v usr="${NEX_k_v:-$NEX_S}" \
		-F ':' \
	'
		{
			str = $10
			gsub(/(^.*<)|(>.*$)/, "", str)
			if (str ~ usr)
				print $8
		}
	'
)

