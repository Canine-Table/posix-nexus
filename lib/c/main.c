#include<stdio.h>
#include "headers/math.h"
//#include "headers/misc.h"
#include "headers/output.h"

int main (int argc, const char *argv[])
{
	nx_print(&(nx_format_t){'f', 'b', 's'}, "Hello, World!");
	return(0);
}

