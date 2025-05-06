.section .data
		nl:
		.ascii "\n"		@ store the string as raw bytes
	msg:
		.ascii "hello world!"	@ store the string as raw bytes
	nx_msg_end:
.section .text
.global _start
_start:
	LDR R4, =msg		@ R4 will point to the current character in the string
	LDR R5, =nx_msg_end	@ label marking the end of the string
	MOV R6, #1		@ R6 holds the file descriptor for stdout
nx_loop:
	CMP R4, R5		@ compare current pointer with end pointer
	BEQ nx_svc_end		@ if R4 == R5, we're done printing
	MOV R0, R6		@ set file descriptor (stdout) in R0
	MOV R1, R4		@ set R1 to point to the current character
	MOV R2, #1		@ one byte to write for this syscall
	MOV R7, #4		@ syscall number for write is 4
	SVC #0			@ invoke write syscall
	ADD R4, R4, #1		@ move to the next character
	MOV R0, R6		@ set file descriptor (stdout) in R0
	LDR R3, =nl		@ R3 holds the new line character
	MOV R7, #4		@ syscall number for write is 4
	MOV R1, R3
	SVC #0
	B nx_loop		@ repeat the loop
nx_svc_end:
	MOV R7, #1		@ syscall: exit
	MOV R0, #0		@  exit code (0 = success)
	SVC 0			@ invoke syscall
nx_swi_end:
	MOV R7, #1		@ syscall: exit
	SWI 0			@ Call software interrupt
