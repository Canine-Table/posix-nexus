.global _start
_start:
	B nx_exit
nx_exit:
	MOV r7, #1
	MOV r0, #0
	SVC #0

