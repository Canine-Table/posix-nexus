.section .data
@nx_include "_asciz.S"

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
@nx_include "_exit.S"
