lda {c2}
cmp {c1}
lda {c2}+1
sbc #0
bvc !+
eor #$80
!:
bmi {la1}
