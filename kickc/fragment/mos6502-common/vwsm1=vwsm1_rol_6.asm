lda {m1}+1
sta $ff
lda {m1}
sta {m1}+1
lda #0
sta {m1}
lsr $ff
ror {m1}+1
ror {m1}
lsr $ff
ror {m1}+1
ror {m1}