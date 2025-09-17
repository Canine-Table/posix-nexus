

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
(
	eval "$(nx_str_optarg ':k:o:c:b:s:t:' "$@")"
	${AWK:-$(nx_cmd_awk)} -v inpt="$k" -v json="$(g_nx_ssl_ecparam)" "
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
		nx_io_printf -E "Curve '$k' not found. The cryptographic gods scoff at your offering. Consult g_nx_ssl_ecparam for the sacred list of acceptable elliptic incantations." 1>&2
		return 1
	}
	t="$(nx_int_natural "$t")"
	test -z "$t" && {
		t="18250"
		nx_io_printf -I "No time specified. Defaulting to 18250 days—an epoch worthy of trust." 
	}
	o="${o:-$HOME/.nx-ssl/${b:-$(whoami)_$k}}"
	key="$(nx_io_noclobber -s ".key" -p "$o")"
	openssl ecparam -name "$k" -genkey -out "$key"
	csr="$(nx_io_noclobber -s ".csr" -p "$key")"
	openssl req -new -key "$key" -out "$csr" ${s:+-subj "$s"}
	crt="$(nx_io_noclobber -s ".crt" -p "$key")"
	chn="$(nx_io_noclobber -s ".chn" -p "$key")"
	test "$c" != "" && {
		ca="$c.key.crt"
		test -e "$ca" || {
			ca="$HOME/.nx-ssl/$ca"
			test -e "$ca" || {
				nx_io_printf -E "CA certificate '$ca' not found. The gods cannot sign what they do not recognize. Place your offering in ~/.nx-ssl or specify the full path." 1>&2
				exit 2
			}
		}
		cakey="$c.key"
		test -e "$cakey" || {
			cakey="$HOME/.nx-ssl/$cakey"
			test -e "$cakey" || {
				nx_io_printf -E "CA key '$cakey' not found. The signing hand is missing. Consult your secrets and place the key in ~/.nx-ssl or specify its full path." 1>&2
				exit 3
			}
		}
		openssl x509 -req -in "$csr" -CA "$ca" -CAkey "$cakey" -CAcreateserial -days "$t" -out "$crt"
		cat "$crt" "$cakey.chn" > "$chn"
	} || {
		openssl x509 -req -in "$csr" -signkey "$key" -days "$t" -out "$crt"
		cp "$crt" "$chn"
	}
)

nx_ssl_disect()
(
	eval "$(nx_str_optarg ':f:' "$@")"
	test -n "$f" || {
		nx_io_printf -E "No file provided. The scroll cannot be read without its parchment." 1>&2
		return 1
	}
	test -e "$f" || {
		f="$HOME/.nx-ssl/$f"
		test -e "$f" || {
			nx_io_printf -E "File '$f' not found. The cryptographic gods demand a valid offering." 1>&2
			return 2
		}
	}

	openssl x509 -in "$f" -noout -subject -issuer -dates -serial -text |
	${AWK:-$(nx_cmd_awk)} -v file="$f" '
		BEGIN { print " Dissecting certificate: " file }
		/^subject=/ {
			sub(/^subject= ?/, "", $0)
			print " Subject: " $0
		}
		/^issuer=/ {
			sub(/^issuer= ?/, "", $0)
			print " Issuer: " $0
		}
		/^notBefore=/ {
			print " Valid from: " $0
		}
		/^notAfter=/ {
			print " Valid until: " $0
		}
		/^serial=/ {
			print " Serial: " $0
		}
		/^X509v3 Basic Constraints:/ {
			in_constraints = 1
		}
		in_constraints && /CA:/ {
			if ($0 ~ /TRUE/)
				s = "Certificate Authority" 
			else
				s = "Leaf"
			print " Role: " s
			in_constraints = 0
		}
	'
)



nx_ssl_suspect()
(
	eval "$(nx_str_optarg ':f:s' "$@")"
	test -z "$s" && s='/dev/stdout' || s='/dev/null'
	test -e "$f" || {
		f="$HOME/.nx-ssl/$f"
		test -e "$f" || {
			nx_io_printf -E "Caesar rejects '$f'—not a certificate, but a cryptographic imposter." 1>&2
			exit 1
		}
	}
	openssl x509 -in "$f" -noout -text >$s 2>&1  || {
		nx_io_printf -E "Caesar rejects '$f'—not a certificate, but a cryptographic imposter." 1>&2
		exit 2
	}
	test "$s" = '/dev/null' && printf '%s\n' "$f"
)

nx_ssl_trust()
(
	f="$(nx_ssl_suspect -f "$1" -s)"
	test -n "$f" || return
	if h_nx_cmd trust; then
		mkdir -p '/etc/ca-certificates/trust-source/anchors'
		cp "$f" '/etc/ca-certificates/trust-source/anchors'
		trust extract-compat
	elif h_nx_cmd update-ca-certificates; then
		cp "$f" '/usr/local/share/ca-certificates'
		update-ca-certificates
	elif h_nx_cmd update-ca-trust; then
		cp "$f" '/etc/pki/ca-trust/source/anchors'
		update-ca-trust extract
	fi
)

