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
 * We laten ook de muur aan de rechterzijde weg, dus je moet nu altijd het balletje goed opvangen.
 * Als de speler het balletje niet kan opvangen, dan stopt het spel.
 *
 * 
 * Bekijk OEFENING sectie(s) om dit programma te vervolledigen.
 * 
 * OEFENING 10.1: Bestudeer de geluid (sound) functies.
 *   - Leer ze gebruiken door de voorbeelden in de code te bekijken.
 *   - Verander het octaaf, frequentie en duurtijd bij enkele van deze geluidjes.
 * 
 * OEFENING 10.2: Voeg geluidjes toe aan het spel.
 *   - Voeg geluidjes toe als het balletje de boven, linker en onderzijde van het spel raakt.
 * 
 * OEFENING 10.3: Bestudeer hoe het spel het geluid aanzet, en stopt. 
 *   - Waar wordt het geluid stopgezet en hoe gebeurd dit?
 * 
 * OEFENING 10.4: Verwijder de rechter muur van het spel. 
 *   - De rechter muur mag niet meer getekend worden.
 * 
 * OEFENING 10.5: Als het balletje de rechterzijde raakt, dan stopt het spel in game over mode.
 *   - Maak het scherm schoon
 *   - Toon de tekst: "GAME OVER !!!"
 *   - Als de speler gewoon de 'x' drukt op de toetsenbord, dan stopt het spel ook.
 *     In dit geval toont het spel de boodschap "SEE YOU NEXT TIME !!!"
 * 
 * OEFENING 10.6: Voeg logica toe als de speler het balletje niet kan opvangen met het muurtje.
 *   - Speel een geluid van boven naar beneden (of een geluidsequentie naar uw wensen),
 *   - Noteer dat, indien de speler de 'x' gebruikt, het spel gewoon moet stoppen zonder enig geluidje!
 * 
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
  .const STACK_BASE = $103
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
  .label conio_cursor_x = $15
  // The current cursor y-position
  .label conio_cursor_y = $d
  // The current text cursor line start
  .label conio_line_text = $e
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
 * @brief De main functie van pong.
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
    .label x1 = $15
    .label y1 = $d
    .label ch = $1c
    // Dit wist het scherm :-)
    .label sound = $19
    // We declareren de variabelen die de positie bijhouden van het muurtje (wall).
    // We kunnen dit muurtje omhoog en omlaag schuiven door met de pijl omhoog of omlaag te tikken.
    // Ons programma zal dan de waarden wall_x en wall_y verminderen of vermeerderen.
    // We houden ook een grootte bij in wall_size.
    .label wall_x = $1e
    // We introduceren een fixed point x en y, waarvan de hoogste byte het gehele gedeelte van het getal bevat
    // en de laagste byte het fractionele gedeelte.
    .label fx = $e
    .label fy = $22
    // De hoogste byte wijzen we toe aan de x en y variabelen om te plotten.
    .label x = $21
    .label y = $1f
    .label wall_y = $1d
    // Deze werk variabelen houden de "deltas" bij van de richting van het balletje.
    // Deze zijn nu 16-bit variabelen, maar de zijn "signed". Dit wil zeggen,
    // dat de variabelen ook een negatieve waarde kunnen hebben!
    // De laagste byte van deze variabelen bevatten het fractionele gedeelte.
    .label dx = $1a
    .label dy = $16
    // Dit wist het scherm :-)
    .label sound_1 = $18
    .label i = $10
    .label game_over = $20
    // clrscr()
    // [18] call clrscr
    // [179] phi from main to clrscr [phi:main->clrscr]
    jsr clrscr
    // [19] phi from main to main::@2 [phi:main->main::@2]
    // [19] phi main::x1#2 = main::border_left [phi:main->main::@2#0] -- vbuz1=vbuc1 
    lda #border_left
    sta.z x1
  // We tekenen eerst het scherm, de randen op de x-as!
    // main::@2
  __b2:
    // for (char x = border_left; x <= border_right; x++)
    // [20] if(main::x1#2<main::border_right+1) goto main::@3 -- vbuz1_lt_vbuc1_then_la1 
    lda.z x1
    cmp #border_right+1
    bcs !__b3+
    jmp __b3
  !__b3:
    // [21] phi from main::@2 to main::@4 [phi:main::@2->main::@4]
    // [21] phi main::y1#2 = main::border_top [phi:main::@2->main::@4#0] -- vbuz1=vbuc1 
    lda #border_top
    sta.z y1
  // We tekenen eerst het scherm, de randen op de y-as!
    // main::@4
  __b4:
    // for (char y = border_top; y <= border_bottom; y++)
    // [22] if(main::y1#2<main::border_bottom+1) goto main::@5 -- vbuz1_lt_vbuc1_then_la1 
    lda.z y1
    cmp #border_bottom+1
    bcs !__b5+
    jmp __b5
  !__b5:
    // [23] phi from main::@4 to main::@6 [phi:main::@4->main::@6]
    // main::@6
    // char ch = getch()
    // [24] call getch
  // Deze variabele ch bevat het karaketer dat wordt gedrukt op het toetsenbord.
  // Het programma wacht niet tot het karaketer gedrukt wordt.
    // [192] phi from main::@6 to getch [phi:main::@6->getch]
    jsr getch
    // char ch = getch()
    // [25] getch::return#2 = getch::return#0
    // main::@57
    // [26] main::ch#0 = getch::return#2 -- vbuz1=vbuaa 
    sta.z ch
    // [27] phi from main::@57 to main::@7 [phi:main::@57->main::@7]
    // [27] phi main::dy#10 = $40 [phi:main::@57->main::@7#0] -- vwsz1=vwsc1 
    lda #<$40
    sta.z dy
    lda #>$40
    sta.z dy+1
    // [27] phi main::fy#10 = $18*$100 [phi:main::@57->main::@7#1] -- vwuz1=vwuc1 
    lda #<$18*$100
    sta.z fy
    lda #>$18*$100
    sta.z fy+1
    // [27] phi main::dx#10 = $80 [phi:main::@57->main::@7#2] -- vwsz1=vwsc1 
    lda #<$80
    sta.z dx
    lda #>$80
    sta.z dx+1
    // [27] phi main::fx#10 = 2*$100 [phi:main::@57->main::@7#3] -- vwuz1=vwuc1 
    lda #<2*$100
    sta.z fx
    lda #>2*$100
    sta.z fx+1
    // [27] phi main::y#11 = byte1 $18*$100 [phi:main::@57->main::@7#4] -- vbuz1=vbuc1 
    lda #>$18*$100
    sta.z y
    // [27] phi main::x#10 = byte1 2*$100 [phi:main::@57->main::@7#5] -- vbuz1=vbuc1 
    lda #>2*$100
    sta.z x
    // [27] phi main::sound#10 = 0 [phi:main::@57->main::@7#6] -- vbuz1=vbuc1 
    lda #0
    sta.z sound_1
    // [27] phi main::wall_y#15 = $16 [phi:main::@57->main::@7#7] -- vbuz1=vbuc1 
    lda #$16
    sta.z wall_y
    // [27] phi main::wall_x#10 = $9a [phi:main::@57->main::@7#8] -- vbuz1=vbuc1 
    lda #$9a
    sta.z wall_x
    // [27] phi main::game_over#18 = 0 [phi:main::@57->main::@7#9] -- vbuz1=vbuc1 
    lda #0
    sta.z game_over
    // [27] phi main::ch#10 = main::ch#0 [phi:main::@57->main::@7#10] -- register_copy 
  // Als we een 'x' drukken op het toetsenbord, dan stoppen we met het spelletje.
    // main::@7
  __b7:
    // while (ch != 'x' && !game_over)
    // [28] if(main::ch#10=='x'pm) goto main::@9 -- vbuz1_eq_vbuc1_then_la1 
    lda #'x'
    cmp.z ch
    beq __b9
    // main::@81
    // [29] if(0==main::game_over#18) goto main::@8 -- 0_eq_vbuz1_then_la1 
    lda.z game_over
    beq __b8
    // [30] phi from main::@7 main::@81 to main::@9 [phi:main::@7/main::@81->main::@9]
    // main::@9
  __b9:
    // clrscr()
    // [31] call clrscr
  // Einde van het spel.
    // [179] phi from main::@9 to clrscr [phi:main::@9->clrscr]
    jsr clrscr
    // main::@59
    // if(game_over == 1)
    // [32] if(main::game_over#18==1) goto main::@1 -- vbuz1_eq_vbuc1_then_la1 
    // OPLOSSING 10.5:
    lda #1
    cmp.z game_over
    beq __b1
    // [33] phi from main::@59 to main::@53 [phi:main::@59->main::@53]
    // main::@53
    // gotoxy(30, 14)
    // [34] call gotoxy
    // [197] phi from main::@53 to gotoxy [phi:main::@53->gotoxy]
    // [197] phi gotoxy::x#4 = $1e [phi:main::@53->gotoxy#0] -- vbuaa=vbuc1 
    lda #$1e
    jsr gotoxy
    // [35] phi from main::@53 to main::@80 [phi:main::@53->main::@80]
    // main::@80
    // printf("SEE YOU NEXT TIME !!!")
    // [36] call printf_str
    // [205] phi from main::@80 to printf_str [phi:main::@80->printf_str]
    // [205] phi printf_str::s#4 = main::s1 [phi:main::@80->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // main::@return
    // }
    // [37] return 
    rts
    // [38] phi from main::@59 to main::@1 [phi:main::@59->main::@1]
    // main::@1
  __b1:
    // gotoxy(36, 14)
    // [39] call gotoxy
    // [197] phi from main::@1 to gotoxy [phi:main::@1->gotoxy]
    // [197] phi gotoxy::x#4 = $24 [phi:main::@1->gotoxy#0] -- vbuaa=vbuc1 
    lda #$24
    jsr gotoxy
    // [40] phi from main::@1 to main::@79 [phi:main::@1->main::@79]
    // main::@79
    // printf("GAME OVER !!!")
    // [41] call printf_str
    // [205] phi from main::@79 to printf_str [phi:main::@79->printf_str]
    // [205] phi printf_str::s#4 = main::s [phi:main::@79->printf_str#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    rts
    // main::@8
  __b8:
    // wall(wall_x, wall_y, wall_size, 0)
    // [42] wall::x#0 = main::wall_x#10 -- vbuz1=vbuz2 
    lda.z wall_x
    sta.z wall.x
    // [43] wall::y#0 = main::wall_y#15 -- vbuz1=vbuz2 
    lda.z wall_y
    sta.z wall.y
    // [44] call wall
  // We wissen het muurtje.
    // [214] phi from main::@8 to wall [phi:main::@8->wall]
    // [214] phi wall::c#4 = 0 [phi:main::@8->wall#0] -- vbuz1=vbuc1 
    lda #0
    sta.z wall.c
    // [214] phi wall::x#4 = wall::x#0 [phi:main::@8->wall#1] -- register_copy 
    // [214] phi wall::y#4 = wall::y#0 [phi:main::@8->wall#2] -- register_copy 
    jsr wall
    // main::@58
    // if(!(sound--))
    // [45] main::sound#1 = -- main::sound#10 -- vbuz1=_dec_vbuz2 
    ldy.z sound_1
    dey
    sty.z sound
    // [46] if(0!=main::sound#10) goto main::@10 -- 0_neq_vbuz1_then_la1 
    lda.z sound_1
    bne __b10
    // [47] phi from main::@58 to main::@45 [phi:main::@58->main::@45]
    // main::@45
    // sound_off()
    // [48] call sound_off
    jsr sound_off
    // main::@10
  __b10:
    // case 0x9D: // Pijltje naar links.
    //             if (wall_x > 120) {
    //                 wall_x--;
    //                 sound_on();
    //                 sound = sound_note(15, 133, 1);
    //             }
    //             break;
    // [49] if(main::ch#10==$9d) goto main::@11 -- vbuz1_eq_vbuc1_then_la1 
    lda #$9d
    cmp.z ch
    bne !__b11+
    jmp __b11
  !__b11:
    // main::@46
    // case 0x1D: // Pijltje naar rechts.
    //             if (wall_x < 150) {
    //                 wall_x++;
    //                 sound_on();
    //                 sound = sound_note(15, 133, 1);
    //             }
    //             break;
    // [50] if(main::ch#10==$1d) goto main::@12 -- vbuz1_eq_vbuc1_then_la1 
    lda #$1d
    cmp.z ch
    bne !__b12+
    jmp __b12
  !__b12:
    // main::@47
    // case 0x91: // Pijltje naar boven.
    //             if (wall_y > wall_min) {
    //                 wall_y--;
    //                 sound_on();
    //                 sound = sound_note(15, 78, 1);
    //             }
    //             break;
    // [51] if(main::ch#10==$91) goto main::@13 -- vbuz1_eq_vbuc1_then_la1 
    lda #$91
    cmp.z ch
    bne !__b13+
    jmp __b13
  !__b13:
    // main::@48
    // case 0x11: // Pijltje naar onder.
    //             if (wall_y < wall_max) {
    //                 wall_y++;
    //                 sound_on();
    //                 sound = sound_note(15, 78, 1);
    //             }
    //             break;
    // [52] if(main::ch#10==$11) goto main::@14 -- vbuz1_eq_vbuc1_then_la1 
    lda #$11
    cmp.z ch
    bne !__b14+
    jmp __b14
  !__b14:
    // [53] phi from main::@11 main::@12 main::@13 main::@14 main::@48 main::@61 main::@64 main::@66 main::@68 to main::@15 [phi:main::@11/main::@12/main::@13/main::@14/main::@48/main::@61/main::@64/main::@66/main::@68->main::@15]
    // [53] phi main::sound#33 = main::sound#1 [phi:main::@11/main::@12/main::@13/main::@14/main::@48/main::@61/main::@64/main::@66/main::@68->main::@15#0] -- register_copy 
    // [53] phi main::wall_y#10 = main::wall_y#15 [phi:main::@11/main::@12/main::@13/main::@14/main::@48/main::@61/main::@64/main::@66/main::@68->main::@15#1] -- register_copy 
    // [53] phi main::wall_x#13 = main::wall_x#10 [phi:main::@11/main::@12/main::@13/main::@14/main::@48/main::@61/main::@64/main::@66/main::@68->main::@15#2] -- register_copy 
    // main::@15
  __b15:
    // plot(x, y, 0)
    // [54] plot::x#5 = main::x#10 -- vbuxx=vbuz1 
    ldx.z x
    // [55] plot::y#5 = main::y#11 -- vbuz1=vbuz2 
    lda.z y
    sta.z plot.y
    // [56] call plot
    // [225] phi from main::@15 to plot [phi:main::@15->plot]
    // [225] phi plot::c#10 = 0 [phi:main::@15->plot#0] -- vbuz1=vbuc1 
    lda #0
    sta.z plot.c
    // [225] phi plot::y#10 = plot::y#5 [phi:main::@15->plot#1] -- register_copy 
    // [225] phi plot::x#7 = plot::x#5 [phi:main::@15->plot#2] -- register_copy 
    jsr plot
    // main::@62
    // fx += dx
    // [57] main::fx#1 = main::fx#10 + main::dx#10 -- vwuz1=vwuz1_plus_vwsz2 
    // Nu werken we de x en y positie bij, we tellen de deltas op bij de x en y waarden.
    clc
    lda.z fx
    adc.z dx
    sta.z fx
    lda.z fx+1
    adc.z dx+1
    sta.z fx+1
    // fy += dy
    // [58] main::fy#1 = main::fy#10 + main::dy#10 -- vwuz1=vwuz1_plus_vwsz2 
    // Hoe kleiner de waarde van het fractionele gedeelte, hoe trager het balletje zal voortbewegen op de x-as.
    clc
    lda.z fy
    adc.z dy
    sta.z fy
    lda.z fy+1
    adc.z dy+1
    sta.z fy+1
    // x = BYTE1(fx)
    // [59] main::x#1 = byte1  main::fx#1 -- vbuz1=_byte1_vwuz2 
    lda.z fx+1
    sta.z x
    // y = BYTE1(fy)
    // [60] main::y#1 = byte1  main::fy#1 -- vbuz1=_byte1_vwuz2 
    lda.z fy+1
    sta.z y
    // wall_y + wall_size
    // [61] main::$42 = main::wall_y#10 + main::wall_size -- vbuxx=vbuz1_plus_vbuc1 
    lax.z wall_y
    axs #-[wall_size]
    // wall_y + wall_size - 1
    // [62] main::$43 = main::$42 - 1 -- vbuxx=vbuxx_minus_1 
    dex
    // if (x == wall_x && y >= wall_y && y <= (wall_y + wall_size - 1))
    // [63] if(main::x#1!=main::wall_x#13) goto main::@24 -- vbuz1_neq_vbuz2_then_la1 
    lda.z x
    cmp.z wall_x
    bne __b6
    // main::@83
    // [64] if(main::y#1<main::wall_y#10) goto main::@24 -- vbuz1_lt_vbuz2_then_la1 
    lda.z y
    cmp.z wall_y
    bcc __b6
    // main::@82
    // [65] if(main::y#1<=main::$43) goto main::@20 -- vbuz1_le_vbuxx_then_la1 
    cpx.z y
    bcc !__b20+
    jmp __b20
  !__b20:
    // [66] phi from main::@82 main::@83 to main::@24 [phi:main::@82/main::@83->main::@24]
  __b6:
    // [66] phi from main::@27 main::@28 main::@29 main::@31 main::@33 main::@34 main::@62 to main::@24 [phi:main::@27/main::@28/main::@29/main::@31/main::@33/main::@34/main::@62->main::@24]
    // [66] phi main::dx#12 = main::dx#41 [phi:main::@27/main::@28/main::@29/main::@31/main::@33/main::@34/main::@62->main::@24#0] -- register_copy 
    // [66] phi main::dy#12 = main::dy#1 [phi:main::@27/main::@28/main::@29/main::@31/main::@33/main::@34/main::@62->main::@24#1] -- register_copy 
    // main::@24
    // if (y == border_top + 1)
    // [67] if(main::y#1!=1) goto main::@84 -- vbuz1_neq_vbuc1_then_la1 
    lda #1
    cmp.z y
    beq !__b84+
    jmp __b84
  !__b84:
    // main::@49
    // dy = -dy
    // [68] main::dy#35 = - main::dy#12 -- vwsz1=_neg_vwsz1 
    lda #0
    sec
    sbc.z dy
    sta.z dy
    lda #0
    sbc.z dy+1
    sta.z dy+1
    // sound_on()
    // [69] call sound_on
    // OPLOSSING 10.2:
    jsr sound_on
    // [70] phi from main::@49 to main::@69 [phi:main::@49->main::@69]
    // main::@69
    // sound_note(85, 99, 1)
    // [71] call sound_note
    // [259] phi from main::@69 to sound_note [phi:main::@69->sound_note]
    // [259] phi sound_note::return#0 = 1 [phi:main::@69->sound_note#0] -- vbuz1=vbuc1 
    lda #1
    sta.z sound_note.return
    // [259] phi sound_note::frequency#8 = $63 [phi:main::@69->sound_note#1] -- vbuz1=vbuc1 
    lda #$63
    sta.z sound_note.frequency
    // [259] phi sound_note::octave#8 = $55 [phi:main::@69->sound_note#2] -- vbuyy=vbuc1 
    ldy #$55
    jsr sound_note
    // sound_note(85, 99, 1)
    // [72] sound_note::return#15 = sound_note::return#0 -- vbuaa=vbuz1 
    lda.z sound_note.return
    // main::@70
    // sound = sound_note(85, 99, 1)
    // [73] main::sound#6 = sound_note::return#15 -- vbuz1=vbuaa 
    sta.z sound_1
    // [74] phi from main::@70 main::@84 to main::@35 [phi:main::@70/main::@84->main::@35]
    // [74] phi main::sound#31 = main::sound#6 [phi:main::@70/main::@84->main::@35#0] -- register_copy 
    // [74] phi main::dy#13 = main::dy#35 [phi:main::@70/main::@84->main::@35#1] -- register_copy 
    // main::@35
  __b35:
    // if (y == border_bottom - 1)
    // [75] if(main::y#1!=main::border_bottom-1) goto main::@36 -- vbuz1_neq_vbuc1_then_la1 
    lda #border_bottom-1
    cmp.z y
    bne __b36
    // main::@50
    // dy = -dy
    // [76] main::dy#6 = - main::dy#13 -- vwsz1=_neg_vwsz1 
    lda #0
    sec
    sbc.z dy
    sta.z dy
    lda #0
    sbc.z dy+1
    sta.z dy+1
    // sound_on()
    // [77] call sound_on
    // OPLOSSING 10.2:
    jsr sound_on
    // [78] phi from main::@50 to main::@71 [phi:main::@50->main::@71]
    // main::@71
    // sound_note(85, 99, 1)
    // [79] call sound_note
    // [259] phi from main::@71 to sound_note [phi:main::@71->sound_note]
    // [259] phi sound_note::return#0 = 1 [phi:main::@71->sound_note#0] -- vbuz1=vbuc1 
    lda #1
    sta.z sound_note.return
    // [259] phi sound_note::frequency#8 = $63 [phi:main::@71->sound_note#1] -- vbuz1=vbuc1 
    lda #$63
    sta.z sound_note.frequency
    // [259] phi sound_note::octave#8 = $55 [phi:main::@71->sound_note#2] -- vbuyy=vbuc1 
    ldy #$55
    jsr sound_note
    // sound_note(85, 99, 1)
    // [80] sound_note::return#16 = sound_note::return#0 -- vbuaa=vbuz1 
    lda.z sound_note.return
    // main::@72
    // sound = sound_note(85, 99, 1)
    // [81] main::sound#7 = sound_note::return#16 -- vbuz1=vbuaa 
    sta.z sound_1
    // [82] phi from main::@35 main::@72 to main::@36 [phi:main::@35/main::@72->main::@36]
    // [82] phi main::dy#60 = main::dy#13 [phi:main::@35/main::@72->main::@36#0] -- register_copy 
    // [82] phi main::sound#28 = main::sound#31 [phi:main::@35/main::@72->main::@36#1] -- register_copy 
    // main::@36
  __b36:
    // if (x == border_left + 1)
    // [83] if(main::x#1!=1) goto main::@37 -- vbuz1_neq_vbuc1_then_la1 
    lda #1
    cmp.z x
    bne __b37
    // main::@51
    // dx = -dx
    // [84] main::dx#4 = - main::dx#12 -- vwsz1=_neg_vwsz1 
    lda #0
    sec
    sbc.z dx
    sta.z dx
    lda #0
    sbc.z dx+1
    sta.z dx+1
    // sound_on()
    // [85] call sound_on
    // OPLOSSING 10.2:
    jsr sound_on
    // [86] phi from main::@51 to main::@73 [phi:main::@51->main::@73]
    // main::@73
    // sound_note(85, 99, 1)
    // [87] call sound_note
    // [259] phi from main::@73 to sound_note [phi:main::@73->sound_note]
    // [259] phi sound_note::return#0 = 1 [phi:main::@73->sound_note#0] -- vbuz1=vbuc1 
    lda #1
    sta.z sound_note.return
    // [259] phi sound_note::frequency#8 = $63 [phi:main::@73->sound_note#1] -- vbuz1=vbuc1 
    lda #$63
    sta.z sound_note.frequency
    // [259] phi sound_note::octave#8 = $55 [phi:main::@73->sound_note#2] -- vbuyy=vbuc1 
    ldy #$55
    jsr sound_note
    // sound_note(85, 99, 1)
    // [88] sound_note::return#17 = sound_note::return#0 -- vbuaa=vbuz1 
    lda.z sound_note.return
    // main::@74
    // sound = sound_note(85, 99, 1)
    // [89] main::sound#8 = sound_note::return#17 -- vbuz1=vbuaa 
    sta.z sound_1
    // [90] phi from main::@36 main::@74 to main::@37 [phi:main::@36/main::@74->main::@37]
    // [90] phi main::dx#62 = main::dx#12 [phi:main::@36/main::@74->main::@37#0] -- register_copy 
    // [90] phi main::sound#25 = main::sound#28 [phi:main::@36/main::@74->main::@37#1] -- register_copy 
    // main::@37
  __b37:
    // if (x == border_right - 1)
    // [91] if(main::x#1!=main::border_right-1) goto main::@38 -- vbuz1_neq_vbuc1_then_la1 
    lda #border_right-1
    cmp.z x
    bne __b38
    // [92] phi from main::@37 to main::@52 [phi:main::@37->main::@52]
    // main::@52
    // sound_on()
    // [93] call sound_on
    // OPLOSSING 10.6:
    jsr sound_on
    // [94] phi from main::@52 to main::@39 [phi:main::@52->main::@39]
    // [94] phi main::frequentie#2 = 0 [phi:main::@52->main::@39#0] -- vbuxx=vbuc1 
    ldx #0
    // main::@39
  __b39:
    // for(char frequentie = 0; frequentie < 255; frequentie++)
    // [95] if(main::frequentie#2<$ff) goto main::@40 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$ff
    bcc __b40
    // [96] phi from main::@39 to main::@41 [phi:main::@39->main::@41]
    // main::@41
    // sound_off()
    // [97] call sound_off
    jsr sound_off
    // [98] phi from main::@41 to main::@38 [phi:main::@41->main::@38]
    // [98] phi main::game_over#10 = 1 [phi:main::@41->main::@38#0] -- vbuz1=vbuc1 
    lda #1
    sta.z game_over
    // [98] phi from main::@37 to main::@38 [phi:main::@37->main::@38]
    // [98] phi main::game_over#10 = main::game_over#18 [phi:main::@37->main::@38#0] -- register_copy 
    // main::@38
  __b38:
    // plot(x, y, 1)
    // [99] plot::x#6 = main::x#1 -- vbuxx=vbuz1 
    ldx.z x
    // [100] plot::y#6 = main::y#1 -- vbuz1=vbuz2 
    lda.z y
    sta.z plot.y
    // [101] call plot
    // [225] phi from main::@38 to plot [phi:main::@38->plot]
    // [225] phi plot::c#10 = 1 [phi:main::@38->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [225] phi plot::y#10 = plot::y#6 [phi:main::@38->plot#1] -- register_copy 
    // [225] phi plot::x#7 = plot::x#6 [phi:main::@38->plot#2] -- register_copy 
    jsr plot
    // main::@75
    // wall(wall_x, wall_y, wall_size, 1)
    // [102] wall::x#1 = main::wall_x#13 -- vbuz1=vbuz2 
    lda.z wall_x
    sta.z wall.x
    // [103] wall::y#1 = main::wall_y#10 -- vbuz1=vbuz2 
    lda.z wall_y
    sta.z wall.y
    // [104] call wall
  // We hertekenen het muurtje.
    // [214] phi from main::@75 to wall [phi:main::@75->wall]
    // [214] phi wall::c#4 = 1 [phi:main::@75->wall#0] -- vbuz1=vbuc1 
    lda #1
    sta.z wall.c
    // [214] phi wall::x#4 = wall::x#1 [phi:main::@75->wall#1] -- register_copy 
    // [214] phi wall::y#4 = wall::y#1 [phi:main::@75->wall#2] -- register_copy 
    jsr wall
    // [105] phi from main::@75 to main::@76 [phi:main::@75->main::@76]
    // main::@76
    // paint()
    // [106] call paint
  // En deze draw functie tekent het volledige scherm door de bitmap te tekenen op alle karakters om het scherm!
    // [263] phi from main::@76 to paint [phi:main::@76->paint]
    jsr paint
    // [107] phi from main::@76 to main::@77 [phi:main::@76->main::@77]
    // main::@77
    // getch()
    // [108] call getch
    // [192] phi from main::@77 to getch [phi:main::@77->getch]
    jsr getch
    // getch()
    // [109] getch::return#3 = getch::return#0
    // main::@78
    // ch = getch()
    // [110] main::ch#1 = getch::return#3 -- vbuz1=vbuaa 
    sta.z ch
    // [27] phi from main::@78 to main::@7 [phi:main::@78->main::@7]
    // [27] phi main::dy#10 = main::dy#60 [phi:main::@78->main::@7#0] -- register_copy 
    // [27] phi main::fy#10 = main::fy#1 [phi:main::@78->main::@7#1] -- register_copy 
    // [27] phi main::dx#10 = main::dx#62 [phi:main::@78->main::@7#2] -- register_copy 
    // [27] phi main::fx#10 = main::fx#1 [phi:main::@78->main::@7#3] -- register_copy 
    // [27] phi main::y#11 = main::y#1 [phi:main::@78->main::@7#4] -- register_copy 
    // [27] phi main::x#10 = main::x#1 [phi:main::@78->main::@7#5] -- register_copy 
    // [27] phi main::sound#10 = main::sound#25 [phi:main::@78->main::@7#6] -- register_copy 
    // [27] phi main::wall_y#15 = main::wall_y#10 [phi:main::@78->main::@7#7] -- register_copy 
    // [27] phi main::wall_x#10 = main::wall_x#13 [phi:main::@78->main::@7#8] -- register_copy 
    // [27] phi main::game_over#18 = main::game_over#10 [phi:main::@78->main::@7#9] -- register_copy 
    // [27] phi main::ch#10 = main::ch#1 [phi:main::@78->main::@7#10] -- register_copy 
    jmp __b7
    // main::@40
  __b40:
    // sound_note((51), frequentie, 0)
    // [111] sound_note::frequency#7 = main::frequentie#2 -- vbuz1=vbuxx 
    stx.z sound_note.frequency
    // [112] call sound_note
    // [259] phi from main::@40 to sound_note [phi:main::@40->sound_note]
    // [259] phi sound_note::return#0 = 0 [phi:main::@40->sound_note#0] -- vbuz1=vbuc1 
    lda #0
    sta.z sound_note.return
    // [259] phi sound_note::frequency#8 = sound_note::frequency#7 [phi:main::@40->sound_note#1] -- register_copy 
    // [259] phi sound_note::octave#8 = $33 [phi:main::@40->sound_note#2] -- vbuyy=vbuc1 
    ldy #$33
    jsr sound_note
    // [113] phi from main::@40 to main::@42 [phi:main::@40->main::@42]
    // [113] phi main::i#2 = 0 [phi:main::@40->main::@42#0] -- vwsz1=vwsc1 
    lda #<0
    sta.z i
    sta.z i+1
    // main::@42
  __b42:
    // for(int i=0; i<100; i++)
    // [114] if(main::i#2<$64) goto main::@43 -- vwsz1_lt_vwuc1_then_la1 
    lda.z i+1
    bmi __b43
    cmp #>$64
    bcc __b43
    bne !+
    lda.z i
    cmp #<$64
    bcc __b43
  !:
    // main::@44
    // for(char frequentie = 0; frequentie < 255; frequentie++)
    // [115] main::frequentie#1 = ++ main::frequentie#2 -- vbuxx=_inc_vbuxx 
    inx
    // [94] phi from main::@44 to main::@39 [phi:main::@44->main::@39]
    // [94] phi main::frequentie#2 = main::frequentie#1 [phi:main::@44->main::@39#0] -- register_copy 
    jmp __b39
    // main::@43
  __b43:
    // for(int i=0; i<100; i++)
    // [116] main::i#1 = ++ main::i#2 -- vwsz1=_inc_vwsz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [113] phi from main::@43 to main::@42 [phi:main::@43->main::@42]
    // [113] phi main::i#2 = main::i#1 [phi:main::@43->main::@42#0] -- register_copy 
    jmp __b42
    // main::@84
  __b84:
    // [117] main::sound#77 = main::sound#33 -- vbuz1=vbuz2 
    lda.z sound
    sta.z sound_1
    jmp __b35
    // main::@20
  __b20:
    // dx = -dx
    // [118] main::dx#1 = - main::dx#10 -- vwsz1=_neg_vwsz1 
    lda #0
    sec
    sbc.z dx
    sta.z dx
    lda #0
    sbc.z dx+1
    sta.z dx+1
    // if (x <= 130)
    // [119] if(main::x#1<$82+1) goto main::@25 -- vbuz1_lt_vbuc1_then_la1 
    // Hier berekenen we de versnelling op de x-as, door dx aan te passen.
    lda.z x
    cmp #$82+1
    bcs !__b25+
    jmp __b25
  !__b25:
    // main::@21
    // if (x <= 140)
    // [120] if(main::x#1<$8c+1) goto main::@26 -- vbuz1_lt_vbuc1_then_la1 
    cmp #$8c+1
    bcc __b26
    // main::@22
    // if (x <= 150)
    // [121] if(main::x#1>=$96+1) goto main::@26 -- vbuz1_ge_vbuc1_then_la1 
    cmp #$96+1
    bcs __b26
    // main::@23
    // dx += 0x10
    // [122] main::dx#3 = main::dx#1 + $10 -- vwsz1=vwsz1_plus_vbsc1 
    // Indien de x positie van het muurtje lager of gelijk aan 150, dan vertragen we op de x-delta met 0x10.
    lda.z dx
    clc
    adc #<$10
    sta.z dx
    lda.z dx+1
    adc #>$10
    sta.z dx+1
    // [123] phi from main::@21 main::@22 main::@23 main::@25 to main::@26 [phi:main::@21/main::@22/main::@23/main::@25->main::@26]
    // [123] phi main::dx#41 = main::dx#1 [phi:main::@21/main::@22/main::@23/main::@25->main::@26#0] -- register_copy 
    // main::@26
  __b26:
    // if (y == wall_y)
    // [124] if(main::y#1==main::wall_y#10) goto main::@27 -- vbuz1_eq_vbuz2_then_la1 
    // Hier berekenen we de versnelling op de y-as, door dy aan te passen.
    lda.z y
    cmp.z wall_y
    beq __b27
    // main::@30
    // wall_y + 1
    // [125] main::$53 = main::wall_y#10 + 1 -- vbuxx=vbuz1_plus_1 
    ldx.z wall_y
    inx
    // if (y == wall_y + 1)
    // [126] if(main::y#1==main::$53) goto main::@28 -- vbuz1_eq_vbuxx_then_la1 
    cpx.z y
    beq __b28
    // main::@31
    // wall_y + 3
    // [127] main::$55 = main::wall_y#10 + 3 -- vbuxx=vbuz1_plus_vbuc1 
    lax.z wall_y
    axs #-[3]
    // if (y <= wall_y + 3)
    // [128] if(main::y#1<=main::$55) goto main::@24 -- vbuz1_le_vbuxx_then_la1 
    cpx.z y
    bcc !__b6+
    jmp __b6
  !__b6:
    // main::@32
    // wall_y + 4
    // [129] main::$57 = main::wall_y#10 + 4 -- vbuxx=vbuz1_plus_vbuc1 
    lax.z wall_y
    axs #-[4]
    // if (y == wall_y + 4)
    // [130] if(main::y#1==main::$57) goto main::@29 -- vbuz1_eq_vbuxx_then_la1 
    cpx.z y
    beq __b29
    // main::@33
    // wall_y + 5
    // [131] main::$59 = main::wall_y#10 + 5 -- vbuxx=vbuz1_plus_vbuc1 
    lax.z wall_y
    axs #-[5]
    // if (y == wall_y + 5)
    // [132] if(main::y#1!=main::$59) goto main::@24 -- vbuz1_neq_vbuxx_then_la1 
    cpx.z y
    beq !__b6+
    jmp __b6
  !__b6:
    // main::@34
    // dy += 0x20
    // [133] main::dy#4 = main::dy#10 + $20 -- vwsz1=vwsz1_plus_vbsc1 
    // Indien de y positie volledig aan de onderkant van het muurtje valt, dan versnellen we de y-delta met 0x20.
    lda.z dy
    clc
    adc #<$20
    sta.z dy
    lda.z dy+1
    adc #>$20
    sta.z dy+1
    jmp __b6
    // main::@29
  __b29:
    // dy += 0x10
    // [134] main::dy#3 = main::dy#10 + $10 -- vwsz1=vwsz1_plus_vbsc1 
    // Indien de y positie bijna aan de onderkant van het muurtje valt, dan versnellen we de y-delta met 0x10.
    lda.z dy
    clc
    adc #<$10
    sta.z dy
    lda.z dy+1
    adc #>$10
    sta.z dy+1
    jmp __b6
    // main::@28
  __b28:
    // dy -= 0x10
    // [135] main::dy#2 = main::dy#10 - $10 -- vwsz1=vwsz1_minus_vbsc1 
    // Indien de y positie bijna aan de top van het muurtje valt, dan vertragen we de y-delta met 0x10.
    lda.z dy
    sec
    sbc #$10
    sta.z dy
    lda.z dy+1
    sbc #>$10
    sta.z dy+1
    jmp __b6
    // main::@27
  __b27:
    // dy -= 0x20
    // [136] main::dy#1 = main::dy#10 - $20 -- vwsz1=vwsz1_minus_vbsc1 
    // Indien de y positie volledig aan de top van het muurtje valt, dan vertragen we de y-delta met 0x20.
    lda.z dy
    sec
    sbc #$20
    sta.z dy
    lda.z dy+1
    sbc #>$20
    sta.z dy+1
    jmp __b6
    // main::@25
  __b25:
    // dx -= 0x10
    // [137] main::dx#2 = main::dx#1 - $10 -- vwsz1=vwsz1_minus_vbsc1 
    // Indien de x positie van het muurtje lager of gelijk aan 130, dan versnellen we op de x-delta met 0x10.
    lda.z dx
    sec
    sbc #$10
    sta.z dx
    lda.z dx+1
    sbc #>$10
    sta.z dx+1
    jmp __b26
    // main::@14
  __b14:
    // if (wall_y < wall_max)
    // [138] if(main::wall_y#15>=main::wall_max#0) goto main::@15 -- vbuz1_ge_vbuc1_then_la1 
    lda.z wall_y
    cmp #wall_max
    bcc !__b15+
    jmp __b15
  !__b15:
    // main::@19
    // wall_y++;
    // [139] main::wall_y#2 = ++ main::wall_y#15 -- vbuz1=_inc_vbuz1 
    inc.z wall_y
    // sound_on()
    // [140] call sound_on
    jsr sound_on
    // [141] phi from main::@19 to main::@67 [phi:main::@19->main::@67]
    // main::@67
    // sound_note(15, 78, 1)
    // [142] call sound_note
    // [259] phi from main::@67 to sound_note [phi:main::@67->sound_note]
    // [259] phi sound_note::return#0 = 1 [phi:main::@67->sound_note#0] -- vbuz1=vbuc1 
    lda #1
    sta.z sound_note.return
    // [259] phi sound_note::frequency#8 = $4e [phi:main::@67->sound_note#1] -- vbuz1=vbuc1 
    lda #$4e
    sta.z sound_note.frequency
    // [259] phi sound_note::octave#8 = $f [phi:main::@67->sound_note#2] -- vbuyy=vbuc1 
    ldy #$f
    jsr sound_note
    // sound_note(15, 78, 1)
    // [143] sound_note::return#14 = sound_note::return#0 -- vbuaa=vbuz1 
    lda.z sound_note.return
    // main::@68
    // sound = sound_note(15, 78, 1)
    // [144] main::sound#5 = sound_note::return#14 -- vbuz1=vbuaa 
    sta.z sound
    jmp __b15
    // main::@13
  __b13:
    // if (wall_y > wall_min)
    // [145] if(main::wall_y#15<main::wall_min+1) goto main::@15 -- vbuz1_lt_vbuc1_then_la1 
    lda.z wall_y
    cmp #wall_min+1
    bcs !__b15+
    jmp __b15
  !__b15:
    // main::@18
    // wall_y--;
    // [146] main::wall_y#1 = -- main::wall_y#15 -- vbuz1=_dec_vbuz1 
    dec.z wall_y
    // sound_on()
    // [147] call sound_on
    jsr sound_on
    // [148] phi from main::@18 to main::@65 [phi:main::@18->main::@65]
    // main::@65
    // sound_note(15, 78, 1)
    // [149] call sound_note
    // [259] phi from main::@65 to sound_note [phi:main::@65->sound_note]
    // [259] phi sound_note::return#0 = 1 [phi:main::@65->sound_note#0] -- vbuz1=vbuc1 
    lda #1
    sta.z sound_note.return
    // [259] phi sound_note::frequency#8 = $4e [phi:main::@65->sound_note#1] -- vbuz1=vbuc1 
    lda #$4e
    sta.z sound_note.frequency
    // [259] phi sound_note::octave#8 = $f [phi:main::@65->sound_note#2] -- vbuyy=vbuc1 
    ldy #$f
    jsr sound_note
    // sound_note(15, 78, 1)
    // [150] sound_note::return#13 = sound_note::return#0 -- vbuaa=vbuz1 
    lda.z sound_note.return
    // main::@66
    // sound = sound_note(15, 78, 1)
    // [151] main::sound#4 = sound_note::return#13 -- vbuz1=vbuaa 
    sta.z sound
    jmp __b15
    // main::@12
  __b12:
    // if (wall_x < 150)
    // [152] if(main::wall_x#10>=$96) goto main::@15 -- vbuz1_ge_vbuc1_then_la1 
    lda.z wall_x
    cmp #$96
    bcc !__b15+
    jmp __b15
  !__b15:
    // main::@17
    // wall_x++;
    // [153] main::wall_x#2 = ++ main::wall_x#10 -- vbuz1=_inc_vbuz1 
    inc.z wall_x
    // sound_on()
    // [154] call sound_on
    jsr sound_on
    // [155] phi from main::@17 to main::@63 [phi:main::@17->main::@63]
    // main::@63
    // sound_note(15, 133, 1)
    // [156] call sound_note
    // [259] phi from main::@63 to sound_note [phi:main::@63->sound_note]
    // [259] phi sound_note::return#0 = 1 [phi:main::@63->sound_note#0] -- vbuz1=vbuc1 
    lda #1
    sta.z sound_note.return
    // [259] phi sound_note::frequency#8 = $85 [phi:main::@63->sound_note#1] -- vbuz1=vbuc1 
    lda #$85
    sta.z sound_note.frequency
    // [259] phi sound_note::octave#8 = $f [phi:main::@63->sound_note#2] -- vbuyy=vbuc1 
    ldy #$f
    jsr sound_note
    // sound_note(15, 133, 1)
    // [157] sound_note::return#12 = sound_note::return#0 -- vbuaa=vbuz1 
    lda.z sound_note.return
    // main::@64
    // sound = sound_note(15, 133, 1)
    // [158] main::sound#3 = sound_note::return#12 -- vbuz1=vbuaa 
    sta.z sound
    jmp __b15
    // main::@11
  __b11:
    // if (wall_x > 120)
    // [159] if(main::wall_x#10<$78+1) goto main::@15 -- vbuz1_lt_vbuc1_then_la1 
    lda.z wall_x
    cmp #$78+1
    bcs !__b15+
    jmp __b15
  !__b15:
    // main::@16
    // wall_x--;
    // [160] main::wall_x#1 = -- main::wall_x#10 -- vbuz1=_dec_vbuz1 
    dec.z wall_x
    // sound_on()
    // [161] call sound_on
    jsr sound_on
    // [162] phi from main::@16 to main::@60 [phi:main::@16->main::@60]
    // main::@60
    // sound_note(15, 133, 1)
    // [163] call sound_note
    // [259] phi from main::@60 to sound_note [phi:main::@60->sound_note]
    // [259] phi sound_note::return#0 = 1 [phi:main::@60->sound_note#0] -- vbuz1=vbuc1 
    lda #1
    sta.z sound_note.return
    // [259] phi sound_note::frequency#8 = $85 [phi:main::@60->sound_note#1] -- vbuz1=vbuc1 
    lda #$85
    sta.z sound_note.frequency
    // [259] phi sound_note::octave#8 = $f [phi:main::@60->sound_note#2] -- vbuyy=vbuc1 
    ldy #$f
    jsr sound_note
    // sound_note(15, 133, 1)
    // [164] sound_note::return#11 = sound_note::return#0 -- vbuaa=vbuz1 
    lda.z sound_note.return
    // main::@61
    // sound = sound_note(15, 133, 1)
    // [165] main::sound#2 = sound_note::return#11 -- vbuz1=vbuaa 
    sta.z sound
    jmp __b15
    // main::@5
  __b5:
    // plot(0, y, 1)
    // [166] plot::y#4 = main::y1#2 -- vbuz1=vbuz2 
    lda.z y1
    sta.z plot.y
    // [167] call plot
    // [225] phi from main::@5 to plot [phi:main::@5->plot]
    // [225] phi plot::c#10 = 1 [phi:main::@5->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [225] phi plot::y#10 = plot::y#4 [phi:main::@5->plot#1] -- register_copy 
    // [225] phi plot::x#7 = 0 [phi:main::@5->plot#2] -- vbuxx=vbuc1 
    ldx #0
    jsr plot
    // main::@56
    // for (char y = border_top; y <= border_bottom; y++)
    // [168] main::y1#1 = ++ main::y1#2 -- vbuz1=_inc_vbuz1 
    inc.z y1
    // [21] phi from main::@56 to main::@4 [phi:main::@56->main::@4]
    // [21] phi main::y1#2 = main::y1#1 [phi:main::@56->main::@4#0] -- register_copy 
    jmp __b4
    // main::@3
  __b3:
    // plot(x, border_top, 1)
    // [169] plot::x#2 = main::x1#2 -- vbuxx=vbuz1 
    ldx.z x1
    // [170] call plot
    // [225] phi from main::@3 to plot [phi:main::@3->plot]
    // [225] phi plot::c#10 = 1 [phi:main::@3->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [225] phi plot::y#10 = main::border_top [phi:main::@3->plot#1] -- vbuz1=vbuc1 
    lda #border_top
    sta.z plot.y
    // [225] phi plot::x#7 = plot::x#2 [phi:main::@3->plot#2] -- register_copy 
    jsr plot
    // main::@54
    // plot(x, border_bottom, 1)
    // [171] plot::x#3 = main::x1#2 -- vbuxx=vbuz1 
    ldx.z x1
    // [172] call plot
    // [225] phi from main::@54 to plot [phi:main::@54->plot]
    // [225] phi plot::c#10 = 1 [phi:main::@54->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [225] phi plot::y#10 = main::border_bottom [phi:main::@54->plot#1] -- vbuz1=vbuc1 
    lda #border_bottom
    sta.z plot.y
    // [225] phi plot::x#7 = plot::x#3 [phi:main::@54->plot#2] -- register_copy 
    jsr plot
    // main::@55
    // for (char x = border_left; x <= border_right; x++)
    // [173] main::x1#1 = ++ main::x1#2 -- vbuz1=_inc_vbuz1 
    inc.z x1
    // [19] phi from main::@55 to main::@2 [phi:main::@55->main::@2]
    // [19] phi main::x1#2 = main::x1#1 [phi:main::@55->main::@2#0] -- register_copy 
    jmp __b2
  .segment Data
    s: .text "GAME OVER !!!"
    .byte 0
    s1: .text "SEE YOU NEXT TIME !!!"
    .byte 0
}
.segment Code
  // cputln
// Print a newline
cputln: {
    // conio_line_text +=  CONIO_WIDTH
    // [174] conio_line_text = conio_line_text + $50 -- pbuz1=pbuz1_plus_vbuc1 
    lda #$50
    clc
    adc.z conio_line_text
    sta.z conio_line_text
    bcc !+
    inc.z conio_line_text+1
  !:
    // conio_cursor_x = 0
    // [175] conio_cursor_x = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y++;
    // [176] conio_cursor_y = ++ conio_cursor_y -- vbuz1=_inc_vbuz1 
    inc.z conio_cursor_y
    // cscroll()
    // [177] call cscroll
    jsr cscroll
    // cputln::@return
    // }
    // [178] return 
    rts
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = 6
    // [180] phi from clrscr to clrscr::@1 [phi:clrscr->clrscr::@1]
    // [180] phi clrscr::line_text#5 = DEFAULT_SCREEN [phi:clrscr->clrscr::@1#0] -- pbuz1=pbuc1 
    lda #<DEFAULT_SCREEN
    sta.z line_text
    lda #>DEFAULT_SCREEN
    sta.z line_text+1
    // [180] phi clrscr::l#2 = 0 [phi:clrscr->clrscr::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // clrscr::@1
  __b1:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [181] if(clrscr::l#2<$19) goto clrscr::@3 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$19
    bcc __b2
    // clrscr::@2
    // conio_cursor_x = 0
    // [182] conio_cursor_x = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y = 0
    // [183] conio_cursor_y = 0 -- vbuz1=vbuc1 
    sta.z conio_cursor_y
    // conio_line_text = CONIO_SCREEN_TEXT
    // [184] conio_line_text = DEFAULT_SCREEN -- pbuz1=pbuc1 
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    // clrscr::@return
    // }
    // [185] return 
    rts
    // [186] phi from clrscr::@1 to clrscr::@3 [phi:clrscr::@1->clrscr::@3]
  __b2:
    // [186] phi clrscr::c#2 = 0 [phi:clrscr::@1->clrscr::@3#0] -- vbuyy=vbuc1 
    ldy #0
    // clrscr::@3
  __b3:
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [187] if(clrscr::c#2<$50) goto clrscr::@4 -- vbuyy_lt_vbuc1_then_la1 
    cpy #$50
    bcc __b4
    // clrscr::@5
    // line_text += CONIO_WIDTH
    // [188] clrscr::line_text#1 = clrscr::line_text#5 + $50 -- pbuz1=pbuz1_plus_vbuc1 
    lda #$50
    clc
    adc.z line_text
    sta.z line_text
    bcc !+
    inc.z line_text+1
  !:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [189] clrscr::l#1 = ++ clrscr::l#2 -- vbuxx=_inc_vbuxx 
    inx
    // [180] phi from clrscr::@5 to clrscr::@1 [phi:clrscr::@5->clrscr::@1]
    // [180] phi clrscr::line_text#5 = clrscr::line_text#1 [phi:clrscr::@5->clrscr::@1#0] -- register_copy 
    // [180] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@5->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@4
  __b4:
    // line_text[c] = ' '
    // [190] clrscr::line_text#5[clrscr::c#2] = ' 'pm -- pbuz1_derefidx_vbuyy=vbuc1 
    lda #' '
    sta (line_text),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [191] clrscr::c#1 = ++ clrscr::c#2 -- vbuyy=_inc_vbuyy 
    iny
    // [186] phi from clrscr::@4 to clrscr::@3 [phi:clrscr::@4->clrscr::@3]
    // [186] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@4->clrscr::@3#0] -- register_copy 
    jmp __b3
}
  // getch
// Get a charakter from the keyboard and return it.
getch: {
    // cbm_k_getin()
    // [193] call cbm_k_getin
    jsr cbm_k_getin
    // [194] cbm_k_getin::return#0 = cbm_k_getin::return#2
    // getch::@1
    // [195] getch::return#0 = cbm_k_getin::return#0
    // getch::@return
    // }
    // [196] return 
    rts
}
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(__register(A) char x, char y)
gotoxy: {
    .const line_offset = ($e<<2)+$e<<4
    // gotoxy::@1
    // if(x>=CONIO_WIDTH)
    // [198] if(gotoxy::x#4<$50) goto gotoxy::@3 -- vbuaa_lt_vbuc1_then_la1 
    cmp #$50
    bcc __b2
    // [200] phi from gotoxy::@1 to gotoxy::@2 [phi:gotoxy::@1->gotoxy::@2]
    // [200] phi gotoxy::x#5 = 0 [phi:gotoxy::@1->gotoxy::@2#0] -- vbuaa=vbuc1 
    lda #0
    // [199] phi from gotoxy::@1 to gotoxy::@3 [phi:gotoxy::@1->gotoxy::@3]
    // gotoxy::@3
    // [200] phi from gotoxy::@3 to gotoxy::@2 [phi:gotoxy::@3->gotoxy::@2]
    // [200] phi gotoxy::x#5 = gotoxy::x#4 [phi:gotoxy::@3->gotoxy::@2#0] -- register_copy 
    // gotoxy::@2
  __b2:
    // conio_cursor_x = x
    // [201] conio_cursor_x = gotoxy::x#5 -- vbuz1=vbuaa 
    sta.z conio_cursor_x
    // conio_cursor_y = y
    // [202] conio_cursor_y = $e -- vbuz1=vbuc1 
    lda #$e
    sta.z conio_cursor_y
    // conio_line_text = CONIO_SCREEN_TEXT + line_offset
    // [203] conio_line_text = DEFAULT_SCREEN+gotoxy::line_offset#0 -- pbuz1=pbuc1 
    lda #<DEFAULT_SCREEN+line_offset
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN+line_offset
    sta.z conio_line_text+1
    // gotoxy::@return
    // }
    // [204] return 
    rts
}
  // printf_str
/// Print a NUL-terminated string
// void printf_str(void (*putc)(char), __zp(6) const char *s)
printf_str: {
    .label s = 6
    // [206] phi from printf_str printf_str::@2 to printf_str::@1 [phi:printf_str/printf_str::@2->printf_str::@1]
    // [206] phi printf_str::s#3 = printf_str::s#4 [phi:printf_str/printf_str::@2->printf_str::@1#0] -- register_copy 
    // printf_str::@1
  __b1:
    // while(c=*s++)
    // [207] printf_str::c#1 = *printf_str::s#3 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (s),y
    // [208] printf_str::s#0 = ++ printf_str::s#3 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [209] if(0!=printf_str::c#1) goto printf_str::@2 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b2
    // printf_str::@return
    // }
    // [210] return 
    rts
    // printf_str::@2
  __b2:
    // putc(c)
    // [211] stackpush(char) = printf_str::c#1 -- _stackpushbyte_=vbuaa 
    pha
    // [212] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    jmp __b1
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
// void wall(__zp($13) char x, __zp($12) char y, char size, __zp($14) char c)
wall: {
    .label i = $b
    .label x = $13
    .label y = $12
    .label c = $14
    // [215] phi from wall to wall::@1 [phi:wall->wall::@1]
    // [215] phi wall::i#2 = 0 [phi:wall->wall::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // wall::@1
  __b1:
    // for (char i = 0; i < size; i++)
    // [216] if(wall::i#2<main::wall_size) goto wall::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z i
    cmp #main.wall_size
    bcc __b2
    // wall::@return
    // }
    // [217] return 
    rts
    // wall::@2
  __b2:
    // plot(x, y + i, c)
    // [218] plot::y#1 = wall::y#4 + wall::i#2 -- vbuz1=vbuz2_plus_vbuz3 
    lda.z y
    clc
    adc.z i
    sta.z plot.y
    // [219] plot::x#1 = wall::x#4 -- vbuxx=vbuz1 
    ldx.z x
    // [220] plot::c#0 = wall::c#4 -- vbuz1=vbuz2 
    lda.z c
    sta.z plot.c
    // [221] call plot
    // [225] phi from wall::@2 to plot [phi:wall::@2->plot]
    // [225] phi plot::c#10 = plot::c#0 [phi:wall::@2->plot#0] -- register_copy 
    // [225] phi plot::y#10 = plot::y#1 [phi:wall::@2->plot#1] -- register_copy 
    // [225] phi plot::x#7 = plot::x#1 [phi:wall::@2->plot#2] -- register_copy 
    jsr plot
    // wall::@3
    // for (char i = 0; i < size; i++)
    // [222] wall::i#1 = ++ wall::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [215] phi from wall::@3 to wall::@1 [phi:wall::@3->wall::@1]
    // [215] phi wall::i#2 = wall::i#1 [phi:wall::@3->wall::@1#0] -- register_copy 
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
    // [223] *sound_off::sound_addr = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta sound_addr
    // sound_off::@return
    // }
    // [224] return 
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
// void plot(__register(X) char x, __zp(8) char y, __zp($c) char c)
plot: {
    .label __6 = 4
    .label __16 = 4
    .label i = 4
    .label bm = $a
    .label bx = 9
    .label y = 8
    .label c = $c
    .label __19 = 2
    .label __20 = 4
    .label __21 = 6
    .label __22 = 4
    // if (x > 159)
    // [226] if(plot::x#7<$9f+1) goto plot::@8 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$9f+1
    bcc __b1
    // [228] phi from plot to plot::@1 [phi:plot->plot::@1]
    // [228] phi plot::x#10 = $9f [phi:plot->plot::@1#0] -- vbuxx=vbuc1 
    ldx #$9f
    // [227] phi from plot to plot::@8 [phi:plot->plot::@8]
    // plot::@8
    // [228] phi from plot::@8 to plot::@1 [phi:plot::@8->plot::@1]
    // [228] phi plot::x#10 = plot::x#7 [phi:plot::@8->plot::@1#0] -- register_copy 
    // plot::@1
  __b1:
    // if (y > 49)
    // [229] if(plot::y#10<$31+1) goto plot::@9 -- vbuz1_lt_vbuc1_then_la1 
    lda.z y
    cmp #$31+1
    bcc __b2
    // [231] phi from plot::@1 to plot::@2 [phi:plot::@1->plot::@2]
    // [231] phi plot::y#8 = $31 [phi:plot::@1->plot::@2#0] -- vbuz1=vbuc1 
    lda #$31
    sta.z y
    // [230] phi from plot::@1 to plot::@9 [phi:plot::@1->plot::@9]
    // plot::@9
    // [231] phi from plot::@9 to plot::@2 [phi:plot::@9->plot::@2]
    // [231] phi plot::y#8 = plot::y#10 [phi:plot::@9->plot::@2#0] -- register_copy 
    // plot::@2
  __b2:
    // char ix = x >> 1
    // [232] plot::ix#0 = plot::x#10 >> 1 -- vbuyy=vbuxx_ror_1 
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
    // [233] plot::iy#0 = plot::y#8 >> 1 -- vbuaa=vbuz1_ror_1 
    // We "shiften" de x waarde met 1 stapje naar rechts (dit is binair gelijk aan delen door 2)!
    lda.z y
    lsr
    // (unsigned int)iy * 80
    // [234] plot::$16 = (unsigned int)plot::iy#0 -- vwuz1=_word_vbuaa 
    sta.z __16
    lda #0
    sta.z __16+1
    // [235] plot::$21 = plot::$16 << 2 -- vwuz1=vwuz2_rol_2 
    lda.z __16
    asl
    sta.z __21
    lda.z __16+1
    rol
    sta.z __21+1
    asl.z __21
    rol.z __21+1
    // [236] plot::$22 = plot::$21 + plot::$16 -- vwuz1=vwuz2_plus_vwuz1 
    clc
    lda.z __22
    adc.z __21
    sta.z __22
    lda.z __22+1
    adc.z __21+1
    sta.z __22+1
    // [237] plot::$6 = plot::$22 << 4 -- vwuz1=vwuz1_rol_4 
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    // unsigned int i = (unsigned int)iy * 80 + ix
    // [238] plot::i#0 = plot::$6 + plot::ix#0 -- vwuz1=vwuz1_plus_vbuyy 
    // We berekenen de index in de lijst van de bitmap die moet "geupdate" worden.
    tya
    clc
    adc.z i
    sta.z i
    bcc !+
    inc.z i+1
  !:
    // char bm = bitmap[i]
    // [239] plot::$19 = bitmap + plot::i#0 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z i
    clc
    adc #<bitmap
    sta.z __19
    lda.z i+1
    adc #>bitmap
    sta.z __19+1
    // [240] plot::bm#0 = *plot::$19 -- vbuz1=_deref_pbuz2 
    // We lezen de 8-bit waarde van de bitmap en houden het bij in een tijdelijke bm (=bitmap) variabele.
    ldy #0
    lda (__19),y
    sta.z bm
    // char bx = (x % 2)
    // [241] plot::bx#0 = plot::x#10 & 2-1 -- vbuz1=vbuxx_band_vbuc1 
    // De % operator neemt de "modulus" van de x en y waarde en stockeren dit in de bx en by variablen.
    // Dus als x = 159 en dan modulus 2, dan zal het resultaat 1 zijn! Bij x = 140 modulus 2, is het resultaat 0!
    // Idem voor y!
    lda #2-1
    sax.z bx
    // y % 2
    // [242] plot::$9 = plot::y#8 & 2-1 -- vbuaa=vbuz1_band_vbuc1 
    and.z y
    // char by = (y % 2) * 2
    // [243] plot::by#0 = plot::$9 << 1 -- vbuaa=vbuaa_rol_1 
    // Let op! Deze sequentie zal de resulterende modulus waar eerst vermenigvuldigen met 2, want het *-tje zal een vermenigvuldiging toepassen!
    asl
    // by + bx
    // [244] plot::$11 = plot::by#0 + plot::bx#0 -- vbuaa=vbuaa_plus_vbuz1 
    clc
    adc.z bx
    // char sh = (by + bx) ^ 3
    // [245] plot::sh#0 = plot::$11 ^ 3 -- vbuaa=vbuaa_bxor_vbuc1 
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
    // [246] if(0==plot::sh#0) goto plot::@3 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b6
    // plot::@6
    // b = 1 << sh
    // [247] plot::b#1 = 1 << plot::sh#0 -- vbuxx=vbuc1_rol_vbuaa 
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
    // [248] phi from plot::@6 to plot::@3 [phi:plot::@6->plot::@3]
    // [248] phi plot::b#2 = plot::b#1 [phi:plot::@6->plot::@3#0] -- register_copy 
    jmp __b3
    // [248] phi from plot::@2 to plot::@3 [phi:plot::@2->plot::@3]
  __b6:
    // [248] phi plot::b#2 = 1 [phi:plot::@2->plot::@3#0] -- vbuxx=vbuc1 
    ldx #1
    // plot::@3
  __b3:
    // if (c)
    // [249] if(0!=plot::c#10) goto plot::@4 -- 0_neq_vbuz1_then_la1 
    // Als laatste bekijken we exact wat er moet gebeuren met de "kleur".
    // Onthou! Een 0 verwijdert een blokje en een 1 tekent een blokje.
    // if (c) zal bekijken of c niet nul is, of anders gezegt, een waarde bevat.
    // Indien c niet 0 is, dan zal er een OR operatie plaatvinden met b!
    // Indien c 0 is, dan zal er een AND operatie plaatvinden met de inverse van b!
    lda.z c
    bne __b4
    // plot::@7
    // ~b
    // [250] plot::$15 = ~ plot::b#2 -- vbuaa=_bnot_vbuxx 
    txa
    eor #$ff
    // bm &= ~b
    // [251] plot::bm#2 = plot::bm#0 & plot::$15 -- vbuxx=vbuz1_band_vbuaa 
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
    // [252] phi from plot::@4 plot::@7 to plot::@5 [phi:plot::@4/plot::@7->plot::@5]
    // [252] phi plot::bm#5 = plot::bm#1 [phi:plot::@4/plot::@7->plot::@5#0] -- register_copy 
    // plot::@5
  __b5:
    // bitmap[i] = bm
    // [253] plot::$20 = bitmap + plot::i#0 -- pbuz1=pbuc1_plus_vwuz1 
    lda.z __20
    clc
    adc #<bitmap
    sta.z __20
    lda.z __20+1
    adc #>bitmap
    sta.z __20+1
    // [254] *plot::$20 = plot::bm#5 -- _deref_pbuz1=vbuxx 
    // En als laatste wijzen we nu de bijgewerkte bitmap toe aan de vorige bitmap index positie!
    // In andere woorden, we overschrijven de vorige waarde met de nieuwe berekende waarde.
    txa
    ldy #0
    sta (__20),y
    // plot::@return
    // }
    // [255] return 
    rts
    // plot::@4
  __b4:
    // bm |= b
    // [256] plot::bm#1 = plot::bm#0 | plot::b#2 -- vbuxx=vbuz1_bor_vbuxx 
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
  // sound_on
/**
 * @brief Turn sound on
 * POKE 59467,16 (turn on port for sound output use 0 to turn it off*)
 * 
 */
sound_on: {
    .label sound_addr = $e84b
    // *sound_addr = 16
    // [257] *sound_on::sound_addr = $10 -- _deref_pbuc1=vbuc2 
    lda #$10
    sta sound_addr
    // sound_on::@return
    // }
    // [258] return 
    rts
}
  // sound_note
/**
 * @brief Geluidsfunctie voor the PET
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
// __register(A) char sound_note(__register(Y) char octave, __zp($12) char frequency, char duration)
sound_note: {
    .label octave_addr = $e84a
    .label frequency_addr = $e848
    .label return = $13
    .label frequency = $12
    // *octave_addr = octave
    // [260] *sound_note::octave_addr = sound_note::octave#8 -- _deref_pbuc1=vbuyy 
    sty octave_addr
    // *frequency_addr = frequency
    // [261] *sound_note::frequency_addr = sound_note::frequency#8 -- _deref_pbuc1=vbuz1 
    lda.z frequency
    sta frequency_addr
    // sound_note::@return
    // }
    // [262] return 
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
    // [264] phi from paint to paint::@1 [phi:paint->paint::@1]
    // [264] phi paint::x#2 = 0 [phi:paint->paint::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // paint::@1
  __b1:
    // for (char x = 0; x < 80; x++)
    // [265] if(paint::x#2<$50) goto paint::@2 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$50
    bcc __b2
    // paint::@return
    // }
    // [266] return 
    rts
    // paint::@2
  __b2:
    // *(screen + 80 * 0 + x) = block[bitmap[80 * 0 + x]]
    // [267] screen[paint::x#2] = block[bitmap[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap,x
    lda block,y
    sta screen,x
    // *(screen + 80 * 1 + x) = block[bitmap[80 * 1 + x]]
    // [268] (screen+$50*1)[paint::x#2] = block[(bitmap+$50*1)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*1,x
    lda block,y
    sta screen+$50*1,x
    // *(screen + 80 * 2 + x) = block[bitmap[80 * 2 + x]]
    // [269] (screen+$50*2)[paint::x#2] = block[(bitmap+$50*2)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*2,x
    lda block,y
    sta screen+$50*2,x
    // *(screen + 80 * 3 + x) = block[bitmap[80 * 3 + x]]
    // [270] (screen+$50*3)[paint::x#2] = block[(bitmap+$50*3)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*3,x
    lda block,y
    sta screen+$50*3,x
    // *(screen + 80 * 4 + x) = block[bitmap[80 * 4 + x]]
    // [271] (screen+(unsigned int)$50*4)[paint::x#2] = block[(bitmap+(unsigned int)$50*4)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*4,x
    lda block,y
    sta screen+$50*4,x
    // *(screen + 80 * 5 + x) = block[bitmap[80 * 5 + x]]
    // [272] (screen+(unsigned int)$50*5)[paint::x#2] = block[(bitmap+(unsigned int)$50*5)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*5,x
    lda block,y
    sta screen+$50*5,x
    // *(screen + 80 * 6 + x) = block[bitmap[80 * 6 + x]]
    // [273] (screen+(unsigned int)$50*6)[paint::x#2] = block[(bitmap+(unsigned int)$50*6)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*6,x
    lda block,y
    sta screen+$50*6,x
    // *(screen + 80 * 7 + x) = block[bitmap[80 * 7 + x]]
    // [274] (screen+(unsigned int)$50*7)[paint::x#2] = block[(bitmap+(unsigned int)$50*7)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*7,x
    lda block,y
    sta screen+$50*7,x
    // *(screen + 80 * 8 + x) = block[bitmap[80 * 8 + x]]
    // [275] (screen+(unsigned int)$50*8)[paint::x#2] = block[(bitmap+(unsigned int)$50*8)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*8,x
    lda block,y
    sta screen+$50*8,x
    // *(screen + 80 * 9 + x) = block[bitmap[80 * 9 + x]]
    // [276] (screen+(unsigned int)$50*9)[paint::x#2] = block[(bitmap+(unsigned int)$50*9)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*9,x
    lda block,y
    sta screen+$50*9,x
    // *(screen + 80 * 10 + x) = block[bitmap[80 * 10 + x]]
    // [277] (screen+(unsigned int)$50*$a)[paint::x#2] = block[(bitmap+(unsigned int)$50*$a)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$a,x
    lda block,y
    sta screen+$50*$a,x
    // *(screen + 80 * 11 + x) = block[bitmap[80 * 11 + x]]
    // [278] (screen+(unsigned int)$50*$b)[paint::x#2] = block[(bitmap+(unsigned int)$50*$b)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$b,x
    lda block,y
    sta screen+$50*$b,x
    // *(screen + 80 * 12 + x) = block[bitmap[80 * 12 + x]]
    // [279] (screen+(unsigned int)$50*$c)[paint::x#2] = block[(bitmap+(unsigned int)$50*$c)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$c,x
    lda block,y
    sta screen+$50*$c,x
    // *(screen + 80 * 13 + x) = block[bitmap[80 * 13 + x]]
    // [280] (screen+(unsigned int)$50*$d)[paint::x#2] = block[(bitmap+(unsigned int)$50*$d)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$d,x
    lda block,y
    sta screen+$50*$d,x
    // *(screen + 80 * 14 + x) = block[bitmap[80 * 14 + x]]
    // [281] (screen+(unsigned int)$50*$e)[paint::x#2] = block[(bitmap+(unsigned int)$50*$e)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$e,x
    lda block,y
    sta screen+$50*$e,x
    // *(screen + 80 * 15 + x) = block[bitmap[80 * 15 + x]]
    // [282] (screen+(unsigned int)$50*$f)[paint::x#2] = block[(bitmap+(unsigned int)$50*$f)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$f,x
    lda block,y
    sta screen+$50*$f,x
    // *(screen + 80 * 16 + x) = block[bitmap[80 * 16 + x]]
    // [283] (screen+(unsigned int)$50*$10)[paint::x#2] = block[(bitmap+(unsigned int)$50*$10)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$10,x
    lda block,y
    sta screen+$50*$10,x
    // *(screen + 80 * 17 + x) = block[bitmap[80 * 17 + x]]
    // [284] (screen+(unsigned int)$50*$11)[paint::x#2] = block[(bitmap+(unsigned int)$50*$11)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$11,x
    lda block,y
    sta screen+$50*$11,x
    // *(screen + 80 * 18 + x) = block[bitmap[80 * 18 + x]]
    // [285] (screen+(unsigned int)$50*$12)[paint::x#2] = block[(bitmap+(unsigned int)$50*$12)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$12,x
    lda block,y
    sta screen+$50*$12,x
    // *(screen + 80 * 19 + x) = block[bitmap[80 * 19 + x]]
    // [286] (screen+(unsigned int)$50*$13)[paint::x#2] = block[(bitmap+(unsigned int)$50*$13)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$13,x
    lda block,y
    sta screen+$50*$13,x
    // *(screen + 80 * 20 + x) = block[bitmap[80 * 20 + x]]
    // [287] (screen+(unsigned int)$50*$14)[paint::x#2] = block[(bitmap+(unsigned int)$50*$14)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$14,x
    lda block,y
    sta screen+$50*$14,x
    // *(screen + 80 * 21 + x) = block[bitmap[80 * 21 + x]]
    // [288] (screen+(unsigned int)$50*$15)[paint::x#2] = block[(bitmap+(unsigned int)$50*$15)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$15,x
    lda block,y
    sta screen+$50*$15,x
    // *(screen + 80 * 22 + x) = block[bitmap[80 * 22 + x]]
    // [289] (screen+(unsigned int)$50*$16)[paint::x#2] = block[(bitmap+(unsigned int)$50*$16)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$16,x
    lda block,y
    sta screen+$50*$16,x
    // *(screen + 80 * 23 + x) = block[bitmap[80 * 23 + x]]
    // [290] (screen+(unsigned int)$50*$17)[paint::x#2] = block[(bitmap+(unsigned int)$50*$17)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$17,x
    lda block,y
    sta screen+$50*$17,x
    // *(screen + 80 * 24 + x) = block[bitmap[80 * 24 + x]]
    // [291] (screen+(unsigned int)$50*$18)[paint::x#2] = block[(bitmap+(unsigned int)$50*$18)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$18,x
    lda block,y
    sta screen+$50*$18,x
    // for (char x = 0; x < 80; x++)
    // [292] paint::x#1 = ++ paint::x#2 -- vbuxx=_inc_vbuxx 
    inx
    // [264] phi from paint::@2 to paint::@1 [phi:paint::@2->paint::@1]
    // [264] phi paint::x#2 = paint::x#1 [phi:paint::@2->paint::@1#0] -- register_copy 
    jmp __b1
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y==CONIO_HEIGHT)
    // [293] if(conio_cursor_y!=$19) goto cscroll::@return -- vbuz1_neq_vbuc1_then_la1 
    lda #$19
    cmp.z conio_cursor_y
    bne __breturn
    // [294] phi from cscroll to cscroll::@1 [phi:cscroll->cscroll::@1]
    // cscroll::@1
    // memcpy(CONIO_SCREEN_TEXT, CONIO_SCREEN_TEXT+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH)
    // [295] call memcpy
    // [306] phi from cscroll::@1 to memcpy [phi:cscroll::@1->memcpy]
    jsr memcpy
    // [296] phi from cscroll::@1 to cscroll::@2 [phi:cscroll::@1->cscroll::@2]
    // cscroll::@2
    // memset(CONIO_SCREEN_TEXT+CONIO_BYTES-CONIO_WIDTH, ' ', CONIO_WIDTH)
    // [297] call memset
    // [313] phi from cscroll::@2 to memset [phi:cscroll::@2->memset]
    jsr memset
    // cscroll::@3
    // conio_line_text -= CONIO_WIDTH
    // [298] conio_line_text = conio_line_text - $50 -- pbuz1=pbuz1_minus_vbuc1 
    sec
    lda.z conio_line_text
    sbc #$50
    sta.z conio_line_text
    lda.z conio_line_text+1
    sbc #0
    sta.z conio_line_text+1
    // conio_cursor_y--;
    // [299] conio_cursor_y = -- conio_cursor_y -- vbuz1=_dec_vbuz1 
    dec.z conio_cursor_y
    // cscroll::@return
  __breturn:
    // }
    // [300] return 
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
    // [301] cbm_k_getin::ch = 0 -- vbum1=vbuc1 
    lda #0
    sta ch
    // asm
    // asm { jsrCBM_GETIN stach  }
    jsr CBM_GETIN
    sta ch
    // return ch;
    // [303] cbm_k_getin::return#1 = cbm_k_getin::ch -- vbuaa=vbum1 
    // cbm_k_getin::@return
    // }
    // [304] cbm_k_getin::return#2 = cbm_k_getin::return#1
    // [305] return 
    rts
  .segment Data
    ch: .byte 0
}
.segment Code
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
    // [307] phi from memcpy to memcpy::@1 [phi:memcpy->memcpy::@1]
    // [307] phi memcpy::dst#2 = (char *)memcpy::destination#0 [phi:memcpy->memcpy::@1#0] -- pbuz1=pbuc1 
    lda #<destination
    sta.z dst
    lda #>destination
    sta.z dst+1
    // [307] phi memcpy::src#2 = (char *)memcpy::source#0 [phi:memcpy->memcpy::@1#1] -- pbuz1=pbuc1 
    lda #<source
    sta.z src
    lda #>source
    sta.z src+1
    // memcpy::@1
  __b1:
    // while(src!=src_end)
    // [308] if(memcpy::src#2!=memcpy::src_end#0) goto memcpy::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z src+1
    cmp #>src_end
    bne __b2
    lda.z src
    cmp #<src_end
    bne __b2
    // memcpy::@return
    // }
    // [309] return 
    rts
    // memcpy::@2
  __b2:
    // *dst++ = *src++
    // [310] *memcpy::dst#2 = *memcpy::src#2 -- _deref_pbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    // [311] memcpy::dst#1 = ++ memcpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [312] memcpy::src#1 = ++ memcpy::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [307] phi from memcpy::@2 to memcpy::@1 [phi:memcpy::@2->memcpy::@1]
    // [307] phi memcpy::dst#2 = memcpy::dst#1 [phi:memcpy::@2->memcpy::@1#0] -- register_copy 
    // [307] phi memcpy::src#2 = memcpy::src#1 [phi:memcpy::@2->memcpy::@1#1] -- register_copy 
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
    // [314] phi from memset to memset::@1 [phi:memset->memset::@1]
    // [314] phi memset::dst#2 = (char *)memset::str#0 [phi:memset->memset::@1#0] -- pbuz1=pbuc1 
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
    // memset::@1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    // [315] if(memset::dst#2!=memset::end#0) goto memset::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // memset::@return
    // }
    // [316] return 
    rts
    // memset::@2
  __b2:
    // *dst = c
    // [317] *memset::dst#2 = memset::c#0 -- _deref_pbuz1=vbuc1 
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    // [318] memset::dst#1 = ++ memset::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [314] phi from memset::@2 to memset::@1 [phi:memset::@2->memset::@1]
    // [314] phi memset::dst#2 = memset::dst#1 [phi:memset::@2->memset::@1#0] -- register_copy 
    jmp __b1
}
  // File Data
.segment Data
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
