lda {c1},y
sta $fe
lda {c1}+1,y
sta $ff
ldy #{c2}
lda #{c3}
sta ($fe),y
