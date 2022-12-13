  // File Comments
/**
 * @file pong-1.c
 * @author your name (you@domain.com)
 * @brief Dit is je eerste C programma, dat werkt op de PET 8032!
 * Het resultaat zal een werkend pong spelletje zijn!
 *
 * # LES 2
 *
 * Probeer het programma te vervolledigen, zodat het vierkantje stuitert tussen de muren in een oneindige lus :-).
 * Kijk in het programma naar de lijnen met verduidelijkingen, want je kan er aanwijzingen in vinden!
 * Deze verduidelijkingen zitten in commentaarlijnen, een syntax, en beginnen op elke lijn met // of zitten tussen /* en * /.
 * De VSCODE editor geeft deze lijnen een specifieke kleur!
 *
 * # LES 3
 *
 * Nu kijken we naar het toetsenbord op de PET. Hoe kan het spel, nadat een toets is ingedrukt, deze uitlezen?
 * En hoe kunnen we dit voor 2 spelers tegelijk doen met verschillende toetsen?
 * We leren ook hoe we voor elke speler een vertikale bar maken en deze via het toetsenbord kunnen bedienen.
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
:BasicUpstart(main)
  // Global Constants & labels
  ///< Close all logical files.
  .const CBM_GETIN = $ffe4
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
  // De variable screen wordt gebruikt in de pain functie om de karaketers te tekenen op het scherm.
  .label screen = $8000
.segment Code
  // main
/**
 * @brief De main functie van pong. Dit programma geeft je
 *
 * @return int
 */
main: {
    .const wall_left = 1
    .const wall_right = $9e
    .const wall_top = 1
    .const wall_bottom = $30
    .const wall_max = wall_bottom-wall_size
    // We declareren de variabelen die de positie bijhouden van het muurtje (wall).
    // We kunnen dit muurtje omhoog en omlaag schuiven door met de pijl omhoog of omlaag te tikken.
    // Ons programma zal dan de waarden wall_x en wall_y verminderen of vermeerderen.
    // We houden ook een grootte bij in wall_size.
    .label wall_x = $9a
    .label wall_size = 6
    .label x1 = $17
    .label y1 = $18
    .label ch = $10
    .label wall_y = $16
    .label fp_x = $1b
    .label fp_y = $1d
    // Een aantal werk variabelen die de huidige x en y positie van het balletje bijhouden.
    // Noteer dat de x en y waarden hier int = integer waarden zijn, en dus 16-bits groot!
    // Dit is om je te leren dat in een programma variabelen verschillende data types kunnen hebben!
    .label x = $19
    .label y = $1a
    .label dy = $14
    // Deze werk variabelen houden de "deltas" bij van de richting van het balletje.
    // Deze zijn 8-bit variabelen, maar de zijn "signed". Dit wil zeggen,
    // dat de variabelen ook een negatieve waarde kunnen hebben!
    // Ik zal jullie in de klas uitleggen hoe dit kan!
    .label dx = $12
    // clrscr()
    // [1] call clrscr
    // [62] phi from main to clrscr [phi:main->clrscr]
    jsr clrscr
    // [2] phi from main to main::@1 [phi:main->main::@1]
    // [2] phi main::x1#2 = 0 [phi:main->main::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z x1
  // We tekenen eerst het scherm, de randen op de x-as!
    // main::@1
  __b1:
    // for(char x=0; x<159; x++)
    // [3] if(main::x1#2<$9f) goto main::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z x1
    cmp #$9f
    bcs !__b2+
    jmp __b2
  !__b2:
    // [4] phi from main::@1 to main::@3 [phi:main::@1->main::@3]
    // [4] phi main::y1#2 = 0 [phi:main::@1->main::@3#0] -- vbuz1=vbuc1 
    lda #0
    sta.z y1
  // We tekenen eerst het scherm, de randen op de y-as!
    // main::@3
  __b3:
    // for(char y=0; y<49; y++)
    // [5] if(main::y1#2<$31) goto main::@4 -- vbuz1_lt_vbuc1_then_la1 
    lda.z y1
    cmp #$31
    bcs !__b4+
    jmp __b4
  !__b4:
    // [6] phi from main::@3 to main::@5 [phi:main::@3->main::@5]
    // main::@5
    // char ch = getch()
    // [7] call getch
  // De while functie in C maakt een loop of een lus.
  // Dus de instructies binnen de { } worden uitgevoerd totdat de waarde binnen de ( ) waar is.
  // 1 is een positieve waarde, dus de while functie zal hier altijd en oneindig blijven herhalen!
    // [72] phi from main::@5 to getch [phi:main::@5->getch]
    jsr getch
    // char ch = getch()
    // [8] getch::return#2 = getch::return#0
    // main::@26
    // [9] main::ch#0 = getch::return#2
    // [10] phi from main::@26 to main::@6 [phi:main::@26->main::@6]
    // [10] phi main::dy#10 = $40 [phi:main::@26->main::@6#0] -- vwsz1=vwsc1 
    lda #<$40
    sta.z dy
    lda #>$40
    sta.z dy+1
    // [10] phi main::fp_y#10 = $18*$100 [phi:main::@26->main::@6#1] -- vwuz1=vwuc1 
    lda #<$18*$100
    sta.z fp_y
    lda #>$18*$100
    sta.z fp_y+1
    // [10] phi main::dx#10 = $80 [phi:main::@26->main::@6#2] -- vwsz1=vwsc1 
    lda #<$80
    sta.z dx
    lda #>$80
    sta.z dx+1
    // [10] phi main::fp_x#10 = 2*$100 [phi:main::@26->main::@6#3] -- vwuz1=vwuc1 
    lda #<2*$100
    sta.z fp_x
    lda #>2*$100
    sta.z fp_x+1
    // [10] phi main::y#13 = $18 [phi:main::@26->main::@6#4] -- vbuz1=vbuc1 
    lda #$18
    sta.z y
    // [10] phi main::x#10 = 2 [phi:main::@26->main::@6#5] -- vbuz1=vbuc1 
    lda #2
    sta.z x
    // [10] phi main::wall_y#10 = $16 [phi:main::@26->main::@6#6] -- vbuz1=vbuc1 
    lda #$16
    sta.z wall_y
    // [10] phi main::ch#2 = main::ch#0 [phi:main::@26->main::@6#7] -- register_copy 
    // main::@6
  __b6:
    // while (ch != 'x')
    // [11] if(main::ch#2!='x'pm) goto main::@7 -- vbuz1_neq_vbuc1_then_la1 
  .encoding "petscii_mixed"
    lda #'x'
    cmp.z ch
    bne __b7
    // main::@return
    // }
    // [12] return 
    rts
    // main::@7
  __b7:
    // wall(wall_x, wall_y, wall_size, 0)
    // [13] wall::y#0 = main::wall_y#10 -- vbuz1=vbuz2 
    lda.z wall_y
    sta.z wall.y
    // [14] call wall
  // We wissen het muurtje.
    // [77] phi from main::@7 to wall [phi:main::@7->wall]
    // [77] phi wall::c#4 = 0 [phi:main::@7->wall#0] -- vbuz1=vbuc1 
    lda #0
    sta.z wall.c
    // [77] phi wall::y#4 = wall::y#0 [phi:main::@7->wall#1] -- register_copy 
    jsr wall
    // main::@27
    // case 0x91:
    //             if (wall_y > wall_min)
    //             {
    //                 wall_y--;
    //             }
    //             break;
    // [15] if(main::ch#2==$91) goto main::@8 -- vbuz1_eq_vbuc1_then_la1 
    lda #$91
    cmp.z ch
    bne !__b8+
    jmp __b8
  !__b8:
    // main::@18
    // case 0x11:
    //             if (wall_y < wall_max)
    //             {
    //                 wall_y++;
    //             }
    //             break;
    // [16] if(main::ch#2==$11) goto main::@9 -- vbuz1_eq_vbuc1_then_la1 
    lda #$11
    cmp.z ch
    bne !__b9+
    jmp __b9
  !__b9:
    // [17] phi from main::@11 main::@12 main::@18 main::@8 main::@9 to main::@10 [phi:main::@11/main::@12/main::@18/main::@8/main::@9->main::@10]
    // [17] phi main::wall_y#12 = main::wall_y#1 [phi:main::@11/main::@12/main::@18/main::@8/main::@9->main::@10#0] -- register_copy 
    // main::@10
  __b10:
    // plot(x, y, 0)
    // [18] plot::x#5 = main::x#10 -- vbuz1=vbuz2 
    lda.z x
    sta.z plot.x
    // [19] plot::y#5 = main::y#13 -- vbuz1=vbuz2 
    lda.z y
    sta.z plot.y
    // [20] call plot
    // [85] phi from main::@10 to plot [phi:main::@10->plot]
    // [85] phi plot::c#7 = 0 [phi:main::@10->plot#0] -- vbuz1=vbuc1 
    lda #0
    sta.z plot.c
    // [85] phi plot::y#7 = plot::y#5 [phi:main::@10->plot#1] -- register_copy 
    // [85] phi plot::x#7 = plot::x#5 [phi:main::@10->plot#2] -- register_copy 
    jsr plot
    // main::@28
    // fp_x += dx
    // [21] main::fp_x#1 = main::fp_x#10 + main::dx#10 -- vwuz1=vwuz1_plus_vwsz2 
    // Nu werken we de x en y positie bij, we tellen de deltas op bij de x en y waarden.
    clc
    lda.z fp_x
    adc.z dx
    sta.z fp_x
    lda.z fp_x+1
    adc.z dx+1
    sta.z fp_x+1
    // fp_y += dy
    // [22] main::fp_y#1 = main::fp_y#10 + main::dy#10 -- vwuz1=vwuz1_plus_vwsz2 
    clc
    lda.z fp_y
    adc.z dy
    sta.z fp_y
    lda.z fp_y+1
    adc.z dy+1
    sta.z fp_y+1
    // x = BYTE1(fp_x)
    // [23] main::x#1 = byte1  main::fp_x#1 -- vbuz1=_byte1_vwuz2 
    lda.z fp_x+1
    sta.z x
    // y = BYTE1(fp_y)
    // [24] main::y#1 = byte1  main::fp_y#1 -- vbuz1=_byte1_vwuz2 
    lda.z fp_y+1
    sta.z y
    // if (y == wall_top)
    // [25] if(main::y#1!=main::wall_top) goto main::@14 -- vbuz1_neq_vbuc1_then_la1 
    lda #wall_top
    cmp.z y
    bne __b14
    // main::@13
    // dy = -dy
    // [26] main::dy#1 = - main::dy#10 -- vwsz1=_neg_vwsz1 
    lda #0
    sec
    sbc.z dy
    sta.z dy
    lda #0
    sbc.z dy+1
    sta.z dy+1
    // [27] phi from main::@13 main::@28 to main::@14 [phi:main::@13/main::@28->main::@14]
    // [27] phi main::dy#5 = main::dy#1 [phi:main::@13/main::@28->main::@14#0] -- register_copy 
    // main::@14
  __b14:
    // if (y == wall_bottom)
    // [28] if(main::y#1!=main::wall_bottom) goto main::@15 -- vbuz1_neq_vbuc1_then_la1 
    lda #wall_bottom
    cmp.z y
    bne __b15
    // main::@19
    // dy = -dy
    // [29] main::dy#2 = - main::dy#5 -- vwsz1=_neg_vwsz1 
    lda #0
    sec
    sbc.z dy
    sta.z dy
    lda #0
    sbc.z dy+1
    sta.z dy+1
    // [30] phi from main::@14 main::@19 to main::@15 [phi:main::@14/main::@19->main::@15]
    // [30] phi main::dy#17 = main::dy#5 [phi:main::@14/main::@19->main::@15#0] -- register_copy 
    // main::@15
  __b15:
    // if (x == wall_left)
    // [31] if(main::x#1!=main::wall_left) goto main::@16 -- vbuz1_neq_vbuc1_then_la1 
    lda #wall_left
    cmp.z x
    bne __b16
    // main::@20
    // dx = -dx
    // [32] main::dx#1 = - main::dx#10 -- vwsz1=_neg_vwsz1 
    lda #0
    sec
    sbc.z dx
    sta.z dx
    lda #0
    sbc.z dx+1
    sta.z dx+1
    // [33] phi from main::@15 main::@20 to main::@16 [phi:main::@15/main::@20->main::@16]
    // [33] phi main::dx#5 = main::dx#10 [phi:main::@15/main::@20->main::@16#0] -- register_copy 
    // main::@16
  __b16:
    // if (x == wall_right)
    // [34] if(main::x#1!=main::wall_right) goto main::@17 -- vbuz1_neq_vbuc1_then_la1 
    lda #wall_right
    cmp.z x
    bne __b17
    // main::@21
    // dx = -dx
    // [35] main::dx#2 = - main::dx#5 -- vwsz1=_neg_vwsz1 
    lda #0
    sec
    sbc.z dx
    sta.z dx
    lda #0
    sbc.z dx+1
    sta.z dx+1
    // [36] phi from main::@16 main::@21 to main::@17 [phi:main::@16/main::@21->main::@17]
    // [36] phi main::dx#21 = main::dx#5 [phi:main::@16/main::@21->main::@17#0] -- register_copy 
    // main::@17
  __b17:
    // plot(x, y, 1)
    // [37] plot::x#6 = main::x#1 -- vbuz1=vbuz2 
    lda.z x
    sta.z plot.x
    // [38] plot::y#6 = main::y#1 -- vbuz1=vbuz2 
    lda.z y
    sta.z plot.y
    // [39] call plot
    // [85] phi from main::@17 to plot [phi:main::@17->plot]
    // [85] phi plot::c#7 = 1 [phi:main::@17->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [85] phi plot::y#7 = plot::y#6 [phi:main::@17->plot#1] -- register_copy 
    // [85] phi plot::x#7 = plot::x#6 [phi:main::@17->plot#2] -- register_copy 
    jsr plot
    // main::@29
    // wall(wall_x, wall_y, wall_size, 1)
    // [40] wall::y#1 = main::wall_y#12 -- vbuz1=vbuz2 
    lda.z wall_y
    sta.z wall.y
    // [41] call wall
  // We hertekenen het muurtje.
    // [77] phi from main::@29 to wall [phi:main::@29->wall]
    // [77] phi wall::c#4 = 1 [phi:main::@29->wall#0] -- vbuz1=vbuc1 
    lda #1
    sta.z wall.c
    // [77] phi wall::y#4 = wall::y#1 [phi:main::@29->wall#1] -- register_copy 
    jsr wall
    // [42] phi from main::@29 to main::@30 [phi:main::@29->main::@30]
    // main::@30
    // paint()
    // [43] call paint
  // En deze draw functie tekent het volledige scherm door de bitmap te tekenen op alle karaketers om het scherm!
    // [111] phi from main::@30 to paint [phi:main::@30->paint]
    jsr paint
    // [44] phi from main::@30 to main::@31 [phi:main::@30->main::@31]
    // main::@31
    // getch()
    // [45] call getch
    // [72] phi from main::@31 to getch [phi:main::@31->getch]
    jsr getch
    // getch()
    // [46] getch::return#3 = getch::return#0
    // main::@32
    // ch = getch()
    // [47] main::ch#1 = getch::return#3
    // [10] phi from main::@32 to main::@6 [phi:main::@32->main::@6]
    // [10] phi main::dy#10 = main::dy#17 [phi:main::@32->main::@6#0] -- register_copy 
    // [10] phi main::fp_y#10 = main::fp_y#1 [phi:main::@32->main::@6#1] -- register_copy 
    // [10] phi main::dx#10 = main::dx#21 [phi:main::@32->main::@6#2] -- register_copy 
    // [10] phi main::fp_x#10 = main::fp_x#1 [phi:main::@32->main::@6#3] -- register_copy 
    // [10] phi main::y#13 = main::y#1 [phi:main::@32->main::@6#4] -- register_copy 
    // [10] phi main::x#10 = main::x#1 [phi:main::@32->main::@6#5] -- register_copy 
    // [10] phi main::wall_y#10 = main::wall_y#12 [phi:main::@32->main::@6#6] -- register_copy 
    // [10] phi main::ch#2 = main::ch#1 [phi:main::@32->main::@6#7] -- register_copy 
    jmp __b6
    // main::@9
  __b9:
    // if (wall_y < wall_max)
    // [48] if(main::wall_y#10>=main::wall_max#0) goto main::@10 -- vbuz1_ge_vbuc1_then_la1 
    lda.z wall_y
    cmp #wall_max
    bcc !__b10+
    jmp __b10
  !__b10:
    // main::@12
    // wall_y++;
    // [49] main::wall_y#2 = ++ main::wall_y#10 -- vbuz1=_inc_vbuz1 
    inc.z wall_y
    jmp __b10
    // main::@8
  __b8:
    // if (wall_y > wall_min)
    // [50] if(main::wall_y#10<main::wall_top+1) goto main::@10 -- vbuz1_lt_vbuc1_then_la1 
    lda.z wall_y
    cmp #wall_top+1
    bcs !__b10+
    jmp __b10
  !__b10:
    // main::@11
    // wall_y--;
    // [51] main::wall_y#1 = -- main::wall_y#10 -- vbuz1=_dec_vbuz1 
    dec.z wall_y
    jmp __b10
    // main::@4
  __b4:
    // plot(0, y, 1)
    // [52] plot::y#3 = main::y1#2 -- vbuz1=vbuz2 
    lda.z y1
    sta.z plot.y
    // [53] call plot
    // [85] phi from main::@4 to plot [phi:main::@4->plot]
    // [85] phi plot::c#7 = 1 [phi:main::@4->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [85] phi plot::y#7 = plot::y#3 [phi:main::@4->plot#1] -- register_copy 
    // [85] phi plot::x#7 = 0 [phi:main::@4->plot#2] -- vbuz1=vbuc1 
    lda #0
    sta.z plot.x
    jsr plot
    // main::@24
    // plot(159, y, 1)
    // [54] plot::y#4 = main::y1#2 -- vbuz1=vbuz2 
    lda.z y1
    sta.z plot.y
    // [55] call plot
    // [85] phi from main::@24 to plot [phi:main::@24->plot]
    // [85] phi plot::c#7 = 1 [phi:main::@24->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [85] phi plot::y#7 = plot::y#4 [phi:main::@24->plot#1] -- register_copy 
    // [85] phi plot::x#7 = $9f [phi:main::@24->plot#2] -- vbuz1=vbuc1 
    lda #$9f
    sta.z plot.x
    jsr plot
    // main::@25
    // for(char y=0; y<49; y++)
    // [56] main::y1#1 = ++ main::y1#2 -- vbuz1=_inc_vbuz1 
    inc.z y1
    // [4] phi from main::@25 to main::@3 [phi:main::@25->main::@3]
    // [4] phi main::y1#2 = main::y1#1 [phi:main::@25->main::@3#0] -- register_copy 
    jmp __b3
    // main::@2
  __b2:
    // plot(x, 0, 1)
    // [57] plot::x#1 = main::x1#2 -- vbuz1=vbuz2 
    lda.z x1
    sta.z plot.x
    // [58] call plot
    // [85] phi from main::@2 to plot [phi:main::@2->plot]
    // [85] phi plot::c#7 = 1 [phi:main::@2->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [85] phi plot::y#7 = 0 [phi:main::@2->plot#1] -- vbuz1=vbuc1 
    lda #0
    sta.z plot.y
    // [85] phi plot::x#7 = plot::x#1 [phi:main::@2->plot#2] -- register_copy 
    jsr plot
    // main::@22
    // plot(x, 49, 1)
    // [59] plot::x#2 = main::x1#2 -- vbuz1=vbuz2 
    lda.z x1
    sta.z plot.x
    // [60] call plot
    // [85] phi from main::@22 to plot [phi:main::@22->plot]
    // [85] phi plot::c#7 = 1 [phi:main::@22->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [85] phi plot::y#7 = $31 [phi:main::@22->plot#1] -- vbuz1=vbuc1 
    lda #$31
    sta.z plot.y
    // [85] phi plot::x#7 = plot::x#2 [phi:main::@22->plot#2] -- register_copy 
    jsr plot
    // main::@23
    // for(char x=0; x<159; x++)
    // [61] main::x1#1 = ++ main::x1#2 -- vbuz1=_inc_vbuz1 
    inc.z x1
    // [2] phi from main::@23 to main::@1 [phi:main::@23->main::@1]
    // [2] phi main::x1#2 = main::x1#1 [phi:main::@23->main::@1#0] -- register_copy 
    jmp __b1
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label c = $f
    .label line_text = 3
    .label l = $11
    // [63] phi from clrscr to clrscr::@1 [phi:clrscr->clrscr::@1]
    // [63] phi clrscr::line_text#5 = DEFAULT_SCREEN [phi:clrscr->clrscr::@1#0] -- pbuz1=pbuc1 
    lda #<DEFAULT_SCREEN
    sta.z line_text
    lda #>DEFAULT_SCREEN
    sta.z line_text+1
    // [63] phi clrscr::l#2 = 0 [phi:clrscr->clrscr::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z l
    // clrscr::@1
  __b1:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [64] if(clrscr::l#2<$19) goto clrscr::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z l
    cmp #$19
    bcc __b4
    // clrscr::@return
    // }
    // [65] return 
    rts
    // [66] phi from clrscr::@1 to clrscr::@2 [phi:clrscr::@1->clrscr::@2]
  __b4:
    // [66] phi clrscr::c#2 = 0 [phi:clrscr::@1->clrscr::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // clrscr::@2
  __b2:
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [67] if(clrscr::c#2<$50) goto clrscr::@3 -- vbuz1_lt_vbuc1_then_la1 
    lda.z c
    cmp #$50
    bcc __b3
    // clrscr::@4
    // line_text += CONIO_WIDTH
    // [68] clrscr::line_text#1 = clrscr::line_text#5 + $50 -- pbuz1=pbuz1_plus_vbuc1 
    lda #$50
    clc
    adc.z line_text
    sta.z line_text
    bcc !+
    inc.z line_text+1
  !:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [69] clrscr::l#1 = ++ clrscr::l#2 -- vbuz1=_inc_vbuz1 
    inc.z l
    // [63] phi from clrscr::@4 to clrscr::@1 [phi:clrscr::@4->clrscr::@1]
    // [63] phi clrscr::line_text#5 = clrscr::line_text#1 [phi:clrscr::@4->clrscr::@1#0] -- register_copy 
    // [63] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@4->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@3
  __b3:
    // line_text[c] = ' '
    // [70] clrscr::line_text#5[clrscr::c#2] = ' 'pm -- pbuz1_derefidx_vbuz2=vbuc1 
    lda #' '
    ldy.z c
    sta (line_text),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [71] clrscr::c#1 = ++ clrscr::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [66] phi from clrscr::@3 to clrscr::@2 [phi:clrscr::@3->clrscr::@2]
    // [66] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@3->clrscr::@2#0] -- register_copy 
    jmp __b2
}
  // getch
// Get a charakter from the keyboard and return it.
getch: {
    .label return = $10
    // cbm_k_getin()
    // [73] call cbm_k_getin
    jsr cbm_k_getin
    // [74] cbm_k_getin::return#2 = cbm_k_getin::return#1
    // getch::@1
    // [75] getch::return#0 = cbm_k_getin::return#2
    // getch::@return
    // }
    // [76] return 
    rts
}
  // wall
// void wall(char x, __zp($11) char y, char size, __zp($f) char c)
wall: {
    .label i = $c
    .label y = $11
    .label c = $f
    // [78] phi from wall to wall::@1 [phi:wall->wall::@1]
    // [78] phi wall::i#2 = 0 [phi:wall->wall::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // wall::@1
  __b1:
    // for(char i=0; i<size; i++)
    // [79] if(wall::i#2<main::wall_size) goto wall::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z i
    cmp #main.wall_size
    bcc __b2
    // wall::@return
    // }
    // [80] return 
    rts
    // wall::@2
  __b2:
    // plot(x, y+i, c)
    // [81] plot::y#0 = wall::y#4 + wall::i#2 -- vbuz1=vbuz2_plus_vbuz3 
    lda.z y
    clc
    adc.z i
    sta.z plot.y
    // [82] plot::c#0 = wall::c#4 -- vbuz1=vbuz2 
    lda.z c
    sta.z plot.c
    // [83] call plot
    // [85] phi from wall::@2 to plot [phi:wall::@2->plot]
    // [85] phi plot::c#7 = plot::c#0 [phi:wall::@2->plot#0] -- register_copy 
    // [85] phi plot::y#7 = plot::y#0 [phi:wall::@2->plot#1] -- register_copy 
    // [85] phi plot::x#7 = main::wall_x [phi:wall::@2->plot#2] -- vbuz1=vbuc1 
    lda #main.wall_x
    sta.z plot.x
    jsr plot
    // wall::@3
    // for(char i=0; i<size; i++)
    // [84] wall::i#1 = ++ wall::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [78] phi from wall::@3 to wall::@1 [phi:wall::@3->wall::@1]
    // [78] phi wall::i#2 = wall::i#1 [phi:wall::@3->wall::@1#0] -- register_copy 
    jmp __b1
}
  // plot
/**
 * @brief De plot functie kan gebruikt worden om een blokje te tekenen op het scherm.
 * Echter, de plot functie tekent niet direct op het scherm, maar het tekent op een "bitmap" in het interne geheugen,
 * dat gebruikt wordt door de functie paint, dat deze bitmap op het scherm zal schilderen in de vorm van
 * Commodore [PETSCII](https://www.pagetable.com/c64ref/charset) karaketers!
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
// void plot(__zp($b) char x, __zp(2) char y, __zp($e) char c)
plot: {
    .label __2 = 3
    .label __5 = 2
    .label __7 = 2
    .label __11 = 2
    .label __12 = 3
    .label ix = $d
    .label iy = $a
    .label i = 3
    .label bm = 5
    .label bx = $b
    .label by = 2
    .label sh = 2
    // En nu komt de magic!
    // nu sh de positie van de bit bevat dat moet worden bijgewerkt, hebben we nog niet de exact bitwaarde!
    // We moeten de bit "shiften" naar links met het aantal benodigde posities!
    // We nemen eerst aan dat de bit positie sh = 0. Dus 0001.
    .label b = 2
    .label y = 2
    .label c = $e
    .label x = $b
    .label __15 = 8
    .label __16 = 3
    .label __17 = 6
    .label __18 = 3
    // char ix = x >> 1
    // [86] plot::ix#0 = plot::x#7 >> 1 -- vbuz1=vbuz2_ror_1 
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
    lda.z x
    lsr
    sta.z ix
    // char iy = y >> 1
    // [87] plot::iy#0 = plot::y#7 >> 1 -- vbuz1=vbuz2_ror_1 
    // We "shiften" de x waarde met 1 stapje naar rechts (dit is binair gelijk aan delen door 2)!
    lda.z y
    lsr
    sta.z iy
    // (unsigned int)iy * 80
    // [88] plot::$12 = (unsigned int)plot::iy#0 -- vwuz1=_word_vbuz2 
    sta.z __12
    lda #0
    sta.z __12+1
    // [89] plot::$17 = plot::$12 << 2 -- vwuz1=vwuz2_rol_2 
    lda.z __12
    asl
    sta.z __17
    lda.z __12+1
    rol
    sta.z __17+1
    asl.z __17
    rol.z __17+1
    // [90] plot::$18 = plot::$17 + plot::$12 -- vwuz1=vwuz2_plus_vwuz1 
    clc
    lda.z __18
    adc.z __17
    sta.z __18
    lda.z __18+1
    adc.z __17+1
    sta.z __18+1
    // [91] plot::$2 = plot::$18 << 4 -- vwuz1=vwuz1_rol_4 
    asl.z __2
    rol.z __2+1
    asl.z __2
    rol.z __2+1
    asl.z __2
    rol.z __2+1
    asl.z __2
    rol.z __2+1
    // unsigned int i = (unsigned int)iy * 80 + ix
    // [92] plot::i#0 = plot::$2 + plot::ix#0 -- vwuz1=vwuz1_plus_vbuz2 
    // We berekenen de index in de lijst van de bitmap die moet "geupdate" worden.
    lda.z ix
    clc
    adc.z i
    sta.z i
    bcc !+
    inc.z i+1
  !:
    // char bm = bitmap[i]
    // [93] plot::$15 = bitmap + plot::i#0 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z i
    clc
    adc #<bitmap
    sta.z __15
    lda.z i+1
    adc #>bitmap
    sta.z __15+1
    // [94] plot::bm#0 = *plot::$15 -- vbuz1=_deref_pbuz2 
    // We lezen de 8-bit waarde van de bitmap en houden het bij in een tijdelijke bm (=bitmap) variabele.
    ldy #0
    lda (__15),y
    sta.z bm
    // char bx = (x % 2)
    // [95] plot::bx#0 = plot::x#7 & 2-1 -- vbuz1=vbuz1_band_vbuc1 
    // De % operator neemt de "modulus" van de x en y waarde en stockeren dit in de bx en by variablen.
    // Dus als x = 159 en dan modulus 2, dan zal het resultaat 1 zijn! Bij x = 140 modulus 2, is het resultaat 0!
    // Idem voor y!
    lda #2-1
    and.z bx
    sta.z bx
    // y % 2
    // [96] plot::$5 = plot::y#7 & 2-1 -- vbuz1=vbuz1_band_vbuc1 
    lda #2-1
    and.z __5
    sta.z __5
    // char by = (y % 2) * 2
    // [97] plot::by#0 = plot::$5 << 1 -- vbuz1=vbuz1_rol_1 
    // Let op! Deze sequentie zal de resulterende modulus waar eerst vermenigvuldigen met 2, want het *-tje zal een vermenigvuldiging toepassen!
    asl.z by
    // by + bx
    // [98] plot::$7 = plot::by#0 + plot::bx#0 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z __7
    clc
    adc.z bx
    sta.z __7
    // char sh = (by + bx) ^ 3
    // [99] plot::sh#0 = plot::$7 ^ 3 -- vbuz1=vbuz1_bxor_vbuc1 
    /*
    Dit is erg ingewikkeld he! Wat we hier doen is de variablen van by en bx eerst optellen.
    En dan doen we een exclusive OR operatie met 3.
    3 in binair = 11!
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
    lda #3
    eor.z sh
    sta.z sh
    // if (sh)
    // [100] if(0==plot::sh#0) goto plot::@1 -- 0_eq_vbuz1_then_la1 
    beq __b4
    // plot::@4
    // b = 1 << sh
    // [101] plot::b#1 = 1 << plot::sh#0 -- vbuz1=vbuc1_rol_vbuz1 
    lda #1
    ldy.z b
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta.z b
    // [102] phi from plot::@4 to plot::@1 [phi:plot::@4->plot::@1]
    // [102] phi plot::b#2 = plot::b#1 [phi:plot::@4->plot::@1#0] -- register_copy 
    jmp __b1
    // [102] phi from plot to plot::@1 [phi:plot->plot::@1]
  __b4:
    // [102] phi plot::b#2 = 1 [phi:plot->plot::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z b
    // plot::@1
  __b1:
    // if (c)
    // [103] if(0!=plot::c#7) goto plot::@2 -- 0_neq_vbuz1_then_la1 
    // Als laatste bekijken we exact wat er moet gebeuren met de "kleur".
    // Onthou! Een 0 verwijdert een blokje en een 1 tekent een blokje.
    // if (c) zal bekijken of c niet nul is, of anders gezegt, een waarde bevat.
    // Indien c niet 0 is, dan zal er een OR operatie plaatvinden met b!
    // Indien c 0 is, dan zal er een AND operatie plaatvinden met de inverse van b!
    lda.z c
    bne __b2
    // plot::@5
    // ~b
    // [104] plot::$11 = ~ plot::b#2 -- vbuz1=_bnot_vbuz1 
    lda.z __11
    eor #$ff
    sta.z __11
    // bm &= ~b
    // [105] plot::bm#2 = plot::bm#0 & plot::$11 -- vbuz1=vbuz1_band_vbuz2 
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
    lda.z bm
    and.z __11
    sta.z bm
    // [106] phi from plot::@2 plot::@5 to plot::@3 [phi:plot::@2/plot::@5->plot::@3]
    // [106] phi plot::bm#5 = plot::bm#1 [phi:plot::@2/plot::@5->plot::@3#0] -- register_copy 
    // plot::@3
  __b3:
    // bitmap[i] = bm
    // [107] plot::$16 = bitmap + plot::i#0 -- pbuz1=pbuc1_plus_vwuz1 
    lda.z __16
    clc
    adc #<bitmap
    sta.z __16
    lda.z __16+1
    adc #>bitmap
    sta.z __16+1
    // [108] *plot::$16 = plot::bm#5 -- _deref_pbuz1=vbuz2 
    // En als laatste wijzen we nu de bijgewerkte bitmap toe aan de vorige bitmap index positie!
    // In andere woorden, we overschrijven de vorige waarde met de nieuwe berekende waarde.
    lda.z bm
    ldy #0
    sta (__16),y
    // plot::@return
    // }
    // [109] return 
    rts
    // plot::@2
  __b2:
    // bm |= b
    // [110] plot::bm#1 = plot::bm#0 | plot::b#2 -- vbuz1=vbuz1_bor_vbuz2 
    // De |= operator berekent een OR operatie met bm en b. We lichten wat OR is nader toe in de klas.
    // Als geheugensteuntje voor de | of de OR operator ... 1 = 1 | 1 ... 1 = 1 | 0 ... 1 = 0 | 1 ... 0 = 0 | 0 ...
    // Als voorbeeld, stel bm = 1010 en b = 0001 ...
    // ... De operatie voluit geschreven wordt: bm = bm | b;
    // ... bm = 1010 | 0001 ...
    // ... bm = 1011
    // Wat leren we hieruit? Dat we bit 0 van de bitmap hebben aangezet, bm = 1011 als resultaat, waar de laatste waarde nu 1 is!
    lda.z bm
    ora.z b
    sta.z bm
    jmp __b3
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
    .label x = $c
    // [112] phi from paint to paint::@1 [phi:paint->paint::@1]
    // [112] phi paint::x#2 = 0 [phi:paint->paint::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z x
    // paint::@1
  __b1:
    // for (char x = 0; x < 80; x++)
    // [113] if(paint::x#2<$50) goto paint::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z x
    cmp #$50
    bcc __b2
    // paint::@return
    // }
    // [114] return 
    rts
    // paint::@2
  __b2:
    // *(screen + 80 * 0 + x) = block[bitmap[80 * 0 + x]]
    // [115] screen[paint::x#2] = block[bitmap[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldx.z x
    ldy bitmap,x
    lda block,y
    sta screen,x
    // *(screen + 80 * 1 + x) = block[bitmap[80 * 1 + x]]
    // [116] (screen+$50*1)[paint::x#2] = block[(bitmap+$50*1)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*1,x
    lda block,y
    sta screen+$50*1,x
    // *(screen + 80 * 2 + x) = block[bitmap[80 * 2 + x]]
    // [117] (screen+$50*2)[paint::x#2] = block[(bitmap+$50*2)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*2,x
    lda block,y
    sta screen+$50*2,x
    // *(screen + 80 * 3 + x) = block[bitmap[80 * 3 + x]]
    // [118] (screen+$50*3)[paint::x#2] = block[(bitmap+$50*3)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*3,x
    lda block,y
    sta screen+$50*3,x
    // *(screen + 80 * 4 + x) = block[bitmap[80 * 4 + x]]
    // [119] (screen+(unsigned int)$50*4)[paint::x#2] = block[(bitmap+(unsigned int)$50*4)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*4,x
    lda block,y
    sta screen+$50*4,x
    // *(screen + 80 * 5 + x) = block[bitmap[80 * 5 + x]]
    // [120] (screen+(unsigned int)$50*5)[paint::x#2] = block[(bitmap+(unsigned int)$50*5)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*5,x
    lda block,y
    sta screen+$50*5,x
    // *(screen + 80 * 6 + x) = block[bitmap[80 * 6 + x]]
    // [121] (screen+(unsigned int)$50*6)[paint::x#2] = block[(bitmap+(unsigned int)$50*6)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*6,x
    lda block,y
    sta screen+$50*6,x
    // *(screen + 80 * 7 + x) = block[bitmap[80 * 7 + x]]
    // [122] (screen+(unsigned int)$50*7)[paint::x#2] = block[(bitmap+(unsigned int)$50*7)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*7,x
    lda block,y
    sta screen+$50*7,x
    // *(screen + 80 * 8 + x) = block[bitmap[80 * 8 + x]]
    // [123] (screen+(unsigned int)$50*8)[paint::x#2] = block[(bitmap+(unsigned int)$50*8)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*8,x
    lda block,y
    sta screen+$50*8,x
    // *(screen + 80 * 9 + x) = block[bitmap[80 * 9 + x]]
    // [124] (screen+(unsigned int)$50*9)[paint::x#2] = block[(bitmap+(unsigned int)$50*9)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*9,x
    lda block,y
    sta screen+$50*9,x
    // *(screen + 80 * 10 + x) = block[bitmap[80 * 10 + x]]
    // [125] (screen+(unsigned int)$50*$a)[paint::x#2] = block[(bitmap+(unsigned int)$50*$a)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$a,x
    lda block,y
    sta screen+$50*$a,x
    // *(screen + 80 * 11 + x) = block[bitmap[80 * 11 + x]]
    // [126] (screen+(unsigned int)$50*$b)[paint::x#2] = block[(bitmap+(unsigned int)$50*$b)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$b,x
    lda block,y
    sta screen+$50*$b,x
    // *(screen + 80 * 12 + x) = block[bitmap[80 * 12 + x]]
    // [127] (screen+(unsigned int)$50*$c)[paint::x#2] = block[(bitmap+(unsigned int)$50*$c)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$c,x
    lda block,y
    sta screen+$50*$c,x
    // *(screen + 80 * 13 + x) = block[bitmap[80 * 13 + x]]
    // [128] (screen+(unsigned int)$50*$d)[paint::x#2] = block[(bitmap+(unsigned int)$50*$d)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$d,x
    lda block,y
    sta screen+$50*$d,x
    // *(screen + 80 * 14 + x) = block[bitmap[80 * 14 + x]]
    // [129] (screen+(unsigned int)$50*$e)[paint::x#2] = block[(bitmap+(unsigned int)$50*$e)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$e,x
    lda block,y
    sta screen+$50*$e,x
    // *(screen + 80 * 15 + x) = block[bitmap[80 * 15 + x]]
    // [130] (screen+(unsigned int)$50*$f)[paint::x#2] = block[(bitmap+(unsigned int)$50*$f)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$f,x
    lda block,y
    sta screen+$50*$f,x
    // *(screen + 80 * 16 + x) = block[bitmap[80 * 16 + x]]
    // [131] (screen+(unsigned int)$50*$10)[paint::x#2] = block[(bitmap+(unsigned int)$50*$10)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$10,x
    lda block,y
    sta screen+$50*$10,x
    // *(screen + 80 * 17 + x) = block[bitmap[80 * 17 + x]]
    // [132] (screen+(unsigned int)$50*$11)[paint::x#2] = block[(bitmap+(unsigned int)$50*$11)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$11,x
    lda block,y
    sta screen+$50*$11,x
    // *(screen + 80 * 18 + x) = block[bitmap[80 * 18 + x]]
    // [133] (screen+(unsigned int)$50*$12)[paint::x#2] = block[(bitmap+(unsigned int)$50*$12)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$12,x
    lda block,y
    sta screen+$50*$12,x
    // *(screen + 80 * 19 + x) = block[bitmap[80 * 19 + x]]
    // [134] (screen+(unsigned int)$50*$13)[paint::x#2] = block[(bitmap+(unsigned int)$50*$13)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$13,x
    lda block,y
    sta screen+$50*$13,x
    // *(screen + 80 * 20 + x) = block[bitmap[80 * 20 + x]]
    // [135] (screen+(unsigned int)$50*$14)[paint::x#2] = block[(bitmap+(unsigned int)$50*$14)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$14,x
    lda block,y
    sta screen+$50*$14,x
    // *(screen + 80 * 21 + x) = block[bitmap[80 * 21 + x]]
    // [136] (screen+(unsigned int)$50*$15)[paint::x#2] = block[(bitmap+(unsigned int)$50*$15)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$15,x
    lda block,y
    sta screen+$50*$15,x
    // *(screen + 80 * 22 + x) = block[bitmap[80 * 22 + x]]
    // [137] (screen+(unsigned int)$50*$16)[paint::x#2] = block[(bitmap+(unsigned int)$50*$16)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$16,x
    lda block,y
    sta screen+$50*$16,x
    // *(screen + 80 * 23 + x) = block[bitmap[80 * 23 + x]]
    // [138] (screen+(unsigned int)$50*$17)[paint::x#2] = block[(bitmap+(unsigned int)$50*$17)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$17,x
    lda block,y
    sta screen+$50*$17,x
    // *(screen + 80 * 24 + x) = block[bitmap[80 * 24 + x]]
    // [139] (screen+(unsigned int)$50*$18)[paint::x#2] = block[(bitmap+(unsigned int)$50*$18)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$18,x
    lda block,y
    sta screen+$50*$18,x
    // for (char x = 0; x < 80; x++)
    // [140] paint::x#1 = ++ paint::x#2 -- vbuz1=_inc_vbuz1 
    inc.z x
    // [112] phi from paint::@2 to paint::@1 [phi:paint::@2->paint::@1]
    // [112] phi paint::x#2 = paint::x#1 [phi:paint::@2->paint::@1#0] -- register_copy 
    jmp __b1
}
  // cbm_k_getin
/**
 * @brief Scan a character from keyboard without pressing enter.
 * 
 * @return char The character read.
 */
cbm_k_getin: {
    .label return = $10
    // __mem unsigned char ch
    // [141] cbm_k_getin::ch = 0 -- vbum1=vbuc1 
    lda #0
    sta ch
    // asm
    // asm { jsrCBM_GETIN stach  }
    jsr CBM_GETIN
    sta ch
    // return ch;
    // [143] cbm_k_getin::return#0 = cbm_k_getin::ch -- vbuz1=vbum2 
    sta.z return
    // cbm_k_getin::@return
    // }
    // [144] cbm_k_getin::return#1 = cbm_k_getin::return#0
    // [145] return 
    rts
  .segment Data
    ch: .byte 0
}
  // File Data
  // De bitmap variabele bevat een lijst van alle karaketers die op het scherm moeten worden getekend.
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
  // Bekijk de [PETSCII](https://www.pagetable.com/c64ref/charset) karaketerset via deze link.
  //
  // Belangrijk: Bij deze declaratie noteren we 16 elementen als grootte, maar bij het gebruik van deze array, verder in het programma,
  // zijn de index waarden enkel tussen 0 en 15 toegelaten! Indien er een waarde groter dan 0 en 15 worden gebruikt, heb je een overflow!
  // In die geval zal er een onbekend geheugen worden gelezen of nog erger, geschreven! Dit mag in een programma nooit gebeuren!
  block: .byte $10*2, $10*6+$c, $10*7+$b, $10*6+2, $10*7+$c, $10*$e+1, $10*$f+$f, $10*$f+$e, $10*7+$e, $10*7+$f, $10*6+1, $10*$f+$c, $10*$e+2, $10*$f+$b, $10*$e+$c, $10*$a
