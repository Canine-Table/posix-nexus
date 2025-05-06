.section .data
	msg: .asciz "hello world!\n"  @ or msg:    .ascii "hello world!" 
	.equ l_msg, . - msg   @ or: l_msg = . - msg (Less Portable (GNU as specific):
.section .text
	.global _start
_start:
	BL nx_write
	B nx_svc_end
nx_write:
	MOV R7, #4
	MOV R0, #1
	LDR R1, =msg
	LDR R2, =l_msg
	SVC #0
	BX LR
nx_svc_end:
	MOV R7, #1		@ syscall: exit
	MOV R0, #0		@  exit code (0 = success)
	SVC 0			@ invoke syscall
nx_swi_end:
	MOV R7, #1		@ syscall: exit
	SWI 0			@ Call software interrupt
