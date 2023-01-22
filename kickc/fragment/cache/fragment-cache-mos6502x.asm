//KICKC FRAGMENT CACHE 12ee4d6024 12ee4d89e7
//FRAGMENT vbuz1=_deref_pbuc1
lda {c1}
sta {z1}
//FRAGMENT vbuz1_lt_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcc {la1}
//FRAGMENT vbuz1=vbuc1
lda #{c1}
sta {z1}
//FRAGMENT vbuz1=vbuz2
lda {z2}
sta {z1}
//FRAGMENT _deref_pbuc1=vbuc2
lda #{c2}
sta {c1}
//FRAGMENT vbuz1=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
sta {z1}
//FRAGMENT _deref_pbuc1=vbuz1
lda {z1}
sta {c1}
//FRAGMENT vwuz1=vwuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT 0_eq_vbuz1_then_la1
lda {z1}
beq {la1}
//FRAGMENT 0_eq_vwuz1_then_la1
lda {z1}
ora {z1}+1
beq {la1}
//FRAGMENT 0_neq_vbuz1_then_la1
lda {z1}
bne {la1}
//FRAGMENT 0_neq_vwuz1_then_la1
lda {z1}
ora {z1}+1
bne {la1}
//FRAGMENT vwuz1=vbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=_byte0_vwuz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=_byte1_vwuz2
lda {z2}+1
sta {z1}
//FRAGMENT vbuz1=vbuz2_rol_1
lda {z2}
asl
sta {z1}
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
//FRAGMENT vbuz1=vbuz1_plus_1
inc {z1}
//FRAGMENT vbuz1=vbuz2_band_vbuc1
lda #{c1}
and {z2}
sta {z1}
//FRAGMENT vbuz1_neq_vbuc1_then_la1
lda #{c1}
cmp {z1}
bne {la1}
//FRAGMENT vbuz1=_inc_vbuz1
inc {z1}
//FRAGMENT vbuz1=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
sta {z1}
//FRAGMENT pbuz1=pbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT pbuz1_derefidx_vbuz2=vbuc1
lda #{c1}
ldy {z2}
sta ({z1}),y
//FRAGMENT vbum1=vbuc1
lda #{c1}
sta {m1}
//FRAGMENT vbuz1=vbum2
lda {m2}
sta {z1}
//FRAGMENT vbuaa=_deref_pbuc1
lda {c1}
//FRAGMENT vbuxx=_deref_pbuc1
ldx {c1}
//FRAGMENT vbuaa_lt_vbuc1_then_la1
cmp #{c1}
bcc {la1}
//FRAGMENT vbuaa=vbuz1
lda {z1}
//FRAGMENT vbuxx=vbuz1
ldx {z1}
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
//FRAGMENT 0_eq_vbuaa_then_la1
cmp #0
beq {la1}
//FRAGMENT 0_neq_vbuxx_then_la1
cpx #0
bne {la1}
//FRAGMENT vbuaa=_byte0_vwuz1
lda {z1}
//FRAGMENT vbuxx=_byte0_vwuz1
ldx {z1}
//FRAGMENT vbuaa=_byte1_vwuz1
lda {z1}+1
//FRAGMENT vbuxx=_byte1_vwuz1
ldx {z1}+1
//FRAGMENT 0_neq_vbuaa_then_la1
cmp #0
bne {la1}
//FRAGMENT vbuaa=vbuz1_rol_1
lda {z1}
asl
//FRAGMENT vbuxx=vbuz1_rol_1
lda {z1}
asl
tax
//FRAGMENT vbuyy=vbuz1_rol_1
lda {z1}
asl
tay
//FRAGMENT vbuz1=vbuxx_rol_1
txa
asl
sta {z1}
//FRAGMENT vbuaa=vbuxx_rol_1
txa
asl
//FRAGMENT vbuxx=vbuxx_rol_1
txa
asl
tax
//FRAGMENT vbuyy=vbuxx_rol_1
txa
asl
tay
//FRAGMENT vbuz1=vbuyy_rol_1
tya
asl
sta {z1}
//FRAGMENT vbuaa=vbuyy_rol_1
tya
asl
//FRAGMENT vbuxx=vbuyy_rol_1
tya
asl
tax
//FRAGMENT vbuyy=vbuyy_rol_1
tya
asl
tay
//FRAGMENT pbuz1=qbuc1_derefidx_vbuaa
tay
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT pbuz1=qbuc1_derefidx_vbuxx
lda {c1},x
sta {z1}
lda {c1}+1,x
sta {z1}+1
//FRAGMENT pbuz1=qbuc1_derefidx_vbuyy
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT vbuz1=vbuxx_band_vbuc1
lda #{c1}
sax {z1}
//FRAGMENT vbuz1=vbuyy_band_vbuc1
tya
and #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuz1_band_vbuc1
lda #{c1}
and {z1}
//FRAGMENT vbuaa=vbuxx_band_vbuc1
txa
and #{c1}
//FRAGMENT vbuaa=vbuyy_band_vbuc1
tya
and #{c1}
//FRAGMENT vbuxx=vbuz1_band_vbuc1
lda #{c1}
and {z1}
tax
//FRAGMENT vbuxx=vbuxx_band_vbuc1
lda #{c1}
axs #0
//FRAGMENT vbuxx=vbuyy_band_vbuc1
ldx #{c1}
tya
axs #0
//FRAGMENT vbuyy=vbuz1_band_vbuc1
lda #{c1}
and {z1}
tay
//FRAGMENT vbuyy=vbuxx_band_vbuc1
txa
and #{c1}
tay
//FRAGMENT vbuyy=vbuyy_band_vbuc1
tya
and #{c1}
tay
//FRAGMENT vbuaa_neq_vbuc1_then_la1
cmp #{c1}
bne {la1}
//FRAGMENT vbuxx_neq_vbuc1_then_la1
cpx #{c1}
bne {la1}
//FRAGMENT vbuz1=vbuaa
sta {z1}
//FRAGMENT vbuaa=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
//FRAGMENT vbuxx=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
tax
//FRAGMENT vbuyy=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
tay
//FRAGMENT pbuz1_derefidx_vbuaa=vbuc1
tay
lda #{c1}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=vbuc1
txa
tay
lda #{c1}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=vbuc1
lda #{c1}
sta ({z1}),y
//FRAGMENT vbuaa=vbum1
lda {m1}
//FRAGMENT vbuxx=vbum1
ldx {m1}
//FRAGMENT 0_eq_vbuxx_then_la1
cpx #0
beq {la1}
//FRAGMENT vbuxx_lt_vbuc1_then_la1
cpx #{c1}
bcc {la1}
//FRAGMENT vbuxx=vbuc1
ldx #{c1}
//FRAGMENT vbuxx=_inc_vbuxx
inx
//FRAGMENT vbuyy=vbuc1
ldy #{c1}
//FRAGMENT vbuyy_lt_vbuc1_then_la1
cpy #{c1}
bcc {la1}
//FRAGMENT vbuyy=_inc_vbuyy
iny
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
//FRAGMENT 0_eq_vbuyy_then_la1
cpy #0
beq {la1}
//FRAGMENT vbuyy=vbuz1
ldy {z1}
//FRAGMENT _deref_pbuc1=vbuxx
stx {c1}
//FRAGMENT vbuyy=_byte0_vwuz1
ldy {z1}
//FRAGMENT _deref_pbuc1=vbuyy
sty {c1}
//FRAGMENT vbuaa=vbuc1
lda #{c1}
//FRAGMENT vbuyy=_deref_pbuc1
ldy {c1}
//FRAGMENT vbuyy=vbuaa
tay
//FRAGMENT vbuyy=_byte1_vwuz1
ldy {z1}+1
//FRAGMENT 0_neq_vbuyy_then_la1
cpy #0
bne {la1}
//FRAGMENT vbuyy_neq_vbuc1_then_la1
cpy #{c1}
bne {la1}
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
