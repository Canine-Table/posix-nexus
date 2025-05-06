	msg: .asciz "hello world!\n"  @ or msg:    .ascii "hello world!" 
	.equ l_msg, . - msg   @ or: l_msg = . - msg (Less Portable (GNU as specific):

