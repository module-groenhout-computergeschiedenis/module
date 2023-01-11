clc
lda {c1}
adc {m1}
sta {c1}
lda {c1}+1
adc #0
sta {c1}+1