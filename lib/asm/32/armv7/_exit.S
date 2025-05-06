nx_svc_end:
	MOV R7, #1		@ syscall: exit
	MOV R0, #0		@  exit code (0 = success)
	SVC 0			@ invoke syscall
nx_swi_end:
	MOV R7, #1		@ syscall: exit
	SWI 0			@ Call software interrupt

