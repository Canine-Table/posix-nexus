
nx_cpsr_start:
	MRS R4, CPSR		@ Read CPSR into R4
nx_cspr_n:
	TST R4, #0x80000000   	@ Check N flag (Bit 31)
	BNE nx_negative       	@ Branch if N is set
nx_flag_c:
	TST R4, #0x40000000	@ Check C flag (Bit 30)
	BEQ nx_zero		@ Branch if Z is set
nx_flag_z:
	TST R4, #0x20000000	@ Check Z flag (Bit 29)
	BNE nx_carry		@  Branch if C is set
nx_flag_v:
	TST R4, #0x10000000	@ Check V flag (Bit 28)
	BNE nx_overflow		@ Branch if V is set
nx_flag_t:
	TST R4, #0x00000020	@ Check T flag (Bit 5)
	BNE nx_thumb
nx_flag_f:
	TST R4, #0x00000040	@ Check F flag (Bit 6)
	BNE nx_fiq
nx_flag_i:
	TST R4, #0x00000080	@ Check I flag (Bit 7)
	BNE nx_irq
nx_flag_m:
	TST R4, #0x0000001F	@ Check processor mode bits (Bits 0-4)
	BNE nx_mode		@ Branch if any of Bits 0-4 are set
nx_flag_end:
	BX LR
nx_negative:
	ADD R3, R3, #67
	B nx_flag_z
nx_zero:
	ADD R3, R3, #31
	B nx_flag_c
nx_carry:
	ADD R3, R3, #37
	B nx_flag_v
nx_overflow:
	ADD R3, R3, #41
	B nx_flag_t
nx_irq:
	ADD R3, R3, #43
	B nx_flag_m
nx_fiq:
	ADD R3, R3, #47
	B nx_flag_i
nx_thumb:
	ADD R3, R3, #53
	B nx_flag_f

nx_mode:
	ADD R3, R3, #59
	B nx_flag_end
nx_end:
	CMP R3, #0		@ Compare R3 with 0
	BEQ nx_swi_end		@ If R3 == 0, jump to nx_swi_end
	BNE nx_svc_end		@ If R3 != 0, jump to nx_svc_end
nx_svc_end:
	ADD R3, R3, #61
	MOV R7, #1   	@ syscall: exit
	MOV R0, #0    	@  exit code (0 = success)
	SVC 0         	@ invoke syscall
nx_swi_end:
	MOV R7, #1		@ syscall: exit
	SWI 0			@ Call syscall

