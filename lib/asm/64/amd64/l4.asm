; ----------------------------------------
; Subroutine: compound_interest(principal, rate, years, freq)
; Result in xmm0
compound_interest:
    ; xmm1 = rate
    ; rdi = principal
    ; rcx = freq
    ; rdx = years

    imul rdx, rcx             ; total periods
    cvtsi2sd xmm2, rcx        ; freq as double
    divsd xmm1, xmm2          ; rate / freq
    movsd xmm3, qword [one]
    addsd xmm1, xmm3          ; 1 + rate/freq
    cvtsi2sd xmm4, rdx        ; periods as double
    call pow                  ; xmm0 = pow(xmm1, xmm4)
    movsd xmm1, qword [rdi]
    mulsd xmm0, xmm1          ; final amount
    ret

