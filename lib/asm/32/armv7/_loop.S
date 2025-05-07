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

