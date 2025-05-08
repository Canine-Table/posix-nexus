.section .data
	@nx_include "_byte.S"
@nx_include "_start.S"
	LDR R2, =msg        @ Load the starting address of the message into R2.
	LDR R3, =nx_msg_end @ Load the terminating address into R3.
	MOV R1, #1          @ The skip count (number of bytes to write per syscall).
	MOV R0, #1          @ The file descriptor (stdout).
	BL nx_write_loop    @ Branch with link into your write loop subroutine.
	B nx_swi_end        @ Branch to the routine that exits (using SWI).
@nx_include "_loop.S"
@nx_include "_exit.S"

