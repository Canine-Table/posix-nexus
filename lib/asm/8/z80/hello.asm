ORG 100h      ; CP/M programs start at 100h
START:
    LD DE, MSG   ; Point DE to the string
    LD C, 9      ; CP/M BDOS function to print a string
    CALL 5       ; Call CP/M BDOS function
    RET          ; Return to CP/M

MSG: DB 'Hello, World!', '$'  ; String must end with '$' for CP/M

