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
    // Een aantal werk variabelen die de huidige x en y positie van het balletje bijhouden.
    // Noteer dat de x en y waarden hier int = integer waarden zijn, en dus 16-bits groot!
    // Dit is om je te leren dat in een programma variabelen verschillende data types kunnen hebben!
    .label y = $b
    .label x = $d
    .label e = 4
    .label dy = $f
    // Deze werk variabelen houden de "deltas" bij van de richting van het balletje.
    // Deze zijn 8-bit variabelen, maar de zijn "signed". Dit wil zeggen,
    // dat de variabelen ook een negatieve waarde kunnen hebben!
    // Ik zal jullie in de klas uitleggen hoe dit kan!
    .label dx = $10
    // clrscr()
    // [1] call clrscr
    // [28] phi from main to clrscr [phi:main->clrscr]
    jsr clrscr
    // [2] phi from main to main::@1 [phi:main->main::@1]
    // [2] phi main::dx#12 = 1 [phi:main->main::@1#0] -- vbsz1=vbsc1 
    lda #1
    sta.z dx
    // [2] phi main::dy#3 = 1 [phi:main->main::@1#1] -- vbsz1=vbsc1 
    sta.z dy
    // [2] phi main::y#2 = 0 [phi:main->main::@1#2] -- vwuz1=vwuc1 
    lda #<0
    sta.z y
    sta.z y+1
    // [2] phi main::x#2 = 0 [phi:main->main::@1#3] -- vwuz1=vwuc1 
    sta.z x
    sta.z x+1
  // De while functie in C maakt een loop of een lus.
  // Dus de instructies binnen de { } worden uitgevoerd totdat de waarde binnen de ( ) waar is.
  // 1 is een positieve waarde, dus de while functie zal hier altijd en oneindig blijven herhalen!
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
    // [38] phi from main::@2 to plot [phi:main::@2->plot]
    // [38] phi plot::c#2 = 0 [phi:main::@2->plot#0] -- vbuz1=vbuc1 
    lda #0
    sta.z plot.c
    // [38] phi plot::y#2 = plot::y#0 [phi:main::@2->plot#1] -- register_copy 
    // [38] phi plot::x#2 = plot::x#0 [phi:main::@2->plot#2] -- register_copy 
    jsr plot
    // main::@9
    // y += dy
    // [6] main::y#1 = main::y#2 + main::dy#3 -- vwuz1=vwuz1_plus_vbsz2 
    // Nu werken we de x en y positie bij, we tellen de deltas op bij de x en y waarden.
    lda.z dy
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
    // [7] main::x#1 = main::x#2 + main::dx#12 -- vwuz1=vwuz1_plus_vbsz2 
    lda.z dx
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
    // if (y == 0)
    // [8] if(main::y#1!=0) goto main::@11 -- vwuz1_neq_0_then_la1 
    lda.z y
    ora.z y+1
    bne __b3
    // [10] phi from main::@9 to main::@3 [phi:main::@9->main::@3]
    // [10] phi main::dy#15 = 1 [phi:main::@9->main::@3#0] -- vbsz1=vbsc1 
    lda #1
    sta.z dy
    // [9] phi from main::@9 to main::@11 [phi:main::@9->main::@11]
    // main::@11
    // [10] phi from main::@11 to main::@3 [phi:main::@11->main::@3]
    // [10] phi main::dy#15 = main::dy#3 [phi:main::@11->main::@3#0] -- register_copy 
    // main::@3
  __b3:
    // if (y == 49)
    // [11] if(main::y#1!=$31) goto main::@12 -- vwuz1_neq_vbuc1_then_la1 
    lda.z y+1
    bne __b4
    lda.z y
    cmp #$31
    bne __b4
    // [13] phi from main::@3 to main::@4 [phi:main::@3->main::@4]
    // [13] phi main::dy#10 = -1 [phi:main::@3->main::@4#0] -- vbsz1=vbsc1 
    lda #-1
    sta.z dy
    // [12] phi from main::@3 to main::@12 [phi:main::@3->main::@12]
    // main::@12
    // [13] phi from main::@12 to main::@4 [phi:main::@12->main::@4]
    // [13] phi main::dy#10 = main::dy#15 [phi:main::@12->main::@4#0] -- register_copy 
    // main::@4
  __b4:
    // if (x == 0)
    // [14] if(main::x#1!=0) goto main::@13 -- vwuz1_neq_0_then_la1 
    lda.z x
    ora.z x+1
    bne __b5
    // [16] phi from main::@4 to main::@5 [phi:main::@4->main::@5]
    // [16] phi main::dx#11 = 1 [phi:main::@4->main::@5#0] -- vbsz1=vbsc1 
    lda #1
    sta.z dx
    // [15] phi from main::@4 to main::@13 [phi:main::@4->main::@13]
    // main::@13
    // [16] phi from main::@13 to main::@5 [phi:main::@13->main::@5]
    // [16] phi main::dx#11 = main::dx#12 [phi:main::@13->main::@5#0] -- register_copy 
    // main::@5
  __b5:
    // if (x == 159)
    // [17] if(main::x#1!=$9f) goto main::@14 -- vwuz1_neq_vbuc1_then_la1 
    lda.z x+1
    bne __b6
    lda.z x
    cmp #$9f
    bne __b6
    // [19] phi from main::@5 to main::@6 [phi:main::@5->main::@6]
    // [19] phi main::dx#10 = -1 [phi:main::@5->main::@6#0] -- vbsz1=vbsc1 
    lda #-1
    sta.z dx
    // [18] phi from main::@5 to main::@14 [phi:main::@5->main::@14]
    // main::@14
    // [19] phi from main::@14 to main::@6 [phi:main::@14->main::@6]
    // [19] phi main::dx#10 = main::dx#11 [phi:main::@14->main::@6#0] -- register_copy 
    // main::@6
  __b6:
    // plot(x, y, 1)
    // [20] plot::x#1 = main::x#1 -- vbuz1=vwuz2 
    lda.z x
    sta.z plot.x
    // [21] plot::y#1 = main::y#1 -- vbuxx=vwuz1 
    ldx.z y
    // [22] call plot
    // [38] phi from main::@6 to plot [phi:main::@6->plot]
    // [38] phi plot::c#2 = 1 [phi:main::@6->plot#0] -- vbuz1=vbuc1 
    lda #1
    sta.z plot.c
    // [38] phi plot::y#2 = plot::y#1 [phi:main::@6->plot#1] -- register_copy 
    // [38] phi plot::x#2 = plot::x#1 [phi:main::@6->plot#2] -- register_copy 
    jsr plot
    // [23] phi from main::@6 to main::@10 [phi:main::@6->main::@10]
    // main::@10
    // paint()
    // [24] call paint
  // En deze draw functie tekent het volledige scherm door de bitmap te tekenen op alle karaketers om het scherm!
    // [64] phi from main::@10 to paint [phi:main::@10->paint]
    jsr paint
    // [25] phi from main::@10 to main::@7 [phi:main::@10->main::@7]
    // [25] phi main::e#2 = 0 [phi:main::@10->main::@7#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z e
    sta.z e+1
  // Dit is een lus om het programma een beetje trager te lagen werken ...
    // main::@7
  __b7:
    // for (unsigned int e = 0; e < 16384; e++)
    // [26] if(main::e#2<$4000) goto main::@8 -- vwuz1_lt_vwuc1_then_la1 
    lda.z e+1
    cmp #>$4000
    bcc __b8
    bne !+
    lda.z e
    cmp #<$4000
    bcc __b8
  !:
    // [2] phi from main::@7 to main::@1 [phi:main::@7->main::@1]
    // [2] phi main::dx#12 = main::dx#10 [phi:main::@7->main::@1#0] -- register_copy 
    // [2] phi main::dy#3 = main::dy#10 [phi:main::@7->main::@1#1] -- register_copy 
    // [2] phi main::y#2 = main::y#1 [phi:main::@7->main::@1#2] -- register_copy 
    // [2] phi main::x#2 = main::x#1 [phi:main::@7->main::@1#3] -- register_copy 
    jmp __b2
    // main::@8
  __b8:
    // for (unsigned int e = 0; e < 16384; e++)
    // [27] main::e#1 = ++ main::e#2 -- vwuz1=_inc_vwuz1 
    inc.z e
    bne !+
    inc.z e+1
  !:
    // [25] phi from main::@8 to main::@7 [phi:main::@8->main::@7]
    // [25] phi main::e#2 = main::e#1 [phi:main::@8->main::@7#0] -- register_copy 
    jmp __b7
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = 2
    // [29] phi from clrscr to clrscr::@1 [phi:clrscr->clrscr::@1]
    // [29] phi clrscr::line_text#5 = DEFAULT_SCREEN [phi:clrscr->clrscr::@1#0] -- pbuz1=pbuc1 
    lda #<DEFAULT_SCREEN
    sta.z line_text
    lda #>DEFAULT_SCREEN
    sta.z line_text+1
    // [29] phi clrscr::l#2 = 0 [phi:clrscr->clrscr::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // clrscr::@1
  __b1:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [30] if(clrscr::l#2<$19) goto clrscr::@2 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$19
    bcc __b4
    // clrscr::@return
    // }
    // [31] return 
    rts
    // [32] phi from clrscr::@1 to clrscr::@2 [phi:clrscr::@1->clrscr::@2]
  __b4:
    // [32] phi clrscr::c#2 = 0 [phi:clrscr::@1->clrscr::@2#0] -- vbuyy=vbuc1 
    ldy #0
    // clrscr::@2
  __b2:
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [33] if(clrscr::c#2<$50) goto clrscr::@3 -- vbuyy_lt_vbuc1_then_la1 
    cpy #$50
    bcc __b3
    // clrscr::@4
    // line_text += CONIO_WIDTH
    // [34] clrscr::line_text#1 = clrscr::line_text#5 + $50 -- pbuz1=pbuz1_plus_vbuc1 
    lda #$50
    clc
    adc.z line_text
    sta.z line_text
    bcc !+
    inc.z line_text+1
  !:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [35] clrscr::l#1 = ++ clrscr::l#2 -- vbuxx=_inc_vbuxx 
    inx
    // [29] phi from clrscr::@4 to clrscr::@1 [phi:clrscr::@4->clrscr::@1]
    // [29] phi clrscr::line_text#5 = clrscr::line_text#1 [phi:clrscr::@4->clrscr::@1#0] -- register_copy 
    // [29] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@4->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@3
  __b3:
    // line_text[c] = ' '
    // [36] clrscr::line_text#5[clrscr::c#2] = ' 'pm -- pbuz1_derefidx_vbuyy=vbuc1 
  .encoding "petscii_mixed"
    lda #' '
    sta (line_text),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [37] clrscr::c#1 = ++ clrscr::c#2 -- vbuyy=_inc_vbuyy 
    iny
    // [32] phi from clrscr::@3 to clrscr::@2 [phi:clrscr::@3->clrscr::@2]
    // [32] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@3->clrscr::@2#0] -- register_copy 
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
// void plot(__zp($a) char x, __register(X) char y, __zp($12) char c)
plot: {
    .label __2 = 2
    .label __12 = 2
    .label i = 2
    .label bm = $11
    .label bx = $a
    .label x = $a
    .label c = $12
    .label __15 = 8
    .label __16 = 2
    .label __17 = 6
    .label __18 = 2
    // char ix = x >> 1
    // [39] plot::ix#0 = plot::x#2 >> 1 -- vbuyy=vbuz1_ror_1 
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
    // [40] plot::iy#0 = plot::y#2 >> 1 -- vbuaa=vbuxx_ror_1 
    // We "shiften" de x waarde met 1 stapje naar rechts (dit is binair gelijk aan delen door 2)!
    txa
    lsr
    // (unsigned int)iy * 80
    // [41] plot::$12 = (unsigned int)plot::iy#0 -- vwuz1=_word_vbuaa 
    sta.z __12
    lda #0
    sta.z __12+1
    // [42] plot::$17 = plot::$12 << 2 -- vwuz1=vwuz2_rol_2 
    lda.z __12
    asl
    sta.z __17
    lda.z __12+1
    rol
    sta.z __17+1
    asl.z __17
    rol.z __17+1
    // [43] plot::$18 = plot::$17 + plot::$12 -- vwuz1=vwuz2_plus_vwuz1 
    clc
    lda.z __18
    adc.z __17
    sta.z __18
    lda.z __18+1
    adc.z __17+1
    sta.z __18+1
    // [44] plot::$2 = plot::$18 << 4 -- vwuz1=vwuz1_rol_4 
    asl.z __2
    rol.z __2+1
    asl.z __2
    rol.z __2+1
    asl.z __2
    rol.z __2+1
    asl.z __2
    rol.z __2+1
    // unsigned int i = (unsigned int)iy * 80 + ix
    // [45] plot::i#0 = plot::$2 + plot::ix#0 -- vwuz1=vwuz1_plus_vbuyy 
    // We berekenen de index in de lijst van de bitmap die moet "geupdate" worden.
    tya
    clc
    adc.z i
    sta.z i
    bcc !+
    inc.z i+1
  !:
    // char bm = bitmap[i]
    // [46] plot::$15 = bitmap + plot::i#0 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z i
    clc
    adc #<bitmap
    sta.z __15
    lda.z i+1
    adc #>bitmap
    sta.z __15+1
    // [47] plot::bm#0 = *plot::$15 -- vbuz1=_deref_pbuz2 
    // We lezen de 8-bit waarde van de bitmap en houden het bij in een tijdelijke bm (=bitmap) variabele.
    ldy #0
    lda (__15),y
    sta.z bm
    // char bx = (x % 2)
    // [48] plot::bx#0 = plot::x#2 & 2-1 -- vbuz1=vbuz1_band_vbuc1 
    // De % operator neemt de "modulus" van de x en y waarde en stockeren dit in de bx en by variablen.
    // Dus als x = 159 en dan modulus 2, dan zal het resultaat 1 zijn! Bij x = 140 modulus 2, is het resultaat 0!
    // Idem voor y!
    lda #2-1
    and.z bx
    sta.z bx
    // y % 2
    // [49] plot::$5 = plot::y#2 & 2-1 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #2-1
    // char by = (y % 2) * 2
    // [50] plot::by#0 = plot::$5 << 1 -- vbuaa=vbuaa_rol_1 
    // Let op! Deze sequentie zal de resulterende modulus waar eerst vermenigvuldigen met 2, want het *-tje zal een vermenigvuldiging toepassen!
    asl
    // by + bx
    // [51] plot::$7 = plot::by#0 + plot::bx#0 -- vbuaa=vbuaa_plus_vbuz1 
    clc
    adc.z bx
    // char sh = (by + bx) ^ 3
    // [52] plot::sh#0 = plot::$7 ^ 3 -- vbuaa=vbuaa_bxor_vbuc1 
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
    // [53] if(0==plot::sh#0) goto plot::@1 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b4
    // plot::@4
    // b = 1 << sh
    // [54] plot::b#1 = 1 << plot::sh#0 -- vbuxx=vbuc1_rol_vbuaa 
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
    // [55] phi from plot::@4 to plot::@1 [phi:plot::@4->plot::@1]
    // [55] phi plot::b#2 = plot::b#1 [phi:plot::@4->plot::@1#0] -- register_copy 
    jmp __b1
    // [55] phi from plot to plot::@1 [phi:plot->plot::@1]
  __b4:
    // [55] phi plot::b#2 = 1 [phi:plot->plot::@1#0] -- vbuxx=vbuc1 
    ldx #1
    // plot::@1
  __b1:
    // if (c)
    // [56] if(0!=plot::c#2) goto plot::@2 -- 0_neq_vbuz1_then_la1 
    // Als laatste bekijken we exact wat er moet gebeuren met de "kleur".
    // Onthou! Een 0 verwijdert een blokje en een 1 tekent een blokje.
    // if (c) zal bekijken of c niet nul is, of anders gezegt, een waarde bevat.
    // Indien c niet 0 is, dan zal er een OR operatie plaatvinden met b!
    // Indien c 0 is, dan zal er een AND operatie plaatvinden met de inverse van b!
    lda.z c
    bne __b2
    // plot::@5
    // ~b
    // [57] plot::$11 = ~ plot::b#2 -- vbuaa=_bnot_vbuxx 
    txa
    eor #$ff
    // bm &= ~b
    // [58] plot::bm#2 = plot::bm#0 & plot::$11 -- vbuxx=vbuz1_band_vbuaa 
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
    // [59] phi from plot::@2 plot::@5 to plot::@3 [phi:plot::@2/plot::@5->plot::@3]
    // [59] phi plot::bm#5 = plot::bm#1 [phi:plot::@2/plot::@5->plot::@3#0] -- register_copy 
    // plot::@3
  __b3:
    // bitmap[i] = bm
    // [60] plot::$16 = bitmap + plot::i#0 -- pbuz1=pbuc1_plus_vwuz1 
    lda.z __16
    clc
    adc #<bitmap
    sta.z __16
    lda.z __16+1
    adc #>bitmap
    sta.z __16+1
    // [61] *plot::$16 = plot::bm#5 -- _deref_pbuz1=vbuxx 
    // En als laatste wijzen we nu de bijgewerkte bitmap toe aan de vorige bitmap index positie!
    // In andere woorden, we overschrijven de vorige waarde met de nieuwe berekende waarde.
    txa
    ldy #0
    sta (__16),y
    // plot::@return
    // }
    // [62] return 
    rts
    // plot::@2
  __b2:
    // bm |= b
    // [63] plot::bm#1 = plot::bm#0 | plot::b#2 -- vbuxx=vbuz1_bor_vbuxx 
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
    // [65] phi from paint to paint::@1 [phi:paint->paint::@1]
    // [65] phi paint::x#2 = 0 [phi:paint->paint::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // paint::@1
  __b1:
    // for (char x = 0; x < 80; x++)
    // [66] if(paint::x#2<$50) goto paint::@2 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$50
    bcc __b2
    // paint::@return
    // }
    // [67] return 
    rts
    // paint::@2
  __b2:
    // *(screen + 80 * 0 + x) = block[bitmap[80 * 0 + x]]
    // [68] screen[paint::x#2] = block[bitmap[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap,x
    lda block,y
    sta screen,x
    // *(screen + 80 * 1 + x) = block[bitmap[80 * 1 + x]]
    // [69] (screen+$50*1)[paint::x#2] = block[(bitmap+$50*1)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*1,x
    lda block,y
    sta screen+$50*1,x
    // *(screen + 80 * 2 + x) = block[bitmap[80 * 2 + x]]
    // [70] (screen+$50*2)[paint::x#2] = block[(bitmap+$50*2)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*2,x
    lda block,y
    sta screen+$50*2,x
    // *(screen + 80 * 3 + x) = block[bitmap[80 * 3 + x]]
    // [71] (screen+$50*3)[paint::x#2] = block[(bitmap+$50*3)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*3,x
    lda block,y
    sta screen+$50*3,x
    // *(screen + 80 * 4 + x) = block[bitmap[80 * 4 + x]]
    // [72] (screen+(unsigned int)$50*4)[paint::x#2] = block[(bitmap+(unsigned int)$50*4)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*4,x
    lda block,y
    sta screen+$50*4,x
    // *(screen + 80 * 5 + x) = block[bitmap[80 * 5 + x]]
    // [73] (screen+(unsigned int)$50*5)[paint::x#2] = block[(bitmap+(unsigned int)$50*5)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*5,x
    lda block,y
    sta screen+$50*5,x
    // *(screen + 80 * 6 + x) = block[bitmap[80 * 6 + x]]
    // [74] (screen+(unsigned int)$50*6)[paint::x#2] = block[(bitmap+(unsigned int)$50*6)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*6,x
    lda block,y
    sta screen+$50*6,x
    // *(screen + 80 * 7 + x) = block[bitmap[80 * 7 + x]]
    // [75] (screen+(unsigned int)$50*7)[paint::x#2] = block[(bitmap+(unsigned int)$50*7)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*7,x
    lda block,y
    sta screen+$50*7,x
    // *(screen + 80 * 8 + x) = block[bitmap[80 * 8 + x]]
    // [76] (screen+(unsigned int)$50*8)[paint::x#2] = block[(bitmap+(unsigned int)$50*8)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*8,x
    lda block,y
    sta screen+$50*8,x
    // *(screen + 80 * 9 + x) = block[bitmap[80 * 9 + x]]
    // [77] (screen+(unsigned int)$50*9)[paint::x#2] = block[(bitmap+(unsigned int)$50*9)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*9,x
    lda block,y
    sta screen+$50*9,x
    // *(screen + 80 * 10 + x) = block[bitmap[80 * 10 + x]]
    // [78] (screen+(unsigned int)$50*$a)[paint::x#2] = block[(bitmap+(unsigned int)$50*$a)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$a,x
    lda block,y
    sta screen+$50*$a,x
    // *(screen + 80 * 11 + x) = block[bitmap[80 * 11 + x]]
    // [79] (screen+(unsigned int)$50*$b)[paint::x#2] = block[(bitmap+(unsigned int)$50*$b)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$b,x
    lda block,y
    sta screen+$50*$b,x
    // *(screen + 80 * 12 + x) = block[bitmap[80 * 12 + x]]
    // [80] (screen+(unsigned int)$50*$c)[paint::x#2] = block[(bitmap+(unsigned int)$50*$c)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$c,x
    lda block,y
    sta screen+$50*$c,x
    // *(screen + 80 * 13 + x) = block[bitmap[80 * 13 + x]]
    // [81] (screen+(unsigned int)$50*$d)[paint::x#2] = block[(bitmap+(unsigned int)$50*$d)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$d,x
    lda block,y
    sta screen+$50*$d,x
    // *(screen + 80 * 14 + x) = block[bitmap[80 * 14 + x]]
    // [82] (screen+(unsigned int)$50*$e)[paint::x#2] = block[(bitmap+(unsigned int)$50*$e)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$e,x
    lda block,y
    sta screen+$50*$e,x
    // *(screen + 80 * 15 + x) = block[bitmap[80 * 15 + x]]
    // [83] (screen+(unsigned int)$50*$f)[paint::x#2] = block[(bitmap+(unsigned int)$50*$f)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$f,x
    lda block,y
    sta screen+$50*$f,x
    // *(screen + 80 * 16 + x) = block[bitmap[80 * 16 + x]]
    // [84] (screen+(unsigned int)$50*$10)[paint::x#2] = block[(bitmap+(unsigned int)$50*$10)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$10,x
    lda block,y
    sta screen+$50*$10,x
    // *(screen + 80 * 17 + x) = block[bitmap[80 * 17 + x]]
    // [85] (screen+(unsigned int)$50*$11)[paint::x#2] = block[(bitmap+(unsigned int)$50*$11)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$11,x
    lda block,y
    sta screen+$50*$11,x
    // *(screen + 80 * 18 + x) = block[bitmap[80 * 18 + x]]
    // [86] (screen+(unsigned int)$50*$12)[paint::x#2] = block[(bitmap+(unsigned int)$50*$12)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$12,x
    lda block,y
    sta screen+$50*$12,x
    // *(screen + 80 * 19 + x) = block[bitmap[80 * 19 + x]]
    // [87] (screen+(unsigned int)$50*$13)[paint::x#2] = block[(bitmap+(unsigned int)$50*$13)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$13,x
    lda block,y
    sta screen+$50*$13,x
    // *(screen + 80 * 20 + x) = block[bitmap[80 * 20 + x]]
    // [88] (screen+(unsigned int)$50*$14)[paint::x#2] = block[(bitmap+(unsigned int)$50*$14)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$14,x
    lda block,y
    sta screen+$50*$14,x
    // *(screen + 80 * 21 + x) = block[bitmap[80 * 21 + x]]
    // [89] (screen+(unsigned int)$50*$15)[paint::x#2] = block[(bitmap+(unsigned int)$50*$15)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$15,x
    lda block,y
    sta screen+$50*$15,x
    // *(screen + 80 * 22 + x) = block[bitmap[80 * 22 + x]]
    // [90] (screen+(unsigned int)$50*$16)[paint::x#2] = block[(bitmap+(unsigned int)$50*$16)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$16,x
    lda block,y
    sta screen+$50*$16,x
    // *(screen + 80 * 23 + x) = block[bitmap[80 * 23 + x]]
    // [91] (screen+(unsigned int)$50*$17)[paint::x#2] = block[(bitmap+(unsigned int)$50*$17)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$17,x
    lda block,y
    sta screen+$50*$17,x
    // *(screen + 80 * 24 + x) = block[bitmap[80 * 24 + x]]
    // [92] (screen+(unsigned int)$50*$18)[paint::x#2] = block[(bitmap+(unsigned int)$50*$18)[paint::x#2]] -- pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx) 
    ldy bitmap+$50*$18,x
    lda block,y
    sta screen+$50*$18,x
    // for (char x = 0; x < 80; x++)
    // [93] paint::x#1 = ++ paint::x#2 -- vbuxx=_inc_vbuxx 
    inx
    // [65] phi from paint::@2 to paint::@1 [phi:paint::@2->paint::@1]
    // [65] phi paint::x#2 = paint::x#1 [phi:paint::@2->paint::@1#0] -- register_copy 
    jmp __b1
}
  // File Data
.segment Data
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
