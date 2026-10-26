#ifndef NEX_misc_H
#define NEX_misc_H

#include <stdlib.h>

#define NEX_UID_C 0xb87ea9d
#define NEX_GID_C 0xb87bf8f
#define NEX_GIDS_C 0x7c7fb13c
#define NEX_PID_C 0xb881018
#define NEX_CWD_C 0xb87d155
#define NEX_HOSTNAME_C 0x90cd15c2
#define NEX_ENDIAN_C 0x8dd0294c

#define NEX_ARCH_C 0x7c7ecf1d



void nx_cmdGroups_g1gF(void*);
int nX_getGroups_ii_1uF(int, gid_t*);
int NX_sizeofGetGroups_iF();
int NX_sizeofStkBuf_iF();
void nX_signalHandler_g_iF(int sig);
void nx_createCmdList_gF();
void nX_shimLoop_g_iF(int);
void nx_cmdHostname_g1gF(void*);
int NX_sizeofGetGroups_iF();
void nX_cmdHostname_g1g_iF(void*, unsigned int);
void nX_cmdCwd_g1g_iF(void*, unsigned int);

#endif

