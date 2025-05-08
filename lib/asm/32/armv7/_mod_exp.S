nx_mod_exp_loop:
    MOV R2, #1         @ Result starts at 1

nx_mod_exp_loop_repeat:
    TST R1, #1         @ If exponent (R1) is odd

nx_mod_exp_loop_end:
        BX LR

