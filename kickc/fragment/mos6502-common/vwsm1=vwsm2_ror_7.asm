lda {m2}+1
sta {m1}
and #$80
beq !+
lda #$ff
!:
sta {m1}+1
lda {m2}
rol
rol {m1}
rol {m1}+1
