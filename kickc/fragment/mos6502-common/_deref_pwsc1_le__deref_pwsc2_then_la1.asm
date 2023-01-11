lda {c2}
cmp {c1}
lda {c2}+1
sbc {c1}+1
bvc !+
eor #$80
!:
bpl {la1}
