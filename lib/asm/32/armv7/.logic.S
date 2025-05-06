.global _start
_start:
	MOV R0, #066
	MOV R1, #0xAA
	AND R2, R1, R0
	ORR R1, R0, R1
	EOR R0, R1, R2
	MVN R0, R0 @ ! MOV 1 -> 0
	AND R0, R0, #0x000000FF
	B nx_svc_end
nx_svc_end:
	MOV R7, #1		@ syscall: exit
	MOV R0, #0		@  exit code (0 = success)
	SVC 0			@ invoke syscall
nx_swi_end:
	MOV R7, #1		@ syscall: exit
	SWI 0			@ Call software interrupt
