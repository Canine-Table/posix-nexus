section .data
	num dq 10, 20, 30, 40  ; An array of elements

section .text
	global _start

.exit:
	MOV RAX, 60
	XOR RDI, RDI
	SYSCALL

