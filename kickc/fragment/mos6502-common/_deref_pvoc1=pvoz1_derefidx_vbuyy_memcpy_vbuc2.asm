ldx #0
!:
lda ({z1}),y
sta {c1},x
iny
inx
cpx #{c2}
bne !-
