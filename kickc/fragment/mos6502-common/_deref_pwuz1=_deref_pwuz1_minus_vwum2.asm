ldy #0
lda ({z1}),y
sec
sbc {m2}
sta ({z1}),y
iny
lda ({z1}),y
sbc {m2}+1
sta ({z1}),y
