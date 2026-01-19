
# ' e&enable<y&yes no&n>;a&A@b&B:

# variable output construct
#	NEX_[g]{
#		':' | k
#		''  | f
#		'#' | K
#		'@' | F
#	}_[param]
#
#	NEX_gf_e
#	NEX_F_a
#	NEX_k_b
#
#	--yes ->	NEX_gf_e='y'
#	-n ->		NEX_gf_e='no'

#	-A a -a b -A c ->		NEX_K_a='a<nx:null/>b<nx:null/>c'
#	-B a -b b -B c ->		NEX_F_b='B<nx:null/>a<nx:null/>b<nx:null/>b<nx:null/>B<nx:null/>c'


${AWK:-$(nx_cmd_awk)} "
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-sh-extras.awk")
"'

	BEGIN {
		str = " alpha&al<beta&b gamma&g>; delta&d<@epsilon&e zeta&z theta&t iota&I>; kappa&k lambda&L;mu&M nu&N@xi&x omicron&O#pi&P:rho&R;sigma&S tau&T;upsilon&U@phi&F chi&C#psi&P omega&W;"
		#str = "alphaal<betab gammag>;#deltad<@epsilone zetaz#thetat:iotaI>;kappak lambdaL;muM nuN@xix omicronO#piP:rhoR;sigmaS tauT;upsilonU@phiF chiC#psiP omegaW;"
		#nx_sh_stride(str, "<", ">", "&")
		#nx_lsh_optargs(str "<nx:null/>abcd",5)
		#nx_lsh_optargs("f<abcdef>g<:iijkg>l<#mno>Qrsp<@qr>s<nx:null/>abcd", 4)
		nx_lsh_optargs(str "<nx:null/>abcd", 4)
	}
'

