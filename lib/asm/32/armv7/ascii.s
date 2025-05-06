.section .data
	@nx_include "_ascii.S"
@nx_include "_start.S"
	LDR R4, =msg       @ r4 will point to the current character in the string
	LDR R5, =nx_msg_end

@nx_include "_exit.S"
