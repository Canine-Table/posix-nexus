ORG 0000H      ; ROM starts at address 0000H

START:
    IN 0        ; Read a character from keyboard (port 0)
    OUT 1       ; Output character to screen (port 1)
    JMP START   ; Loop forever

END

