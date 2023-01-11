ldy #0
!:
lda {c1},y
sta ({z1}),y
iny
cpy #{c2}
bne !-
