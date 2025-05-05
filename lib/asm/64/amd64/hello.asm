section .data
	msg db "hello world!", 10
	l_msg equ $-msg

section .text
	global _start

_start:
	call nx_write
	jmp nx_exit

nx_write:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg
	mov rdx, l_msg
	syscall
	ret

nx_exit:
	mov rax, 60
	mov rdi, 0
	syscall
