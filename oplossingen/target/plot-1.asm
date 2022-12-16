  // File Comments
/**
 * @file plot-1.c
 * @author your name (you@domain.com)
 * @brief Je bent op weg naar je eerste C programma, dat werkt op de PET 8032!
 * Het is een eerste stap naar je werkende pong game!
 * Hier leer je dat de PET geen grafische modus had, en enkel kon tekenen met karakters.
 * We kunnen echter tekenen met de PETSCII karakters.
 * Er zijn in de PETSCII karaketerset combinaties van karakters bestaande uit vier blokjes
 * in een quadrant. Dus door het juiste karakter te kiezen kan je een tekening maken met
 * blokjes bestaande uit 4x4 pixels.
 * @version 0.1
 * @date 2022-12-15
 *
 * @copyright Copyright (c) 2022
 *
 */
  // Upstart
  // Commodore PET 8032 PRG executable file
.file [name="plot-1.prg", type="prg", segments="Program"]
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
 * @brief De main functie van je pong game.
 *
 * @return int
 */
main: {
    // clrscr()
    // [1] call clrscr
    // [25] phi from main to clrscr [phi:main->clrscr]
    jsr clrscr
    // [2] phi from main to main::@1 [phi:main->main::@1]
    // main::@1
    // plot(10, 10, 1)
    // [3] call plot
  // Dit wist het scherm :-)
    // [35] phi from main::@1 to plot [phi:main::@1->plot]
    // [35] phi plot::y#10 = $a [phi:main::@1->plot#0] -- vbuz1=vbuc1 
    lda #$a
    sta.z plot.y
    // [35] phi plot::x#10 = $a [phi:main::@1->plot#1] -- vbuz1=vbuc1 
    sta.z plot.x
    jsr plot
    // [4] phi from main::@1 to main::@2 [phi:main::@1->main::@2]
    // main::@2
    // plot(14, 10, 1)
    // [5] call plot
    // [35] phi from main::@2 to plot [phi:main::@2->plot]
    // [35] phi plot::y#10 = $a [phi:main::@2->plot#0] -- vbuz1=vbuc1 
    lda #$a
    sta.z plot.y
    // [35] phi plot::x#10 = $e [phi:main::@2->plot#1] -- vbuz1=vbuc1 
    lda #$e
    sta.z plot.x
    jsr plot
    // [6] phi from main::@2 to main::@3 [phi:main::@2->main::@3]
    // main::@3
    // plot(13, 11, 1)
    // [7] call plot
    // [35] phi from main::@3 to plot [phi:main::@3->plot]
    // [35] phi plot::y#10 = $b [phi:main::@3->plot#0] -- vbuz1=vbuc1 
    lda #$b
    sta.z plot.y
    // [35] phi plot::x#10 = $d [phi:main::@3->plot#1] -- vbuz1=vbuc1 
    lda #$d
    sta.z plot.x
    jsr plot
    // [8] phi from main::@3 to main::@4 [phi:main::@3->main::@4]
    // main::@4
    // plot(14, 11, 1)
    // [9] call plot
    // [35] phi from main::@4 to plot [phi:main::@4->plot]
    // [35] phi plot::y#10 = $b [phi:main::@4->plot#0] -- vbuz1=vbuc1 
    lda #$b
    sta.z plot.y
    // [35] phi plot::x#10 = $e [phi:main::@4->plot#1] -- vbuz1=vbuc1 
    lda #$e
    sta.z plot.x
    jsr plot
    // [10] phi from main::@4 to main::@5 [phi:main::@4->main::@5]
    // main::@5
    // plot(17, 10, 1)
    // [11] call plot
    // [35] phi from main::@5 to plot [phi:main::@5->plot]
    // [35] phi plot::y#10 = $a [phi:main::@5->plot#0] -- vbuz1=vbuc1 
    lda #$a
    sta.z plot.y
    // [35] phi plot::x#10 = $11 [phi:main::@5->plot#1] -- vbuz1=vbuc1 
    lda #$11
    sta.z plot.x
    jsr plot
    // [12] phi from main::@5 to main::@6 [phi:main::@5->main::@6]
    // main::@6
    // plot(16, 11, 1)
    // [13] call plot
    // [35] phi from main::@6 to plot [phi:main::@6->plot]
    // [35] phi plot::y#10 = $b [phi:main::@6->plot#0] -- vbuz1=vbuc1 
    lda #$b
    sta.z plot.y
    // [35] phi plot::x#10 = $10 [phi:main::@6->plot#1] -- vbuz1=vbuc1 
    lda #$10
    sta.z plot.x
    jsr plot
    // [14] phi from main::@6 to main::@7 [phi:main::@6->main::@7]
    // main::@7
    // plot(17, 11, 1)
    // [15] call plot
    // [35] phi from main::@7 to plot [phi:main::@7->plot]
    // [35] phi plot::y#10 = $b [phi:main::@7->plot#0] -- vbuz1=vbuc1 
    lda #$b
    sta.z plot.y
    // [35] phi plot::x#10 = $11 [phi:main::@7->plot#1] -- vbuz1=vbuc1 
    lda #$11
    sta.z plot.x
    jsr plot
    // [16] phi from main::@7 to main::@8 [phi:main::@7->main::@8]
    // main::@8
    // plot(159, 48, 1)
    // [17] call plot
    // [35] phi from main::@8 to plot [phi:main::@8->plot]
    // [35] phi plot::y#10 = $30 [phi:main::@8->plot#0] -- vbuz1=vbuc1 
    lda #$30
    sta.z plot.y
    // [35] phi plot::x#10 = $9f [phi:main::@8->plot#1] -- vbuz1=vbuc1 
    lda #$9f
    sta.z plot.x
    jsr plot
    // [18] phi from main::@8 to main::@9 [phi:main::@8->main::@9]
    // main::@9
    // plot(158, 49, 1)
    // [19] call plot
    // [35] phi from main::@9 to plot [phi:main::@9->plot]
    // [35] phi plot::y#10 = $31 [phi:main::@9->plot#0] -- vbuz1=vbuc1 
    lda #$31
    sta.z plot.y
    // [35] phi plot::x#10 = $9e [phi:main::@9->plot#1] -- vbuz1=vbuc1 
    lda #$9e
    sta.z plot.x
    jsr plot
    // [20] phi from main::@9 to main::@10 [phi:main::@9->main::@10]
    // main::@10
    // plot(159, 49, 1)
    // [21] call plot
    // [35] phi from main::@10 to plot [phi:main::@10->plot]
    // [35] phi plot::y#10 = $31 [phi:main::@10->plot#0] -- vbuz1=vbuc1 
    lda #$31
    sta.z plot.y
    // [35] phi plot::x#10 = $9f [phi:main::@10->plot#1] -- vbuz1=vbuc1 
    lda #$9f
    sta.z plot.x
    jsr plot
    // [22] phi from main::@10 to main::@11 [phi:main::@10->main::@11]
    // main::@11
    // paint()
    // [23] call paint
  // En deze draw functie tekent het volledige scherm door de bitmap te tekenen op alle karaketers om het scherm!
    // [57] phi from main::@11 to paint [phi:main::@11->paint]
    jsr paint
    // main::@return
    // }
    // [24] return 
    rts
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label c = 2
    .label line_text = 4
    .label l = 6
    // [26] phi from clrscr to clrscr::@1 [phi:clrscr->clrscr::@1]
    // [26] phi clrscr::line_text#5 = DEFAULT_SCREEN [phi:clrscr->clrscr::@1#0] -- pbuz1=pbuc1 
    lda #<DEFAULT_SCREEN
    sta.z line_text
    lda #>DEFAULT_SCREEN
    sta.z line_text+1
    // [26] phi clrscr::l#2 = 0 [phi:clrscr->clrscr::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z l
    // clrscr::@1
  __b1:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [27] if(clrscr::l#2<$19) goto clrscr::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z l
    cmp #$19
    bcc __b4
    // clrscr::@return
    // }
    // [28] return 
    rts
    // [29] phi from clrscr::@1 to clrscr::@2 [phi:clrscr::@1->clrscr::@2]
  __b4:
    // [29] phi clrscr::c#2 = 0 [phi:clrscr::@1->clrscr::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // clrscr::@2
  __b2:
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [30] if(clrscr::c#2<$50) goto clrscr::@3 -- vbuz1_lt_vbuc1_then_la1 
    lda.z c
    cmp #$50
    bcc __b3
    // clrscr::@4
    // line_text += CONIO_WIDTH
    // [31] clrscr::line_text#1 = clrscr::line_text#5 + $50 -- pbuz1=pbuz1_plus_vbuc1 
    lda #$50
    clc
    adc.z line_text
    sta.z line_text
    bcc !+
    inc.z line_text+1
  !:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [32] clrscr::l#1 = ++ clrscr::l#2 -- vbuz1=_inc_vbuz1 
    inc.z l
    // [26] phi from clrscr::@4 to clrscr::@1 [phi:clrscr::@4->clrscr::@1]
    // [26] phi clrscr::line_text#5 = clrscr::line_text#1 [phi:clrscr::@4->clrscr::@1#0] -- register_copy 
    // [26] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@4->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@3
  __b3:
    // line_text[c] = ' '
    // [33] clrscr::line_text#5[clrscr::c#2] = ' 'pm -- pbuz1_derefidx_vbuz2=vbuc1 
  .encoding "petscii_mixed"
    lda #' '
    ldy.z c
    sta (line_text),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [34] clrscr::c#1 = ++ clrscr::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [29] phi from clrscr::@3 to clrscr::@2 [phi:clrscr::@3->clrscr::@2]
    // [29] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@3->clrscr::@2#0] -- register_copy 
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
// void plot(__zp(6) char x, __zp(2) char y, char c)
plot: {
    .label __2 = 4
    .label __5 = 2
    .label __7 = 2
    .label __12 = 4
    .label ix = 3
    .label iy = $b
    .label i = 4
    .label bm = $c
    .label bx = 6
    .label by = 2
    .label sh = 2
    // En nu komt de magic!
    // nu sh de positie van de bit bevat dat moet worden bijgewerkt, hebben we nog niet de exact bitwaarde!
    // We moeten de bit "shiften" naar links met het aantal benodigde posities!
    // We nemen eerst aan dat de bit positie sh = 0. Dus 0001.
    .label b = 2
    .label bm_1 = 2
    .label x = 6
    .label y = 2
    .label __15 = 9
    .label __16 = 4
    .label __17 = 7
    .label __18 = 4
    // char ix = x >> 1
    // [36] plot::ix#0 = plot::x#10 >> 1 -- vbuz1=vbuz2_ror_1 
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
    // [37] plot::iy#0 = plot::y#10 >> 1 -- vbuz1=vbuz2_ror_1 
    // We "shiften" de x waarde met 1 stapje naar rechts (dit is binair gelijk aan delen door 2)!
    lda.z y
    lsr
    sta.z iy
    // (unsigned int)iy * 80
    // [38] plot::$12 = (unsigned int)plot::iy#0 -- vwuz1=_word_vbuz2 
    sta.z __12
    lda #0
    sta.z __12+1
    // [39] plot::$17 = plot::$12 << 2 -- vwuz1=vwuz2_rol_2 
    lda.z __12
    asl
    sta.z __17
    lda.z __12+1
    rol
    sta.z __17+1
    asl.z __17
    rol.z __17+1
    // [40] plot::$18 = plot::$17 + plot::$12 -- vwuz1=vwuz2_plus_vwuz1 
    clc
    lda.z __18
    adc.z __17
    sta.z __18
    lda.z __18+1
    adc.z __17+1
    sta.z __18+1
    // [41] plot::$2 = plot::$18 << 4 -- vwuz1=vwuz1_rol_4 
    asl.z __2
    rol.z __2+1
    asl.z __2
    rol.z __2+1
    asl.z __2
    rol.z __2+1
    asl.z __2
    rol.z __2+1
    // unsigned int i = (unsigned int)iy * 80 + ix
    // [42] plot::i#0 = plot::$2 + plot::ix#0 -- vwuz1=vwuz1_plus_vbuz2 
    // We berekenen de index in de lijst van de bitmap die moet "geupdate" worden.
    lda.z ix
    clc
    adc.z i
    sta.z i
    bcc !+
    inc.z i+1
  !:
    // char bm = bitmap[i]
    // [43] plot::$15 = bitmap + plot::i#0 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z i
    clc
    adc #<bitmap
    sta.z __15
    lda.z i+1
    adc #>bitmap
    sta.z __15+1
    // [44] plot::bm#0 = *plot::$15 -- vbuz1=_deref_pbuz2 
    // We lezen de 8-bit waarde van de bitmap en houden het bij in een tijdelijke bm (=bitmap) variabele.
    ldy #0
    lda (__15),y
    sta.z bm
    // char bx = (x % 2)
    // [45] plot::bx#0 = plot::x#10 & 2-1 -- vbuz1=vbuz1_band_vbuc1 
    // De % operator neemt de "modulus" van de x en y waarde en stockeren dit in de bx en by variablen.
    // Dus als x = 159 en dan modulus 2, dan zal het resultaat 1 zijn! Bij x = 140 modulus 2, is het resultaat 0!
    // Idem voor y!
    lda #2-1
    and.z bx
    sta.z bx
    // y % 2
    // [46] plot::$5 = plot::y#10 & 2-1 -- vbuz1=vbuz1_band_vbuc1 
    lda #2-1
    and.z __5
    sta.z __5
    // char by = (y % 2) * 2
    // [47] plot::by#0 = plot::$5 << 1 -- vbuz1=vbuz1_rol_1 
    // Let op! Deze sequentie zal de resulterende modulus waar eerst vermenigvuldigen met 2, want het *-tje zal een vermenigvuldiging toepassen!
    asl.z by
    // by + bx
    // [48] plot::$7 = plot::by#0 + plot::bx#0 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z __7
    clc
    adc.z bx
    sta.z __7
    // char sh = (by + bx) ^ 3
    // [49] plot::sh#0 = plot::$7 ^ 3 -- vbuz1=vbuz1_bxor_vbuc1 
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
    // [50] if(0==plot::sh#0) goto plot::@1 -- 0_eq_vbuz1_then_la1 
    beq __b1
    // plot::@4
    // b = 1 << sh
    // [51] plot::b#1 = 1 << plot::sh#0 -- vbuz1=vbuc1_rol_vbuz1 
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
    // [52] phi from plot::@4 to plot::@1 [phi:plot::@4->plot::@1]
    // [52] phi plot::b#2 = plot::b#1 [phi:plot::@4->plot::@1#0] -- register_copy 
    jmp __b2
    // [52] phi from plot to plot::@1 [phi:plot->plot::@1]
  __b1:
    // [52] phi plot::b#2 = 1 [phi:plot->plot::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z b
    // plot::@1
    // plot::@2
  __b2:
    // bm |= b
    // [53] plot::bm#1 = plot::bm#0 | plot::b#2 -- vbuz1=vbuz2_bor_vbuz1 
    // De |= operator berekent een OR operatie met bm en b. We lichten wat OR is nader toe in de klas.
    // Als geheugensteuntje voor de | of de OR operator ... 1 = 1 | 1 ... 1 = 1 | 0 ... 1 = 0 | 1 ... 0 = 0 | 0 ...
    // Als voorbeeld, stel bm = 1010 en b = 0001 ...
    // ... De operatie voluit geschreven wordt: bm = bm | b;
    // ... bm = 1010 | 0001 ...
    // ... bm = 1011
    // Wat leren we hieruit? Dat we bit 0 van de bitmap hebben aangezet, bm = 1011 als resultaat, waar de laatste waarde nu 1 is!
    lda.z bm_1
    ora.z bm
    sta.z bm_1
    // plot::@3
    // bitmap[i] = bm
    // [54] plot::$16 = bitmap + plot::i#0 -- pbuz1=pbuc1_plus_vwuz1 
    lda.z __16
    clc
    adc #<bitmap
    sta.z __16
    lda.z __16+1
    adc #>bitmap
    sta.z __16+1
    // [55] *plot::$16 = plot::bm#1 -- _deref_pbuz1=vbuz2 
    // En als laatste wijzen we nu de bijgewerkte bitmap toe aan de vorige bitmap index positie!
    // In andere woorden, we overschrijven de vorige waarde met de nieuwe berekende waarde.
    lda.z bm_1
    ldy #0
    sta (__16),y
    // plot::@return
    // }
    // [56] return 
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
    .label x = 3
    // [58] phi from paint to paint::@1 [phi:paint->paint::@1]
    // [58] phi paint::x#2 = 0 [phi:paint->paint::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z x
    // paint::@1
  __b1:
    // for (char x = 0; x < 80; x++)
    // [59] if(paint::x#2<$50) goto paint::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z x
    cmp #$50
    bcc __b2
    // paint::@return
    // }
    // [60] return 
    rts
    // paint::@2
  __b2:
    // *(screen + 80 * 0 + x) = block[bitmap[80 * 0 + x]]
    // [61] screen[paint::x#2] = block[bitmap[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldx.z x
    ldy bitmap,x
    lda block,y
    sta screen,x
    // *(screen + 80 * 1 + x) = block[bitmap[80 * 1 + x]]
    // [62] (screen+$50*1)[paint::x#2] = block[(bitmap+$50*1)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*1,x
    lda block,y
    sta screen+$50*1,x
    // *(screen + 80 * 2 + x) = block[bitmap[80 * 2 + x]]
    // [63] (screen+$50*2)[paint::x#2] = block[(bitmap+$50*2)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*2,x
    lda block,y
    sta screen+$50*2,x
    // *(screen + 80 * 3 + x) = block[bitmap[80 * 3 + x]]
    // [64] (screen+$50*3)[paint::x#2] = block[(bitmap+$50*3)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*3,x
    lda block,y
    sta screen+$50*3,x
    // *(screen + 80 * 4 + x) = block[bitmap[80 * 4 + x]]
    // [65] (screen+(unsigned int)$50*4)[paint::x#2] = block[(bitmap+(unsigned int)$50*4)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*4,x
    lda block,y
    sta screen+$50*4,x
    // *(screen + 80 * 5 + x) = block[bitmap[80 * 5 + x]]
    // [66] (screen+(unsigned int)$50*5)[paint::x#2] = block[(bitmap+(unsigned int)$50*5)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*5,x
    lda block,y
    sta screen+$50*5,x
    // *(screen + 80 * 6 + x) = block[bitmap[80 * 6 + x]]
    // [67] (screen+(unsigned int)$50*6)[paint::x#2] = block[(bitmap+(unsigned int)$50*6)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*6,x
    lda block,y
    sta screen+$50*6,x
    // *(screen + 80 * 7 + x) = block[bitmap[80 * 7 + x]]
    // [68] (screen+(unsigned int)$50*7)[paint::x#2] = block[(bitmap+(unsigned int)$50*7)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*7,x
    lda block,y
    sta screen+$50*7,x
    // *(screen + 80 * 8 + x) = block[bitmap[80 * 8 + x]]
    // [69] (screen+(unsigned int)$50*8)[paint::x#2] = block[(bitmap+(unsigned int)$50*8)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*8,x
    lda block,y
    sta screen+$50*8,x
    // *(screen + 80 * 9 + x) = block[bitmap[80 * 9 + x]]
    // [70] (screen+(unsigned int)$50*9)[paint::x#2] = block[(bitmap+(unsigned int)$50*9)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*9,x
    lda block,y
    sta screen+$50*9,x
    // *(screen + 80 * 10 + x) = block[bitmap[80 * 10 + x]]
    // [71] (screen+(unsigned int)$50*$a)[paint::x#2] = block[(bitmap+(unsigned int)$50*$a)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$a,x
    lda block,y
    sta screen+$50*$a,x
    // *(screen + 80 * 11 + x) = block[bitmap[80 * 11 + x]]
    // [72] (screen+(unsigned int)$50*$b)[paint::x#2] = block[(bitmap+(unsigned int)$50*$b)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$b,x
    lda block,y
    sta screen+$50*$b,x
    // *(screen + 80 * 12 + x) = block[bitmap[80 * 12 + x]]
    // [73] (screen+(unsigned int)$50*$c)[paint::x#2] = block[(bitmap+(unsigned int)$50*$c)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$c,x
    lda block,y
    sta screen+$50*$c,x
    // *(screen + 80 * 13 + x) = block[bitmap[80 * 13 + x]]
    // [74] (screen+(unsigned int)$50*$d)[paint::x#2] = block[(bitmap+(unsigned int)$50*$d)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$d,x
    lda block,y
    sta screen+$50*$d,x
    // *(screen + 80 * 14 + x) = block[bitmap[80 * 14 + x]]
    // [75] (screen+(unsigned int)$50*$e)[paint::x#2] = block[(bitmap+(unsigned int)$50*$e)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$e,x
    lda block,y
    sta screen+$50*$e,x
    // *(screen + 80 * 15 + x) = block[bitmap[80 * 15 + x]]
    // [76] (screen+(unsigned int)$50*$f)[paint::x#2] = block[(bitmap+(unsigned int)$50*$f)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$f,x
    lda block,y
    sta screen+$50*$f,x
    // *(screen + 80 * 16 + x) = block[bitmap[80 * 16 + x]]
    // [77] (screen+(unsigned int)$50*$10)[paint::x#2] = block[(bitmap+(unsigned int)$50*$10)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$10,x
    lda block,y
    sta screen+$50*$10,x
    // *(screen + 80 * 17 + x) = block[bitmap[80 * 17 + x]]
    // [78] (screen+(unsigned int)$50*$11)[paint::x#2] = block[(bitmap+(unsigned int)$50*$11)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$11,x
    lda block,y
    sta screen+$50*$11,x
    // *(screen + 80 * 18 + x) = block[bitmap[80 * 18 + x]]
    // [79] (screen+(unsigned int)$50*$12)[paint::x#2] = block[(bitmap+(unsigned int)$50*$12)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$12,x
    lda block,y
    sta screen+$50*$12,x
    // *(screen + 80 * 19 + x) = block[bitmap[80 * 19 + x]]
    // [80] (screen+(unsigned int)$50*$13)[paint::x#2] = block[(bitmap+(unsigned int)$50*$13)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$13,x
    lda block,y
    sta screen+$50*$13,x
    // *(screen + 80 * 20 + x) = block[bitmap[80 * 20 + x]]
    // [81] (screen+(unsigned int)$50*$14)[paint::x#2] = block[(bitmap+(unsigned int)$50*$14)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$14,x
    lda block,y
    sta screen+$50*$14,x
    // *(screen + 80 * 21 + x) = block[bitmap[80 * 21 + x]]
    // [82] (screen+(unsigned int)$50*$15)[paint::x#2] = block[(bitmap+(unsigned int)$50*$15)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$15,x
    lda block,y
    sta screen+$50*$15,x
    // *(screen + 80 * 22 + x) = block[bitmap[80 * 22 + x]]
    // [83] (screen+(unsigned int)$50*$16)[paint::x#2] = block[(bitmap+(unsigned int)$50*$16)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$16,x
    lda block,y
    sta screen+$50*$16,x
    // *(screen + 80 * 23 + x) = block[bitmap[80 * 23 + x]]
    // [84] (screen+(unsigned int)$50*$17)[paint::x#2] = block[(bitmap+(unsigned int)$50*$17)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$17,x
    lda block,y
    sta screen+$50*$17,x
    // *(screen + 80 * 24 + x) = block[bitmap[80 * 24 + x]]
    // [85] (screen+(unsigned int)$50*$18)[paint::x#2] = block[(bitmap+(unsigned int)$50*$18)[paint::x#2]] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1) 
    ldy bitmap+$50*$18,x
    lda block,y
    sta screen+$50*$18,x
    // for (char x = 0; x < 80; x++)
    // [86] paint::x#1 = ++ paint::x#2 -- vbuz1=_inc_vbuz1 
    inc.z x
    // [58] phi from paint::@2 to paint::@1 [phi:paint::@2->paint::@1]
    // [58] phi paint::x#2 = paint::x#1 [phi:paint::@2->paint::@1#0] -- register_copy 
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
