
;cld	; Clear direction flag (forward memory movement)
;std	; Set direction flag (backward memory movement)
; 	cmp	byte [rsi], 0

section .data
	newline db 0xA			; Newline character
	msg db "Hello, world!", 0	; Message stored in memory
	msg_len equ $-msg		; Calculate string length

section .text
	global	_start

_start:
	mov rsi, msg		; Pointer to first character
	mov rcx, msg_len	; Loop counter (length of msg)
	mov rax, 1		; Syscall: write
	mov rdi, 1		; File descriptor: stdout (1)
	xor rsi, rsi

print_loop:
	mov rdx, 1	   ; Print 1 character at a time
	syscall		   ; Invoke syscall
	mov rax, 1	   ; Syscall: write for newline
	mov rdi, 1	   ; File descriptor: stdout (1)
	mov rsi, newline   ; Pointer to newline character
	mov rdx, 1	   ; Print 1 byte (0xA)
	syscall		   ; Invoke syscall
	inc rsi		; Move to next character
	mov rdx, 1	   ; Print 1 character at a time
	loop print_loop ; Repeat until rcx reaches 0
	jmp exit

;_start:
;	jmp pmem

pmem:
	mov rax, 1	; syscall: write
	mov rdi, 1	; File descriptor: stdout (1)
	lea rsi, 1	; Load memory address of msg
	mov rdx, 1	; Assume address is 8 bytes long
	syscall		; Print the address as raw memory bytes
	jmp exit

loop_dec:
	dec rcx		; Decrease counter
	jnz loop_dec	; Jump if rcx is not zero

exit:
	mov rax, 60	; syscall: exit
	xor rdi, rdi	; Exit code 0
	syscall

