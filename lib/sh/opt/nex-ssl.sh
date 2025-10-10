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

__nx_ssl_path()
{
	test -n "$1" || {
		nx_io_printf -E "${3:-"No file provided. The scroll cannot be read without its parchment."}" 1>&2
		return 1
	}
	test -e "$1" && printf '%s' "$1" || {
		test -e "$HOME/.nx-ssl/$1" && printf '%s' "$HOME/.nx-ssl/$1" || {
			nx_io_printf -E "${2:-"Caesar rejects '$1'—not a certificate, but a cryptographic imposter."}" 1>&2
			return 2
		}
	}
}


nx_ssl_ecparam()
(
	eval "$(nx_str_optarg ':k:o:c:b:s:t:C:E:R:' "$@")"
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
	openssl req -new -key "$key" -out "$csr" ${s:+-subj "$s"} ${R:+${C:+-config "$C" -extensions "$R"}}
	crt="$(nx_io_noclobber -s ".crt" -p "$key")"
	chn="$(nx_io_noclobber -s ".chn" -p "$key")"
	test "$c" != "" && {
		ca=$(__nx_ssl_path "$c.key.crt" "CA certificate '$ca' not found. The gods cannot sign what they do not recognize. Place your offering in ~/.nx-ssl or specify the full path.") || exit 2
		cakey=$(__nx_ssl_path "$c.key" "CA key '$cakey' not found. The signing hand is missing. Consult your secrets and place the key in ~/.nx-ssl or specify its full path.") || exit 3
		openssl x509 -req -in "$csr" -CA "$ca" -CAkey "$cakey" -CAcreateserial -days "$t" -out "$crt" ${s:+-subj "$s"} ${E:+${C:+-extfile "$C" -extensions "$E"}}
		cat "$crt" "$cakey.chn" > "$chn"
	} || {
		openssl x509 -req -in "$csr" -signkey "$key" -days "$t" -out "$crt" ${s:+-subj "$s"} ${E:+${C:+-extfile "$C" -extensions "$E"}}
		cp "$crt" "$chn"
	}
)

nx_ssl_disect()
(
	eval "$(nx_str_optarg ':f:r' "$@")"
	test -n "$r" && r='req' || r='x509'
	f="$(__nx_ssl_path "$f" "File '$f' not found. The cryptographic gods demand a valid offering.")" || exit 2
	openssl $r -in "$f" -noout -subject -issuer -dates -serial -text |
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

nx_ssl_shake()
(
	eval "$(nx_str_optarg ':f:p:h:' "$@")"
	f="$(__nx_ssl_path "$f" "Caesar rejects '$f'—not a certificate, but a cryptographic imposter.")" || exit 1
	openssl s_server -cert "$f.crt" -key "$f" -CAfile "$f.chn" -accept "${h:-0.0.0.0}:$(nx_misc_port_bind "${p:-443}")"
)

nx_ssl_connect()
(
	eval "$(nx_str_optarg ':f:p:h:' "$@")"
	f="$(__nx_ssl_path "$f" "Caesar rejects '$f'—not a certificate, but a cryptographic imposter.")" || exit 1
	openssl s_client -connect "${h:-localhost}:$(nx_misc_port_bind "${p:-443}")" -CAfile "$f"
)


nx_ssl_suspect()
(
	eval "$(nx_str_optarg ':f:s' "$@")"
	f="$(__nx_ssl_path "$f" "Caesar rejects '$f'—not a certificate, but a cryptographic imposter.")" || exit 1
	test -z "$s" && s='/dev/stdout' || s='/dev/null'
	openssl x509 -in "$f" -noout -text >$s 2>&1  || {
		nx_io_printf -E "Caesar rejects '$f'—not a certificate, but a cryptographic imposter." 1>&2
		exit 2
	}
	test "$s" = '/dev/null' && printf '%s\n' "$f"
)

nx_ssl_verify()
(
	eval "$(nx_str_optarg ':f:' "$@")"
	f="$(__nx_ssl_path "$f" "Caesar rejects '$f'—not a certificate, but a cryptographic imposter.")" || exit 1
	openssl verify -CAfile '/etc/ssl/certs/ca-certificates.crt' "$f"
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

