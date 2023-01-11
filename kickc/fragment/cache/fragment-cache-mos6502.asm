//KICKC FRAGMENT CACHE 139dadd546 139dadfeaf
//FRAGMENT vbuz1=vbuc1
lda #{c1}
sta {z1}
//FRAGMENT vbum1=vbuc1
lda #{c1}
sta {m1}
//FRAGMENT isr_rom_sys_cx16_entry

//FRAGMENT _deref_pbuc1=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
sta {c1}
//FRAGMENT _deref_pbuc1=vbuc2
lda #{c2}
sta {c1}
//FRAGMENT pvoz1=pvoc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vwuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vbum1=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
sta {m1}
//FRAGMENT 0_neq_vbum1_then_la1
lda {m1}
bne {la1}
//FRAGMENT _deref_pbuc1=_inc__deref_pbuc1
inc {c1}
//FRAGMENT isr_rom_sys_cx16_exit
jmp $E361
//FRAGMENT vwuz1=vwuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwum1=vwuz2
lda {z2}
sta {m1}
lda {z2}+1
sta {m1}+1
//FRAGMENT vbum1=_byte1_vwum2
lda {m2}+1
sta {m1}
//FRAGMENT _deref_pbuc1=vbum1
lda {m1}
sta {c1}
//FRAGMENT vbum1=_byte0_vwum2
lda {m2}
sta {m1}
//FRAGMENT vbuz1=_deref_pbuc1
lda {c1}
sta {z1}
//FRAGMENT vbuz1=_stackidxbyte_vbuc1
tsx
lda STACK_BASE+{c1},x
sta {z1}
//FRAGMENT vbuz1_eq_vbuc1_then_la1
lda #{c1}
cmp {z1}
beq {la1}
//FRAGMENT vbum1=_byte0__deref_pwuc1
lda {c1}
sta {m1}
//FRAGMENT vbum1=_byte1__deref_pwuc1
lda {c1}+1
sta {m1}
//FRAGMENT vbum1=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
sta {m1}
//FRAGMENT _deref_pbuc1=vbuz1
lda {z1}
sta {c1}
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
//FRAGMENT _deref_pwuc1=_inc__deref_pwuc1
inc {c1}
bne !+
inc {c1}+1
!:
//FRAGMENT vwum1=vbuc1
lda #<{c1}
sta {m1}
lda #>{c1}
sta {m1}+1
//FRAGMENT vdum1=vwuc1
NO_SYNTHESIS
//FRAGMENT vdum1=vwsc1
NO_SYNTHESIS
//FRAGMENT vdum1=vduc1
lda #<{c1}
sta {m1}
lda #>{c1}
sta {m1}+1
lda #<{c1}>>$10
sta {m1}+2
lda #>{c1}>>$10
sta {m1}+3
//FRAGMENT pssz1=pssc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vwum1=vwuc1
lda #<{c1}
sta {m1}
lda #>{c1}
sta {m1}+1
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
sta {c1}
//FRAGMENT vbuz1=vbuz2
lda {z2}
sta {z1}
//FRAGMENT vbum1=vbuz2
lda {z2}
sta {m1}
//FRAGMENT 0_eq_vbum1_then_la1
lda {m1}
beq {la1}
//FRAGMENT _deref_qprc1=pprc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT vwuz1_le_0_then_la1
lda {z1}
bne !+
lda {z1}+1
beq {la1}
!:
//FRAGMENT pbuz1=pbuz2_plus_vwuz3
lda {z2}
clc
adc {z3}
sta {z1}
lda {z2}+1
adc {z3}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT pbuz1_neq_pbuz2_then_la1
lda {z1}+1
cmp {z2}+1
bne {la1}
lda {z1}
cmp {z2}
bne {la1}
//FRAGMENT _deref_pbuz1=vbuz2
lda {z2}
ldy #0
sta ({z1}),y
//FRAGMENT pbuz1=_inc_pbuz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vwsz1=vwsc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT _deref_pwsc1=_deref_pwsc2
lda {c2}
sta {c1}
lda {c2}+1
sta {c1}+1
//FRAGMENT _deref_pwsc1=vwsz1
lda {z1}
sta {c1}
lda {z1}+1
sta {c1}+1
//FRAGMENT _deref_pwuc1_ge__deref_pbuc2_then_la1
lda {c1}+1
bne {la1}
lda {c1}
cmp {c2}
bcs {la1}
!:
//FRAGMENT vbum1_lt_vbuc1_then_la1
lda {m1}
cmp #{c1}
bcc {la1}
//FRAGMENT _deref_pwuc1_lt__deref_pwuc2_then_la1
lda {c1}+1
cmp {c2}+1
bcc {la1}
bne !+
lda {c1}
cmp {c2}
bcc {la1}
!:
//FRAGMENT pssz1=_deref_qssc1
lda {c1}
sta {z1}
lda {c1}+1
sta {z1}+1
//FRAGMENT vwum1=_deref_pwuc1_rol_1
lda {c1}
asl
sta {m1}
lda {c1}+1
rol
sta {m1}+1
//FRAGMENT vwum1=vwum2_plus__deref_pwuc1
lda {m2}
clc
adc {c1}
sta {m1}
lda {m2}+1
adc {c1}+1
sta {m1}+1
//FRAGMENT pbuz1=pbuz2_plus_vwum3
lda {m3}
clc
adc {z2}
sta {z1}
lda {m3}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT _deref_pwuc1=_deref_pbuz1
ldy #0
lda ({z1}),y
sta {c1}
lda #0
sta {c1}+1
//FRAGMENT _deref_pwuc1=vbuc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT 0_eq__deref_pbuc1_then_la1
lda {c1}
beq {la1}
//FRAGMENT _deref_pbuc1=_dec__deref_pbuc1
dec {c1}
//FRAGMENT 0_neq__deref_pbuc1_then_la1
lda {c1}
bne {la1}
//FRAGMENT 0_eq_pbuc1_derefidx_vbum1_then_la1
ldy {m1}
lda {c1},y
cmp #0
beq {la1}
//FRAGMENT vbum1=vbum2_rol_1
lda {m2}
asl
sta {m1}
//FRAGMENT vwum1=pwuc1_derefidx_vbum2
ldy {m2}
lda {c1},y
sta {m1}
lda {c1}+1,y
sta {m1}+1
//FRAGMENT vwum1_lt__deref_pwuc1_then_la1
lda {m1}+1
cmp {c1}+1
bcc {la1}
bne !+
lda {m1}
cmp {c1}
bcc {la1}
!:
//FRAGMENT pbuc1_derefidx_vbum1=vbuc2
lda #{c2}
ldy {m1}
sta {c1},y
//FRAGMENT vbum1=_inc_vbum1
inc {m1}
//FRAGMENT qssz1=qssz2_plus_1
clc
lda {z2}
adc #1
sta {z1}
lda {z2}+1
adc #0
sta {z1}+1
//FRAGMENT qssz1=qssz2_plus_vwum3
lda {z2}
clc
adc {m3}
sta {z1}
lda {z2}+1
adc {m3}+1
sta {z1}+1
//FRAGMENT pssz1=_deref_qssz2
ldy #0
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT vwum1=vwum2_rol_1
lda {m2}
asl
sta {m1}
lda {m2}+1
rol
sta {m1}+1
//FRAGMENT vwum1=vwum2_plus_vwum3
lda {m2}
clc
adc {m3}
sta {m1}
lda {m2}+1
adc {m3}+1
sta {m1}+1
//FRAGMENT pbuz1=pbuz2_plus_vbuc1
lda #{c1}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT vwum1=_word__deref_pbuz2
ldy #0
lda ({z2}),y
sta {m1}
lda #0
sta {m1}+1
//FRAGMENT vwum1_neq_vwum2_then_la1
lda {m1}+1
cmp {m2}+1
bne {la1}
lda {m1}
cmp {m2}
bne {la1}
//FRAGMENT vwum1=_deref_pwuc1_plus_1
clc
lda {c1}
adc #1
sta {m1}
lda {c1}+1
adc #0
sta {m1}+1
//FRAGMENT vbum1=vwum2_band_vbuc1
lda #{c1}
and {m2}
sta {m1}
//FRAGMENT _deref_pwuc1=vbum1
lda {m1}
sta {c1}
lda #0
sta {c1}+1
//FRAGMENT vbum1=_deref_pwuc1
lda {c1}
sta {m1}
//FRAGMENT vwum1=vwum2
lda {m2}
sta {m1}
lda {m2}+1
sta {m1}+1
//FRAGMENT vwum1=_inc_vwum1
inc {m1}
bne !+
inc {m1}+1
!:
//FRAGMENT pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1
ldx {m1}
dec {c1},x
//FRAGMENT 0_neq_pbuc1_derefidx_vbum1_then_la1
ldy {m1}
lda {c1},y
cmp #0
bne {la1}
//FRAGMENT pssz1=qssc1_derefidx_vbum2
ldy {m2}
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT vbum1=vbum2
lda {m2}
sta {m1}
//FRAGMENT pssz1=pssz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwsm1=pwsc1_derefidx_vbum2
ldy {m2}
lda {c1},y
sta {m1}
lda {c1}+1,y
sta {m1}+1
//FRAGMENT pwsc1_derefidx_vbum1=pwsc1_derefidx_vbum1_plus_pbsc2_derefidx_vbum2
ldx {m1}
ldy {m2}
lda {c2},y
sta $ff
clc
adc {c1},x
sta {c1},x
iny
lda $ff
ora #$7f
bmi !+
lda #0
!:
adc {c1}+1,x
sta {c1}+1,x
//FRAGMENT pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum1
ldy {m1}
lda {c2},y
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_minus_vbuc2
ldy {m1}
lda {c1},y
sec
sbc #{c2}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbum1_le_0_then_la1
ldy {m1}
lda {c1},y
cmp #0
beq {la1}
//FRAGMENT _deref_pwsc1_ge__deref_pwsc2_then_la1
lda {c1}
cmp {c2}
lda {c1}+1
sbc {c2}+1
bvc !+
eor #$80
!:
bpl {la1}
//FRAGMENT pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_minus_1
ldy {m1}
lda {c1},y
sec
sbc #1
sta {c1},y
//FRAGMENT _deref_pwsc1_le__deref_pwsc2_then_la1
lda {c2}
cmp {c1}
lda {c2}+1
sbc {c1}+1
bvc !+
eor #$80
!:
bpl {la1}
//FRAGMENT pbuc1_derefidx_vbum1_ge_vbuc2_then_la1
ldy {m1}
lda {c1},y
cmp #{c2}
bcs {la1}
//FRAGMENT pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_plus_1
ldy {m1}
lda {c1},y
clc
adc #1
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbum1_neq_vbuc2_then_la1
lda #{c2}
ldy {m1}
cmp {c1},y
bne {la1}
//FRAGMENT pbuc1_derefidx_vbum1_lt_vbuc2_then_la1
ldy {m1}
lda {c1},y
cmp #{c2}
bcc {la1}
//FRAGMENT vbum1=pbuc1_derefidx_vbum2
ldy {m2}
lda {c1},y
sta {m1}
//FRAGMENT pbuc1_derefidx_vbum1=_inc_pbuc1_derefidx_vbum1
ldx {m1}
inc {c1},x
//FRAGMENT pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_band_vbuc2
lda #{c2}
ldy {m1}
and {c1},y
sta {c1},y
//FRAGMENT _deref_pbuc1_neq_vbuc2_then_la1
lda #{c2}
cmp {c1}
bne {la1}
//FRAGMENT vdum1=_deref_pwuc1_dword_vbuc2
lda {c1}
sta {m1}+2
lda {c1}+1
sta {m1}+3
lda #{c2}
sta {m1}
lda #0
sta {m1}+1
//FRAGMENT vbum1=vbum2_rol_2
lda {m2}
asl
asl
sta {m1}
//FRAGMENT pduc1_derefidx_vbum1=vdum2
ldy {m1}
lda {m2}
sta {c1},y
lda {m2}+1
sta {c1}+1,y
lda {m2}+2
sta {c1}+2,y
lda {m2}+3
sta {c1}+3,y
//FRAGMENT vwum1=_word1_pduc1_derefidx_vbum2
ldy {m2}
lda {c1}+2,y
sta {m1}
lda {c1}+3,y
sta {m1}+1
//FRAGMENT vwsm1_le_vbsc1_then_la1
NO_SYNTHESIS
//FRAGMENT vwsm1_le_vwsc1_then_la1
lda #<{c1}
cmp {m1}
lda #>{c1}
sbc {m1}+1
bvc !+
eor #$80
!:
bpl {la1}
//FRAGMENT vwsm1_lt_vwsc1_then_la1
lda {m1}
cmp #<{c1}
lda {m1}+1
sbc #>{c1}
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vwum1=vwum2_plus_vbuc1
lda #{c1}
clc
adc {m2}
sta {m1}
lda #0
adc {m2}+1
sta {m1}+1
//FRAGMENT vwsm1=vwsm2_ror_2
lda {m2}+1
cmp #$80
ror
sta {m1}+1
lda {m2}
ror
sta {m1}
lda {m1}+1
cmp #$80
ror {m1}+1
ror {m1}
//FRAGMENT vbum1=_byte0_vwsm2
lda {m2}
sta {m1}
//FRAGMENT vbum1=vbum2_bor_vbum3
lda {m2}
ora {m3}
sta {m1}
//FRAGMENT vbum1=_byte1_vwsm2
lda {m2}+1
sta {m1}
//FRAGMENT vwsm1=vwsm2_plus_vbsc1
lda {m2}
clc
adc #<{c1}
sta {m1}
lda {m2}+1
adc #>{c1}
sta {m1}+1
//FRAGMENT pduc1_derefidx_vbum1=pduc1_derefidx_vbum1_plus_pduc2_derefidx_vbum1
ldy {m1}
lda {c1},y
clc
adc {c2},y
sta {c1},y
lda {c1}+1,y
adc {c2}+1,y
sta {c1}+1,y
lda {c1}+2,y
adc {c2}+2,y
sta {c1}+2,y
lda {c1}+3,y
adc {c2}+3,y
sta {c1}+3,y
//FRAGMENT pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_plus_pbsc2_derefidx_vbum1
ldx {m1}
lda {c1},x
ldy {c2},x
sty $ff
clc
adc $ff
sta {c1},x
//FRAGMENT pbsc1_derefidx_vbum1_le_0_then_la1
ldy {m1}
lda {c1},y
cmp #1
bmi {la1}
//FRAGMENT pbuc1_derefidx_vbum1_lt_pbuc2_derefidx_vbum1_then_la1
ldy {m1}
lda {c1},y
cmp {c2},y
bcc {la1}
//FRAGMENT pbsc1_derefidx_vbum1_ge_0_then_la1
ldy {m1}
lda {c1},y
cmp #0
bpl {la1}
//FRAGMENT pbuc1_derefidx_vbum1_gt_pbuc2_derefidx_vbum1_then_la1
ldy {m1}
lda {c2},y
cmp {c1},y
bcc {la1}
//FRAGMENT pbsc1_derefidx_vbum1=vbsc2
lda #{c2}
ldy {m1}
sta {c1},y
//FRAGMENT vwsm1_lt_vbsc1_then_la1
NO_SYNTHESIS
//FRAGMENT vwsm1_gt_vwsc1_then_la1
lda #<{c1}
cmp {m1}
lda #>{c1}
sbc {m1}+1
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vbum1=pbuc1_derefidx_(pbuc2_derefidx_vbum2)
ldx {m2}
ldy {c2},x
ldx {c1},y
stx {m1}
//FRAGMENT pbuc1_derefidx_vbum1_eq_vbuc2_then_la1
ldy {m1}
lda {c1},y
cmp #{c2}
beq {la1}
//FRAGMENT 0_eq_pwuc1_derefidx_vbum1_then_la1
ldy {m1}
lda {c1},y
ora {c1}+1,y
beq {la1}
//FRAGMENT pwuc1_derefidx_vbum1=_dec_pwuc1_derefidx_vbum1
ldx {m1}
lda {c1},x
bne !+
dec {c1}+1,x
!:
dec {c1},x
//FRAGMENT vbum1=vbum2_band_vbuc1
lda #{c1}
and {m2}
sta {m1}
//FRAGMENT vwsm1=vwsm1_rol_vbum2
ldy {m2}
beq !e+
!:
asl {m1}
rol {m1}+1
dey
bne !-
!e:
//FRAGMENT vdum1=_dword_vwsm2
lda {m2}
sta {m1}
lda {m2}+1
sta {m1}+1
ora #$7f
bmi !+
lda #0
!:
sta {m1}+2
sta {m1}+3
//FRAGMENT vdum1=vdum2_rol_8
lda #0
sta {m1}
lda {m2}
sta {m1}+1
lda {m2}+1
sta {m1}+2
lda {m2}+2
sta {m1}+3
//FRAGMENT pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_plus_pbuc2_derefidx_vbum1
ldy {m1}
lda {c1},y
clc
adc {c2},y
sta {c1},y
//FRAGMENT vwum1_lt_vwuc1_then_la1
lda {m1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {m1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT pvoz1=qvoz2_derefidx_vbum3
ldy {m3}
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT vbum1=pbuz2_derefidx_vbum3
ldy {m3}
lda ({z2}),y
sta {m1}
//FRAGMENT vbum1_eq_vbuc1_then_la1
lda #{c1}
cmp {m1}
beq {la1}
//FRAGMENT pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_plus_vbuc2
lda #{c2}
ldy {m1}
clc
adc {c1},y
sta {c1},y
//FRAGMENT vbsm1=_deref_pbsz2
ldy #0
lda ({z2}),y
sta {m1}
//FRAGMENT vbum1=pbuz2_derefidx_vbuc1
ldy #{c1}
lda ({z2}),y
sta {m1}
//FRAGMENT pbuc1_derefidx_vbum1=vbum2
lda {m2}
ldy {m1}
sta {c1},y
//FRAGMENT vwum1=_deref_pwuz2
ldy #0
lda ({z2}),y
sta {m1}
iny
lda ({z2}),y
sta {m1}+1
//FRAGMENT vbsm1=pbsz2_derefidx_vbuc1
ldy #{c1}
lda ({z2}),y
sta {m1}
//FRAGMENT vbum1=vbum1_plus_vbuc1
lda #{c1}
clc
adc {m1}
sta {m1}
//FRAGMENT vbuz1=vbum2_plus_vbuc1
lda #{c1}
clc
adc {m2}
sta {z1}
//FRAGMENT vbuz1=vbum2_band_vbuc1
lda #{c1}
and {m2}
sta {z1}
//FRAGMENT 0_neq_pbuc1_derefidx_vbuz1_then_la1
ldy {z1}
lda {c1},y
cmp #0
bne {la1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbum2
ldy {m2}
lda {c1},y
sta {z1}
//FRAGMENT 0_eq_pbuc1_derefidx_vbuz1_then_la1
ldy {z1}
lda {c1},y
cmp #0
beq {la1}
//FRAGMENT vbum1=vbuz2_rol_2
lda {z2}
asl
asl
sta {m1}
//FRAGMENT vbum1=pbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {m1}
//FRAGMENT vbum1=vbum2_rol_4
lda {m2}
asl
asl
asl
asl
sta {m1}
//FRAGMENT pbuc1_derefidx_vbuz1_neq_vbuc2_then_la1
lda #{c2}
ldy {z1}
cmp {c1},y
bne {la1}
//FRAGMENT vbuz1=vbum2
lda {m2}
sta {z1}
//FRAGMENT 0_neq_vbuz1_then_la1
lda {z1}
bne {la1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
//FRAGMENT vwsm1=vwsm2_plus_pbuc1_derefidx_vbum3
ldy {m3}
lda {c1},y
clc
adc {m2}
sta {m1}
lda {m2}+1
adc #0
sta {m1}+1
//FRAGMENT vwsm1_gt_vwsm2_then_la1
lda {m2}
cmp {m1}
lda {m2}+1
sbc {m1}+1
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vwsm1_lt_vwsm2_then_la1
lda {m1}
cmp {m2}
lda {m1}+1
sbc {m2}+1
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz1
ldy {z1}
lda {c1},y
sta {z1}
//FRAGMENT pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_plus_vbum2
lda {m2}
ldy {m1}
clc
adc {c1},y
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1_neq_vbuz2_then_la1
lda {z2}
ldy {z1}
cmp {c1},y
bne {la1}
//FRAGMENT vbum1=vbum2_bor_vbuc1
lda #{c1}
ora {m2}
sta {m1}
//FRAGMENT vbum1=vbuz2_rol_4
lda {z2}
asl
asl
asl
asl
sta {m1}
//FRAGMENT vwuz1=vbuz2_word_vbuz3
lda {z2}
sta {z1}+1
lda {z3}
sta {z1}
//FRAGMENT vbuz1_ge__deref_pbuc1_then_la1
lda {z1}
cmp {c1}
bcs {la1}
//FRAGMENT vbum1=_deref_pbuc1
lda {c1}
sta {m1}
//FRAGMENT vbum1=_deref_pbuc1_rol_1
lda {c1}
asl
sta {m1}
//FRAGMENT vbum1=vbuz2_rol_1
lda {z2}
asl
sta {m1}
//FRAGMENT vwum1=pwuc1_derefidx_vbum2_plus_vbum3
lda {m3}
ldy {m2}
clc
adc {c1},y
sta {m1}
lda {c1}+1,y
adc #0
sta {m1}+1
//FRAGMENT _deref_pwuc1=vwum1
lda {m1}
sta {c1}
lda {m1}+1
sta {c1}+1
//FRAGMENT _deref_pwuc1=pwuc2_derefidx_vbum1
ldy {m1}
lda {c2},y
sta {c1}
lda {c2}+1,y
sta {c1}+1
//FRAGMENT pbuc1_derefidx_(_deref_pbuc2)=vbuz1
lda {z1}
ldy {c2}
sta {c1},y
//FRAGMENT _deref_pwuc1=vwuc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT pvoz1=pvoz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vwum1=_deref_pwuc1
lda {c1}
sta {m1}
lda {c1}+1
sta {m1}+1
//FRAGMENT 0_eq__deref_pwuc1_then_la1
lda {c1}
ora {c1}+1
beq {la1}
//FRAGMENT pwuz1_derefidx_vbuc1=vwum2
ldy #{c1}
lda {m2}
sta ({z1}),y
iny
lda {m2}+1
sta ({z1}),y
//FRAGMENT vdum1=vdum2
lda {m2}
sta {m1}
lda {m2}+1
sta {m1}+1
lda {m2}+2
sta {m1}+2
lda {m2}+3
sta {m1}+3
//FRAGMENT pduz1_derefidx_vbuc1=vdum2
ldy #{c1}
lda {m2}
sta ({z1}),y
iny
lda {m2}+1
sta ({z1}),y
iny
lda {m2}+2
sta ({z1}),y
iny
lda {m2}+3
sta ({z1}),y
//FRAGMENT pwuz1_derefidx_vbuc1=vbuc2
lda #{c2}
ldy #{c1}
sta ({z1}),y
lda #0
iny
sta ({z1}),y
//FRAGMENT vwum1=pwuz2_derefidx_vbuc1
ldy #{c1}
lda ({z2}),y
sta {m1}
iny
lda ({z2}),y
sta {m1}+1
//FRAGMENT qssc1_derefidx_vbum1=pssz2
ldy {m1}
lda {z2}
sta {c1},y
lda {z2}+1
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbum1=vwum2
ldy {m1}
lda {m2}
sta {c1},y
lda {m2}+1
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbum1=vbuc2
lda #{c2}
ldy {m1}
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT vwum1=vwum2_minus_pwuc1_derefidx_vbum3
ldy {m3}
lda {m2}
sec
sbc {c1},y
sta {m1}
lda {m2}+1
sbc {c1}+1,y
sta {m1}+1
//FRAGMENT vwum1=pwuc1_derefidx_vbum2_minus_pwuc2_derefidx_vbum2
ldy {m2}
lda {c1},y
sec
sbc {c2},y
sta {m1}
lda {c1}+1,y
sbc {c2}+1,y
sta {m1}+1
//FRAGMENT pbuc1_derefidx_vbum1=vbum1
ldy {m1}
tya
sta {c1},y
//FRAGMENT pwuc1_derefidx_vbum1=_inc_pwuc1_derefidx_vbum1
ldx {m1}
inc {c1},x
bne !+
inc {c1}+1,x
!:
//FRAGMENT vwum1_lt_vbuc1_then_la1
lda {m1}+1
bne !+
lda {m1}
cmp #{c1}
bcc {la1}
!:
//FRAGMENT vwum1=vwum2_rol_5
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
//FRAGMENT pwuz1=pwuc1_plus_vwum2
lda {m2}
clc
adc #<{c1}
sta {z1}
lda {m2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT _deref_pwuz1=vwuz2
ldy #0
lda {z2}
sta ({z1}),y
iny
lda {z2}+1
sta ({z1}),y
//FRAGMENT _deref_pbuz1=vbuc1
lda #{c1}
ldy #0
sta ({z1}),y
//FRAGMENT pbuz1=_deref_qbuc1
lda {c1}
sta {z1}
lda {c1}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT pssc1_neq_pssz1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT vwum1=vbum2
lda {m2}
sta {m1}
lda #0
sta {m1}+1
//FRAGMENT vbum1=vwum2
lda {m2}
sta {m1}
//FRAGMENT vwum1=vbuz2
lda {z2}
sta {m1}
lda #0
sta {m1}+1
//FRAGMENT pprz1=pprc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vwum2
lda {m2}
sta {z1}
lda {m2}+1
sta {z1}+1
//FRAGMENT vwuz1=_deref_pwuc1
lda {c1}
sta {z1}
lda {c1}+1
sta {z1}+1
//FRAGMENT vbum1=_byte0_vwuz2
lda {z2}
sta {m1}
//FRAGMENT vbum1=_byte1_vwuz2
lda {z2}+1
sta {m1}
//FRAGMENT vbuz1=_dec_vbuz1
dec {z1}
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
//FRAGMENT _deref_qssc1=pssc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT pduc1_derefidx_vbum1=vduc2
ldy {m1}
lda #<{c2}
sta {c1},y
lda #>{c2}
sta {c1}+1,y
lda #<{c2}>>$10
sta {c1}+2,y
lda #>{c2}>>$10
sta {c1}+3,y
//FRAGMENT pduc1_derefidx_vbum1=vbuc2
ldy {m1}
lda #{c2}
sta {c1},y
lda #0
sta {c1}+1,y
sta {c1}+2,y
sta {c1}+3,y
//FRAGMENT vbum1=vbum2_plus_1
ldy {m2}
iny
sty {m1}
//FRAGMENT 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1
ldy {c2}
lda {c1},y
cmp #0
bne {la1}
//FRAGMENT pbsz1=pbsz2_plus_vbuc1
lda #{c1}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT pbsz1=pbsz2_plus_vwum3
lda {m3}
clc
adc {z2}
sta {z1}
lda {m3}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT pbsc1_derefidx_vbum1=_deref_pbsz2
ldy #0
lda ({z2}),y
ldy {m1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbum1=_deref_pbuz2
ldy #0
lda ({z2}),y
ldy {m1}
sta {c1},y
//FRAGMENT qssz1=qssz2_plus_vbuc1
lda #{c1}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT qssc1_derefidx_vbum1=_deref_qssz2
ldx {m1}
ldy #$00
lda ({z2}),y
sta {c1},x
iny
lda ({z2}),y
sta {c1}+1,x
//FRAGMENT pbuz1=pbuz2_plus_1
clc
lda {z2}
adc #1
sta {z1}
lda {z2}+1
adc #0
sta {z1}+1
//FRAGMENT pwsz1=pwsz2_plus_vbuc1
lda #{c1}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT pwsz1=pwsz2_plus_vwum3
lda {m3}
clc
adc {z2}
sta {z1}
lda {m3}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT pwsc1_derefidx_vbum1=_deref_pwsz2
ldx {m1}
ldy #0
lda ({z2}),y
sta {c1},x
iny
lda ({z2}),y
sta {c1}+1,x
//FRAGMENT pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2
ldy {m2}
lda {c2},y
ldy {m1}
sta {c1},y
//FRAGMENT vbum1=pbuc1_derefidx_vbum2_minus_1
ldy {m2}
ldx {c1},y
dex
stx {m1}
//FRAGMENT vdum1=vwum2_dword_vbuc1
lda {m2}
sta {m1}+2
lda {m2}+1
sta {m1}+3
lda #{c1}
sta {m1}
lda #0
sta {m1}+1
//FRAGMENT _deref_pbuc1_ge_vbuc2_then_la1
lda {c1}
cmp #{c2}
bcs {la1}
//FRAGMENT vwum1=_deref_pwuc1_plus_vbsc2
lda #{c2}
sta $ff
clc
adc {c1}
sta {m1}
lda $ff
ora #$7f
bmi !+
lda #0
!:
adc {c1}+1
sta {m1}+1
//FRAGMENT vbum1=pbuc1_derefidx_vbum2_bxor_vbuc2
lda #{c2}
ldy {m2}
eor {c1},y
sta {m1}
//FRAGMENT vbum1=vbum2_plus_vbuc1
lda #{c1}
clc
adc {m2}
sta {m1}
//FRAGMENT vbum1=vbum2_ror_4
lda {m2}
lsr
lsr
lsr
lsr
sta {m1}
//FRAGMENT vbum1_le_vbum2_then_la1
lda {m2}
cmp {m1}
bcs {la1}
//FRAGMENT vbuz1=vbum2_plus_vbum3
lda {m2}
clc
adc {m3}
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=vbuz2
lda {z2}
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbum1=vbuz2
lda {z2}
ldy {m1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=vbum2
lda {m2}
ldy {z1}
sta {c1},y
//FRAGMENT vbum1=_dec_vbum1
dec {m1}
//FRAGMENT vbum1_neq_vbuc1_then_la1
lda #{c1}
cmp {m1}
bne {la1}
//FRAGMENT vbom1=vbom2
lda {m2}
sta {m1}
//FRAGMENT vbom1_then_la1
lda {m1}
cmp #0
bne {la1}
//FRAGMENT vwum1_neq_vwuc1_then_la1
lda {m1}+1
cmp #>{c1}
bne {la1}
lda {m1}
cmp #<{c1}
bne {la1}
//FRAGMENT vdum1=_dword_pwuc1_derefidx_vbum2
ldy {m2}
lda {c1},y
sta {m1}
iny
lda {c1},y
sta {m1}+1
lda #0
sta {m1}+2
sta {m1}+3
//FRAGMENT vbum1=_deref_pbuz2_ror_5
ldy #0
lda ({z2}),y
lsr
lsr
lsr
lsr
lsr
sta {m1}
//FRAGMENT vwum1=_deref_pbuz2_word__deref_pbuz3
ldy #0
lda ({z3}),y
sta {m1}
lda ({z2}),y
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
//FRAGMENT vbum1=vbum2_ror_2
lda {m2}
lsr
lsr
sta {m1}
//FRAGMENT vwum1=vwum2_band_vwuc1
lda {m2}
and #<{c1}
sta {m1}
lda {m2}+1
and #>{c1}
sta {m1}+1
//FRAGMENT vwuz1=vwum2_bor_vwuc1
lda {m2}
ora #<{c1}
sta {z1}
lda {m2}+1
ora #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbum2
ldy {m2}
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT vwum1=vwum2_ror_5
lda {m2}+1
lsr
sta {m1}+1
lda {m2}
ror
sta {m1}
lsr {m1}+1
ror {m1}
lsr {m1}+1
ror {m1}
lsr {m1}+1
ror {m1}
lsr {m1}+1
ror {m1}
//FRAGMENT vwum1=_word_vbum2
lda {m2}
sta {m1}
lda #0
sta {m1}+1
//FRAGMENT vwum1=vwum2_rol_vbuc1
ldy #{c1}
lda {m2}
sta {m1}
lda {m2}+1
sta {m1}+1
cpy #0
beq !e+
!:
asl {m1}
rol {m1}+1
dey
bne !-
!e:
//FRAGMENT vwum1=vwum2_bor_vwum3
lda {m2}
ora {m3}
sta {m1}
lda {m2}+1
ora {m3}+1
sta {m1}+1
//FRAGMENT vwum1=pbuc1_derefidx_(pbuc2_derefidx_vbum2)
ldx {m2}
ldy {c2},x
lda {c1},y
sta {m1}
lda #0
sta {m1}+1
//FRAGMENT vwum1=vwum2_rol_7
lda {m2}+1
lsr
lda {m2}
ror
sta {m1}+1
lda #0
ror
sta {m1}
//FRAGMENT vwum1=vwum1_bxor_vwum2
lda {m1}
eor {m2}
sta {m1}
lda {m1}+1
eor {m2}+1
sta {m1}+1
//FRAGMENT vwum1=vwum2_ror_9
lda {m2}+1
lsr
sta {m1}
lda #0
sta {m1}+1
//FRAGMENT vwum1=vwum2_rol_8
lda {m2}
sta {m1}+1
lda #0
sta {m1}
//FRAGMENT vwum1=vwum2_ror_2
lda {m2}+1
lsr
sta {m1}+1
lda {m2}
ror
sta {m1}
lsr {m1}+1
ror {m1}
//FRAGMENT vwum1=_deref_pwuc1_ror_2
lda {c1}+1
lsr
sta {m1}+1
lda {c1}
ror
sta {m1}
lsr {m1}+1
ror {m1}
//FRAGMENT vbum1=vbum2_minus_vbuc1
lda {m2}
sec
sbc #{c1}
sta {m1}
//FRAGMENT vwsm1=vwsm2_rol_vbuc1
ldy #{c1}
lda {m2}
sta {m1}
lda {m2}+1
sta {m1}+1
cpy #0
beq !e+
!:
asl {m1}
rol {m1}+1
dey
bne !-
!e:
//FRAGMENT vbum1=vbum2_minus_1
ldx {m2}
dex
stx {m1}
//FRAGMENT vwum1=vwum1_ror_vbum2
ldy {m2}
!:
lsr {m1}+1
ror {m1}
dey
bne !-
!e:
//FRAGMENT vbum1=pbuc1_derefidx_vbum2_plus_vbum3
lda {m3}
ldy {m2}
clc
adc {c1},y
sta {m1}
//FRAGMENT pbsc1_derefidx_vbum1=pbsc1_derefidx_vbum1_plus_pbsc2_derefidx_vbum2
ldy {m2}
lda {c2},y
ldy {m1}
clc
adc {c1},y
sta {c1},y
//FRAGMENT pbsc1_derefidx_vbum1_gt_0_then_la1
ldy {m1}
lda {c1},y
cmp #0
beq !+
bpl {la1}
!:
//FRAGMENT vbum1=vbuz2_ror_7
lda {z2}
rol
rol
and #$01
sta {m1}
//FRAGMENT vwum1=vbum2_word_vbuc1
lda #{c1}
ldy {m2}
sty {m1}+1
sta {m1}
//FRAGMENT vbum1=vbuz2_band_vbuc1
lda #{c1}
and {z2}
sta {m1}
//FRAGMENT _deref_pbuc1=pbuc2_derefidx_vbum1
ldy {m1}
lda {c2},y
sta {c1}
//FRAGMENT vbum1=vbum2_ror_6
lda {m2}
rol
rol
rol
and #$03
sta {m1}
//FRAGMENT vbom1=vbum2_eq_vbuc1
lda {m2}
eor #{c1}
beq !+
lda #1
!:
eor #1
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
//FRAGMENT vbuz1_lt__deref_pbuc1_then_la1
lda {z1}
cmp {c1}
bcc {la1}
//FRAGMENT pwuc1_derefidx_vbum1=vwuz2
ldy {m1}
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
//FRAGMENT _deref_pbuc1=_deref_pbuc1
lda {c1}
sta {c1}
//FRAGMENT vdum1=vdum2_ror_3
lda {m2}+3
lsr
sta {m1}+3
lda {m2}+2
ror
sta {m1}+2
lda {m2}+1
ror
sta {m1}+1
lda {m2}
ror
sta {m1}
lsr {m1}+3
ror {m1}+2
ror {m1}+1
ror {m1}
lsr {m1}+3
ror {m1}+2
ror {m1}+1
ror {m1}
//FRAGMENT vwum1=_word_vdum2
lda {m2}
sta {m1}
lda {m2}+1
sta {m1}+1
//FRAGMENT vbum1=vbum2_rol_5
lda {m2}
asl
asl
asl
asl
asl
sta {m1}
//FRAGMENT vwum1=vwum2_ror_3
lda {m2}+1
lsr
sta {m1}+1
lda {m2}
ror
sta {m1}
lsr {m1}+1
ror {m1}
lsr {m1}+1
ror {m1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_plus_1
inc {c1}
//FRAGMENT vbum1=pbuc1_derefidx_vbum2_band_vbuc2
lda #{c2}
ldy {m2}
and {c1},y
sta {m1}
//FRAGMENT pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_band_vbum2
lda {m2}
ldy {m1}
and {c1},y
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_bor_vbuc2
lda #{c2}
ldy {m1}
ora {c1},y
sta {c1},y
//FRAGMENT vbuz1=pbuz2_derefidx_vbuc1
ldy #{c1}
lda ({z2}),y
sta {z1}
//FRAGMENT vwuz1=pwuz2_derefidx_vbuc1
ldy #{c1}
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT 0_eq_vwum1_then_la1
lda {m1}
ora {m1}+1
beq {la1}
//FRAGMENT vbum1_lt_pbuz2_derefidx_vbuc1_then_la1
ldy #{c1}
lda ({z2}),y

cmp {m1}
beq !+
bcs {la1}
!:
//FRAGMENT _stackpushbyte_=vbuc1
lda #{c1}
pha
//FRAGMENT call_vprc1
jsr {c1}
//FRAGMENT _stackpullpadding_1
pla
//FRAGMENT _deref_pwuz1=vwum2
ldy #0
lda {m2}
sta ({z1}),y
iny
lda {m2}+1
sta ({z1}),y
//FRAGMENT vbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
sta {z1}
//FRAGMENT _stackpushbyte_=vbuz1
lda {z1}
pha
//FRAGMENT call__deref_pprz1
jsr {la1}
{la1}: @outside_flow
jmp ({z1})  @outside_flow
//FRAGMENT vbum1=vbuz2_bor_vbuc1
lda #{c1}
ora {z2}
sta {m1}
//FRAGMENT vwum1=pbuz2_band_pbuc1
lda {z2}
and #<{c1}
sta {m1}
lda {z2}+1
and #>{c1}
sta {m1}+1
//FRAGMENT pbuz1=vwum2_plus_pbuc1
lda {m2}
clc
adc #<{c1}
sta {z1}
lda {m2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=pbuz2_minus_pbuz3
lda {z2}
sec
sbc {z3}
sta {z1}
lda {z2}+1
sbc {z3}+1
sta {z1}+1
//FRAGMENT vbuz1=_byte_vwuz2
lda {z2}
sta {z1}
//FRAGMENT vwuz1_gt_vwuz2_then_la1
lda {z2}+1
cmp {z1}+1
bcc {la1}
bne !+
lda {z2}
cmp {z1}
bcc {la1}
!:
//FRAGMENT vbuz1=vwuz2
lda {z2}
sta {z1}
//FRAGMENT 0_eq_vbuz1_then_la1
lda {z1}
beq {la1}
//FRAGMENT vbuz1_lt_vbuz2_then_la1
lda {z1}
cmp {z2}
bcc {la1}
//FRAGMENT pbuz1=pbuz1_plus_vbuz2
lda {z2}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vwuz1=vwuz1_minus_vbuz2
sec
lda {z1}
sbc {z2}
sta {z1}
bcs !+
dec {z1}+1
!:
//FRAGMENT vbum1=_byte1_pbuz2
lda {z2}+1
sta {m1}
//FRAGMENT vbuz1=_byte1_vwuz2
lda {z2}+1
sta {z1}
//FRAGMENT pbuz1=pbuz1_plus_vwuc1
lda {z1}
clc
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_minus_vwuc1
lda {z1}
sec
sbc #<{c1}
sta {z1}
lda {z1}+1
sbc #>{c1}
sta {z1}+1
//FRAGMENT vwum1=_word_pbuz2_derefidx_vbuc1
ldy #{c1}
lda ({z2}),y
sta {m1}
lda #0
sta {m1}+1
//FRAGMENT qvoz1=qvoc1_plus_vwum2
lda #<{c1}
clc
adc {m2}
sta {z1}
lda #>{c1}
adc {m2}+1
sta {z1}+1
//FRAGMENT _deref_qssz1_eq_pssz2_then_la1
ldy #0
lda ({z1}),y
cmp {z2}
bne !+
iny
lda ({z1}),y
cmp {z2}+1
beq {la1}
!:
//FRAGMENT 0_eq__deref_pbuz1_then_la1
ldy #0
lda ({z1}),y
cmp #0
beq {la1}
//FRAGMENT vwum1=_deref_pbuc1
lda {c1}
sta {m1}
lda #0
sta {m1}+1
//FRAGMENT vwum1=vwum2_rol_4
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
asl {m1}
rol {m1}+1
//FRAGMENT pbuz1_derefidx_vbuc1=vwum2
ldy #{c1}
lda {m2}
sta ({z1}),y
//FRAGMENT _deref_qvoz1=pvoz2
ldy #0
lda {z2}
sta ({z1}),y
iny
lda {z2}+1
sta ({z1}),y
//FRAGMENT _deref_pbuz1=pbuz2_derefidx_vbuc1
ldy #{c1}
lda ({z2}),y
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pwuz1=pwuz2_derefidx_vbuc1
ldy #{c1}
lda ({z2}),y
pha
iny
lda ({z2}),y
ldy #1
sta ({z1}),y
dey
pla
sta ({z1}),y
//FRAGMENT _deref_pbuz1=_inc__deref_pbuz2
ldy #0
lda ({z2}),y
clc
adc #1
ldy #0
sta ({z1}),y
//FRAGMENT vbum1=_deref_pbuc1_plus_1
ldy {c1}
iny
sty {m1}
//FRAGMENT vbum1=_deref_pbuz2_rol_1
ldy #0
lda ({z2}),y
asl
sta {m1}
//FRAGMENT 0_neq_pwuc1_derefidx_vbum1_then_la1
ldy {m1}
lda {c1}+1,y
ora {c1},y
bne {la1}
//FRAGMENT _deref_pbuz1=_inc__deref_pbuz1
ldy #0
lda ({z1}),y
clc
adc #1
ldy #0
sta ({z1}),y
//FRAGMENT vbum1=_deref_pbuz2
ldy #0
lda ({z2}),y
sta {m1}
//FRAGMENT vwum1=vwuc1_plus_vwum2
lda {m2}
clc
adc #<{c1}
sta {m1}
lda {m2}+1
adc #>{c1}
sta {m1}+1
//FRAGMENT _deref_pbuz1_ge_vbum2_then_la1
ldy #0
lda ({z1}),y
cmp {m2}
bcs {la1}
//FRAGMENT vbum1=_deref_pbuz2_plus_1
ldy #0
lda ({z2}),y
clc
adc #1
sta {m1}
//FRAGMENT _deref_pbuz1=vbum2
lda {m2}
ldy #0
sta ({z1}),y
//FRAGMENT vwum1=vwum2_plus_1
clc
lda {m2}
adc #1
sta {m1}
lda {m2}+1
adc #0
sta {m1}+1
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor_vbum1
lda {c1}
ora {m1}
sta {c1}
//FRAGMENT vwum1=pbuc1_derefidx_vbum2
ldy {m2}
lda {c1},y
sta {m1}
lda #0
sta {m1}+1
//FRAGMENT pwuc1_derefidx_vbum1_neq_vwuc2_then_la1
ldy {m1}
lda {c1}+1,y
cmp #>{c2}
bne {la1}
lda {c1},y
cmp #<{c2}
bne {la1}
//FRAGMENT vbuz1=vwuc1
lda #<{c1}
sta {z1}
//FRAGMENT pwuc1_derefidx_vbum1_neq_vwuz2_then_la1
ldy {m1}
lda {z2}+1
cmp {c1}+1,y
bne {la1}
lda {z2}
cmp {c1},y
bne {la1}
//FRAGMENT vbuz1=vbuz2_band_vbuc1
lda #{c1}
and {z2}
sta {z1}
//FRAGMENT vdum1=vwum2
lda {m2}
sta {m1}
lda {m2}+1
sta {m1}+1
lda #0
sta {m1}+2
sta {m1}+3
//FRAGMENT vbom1=vbum2_neq_vbuc1
lda {m2}
eor #{c1}
beq !+
lda #1
!:
sta {m1}
//FRAGMENT pwuc1_derefidx_vbum1=vwuc2
ldy {m1}
lda #<{c2}
sta {c1},y
lda #>{c2}
sta {c1}+1,y
//FRAGMENT pbuc1_derefidx_vbuz1_eq_vbuz1_then_la1
ldy {z1}
lda {c1},y
cmp {z1}
beq {la1}
//FRAGMENT vbuz1_neq__deref_pbuc1_then_la1
lda {c1}
cmp {z1}
bne {la1}
//FRAGMENT vwum1=vbum2_word_pbuc1_derefidx_vbum3
lda {m2}
ldy {m3}
sta {m1}+1
lda {c1},y
sta {m1}
//FRAGMENT vwum1=pbuc1_derefidx_vbum2_word_pbuc2_derefidx_vbum2
ldy {m2}
lda {c1},y
sta {m1}+1
lda {c2},y
sta {m1}
//FRAGMENT _deref_pwuc1=_deref_pwuc1_plus_vwum1
clc
lda {c1}
adc {m1}
sta {c1}
lda {c1}+1
adc {m1}+1
sta {c1}+1
//FRAGMENT _deref_pwuc1=_deref_pwuc1_minus_vwum1
lda {c1}
sec
sbc {m1}
sta {c1}
lda {c1}+1
sbc {m1}+1
sta {c1}+1
//FRAGMENT pwuc1_derefidx_vbum1_eq_vwuc2_then_la1
ldy {m1}
lda {c1},y
cmp #<{c2}
bne !+
lda {c1}+1,y
cmp #>{c2}
beq {la1}
!:
//FRAGMENT pbuc1_derefidx_vbuz1=_deref_pbuc2
lda {c2}
ldy {z1}
sta {c1},y
//FRAGMENT _deref_pbuc1=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1}
//FRAGMENT vwum1=vwum2_minus_vwuc1
sec
lda {m2}
sbc #<{c1}
sta {m1}
lda {m2}+1
sbc #>{c1}
sta {m1}+1
//FRAGMENT _deref_pbuz1=_dec__deref_pbuz1
ldy #0
lda ({z1}),y
sec
sbc #1
ldy #0
sta ({z1}),y
//FRAGMENT vbum1=_neg_vbum1
lda {m1}
eor #$ff
clc
adc #$01
sta {m1}
//FRAGMENT vwuz1=_word_vbuz2
lda {z2}
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vbuz1_neq_0_then_la1
lda {z1}
bne {la1}
//FRAGMENT vbum1_eq_0_then_la1
lda {m1}
beq {la1}
//FRAGMENT vwuz1=vwuz1_plus_vwuz2
clc
lda {z1}
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=vbuz1_ror_1
lsr {z1}
//FRAGMENT vwuz1=vwuz1_rol_1
asl {z1}
rol {z1}+1
//FRAGMENT vbuz1=vbum2_rol_1
lda {m2}
asl
sta {z1}
//FRAGMENT vbuz1_le__deref_pbuc1_then_la1
lda {c1}
cmp {z1}
bcs {la1}
//FRAGMENT vbum1=vbuz2_plus_1
ldy {z2}
iny
sty {m1}
//FRAGMENT 0_eq_vwuz1_then_la1
lda {z1}
ora {z1}+1
beq {la1}
//FRAGMENT vwuz1_lt_vwuz2_then_la1
lda {z1}+1
cmp {z2}+1
bcc {la1}
bne !+
lda {z1}
cmp {z2}
bcc {la1}
!:
//FRAGMENT vwuz1=_inc_vwuz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT pbuz1_neq_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT vbsz1=_sbyte_vwum2
lda {m2}
sta {z1}
//FRAGMENT vbsz1=vbsz2_minus_vbsz3
lda {z2}
sec
sbc {z3}
sta {z1}
//FRAGMENT vbsz1_ge_0_then_la1
lda {z1}
cmp #0
bpl {la1}
//FRAGMENT vbsz1=vbsc1
lda #{c1}
sta {z1}
//FRAGMENT 0_neq_vbsz1_then_la1
lda {z1}
cmp #0
bne {la1}
//FRAGMENT vbum1_lt__deref_pbuc1_then_la1
lda {m1}
cmp {c1}
bcc {la1}
//FRAGMENT pwuz1_derefidx_vbuc1_lt_vwum2_then_la1
ldy #{c1}
iny
lda ({z1}),y
cmp {m2}+1
bcc {la1}
bne !+
dey
lda ({z1}),y
cmp {m2}
bcc {la1}
!:
//FRAGMENT vbuz1_lt_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcc {la1}
//FRAGMENT vbum1=_byte_vwuz2
lda {z2}
sta {m1}
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
//FRAGMENT vwuz1_ge_vwuz2_then_la1
lda {z2}+1
cmp {z1}+1
bne !+
lda {z2}
cmp {z1}
beq {la1}
!:
bcc {la1}
//FRAGMENT vbsz1=_inc_vbsz1
inc {z1}
//FRAGMENT pprz1=pprz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_plus_vwuc1
lda {z2}
clc
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT _deref_pbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
ldy #0
sta ({z1}),y
//FRAGMENT pbuc1_derefidx_(pbuc2_derefidx_vbum1)=vbuc3
lda #{c3}
ldy {m1}
ldx {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbum1=vwum2
ldy {m1}
lda {m2}
sta {c1},y
//FRAGMENT pssz1=pssc1_plus_vwum2
lda {m2}
clc
adc #<{c1}
sta {z1}
lda {m2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vbum1=vwuz2
lda {z2}
sta {m1}
//FRAGMENT vdum1=vdum2_minus_1
sec
lda {m2}
sbc #1
sta {m1}
lda {m2}+1
sbc #0
sta {m1}+1
lda {m2}+2
sbc #0
sta {m1}+2
lda {m2}+3
sbc #0
sta {m1}+3
//FRAGMENT vwum1_lt_vwum2_then_la1
lda {m1}+1
cmp {m2}+1
bcc {la1}
bne !+
lda {m1}
cmp {m2}
bcc {la1}
!:
//FRAGMENT vwum1_ge_vwum2_then_la1
lda {m2}+1
cmp {m1}+1
bne !+
lda {m2}
cmp {m1}
beq {la1}
!:
bcc {la1}
//FRAGMENT vbum1=pbuc1_derefidx_vbum1
ldy {m1}
lda {c1},y
sta {m1}
//FRAGMENT vbum1_neq_vbum2_then_la1
lda {m1}
cmp {m2}
bne {la1}
//FRAGMENT vwum1_gt_vwum2_then_la1
lda {m2}+1
cmp {m1}+1
bcc {la1}
bne !+
lda {m2}
cmp {m1}
bcc {la1}
!:
//FRAGMENT _deref_pwuc1=_dec__deref_pwuc1
lda {c1}
bne !+
dec {c1}+1
!:
dec {c1}
//FRAGMENT vwum1_eq_vwum2_then_la1
lda {m1}
cmp {m2}
bne !+
lda {m1}+1
cmp {m2}+1
beq {la1}
!:
//FRAGMENT vbuz1=_dec_vbuz2
ldy {z2}
dey
sty {z1}
//FRAGMENT vbuz1=_byte_vwum2
lda {m2}
sta {z1}
//FRAGMENT 0_neq__deref_pbuz1_then_la1
ldy #0
lda ({z1}),y
cmp #0
bne {la1}
//FRAGMENT _deref_pbuz1=pbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
ldy #0
sta ({z1}),y
//FRAGMENT vbuz1_ge_vbuz2_then_la1
lda {z1}
cmp {z2}
bcs {la1}
//FRAGMENT 0_neq_vwum1_then_la1
lda {m1}
ora {m1}+1
bne {la1}
//FRAGMENT pwuz1_derefidx_vbuc1=_inc_pwuz1_derefidx_vbuc1
ldy #{c1}
lda ({z1}),y
clc
adc #1
sta ({z1}),y
bne !+
iny
lda ({z1}),y
adc #0
sta ({z1}),y
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
//FRAGMENT pwuz1_derefidx_vbuc1=pwuz1_derefidx_vbuc2
ldy #{c2}
lda ({z1}),y
ldy #{c1}
sta ({z1}),y
ldy #{c2}+1
lda ({z1}),y
ldy #{c1}+1
sta ({z1}),y
//FRAGMENT vwuz1=vwuz1_minus_vwuz2
lda {z1}
sec
sbc {z2}
sta {z1}
lda {z1}+1
sbc {z2}+1
sta {z1}+1
//FRAGMENT _deref_pbuc1_lt_vbuc2_then_la1
lda {c1}
cmp #{c2}
bcc {la1}
//FRAGMENT vbum1=_byte2_vdum2
lda {m2}+2
sta {m1}
//FRAGMENT vwum1=_word0_vdum2
lda {m2}
sta {m1}
lda {m2}+1
sta {m1}+1
//FRAGMENT vwum1=vwum2_minus_vwum3
lda {m2}
sec
sbc {m3}
sta {m1}
lda {m2}+1
sbc {m3}+1
sta {m1}+1
//FRAGMENT vbuz1=vbuz1_minus_vbuz2
lda {z1}
sec
sbc {z2}
sta {z1}
//FRAGMENT vdum1=_dword_pwuz2_derefidx_vbuc1
ldy #{c1}
lda ({z2}),y
sta {m1}
iny
lda ({z2}),y
sta {m1}+1
lda #0
sta {m1}+2
sta {m1}+3
//FRAGMENT vbuz1_le_vbuc1_then_la1
lda #{c1}
cmp {z1}
bcs {la1}
//FRAGMENT vbuz1=vbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
//FRAGMENT vbum1=vbum1_plus_1
inc {m1}
//FRAGMENT vbum1=vbum1_band_vbuc1
lda #{c1}
and {m1}
sta {m1}
//FRAGMENT pbuz1=pbuz2_plus_vwuz1
clc
lda {z1}
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT vbum1=vbum1_rol_1
asl {m1}
//FRAGMENT vwum1=vwum1_bor_vwum2
lda {m1}
ora {m2}
sta {m1}
lda {m1}+1
ora {m2}+1
sta {m1}+1
//FRAGMENT vdum1=vdum1_ror_3
lsr {m1}+3
ror {m1}+2
ror {m1}+1
ror {m1}
lsr {m1}+3
ror {m1}+2
ror {m1}+1
ror {m1}
lsr {m1}+3
ror {m1}+2
ror {m1}+1
ror {m1}
//FRAGMENT vwum1=vwum1_plus_vwum2
clc
lda {m1}
adc {m2}
sta {m1}
lda {m1}+1
adc {m2}+1
sta {m1}+1
//FRAGMENT vbum1=vbum1_rol_5
lda {m1}
asl
asl
asl
asl
asl
sta {m1}
//FRAGMENT vbum1=vbum1_ror_2
lda {m1}
lsr
lsr
sta {m1}
//FRAGMENT vwuz1=pbuz2_minus_pbuz1
lda {z2}
sec
sbc {z1}
sta {z1}
lda {z2}+1
sbc {z1}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vbuz1=vbuz1_band_vbuc1
lda #{c1}
and {z1}
sta {z1}
//FRAGMENT vwum1=vwum1_minus_vwuc1
lda {m1}
sec
sbc #<{c1}
sta {m1}
lda {m1}+1
sbc #>{c1}
sta {m1}+1
//FRAGMENT vbsz1=vbsz1_minus_vbsz2
lda {z1}
sec
sbc {z2}
sta {z1}
//FRAGMENT vbsz1=vbsz2_minus_vbsz1
lda {z2}
sec
sbc {z1}
sta {z1}
//FRAGMENT vdum1=vdum1_minus_1
sec
lda {m1}
sbc #1
sta {m1}
lda {m1}+1
sbc #0
sta {m1}+1
lda {m1}+2
sbc #0
sta {m1}+2
lda {m1}+3
sbc #0
sta {m1}+3
//FRAGMENT vbum1=pbuc1_derefidx_vbum1_band_vbuc2
lda #{c2}
ldy {m1}
and {c1},y
sta {m1}
//FRAGMENT pbuz1=pbuz1_plus_vwum2
clc
lda {z1}
adc {m2}
sta {z1}
lda {z1}+1
adc {m2}+1
sta {z1}+1
//FRAGMENT vwum1=vwum1_plus__deref_pwuc1
clc
lda {m1}
adc {c1}
sta {m1}
lda {m1}+1
adc {c1}+1
sta {m1}+1
//FRAGMENT qssz1=qssz1_plus_1
clc
lda {z1}
adc #1
sta {z1}
lda {z1}+1
adc #0
sta {z1}+1
//FRAGMENT pssz1=_deref_qssz1
ldy #0
lda ({z1}),y
pha
iny
lda ({z1}),y
sta {z1}+1
pla
sta {z1}
//FRAGMENT vwsm1=vwsm1_plus_vbsc1
lda {m1}
clc
adc #<{c1}
sta {m1}
lda {m1}+1
adc #>{c1}
sta {m1}+1
//FRAGMENT vwum1=vwum1_plus_vbuc1
lda #{c1}
clc
adc {m1}
sta {m1}
bcc !+
inc {m1}+1
!:
//FRAGMENT vbum1=vbum2_bor_vbum1
lda {m1}
ora {m2}
sta {m1}
//FRAGMENT vwsm1=vwsm1_ror_2
lda {m1}+1
cmp #$80
ror {m1}+1
ror {m1}
lda {m1}+1
cmp #$80
ror {m1}+1
ror {m1}
//FRAGMENT vdum1=vdum1_rol_8
lda {m1}+2
sta {m1}+3
lda {m1}+1
sta {m1}+2
lda {m1}
sta {m1}+1
lda #0
sta {m1}
//FRAGMENT vbum1=vbum1_rol_2
lda {m1}
asl
asl
sta {m1}
//FRAGMENT vbum1=vbum1_rol_4
lda {m1}
asl
asl
asl
asl
sta {m1}
//FRAGMENT vwsm1=vwsm1_plus_pbuc1_derefidx_vbum2
ldy {m2}
lda {c1},y
clc
adc {m1}
sta {m1}
lda {m1}+1
adc #0
sta {m1}+1
//FRAGMENT vbum1=vbum1_bor_vbuc1
lda #{c1}
ora {m1}
sta {m1}
//FRAGMENT vbum1=vbum1_bor_vbum2
lda {m1}
ora {m2}
sta {m1}
//FRAGMENT vwum1=vwum1_minus_pwuc1_derefidx_vbum2
ldy {m2}
lda {m1}
sec
sbc {c1},y
sta {m1}
lda {m1}+1
sbc {c1}+1,y
sta {m1}+1
//FRAGMENT pbsz1=pbsz1_plus_vwum2
clc
lda {z1}
adc {m2}
sta {z1}
lda {z1}+1
adc {m2}+1
sta {z1}+1
//FRAGMENT qssz1=qssz1_plus_vwum2
lda {z1}
clc
adc {m2}
sta {z1}
lda {z1}+1
adc {m2}+1
sta {z1}+1
//FRAGMENT pwsz1=pwsz1_plus_vwum2
clc
lda {z1}
adc {m2}
sta {z1}
lda {z1}+1
adc {m2}+1
sta {z1}+1
//FRAGMENT vbum1=pbuc1_derefidx_vbum1_minus_1
ldy {m1}
ldx {c1},y
dex
stx {m1}
//FRAGMENT vwum1=vwum1_band_vwuc1
lda {m1}
and #<{c1}
sta {m1}
lda {m1}+1
and #>{c1}
sta {m1}+1
//FRAGMENT vwum1=vwum1_rol_3
asl {m1}
rol {m1}+1
asl {m1}
rol {m1}+1
asl {m1}
rol {m1}+1
//FRAGMENT vwum1=vwum1_rol_vbuc1
ldy #{c1}
cpy #0
beq !e+
!:
asl {m1}
rol {m1}+1
dey
bne !-
!e:
//FRAGMENT vwum1=vwum1_ror_2
lsr {m1}+1
ror {m1}
lsr {m1}+1
ror {m1}
//FRAGMENT vwsm1=vwsm1_rol_vbuc1
ldy #{c1}
beq !e+
!:
asl {m1}
rol {m1}+1
dey
bne !-
!e:
//FRAGMENT vbom1=vbum1_eq_vbuc1
lda {m1}
eor #{c1}
beq !+
lda #1
!:
eor #1
sta {m1}
//FRAGMENT vbum1=vbum1_ror_4
lda {m1}
lsr
lsr
lsr
lsr
sta {m1}
//FRAGMENT vbum1=vbum1_ror_6
lda {m1}
rol
rol
rol
and #$03
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
//FRAGMENT vbom1=vbum1_neq_vbuc1
lda {m1}
eor #{c1}
beq !+
lda #1
!:
sta {m1}
//FRAGMENT vwum1=vwum1_ror_3
lsr {m1}+1
ror {m1}
lsr {m1}+1
ror {m1}
lsr {m1}+1
ror {m1}
//FRAGMENT vwum1=vwum1_ror_5
lsr {m1}+1
ror {m1}
lsr {m1}+1
ror {m1}
lsr {m1}+1
ror {m1}
lsr {m1}+1
ror {m1}
lsr {m1}+1
ror {m1}
//FRAGMENT vwum1=vwum1_rol_1
asl {m1}
rol {m1}+1
//FRAGMENT vbum1=pbuz2_derefidx_vbum1
ldy {m1}
lda ({z2}),y
sta {m1}
//FRAGMENT vbum1=pbuc1_derefidx_vbum2_plus_vbum1
lda {m1}
ldy {m2}
clc
adc {c1},y
sta {m1}
//FRAGMENT vwum1=vwuc1_plus_vwum1
lda {m1}
clc
adc #<{c1}
sta {m1}
lda {m1}+1
adc #>{c1}
sta {m1}+1
//FRAGMENT vbum1=vbum1_minus_vbuc1
lda {m1}
sec
sbc #{c1}
sta {m1}
//FRAGMENT vwum1=vwum1_plus_1
inc {m1}
bne !+
inc {m1}+1
!:
//FRAGMENT pwsz1=pwsz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vbum1=vbum1_minus_1
dec {m1}
