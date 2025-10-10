
__h_nx_nft()
{
	h_nx_cmd nft || {
		nx_io_printf -W "nft not found! The netfilter gate is sealed—no rules may be cast, no chains may form." 1>&2
		return 1
	}
}

nx_nft_jtree()
(
	__h_nx_nft || exit
	eval "$(nx_str_optarg ':r:j:n:' "$@")"
	nx_data_jtree ${r:+-r "$r"} ${n:+-n "$n"} -j "$(nft --json --handle list ruleset)"
)

nx_nft_jdump()
{
	nx_data_jdump "$(nx_nft_jtree $@)"
}

