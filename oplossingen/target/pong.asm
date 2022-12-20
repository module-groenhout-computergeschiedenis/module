  // File Comments
/**
 * @file pong.c
 * @author your name (you@domain.com)
 * @brief Dit is je eerste C programma, dat werkt op de PET 8032!
 * Het resultaat zal een werkend pong spelletje zijn!
 *
 * Nu maken we geluid. We maken verschillende geluidjes als het balletje stuitert op verschillende
 * plaatsen met de andere objecten.
 *
 * Zoek naar de OEFENING sectie(s) om dit programma te vervolledigen.
 *
 * @version 0.1
 * @date 2022-12-12
 *
 * @copyright Copyright (c) 2022
 *
 */
  // Upstart
  // Commodore PET 8032 PRG executable file
.file [name="pong.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0401]
.segmentdef Code [start=$40d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  // Global Constants & labels
  ///< Close all logical files.
  .const CBM_GETIN = $ffe4
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $8000
  // Nog iets interessants! Hexadecimaal!
  // Onderstaande variabele screen bevat een "pointer" naar een adres in het geheugen van de computer!
  // Het adres is 0x8000 en is uitgedrukt in het hexadecimale talstel!
  // Het hexadecimale talstelsel is net zoals in decimale talstelsel, maar heeft 16 cijfers in plaats van 10 cijfers!
  // Waarom? Dit werkt erg handig met computers, omdat computers binair werken in veelvouden van 2, 4, 8, 16, 32 of 64!
  // We schrijven aan het begin van hexadecimale getallen (in de C taal) een "0x", om verwarring met gewone decimale getallen te vermijden.
  // Het hexadecimale getal 0x8000 komt overeen in het decimale talstelsel met 32768 ...
  // Echter, hexadecimale getallen hebben 16 cijfers, dus de cijfers 0 tot 9 zijn net zoals in het decimale talstelsel,
  // maar na de 9 komen de cijfers A, B, C, D, E en F, die respectievelijk in het decimaal de waarden 11, 12, 13, 14, 15 en 16 hebben!
  // Dus het voordeel van hexadecimaal is dat je erg compact getallen kan noteren die een veelvoud zijn van 16!
  // De variable screen wordt gebruikt in de pain functie om de karakters te tekenen op het scherm.
  .label screen = $8000
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = $b
  // The current cursor y-position
  .label conio_cursor_y = 7
  // The current text cursor line start
  .label conio_line_text = 8
.segment Code
  // __start
__start: {
    // __start::__init1
    // __ma char conio_cursor_x = 0
    // [1] conio_cursor_x = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z conio_cursor_x
    // __ma char conio_cursor_y = 0
    // [2] conio_cursor_y = 0 -- vbuz1=vbuc1 
    sta.z conio_cursor_y
    // __ma char *conio_line_text = CONIO_SCREEN_TEXT
    // [3] conio_line_text = DEFAULT_SCREEN -- pbuz1=pbuc1 
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    // [4] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [5] call main
    // [17] phi from __start::@1 to main [phi:__start::@1->main]
    jsr main
    // __start::@return
    // [6] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__register(A) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    // [7] cputc::c#0 = stackidx(char,cputc::OFFSET_STACK_C) -- vbuaa=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    // if(c=='\n')
    // [8] if(cputc::c#0==' 'pm) goto cputc::@1 -- vbuaa_eq_vbuc1_then_la1 
  .encoding "petscii_mixed"
    cmp #'\n'
    beq __b1
    // cputc::@2
    // conio_line_text[conio_cursor_x] = c
    // [9] conio_line_text[conio_cursor_x] = cputc::c#0 -- pbuz1_derefidx_vbuz2=vbuaa 
    ldy.z conio_cursor_x
    sta (conio_line_text),y
    // if(++conio_cursor_x==CONIO_WIDTH)
    // [10] conio_cursor_x = ++ conio_cursor_x -- vbuz1=_inc_vbuz1 
    inc.z conio_cursor_x
    // [11] if(conio_cursor_x!=$50) goto cputc::@return -- vbuz1_neq_vbuc1_then_la1 
    lda #$50
    cmp.z conio_cursor_x
    bne __breturn
    // [12] phi from cputc::@2 to cputc::@3 [phi:cputc::@2->cputc::@3]
    // cputc::@3
    // cputln()
    // [13] call cputln
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [14] return 
    rts
    // [15] phi from cputc to cputc::@1 [phi:cputc->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [16] call cputln
    jsr cputln
    rts
}
  // main
/**
 * @brief De main functie van pong. Dit programma geeft je
 *
 * @return int
 */
main: {
    // Dit zijn constanten die de linker, rechter, boven en onderkant van het speelveld bepalen.
    .const border_left = 0
    .const border_right = $9f
    .const border_top = 0
    .const border_bottom = $31
    .const wall_min = 1
    .const wall_max = border_bottom-wall_size-1
    .label wall_size = 6
    .label x1 = $b
    .label y1 = 7
    .label ch = $1c
    // Dit wist het scherm :-)
    .label sound = $19
    // We declareren de variabelen die de positie bijhouden van het muurtje (wall).
    // We kunnen dit muurtje omhoog en omlaag schuiven door met de pijl omhoog of omlaag te tikken.
    // Ons programma zal dan de waarden wall_x en wall_y verminderen of vermeerderen.
    // We houden ook een grootte bij in wall_size.
    .label wall_x = $1b
    // We introduceren een fixed point x en y, waarvan de hoogste byte het gehele gedeelte van het getal bevat
    // en de laagste byte het fractionele gedeelte.
    .label fx = $1f
    .label fy = $21
    // De hoogste byte wijzen we toe aan de x en y variabelen om te plotten.
    .label x = $1e
    .label y = $1d
    .label wall_y = $1a
    // Deze werk variabelen houden de "deltas" bij van de richting van het balletje.
    // Deze zijn nu 16-bit variabelen, maar de zijn "signed". Dit wil zeggen,
    // dat de variabelen ook een negatieve waarde kunnen hebben!
    // De laagste byte van deze variabelen bevatten het fractionele gedeelte.
    .label dx = $17
    .label dy = $15
    // Dit wist het scherm :-)
    .label sound_1 = $14
    // clrscr()
    // [18] call clrscr
    // [152] phi from main to clrscr [phi:main->clrscr]
    jsr clrscr
    // [19] phi from main to main::@1 [phi:main->main::@1]
    // [19] phi main::x1#2 = main::border_left [phi:main->main::@1#0] -- vbuz1=vbuc1 
    lda #border_left
    sta.z x1
  // We tekenen eerst het scherm, de randen op de x-as!
    // main::@1
  __b1:
    // for (char x = border_left; x <= border_right; x++)
    // [20] if(main::x1#2<main::border_right+1) goto main::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z x1
    cmp #border_right+1
    bcs !__b2+
    jmp __b2
  !__b2:
    // [21] phi from main::@1 to main::@3 [phi:main::@1->main::@3]
    // [21] phi main::y1#2 = main::border_top [phi:main::@1->main::@3#0] -- vbuz1=vbuc1 
    lda #border_top
    sta.z y1
  // We tekenen eerst het scherm, de randen op de y-as!
    // main::@3
  __b3:
    // for (char y = border_top; y <= border_bottom; y++)
    // [22] if(main::y1#2<main::border_bottom+1) goto main::@4 -- vbuz1_lt_vbuc1_then_la1 
    lda.z y1
    cmp #border_bottom+1
    bcs !__b4+
    jmp __b4
  !__b4:
    // [23] phi from main::@3 to main::@5 [phi:main::@3->main::@5]
    // main::@5
    // char ch = getch()
    // [24] call getch
  // Deze variabele ch bevat het karaketer dat wordt gedrukt op het toetsenbord.
  // Het programma wacht niet tot het karaketer gedrukt wordt.
    // [165] phi from main::@5 to getch [phi:main::@5->getch]
    jsr getch
    // char ch = getch()
    // [25] getch::return#2 = getch::return#0
    // main::@50
    // [26] main::ch#0 = getch::return#2 -- vbuz1=vbuaa 
    sta.z ch
    // [27] phi from main::@50 to main::@6 [phi:main::@50->main::@6]
    // [27] phi main::dy#10 = $40 [phi:main::@50->main::@6#0] -- vwsz1=vwsc1 
    lda #<$40
    sta.z dy
    lda #>$40
    sta.z dy+1
    // [27] phi main::fy#10 = $18*$100 [phi:main::@50->main::@6#1] -- vwuz1=vwuc1 
    lda #<$18*$100
    sta.z fy
    lda #>$18*$100
    sta.z fy+1
    // [27] phi main::dx#12 = $80 [phi:main::@50->main::@6#2] -- vwsz1=vwsc1 
    lda #<$80
    sta.z dx
    lda #>$80
    sta.z dx+1
    // [27] phi main::fx#10 = 2*$100 [phi:main::@50->main::@6#3] -- vwuz1=vwuc1 
    lda #<2*$100
    sta.z fx
    lda #>2*$100
    sta.z fx+1
    // [27] phi main::y#11 = byte1 $18*$100 [phi:main::@50->main::@6#4] -- vbuz1=vbuc1 
    lda #>$18*$100
    sta.z y
    // [27] phi main::x#10 = byte1 2*$100 [phi:main::@50->main::@6#5] -- vbuz1=vbuc1 
    lda #>2*$100
    sta.z x
    // [27] phi main::sound#10 = 0 [phi:main::@50->main::@6#6] -- vbuz1=vbuc1 
    lda #0
    sta.z sound_1
    // [27] phi main::wall_y#15 = $16 [phi:main::@50->main::@6#7] -- vbuz1=vbuc1 
    lda #$16
    sta.z wall_y
    // [27] phi main::wall_x#10 = $9a [phi:main::@50->main::@6#8] -- vbuz1=vbuc1 
    lda #$9a
    sta.z wall_x
    // [27] phi main::ch#10 = main::ch#0 [phi:main::@50->main::@6#9] -- register_copy 
  // Als we een 'x' drukken op het toetsenbord, dan stoppen we met het spelletje.
    // main::@6
  __b6:
    // while (ch != 'x')
    // [28] if(main::ch#10!='x'pm) goto main::@7 -- vbuz1_neq_vbuc1_then_la1 
    lda #'x'
    cmp.z ch
    bne __b7
    // [29] phi from main::@6 to main::@8 [phi:main::@6->main::@8]
    // main::@8
    // clrscr()
    // [30] call clrscr
  // Einde van het spel.
    // [152] phi from main::@8 to clrscr [phi:main::@8->clrscr]
    jsr clrscr
    // main::@return
    // }
    // [31] return 
    rts
    // main::@7
  __b7:
    // wall(wall_x, wall_y, wall_size, 0)
    // [32] wall::x#0 = main::wall_x#10 -- vbuz1=vbuz2 
    lda.z wall_x
    sta.z wall.x
    // [33] wall::y#0 = main::wall_y#15 -- vbuz1=vbuz2 
    lda.z wall_y
    sta.z wall.y
    // [34] call wall
  // We wissen het muurtje.
    // [170] phi from main::@7 to wall [phi:main::@7->wall]
    // [170] phi wall::c#4 = 0 [phi:main::@7->wall#0] -- vbuz1=vbuc1 
    lda #0
    sta.z wall.c
    // [170] phi wall::x#4 = wall::x#0 [phi:main::@7->wall#1] -- register_copy 
    // [170] phi wall::y#4 = wall::y#0 [phi:main::@7->wall#2] -- register_copy 
    jsr wall
    // main::@51
    // if(!(sound--))
    // [35] main::sound#1 = -- main::sound#10 -- vbuz1=_dec_vbuz2 
    ldy.z sound_1
    dey
    sty.z sound
    // [36] if(0!=main::sound#10) goto main::@9 -- 0_neq_vbuz1_then_la1 
    lda.z sound_1
    bne __b9
    // [37] phi from main::@51 to main::@38 [phi:main::@51->main::@38]
    // main::@38
    // sound_off()
    // [38] call sound_off
    jsr sound_off
    // main::@9
  __b9:
    // case 0x9D:
    //             if (wall_x > 120) {
    //                 wall_x--;
    //                 sound = sound_note(15, 133, 1);
    //             }
    //             break;
    // [39] if(main::ch#10==$9d) goto main::@10 -- vbuz1_eq_vbuc1_then_la1 
    lda #$9d
    cmp.z ch
    bne !__b10+
    jmp __b10
  !__b10:
    // main::@39
    // case 0x1D:
    //             if (wall_x < 150) {
    //                 wall_x++;
    //                 sound = sound_note(15, 133, 1);
    //             }
    //             break;
    // [40] if(main::ch#10==$1d) goto main::@11 -- vbuz1_eq_vbuc1_then_la1 
    lda #$1d
    cmp.z ch
    bne !__b11+
    jmp __b11
  !__b11:
    // main::@40
    // case 0x91:
    //             if (wall_y > wall_min) {
    //                 wall_y--;
    //                 sound = sound_note(15, 78, 1);
    //             }
    //             break;
    // [41] if(main::ch#10==$91) goto main::@12 -- vbuz1_eq_vbuc1_then_la1 
    lda #$91
    cmp.z ch
    bne !__b12+
    jmp __b12
  !__b12:
    // main::@41
    // case 0x11:
    //             // OEFENING:
    //             // Kan je bereiken dat wall_y niet verder dan de onderste rand kan?
    //             // OPLOSSING:
    //             if (wall_y < wall_max) {
    //                 wall_y++;
    //                 sound = sound_note(51, 78, 1);
    //             }
    //             break;
    // [42] if(main::ch#10==$11) goto main::@13 -- vbuz1_eq_vbuc1_then_la1 
    lda #$11
    cmp.z ch
    bne !__b13+
    jmp __b13
  !__b13:
    // [43] phi from main::@10 main::@11 main::@12 main::@13 main::@41 main::@52 main::@54 main::@55 main::@56 to main::@14 [phi:main::@10/main::@11/main::@12/main::@13/main::@41/main::@52/main::@54/main::@55/main::@56->main::@14]
    // [43] phi main::sound#34 = main::sound#1 [phi:main::@10/main::@11/main::@12/main::@13/main::@41/main::@52/main::@54/main::@55/main::@56->main::@14#0] -- register_copy 
    // [43] phi main::wall_y#10 = main::wall_y#15 [phi:main::@10/main::@11/main::@12/main::@13/main::@41/main::@52/main::@54/main::@55/main::@56->main::@14#1] -- register_copy 
    // [43] phi main::wall_x#13 = main::wall_x#10 [phi:main::@10/main::@11/main::@12/main::@13/main::@41/main::@52/main::@54/main::@55/main::@56->main::@14#2] -- register_copy 
    // main::@14
  __b14:
    // plot(x, y, 0)
    // [44] plot::x#6 = main::x#10 -- vbuxx=vbuz1 
    ldx.z x
    // [45] plot::y#6 = main::y#11 -- vbuz1=vbuz2 
    lda.z y
    sta.z plot.y
    // [46] call plot
    // [181] phi from main::@14 to plot [phi:main::@14->plot]
    // [181] phi plot::c#10 = 0 [phi:main::@14->plot#0] -- vbuz1=vbuc1 
    lda #0
    sta.z plot.c
    // [181] phi plot::y#10 = plot::y#6 [phi:main::@14->plot#1] -- register_copy 
    // [181] phi plot::x#8 = plot::x#6 [phi:main::@14->plot#2] -- register_copy 
    jsr plot
    // main::@53
    // fx += dx
    // [47] main::fx#1 = main::fx#10 + main::dx#12 -- vwuz1=vwuz1_plus_vwsz2 
    // Nu werken we de x en y positie bij, we tellen de deltas op bij de x en y waarden.
    clc
    lda.z fx
    adc.z dx
    sta.z fx
    lda.z fx+1
    adc.z dx+1
    sta.z fx+1
    // fy += dy
    // [48] main::fy#1 = main::fy#10 + main::dy#10 -- vwuz1=vwuz1_plus_vwsz2 
    // Hoe kleiner de waarde van het fractionele gedeelte, hoe trager het balletje zal voortbewegen op de x-as.
    clc
    lda.z fy
    adc.z dy
    sta.z fy
    lda.z fy+1
    adc.z dy+1
    sta.z fy+1
    // x = BYTE1(fx)
    // [49] main::x#1 = byte1  main::fx#1 -- vbuz1=_byte1_vwuz2 
    lda.z fx+1
    sta.z x
    // y = BYTE1(fy)
    // [50] main::y#1 = byte1  main::fy#1 -- vbuz1=_byte1_vwuz2 
    lda.z fy+1
    sta.z y
    // wall_y + wall_size
    // [51] main::$36 = main::wall_y#10 + main::wall_size -- vbuaa=vbuz1_plus_vbuc1 
    lda #wall_size
    clc
    adc.z wall_y
    // wall_y + wall_size - 1
    // [52] main::$37 = main::$36 - 1 -- vbuxx=vbuaa_minus_1 
    tax
    dex
    // if (x == wall_x && y >= wall_y && y <= (wall_y + wall_size - 1))
    // [53] if(main::x#1!=main::wall_x#13) goto main::@23 -- vbuz1_neq_vbuz2_then_la1 
    lda.z x
    cmp.z wall_x
    bne __b5
    // main::@67
    // [54] if(main::y#1<main::wall_y#10) goto main::@23 -- vbuz1_lt_vbuz2_then_la1 
    lda.z y
    cmp.z wall_y
    bcc __b5
    // main::@66
    // [55] if(main::y#1<=main::$37) goto main::@19 -- vbuz1_le_vbuxx_then_la1 
    cpx.z y
    bcc !__b19+
    jmp __b19
  !__b19:
    // [56] phi from main::@66 main::@67 to main::@23 [phi:main::@66/main::@67->main::@23]
  __b5:
    // [56] phi from main::@26 main::@27 main::@28 main::@30 main::@32 main::@33 main::@53 to main::@23 [phi:main::@26/main::@27/main::@28/main::@30/main::@32/main::@33/main::@53->main::@23]
    // [56] phi main::dx#10 = main::dx#41 [phi:main::@26/main::@27/main::@28/main::@30/main::@32/main::@33/main::@53->main::@23#0] -- register_copy 
    // [56] phi main::dy#12 = main::dy#1 [phi:main::@26/main::@27/main::@28/main::@30/main::@32/main::@33/main::@53->main::@23#1] -- register_copy 
    // main::@23
    // if (y == border_top + 1)
    // [57] if(main::y#1!=1) goto main::@68 -- vbuz1_neq_vbuc1_then_la1 
    lda #1
    cmp.z y
    beq !__b68+
    jmp __b68
  !__b68:
    // main::@42
    // dy = -dy
    // [58] main::dy#35 = - main::dy#12 -- vwsz1=_neg_vwsz1 
    lda #0
    sec
    sbc.z dy
    sta.z dy
    lda #0
    sbc.z dy+1
    sta.z dy+1
    // sound_note(85, 99, 1)
    // [59] call sound_note
    // [213] phi from main::@42 to sound_note [phi:main::@42->sound_note]
    // [213] phi sound_note::return#0 = sound_note::duration#4 [phi:main::@42->sound_note#0] -- vbuz1=vbuc1 
    lda #sound_note.duration
    sta.z sound_note.return
    // [213] phi sound_note::frequency#8 = $63 [phi:main::@42->sound_note#1] -- vbuyy=vbuc1 
    ldy #$63
    // [213] phi sound_note::octave#8 = $55 [phi:main::@42->sound_note#2] -- vbuxx=vbuc1 
    ldx #$55
    jsr sound_note
    // sound_note(85, 99, 1)
    // [60] sound_note::return#15 = sound_note::return#0 -- vbuaa=vbuz1 
    lda.z sound_note.return
    // main::@57
    // sound = sound_note(85, 99, 1)
    // [61] main::sound#6 = sound_note::return#15 -- vbuz1=vbuaa 
    sta.z sound_1
    // [62] phi from main::@57 main::@68 to main::@34 [phi:main::@57/main::@68->main::@34]
    // [62] phi main::sound#33 = main::sound#6 [phi:main::@57/main::@68->main::@34#0] -- register_copy 
    // [62] phi main::dy#13 = main::dy#35 [phi:main::@57/main::@68->main::@34#1] -- register_copy 
    // main::@34
  __b34:
    // if (y == border_bottom - 1)
    // [63] if(main::y#1!=main::border_bottom-1) goto main::@35 -- vbuz1_neq_vbuc1_then_la1 
    lda #border_bottom-1
    cmp.z y
    bne __b35
    // main::@43
    // dy = -dy
    // [64] main::dy#6 = - main::dy#13 -- vwsz1=_neg_vwsz1 
    lda #0
    sec
    sbc.z dy
    sta.z dy
    lda #0
    sbc.z dy+1
    sta.z dy+1
    // sound_note(85, 99, 1)
    // [65] call sound_note
    // [213] phi from main::@43 to sound_note [phi:main::@43->sound_note]
    // [213] phi sound_note::return#0 = sound_note::duration#5 [phi:main::@43->sound_note#0] -- vbuz1=vbuc1 
    lda #sound_note.duration
    sta.z sound_note.return
    // [213] phi sound_note::frequency#8 = $63 [phi:main::@43->sound_note#1] -- vbuyy=vbuc1 
    ldy #$63
    // [213] phi sound_note::octave#8 = $55 [phi:main::@43->sound_note#2] -- vbuxx=vbuc1 
    ldx #$55
    jsr sound_note
    // sound_note(85, 99, 1)
    // [66] sound_note::return#16 = sound_note::return#0 -- vbuaa=vbuz1 
    lda.z sound_note.return
    // main::@58
    // sound = sound_note(85, 99, 1)
    // [67] main::sound#7 = sound_note::return#16 -- vbuz1=vbuaa 
    sta.z sound_1
    // [68] phi from main::@34 main::@58 to main::@35 [phi:main::@34/main::@58->main::@35]
    // [68] phi main::dy#50 = main::dy#13 [phi:main::@34/main::@58->main::@35#0] -- register_copy 
    // [68] phi main::sound#32 = main::sound#33 [phi:main::@34/main::@58->main::@35#1] -- register_copy 
    // main::@35
  __b35:
    // if (x == border_left + 1)
    // [69] if(main::x#1!=1) goto main::@36 -- vbuz1_neq_vbuc1_then_la1 
    lda #1
    cmp.z x
    bne __b36
    // main::@44
    // dx = -dx
    // [70] main::dx#28 = - main::dx#10 -- vwsz1=_neg_vwsz1 
    lda #0
    sec
    sbc.z dx
    sta.z dx
    lda #0
    sbc.z dx+1
    sta.z dx+1
    // sound_note(85, 99, 1)
    // [71] call sound_note
    // [213] phi from main::@44 to sound_note [phi:main::@44->sound_note]
    // [213] phi sound_note::return#0 = sound_note::duration#6 [phi:main::@44->sound_note#0] -- vbuz1=vbuc1 
    lda #sound_note.duration
    sta.z sound_note.return
    // [213] phi sound_note::frequency#8 = $63 [phi:main::@44->sound_note#1] -- vbuyy=vbuc1 
    ldy #$63
    // [213] phi sound_note::octave#8 = $55 [phi:main::@44->sound_note#2] -- vbuxx=vbuc1 
    ldx #$55
    jsr sound_note
    // sound_note(85, 99, 1)
    // [72] sound_note::return#17 = sound_note::return#0 -- vbuaa=vbuz1 
    lda.z sound_note.return
    // main::@59
    // sound = sound_note(85, 99, 1)
    // [73] main::sound#8 = sound_note::return#17 -- vbuz1=vbuaa 
    sta.z sound_1
    // [74] phi from main::@35 main::@59 to main::@36 [phi:main::@35/main::@59->main::@36]
    // [74] phi main::sound#31 = main::sound#32 [phi:main::@35/main::@59->main::@36#0] -- register_copy 
    // [74] phi main::dx#11 = main::dx#10 [phi:main::@35/main::@59->main::@36#1] -- register_copy 
    // main::@36
  __b36:
    // if (x == border_right - 1)
    // [75] if(main::x#1!=main::border_right-1) goto main::@37 -- vbuz1_neq_vbuc1_then_la1 
    lda #border_right-1
    cmp.z x
    bne __b37
    // main::@45
    // dx = -dx
    // [76] main::dx#5 = - main::dx#11 -- vwsz1=_neg_vwsz1 
    lda #0
    sec
    sbc.z dx
    sta.z dx
    lda #0
    sbc.z dx+1
    sta.z dx+1
    // sound_note(85, 99, 1)
    // [77] call sound_note
    // [213] phi from main::@45 to sound_note [phi:main::@45->sound_note]
    // [213] phi sound_note::return#0 = sound_note::duration#7 [phi:main::@45->sound_note#0] -- vbuz1=vbuc1 
    lda #sound_note.duration
    sta.z sound_note.return
    // [213] phi sound_note::frequency#8 = $63 [phi:main::@45->sound_note#1] -- vbuyy=vbuc1 
    ldy #$63
    // [213] phi sound_note::octave#8 = $55 [phi:main::@45->sound_note#2] -- vbuxx=vbuc1 
    ldx #$55
    jsr sound_note
    // sound_note(85, 99, 1)
    // [78] sound_note::return#18 = sound_note::return#0 -- vbuaa=vbuz1 
    lda.z sound_note.return
    // main::@65
    // sound = sound_note(85, 99, 1)
    // [79] main::sound#9 = sound_note::return#18 -- vbuz1=vbuaa 
    sta.z sound_1
    // [80] phi from main::@36 main::@65 to main::@37 [phi:main::@36/main::@65->main::@37]
    // [80] phi main::dx#55 = main::dx#11 [phi:main::@36/main::@65->main::@37#0] -- register_copy 
    // [80] phi main::sound#14 = main::sound#31 [phi:main::@36/main::@65->main::@37#1] -- register_copy 
    // main::@37
  __b37:
    // plot(x, y, 1)
    // [81] plot::x#7 = main::x#1 -- vbuxx=vbuz1 
    ldx.z x
    // [82] plot::y#7 = main::y#1 -- vbuz1=vbuz2 
    lda.z y
    sta.z plot.y
    // [83] call plot
    // [181] phi from main::@37 to plot [phi:main::@37->plot]
    // [181] phi plot::c#10 = 1 [phi:main::@37->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [181] phi plot::y#10 = plot::y#7 [phi:main::@37->plot#1] -- register_copy 
    // [181] phi plot::x#8 = plot::x#7 [phi:main::@37->plot#2] -- register_copy 
    jsr plot
    // main::@60
    // wall(wall_x, wall_y, wall_size, 1)
    // [84] wall::x#1 = main::wall_x#13 -- vbuz1=vbuz2 
    lda.z wall_x
    sta.z wall.x
    // [85] wall::y#1 = main::wall_y#10 -- vbuz1=vbuz2 
    lda.z wall_y
    sta.z wall.y
    // [86] call wall
  // We hertekenen het muurtje.
    // [170] phi from main::@60 to wall [phi:main::@60->wall]
    // [170] phi wall::c#4 = 1 [phi:main::@60->wall#0] -- vbuz1=vbuc1 
    lda #1
    sta.z wall.c
    // [170] phi wall::x#4 = wall::x#1 [phi:main::@60->wall#1] -- register_copy 
    // [170] phi wall::y#4 = wall::y#1 [phi:main::@60->wall#2] -- register_copy 
    jsr wall
    // [87] phi from main::@60 to main::@61 [phi:main::@60->main::@61]
    // main::@61
    // paint()
    // [88] call paint
  // En deze draw functie tekent het volledige scherm door de bitmap te tekenen op alle karakters om het scherm!
    // [218] phi from main::@61 to paint [phi:main::@61->paint]
    jsr paint
    // [89] phi from main::@61 to main::@62 [phi:main::@61->main::@62]
    // main::@62
    // getch()
    // [90] call getch
    // [165] phi from main::@62 to getch [phi:main::@62->getch]
    jsr getch
    // getch()
    // [91] getch::return#3 = getch::return#0
    // main::@63
    // ch = getch()
    // [92] main::ch#1 = getch::return#3 -- vbuz1=vbuaa 
    sta.z ch
    // gotoxy(0, 24)
    // [93] call gotoxy
    // [248] phi from main::@63 to gotoxy [phi:main::@63->gotoxy]
    jsr gotoxy
    // main::@64
    // printf("%02x", ch)
    // [94] printf_uchar::uvalue#0 = main::ch#1 -- vbuxx=vbuz1 
    ldx.z ch
    // [95] call printf_uchar
    // [253] phi from main::@64 to printf_uchar [phi:main::@64->printf_uchar]
    jsr printf_uchar
    // [27] phi from main::@64 to main::@6 [phi:main::@64->main::@6]
    // [27] phi main::dy#10 = main::dy#50 [phi:main::@64->main::@6#0] -- register_copy 
    // [27] phi main::fy#10 = main::fy#1 [phi:main::@64->main::@6#1] -- register_copy 
    // [27] phi main::dx#12 = main::dx#55 [phi:main::@64->main::@6#2] -- register_copy 
    // [27] phi main::fx#10 = main::fx#1 [phi:main::@64->main::@6#3] -- register_copy 
    // [27] phi main::y#11 = main::y#1 [phi:main::@64->main::@6#4] -- register_copy 
    // [27] phi main::x#10 = main::x#1 [phi:main::@64->main::@6#5] -- register_copy 
    // [27] phi main::sound#10 = main::sound#14 [phi:main::@64->main::@6#6] -- register_copy 
    // [27] phi main::wall_y#15 = main::wall_y#10 [phi:main::@64->main::@6#7] -- register_copy 
    // [27] phi main::wall_x#10 = main::wall_x#13 [phi:main::@64->main::@6#8] -- register_copy 
    // [27] phi main::ch#10 = main::ch#1 [phi:main::@64->main::@6#9] -- register_copy 
    jmp __b6
    // main::@68
  __b68:
    // [96] main::sound#71 = main::sound#34 -- vbuz1=vbuz2 
    lda.z sound
    sta.z sound_1
    jmp __b34
    // main::@19
  __b19:
    // dx = -dx
    // [97] main::dx#1 = - main::dx#12 -- vwsz1=_neg_vwsz1 
    lda #0
    sec
    sbc.z dx
    sta.z dx
    lda #0
    sbc.z dx+1
    sta.z dx+1
    // if (x <= 130)
    // [98] if(main::x#1<$82+1) goto main::@24 -- vbuz1_lt_vbuc1_then_la1 
    // Hier berekenen we de versnelling op de x-as, door dx aan te passen.
    lda.z x
    cmp #$82+1
    bcs !__b24+
    jmp __b24
  !__b24:
    // main::@20
    // if (x <= 140)
    // [99] if(main::x#1<$8c+1) goto main::@25 -- vbuz1_lt_vbuc1_then_la1 
    cmp #$8c+1
    bcc __b25
    // main::@21
    // if (x <= 150)
    // [100] if(main::x#1>=$96+1) goto main::@25 -- vbuz1_ge_vbuc1_then_la1 
    cmp #$96+1
    bcs __b25
    // main::@22
    // dx += 0x10
    // [101] main::dx#3 = main::dx#1 + $10 -- vwsz1=vwsz1_plus_vbsc1 
    // Indien de x positie van het muurtje lager of gelijk aan 150, dan vertragen we op de x-delta met 0x10.
    lda.z dx
    clc
    adc #<$10
    sta.z dx
    lda.z dx+1
    adc #>$10
    sta.z dx+1
    // [102] phi from main::@20 main::@21 main::@22 main::@24 to main::@25 [phi:main::@20/main::@21/main::@22/main::@24->main::@25]
    // [102] phi main::dx#41 = main::dx#1 [phi:main::@20/main::@21/main::@22/main::@24->main::@25#0] -- register_copy 
    // main::@25
  __b25:
    // if (y == wall_y)
    // [103] if(main::y#1==main::wall_y#10) goto main::@26 -- vbuz1_eq_vbuz2_then_la1 
    // Hier berekenen we de versnelling op de y-as, door dy aan te passen.
    lda.z y
    cmp.z wall_y
    beq __b26
    // main::@29
    // wall_y + 1
    // [104] main::$47 = main::wall_y#10 + 1 -- vbuxx=vbuz1_plus_1 
    ldx.z wall_y
    inx
    // if (y == wall_y + 1)
    // [105] if(main::y#1==main::$47) goto main::@27 -- vbuz1_eq_vbuxx_then_la1 
    cpx.z y
    beq __b27
    // main::@30
    // wall_y + 3
    // [106] main::$49 = main::wall_y#10 + 3 -- vbuxx=vbuz1_plus_vbuc1 
    lax.z wall_y
    axs #-[3]
    // if (y <= wall_y + 3)
    // [107] if(main::y#1<=main::$49) goto main::@23 -- vbuz1_le_vbuxx_then_la1 
    cpx.z y
    bcc !__b5+
    jmp __b5
  !__b5:
    // main::@31
    // wall_y + 4
    // [108] main::$51 = main::wall_y#10 + 4 -- vbuxx=vbuz1_plus_vbuc1 
    lax.z wall_y
    axs #-[4]
    // if (y == wall_y + 4)
    // [109] if(main::y#1==main::$51) goto main::@28 -- vbuz1_eq_vbuxx_then_la1 
    cpx.z y
    beq __b28
    // main::@32
    // wall_y + 5
    // [110] main::$53 = main::wall_y#10 + 5 -- vbuxx=vbuz1_plus_vbuc1 
    lax.z wall_y
    axs #-[5]
    // if (y == wall_y + 5)
    // [111] if(main::y#1!=main::$53) goto main::@23 -- vbuz1_neq_vbuxx_then_la1 
    cpx.z y
    beq !__b5+
    jmp __b5
  !__b5:
    // main::@33
    // dy += 0x20
    // [112] main::dy#4 = main::dy#10 + $20 -- vwsz1=vwsz1_plus_vbsc1 
    // Indien de y positie volledig aan de onderkant van het muurtje valt, dan versnellen we de y-delta met 0x20.
    lda.z dy
    clc
    adc #<$20
    sta.z dy
    lda.z dy+1
    adc #>$20
    sta.z dy+1
    jmp __b5
    // main::@28
  __b28:
    // dy += 0x10
    // [113] main::dy#3 = main::dy#10 + $10 -- vwsz1=vwsz1_plus_vbsc1 
    // Indien de y positie bijna aan de onderkant van het muurtje valt, dan versnellen we de y-delta met 0x10.
    lda.z dy
    clc
    adc #<$10
    sta.z dy
    lda.z dy+1
    adc #>$10
    sta.z dy+1
    jmp __b5
    // main::@27
  __b27:
    // dy -= 0x10
    // [114] main::dy#2 = main::dy#10 - $10 -- vwsz1=vwsz1_minus_vbsc1 
    // Indien de y positie bijna aan de top van het muurtje valt, dan vertragen we de y-delta met 0x10.
    lda.z dy
    sec
    sbc #$10
    sta.z dy
    lda.z dy+1
    sbc #>$10
    sta.z dy+1
    jmp __b5
    // main::@26
  __b26:
    // dy -= 0x20
    // [115] main::dy#1 = main::dy#10 - $20 -- vwsz1=vwsz1_minus_vbsc1 
    // Indien de y positie volledig aan de top van het muurtje valt, dan vertragen we de y-delta met 0x20.
    lda.z dy
    sec
    sbc #$20
    sta.z dy
    lda.z dy+1
    sbc #>$20
    sta.z dy+1
    jmp __b5
    // main::@24
  __b24:
    // dx -= 0x10
    // [116] main::dx#2 = main::dx#1 - $10 -- vwsz1=vwsz1_minus_vbsc1 
    // Indien de x positie van het muurtje lager of gelijk aan 130, dan versnellen we op de x-delta met 0x10.
    lda.z dx
    sec
    sbc #$10
    sta.z dx
    lda.z dx+1
    sbc #>$10
    sta.z dx+1
    jmp __b25
    // main::@13
  __b13:
    // if (wall_y < wall_max)
    // [117] if(main::wall_y#15>=main::wall_max#0) goto main::@14 -- vbuz1_ge_vbuc1_then_la1 
    lda.z wall_y
    cmp #wall_max
    bcc !__b14+
    jmp __b14
  !__b14:
    // main::@18
    // wall_y++;
    // [118] main::wall_y#2 = ++ main::wall_y#15 -- vbuz1=_inc_vbuz1 
    inc.z wall_y
    // sound_note(51, 78, 1)
    // [119] call sound_note
    // [213] phi from main::@18 to sound_note [phi:main::@18->sound_note]
    // [213] phi sound_note::return#0 = sound_note::duration#3 [phi:main::@18->sound_note#0] -- vbuz1=vbuc1 
    lda #sound_note.duration
    sta.z sound_note.return
    // [213] phi sound_note::frequency#8 = $4e [phi:main::@18->sound_note#1] -- vbuyy=vbuc1 
    ldy #$4e
    // [213] phi sound_note::octave#8 = $33 [phi:main::@18->sound_note#2] -- vbuxx=vbuc1 
    ldx #$33
    jsr sound_note
    // sound_note(51, 78, 1)
    // [120] sound_note::return#14 = sound_note::return#0 -- vbuaa=vbuz1 
    lda.z sound_note.return
    // main::@56
    // sound = sound_note(51, 78, 1)
    // [121] main::sound#5 = sound_note::return#14 -- vbuz1=vbuaa 
    sta.z sound
    jmp __b14
    // main::@12
  __b12:
    // if (wall_y > wall_min)
    // [122] if(main::wall_y#15<main::wall_min+1) goto main::@14 -- vbuz1_lt_vbuc1_then_la1 
    lda.z wall_y
    cmp #wall_min+1
    bcs !__b14+
    jmp __b14
  !__b14:
    // main::@17
    // wall_y--;
    // [123] main::wall_y#1 = -- main::wall_y#15 -- vbuz1=_dec_vbuz1 
    dec.z wall_y
    // sound_note(15, 78, 1)
    // [124] call sound_note
    // [213] phi from main::@17 to sound_note [phi:main::@17->sound_note]
    // [213] phi sound_note::return#0 = sound_note::duration#2 [phi:main::@17->sound_note#0] -- vbuz1=vbuc1 
    lda #sound_note.duration
    sta.z sound_note.return
    // [213] phi sound_note::frequency#8 = $4e [phi:main::@17->sound_note#1] -- vbuyy=vbuc1 
    ldy #$4e
    // [213] phi sound_note::octave#8 = $f [phi:main::@17->sound_note#2] -- vbuxx=vbuc1 
    ldx #$f
    jsr sound_note
    // sound_note(15, 78, 1)
    // [125] sound_note::return#13 = sound_note::return#0 -- vbuaa=vbuz1 
    lda.z sound_note.return
    // main::@55
    // sound = sound_note(15, 78, 1)
    // [126] main::sound#4 = sound_note::return#13 -- vbuz1=vbuaa 
    sta.z sound
    jmp __b14
    // main::@11
  __b11:
    // if (wall_x < 150)
    // [127] if(main::wall_x#10>=$96) goto main::@14 -- vbuz1_ge_vbuc1_then_la1 
    lda.z wall_x
    cmp #$96
    bcc !__b14+
    jmp __b14
  !__b14:
    // main::@16
    // wall_x++;
    // [128] main::wall_x#2 = ++ main::wall_x#10 -- vbuz1=_inc_vbuz1 
    inc.z wall_x
    // sound_note(15, 133, 1)
    // [129] call sound_note
    // [213] phi from main::@16 to sound_note [phi:main::@16->sound_note]
    // [213] phi sound_note::return#0 = sound_note::duration#1 [phi:main::@16->sound_note#0] -- vbuz1=vbuc1 
    lda #sound_note.duration
    sta.z sound_note.return
    // [213] phi sound_note::frequency#8 = $85 [phi:main::@16->sound_note#1] -- vbuyy=vbuc1 
    ldy #$85
    // [213] phi sound_note::octave#8 = $f [phi:main::@16->sound_note#2] -- vbuxx=vbuc1 
    ldx #$f
    jsr sound_note
    // sound_note(15, 133, 1)
    // [130] sound_note::return#12 = sound_note::return#0 -- vbuaa=vbuz1 
    lda.z sound_note.return
    // main::@54
    // sound = sound_note(15, 133, 1)
    // [131] main::sound#3 = sound_note::return#12 -- vbuz1=vbuaa 
    sta.z sound
    jmp __b14
    // main::@10
  __b10:
    // if (wall_x > 120)
    // [132] if(main::wall_x#10<$78+1) goto main::@14 -- vbuz1_lt_vbuc1_then_la1 
    lda.z wall_x
    cmp #$78+1
    bcs !__b14+
    jmp __b14
  !__b14:
    // main::@15
    // wall_x--;
    // [133] main::wall_x#1 = -- main::wall_x#10 -- vbuz1=_dec_vbuz1 
    dec.z wall_x
    // sound_note(15, 133, 1)
    // [134] call sound_note
    // [213] phi from main::@15 to sound_note [phi:main::@15->sound_note]
    // [213] phi sound_note::return#0 = sound_note::duration#0 [phi:main::@15->sound_note#0] -- vbuz1=vbuc1 
    lda #sound_note.duration
    sta.z sound_note.return
    // [213] phi sound_note::frequency#8 = $85 [phi:main::@15->sound_note#1] -- vbuyy=vbuc1 
    ldy #$85
    // [213] phi sound_note::octave#8 = $f [phi:main::@15->sound_note#2] -- vbuxx=vbuc1 
    ldx #$f
    jsr sound_note
    // sound_note(15, 133, 1)
    // [135] sound_note::return#11 = sound_note::return#0 -- vbuaa=vbuz1 
    lda.z sound_note.return
    // main::@52
    // sound = sound_note(15, 133, 1)
    // [136] main::sound#2 = sound_note::return#11 -- vbuz1=vbuaa 
    sta.z sound
    jmp __b14
    // main::@4
  __b4:
    // plot(0, y, 1)
    // [137] plot::y#4 = main::y1#2 -- vbuz1=vbuz2 
    lda.z y1
    sta.z plot.y
    // [138] call plot
    // [181] phi from main::@4 to plot [phi:main::@4->plot]
    // [181] phi plot::c#10 = 1 [phi:main::@4->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [181] phi plot::y#10 = plot::y#4 [phi:main::@4->plot#1] -- register_copy 
    // [181] phi plot::x#8 = 0 [phi:main::@4->plot#2] -- vbuxx=vbuc1 
    ldx #0
    jsr plot
    // main::@48
    // plot(159, y, 1)
    // [139] plot::y#5 = main::y1#2 -- vbuz1=vbuz2 
    lda.z y1
    sta.z plot.y
    // [140] call plot
    // [181] phi from main::@48 to plot [phi:main::@48->plot]
    // [181] phi plot::c#10 = 1 [phi:main::@48->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [181] phi plot::y#10 = plot::y#5 [phi:main::@48->plot#1] -- register_copy 
    // [181] phi plot::x#8 = $9f [phi:main::@48->plot#2] -- vbuxx=vbuc1 
    ldx #$9f
    jsr plot
    // main::@49
    // for (char y = border_top; y <= border_bottom; y++)
    // [141] main::y1#1 = ++ main::y1#2 -- vbuz1=_inc_vbuz1 
    inc.z y1
    // [21] phi from main::@49 to main::@3 [phi:main::@49->main::@3]
    // [21] phi main::y1#2 = main::y1#1 [phi:main::@49->main::@3#0] -- register_copy 
    jmp __b3
    // main::@2
  __b2:
    // plot(x, border_top, 1)
    // [142] plot::x#2 = main::x1#2 -- vbuxx=vbuz1 
    ldx.z x1
    // [143] call plot
    // [181] phi from main::@2 to plot [phi:main::@2->plot]
    // [181] phi plot::c#10 = 1 [phi:main::@2->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [181] phi plot::y#10 = main::border_top [phi:main::@2->plot#1] -- vbuz1=vbuc1 
    lda #border_top
    sta.z plot.y
    // [181] phi plot::x#8 = plot::x#2 [phi:main::@2->plot#2] -- register_copy 
    jsr plot
    // main::@46
    // plot(x, border_bottom, 1)
    // [144] plot::x#3 = main::x1#2 -- vbuxx=vbuz1 
    ldx.z x1
    // [145] call plot
    // [181] phi from main::@46 to plot [phi:main::@46->plot]
    // [181] phi plot::c#10 = 1 [phi:main::@46->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [181] phi plot::y#10 = main::border_bottom [phi:main::@46->plot#1] -- vbuz1=vbuc1 
    lda #border_bottom
    sta.z plot.y
    // [181] phi plot::x#8 = plot::x#3 [phi:main::@46->plot#2] -- register_copy 
    jsr plot
    // main::@47
    // for (char x = border_left; x <= border_right; x++)
    // [146] main::x1#1 = ++ main::x1#2 -- vbuz1=_inc_vbuz1 
    inc.z x1
    // [19] phi from main::@47 to main::@1 [phi:main::@47->main::@1]
    // [19] phi main::x1#2 = main::x1#1 [phi:main::@47->main::@1#0] -- register_copy 
    jmp __b1
}
  // cputln
// Print a newline
cputln: {
    // conio_line_text +=  CONIO_WIDTH
    // [147] conio_line_text = conio_line_text + $50 -- pbuz1=pbuz1_plus_vbuc1 
    lda #$50
    clc
    adc.z conio_line_text
    sta.z conio_line_text
    bcc !+
    inc.z conio_line_text+1
  !:
    // conio_cursor_x = 0
    // [148] conio_cursor_x = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y++;
    // [149] conio_cursor_y = ++ conio_cursor_y -- vbuz1=_inc_vbuz1 
    inc.z conio_cursor_y
    // cscroll()
    // [150] call cscroll
    jsr cscroll
    // cputln::@return
    // }
    // [151] return 
    rts
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = 2
    // [153] phi from clrscr to clrscr::@1 [phi:clrscr->clrscr::@1]
    // [153] phi clrscr::line_text#5 = DEFAULT_SCREEN [phi:clrscr->clrscr::@1#0] -- pbuz1=pbuc1 
    lda #<DEFAULT_SCREEN
    sta.z line_text
    lda #>DEFAULT_SCREEN
    sta.z line_text+1
    // [153] phi clrscr::l#2 = 0 [phi:clrscr->clrscr::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // clrscr::@1
  __b1:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [154] if(clrscr::l#2<$19) goto clrscr::@3 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$19
    bcc __b2
    // clrscr::@2
    // conio_cursor_x = 0
    // [155] conio_cursor_x = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y = 0
    // [156] conio_cursor_y = 0 -- vbuz1=vbuc1 
    sta.z conio_cursor_y
    // conio_line_text = CONIO_SCREEN_TEXT
    // [157] conio_line_text = DEFAULT_SCREEN -- pbuz1=pbuc1 
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    // clrscr::@return
    // }
    // [158] return 
    rts
    // [159] phi from clrscr::@1 to clrscr::@3 [phi:clrscr::@1->clrscr::@3]
  __b2:
    // [159] phi clrscr::c#2 = 0 [phi:clrscr::@1->clrscr::@3#0] -- vbuyy=vbuc1 
    ldy #0
    // clrscr::@3
  __b3:
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [160] if(clrscr::c#2<$50) goto clrscr::@4 -- vbuyy_lt_vbuc1_then_la1 
    cpy #$50
    bcc __b4
    // clrscr::@5
    // line_text += CONIO_WIDTH
    // [161] clrscr::line_text#1 = clrscr::line_text#5 + $50 -- pbuz1=pbuz1_plus_vbuc1 
    lda #$50
    clc
    adc.z line_text
    sta.z line_text
    bcc !+
    inc.z line_text+1
  !:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [162] clrscr::l#1 = ++ clrscr::l#2 -- vbuxx=_inc_vbuxx 
    inx
    // [153] phi from clrscr::@5 to clrscr::@1 [phi:clrscr::@5->clrscr::@1]
    // [153] phi clrscr::line_text#5 = clrscr::line_text#1 [phi:clrscr::@5->clrscr::@1#0] -- register_copy 
    // [153] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@5->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@4
  __b4:
    // line_text[c] = ' '
    // [163] clrscr::line_text#5[clrscr::c#2] = ' 'pm -- pbuz1_derefidx_vbuyy=vbuc1 
    lda #' '
    sta (line_text),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [164] clrscr::c#1 = ++ clrscr::c#2 -- vbuyy=_inc_vbuyy 
    iny
    // [159] phi from clrscr::@4 to clrscr::@3 [phi:clrscr::@4->clrscr::@3]
    // [159] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@4->clrscr::@3#0] -- register_copy 
    jmp __b3
}
  // getch
// Get a charakter from the keyboard and return it.
getch: {
    // cbm_k_getin()
    // [166] call cbm_k_getin
    jsr cbm_k_getin
    // [167] cbm_k_getin::return#0 = cbm_k_getin::return#2
    // getch::@1
    // [168] getch::return#0 = cbm_k_getin::return#0
    // getch::@return
    // }
    // [169] return 
    rts
}
  // wall
/**
 * @brief Draws the wall controlled by the player.
 *
 * @param x
 * @param y
 * @param size
 * @param c
 */
// void wall(__zp($e) char x, __zp($13) char y, char size, __zp($f) char c)
wall: {
    .label i = $12
    .label x = $e
    .label y = $13
    .label c = $f
    // [171] phi from wall to wall::@1 [phi:wall->wall::@1]
    // [171] phi wall::i#2 = 0 [phi:wall->wall::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // wall::@1
  __b1:
    // for (char i = 0; i < size; i++)
    // [172] if(wall::i#2<main::wall_size) goto wall::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z i
    cmp #main.wall_size
    bcc __b2
    // wall::@return
    // }
    // [173] return 
    rts
    // wall::@2
  __b2:
    // plot(x, y + i, c)
    // [174] plot::y#1 = wall::y#4 + wall::i#2 -- vbuz1=vbuz2_plus_vbuz3 
    lda.z y
    clc
    adc.z i
    sta.z plot.y
    // [175] plot::x#1 = wall::x#4 -- vbuxx=vbuz1 
    ldx.z x
    // [176] plot::c#0 = wall::c#4 -- vbuz1=vbuz2 
    lda.z c
    sta.z plot.c
    // [177] call plot
    // [181] phi from wall::@2 to plot [phi:wall::@2->plot]
    // [181] phi plot::c#10 = plot::c#0 [phi:wall::@2->plot#0] -- register_copy 
    // [181] phi plot::y#10 = plot::y#1 [phi:wall::@2->plot#1] -- register_copy 
    // [181] phi plot::x#8 = plot::x#1 [phi:wall::@2->plot#2] -- register_copy 
    jsr plot
    // wall::@3
    // for (char i = 0; i < size; i++)
    // [178] wall::i#1 = ++ wall::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [171] phi from wall::@3 to wall::@1 [phi:wall::@3->wall::@1]
    // [171] phi wall::i#2 = wall::i#1 [phi:wall::@3->wall::@1#0] -- register_copy 
    jmp __b1
}
  // sound_off
/**
 * @brief Turn sound off
 * POKE 59467,16 (turn on port for sound output use 0 to turn it off*)
 * 
 */
sound_off: {
    .label sound_addr = $e84b
    // *sound_addr = 0
    // [179] *sound_off::sound_addr = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta sound_addr
    // sound_off::@return
    // }
    // [180] return 
    rts
}
  // plot
/**
 * @brief De plot functie kan gebruikt worden om een blokje te tekenen op het scherm.
 * Echter, de plot functie tekent niet direct op het scherm, maar het tekent op een "bitmap" in het interne geheugen,
 * dat gebruikt wordt door de functie paint, dat deze bitmap op het scherm zal schilderen in de vorm van
 * Commodore [PETSCII](https://www.pagetable.com/c64ref/charset) karakters!
 * Je zal deze functies terug vinden in de main functie.
 *
 * Geeft aan de plot functie 3 parameters:
 *
 * @param x Een 8 bit waarde, dat de positie op de x-as aangeeft.
 * @param y Een 8 bit waarde, dat de positie op de y-as aangeeft.
 * @param c Een waarde 1 of 0. 1 zal een blokje tekenen, en 0 zal het blokje verwijderen!
 *
 * Deze X en Y waarden tellen vanaf de boven linker hoek naar de onder rechter hoek, en de laagste waarde is 0 (niet 1).
 * Dus de waarden van de bovenste linker hoek zijn x = 0 en y = 0.
 * De uiterst rechtse x waarde is x = 159, en de uiterst onderste waarde is y = 49!
 * Bij foutieve waarden, zal de functie rare dingen doen (op zijn minst), en kan er zelfs foutief geheugen overschreven worden!
 * Als resultaat kan je programma zelfs "crashen" :-).
 *
 * Dus je moet telkens zorgen dat de plot functie mooi in het beschikbare vierkent zal tekenen!
 * We bekijken zal in de klas hoe je dit kan coderen!
 *
 */
// void plot(__register(X) char x, __zp(6) char y, __zp($a) char c)
plot: {
    .label __6 = 2
    .label __16 = 2
    .label i = 2
    .label bm = $10
    .label bx = $11
    .label y = 6
    .label c = $a
    .label __19 = 8
    .label __20 = 2
    .label __21 = $c
    .label __22 = 2
    // if (x > 159)
    // [182] if(plot::x#8<$9f+1) goto plot::@8 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$9f+1
    bcc __b1
    // [184] phi from plot to plot::@1 [phi:plot->plot::@1]
    // [184] phi plot::x#10 = $9f [phi:plot->plot::@1#0] -- vbuxx=vbuc1 
    ldx #$9f
    // [183] phi from plot to plot::@8 [phi:plot->plot::@8]
    // plot::@8
    // [184] phi from plot::@8 to plot::@1 [phi:plot::@8->plot::@1]
    // [184] phi plot::x#10 = plot::x#8 [phi:plot::@8->plot::@1#0] -- register_copy 
    // plot::@1
  __b1:
    // if (y > 49)
    // [185] if(plot::y#10<$31+1) goto plot::@9 -- vbuz1_lt_vbuc1_then_la1 
    lda.z y
    cmp #$31+1
    bcc __b2
    // [187] phi from plot::@1 to plot::@2 [phi:plot::@1->plot::@2]
    // [187] phi plot::y#9 = $31 [phi:plot::@1->plot::@2#0] -- vbuz1=vbuc1 
    lda #$31
    sta.z y
    // [186] phi from plot::@1 to plot::@9 [phi:plot::@1->plot::@9]
    // plot::@9
    // [187] phi from plot::@9 to plot::@2 [phi:plot::@9->plot::@2]
    // [187] phi plot::y#9 = plot::y#10 [phi:plot::@9->plot::@2#0] -- register_copy 
    // plot::@2
  __b2:
    // char ix = x >> 1
    // [188] plot::ix#0 = plot::x#10 >> 1 -- vbuyy=vbuxx_ror_1 
    /*
    De plot functie tekent op de interne bitmap. Dit is een lijstje van binaire waarden die een vorm van een blokje uitrekenen
    in PETSCII. We zullen dit toelichten in de klas hoe dit werkt, maar als geheugensteuntje, elk blokje in de bitmap heeft
    een binaire waarde van 4 bits, waarbij de bits de posities van de volgende blokjes weergeven!

    #########
    # 3 # 2 #    3 = 1000
    #########    2 = 0100
    # 1 # 0 #    1 = 0010
    #########    0 = 0001
    */
    txa
    lsr
    tay
    // char iy = y >> 1
    // [189] plot::iy#0 = plot::y#9 >> 1 -- vbuaa=vbuz1_ror_1 
    // We "shiften" de x waarde met 1 stapje naar rechts (dit is binair gelijk aan delen door 2)!
    lda.z y
    lsr
    // (unsigned int)iy * 80
    // [190] plot::$16 = (unsigned int)plot::iy#0 -- vwuz1=_word_vbuaa 
    sta.z __16
    lda #0
    sta.z __16+1
    // [191] plot::$21 = plot::$16 << 2 -- vwuz1=vwuz2_rol_2 
    lda.z __16
    asl
    sta.z __21
    lda.z __16+1
    rol
    sta.z __21+1
    asl.z __21
    rol.z __21+1
    // [192] plot::$22 = plot::$21 + plot::$16 -- vwuz1=vwuz2_plus_vwuz1 
    clc
    lda.z __22
    adc.z __21
    sta.z __22
    lda.z __22+1
    adc.z __21+1
    sta.z __22+1
    // [193] plot::$6 = plot::$22 << 4 -- vwuz1=vwuz1_rol_4 
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    // unsigned int i = (unsigned int)iy * 80 + ix
    // [194] plot::i#0 = plot::$6 + plot::ix#0 -- vwuz1=vwuz1_plus_vbuyy 
    // We berekenen de index in de lijst van de bitmap die moet "geupdate" worden.
    tya
    clc
    adc.z i
    sta.z i
    bcc !+
    inc.z i+1
  !:
    // char bm = bitmap[i]
    // [195] plot::$19 = bitmap + plot::i#0 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z i
    clc
    adc #<bitmap
    sta.z __19
    lda.z i+1
    adc #>bitmap
    sta.z __19+1
    // [196] plot::bm#0 = *plot::$19 -- vbuz1=_deref_pbuz2 
    // We lezen de 8-bit waarde van de bitmap en houden het bij in een tijdelijke bm (=bitmap) variabele.
    ldy #0
    lda (__19),y
    sta.z bm
    // char bx = (x % 2)
    // [197] plot::bx#0 = plot::x#10 & 2-1 -- vbuz1=vbuxx_band_vbuc1 
    // De % operator neemt de "modulus" van de x en y waarde en stockeren dit in de bx en by variablen.
    // Dus als x = 159 en dan modulus 2, dan zal het resultaat 1 zijn! Bij x = 140 modulus 2, is het resultaat 0!
    // Idem voor y!
    lda #2-1
    sax.z bx
    // y % 2
    // [198] plot::$9 = plot::y#9 & 2-1 -- vbuaa=vbuz1_band_vbuc1 
    and.z y
    // char by = (y % 2) * 2
    // [199] plot::by#0 = plot::$9 << 1 -- vbuaa=vbuaa_rol_1 
    // Let op! Deze sequentie zal de resulterende modulus waar eerst vermenigvuldigen met 2, want het *-tje zal een vermenigvuldiging toepassen!
    asl
    // by + bx
    // [200] plot::$11 = plot::by#0 + plot::bx#0 -- vbuaa=vbuaa_plus_vbuz1 
    clc
    adc.z bx
    // char sh = (by + bx) ^ 3
    // [201] plot::sh#0 = plot::$11 ^ 3 -- vbuaa=vbuaa_bxor_vbuc1 
    /*
    Dit is erg ingewikkeld he! Wat we hier doen is de variablen van by en bx eerst optellen.
    En dan doen we een exclusive OR operatie met 3.
    3 in binair = 0b11!
    bx kan maximum 1 of 0 bevatten.
    by kan 2 of 0 bevatten.
    De som van by of bx is dus 0, 1, 2 of 3, he?
    Waarom de exclusive or? Omdat we de waarden moeten "omdraaien", anders kloppen de posities van de blokjes niet in het karakter!
    Ik zal dit toelichten in de klas, maar hieronder is het grafisch voorgesteld.
    We krijgen de waarden als volgt    #########    en we willen dat de waarde      #########
    uit de berekening:                 # 0 # 1 #    als volgt wordt voorgesteld     # 3 # 2 #
                                       #########    om het juiste blokje te         #########
                                       # 2 # 3 #    kiezen:                         # 1 # 0 #
                                       #########                                    #########
    */
    eor #3
    // if (sh)
    // [202] if(0==plot::sh#0) goto plot::@3 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b6
    // plot::@6
    // b = 1 << sh
    // [203] plot::b#1 = 1 << plot::sh#0 -- vbuxx=vbuc1_rol_vbuaa 
    tax
    lda #1
    cpx #0
    beq !e+
  !:
    asl
    dex
    bne !-
  !e:
    tax
    // [204] phi from plot::@6 to plot::@3 [phi:plot::@6->plot::@3]
    // [204] phi plot::b#2 = plot::b#1 [phi:plot::@6->plot::@3#0] -- register_copy 
    jmp __b3
    // [204] phi from plot::@2 to plot::@3 [phi:plot::@2->plot::@3]
  __b6:
    // [204] phi plot::b#2 = 1 [phi:plot::@2->plot::@3#0] -- vbuxx=vbuc1 
    ldx #1
    // plot::@3
  __b3:
    // if (c)
    // [205] if(0!=plot::c#10) goto plot::@4 -- 0_neq_vbuz1_then_la1 
    // Als laatste bekijken we exact wat er moet gebeuren met de "kleur".
    // Onthou! Een 0 verwijdert een blokje en een 1 tekent een blokje.
    // if (c) zal bekijken of c niet nul is, of anders gezegt, een waarde bevat.
    // Indien c niet 0 is, dan zal er een OR operatie plaatvinden met b!
    // Indien c 0 is, dan zal er een AND operatie plaatvinden met de inverse van b!
    lda.z c
    bne __b4
    // plot::@7
    // ~b
    // [206] plot::$15 = ~ plot::b#2 -- vbuaa=_bnot_vbuxx 
    txa
    eor #$ff
    // bm &= ~b
    // [207] plot::bm#2 = plot::bm#0 & plot::$15 -- vbuxx=vbuz1_band_vbuaa 
    // De &= operator berekent een AND operatie met bm en de inverse van b. We lichten wat AND is nader toe in de klas.
    // Als geheugensteuntje voor de & of de AND operator ... 1 = 1 & 1 ... 0 = 1 & 0 ... 0 = 0 & 1 ... 0 = 0 & 0 ...
    // De ~ operator berekent de "inverse" van b. We noemen de inverse ook de NOT operator.
    // Als geheugensteuntje voor de ~ of NOT operator ... 1 = NOT 0 ... 0 = NOT 1 ...
    // Dus als voorbeeld, stel bm = 1010 en b = 0010 ...
    // ... De operatie voluit geschreven wordt: bm = bm & ~b;
    // ... bm = 1010 & ~0010 ...
    // ... bm = 1010 & 1101 ...
    // ... bm = 1000 ... !
    // Wat leren we hieruit? Dat we bit 1 van de bitmap hebben uitgezet, bm = 1000 als resultaat, waar bit 1 nu 0 is geworden van bm!
    ldx.z bm
    axs #0
    // [208] phi from plot::@4 plot::@7 to plot::@5 [phi:plot::@4/plot::@7->plot::@5]
    // [208] phi plot::bm#5 = plot::bm#1 [phi:plot::@4/plot::@7->plot::@5#0] -- register_copy 
    // plot::@5
  __b5:
    // bitmap[i] = bm
    // [209] plot::$20 = bitmap + plot::i#0 -- pbuz1=pbuc1_plus_vwuz1 
    lda.z __20
    clc
    adc #<bitmap
    sta.z __20
    lda.z __20+1
    adc #>bitmap
    sta.z __20+1
    // [210] *plot::$20 = plot::bm#5 -- _deref_pbuz1=vbuxx 
    // En als laatste wijzen we nu de bijgewerkte bitmap toe aan de vorige bitmap index positie!
    // In andere woorden, we overschrijven de vorige waarde met de nieuwe berekende waarde.
    txa
    ldy #0
    sta (__20),y
    // plot::@return
    // }
    // [211] return 
    rts
    // plot::@4
  __b4:
    // bm |= b
    // [212] plot::bm#1 = plot::bm#0 | plot::b#2 -- vbuxx=vbuz1_bor_vbuxx 
    // De |= operator berekent een OR operatie met bm en b. We lichten wat OR is nader toe in de klas.
    // Als geheugensteuntje voor de | of de OR operator ... 1 = 1 | 1 ... 1 = 1 | 0 ... 1 = 0 | 1 ... 0 = 0 | 0 ...
    // Als voorbeeld, stel bm = 1010 en b = 0001 ...
    // ... De operatie voluit geschreven wordt: bm = bm | b;
    // ... bm = 1010 | 0001 ...
    // ... bm = 1011
    // Wat leren we hieruit? Dat we bit 0 van de bitmap hebben aangezet, bm = 1011 als resultaat, waar de laatste waarde nu 1 is!
    txa
    ora.z bm
    tax
    jmp __b5
}
  // sound_note
/**
 * @brief Sound function for the PET
 * HOW DO I MAKE SOUND ON MY PET?
 * This process sets the PET's shift register in a free-running state where the signal is used for sound generation. By adjusting the pattern of the output and
 * the frequency you can produce a wide variety of sounds, and even music!
 *
 * Three pokes are required to make sound:
 * POKE 59467,16 (turn on port for sound output use 0 to turn it off*)
 * POKE 59466,octave (octave number, see below)
 * POKE 59464,frequency (0 for no sound)
 * After setting 59467 you can adjust 59466 and 59464 to get any sort of sound, but to get music you need to set them with specific values, here is a
 * three-octave note table:
 *
 * Note Table:
 * |------|-----------------------------------------------|
 * | Note |	Frequency                                     |
 * | ---- |-----------------------------------------------|
 * |      | octave=15     | octave=51     | octave=85     |
 * |      |---------------|---------------|---------------|
 * |      | Oct.0 | Oct.1 |	Oct.1 | Oct.2 | Oct.2 | Oct.3 |
 * |      |-------|-------|-------|-------|-------|-------|
 * | B    | 251   | 125   | 251   | 125   | 251   | 125   |
 * | C    | 238   | 118   | 238   | 118   | 238   | 118   |
 * | C#   | 224   | 110   | 224   | 110   | 224   | 110   |
 * | D    | 210   | 104   | 210   | 104   | 210   | 104   |
 * | D#   | 199   | 99    | 199   | 99    | 199   | 99    |
 * | E    | 188   | 93    | 188   | 93    | 188   | 93    |
 * | F    | 177	  | 88    | 177   | 88    | 177   | 88    |
 * | F#   | 168   | 83    | 168   | 83    | 168   | 83    |
 * | G    | 158   | 78    | 158   | 78    | 158   | 78    |
 * | G#   | 149   | 74    | 149   | 74    | 149   | 74    |
 * | A    | 140   | 69    | 140   | 69    | 140   | 69    |
 * | A#   | 133   | 65    | 133   | 65    | 133   | 65    |
 * |------|-------|-------|-------|-------|-------|-------|
 *
 * Set 59466 with octave range desired and play notes by setting the frequency in 59464. To stop any sound use POKE 59464,0.
 * Note: due to a hardware bug, leaving the shift register in free running mode will cause problems when attempting to use the datasette so always POKE 59467,0
 * before attempting to use any tape commands.
 *
 * The process for using and playing sound can also be done on the 64/128 and VIC-20 the same connector pins are involved but the POKEs are different:
 * Instead of 59467, 59466, and 59464 for the PET use these:
 * on the VIC-20: 37147, 37146, and 37144
 * on the 64 or 128: 56587, 56586, and 56584
 *
 */
// __register(A) char sound_note(__register(X) char octave, __register(Y) char frequency, char duration)
sound_note: {
    .label octave_addr = $e84a
    .label frequency_addr = $e848
    .label duration = 1
    .label return = $13
    // sound_on()
    // [214] call sound_on
    jsr sound_on
    // sound_note::@1
    // *octave_addr = octave
    // [215] *sound_note::octave_addr = sound_note::octave#8 -- _deref_pbuc1=vbuxx 
    stx octave_addr
    // *frequency_addr = frequency
    // [216] *sound_note::frequency_addr = sound_note::frequency#8 -- _deref_pbuc1=vbuyy 
    sty frequency_addr
    // sound_note::@return
    // }
    // [217] return 
    rts
}
  // paint
// Dit bevat een functie die het scherm tekent op de PET 8032 gebruik makend van de PETSCII karakters!
// Het tekent voor alle 25 lijnen een blokje voor de specifieke kolom aangeduid door de variable x ...
// De functie berekent het juiste karakter door de bitmap te raadplegen voor de respectievelijke x en y.
// Zoals je weet, heeft de bitmap waarden die tussen 0 en 15 liggen, waarbij de posities van het binaire getal aanduiden of
// er in elke quadrant een blokje moet getekend worden of niet.
// Dus bitmap[80 * 0 + x] geeft een waarde tussen 0 en 15 voor de 0-de rij en kolom x !
// We gebruiken nu deze waarde, om via de array block het juiste karaketertje te selecteren.
// Aan de rechterzijde hebben we een berekening met de variabele screen, die de waarde van block zal tekenen op de juiste positie op het scherm!
// Voor alle 25 rijen is zo'n instructie gemaakt, en dit is om performantie redenen!
// We willen dat het scherm snel kan bijgewerkt worden!
paint: {
    // [219] phi from paint to paint::@1 [phi:paint->paint::@1]
    // [219] phi paint::x#2 = 0 [phi:paint->paint::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // paint::@1
  __b1:
    // for (char x = 0; x < 80; x++)
    // [220] if(paint::x#2<$50) goto paint::@2 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$50
    bcc __b2
    // paint::@return
    // }
    // [221] return 
    rts
    // paint::@2
  __b2:
    // *(screen + 80 * 0 + x) = block[bitmap[80 * 0 + x]]
    // [222] screen[paint::x#2] = block[bitmap[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap,x
    lda block,y
    sta screen,x
    // *(screen + 80 * 1 + x) = block[bitmap[80 * 1 + x]]
    // [223] (screen+$50*1)[paint::x#2] = block[(bitmap+$50*1)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*1,x
    lda block,y
    sta screen+$50*1,x
    // *(screen + 80 * 2 + x) = block[bitmap[80 * 2 + x]]
    // [224] (screen+$50*2)[paint::x#2] = block[(bitmap+$50*2)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*2,x
    lda block,y
    sta screen+$50*2,x
    // *(screen + 80 * 3 + x) = block[bitmap[80 * 3 + x]]
    // [225] (screen+$50*3)[paint::x#2] = block[(bitmap+$50*3)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*3,x
    lda block,y
    sta screen+$50*3,x
    // *(screen + 80 * 4 + x) = block[bitmap[80 * 4 + x]]
    // [226] (screen+(unsigned int)$50*4)[paint::x#2] = block[(bitmap+(unsigned int)$50*4)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*4,x
    lda block,y
    sta screen+$50*4,x
    // *(screen + 80 * 5 + x) = block[bitmap[80 * 5 + x]]
    // [227] (screen+(unsigned int)$50*5)[paint::x#2] = block[(bitmap+(unsigned int)$50*5)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*5,x
    lda block,y
    sta screen+$50*5,x
    // *(screen + 80 * 6 + x) = block[bitmap[80 * 6 + x]]
    // [228] (screen+(unsigned int)$50*6)[paint::x#2] = block[(bitmap+(unsigned int)$50*6)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*6,x
    lda block,y
    sta screen+$50*6,x
    // *(screen + 80 * 7 + x) = block[bitmap[80 * 7 + x]]
    // [229] (screen+(unsigned int)$50*7)[paint::x#2] = block[(bitmap+(unsigned int)$50*7)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*7,x
    lda block,y
    sta screen+$50*7,x
    // *(screen + 80 * 8 + x) = block[bitmap[80 * 8 + x]]
    // [230] (screen+(unsigned int)$50*8)[paint::x#2] = block[(bitmap+(unsigned int)$50*8)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*8,x
    lda block,y
    sta screen+$50*8,x
    // *(screen + 80 * 9 + x) = block[bitmap[80 * 9 + x]]
    // [231] (screen+(unsigned int)$50*9)[paint::x#2] = block[(bitmap+(unsigned int)$50*9)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*9,x
    lda block,y
    sta screen+$50*9,x
    // *(screen + 80 * 10 + x) = block[bitmap[80 * 10 + x]]
    // [232] (screen+(unsigned int)$50*$a)[paint::x#2] = block[(bitmap+(unsigned int)$50*$a)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$a,x
    lda block,y
    sta screen+$50*$a,x
    // *(screen + 80 * 11 + x) = block[bitmap[80 * 11 + x]]
    // [233] (screen+(unsigned int)$50*$b)[paint::x#2] = block[(bitmap+(unsigned int)$50*$b)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$b,x
    lda block,y
    sta screen+$50*$b,x
    // *(screen + 80 * 12 + x) = block[bitmap[80 * 12 + x]]
    // [234] (screen+(unsigned int)$50*$c)[paint::x#2] = block[(bitmap+(unsigned int)$50*$c)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$c,x
    lda block,y
    sta screen+$50*$c,x
    // *(screen + 80 * 13 + x) = block[bitmap[80 * 13 + x]]
    // [235] (screen+(unsigned int)$50*$d)[paint::x#2] = block[(bitmap+(unsigned int)$50*$d)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$d,x
    lda block,y
    sta screen+$50*$d,x
    // *(screen + 80 * 14 + x) = block[bitmap[80 * 14 + x]]
    // [236] (screen+(unsigned int)$50*$e)[paint::x#2] = block[(bitmap+(unsigned int)$50*$e)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$e,x
    lda block,y
    sta screen+$50*$e,x
    // *(screen + 80 * 15 + x) = block[bitmap[80 * 15 + x]]
    // [237] (screen+(unsigned int)$50*$f)[paint::x#2] = block[(bitmap+(unsigned int)$50*$f)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$f,x
    lda block,y
    sta screen+$50*$f,x
    // *(screen + 80 * 16 + x) = block[bitmap[80 * 16 + x]]
    // [238] (screen+(unsigned int)$50*$10)[paint::x#2] = block[(bitmap+(unsigned int)$50*$10)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$10,x
    lda block,y
    sta screen+$50*$10,x
    // *(screen + 80 * 17 + x) = block[bitmap[80 * 17 + x]]
    // [239] (screen+(unsigned int)$50*$11)[paint::x#2] = block[(bitmap+(unsigned int)$50*$11)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$11,x
    lda block,y
    sta screen+$50*$11,x
    // *(screen + 80 * 18 + x) = block[bitmap[80 * 18 + x]]
    // [240] (screen+(unsigned int)$50*$12)[paint::x#2] = block[(bitmap+(unsigned int)$50*$12)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$12,x
    lda block,y
    sta screen+$50*$12,x
    // *(screen + 80 * 19 + x) = block[bitmap[80 * 19 + x]]
    // [241] (screen+(unsigned int)$50*$13)[paint::x#2] = block[(bitmap+(unsigned int)$50*$13)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$13,x
    lda block,y
    sta screen+$50*$13,x
    // *(screen + 80 * 20 + x) = block[bitmap[80 * 20 + x]]
    // [242] (screen+(unsigned int)$50*$14)[paint::x#2] = block[(bitmap+(unsigned int)$50*$14)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$14,x
    lda block,y
    sta screen+$50*$14,x
    // *(screen + 80 * 21 + x) = block[bitmap[80 * 21 + x]]
    // [243] (screen+(unsigned int)$50*$15)[paint::x#2] = block[(bitmap+(unsigned int)$50*$15)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$15,x
    lda block,y
    sta screen+$50*$15,x
    // *(screen + 80 * 22 + x) = block[bitmap[80 * 22 + x]]
    // [244] (screen+(unsigned int)$50*$16)[paint::x#2] = block[(bitmap+(unsigned int)$50*$16)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$16,x
    lda block,y
    sta screen+$50*$16,x
    // *(screen + 80 * 23 + x) = block[bitmap[80 * 23 + x]]
    // [245] (screen+(unsigned int)$50*$17)[paint::x#2] = block[(bitmap+(unsigned int)$50*$17)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$17,x
    lda block,y
    sta screen+$50*$17,x
    // *(screen + 80 * 24 + x) = block[bitmap[80 * 24 + x]]
    // [246] (screen+(unsigned int)$50*$18)[paint::x#2] = block[(bitmap+(unsigned int)$50*$18)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$18,x
    lda block,y
    sta screen+$50*$18,x
    // for (char x = 0; x < 80; x++)
    // [247] paint::x#1 = ++ paint::x#2 -- vbuxx=_inc_vbuxx 
    inx
    // [219] phi from paint::@2 to paint::@1 [phi:paint::@2->paint::@1]
    // [219] phi paint::x#2 = paint::x#1 [phi:paint::@2->paint::@1#0] -- register_copy 
    jmp __b1
}
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(char x, char y)
gotoxy: {
    .const x = 0
    .const y = $18
    .const line_offset = y*$50
    // gotoxy::@1
    // conio_cursor_x = x
    // [249] conio_cursor_x = gotoxy::x#2 -- vbuz1=vbuc1 
    lda #x
    sta.z conio_cursor_x
    // conio_cursor_y = y
    // [250] conio_cursor_y = gotoxy::y#2 -- vbuz1=vbuc1 
    lda #y
    sta.z conio_cursor_y
    // conio_line_text = CONIO_SCREEN_TEXT + line_offset
    // [251] conio_line_text = DEFAULT_SCREEN+gotoxy::line_offset#0 -- pbuz1=pbuc1 
    lda #<DEFAULT_SCREEN+line_offset
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN+line_offset
    sta.z conio_line_text+1
    // gotoxy::@return
    // }
    // [252] return 
    rts
}
  // printf_uchar
// Print an unsigned char using a specific format
// void printf_uchar(void (*putc)(char), __register(X) char uvalue, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_uchar: {
    .label format_min_length = 2
    // printf_uchar::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [254] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    // [255] uctoa::value#1 = printf_uchar::uvalue#0
    // [256] call uctoa
  // Format number into buffer
    // [275] phi from printf_uchar::@1 to uctoa [phi:printf_uchar::@1->uctoa]
    jsr uctoa
    // printf_uchar::@2
    // printf_number_buffer(putc, printf_buffer, format)
    // [257] printf_number_buffer::buffer_sign#0 = *((char *)&printf_buffer) -- vbuxx=_deref_pbuc1 
    ldx printf_buffer
    // [258] call printf_number_buffer
  // Print using format
    // [294] phi from printf_uchar::@2 to printf_number_buffer [phi:printf_uchar::@2->printf_number_buffer]
    jsr printf_number_buffer
    // printf_uchar::@return
    // }
    // [259] return 
    rts
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y==CONIO_HEIGHT)
    // [260] if(conio_cursor_y!=$19) goto cscroll::@return -- vbuz1_neq_vbuc1_then_la1 
    lda #$19
    cmp.z conio_cursor_y
    bne __breturn
    // [261] phi from cscroll to cscroll::@1 [phi:cscroll->cscroll::@1]
    // cscroll::@1
    // memcpy(CONIO_SCREEN_TEXT, CONIO_SCREEN_TEXT+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH)
    // [262] call memcpy
    // [317] phi from cscroll::@1 to memcpy [phi:cscroll::@1->memcpy]
    jsr memcpy
    // [263] phi from cscroll::@1 to cscroll::@2 [phi:cscroll::@1->cscroll::@2]
    // cscroll::@2
    // memset(CONIO_SCREEN_TEXT+CONIO_BYTES-CONIO_WIDTH, ' ', CONIO_WIDTH)
    // [264] call memset
    // [324] phi from cscroll::@2 to memset [phi:cscroll::@2->memset]
    jsr memset
    // cscroll::@3
    // conio_line_text -= CONIO_WIDTH
    // [265] conio_line_text = conio_line_text - $50 -- pbuz1=pbuz1_minus_vbuc1 
    sec
    lda.z conio_line_text
    sbc #$50
    sta.z conio_line_text
    lda.z conio_line_text+1
    sbc #0
    sta.z conio_line_text+1
    // conio_cursor_y--;
    // [266] conio_cursor_y = -- conio_cursor_y -- vbuz1=_dec_vbuz1 
    dec.z conio_cursor_y
    // cscroll::@return
  __breturn:
    // }
    // [267] return 
    rts
}
  // cbm_k_getin
/**
 * @brief Scan a character from keyboard without pressing enter.
 * 
 * @return char The character read.
 */
cbm_k_getin: {
    // __mem unsigned char ch
    // [268] cbm_k_getin::ch = 0 -- vbum1=vbuc1 
    lda #0
    sta ch
    // asm
    // asm { jsrCBM_GETIN stach  }
    jsr CBM_GETIN
    sta ch
    // return ch;
    // [270] cbm_k_getin::return#1 = cbm_k_getin::ch -- vbuaa=vbum1 
    // cbm_k_getin::@return
    // }
    // [271] cbm_k_getin::return#2 = cbm_k_getin::return#1
    // [272] return 
    rts
  .segment Data
    ch: .byte 0
}
.segment Code
  // sound_on
/**
 * @brief Turn sound on
 * POKE 59467,16 (turn on port for sound output use 0 to turn it off*)
 * 
 */
sound_on: {
    .label sound_addr = $e84b
    // *sound_addr = 16
    // [273] *sound_on::sound_addr = $10 -- _deref_pbuc1=vbuc2 
    lda #$10
    sta sound_addr
    // sound_on::@return
    // }
    // [274] return 
    rts
}
  // uctoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void uctoa(__register(X) char value, __zp(2) char *buffer, char radix)
uctoa: {
    .const max_digits = 2
    .label digit_value = 6
    .label buffer = 2
    .label digit = $e
    .label started = $f
    // [276] phi from uctoa to uctoa::@1 [phi:uctoa->uctoa::@1]
    // [276] phi uctoa::buffer#11 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:uctoa->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [276] phi uctoa::started#2 = 0 [phi:uctoa->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z started
    // [276] phi uctoa::value#2 = uctoa::value#1 [phi:uctoa->uctoa::@1#2] -- register_copy 
    // [276] phi uctoa::digit#2 = 0 [phi:uctoa->uctoa::@1#3] -- vbuz1=vbuc1 
    sta.z digit
    // uctoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [277] if(uctoa::digit#2<uctoa::max_digits#2-1) goto uctoa::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z digit
    cmp #max_digits-1
    bcc __b2
    // uctoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [278] *uctoa::buffer#11 = DIGITS[uctoa::value#2] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [279] uctoa::buffer#3 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [280] *uctoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // uctoa::@return
    // }
    // [281] return 
    rts
    // uctoa::@2
  __b2:
    // unsigned char digit_value = digit_values[digit]
    // [282] uctoa::digit_value#0 = RADIX_HEXADECIMAL_VALUES_CHAR[uctoa::digit#2] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z digit
    lda RADIX_HEXADECIMAL_VALUES_CHAR,y
    sta.z digit_value
    // if (started || value >= digit_value)
    // [283] if(0!=uctoa::started#2) goto uctoa::@5 -- 0_neq_vbuz1_then_la1 
    lda.z started
    bne __b5
    // uctoa::@7
    // [284] if(uctoa::value#2>=uctoa::digit_value#0) goto uctoa::@5 -- vbuxx_ge_vbuz1_then_la1 
    cpx.z digit_value
    bcs __b5
    // [285] phi from uctoa::@7 to uctoa::@4 [phi:uctoa::@7->uctoa::@4]
    // [285] phi uctoa::buffer#14 = uctoa::buffer#11 [phi:uctoa::@7->uctoa::@4#0] -- register_copy 
    // [285] phi uctoa::started#4 = uctoa::started#2 [phi:uctoa::@7->uctoa::@4#1] -- register_copy 
    // [285] phi uctoa::value#6 = uctoa::value#2 [phi:uctoa::@7->uctoa::@4#2] -- register_copy 
    // uctoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [286] uctoa::digit#1 = ++ uctoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [276] phi from uctoa::@4 to uctoa::@1 [phi:uctoa::@4->uctoa::@1]
    // [276] phi uctoa::buffer#11 = uctoa::buffer#14 [phi:uctoa::@4->uctoa::@1#0] -- register_copy 
    // [276] phi uctoa::started#2 = uctoa::started#4 [phi:uctoa::@4->uctoa::@1#1] -- register_copy 
    // [276] phi uctoa::value#2 = uctoa::value#6 [phi:uctoa::@4->uctoa::@1#2] -- register_copy 
    // [276] phi uctoa::digit#2 = uctoa::digit#1 [phi:uctoa::@4->uctoa::@1#3] -- register_copy 
    jmp __b1
    // uctoa::@5
  __b5:
    // uctoa_append(buffer++, value, digit_value)
    // [287] uctoa_append::buffer#0 = uctoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z uctoa_append.buffer
    lda.z buffer+1
    sta.z uctoa_append.buffer+1
    // [288] uctoa_append::value#0 = uctoa::value#2
    // [289] uctoa_append::sub#0 = uctoa::digit_value#0
    // [290] call uctoa_append
    // [330] phi from uctoa::@5 to uctoa_append [phi:uctoa::@5->uctoa_append]
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // [291] uctoa_append::return#0 = uctoa_append::value#2
    // uctoa::@6
    // value = uctoa_append(buffer++, value, digit_value)
    // [292] uctoa::value#0 = uctoa_append::return#0
    // value = uctoa_append(buffer++, value, digit_value);
    // [293] uctoa::buffer#4 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [285] phi from uctoa::@6 to uctoa::@4 [phi:uctoa::@6->uctoa::@4]
    // [285] phi uctoa::buffer#14 = uctoa::buffer#4 [phi:uctoa::@6->uctoa::@4#0] -- register_copy 
    // [285] phi uctoa::started#4 = 1 [phi:uctoa::@6->uctoa::@4#1] -- vbuz1=vbuc1 
    lda #1
    sta.z started
    // [285] phi uctoa::value#6 = uctoa::value#0 [phi:uctoa::@6->uctoa::@4#2] -- register_copy 
    jmp __b4
}
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(void (*putc)(char), __register(X) char buffer_sign, char *buffer_digits, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label __19 = 2
    .label padding = $12
    // [295] phi from printf_number_buffer to printf_number_buffer::@4 [phi:printf_number_buffer->printf_number_buffer::@4]
    // printf_number_buffer::@4
    // strlen(buffer.digits)
    // [296] call strlen
    // [337] phi from printf_number_buffer::@4 to strlen [phi:printf_number_buffer::@4->strlen]
    jsr strlen
    // strlen(buffer.digits)
    // [297] strlen::return#2 = strlen::len#2
    // printf_number_buffer::@9
    // [298] printf_number_buffer::$19 = strlen::return#2
    // signed char len = (signed char)strlen(buffer.digits)
    // [299] printf_number_buffer::len#0 = (signed char)printf_number_buffer::$19 -- vbsaa=_sbyte_vwuz1 
    // There is a minimum length - work out the padding
    lda.z __19
    // if(buffer.sign)
    // [300] if(0==printf_number_buffer::buffer_sign#0) goto printf_number_buffer::@8 -- 0_eq_vbuxx_then_la1 
    cpx #0
    beq __b8
    // printf_number_buffer::@5
    // len++;
    // [301] printf_number_buffer::len#1 = ++ printf_number_buffer::len#0 -- vbsaa=_inc_vbsaa 
    clc
    adc #1
    // [302] phi from printf_number_buffer::@5 printf_number_buffer::@9 to printf_number_buffer::@8 [phi:printf_number_buffer::@5/printf_number_buffer::@9->printf_number_buffer::@8]
    // [302] phi printf_number_buffer::len#2 = printf_number_buffer::len#1 [phi:printf_number_buffer::@5/printf_number_buffer::@9->printf_number_buffer::@8#0] -- register_copy 
    // printf_number_buffer::@8
  __b8:
    // padding = (signed char)format.min_length - len
    // [303] printf_number_buffer::padding#1 = (signed char)printf_uchar::format_min_length#0 - printf_number_buffer::len#2 -- vbsz1=vbsc1_minus_vbsaa 
    eor #$ff
    sec
    adc #printf_uchar.format_min_length
    sta.z padding
    // if(padding<0)
    // [304] if(printf_number_buffer::padding#1>=0) goto printf_number_buffer::@11 -- vbsz1_ge_0_then_la1 
    cmp #0
    bpl __b2
    // [306] phi from printf_number_buffer::@8 to printf_number_buffer::@1 [phi:printf_number_buffer::@8->printf_number_buffer::@1]
    // [306] phi printf_number_buffer::padding#10 = 0 [phi:printf_number_buffer::@8->printf_number_buffer::@1#0] -- vbsz1=vbsc1 
    lda #0
    sta.z padding
    // [305] phi from printf_number_buffer::@8 to printf_number_buffer::@11 [phi:printf_number_buffer::@8->printf_number_buffer::@11]
    // printf_number_buffer::@11
    // [306] phi from printf_number_buffer::@11 to printf_number_buffer::@1 [phi:printf_number_buffer::@11->printf_number_buffer::@1]
    // [306] phi printf_number_buffer::padding#10 = printf_number_buffer::padding#1 [phi:printf_number_buffer::@11->printf_number_buffer::@1#0] -- register_copy 
    // printf_number_buffer::@1
    // printf_number_buffer::@2
  __b2:
    // if(buffer.sign)
    // [307] if(0==printf_number_buffer::buffer_sign#0) goto printf_number_buffer::@10 -- 0_eq_vbuxx_then_la1 
    cpx #0
    beq __b10
    // printf_number_buffer::@6
    // putc(buffer.sign)
    // [308] stackpush(char) = printf_number_buffer::buffer_sign#0 -- _stackpushbyte_=vbuxx 
    txa
    pha
    // [309] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_number_buffer::@10
  __b10:
    // if(format.zero_padding && padding)
    // [311] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@7 -- 0_neq_vbsz1_then_la1 
    lda.z padding
    cmp #0
    bne __b7
    // [314] phi from printf_number_buffer::@10 printf_number_buffer::@7 to printf_number_buffer::@3 [phi:printf_number_buffer::@10/printf_number_buffer::@7->printf_number_buffer::@3]
    jmp __b3
    // printf_number_buffer::@7
  __b7:
    // printf_padding(putc, '0',(char)padding)
    // [312] printf_padding::length#1 = (char)printf_number_buffer::padding#10 -- vbuz1=vbuz2 
    lda.z padding
    sta.z printf_padding.length
    // [313] call printf_padding
    // [343] phi from printf_number_buffer::@7 to printf_padding [phi:printf_number_buffer::@7->printf_padding]
    jsr printf_padding
    // printf_number_buffer::@3
  __b3:
    // printf_str(putc, buffer.digits)
    // [315] call printf_str
    // [351] phi from printf_number_buffer::@3 to printf_str [phi:printf_number_buffer::@3->printf_str]
    jsr printf_str
    // printf_number_buffer::@return
    // }
    // [316] return 
    rts
}
  // memcpy
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(void *destination, void *source, unsigned int num)
memcpy: {
    .const num = $19*$50-$50
    .label destination = DEFAULT_SCREEN
    .label source = DEFAULT_SCREEN+$50
    .label src_end = source+num
    .label dst = 4
    .label src = 2
    // [318] phi from memcpy to memcpy::@1 [phi:memcpy->memcpy::@1]
    // [318] phi memcpy::dst#2 = (char *)memcpy::destination#0 [phi:memcpy->memcpy::@1#0] -- pbuz1=pbuc1 
    lda #<destination
    sta.z dst
    lda #>destination
    sta.z dst+1
    // [318] phi memcpy::src#2 = (char *)memcpy::source#0 [phi:memcpy->memcpy::@1#1] -- pbuz1=pbuc1 
    lda #<source
    sta.z src
    lda #>source
    sta.z src+1
    // memcpy::@1
  __b1:
    // while(src!=src_end)
    // [319] if(memcpy::src#2!=memcpy::src_end#0) goto memcpy::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z src+1
    cmp #>src_end
    bne __b2
    lda.z src
    cmp #<src_end
    bne __b2
    // memcpy::@return
    // }
    // [320] return 
    rts
    // memcpy::@2
  __b2:
    // *dst++ = *src++
    // [321] *memcpy::dst#2 = *memcpy::src#2 -- _deref_pbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    // [322] memcpy::dst#1 = ++ memcpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [323] memcpy::src#1 = ++ memcpy::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [318] phi from memcpy::@2 to memcpy::@1 [phi:memcpy::@2->memcpy::@1]
    // [318] phi memcpy::dst#2 = memcpy::dst#1 [phi:memcpy::@2->memcpy::@1#0] -- register_copy 
    // [318] phi memcpy::src#2 = memcpy::src#1 [phi:memcpy::@2->memcpy::@1#1] -- register_copy 
    jmp __b1
}
  // memset
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .const c = ' '
    .const num = $50
    .label str = DEFAULT_SCREEN+$19*$50-$50
    .label end = str+num
    .label dst = 2
    // [325] phi from memset to memset::@1 [phi:memset->memset::@1]
    // [325] phi memset::dst#2 = (char *)memset::str#0 [phi:memset->memset::@1#0] -- pbuz1=pbuc1 
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
    // memset::@1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    // [326] if(memset::dst#2!=memset::end#0) goto memset::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // memset::@return
    // }
    // [327] return 
    rts
    // memset::@2
  __b2:
    // *dst = c
    // [328] *memset::dst#2 = memset::c#0 -- _deref_pbuz1=vbuc1 
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    // [329] memset::dst#1 = ++ memset::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [325] phi from memset::@2 to memset::@1 [phi:memset::@2->memset::@1]
    // [325] phi memset::dst#2 = memset::dst#1 [phi:memset::@2->memset::@1#0] -- register_copy 
    jmp __b1
}
  // uctoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __register(X) char uctoa_append(__zp(4) char *buffer, __register(X) char value, __zp(6) char sub)
uctoa_append: {
    .label buffer = 4
    .label sub = 6
    // [331] phi from uctoa_append to uctoa_append::@1 [phi:uctoa_append->uctoa_append::@1]
    // [331] phi uctoa_append::digit#2 = 0 [phi:uctoa_append->uctoa_append::@1#0] -- vbuyy=vbuc1 
    ldy #0
    // [331] phi uctoa_append::value#2 = uctoa_append::value#0 [phi:uctoa_append->uctoa_append::@1#1] -- register_copy 
    // uctoa_append::@1
  __b1:
    // while (value >= sub)
    // [332] if(uctoa_append::value#2>=uctoa_append::sub#0) goto uctoa_append::@2 -- vbuxx_ge_vbuz1_then_la1 
    cpx.z sub
    bcs __b2
    // uctoa_append::@3
    // *buffer = DIGITS[digit]
    // [333] *uctoa_append::buffer#0 = DIGITS[uctoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuyy 
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // uctoa_append::@return
    // }
    // [334] return 
    rts
    // uctoa_append::@2
  __b2:
    // digit++;
    // [335] uctoa_append::digit#1 = ++ uctoa_append::digit#2 -- vbuyy=_inc_vbuyy 
    iny
    // value -= sub
    // [336] uctoa_append::value#1 = uctoa_append::value#2 - uctoa_append::sub#0 -- vbuxx=vbuxx_minus_vbuz1 
    txa
    sec
    sbc.z sub
    tax
    // [331] phi from uctoa_append::@2 to uctoa_append::@1 [phi:uctoa_append::@2->uctoa_append::@1]
    // [331] phi uctoa_append::digit#2 = uctoa_append::digit#1 [phi:uctoa_append::@2->uctoa_append::@1#0] -- register_copy 
    // [331] phi uctoa_append::value#2 = uctoa_append::value#1 [phi:uctoa_append::@2->uctoa_append::@1#1] -- register_copy 
    jmp __b1
}
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// __zp(2) unsigned int strlen(__zp(4) char *str)
strlen: {
    .label len = 2
    .label str = 4
    .label return = 2
    // [338] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [338] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z len
    sta.z len+1
    // [338] phi strlen::str#2 = printf_number_buffer::buffer_digits#0 [phi:strlen->strlen::@1#1] -- pbuz1=pbuc1 
    lda #<printf_number_buffer.buffer_digits
    sta.z str
    lda #>printf_number_buffer.buffer_digits
    sta.z str+1
    // strlen::@1
  __b1:
    // while(*str)
    // [339] if(0!=*strlen::str#2) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [340] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [341] strlen::len#1 = ++ strlen::len#2 -- vwuz1=_inc_vwuz1 
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    // [342] strlen::str#0 = ++ strlen::str#2 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [338] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [338] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [338] phi strlen::str#2 = strlen::str#0 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
}
  // printf_padding
// Print a padding char a number of times
// void printf_padding(void (*putc)(char), char pad, __zp($10) char length)
printf_padding: {
    .const pad = '0'
    .label i = $a
    .label length = $10
    // [344] phi from printf_padding to printf_padding::@1 [phi:printf_padding->printf_padding::@1]
    // [344] phi printf_padding::i#2 = 0 [phi:printf_padding->printf_padding::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // printf_padding::@1
  __b1:
    // for(char i=0;i<length; i++)
    // [345] if(printf_padding::i#2<printf_padding::length#1) goto printf_padding::@2 -- vbuz1_lt_vbuz2_then_la1 
    lda.z i
    cmp.z length
    bcc __b2
    // printf_padding::@return
    // }
    // [346] return 
    rts
    // printf_padding::@2
  __b2:
    // putc(pad)
    // [347] stackpush(char) = printf_padding::pad#1 -- _stackpushbyte_=vbuc1 
    lda #pad
    pha
    // [348] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_padding::@3
    // for(char i=0;i<length; i++)
    // [350] printf_padding::i#1 = ++ printf_padding::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [344] phi from printf_padding::@3 to printf_padding::@1 [phi:printf_padding::@3->printf_padding::@1]
    // [344] phi printf_padding::i#2 = printf_padding::i#1 [phi:printf_padding::@3->printf_padding::@1#0] -- register_copy 
    jmp __b1
}
  // printf_str
/// Print a NUL-terminated string
// void printf_str(void (*putc)(char), __zp($c) const char *s)
printf_str: {
    .label s = $c
    // [352] phi from printf_str to printf_str::@1 [phi:printf_str->printf_str::@1]
    // [352] phi printf_str::s#2 = printf_number_buffer::buffer_digits#0 [phi:printf_str->printf_str::@1#0] -- pbuz1=pbuc1 
    lda #<printf_number_buffer.buffer_digits
    sta.z s
    lda #>printf_number_buffer.buffer_digits
    sta.z s+1
    // printf_str::@1
  __b1:
    // while(c=*s++)
    // [353] printf_str::c#1 = *printf_str::s#2 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (s),y
    // [354] printf_str::s#0 = ++ printf_str::s#2 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [355] if(0!=printf_str::c#1) goto printf_str::@2 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b2
    // printf_str::@return
    // }
    // [356] return 
    rts
    // printf_str::@2
  __b2:
    // putc(c)
    // [357] stackpush(char) = printf_str::c#1 -- _stackpushbyte_=vbuaa 
    pha
    // [358] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // [352] phi from printf_str::@2 to printf_str::@1 [phi:printf_str::@2->printf_str::@1]
    // [352] phi printf_str::s#2 = printf_str::s#0 [phi:printf_str::@2->printf_str::@1#0] -- register_copy 
    jmp __b1
}
  // File Data
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
  // De bitmap variabele bevat een lijst van alle karakters die op het scherm moeten worden getekend.
  // Het is een "array" van het type char.
  // Het is een soort buffer, dan in het interne geheugen wordt bijgewerkt.
  // OEFENING: We weet waarom we dit soort geheugenbuffer bijhouden? Wat zou het effect zijn als we dit niet zouden hebben?
  bitmap: .byte 0
  .fill $7cf, 0
  // Het interessante is nu dat deze 4-bits overeenstemmen met 16 mogelijke combinaties. Probeer het maar eens.
  // In andere woorden, een 4-bit binair cijfer stelt in het decimale talstelsel een cijfer voor tussen 0 en 15!
  // Voorbeelden zijn 0b1000, 0b1100, 0b0011, 0b0101, 0b1111, 0b0000, ....
  // En nu komt het, voor elke positie of "orde" van een cijfer in dit binaire getal, koppelen we een quadrant in een karakter,
  // om aan te duiden of er een blokje moet getekend worden of niet!
  //
  // #########
  // # 3 # 2 #    3 = 0b1000
  // #########    2 = 0b0100
  // # 1 # 0 #    1 = 0b0010
  // #########    0 = 0b0001
  //
  // En de block variable bevat nu een aanduiding van elk karakter in het PETSCII karakterset, met het desbetreffende blokje.
  // Bekijk de [PETSCII](https://www.pagetable.com/c64ref/charset) karakterset via deze link.
  //
  // Belangrijk: Bij deze declaratie noteren we 16 elementen als grootte, maar bij het gebruik van deze array, verder in het programma,
  // zijn de index waarden enkel tussen 0 en 15 toegelaten! Indien er een waarde groter dan 0 en 15 worden gebruikt, heb je een overflow!
  // In die geval zal er een onbekend geheugen worden gelezen of nog erger, geschreven! Dit mag in een programma nooit gebeuren!
  block: .byte $10*2, $10*6+$c, $10*7+$b, $10*6+2, $10*7+$c, $10*$e+1, $10*$f+$f, $10*$f+$e, $10*7+$e, $10*7+$f, $10*6+1, $10*$f+$c, $10*$e+2, $10*$f+$b, $10*$e+$c, $10*$a
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
