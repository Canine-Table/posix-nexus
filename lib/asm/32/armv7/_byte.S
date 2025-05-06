msg:
	.byte 'h'
	.byte 'e'
	.byte 'l'
	.byte 'l'
	.byte 'o'
	.byte ' '	 @ space
	.byte 'w'
	.byte 'o'
	.byte 'r'
	.byte 'l'
	.byte 'd'
	.byte '!'
nx_msg_end:
	.byte 0		@ dummy value, not printed; or omit and calculate length
nl:
	.byte 10	@ newline character (ASCII LF)

