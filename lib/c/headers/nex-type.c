#include "nex-type.h"

NX_UES_CAST_IMP(db, c, DB_C)
NX_UES_CAST_IMP(db, cs, DB_CS)
NX_UES_CAST_IMP(db, cu, DB_CU)
NX_UES_IMP(db)

{
	s->type = e;
	switch (s->type) {
		case NX_DB_CST:
			s->data.NX_DB_CST = *(nx_db_pcst)d;
			break;
		case NX_DB_CUT:
			s->data.NX_DB_CUT = *(nx_db_pcut)d;
			break;
		default:
			s->type = NX_DB_CT;
			s->data.NX_DB_CT = *(nx_db_pct)d;
	}
}

NX_UES_CAST_IMP(dw, ss, DW_SS)
NX_UES_CAST_IMP(dw, su, DW_SU)
NX_UES_IMP(dw)
{
	switch (e) {
		case NX_DW_SUT:
			s->type = NX_DW_SUT;
			s->data.NX_DW_SUT = *(nx_dw_psut)d;
			break;
		default:
			s->type = NX_DW_SST;
			s->data.NX_DW_SST = *(nx_dw_psst)d;
	}
}

NX_UES_CAST_IMP(dd, is, DD_IS)
NX_UES_CAST_IMP(dd, iu, DD_IU)
NX_UES_CAST_IMP(dd, f, DD_F)

NX_UES_IMP(dd)
{
	s->type = e;
	switch (s->type) {
		case NX_DD_FT:
			s->data.NX_DD_FT = *(nx_dd_pft)d;
			break;
		case NX_DD_IUT:
			s->data.NX_DD_IUT = *(nx_dd_piut)d;
			break;
		default:
			s->type = NX_DD_IST;
			s->data.NX_DD_IST = *(nx_dd_pist)d;
	}
}

/*
NX_UES_IMP(d)
{
	switch (e) {
		case NX_DD_FT:
		case NX_DD_IUT:
		case NX_DD_IST:
			s->type = NX_DD_E;
			nx_dd_F(s->data.NX_DD_E, (nx_d_pt)&d);
			break;
		case NX_DW_SUT:
		case NX_DW_SST:
			s->type = NX_DW_E;
			nx_dw_F(s->data.NX_DW_E, d);
			break;
		default:
			s->type = NX_DB_E;
			//nx_db_F(s->data.NX_DB_E, d);
	}
}
*/
