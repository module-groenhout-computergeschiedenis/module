lda {c1}
cmp {c2}
lda {c1}+1
sbc {c2}+1
bvc !+
eor #$80
!:
bmi {la1}
