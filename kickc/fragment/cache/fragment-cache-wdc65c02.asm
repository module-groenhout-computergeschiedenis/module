//KICKC FRAGMENT CACHE 12828b770b 12828ba0d5
//FRAGMENT vbuz1=vbuc1
lda #{c1}
sta {z1}
//FRAGMENT vwuz1=vwuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=_byte1_vwuz2
lda {z2}+1
sta {z1}
//FRAGMENT _deref_pbuc1=vbuz1
lda {z1}
sta {c1}
//FRAGMENT vbuz1=_byte0_vwuz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=_deref_pbuc1
lda {c1}
sta {z1}
//FRAGMENT _deref_pbuc1=vbuc2
lda #{c2}
sta {c1}
//FRAGMENT vbuz1=_stackidxbyte_vbuc1
tsx
lda STACK_BASE+{c1},x
sta {z1}
//FRAGMENT vbuz1_eq_vbuc1_then_la1
lda #{c1}
cmp {z1}
beq {la1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
sta {c1}
//FRAGMENT vbuz1=_byte0__deref_pwuc1
lda {c1}
sta {z1}
//FRAGMENT vbuz1=_byte1__deref_pwuc1
lda {c1}+1
sta {z1}
//FRAGMENT vbuz1=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
sta {z1}
//FRAGMENT _deref_pbuc1=_deref_pbuc2
lda {c2}
sta {c1}
//FRAGMENT 0_eq_pbuc1_derefidx_(_deref_pbuc2)_then_la1
ldy {c2}
lda {c1},y
cmp #0
beq {la1}
//FRAGMENT _deref_pbuc1_ge__deref_pbuc2_then_la1
lda {c1}
cmp {c2}
bcs {la1}
//FRAGMENT _deref_pbuc1=_inc__deref_pbuc1
inc {c1}
//FRAGMENT _deref_pwuc1=_inc__deref_pwuc1
inc {c1}
bne !+
inc {c1}+1
!:
//FRAGMENT vbuz1=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
sta {z1}
//FRAGMENT vbuz1=vbuz2_bor_vbuc1
lda #{c1}
ora {z2}
sta {z1}
//FRAGMENT vbum1=vbuc1
lda #{c1}
sta {m1}
//FRAGMENT vwuz1=vbum2_word_vbum3
lda {m2}
sta {z1}+1
lda {m3}
sta {z1}
//FRAGMENT vbuz1_ge__deref_pbuc1_then_la1
lda {z1}
cmp {c1}
bcs {la1}
//FRAGMENT vbuz1=vbuz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=_deref_pbuc1_rol_1
lda {c1}
asl
sta {z1}
//FRAGMENT vbuz1=vbuz2_rol_1
lda {z2}
asl
sta {z1}
//FRAGMENT vwuz1=pwuc1_derefidx_vbuz2_plus_vbuz3
lda {z3}
ldy {z2}
clc
adc {c1},y
sta {z1}
lda {c1}+1,y
adc #0
sta {z1}+1
//FRAGMENT _deref_pwuc1=vwuz1
lda {z1}
sta {c1}
lda {z1}+1
sta {c1}+1
//FRAGMENT _deref_pwuc1=pwuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1}
lda {c2}+1,y
sta {c1}+1
//FRAGMENT vwuz1=_deref_pwuc1
lda {c1}
sta {z1}
lda {c1}+1
sta {z1}+1
//FRAGMENT vbuz1=_dec_vbuz1
dec {z1}
//FRAGMENT 0_neq_vbuz1_then_la1
lda {z1}
bne {la1}
//FRAGMENT vwuz1=vwuz1_plus__deref_pwuc1
clc
lda {z1}
adc {c1}
sta {z1}
lda {z1}+1
adc {c1}+1
sta {z1}+1
//FRAGMENT _deref_pwuc1=_deref_pwuc2
lda {c2}
sta {c1}
lda {c2}+1
sta {c1}+1
//FRAGMENT pbuz1=pbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
sta {z1}
//FRAGMENT pbuz1=_inc_pbuz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT _stackpushbyte_=vbuz1
lda {z1}
pha
//FRAGMENT call_vprc1
jsr {c1}
//FRAGMENT _stackpullpadding_1
pla
//FRAGMENT vbum1=_deref_pbuc1
lda {c1}
sta {m1}
//FRAGMENT vbuz1=vbuz2_ror_7
lda {z2}
rol
rol
and #$01
sta {z1}
//FRAGMENT vwuz1=vbuz2_word_vbuc1
lda #{c1}
ldy {z2}
sty {z1}+1
sta {z1}
//FRAGMENT vbuz1=vbuz2_band_vbuc1
lda #{c1}
and {z2}
sta {z1}
//FRAGMENT vbuz1=vbuz2_ror_4
lda {z2}
lsr
lsr
lsr
lsr
sta {z1}
//FRAGMENT _deref_pbuc1=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1}
//FRAGMENT vbuz1=vbuz2_ror_6
lda {z2}
rol
rol
rol
and #$03
sta {z1}
//FRAGMENT vboz1=vbum2_eq_vbuc1
lda {m2}
eor #{c1}
beq !+
lda #1
!:
eor #1
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
//FRAGMENT vbuz1=vbuz2_minus_1
ldx {z2}
dex
stx {z1}
//FRAGMENT vbuz1_lt__deref_pbuc1_then_la1
lda {z1}
cmp {c1}
bcc {la1}
//FRAGMENT pwuc1_derefidx_vbuz1=vwuz2
ldy {z1}
lda {z2}
sta {c1},y
lda {z2}+1
sta {c1}+1,y
//FRAGMENT vbuz1=_inc_vbuz1
inc {z1}
//FRAGMENT _deref_pbuc1_le__deref_pbuc2_then_la1
lda {c2}
cmp {c1}
bcs {la1}
//FRAGMENT 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1
ldy {c2}
lda {c1},y
cmp #0
bne {la1}
//FRAGMENT vbuz1=_deref_pbuc1_plus_1
lda {c1}
inc
sta {z1}
//FRAGMENT vbuz1_le__deref_pbuc1_then_la1
lda {c1}
cmp {z1}
bcs {la1}
//FRAGMENT vbuz1=vbuz2_plus_1
lda {z2}
inc
sta {z1}
//FRAGMENT vwuz1=pwuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
sta {c1}
//FRAGMENT vbuz1=_dec_vbuz2
ldy {z2}
dey
sty {z1}
//FRAGMENT vbuz1=vbuz1_rol_1
asl {z1}
//FRAGMENT vbuz1=vbuz1_band_vbuc1
lda #{c1}
and {z1}
sta {z1}
//FRAGMENT vbuz1=vbuz1_bor_vbuc1
lda #{c1}
ora {z1}
sta {z1}
//FRAGMENT vbuz1=vbuz1_ror_4
lda {z1}
lsr
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuz1=vbuz1_minus_1
dec {z1}
//FRAGMENT vbuz1=vbuz1_ror_6
lda {z1}
rol
rol
rol
and #$03
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
