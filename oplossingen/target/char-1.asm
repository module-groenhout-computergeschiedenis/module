  // File Comments
/**
 * @file char-1.c
 * @author your name (you@domain.com)
 * @brief Je bent op weg naar je eerste C programma, dat werkt op de PET 8032!
 * Hier leer je hoe de PET de PETSCII karaketerset gebruikte.
 * Je leert hoe je karaketer op het scherm kan toveren om een gewenste x en y as.
 * Je leert ook hoe je een programma kan compileren en uitvoeren in onze ontwikkelingsomgeving.
 * @version 0.1
 * @date 2022-12-15
 *
 * @copyright Copyright (c) 2022
 *
 */
  // Upstart
  // Commodore PET 8032 PRG executable file
.file [name="char-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0401]
.segmentdef Code [start=$40d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  // Global Constants & labels
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $8000
  // Onderstaande is een declaratie van de variabele "screen", dat het adres bevat vanwaar de PET
  // zijn scherm, bestaande uit 80 x 25 karakters tekent.
  // Met andere woorden, die adres 32768 is het eerste karakter linksboven.
  // Het adres van het karakter rechtsboven is 32847, dus per rij van 80 wordt het scherm getekend.
  // Je PET handleiding op pagina 302, bevat een goede omschrijving van hoe het scherm wordt getekend, maar in de folder
  // van dit programma kan je een bitmap vinden waar dit grafisch is weergegeven, maar let op, voor een scherm van 40x25 karakters.
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
    // [7] phi from main to clrscr [phi:main->clrscr]
    jsr clrscr
    // main::@1
    // *(screen) = 'a'
    // [2] *screen = 'a'pm -- _deref_pbuc1=vbuc2 
    // Dit wist het scherm :-)
  .encoding "petscii_mixed"
    lda #'a'
    sta screen
    // *(screen+10) = 'b'
    // [3] *(screen+$a) = 'b'pm -- _deref_pbuc1=vbuc2 
    lda #'b'
    sta screen+$a
    // *(screen+79) = 'c'
    // [4] *(screen+$4f) = 'c'pm -- _deref_pbuc1=vbuc2 
    lda #'c'
    sta screen+$4f
    // *(screen+80) = 65+3
    // [5] *(screen+$50) = $41+3 -- _deref_pbuc1=vbuc2 
    lda #$41+3
    sta screen+$50
    // main::@return
    // }
    // [6] return 
    rts
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label c = 2
    .label line_text = 3
    .label l = 5
    // [8] phi from clrscr to clrscr::@1 [phi:clrscr->clrscr::@1]
    // [8] phi clrscr::line_text#5 = DEFAULT_SCREEN [phi:clrscr->clrscr::@1#0] -- pbuz1=pbuc1 
    lda #<DEFAULT_SCREEN
    sta.z line_text
    lda #>DEFAULT_SCREEN
    sta.z line_text+1
    // [8] phi clrscr::l#2 = 0 [phi:clrscr->clrscr::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z l
    // clrscr::@1
  __b1:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [9] if(clrscr::l#2<$19) goto clrscr::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z l
    cmp #$19
    bcc __b4
    // clrscr::@return
    // }
    // [10] return 
    rts
    // [11] phi from clrscr::@1 to clrscr::@2 [phi:clrscr::@1->clrscr::@2]
  __b4:
    // [11] phi clrscr::c#2 = 0 [phi:clrscr::@1->clrscr::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // clrscr::@2
  __b2:
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [12] if(clrscr::c#2<$50) goto clrscr::@3 -- vbuz1_lt_vbuc1_then_la1 
    lda.z c
    cmp #$50
    bcc __b3
    // clrscr::@4
    // line_text += CONIO_WIDTH
    // [13] clrscr::line_text#1 = clrscr::line_text#5 + $50 -- pbuz1=pbuz1_plus_vbuc1 
    lda #$50
    clc
    adc.z line_text
    sta.z line_text
    bcc !+
    inc.z line_text+1
  !:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [14] clrscr::l#1 = ++ clrscr::l#2 -- vbuz1=_inc_vbuz1 
    inc.z l
    // [8] phi from clrscr::@4 to clrscr::@1 [phi:clrscr::@4->clrscr::@1]
    // [8] phi clrscr::line_text#5 = clrscr::line_text#1 [phi:clrscr::@4->clrscr::@1#0] -- register_copy 
    // [8] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@4->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@3
  __b3:
    // line_text[c] = ' '
    // [15] clrscr::line_text#5[clrscr::c#2] = ' 'pm -- pbuz1_derefidx_vbuz2=vbuc1 
    lda #' '
    ldy.z c
    sta (line_text),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [16] clrscr::c#1 = ++ clrscr::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [11] phi from clrscr::@3 to clrscr::@2 [phi:clrscr::@3->clrscr::@2]
    // [11] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@3->clrscr::@2#0] -- register_copy 
    jmp __b2
}
  // File Data