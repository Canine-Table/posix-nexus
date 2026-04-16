

# ' alpha<beta gamma> delta<epsilon zeta>'
#
# --beta --gamma --alpha --gamma --beta --epsilon --gamma --zeta --delta --zeta
#
# NEX_gf_alpha => group 1 index, group 1 index + stride == beta<nx:null/>gamma
# group1 index => group 2 index, group 2 index + stride == gamma<nx:null/>beta<nx:null/>gamma
# NEX_gf_delta => group 1 index, group 1 index + stride == epsilon<nx:null/>zeta
# NEX_gf_delta => group 2 index, group 2 index + stride == zeta

${AWK:-$(nx_cmd_awk)} "
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-sh-extras.awk")
"'
	BEGIN {
		nx_lsh_optargs("y&Y n&No&Not:<nx:null/>-a<nx:null/>-y<nx:null/>-Y<nx:null/>--Not<nx:null/>hello",4, "<nx:null/>", ",")
	}
'

