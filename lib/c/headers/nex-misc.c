#include <sys/resource.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include "nex-ansi.h"
#include "nex-bw.h"
#include "nex-misc.h"

void nx_createCmdList_gF()
{
	char *list[] = {
		"UID",
		"GID",
		"GIDS",
		"PID",
		"CWD",
		"HOSTNAME",
		"ENDIAN"
	};
	for (size_t i = 0; i < sizeof(list) / sizeof(list[0]); ++i)
		printf("#define NEX_%s_C 0x%x\n", list[i], nX_hashChars_h__1BF(list[i]));
}

void nX_signalHandler_g_iF(int sig)
{
	const char *snm = strsignal(sig);
	if (snm == NULL)
		snm = "UNKOWN";
	nx_ansi_alert("Caught Signal: %s (%d)\n", snm, sig);
	fflush(stdout);
	exit(0);
}

int NX_sizeofStkBuf_iF()
{
	struct rlimit limit;
	if (getrlimit(RLIMIT_STACK, &limit) == -1)
		return(4096);
	return(limit.rlim_cur);
}


void nX_shimLoop_g_iF(int size)
{
	char buffer[size];
	int ssize = NX_sizeofStkBuf_iF() / 2;
	void *stack[ssize / 8];
	ssize_t bytes;
	uint32_t hash;

	signal(SIGTERM, nX_signalHandler_g_iF);
	signal(SIGINT, nX_signalHandler_g_iF);
	signal(SIGQUIT, nX_signalHandler_g_iF);


	while (1) {
		bytes = read(STDIN_FILENO, buffer, sizeof(buffer) - 1);

		if (bytes == -1) {
			nx_ansi_error("read, (%d)", strerror(errno));
			break;
		}

		if (bytes == 0) {
			nx_ansi_info("EOF on stdin");
			break;
		}

		buffer[bytes - 1] = '\0';
		hash = nX_hashChars_h__1BF(buffer);

		switch (hash) {
			case NEX_GIDS_C:
				nx_cmdGroups_g1gF(stack);
				break;
			case NEX_HOSTNAME_C:
				nX_cmdHostname_g1g_iF(stack, ssize);
				break;
			case NEX_CWD_C:
				nX_cmdCwd_g1g_iF(stack, ssize);
				break;
			case NEX_ENDIAN_C:
				printf("%s\n", nx_dm_endian_isD == 1
					? "Big Endian"
					: "Little Endian");
				break;
			case NEX_ARCH_C:
				printf("%d\n", nx_dm_bw_isD);
				break;
			case NEX_UID_C:
				printf("%d,%d\n", (int)getuid(), (int)geteuid());
				break;
			case NEX_GID_C:
				printf("%d,%d\n", (int)getgid(), (int)getegid());
				break;
			case NEX_PID_C:
				printf("%d\n", (int)getpid());
				break;
			default:
				nx_ansi_error("Input %s is not 0x%x an option\n", buffer, hash);
				break;
		}
	}
}


void nX_cmdCwd_g1g_iF(void *stack, unsigned int n)
{
	char *cwd = (char*)stack;
	if (getcwd(cwd, n) != NULL)
		printf("%s\n", cwd);
}


void nX_cmdHostname_g1g_iF(void *stack, unsigned int n)
{
	char *hostname = (char*)stack;
	if (gethostname(hostname, n) != -1)
		printf("%s\n", hostname);
}

int NX_sizeofGetGroups_iF()
{
	int ngroups = getgroups(0, NULL);
	if (ngroups > 0)
		return ngroups;
	return 0;
}

int nX_getGroups_ii_1uF(int ngroups, gid_t *groups)
{
	if (ngroups == 0)
		return(-1);
	getgroups(ngroups, groups);
	return(0);
}

void nx_cmdGroups_g1gF(void *stack)
{
	gid_t *groups = (gid_t*)stack;
	int ngroups = NX_sizeofGetGroups_iF();
	if (nX_getGroups_ii_1uF(ngroups, groups) == 0) {
		for (int i = 1; i < ngroups; ++i)
			printf("%d,", groups[i]);
		printf("%d\n", groups[0]);
	}
}

