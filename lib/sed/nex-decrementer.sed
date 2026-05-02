# All The Twiddled Bits
# Chimeric ABI

# make sure were binarying
s/[^01]*//
s/^$/0/

# branch return
:JMP
/^0*$/b RET

p
h
x

s/^[10]*\(1[0]*\)$/\1/; t NOT

:NOT
y/01/10/
x
s/1[0]*$//
x
H
x
s/\n//
b JMP

# branch return
:RET
q
