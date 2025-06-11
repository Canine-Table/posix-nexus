#ifndef NX_TYPE_H
#define NX_TYPE_H

/*
	nx_<size>[_<module>]_[<ptr>]<type>[<signed>|<unsigned>]<modifier>

	size:
		d = void
		db = defined byte (8 bits)
		dw = defined word (16 bits)
		dd = defined double word (32 bits)
		dq = defined quadword (64 bits)
		do = defined octword (128 bits)

	type:
		u = unsigned
		s = signed
		b = bool
		c = char
		s = short
		i = int
		l = long
		d = double
		f = float
		p = pointer
		P = const pointer
		t = typedef
		T = const typedef
		E = enum
		U = union
		S = struct
		F = function
*/

#define NX_CONST_PTR_ONE(D1, D2, D3) \
	typedef const D1 *nx_##D2##_P##D3##t; \
	typedef D1 *const nx_##D2##_p##D3##T; \
	typedef const D1 *const nx_##D2##_P##D3##T;
#define NX_PTR_ONE(D1, D2, D3) \
	typedef D1 *nx_##D2##_p##D3##t;
#define NX_CONST_PTR_ONE_DEF(D1, D2, D3) NX_CONST_PTR_ONE(D1, D2, D3)
#define NX_PTR_ONE_DEF(D1, D2, D3) NX_PTR_ONE(D1, D2, D3)
#define NX_PTRS_ONE_DEF(D1, D2, D3) \
	NX_CONST_PTR_ONE_DEF(D1, D2, D3) \
	NX_PTR_ONE_DEF(D1, D2, D3)

#define NX_CONST_PTR_TWO(D1, D2, D3) \
	typedef const D1 **nx_##D2##_Pp##D3##t; \
	typedef D1 *const *nx_##D2##_pP##D3##t; \
	typedef D1 **const nx_##D2##_pp##D3##T; \
	typedef const D1 *const *nx_##D2##_PP##D3##t; \
	typedef const D1 **const nx_##D2##_Pp##D3##T; \
	typedef const D1 *const *const nx_##D2##_PP##D3##T;
#define NX_PTR_TWO(D1, D2, D3) \
	typedef D1 **nx_##D2##_pp##D3##t;
#define NX_PTR_TWO_DEF(D1, D2, D3) \
	NX_PTR_ONE_DEF(D1, D2, D3) \
	NX_PTR_TWO(D1, D2, D3)
#define NX_CONST_PTR_TWO_DEF(D1, D2, D3) \
	NX_CONST_PTR_ONE_DEF(D1, D2, D3) \
	NX_CONST_PTR_TWO(D1, D2, D3)
#define NX_PTRS_TWO_DEF(D1, D2, D3) \
	NX_PTR_TWO_DEF(D1, D2, D3) \
	NX_CONST_PTR_TWO_DEF(D1, D2, D3)

#define NX_CONST_PTR_THREE(D1, D2, D3) \
    typedef D1 ***nx_##D2##_ppp##D3##t; \
    typedef const D1 ***nx_##D2##_Ppp##D3##t; \
    typedef D1 *const **nx_##D2##_pPp##D3##t; \
    typedef D1 **const *nx_##D2##_ppP##D3##t; \
    typedef D1 ***const nx_##D2##_ppp##D3##T; \
    typedef const D1 *const **nx_##D2##_PPp##D3##t; \
    typedef const D1 **const *nx_##D2##_PpP##D3##t; \
    typedef const D1 ***const nx_##D2##_Ppp##D3##T; \
    typedef D1 **const **nx_##D2##_pPp##D3##T; \
    typedef D1 *const *const *nx_##D2##_pPP##D3##T; \
    typedef D1 **const *const nx_##D2##_ppP##D3##T; \
    typedef const D1 *const *const *nx_##D2##_PPP##D3##T;
#define NX_PTR_THREE(D1, D2, D3) \
	typedef D1 ***nx_##D2##_ppp##D3##t;
#define NX_PTR_THREE_DEF(D1, D2, D3) \
	NX_PTR_TWO_DEF(D1, D2, D3) \
	NX_PTR_THREE(D1, D2, D3)
#define NX_CONST_PTR_THREE_DEF(D1, D2, D3) \
	NX_CONST_PTR_TWO_DEF(D1, D2, D3) \
	NX_CONST_PTR_THREE(D1, D2, D3)
#define NX_PTRS_THREE_DEF(D1, D2, D3) \
	NX_PTR_THREE_DEF(D1, D2, D3) \
	NX_CONST_PTR_THREE_DEF(D1, D2, D3)

#define NX_AUTO_TYPE(D1, D2, D3) \
	typedef D1 nx_##D2##_##D3##t; \
	NX_PTR_THREE_DEF(D1, D2, D3)
#define NX_CONST_AUTO_TYPE(D1, D2, D3) \
	typedef const D1 nx_##D2##_##D3##T; \
	NX_CONST_PTR_THREE_DEF(D1, D2, D3)
#define NX_AUTO_TYPE_DEF(D1, D2, D3) \
	NX_CONST_AUTO_TYPE(D1, D2, D3) \
	NX_AUTO_TYPE(D1, D2, D3)

#define NX_UNSIGNED_TYPE(D1, D2, D3) \
	typedef unsigned D1 nx_##D2##_##D3##ut; \
	NX_PTR_THREE_DEF(unsigned D1, D2, D3##u)
#define NX_CONST_UNSIGNED_TYPE(D1, D2, D3) \
	typedef const unsigned D1 nx_##D2##_##D3##uT; \
	NX_CONST_PTR_THREE_DEF(unsigned D1, D2, D3##u)
#define NX_UNSIGNED_TYPE_DEF(D1, D2, D3) \
	NX_CONST_UNSIGNED_TYPE(D1, D2, D3) \
	NX_UNSIGNED_TYPE(D1, D2, D3) \

#define NX_SIGNED_TYPE(D1, D2, D3) \
	typedef signed D1 nx_##D2##_##D3##st; \
	NX_PTR_THREE_DEF(signed D1, D2, D3##s)
#define NX_CONST_SIGNED_TYPE(D1, D2, D3) \
	typedef const signed D1 nx_##D2##_##D3##sT; \
	NX_CONST_PTR_THREE_DEF(signed D1, D2, D3##s)
#define NX_SIGNED_TYPE_DEF(D1, D2, D3) \
	NX_CONST_SIGNED_TYPE(D1, D2, D3) \
	NX_SIGNED_TYPE(D1, D2, D3) \

#define NX_SIGNED_UNSIGNED_TYPE(D1, D2, D3) \
	NX_SIGNED_TYPE(D1, D2, D3) \
	NX_UNSIGNED_TYPE(D1, D2, D3)
#define NX_CONST_SIGNED_UNSIGNED_TYPE(D1, D2, D3) \
	NX_CONST_SIGNED_TYPE(D1, D2, D3) \
	NX_CONST_UNSIGNED_TYPE(D1, D2, D3)
#define NX_SIGNED_UNSIGNED_TYPE_DEF(D1, D2, D3) \
	NX_CONST_SIGNED_UNSIGNED_TYPE(D1, D2, D3) \
	NX_SIGNED_UNSIGNED_TYPE(D1, D2, D3)

#define NX_ALL_TYPE(D1, D2, D3) \
	NX_SIGNED_UNSIGNED_TYPE(D1, D2, D3) \
	NX_AUTO_TYPE(D1, D2, D3)
#define NX_CONST_ALL_TYPE(D1, D2, D3) \
	NX_CONST_SIGNED_UNSIGNED_TYPE(D1, D2, D3) \
	NX_CONST_AUTO_TYPE(D1, D2, D3)
#define NX_ALL_TYPE_DEF(D1, D2, D3) \
	NX_ALL_TYPE(D1, D2, D3) \
	NX_CONST_ALL_TYPE(D1, D2, D3)

NX_AUTO_TYPE(void, d, /**/)
NX_ALL_TYPE_DEF(char, db, c)
NX_SIGNED_UNSIGNED_TYPE_DEF(short, dw, s)
NX_AUTO_TYPE_DEF(float, dd, f)
NX_SIGNED_UNSIGNED_TYPE_DEF(int, dd, i)

typedef union {
	nx_db_ct NX_DB_CT;
	nx_db_cut NX_DB_CUT;
	nx_db_cst NX_DB_CST;
} nx_db_U;

typedef enum {
	NX_DB_CT, NX_DB_CUT, NX_DB_CST, NX_DB_NT
} nx_db_E;

typedef union {
	nx_dw_sut NX_DW_SUT;
	nx_dw_sst NX_DW_SST;
} nx_dw_U;

typedef enum {
	NX_DW_SUT, NX_DW_SST, NX_DW_NT
} nx_dw_E;

typedef union {
	nx_dd_ist NX_DD_IST;
	nx_dd_iut NX_DD_IUT;
	nx_dd_ft NX_DD_FT;
} nx_dd_U;

typedef enum {
	NX_DD_IUT, NX_DD_IST, NX_DD_FT, NX_DD_NT
} nx_dd_E;

#define NX_FUNC(D1, D2, D3, D4) nx_##D1##_##D2##D4 nx_##D1##D3##_##D2##F
#define NX_D_FUNC(D1, D2, D3, D4) nx_d_##D4##t nx_##D1##D3##_##D2##F
#define NX_FUNC_STRUCT_RET(D1, D2, D3) NX_FUNC(D1, D2, D3, S)
#define NX_FUNC_TYPEDEF_RET(D1, D2, D3) NX_FUNC(D1, D2, D3, t)

#define NX_UES_DEF(D) \
	typedef struct { \
		nx_##D##_E type; \
		nx_##D##_U data; \
	} nx_##D##_S; \
	typedef nx_##D##_S *nx_##D##_pS; \
	NX_UES_IMP(D);
#define NX_UES_IMP(D) NX_D_FUNC(D, /**/, /**/, /**/)(nx_##D##_pS s, nx_##D##_E e, nx_d_pt d)

#define NX_UES_CAST_DEF(D1, D2) NX_FUNC_TYPEDEF_RET(D1, D2, /**/)(nx_##D1##_pS s, nx_##D1##_##D2##t d)
#define NX_UES_CAST_IMP(D1, D2, D3) NX_UES_CAST_DEF(D1, D2) \
{ \
	nx_##D1##_##D2##t t = d; \
	nx_##D1##_F(s, NX_##D3##T, (nx_d_pt)&t); \
	return t; \
}

NX_UES_DEF(db)
NX_UES_CAST_DEF(db, c);
NX_UES_CAST_DEF(db, cs);
NX_UES_CAST_DEF(db, cu);

NX_UES_DEF(dw)
NX_UES_CAST_DEF(dw, ss);
NX_UES_CAST_DEF(dw, su);

NX_UES_DEF(dd)
NX_UES_CAST_DEF(dd, is);
NX_UES_CAST_DEF(dd, iu);
NX_UES_CAST_DEF(dd, f);

typedef union {
	nx_db_S NX_DB_E;
	nx_dw_S NX_DW_E;
	nx_dd_S NX_DD_E;
} nx_d_U;

typedef enum {
	NX_DB_E, NX_DW_E, NX_DD_E, NX_D_E
} nx_d_E;


//NX_UES_DEF(d)
//nx_d_t nx_d_F(nx_d_pS, nx_db_Pct);

#endif
