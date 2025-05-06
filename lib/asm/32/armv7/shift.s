.global _start
_start:
	MOV R0, #10
	MOV R1, #2
	LSL R0, R1 @ right shift => multiply by 2
	LSR R1, R0 @ left shift => divide by 2
	ROR R0, R0 @ rotate 
	B nx_svc_end

@nx_include "_exit.S"

