.section .data
	msg:
	.byte 'h'
	.byte 'e'
	.byte 'l'
	.byte 'l'
	.byte 'o'
	.byte ' '	 @ space
	.byte 'w'
	.byte 'o'
	.byte 'r'
	.byte 'l'
	.byte 'd'
	.byte '!'
nx_msg_end:
	.byte 0		@ dummy value, not printed; or omit and calculate length
nl:
	.byte 10	@ newline character (ASCII LF)
.section .text
.global _start
_start:
	LDR R2, =msg
	LDR R3, =nx_msg_end
	MOV R1, #1
	MOV R0, #1
	BL nx_write_loop
	B nx_swi_end
nx_write_loop:
	MOV R10, R3		@ the terminator
	MOV R9, R2		@ the message
	MOV R8, R1		@ set the skip count
	MOV R6, R0		@ set file descriptor
nx_write_loop_repeat:
	CMP R9, R10		@ compare current pointer with end pointer
	BEQ nx_write_loop_end	@ if R9 == R10, we're done printing
	MOV R7, #4		@ syscall number for write is 4
	MOV R1, R9		@ set R1 to point to the current character
	MOV R2, R8		@ R8 byte(s) to write for this syscall
	SVC #0			@ invoke write syscall
	ADD R9, R9, R8		@ move over R8 character(s)
	B nx_write_loop_repeat	@ repeat the loop
nx_write_loop_end:
	BX LR
nx_svc_end:
	MOV R7, #1		@ syscall: exit
	MOV R0, #0		@  exit code (0 = success)
	SVC 0			@ invoke syscall
nx_swi_end:
	MOV R7, #1		@ syscall: exit
	SWI 0			@ Call software interrupt
