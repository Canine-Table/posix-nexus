#ifndef nX_Dm_define_H
#define nX_Dm_define_H

typedef char nx_d_cT;
typedef const char nx_D_cT;
typedef unsigned char nx_d_iuT;
typedef signed char nx_d_isT;

typedef union {
	nx_d_cT c;
	nx_d_iuT uc;
	nx_d_isT sc;
} nx_d_cU;

typedef unsigned long nx_d_luT;
typedef signed long nx_d_lsT;
typedef double nx_d_dT;

typedef union {
	nx_d_luT lu;
	nx_d_lsT ls;
} nx_d_lU;

typedef union {
	nx_d_luT lu;
	nx_d_lsT ls;
	nx_d_dT d;
} nx_d_64U;

typedef unsigned int nx_d_iuT;
typedef signed int nx_d_isT;
typedef float nx_d_fT;

typedef nx_d_cU nX256_d_cU[256];

typedef struct {
	nX256_d_cU cur;
	struct nX256_d_cS *prev;
	struct nX256_d_cS *next;
} nX256_d_cS;

#endif
