/**
 * @file karakters.c
 * @author your name (you@domain.com)
 * @brief Je bent op weg naar je eerste C programma, dat werkt op de PET 8032!
 * Hier leer je hoe de PET de PETSCII karakterset gebruikt.
 * Bekijk de [PETSCII](https://www.pagetable.com/c64ref/charset) karakterset via deze link.
 *
 *
 * Je leert hoe je karakters op het scherm kan toveren om een gewenste x en y as.
 * Je leert ook hoe je een programma kan compileren en uitvoeren in onze ontwikkelingsomgeving.
 *
 * Hier leer je hoe de PET de PETSCII karakterset gebruikt.
 * Bekijk de [PETSCII](https://www.pagetable.com/c64ref/charset) karakterset via deze link. 
 *
 * Hieronder een aantal opdrachten. Je kan deze 1 voor 1 uitvoeren en al lerend proberen.
 * Het geeft niet als je iets verkeerd doet, gewoon proberen en ik ben er om te helpen.
 *
 * 
 * Bekijk OEFENING sectie(s) om dit programma te vervolledigen.
 * 
 * OEFENING 01.1: Teken de 'X' op de 4de rij, 20ste kolom. let op! We tellen vanaf 0!
 *   - *(screen+...) = ...;
 *
 * OEFENING 01.2: Teken de 'Z' op de 24ste rij, 79ste kolom!
 *
 * OEFENING 01.3: Teken het schaakbord karakter in PETSCII in het midden op het scherm!
 *
 * OEFENING 01.4: Probeer wat karakters te tekenen op het scherm :-)
 *   - Gebruik een for() lus
 *      for(char i=32; i<64; i++) {
 *         ...
 *      }
 *
 * @version 0.1
 * @date 2022-12-15
 *
 * @copyright Copyright (c) 2022
 *
 */

#pragma encoding(petscii_mixed)
#pragma var_model(zp)
#pragma target(PET8032)

#include <conio.h>

// Onderstaande is een declaratie van de variabele "screen", dat het adres bevat vanwaar de PET
// zijn scherm, bestaande uit 80 x 25 karakters tekent.
// Met andere woorden, die adres 32768 is het eerste karakter linksboven.
// Het adres van het karakter rechtsboven is 32847, dus per rij van 80 wordt het scherm getekend.
// Je PET handleiding op pagina 302, bevat een goede omschrijving van hoe het scherm wordt getekend, maar in de folder
// van dit programma kan je een bitmap vinden waar dit grafisch is weergegeven, maar let op, voor een scherm van 40x25 karakters.
char* const screen = (char *)32768;

char const screen_width = 80 - 1;   // We tellen vanaf 0, dus 80 kolommen eindigt op 79.
char const screen_height = 25 - 1;  // We tellen vanaf 0, dus 25 lijnen eindigt op 24.

/**
 * @brief De main functie van je pong game.
 *
 * @return int
 */
int main() {
    clrscr(); // Dit wist het scherm :-)

    *(screen) = 'a';

    *(screen + 10) = 'b';

    *(screen + screen_width) = 'c';

    *(screen + screen_width + 1) = 65 + 3;

    *(screen + screen_width*2 + 1) = 65 + 4;

    // OPLOSSING 01.1:
    // *(screen+...) = ...;

    // OPLOSSING 01.2:

    // OPLOSSING 01.3:

    // OPLOSSING 01.4:



    return 1;
}