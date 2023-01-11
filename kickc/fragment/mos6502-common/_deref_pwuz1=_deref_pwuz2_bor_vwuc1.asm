ldy #0
lda ({z2}),y
ora #<{c1}
sta ({z1}),y
iny
lda ({z2}),y
ora #>{c1}
sta ({z1}),y