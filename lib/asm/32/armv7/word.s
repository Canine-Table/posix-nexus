.section .data
	nx_l_int: .word 2,-3,5,-7,11,-13

.section .text
	.global _start

_start:
	MOV R7, #4
        MOV R0, #1
	LDR R1, =nx_l_int
	BL nx_loop
	B nx_exit


nx_loop:
	LDR R2, [R1,#4]
	SVC #0
	BX LR

nx_exit:
	MOV R7, #1
	MOV R0, #0
	SVC #0

