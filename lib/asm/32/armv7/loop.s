.section .data
	@nx_include "_byte.S"
@nx_include "_start.S"
	LDR R2, =msg
	LDR R3, =nx_msg_end
	MOV R1, #1
	MOV R0, #1
	BL nx_write_loop
	B nx_swi_end

@nx_include "_loop.S"
@nx_include "_exit.S"

