#include "intro.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

int nx_mem_chk(void *p)
{
	if (p == NULL) {
		fprintf(stderr, "Memory allocation failed!\n");
		return -1;  /* Return an error indicator */
	}
	return 0;  /* Memory allocation was successful */
}

int nx_wasteful_alloc(int num)
{
	if (num < 0)
		return(-1);
	/* Allocate memory using malloc */
	int *p_num = (int*)malloc(num * sizeof(int));
	if (nx_mem_chk(p_num) == -1) /* Handle memory allocation failure here */
		return(-1);

	int i = 0; /* Initialize values */

	int *c_num = (int*)calloc(num, sizeof(int)); // Allocates and initializes to 0
	if ((i = nx_mem_chk(c_num)) == -1) /* Handle memory allocation failure here */
		goto malloc_cleanup;

	for (i = 0; i < num; i++) {
		p_num[i] = i + 1;
		c_num[i] = i + 1;
	}

	num = num * 2;

	int *t_num = (int*)realloc(p_num, num * sizeof(int));
	if (nx_mem_chk(t_num) == -1) /* Handle memory allocation failure here */
		goto calloc_cleanup;
	p_num = t_num;

	t_num = (int*)realloc(c_num, num * sizeof(int));
	if ((i = nx_mem_chk(t_num)) == -1) /* Handle memory allocation failure here */
		goto calloc_cleanup;
	c_num = t_num;

	for (i = num / 2; i < num; i++) { /* Initialize new values */
		p_num[i] = (i + 1) * 2;
		c_num[i] = (i + 1) * 2;
	}
	for (i = 1; i < num; i++)
		printf("%d * %d = %d\n", p_num[i], c_num[i], p_num[i] * c_num[i]); /* Print values */

	calloc_cleanup:
		free(c_num); /* Free allocated memory */
	malloc_cleanup:
		free(p_num); /* Free allocated memory */
	return(i);
}

