lda ({z1}),y
sta $fe
iny
lda ({z1}),y
sta $ff
ldy {m2}
lda {m3}
sta ($fe),y
iny
lda {m3}+1
sta ($fe),y