//KICKC FRAGMENT CACHE 13047c6035 13047c89f8
//FRAGMENT pbuz1=pbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
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
//FRAGMENT _deref_pbuc1=vbuc2
lda #{c2}
sta {c1}
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
//FRAGMENT pprz1=pprc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vbum1=_dec_vbum2
ldy {m2}
dey
sty {m1}
//FRAGMENT 0_neq_vbum1_then_la1
lda {m1}
bne {la1}
//FRAGMENT vwum1=_word__deref_pbuc1
lda {c1}
sta {m1}
lda #0
sta {m1}+1
//FRAGMENT vwum1_ge_vwuc1_then_la1
lda {m1}+1
cmp #>{c1}
bcc !+
bne {la1}
lda {m1}
cmp #<{c1}
bcs {la1}
!:
//FRAGMENT vwum1_lt_vwuc1_then_la1
lda {m1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {m1}
cmp #<{c1}
bcc {la1}
!:
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
//FRAGMENT vwum1_le_vwuc1_then_la1
lda {m1}+1
cmp #>{c1}
bne !+
lda {m1}
cmp #<{c1}
!:
bcc {la1}
beq {la1}
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
//FRAGMENT vdum1=vdum2_plus_vwuc1
clc
lda {m2}
adc #<{c1}
sta {m1}
lda {m2}+1
adc #>{c1}
sta {m1}+1
lda {m2}+2
adc #0
sta {m1}+2
lda {m2}+3
adc #0
sta {m1}+3
//FRAGMENT vdum1=_neg_vdum2
sec
lda #0
sbc {m2}
sta {m1}
lda #0
sbc {m2}+1
sta {m1}+1
lda #0
sbc {m2}+2
sta {m1}+2
lda #0
sbc {m2}+3
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
//FRAGMENT vwum1=vwum2
lda {m2}
sta {m1}
lda {m2}+1
sta {m1}+1
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
//FRAGMENT pbuz1=pbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
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
//FRAGMENT call__deref_pprz1
jsr {la1}
{la1}: @outside_flow
jmp ({z1})  @outside_flow
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
//FRAGMENT _deref_pbuz1=pbuc1_derefidx_vbum2
ldy {m2}
lda {c1},y
ldy #0
sta ({z1}),y
//FRAGMENT pbuz1=_inc_pbuz2
clc
lda {z2}
adc #1
sta {z1}
lda {z2}+1
adc #0
sta {z1}+1
//FRAGMENT _deref_pbuz1=vbuc1
lda #{c1}
ldy #0
sta ({z1}),y
//FRAGMENT vbum1=pbuc1_derefidx_vbum2
ldy {m2}
lda {c1},y
sta {m1}
//FRAGMENT vbum1_ge_vbum2_then_la1
lda {m1}
cmp {m2}
bcs {la1}
//FRAGMENT vbsm1=_sbyte_vwum2
lda {m2}
sta {m1}
//FRAGMENT vbsm1=_inc_vbsm1
inc {m1}
//FRAGMENT vbsm1=vbsc1_minus_vbsm2
lda #{c1}
sec
sbc {m2}
sta {m1}
//FRAGMENT vbsm1_ge_0_then_la1
lda {m1}
cmp #0
bpl {la1}
//FRAGMENT vbsm1=vbsc1
lda #{c1}
sta {m1}
//FRAGMENT 0_neq_vbsm1_then_la1
lda {m1}
cmp #0
bne {la1}
//FRAGMENT call_vprc1
jsr {c1}
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
//FRAGMENT pbuz1=pbuz2_plus_vbuc1
lda #{c1}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT vbum1=vbum1_minus_vbum2
lda {m1}
sec
sbc {m2}
sta {m1}
//FRAGMENT 0_neq__deref_pbuz1_then_la1
ldy #0
lda ({z1}),y
cmp #0
bne {la1}
//FRAGMENT vbum1_lt_vbum2_then_la1
lda {m1}
cmp {m2}
bcc {la1}
//FRAGMENT _stackpushbyte_=vbuc1
lda #{c1}
pha
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
//FRAGMENT vbsm1=vbsc1_minus_vbsm1
lda #{c1}
sec
sbc {m1}
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
//FRAGMENT vbuz1=vbuc1
lda #{c1}
sta {z1}
//FRAGMENT vbuz1_lt_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcc {la1}
//FRAGMENT pbuz1=pbuc1_plus_vbuz2
lda {z2}
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT pbuz1_derefidx_vbuc1=vbuz2
lda {z2}
ldy #{c1}
sta ({z1}),y
//FRAGMENT vbuz1=_inc_vbuz1
inc {z1}
//FRAGMENT pbuz1_derefidx_vbuz2=vbuc1
lda #{c1}
ldy {z2}
sta ({z1}),y
//FRAGMENT vbuz1=_deref_pbuc1
lda {c1}
sta {z1}
//FRAGMENT vbuz1=vbuz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=_stackidxbyte_vbuc1
tsx
lda STACK_BASE+{c1},x
sta {z1}
//FRAGMENT vbuz1_eq_vbuc1_then_la1
lda #{c1}
cmp {z1}
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuz2=vbuz3
lda {z3}
ldy {z2}
sta ({z1}),y
//FRAGMENT vbuz1_neq_vbuc1_then_la1
lda #{c1}
cmp {z1}
bne {la1}
//FRAGMENT vwsz1=vwsc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vwuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT 0_eq_vbuz1_then_la1
lda {z1}
beq {la1}
//FRAGMENT vbuz1=_dec_vbuz2
ldy {z2}
dey
sty {z1}
//FRAGMENT 0_neq_vbuz1_then_la1
lda {z1}
bne {la1}
//FRAGMENT vwuz1=vwuz1_plus_vwsz2
clc
lda {z1}
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=vbuz2_minus_1
ldx {z2}
dex
stx {z1}
//FRAGMENT vbuz1_neq_vbuz2_then_la1
lda {z1}
cmp {z2}
bne {la1}
//FRAGMENT vbuz1_lt_vbuz2_then_la1
lda {z1}
cmp {z2}
bcc {la1}
//FRAGMENT vbuz1_le_vbuz2_then_la1
lda {z2}
cmp {z1}
bcs {la1}
//FRAGMENT vwsz1=_neg_vwsz1
lda #0
sec
sbc {z1}
sta {z1}
lda #0
sbc {z1}+1
sta {z1}+1
//FRAGMENT vwsz1_lt_vbsc1_then_la1
NO_SYNTHESIS
//FRAGMENT vwsz1_lt_vwuc1_then_la1
lda {z1}+1
bmi {la1}
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vwsz1=_inc_vwsz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vbuz1_ge_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcs {la1}
//FRAGMENT vwsz1=vwsz1_plus_vbsc1
lda {z1}
clc
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vbuz1_eq_vbuz2_then_la1
lda {z1}
cmp {z2}
beq {la1}
//FRAGMENT vbuz1=vbuz2_plus_1
ldy {z2}
iny
sty {z1}
//FRAGMENT vbuz1=vbuz2_plus_vbuc1
lax {z2}
axs #-[{c1}]
stx {z1}
//FRAGMENT vwsz1=vwsz1_minus_vbsc1
lda {z1}
sec
sbc #{c1}
sta {z1}
lda {z1}+1
sbc #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=_dec_vbuz1
dec {z1}
//FRAGMENT vwuz1=_word_vbuz2
lda {z2}
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_rol_2
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT vwuz1=vwuz2_plus_vwuz3
lda {z2}
clc
adc {z3}
sta {z1}
lda {z2}+1
adc {z3}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_rol_3
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_vwuz2
lda {z2}
clc
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
sta {z1}
//FRAGMENT _stackpushbyte_=vbuz1
lda {z1}
pha
//FRAGMENT vbuz1=vbuz2_plus_vbuz3
lda {z2}
clc
adc {z3}
sta {z1}
//FRAGMENT vbuz1=vbuz2_ror_1
lda {z2}
lsr
sta {z1}
//FRAGMENT vwuz1=vwuz2_plus_vbuz3
lda {z3}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=vbuz2_band_vbuc1
lda #{c1}
and {z2}
sta {z1}
//FRAGMENT vbuz1=vbuz2_rol_1
lda {z2}
asl
sta {z1}
//FRAGMENT vbuz1=vbuz2_bxor_vbuc1
lda #{c1}
eor {z2}
sta {z1}
//FRAGMENT vbuz1=vbuc1_rol_vbuz2
lda #{c1}
ldy {z2}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
sta {z1}
//FRAGMENT vbuz1=_bnot_vbuz2
lda {z2}
eor #$ff
sta {z1}
//FRAGMENT vbuz1=vbuz2_band_vbuz3
lda {z2}
and {z3}
sta {z1}
//FRAGMENT _deref_pbuz1=vbuz2
lda {z2}
ldy #0
sta ({z1}),y
//FRAGMENT vbuz1=vbuz2_bor_vbuz3
lda {z2}
ora {z3}
sta {z1}
//FRAGMENT _deref_pbuc1=vbuz1
lda {z1}
sta {c1}
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1)
ldx {z1}
ldy {c3},x
lda {c2},y
sta {c1},x
//FRAGMENT vbuz1=vbum2
lda {m2}
sta {z1}
//FRAGMENT vbuz1=_byte1_vwuz2
lda {z2}+1
sta {z1}
//FRAGMENT vbuz1=vbuz1_band_vbuz2
lda {z1}
and {z2}
sta {z1}
//FRAGMENT vbuz1=vbuz1_bor_vbuz2
lda {z1}
ora {z2}
sta {z1}
//FRAGMENT vbuz1=vbuz1_band_vbuc1
lda #{c1}
and {z1}
sta {z1}
//FRAGMENT vbuz1=vbuc1_rol_vbuz1
lda #{c1}
ldy {z1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
sta {z1}
//FRAGMENT vbuz1=_bnot_vbuz1
lda {z1}
eor #$ff
sta {z1}
//FRAGMENT vbuz1=vbuz1_minus_1
dec {z1}
//FRAGMENT vwuz1=vwuz2_plus_vwuz1
clc
lda {z1}
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_vwuz1
lda {z1}
clc
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_plus_vbuz2
lda {z2}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vbuz1=vbuz1_plus_vbuz2
lda {z1}
clc
adc {z2}
sta {z1}
//FRAGMENT vbuz1=vbuz1_rol_1
asl {z1}
//FRAGMENT vwuz1=vwuz1_rol_3
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT vbuz1=vbuz1_bxor_vbuc1
lda #{c1}
eor {z1}
sta {z1}
//FRAGMENT vbuz1=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
sta {z1}
//FRAGMENT vwuz1=vbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT 0_eq_vwuz1_then_la1
lda {z1}
ora {z1}+1
beq {la1}
//FRAGMENT 0_neq_vwuz1_then_la1
lda {z1}
ora {z1}+1
bne {la1}
//FRAGMENT vbuz1=_byte0_vbuz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1_neq_0_then_la1
lda {z1}
bne {la1}
//FRAGMENT vbuaa=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
//FRAGMENT vbuxx=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
tax
//FRAGMENT vbuyy=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
tay
//FRAGMENT _deref_pbuc1=vbuaa
sta {c1}
//FRAGMENT 0_neq_vbuxx_then_la1
cpx #0
bne {la1}
//FRAGMENT vbuz1=_byte0_vbuxx
txa
sta {z1}
//FRAGMENT vbuz1=_byte0_vbuyy
tya
sta {z1}
//FRAGMENT vbuaa=_byte0_vbuz1
lda {z1}
//FRAGMENT vbuaa=_byte0_vbuxx
txa
//FRAGMENT vbuaa=_byte0_vbuyy
tya
//FRAGMENT vbuxx=_byte0_vbuz1
lda {z1}
tax
//FRAGMENT vbuxx=_byte0_vbuxx
txa
tax
//FRAGMENT vbuxx=_byte0_vbuyy
tya
tax
//FRAGMENT vbuyy=_byte0_vbuz1
lda {z1}
tay
//FRAGMENT vbuyy=_byte0_vbuxx
txa
tay
//FRAGMENT vbuyy=_byte0_vbuyy
tya
tay
//FRAGMENT vbuxx_neq_0_then_la1
cpx #0
bne {la1}
//FRAGMENT vbuaa=vbuz1
lda {z1}
//FRAGMENT vbuxx=vbuz1
ldx {z1}
//FRAGMENT vbuz1=vbuaa
sta {z1}
//FRAGMENT 0_eq_vbuaa_then_la1
cmp #0
beq {la1}
//FRAGMENT vbuaa=vbum1
lda {m1}
//FRAGMENT vbuxx=vbum1
ldx {m1}
//FRAGMENT vbuz1=vbuxx
stx {z1}
//FRAGMENT vbuyy=vbum1
ldy {m1}
//FRAGMENT vbuz1=vbuyy
sty {z1}
//FRAGMENT vbuaa=vbuxx
txa
//FRAGMENT vbuaa=vbuyy
tya
//FRAGMENT vbuxx=vbuaa
tax
//FRAGMENT _deref_pbuc1=vbuxx
stx {c1}
//FRAGMENT _deref_pbuc1=vbuyy
sty {c1}
//FRAGMENT vbuyy=vbuz1
ldy {z1}
//FRAGMENT vbuyy=vbuaa
tay
//FRAGMENT 0_eq_vbuxx_then_la1
cpx #0
beq {la1}
//FRAGMENT 0_eq_vbuyy_then_la1
cpy #0
beq {la1}
//FRAGMENT 0_neq_vbuyy_then_la1
cpy #0
bne {la1}
//FRAGMENT pbuz1=qbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_ror_6
lda {z2}
asl
sta $ff
lda {z2}+1
rol
sta {z1}
lda #0
rol
sta {z1}+1
asl $ff
rol {z1}
rol {z1}+1
//FRAGMENT _deref_pbuc1=_byte_vwuz1
lda {z1}
sta {c1}
//FRAGMENT vbuz1=vbuz1_plus_1
inc {z1}
//FRAGMENT vwuz1=vwuz1_ror_6
lda {z1}
asl
sta $ff
lda {z1}+1
rol
sta {z1}
lda #0
rol
sta {z1}+1
asl $ff
rol {z1}
rol {z1}+1
//FRAGMENT vbuz1=_byte0_vwuz2
lda {z2}
sta {z1}
//FRAGMENT vwuz1_lt_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vwuz1=_inc_vwuz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vbuz1=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
sta {z1}
