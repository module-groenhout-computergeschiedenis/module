  // File Comments
/**
 * @file pong-1.c
 * @author your name (you@domain.com)
 * @brief Dit is je eerste C programma, dat werkt op de PET 8032!
 * Het is een eerste stap naar je werkende pong game!
 * Probeer het programma te vervolledigen, zodat het vierkantje stuitert tussen de muren in een oneindige lus :-).
 * Kijk in het programma naar de lijnen met verduidelijkingen, want je kan er aanwijzingen in vinden!
 * Deze verduidelijkingen zitten in commentaarlijnen, een syntax, en beginnen op elke lijn met // of zitten tussen /* en * /.
 * De VSCODE editor geeft deze lijnen een specifieke kleur!
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
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $8000
  .label screen = $8000
.segment Code
  // main
main: {
    .const dx = 1
    .const dy = 1
    .label y = $b
    .label x = $d
    .label e = 4
    // clrscr()
    // [1] call clrscr
    // [16] phi from main to clrscr [phi:main->clrscr]
    jsr clrscr
    // [2] phi from main to main::@1 [phi:main->main::@1]
    // [2] phi main::y#2 = 0 [phi:main->main::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z y
    sta.z y+1
    // [2] phi main::x#2 = 0 [phi:main->main::@1#1] -- vwuz1=vwuc1 
    sta.z x
    sta.z x+1
    // main::@1
    // main::@2
  __b2:
    // plot(x, y, 0)
    // [3] plot::x#0 = main::x#2 -- vbuz1=vwuz2 
    lda.z x
    sta.z plot.x
    // [4] plot::y#0 = main::y#2 -- vbuxx=vwuz1 
    ldx.z y
    // [5] call plot
    // [26] phi from main::@2 to plot [phi:main::@2->plot]
    // [26] phi plot::c#2 = 0 [phi:main::@2->plot#0] -- vbuz1=vbuc1 
    lda #0
    sta.z plot.c
    // [26] phi plot::y#2 = plot::y#0 [phi:main::@2->plot#1] -- register_copy 
    // [26] phi plot::x#2 = plot::x#0 [phi:main::@2->plot#2] -- register_copy 
    jsr plot
    // main::@5
    // y += dy
    // [6] main::y#1 = main::y#2 + main::dy -- vwuz1=vwuz1_plus_vbsc1 
    lda #dy
    clc
    sta.z $ff
    adc.z y
    sta.z y
    lda.z $ff
    ora #$7f
    bmi !+
    lda #0
  !:
    adc.z y+1
    sta.z y+1
    // x += dx
    // [7] main::x#1 = main::x#2 + main::dx -- vwuz1=vwuz1_plus_vbsc1 
    lda #dx
    clc
    sta.z $ff
    adc.z x
    sta.z x
    lda.z $ff
    ora #$7f
    bmi !+
    lda #0
  !:
    adc.z x+1
    sta.z x+1
    // plot(x, y, 1)
    // [8] plot::x#1 = main::x#1 -- vbuz1=vwuz2 
    lda.z x
    sta.z plot.x
    // [9] plot::y#1 = main::y#1 -- vbuxx=vwuz1 
    ldx.z y
    // [10] call plot
  // OEFENING: Kan je zorgen dat het blokje goed loopt? 
  // Dat het op het einde van het scherm terug botst op de rand van het scherm? 
    // [26] phi from main::@5 to plot [phi:main::@5->plot]
    // [26] phi plot::c#2 = 1 [phi:main::@5->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [26] phi plot::y#2 = plot::y#1 [phi:main::@5->plot#1] -- register_copy 
    // [26] phi plot::x#2 = plot::x#1 [phi:main::@5->plot#2] -- register_copy 
    jsr plot
    // [11] phi from main::@5 to main::@6 [phi:main::@5->main::@6]
    // main::@6
    // draw()
    // [12] call draw
    // [52] phi from main::@6 to draw [phi:main::@6->draw]
    jsr draw
    // [13] phi from main::@6 to main::@3 [phi:main::@6->main::@3]
    // [13] phi main::e#2 = 0 [phi:main::@6->main::@3#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z e
    sta.z e+1
    // main::@3
  __b3:
    // for (unsigned int e = 0; e < 16384; e++)
    // [14] if(main::e#2<$4000) goto main::@4 -- vwuz1_lt_vwuc1_then_la1 
    lda.z e+1
    cmp #>$4000
    bcc __b4
    bne !+
    lda.z e
    cmp #<$4000
    bcc __b4
  !:
    // [2] phi from main::@3 to main::@1 [phi:main::@3->main::@1]
    // [2] phi main::y#2 = main::y#1 [phi:main::@3->main::@1#0] -- register_copy 
    // [2] phi main::x#2 = main::x#1 [phi:main::@3->main::@1#1] -- register_copy 
    jmp __b2
    // main::@4
  __b4:
    // for (unsigned int e = 0; e < 16384; e++)
    // [15] main::e#1 = ++ main::e#2 -- vwuz1=_inc_vwuz1 
    inc.z e
    bne !+
    inc.z e+1
  !:
    // [13] phi from main::@4 to main::@3 [phi:main::@4->main::@3]
    // [13] phi main::e#2 = main::e#1 [phi:main::@4->main::@3#0] -- register_copy 
    jmp __b3
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = 2
    // [17] phi from clrscr to clrscr::@1 [phi:clrscr->clrscr::@1]
    // [17] phi clrscr::line_text#5 = DEFAULT_SCREEN [phi:clrscr->clrscr::@1#0] -- pbuz1=pbuc1 
    lda #<DEFAULT_SCREEN
    sta.z line_text
    lda #>DEFAULT_SCREEN
    sta.z line_text+1
    // [17] phi clrscr::l#2 = 0 [phi:clrscr->clrscr::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // clrscr::@1
  __b1:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [18] if(clrscr::l#2<$19) goto clrscr::@2 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$19
    bcc __b4
    // clrscr::@return
    // }
    // [19] return 
    rts
    // [20] phi from clrscr::@1 to clrscr::@2 [phi:clrscr::@1->clrscr::@2]
  __b4:
    // [20] phi clrscr::c#2 = 0 [phi:clrscr::@1->clrscr::@2#0] -- vbuyy=vbuc1 
    ldy #0
    // clrscr::@2
  __b2:
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [21] if(clrscr::c#2<$50) goto clrscr::@3 -- vbuyy_lt_vbuc1_then_la1 
    cpy #$50
    bcc __b3
    // clrscr::@4
    // line_text += CONIO_WIDTH
    // [22] clrscr::line_text#1 = clrscr::line_text#5 + $50 -- pbuz1=pbuz1_plus_vbuc1 
    lda #$50
    clc
    adc.z line_text
    sta.z line_text
    bcc !+
    inc.z line_text+1
  !:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [23] clrscr::l#1 = ++ clrscr::l#2 -- vbuxx=_inc_vbuxx 
    inx
    // [17] phi from clrscr::@4 to clrscr::@1 [phi:clrscr::@4->clrscr::@1]
    // [17] phi clrscr::line_text#5 = clrscr::line_text#1 [phi:clrscr::@4->clrscr::@1#0] -- register_copy 
    // [17] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@4->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@3
  __b3:
    // line_text[c] = ' '
    // [24] clrscr::line_text#5[clrscr::c#2] = ' 'pm -- pbuz1_derefidx_vbuyy=vbuc1 
  .encoding "petscii_mixed"
    lda #' '
    sta (line_text),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [25] clrscr::c#1 = ++ clrscr::c#2 -- vbuyy=_inc_vbuyy 
    iny
    // [20] phi from clrscr::@3 to clrscr::@2 [phi:clrscr::@3->clrscr::@2]
    // [20] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@3->clrscr::@2#0] -- register_copy 
    jmp __b2
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
// void plot(__zp($a) char x, __register(X) char y, __zp($10) char c)
plot: {
    .label __2 = 2
    .label __12 = 2
    .label i = 2
    .label bm = $f
    .label bx = $a
    .label x = $a
    .label c = $10
    .label __15 = 8
    .label __16 = 2
    .label __17 = 6
    .label __18 = 2
    // char ix = x >> 1
    // [27] plot::ix#0 = plot::x#2 >> 1 -- vbuyy=vbuz1_ror_1 
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
    tay
    // char iy = y >> 1
    // [28] plot::iy#0 = plot::y#2 >> 1 -- vbuaa=vbuxx_ror_1 
    // We "shiften" de x waarde met 1 stapje naar rechts (dit is binair gelijk aan delen door 2)!
    txa
    lsr
    // (unsigned int)iy * 80
    // [29] plot::$12 = (unsigned int)plot::iy#0 -- vwuz1=_word_vbuaa 
    sta.z __12
    lda #0
    sta.z __12+1
    // [30] plot::$17 = plot::$12 << 2 -- vwuz1=vwuz2_rol_2 
    lda.z __12
    asl
    sta.z __17
    lda.z __12+1
    rol
    sta.z __17+1
    asl.z __17
    rol.z __17+1
    // [31] plot::$18 = plot::$17 + plot::$12 -- vwuz1=vwuz2_plus_vwuz1 
    clc
    lda.z __18
    adc.z __17
    sta.z __18
    lda.z __18+1
    adc.z __17+1
    sta.z __18+1
    // [32] plot::$2 = plot::$18 << 4 -- vwuz1=vwuz1_rol_4 
    asl.z __2
    rol.z __2+1
    asl.z __2
    rol.z __2+1
    asl.z __2
    rol.z __2+1
    asl.z __2
    rol.z __2+1
    // unsigned int i = (unsigned int)iy * 80 + ix
    // [33] plot::i#0 = plot::$2 + plot::ix#0 -- vwuz1=vwuz1_plus_vbuyy 
    // We berekenen de index in de lijst van de bitmap die moet "geupdate" worden.
    tya
    clc
    adc.z i
    sta.z i
    bcc !+
    inc.z i+1
  !:
    // char bm = bitmap[i]
    // [34] plot::$15 = bitmap + plot::i#0 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z i
    clc
    adc #<bitmap
    sta.z __15
    lda.z i+1
    adc #>bitmap
    sta.z __15+1
    // [35] plot::bm#0 = *plot::$15 -- vbuz1=_deref_pbuz2 
    // We lezen de 8-bit waarde van de bitmap en houden het bij in een tijdelijke bm (=bitmap) variabele.
    ldy #0
    lda (__15),y
    sta.z bm
    // char bx = (x % 2)
    // [36] plot::bx#0 = plot::x#2 & 2-1 -- vbuz1=vbuz1_band_vbuc1 
    // De % operator neemt de "modulus" van de x en y waarde en stockeren dit in de bx en by variablen.
    // Dus als x = 159 en dan modulus 2, dan zal het resultaat 1 zijn! Bij x = 140 modulus 2, is het resultaat 0!
    // Idem voor y!
    lda #2-1
    and.z bx
    sta.z bx
    // y % 2
    // [37] plot::$5 = plot::y#2 & 2-1 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #2-1
    // char by = (y % 2) * 2
    // [38] plot::by#0 = plot::$5 << 1 -- vbuaa=vbuaa_rol_1 
    // Let op! Deze sequentie zal de resulterende modulus waar eerst vermenigvuldigen met 2, want het *-tje zal een vermenigvuldiging toepassen!
    asl
    // by + bx
    // [39] plot::$7 = plot::by#0 + plot::bx#0 -- vbuaa=vbuaa_plus_vbuz1 
    clc
    adc.z bx
    // char sh = (by + bx) ^ 3
    // [40] plot::sh#0 = plot::$7 ^ 3 -- vbuaa=vbuaa_bxor_vbuc1 
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
    eor #3
    // if (sh)
    // [41] if(0==plot::sh#0) goto plot::@1 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b4
    // plot::@4
    // b = 1 << sh
    // [42] plot::b#1 = 1 << plot::sh#0 -- vbuxx=vbuc1_rol_vbuaa 
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
    // [43] phi from plot::@4 to plot::@1 [phi:plot::@4->plot::@1]
    // [43] phi plot::b#2 = plot::b#1 [phi:plot::@4->plot::@1#0] -- register_copy 
    jmp __b1
    // [43] phi from plot to plot::@1 [phi:plot->plot::@1]
  __b4:
    // [43] phi plot::b#2 = 1 [phi:plot->plot::@1#0] -- vbuxx=vbuc1 
    ldx #1
    // plot::@1
  __b1:
    // if (c)
    // [44] if(0!=plot::c#2) goto plot::@2 -- 0_neq_vbuz1_then_la1 
    // Als laatste bekijken we exact wat er moet gebeuren met de "kleur".
    // Onthou! Een 0 verwijdert een blokje en een 1 tekent een blokje.
    // if (c) zal bekijken of c niet nul is, of anders gezegt, een waarde bevat.
    // Indien c niet 0 is, dan zal er een OR operatie plaatvinden met b!
    // Indien c 0 is, dan zal er een AND operatie plaatvinden met de inverse van b!
    lda.z c
    bne __b2
    // plot::@5
    // ~b
    // [45] plot::$11 = ~ plot::b#2 -- vbuaa=_bnot_vbuxx 
    txa
    eor #$ff
    // bm &= ~b
    // [46] plot::bm#2 = plot::bm#0 & plot::$11 -- vbuxx=vbuz1_band_vbuaa 
    // De &= operator berekent een AND operatie met bm en de inverse van b. We lichten wat AND is nader toe in de klas.
    // Als geheugensteuntje voor de & or AND operator ... 1 = 1 AND 1 ... 0 = 1 AND 0 ... 0 = 0 AND 1 ... 0 = 0 AND 0 ...
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
    // [47] phi from plot::@2 plot::@5 to plot::@3 [phi:plot::@2/plot::@5->plot::@3]
    // [47] phi plot::bm#5 = plot::bm#1 [phi:plot::@2/plot::@5->plot::@3#0] -- register_copy 
    // plot::@3
  __b3:
    // bitmap[i] = bm
    // [48] plot::$16 = bitmap + plot::i#0 -- pbuz1=pbuc1_plus_vwuz1 
    lda.z __16
    clc
    adc #<bitmap
    sta.z __16
    lda.z __16+1
    adc #>bitmap
    sta.z __16+1
    // [49] *plot::$16 = plot::bm#5 -- _deref_pbuz1=vbuxx 
    // En als laatste wijzen we nu de bijgewerkte bitmap toe aan de vorige bitmap index positie!
    // In andere woorden, we overschrijven de vorige waarde met de nieuwe berekende waarde.
    txa
    ldy #0
    sta (__16),y
    // plot::@return
    // }
    // [50] return 
    rts
    // plot::@2
  __b2:
    // bm |= b
    // [51] plot::bm#1 = plot::bm#0 | plot::b#2 -- vbuxx=vbuz1_bor_vbuxx 
    // De |= operator berekent een OR operatie met bm en b. We lichten wat OR is nader toe in de klas.
    // Als geheugensteuntje voor de | or OR operator ... 1 = 1 OR 1 ... 1 = 1 OR 0 ... 1 = 0 OR 1 ... 0 = 0 OR 0 ...
    // Als voorbeeld, stel bm = 1010 en b = 0001 ...
    // ... De operatie voluit geschreven wordt: bm = bm | b;
    // ... bm = 1010 | 0001 ...
    // ... bm = 1011
    // Wat leren we hieruit? Dat we bit 0 van de bitmap hebben aangezet, bm = 1011 als resultaat, waar de laatste waarde nu 1 is!
    txa
    ora.z bm
    tax
    jmp __b3
}
  // draw
draw: {
    // [53] phi from draw to draw::@1 [phi:draw->draw::@1]
    // [53] phi draw::x#2 = 0 [phi:draw->draw::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // draw::@1
  __b1:
    // for (char x = 0; x < 80; x++)
    // [54] if(draw::x#2<$50) goto draw::@2 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$50
    bcc __b2
    // draw::@return
    // }
    // [55] return 
    rts
    // draw::@2
  __b2:
    // *(screen + 80 * 0 + x) = block[bitmap[80 * 0 + x]]
    // [56] screen[draw::x#2] = block[bitmap[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap,x
    lda block,y
    sta screen,x
    // *(screen + 80 * 1 + x) = block[bitmap[80 * 1 + x]]
    // [57] (screen+$50*1)[draw::x#2] = block[(bitmap+$50*1)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*1,x
    lda block,y
    sta screen+$50*1,x
    // *(screen + 80 * 2 + x) = block[bitmap[80 * 2 + x]]
    // [58] (screen+$50*2)[draw::x#2] = block[(bitmap+$50*2)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*2,x
    lda block,y
    sta screen+$50*2,x
    // *(screen + 80 * 3 + x) = block[bitmap[80 * 3 + x]]
    // [59] (screen+$50*3)[draw::x#2] = block[(bitmap+$50*3)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*3,x
    lda block,y
    sta screen+$50*3,x
    // *(screen + 80 * 4 + x) = block[bitmap[80 * 4 + x]]
    // [60] (screen+(unsigned int)$50*4)[draw::x#2] = block[(bitmap+(unsigned int)$50*4)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*4,x
    lda block,y
    sta screen+$50*4,x
    // *(screen + 80 * 5 + x) = block[bitmap[80 * 5 + x]]
    // [61] (screen+(unsigned int)$50*5)[draw::x#2] = block[(bitmap+(unsigned int)$50*5)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*5,x
    lda block,y
    sta screen+$50*5,x
    // *(screen + 80 * 6 + x) = block[bitmap[80 * 6 + x]]
    // [62] (screen+(unsigned int)$50*6)[draw::x#2] = block[(bitmap+(unsigned int)$50*6)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*6,x
    lda block,y
    sta screen+$50*6,x
    // *(screen + 80 * 7 + x) = block[bitmap[80 * 7 + x]]
    // [63] (screen+(unsigned int)$50*7)[draw::x#2] = block[(bitmap+(unsigned int)$50*7)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*7,x
    lda block,y
    sta screen+$50*7,x
    // *(screen + 80 * 8 + x) = block[bitmap[80 * 8 + x]]
    // [64] (screen+(unsigned int)$50*8)[draw::x#2] = block[(bitmap+(unsigned int)$50*8)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*8,x
    lda block,y
    sta screen+$50*8,x
    // *(screen + 80 * 9 + x) = block[bitmap[80 * 9 + x]]
    // [65] (screen+(unsigned int)$50*9)[draw::x#2] = block[(bitmap+(unsigned int)$50*9)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*9,x
    lda block,y
    sta screen+$50*9,x
    // *(screen + 80 * 10 + x) = block[bitmap[80 * 10 + x]]
    // [66] (screen+(unsigned int)$50*$a)[draw::x#2] = block[(bitmap+(unsigned int)$50*$a)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$a,x
    lda block,y
    sta screen+$50*$a,x
    // *(screen + 80 * 11 + x) = block[bitmap[80 * 11 + x]]
    // [67] (screen+(unsigned int)$50*$b)[draw::x#2] = block[(bitmap+(unsigned int)$50*$b)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$b,x
    lda block,y
    sta screen+$50*$b,x
    // *(screen + 80 * 12 + x) = block[bitmap[80 * 12 + x]]
    // [68] (screen+(unsigned int)$50*$c)[draw::x#2] = block[(bitmap+(unsigned int)$50*$c)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$c,x
    lda block,y
    sta screen+$50*$c,x
    // *(screen + 80 * 13 + x) = block[bitmap[80 * 13 + x]]
    // [69] (screen+(unsigned int)$50*$d)[draw::x#2] = block[(bitmap+(unsigned int)$50*$d)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$d,x
    lda block,y
    sta screen+$50*$d,x
    // *(screen + 80 * 14 + x) = block[bitmap[80 * 14 + x]]
    // [70] (screen+(unsigned int)$50*$e)[draw::x#2] = block[(bitmap+(unsigned int)$50*$e)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$e,x
    lda block,y
    sta screen+$50*$e,x
    // *(screen + 80 * 15 + x) = block[bitmap[80 * 15 + x]]
    // [71] (screen+(unsigned int)$50*$f)[draw::x#2] = block[(bitmap+(unsigned int)$50*$f)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$f,x
    lda block,y
    sta screen+$50*$f,x
    // *(screen + 80 * 16 + x) = block[bitmap[80 * 16 + x]]
    // [72] (screen+(unsigned int)$50*$10)[draw::x#2] = block[(bitmap+(unsigned int)$50*$10)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$10,x
    lda block,y
    sta screen+$50*$10,x
    // *(screen + 80 * 17 + x) = block[bitmap[80 * 17 + x]]
    // [73] (screen+(unsigned int)$50*$11)[draw::x#2] = block[(bitmap+(unsigned int)$50*$11)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$11,x
    lda block,y
    sta screen+$50*$11,x
    // *(screen + 80 * 18 + x) = block[bitmap[80 * 18 + x]]
    // [74] (screen+(unsigned int)$50*$12)[draw::x#2] = block[(bitmap+(unsigned int)$50*$12)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$12,x
    lda block,y
    sta screen+$50*$12,x
    // *(screen + 80 * 19 + x) = block[bitmap[80 * 19 + x]]
    // [75] (screen+(unsigned int)$50*$13)[draw::x#2] = block[(bitmap+(unsigned int)$50*$13)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$13,x
    lda block,y
    sta screen+$50*$13,x
    // *(screen + 80 * 20 + x) = block[bitmap[80 * 20 + x]]
    // [76] (screen+(unsigned int)$50*$14)[draw::x#2] = block[(bitmap+(unsigned int)$50*$14)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$14,x
    lda block,y
    sta screen+$50*$14,x
    // *(screen + 80 * 21 + x) = block[bitmap[80 * 21 + x]]
    // [77] (screen+(unsigned int)$50*$15)[draw::x#2] = block[(bitmap+(unsigned int)$50*$15)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$15,x
    lda block,y
    sta screen+$50*$15,x
    // *(screen + 80 * 22 + x) = block[bitmap[80 * 22 + x]]
    // [78] (screen+(unsigned int)$50*$16)[draw::x#2] = block[(bitmap+(unsigned int)$50*$16)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$16,x
    lda block,y
    sta screen+$50*$16,x
    // *(screen + 80 * 23 + x) = block[bitmap[80 * 23 + x]]
    // [79] (screen+(unsigned int)$50*$17)[draw::x#2] = block[(bitmap+(unsigned int)$50*$17)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$17,x
    lda block,y
    sta screen+$50*$17,x
    // *(screen + 80 * 24 + x) = block[bitmap[80 * 24 + x]]
    // [80] (screen+(unsigned int)$50*$18)[draw::x#2] = block[(bitmap+(unsigned int)$50*$18)[draw::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$18,x
    lda block,y
    sta screen+$50*$18,x
    // for (char x = 0; x < 80; x++)
    // [81] draw::x#1 = ++ draw::x#2 -- vbuxx=_inc_vbuxx 
    inx
    // [53] phi from draw::@2 to draw::@1 [phi:draw::@2->draw::@1]
    // [53] phi draw::x#2 = draw::x#1 [phi:draw::@2->draw::@1#0] -- register_copy 
    jmp __b1
}
  // File Data
.segment Data
  bitmap: .byte 0
  .fill $18ff, 0
  block: .byte $10*2, $10*6+$c, $10*7+$b, $10*6+2, $10*7+$c, $10*$e+1, $10*$f+$f, $10*$f+$e, $10*7+$e, $10*7+$f, $10*6+1, $10*$f+$c, $10*$e+2, $10*$f+$b, $10*$e+$c, $10*$a
