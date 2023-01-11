//KICKC FRAGMENT CACHE 13689afa04 13689b23ba
//FRAGMENT _deref_pbuc1=vbuc2
lda #{c2}
sta {c1}
//FRAGMENT pbuz1=pbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=vbuc1
lda #{c1}
sta {z1}
//FRAGMENT vbuz1_lt_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcc {la1}
//FRAGMENT pbuz1=pbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vbuz1=_inc_vbuz1
inc {z1}
//FRAGMENT pbuz1_derefidx_vbuz2=vbuc1
lda #{c1}
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1=pbuc1_plus_vbuz2
lda {z2}
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_plus_vbuc1
lda #{c1}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT pbuz1_derefidx_vbuc1=vbuz2
lda {z2}
ldy #{c1}
sta ({z1}),y
//FRAGMENT vbum1=_deref_pbuc1
lda {c1}
sta {m1}
//FRAGMENT vbum1_lt_vbuc1_then_la1
lda {m1}
cmp #{c1}
bcc {la1}
//FRAGMENT vbum1=vbuc1
lda #{c1}
sta {m1}
//FRAGMENT vbum1=vbum2
lda {m2}
sta {m1}
//FRAGMENT vbum1=_stackidxbyte_vbuc1
tsx
lda STACK_BASE+{c1},x
sta {m1}
//FRAGMENT vbum1_eq_vbuc1_then_la1
lda #{c1}
cmp {m1}
beq {la1}
//FRAGMENT pbuz1_derefidx_vbum2=vbum3
lda {m3}
ldy {m2}
sta ({z1}),y
//FRAGMENT vbum1=_inc_vbum1
inc {m1}
//FRAGMENT vbum1_neq_vbuc1_then_la1
lda #{c1}
cmp {m1}
bne {la1}
//FRAGMENT vwum1=vwuc1
lda #<{c1}
sta {m1}
lda #>{c1}
sta {m1}+1
//FRAGMENT vbum1=vwuc1
lda #<{c1}
sta {m1}
//FRAGMENT 0_eq_vbum1_then_la1
lda {m1}
beq {la1}
//FRAGMENT vdum1=vduc1
lda #<{c1}
sta {m1}
lda #>{c1}
sta {m1}+1
lda #<{c1}>>$10
sta {m1}+2
lda #>{c1}>>$10
sta {m1}+3
//FRAGMENT vbum1=_dec_vbum2
ldy {m2}
dey
sty {m1}
//FRAGMENT 0_neq_vbum1_then_la1
lda {m1}
bne {la1}
//FRAGMENT vwum1=_word1_vdum2
lda {m2}+2
sta {m1}
lda {m2}+3
sta {m1}+1
//FRAGMENT vwum1=vwum2_plus_vbuc1
lda #{c1}
clc
adc {m2}
sta {m1}
lda #0
adc {m2}+1
sta {m1}+1
//FRAGMENT vwum1_lt_vwum2_then_la1
lda {m1}+1
cmp {m2}+1
bcc {la1}
bne !+
lda {m1}
cmp {m2}
bcc {la1}
!:
//FRAGMENT vwum1_le_vwum2_then_la1
lda {m1}+1
cmp {m2}+1
bne !+
lda {m1}
cmp {m2}
beq {la1}
!:
bcc {la1}
//FRAGMENT vwum1_ge_vwuc1_then_la1
lda {m1}+1
cmp #>{c1}
bcc !+
bne {la1}
lda {m1}
cmp #<{c1}
bcs {la1}
!:
//FRAGMENT vdum1=_neg_vdum1
sec
lda #0
sbc {m1}
sta {m1}
lda #0
sbc {m1}+1
sta {m1}+1
lda #0
sbc {m1}+2
sta {m1}+2
lda #0
sbc {m1}+3
sta {m1}+3
//FRAGMENT vwum1_lt_vwuc1_then_la1
lda {m1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {m1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vwum1_le_vwuc1_then_la1
lda {m1}+1
cmp #>{c1}
bne !+
lda {m1}
cmp #<{c1}
!:
bcc {la1}
beq {la1}
//FRAGMENT vdum1=vdum1_plus_vdum2
clc
lda {m1}
adc {m2}
sta {m1}
lda {m1}+1
adc {m2}+1
sta {m1}+1
lda {m1}+2
adc {m2}+2
sta {m1}+2
lda {m1}+3
adc {m2}+3
sta {m1}+3
//FRAGMENT vwum1=vwum2
lda {m2}
sta {m1}
lda {m2}+1
sta {m1}+1
//FRAGMENT vbum1=vwum2
lda {m2}
sta {m1}
//FRAGMENT vwum1_lt_vbuc1_then_la1
lda {m1}+1
bne !+
lda {m1}
cmp #{c1}
bcc {la1}
!:
//FRAGMENT vwum1=_inc_vwum1
inc {m1}
bne !+
inc {m1}+1
!:
//FRAGMENT vwsm1=vwsc1
lda #<{c1}
sta {m1}
lda #>{c1}
sta {m1}+1
//FRAGMENT vwsm1_lt_vbsc1_then_la1
NO_SYNTHESIS
//FRAGMENT vwsm1_lt_vwuc1_then_la1
lda {m1}+1
bmi {la1}
cmp #>{c1}
bcc {la1}
bne !+
lda {m1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vwsm1=_inc_vwsm1
inc {m1}
bne !+
inc {m1}+1
!:
//FRAGMENT vwum1_gt_vwuc1_then_la1
lda #>{c1}
cmp {m1}+1
bcc {la1}
bne !+
lda #<{c1}
cmp {m1}
bcc {la1}
!:
//FRAGMENT vdum1=vdum1_plus_vwuc1
clc
lda {m1}
adc #<{c1}
sta {m1}
lda {m1}+1
adc #>{c1}
sta {m1}+1
lda {m1}+2
adc #0
sta {m1}+2
lda {m1}+3
adc #0
sta {m1}+3
//FRAGMENT vwum1_eq_vwum2_then_la1
lda {m1}
cmp {m2}
bne !+
lda {m1}+1
cmp {m2}+1
beq {la1}
!:
//FRAGMENT vwum1_neq_vwum2_then_la1
lda {m1}+1
cmp {m2}+1
bne {la1}
lda {m1}
cmp {m2}
bne {la1}
//FRAGMENT vdum1=vdum1_minus_vwuc1
NO_SYNTHESIS
//FRAGMENT vdum1=vdum1_minus_vwsc1
NO_SYNTHESIS
//FRAGMENT vdum1=vdum1_minus_vduc1
lda {m1}
sec
sbc #<{c1}
sta {m1}
lda {m1}+1
sbc #>{c1}
sta {m1}+1
lda {m1}+2
sbc #<{c1}>>$10
sta {m1}+2
lda {m1}+3
sbc #>{c1}>>$10
sta {m1}+3
//FRAGMENT vwum1=vwum1_plus_vbuc1
lda #{c1}
clc
adc {m1}
sta {m1}
bcc !+
inc {m1}+1
!:
//FRAGMENT vwum1=vwum1_minus_vbuc1
sec
lda {m1}
sbc #{c1}
sta {m1}
lda {m1}+1
sbc #0
sta {m1}+1
//FRAGMENT vwum1=_dec_vwum1
lda {m1}
bne !+
dec {m1}+1
!:
dec {m1}
//FRAGMENT vwum1=_word_vbum2
lda {m2}
sta {m1}
lda #0
sta {m1}+1
//FRAGMENT vwum1=vwum2_rol_2
lda {m2}
asl
sta {m1}
lda {m2}+1
rol
sta {m1}+1
asl {m1}
rol {m1}+1
//FRAGMENT vwum1=vwum2_plus_vwum3
lda {m2}
clc
adc {m3}
sta {m1}
lda {m2}+1
adc {m3}+1
sta {m1}+1
//FRAGMENT vwum1=vwum2_rol_3
lda {m2}
asl
sta {m1}
lda {m2}+1
rol
sta {m1}+1
asl {m1}
rol {m1}+1
asl {m1}
rol {m1}+1
//FRAGMENT pbuz1=pbuc1_plus_vwum2
lda {m2}
clc
adc #<{c1}
sta {z1}
lda {m2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT pbuz1_derefidx_vbum2=vbuc1
lda #{c1}
ldy {m2}
sta ({z1}),y
//FRAGMENT pbuc1_derefidx_vbum1=pbuc2_derefidx_(pbuc3_derefidx_vbum1)
ldx {m1}
ldy {c3},x
lda {c2},y
sta {c1},x
//FRAGMENT vbum1=_byte0_vwum2
lda {m2}
sta {m1}
//FRAGMENT _deref_pbuc1=vbum1
lda {m1}
sta {c1}
//FRAGMENT vbum1=_byte1_vwum2
lda {m2}+1
sta {m1}
//FRAGMENT vbum1=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
sta {m1}
//FRAGMENT _deref_pbuc1=vwum1
lda {m1}
sta {c1}
//FRAGMENT vbum1=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
sta {m1}
//FRAGMENT vbum1=_deref_pbuz2
ldy #0
lda ({z2}),y
sta {m1}
//FRAGMENT pbuz1=_inc_pbuz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT _stackpushbyte_=vbum1
lda {m1}
pha
//FRAGMENT call_vprc1
jsr {c1}
//FRAGMENT _stackpullpadding_1
pla
//FRAGMENT vbum1=vbum2_ror_1
lda {m2}
lsr
sta {m1}
//FRAGMENT vwum1=vwum2_plus_vbum3
lda {m3}
clc
adc {m2}
sta {m1}
lda #0
adc {m2}+1
sta {m1}+1
//FRAGMENT vbum1=vbum2_band_vbuc1
lda #{c1}
and {m2}
sta {m1}
//FRAGMENT vbum1=vbum2_rol_1
lda {m2}
asl
sta {m1}
//FRAGMENT vbum1=vbum2_plus_vbum3
lda {m2}
clc
adc {m3}
sta {m1}
//FRAGMENT vbum1=vbum2_bxor_vbuc1
lda #{c1}
eor {m2}
sta {m1}
//FRAGMENT vbum1=vbuc1_rol_vbum2
lda #{c1}
ldy {m2}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
sta {m1}
//FRAGMENT vbum1=vbum2_bor_vbum3
lda {m2}
ora {m3}
sta {m1}
//FRAGMENT _deref_pbuz1=vbum2
lda {m2}
ldy #0
sta ({z1}),y
//FRAGMENT pvoz1=pvoc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuz1_minus_vbuc1
sec
lda {z1}
sbc #{c1}
sta {z1}
lda {z1}+1
sbc #0
sta {z1}+1
//FRAGMENT vbum1=_dec_vbum1
dec {m1}
//FRAGMENT pbuz1=pbuz2_plus_vwuc1
lda {z2}
clc
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT pbuz1_neq_pbuz2_then_la1
lda {z1}+1
cmp {z2}+1
bne {la1}
lda {z1}
cmp {z2}
bne {la1}
//FRAGMENT _deref_pbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
ldy #0
sta ({z1}),y
//FRAGMENT vbum1=vbum1_band_vbuc1
lda #{c1}
and {m1}
sta {m1}
//FRAGMENT vbum1=vbuc1_rol_vbum1
lda #{c1}
ldy {m1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
sta {m1}
//FRAGMENT vbum1=vbum2_bor_vbum1
lda {m1}
ora {m2}
sta {m1}
//FRAGMENT vwum1=vwum2_plus_vwum1
clc
lda {m1}
adc {m2}
sta {m1}
lda {m1}+1
adc {m2}+1
sta {m1}+1
//FRAGMENT vwum1=vwum1_plus_vbum2
lda {m2}
clc
adc {m1}
sta {m1}
bcc !+
inc {m1}+1
!:
//FRAGMENT vbum1=vbum1_plus_vbum2
lda {m1}
clc
adc {m2}
sta {m1}
//FRAGMENT vbum1=vbum1_rol_1
asl {m1}
//FRAGMENT vwum1=vwum1_rol_3
asl {m1}
rol {m1}+1
asl {m1}
rol {m1}+1
asl {m1}
rol {m1}+1
//FRAGMENT vbum1=vbum1_bxor_vbuc1
lda #{c1}
eor {m1}
sta {m1}
