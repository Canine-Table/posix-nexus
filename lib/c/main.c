#include<stdio.h>
#include <string.h>
//#include "headers/math.h"
//#include "headers/def.h"
//#include "headers/data.h"
//#include "headers/misc.h"
//#include "headers/output.h"

int main (int argc, const char *argv[])
{
	const char msg[] = "Hello, World!\n";
	__asm__ (
		"mov $1, %%rax\n"  // syscall: write
		"mov $1, %%rdi\n"  // file descriptor: stdout
		"mov %0, %%rsi\n"  // pointer to message
		"mov $14, %%rdx\n" // message length
		"syscall\n"        // invoke syscall
		:
		: "r"(msg)         // input operand
		: "rax", "rdi", "rsi", "rdx"
	);
	return(0);
}

