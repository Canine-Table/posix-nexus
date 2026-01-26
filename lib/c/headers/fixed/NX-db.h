#ifndef NX_db_H
#define NX_db_H

typedef struct {
	unsigned char h;
	unsigned char l;
} NX_wbbS;


typedef struct {
	NX_dwwS h;
	NX_dwwS l;
} NX_addS;

typedef struct {
	NX_addS h;
	NX_addS l;
} NX_oaaS;

typedef struct {
	NX_oaaS h;
	NX_oaaS l;
} NX_hooS;

typedef struct {
	NX_hooS h;
	NX_hooS l;
} NX_shhS;

typedef struct {
	NX_shhS h;
	NX_shhS l;
} NX_pssS;

typedef struct {
	NX_pssS h;
	NX_pssS l;
} NX_xppS;

unsigned char NX_set_b1wBBF(NX_wbbS*, const unsigned char, const unsigned char);
unsigned char NX_set_b1wVF(NX_wbbS*, const unsigned short);
unsigned char NX_add_b1w1W1WF(NX_wbbS*, const NX_wbbS*, const NX_wbbS*);
unsigned char NX_sub_b1w1W1WF(NX_wbbS*, const NX_wbbS*, const NX_wbbS*);
unsigned char NX_satAdd_b1w1W1WF(NX_wbbS*, const NX_wbbS*, const NX_wbbS*);
unsigned char NX_satSub_b1w1W1WF(NX_wbbS*, const NX_wbbS*, const NX_wbbS*);
unsigned char NX_mul_b1w1W1WF(NX_wbbS*, const NX_wbbS*, const NX_wbbS*);
unsigned char NX_div_b1w1W1WF(NX_wbbS*, const NX_wbbS*, const NX_wbbS*);
unsigned char NX_min_b1w1W1WF(NX_wbbS*, const NX_wbbS*, const NX_wbbS*);
unsigned char NX_max_b1w1W1WF(NX_wbbS*, const NX_wbbS*, const NX_wbbS*);
unsigned char NX_clamp_b1w1W1W1WF(NX_wbbS*, const NX_wbbS*, const NX_wbbS*, const NX_wbbS*);
unsigned char NX_zero_b1wF(NX_wbbS *);
unsigned char NX_swap_b1w1wF(NX_wbbS*, NX_wbbS*);
unsigned char NX_dec_b1w1WF(NX_wbbS*, const NX_wbbS*);
unsigned char NX_inc_b1w1WF(NX_wbbS*, const NX_wbbS*);
unsigned char NX_cmp_b1W1WF(const NX_wbbS*, const NX_wbbS*);
unsigned short NX_get_vBBF(const unsigned char, const unsigned char);
unsigned short NX_get_v1WF(const NX_wbbS*);

#endif

