sec
lda {c1}
sbc {m1}
sta {c1}
lda {c1}+1
sbc #0
sta {c1}+1