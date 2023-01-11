ldy #<{c1}
sty $fe
ldy #>{c1}
sty $ff
ldy #0
lda ($fe),y
ora #<{c2}
sta ($fe),y
