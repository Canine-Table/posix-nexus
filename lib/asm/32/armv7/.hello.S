.section .data
	msg: .asciz "hello world!\n"  @ or msg:    .ascii "hello world!" 
	.equ l_msg, . - msg   @ or: l_msg = . - msg (Less Portable (GNU as specific):
.section .text
	.global _start
_start:
	BL nx_write
	B nx_exit
nx_write:
	MOV R7, #4
	MOV R0, #1
	LDR R1, =msg
	LDR R2, =l_msg
	SVC #0
	BX LR
nx_exit:
	MOV r7, #1
	MOV r0, #0
	SVC #0
