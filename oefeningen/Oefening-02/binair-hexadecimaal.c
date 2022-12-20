/**
 * @file binair-hexadecimaal.c
 * @author your name (you@domain.com)
 * @brief Je bent op weg naar je eerste C programma, dat werkt op de PET 8032!
 * Hier leer je hoe de printf functie gebruikt in C (de basis).
 *
 * Je leert wat binaire, octale en hexadecimale talstelsels zijn,
 * en waarom ze belangrijk zijn in de computerwereld. We zullen dit toelichten in de klas.
 * Je leert ook hoe je zelf functies can maken in je eigen programma in de C-taal.
 * We bekijken samen hoe een C programma in machinetaal is uitgedrukt.
 * We leren de basis instructieset van de 6502 processor.
 *
 * Bekijk OEFENING sectie(s) om dit programma te vervolledigen.
 *
 * OEFENING 02.1: probeer wat de binaire waarden zijn van decimale getallen naar jouw keuze.
 *
 * OEFENING 02.2: toon de binaire en hexadecimale representatie van decimale getallen van 0 tem 15.
 *   - Doe dit in een lus...
 *       for(char n=0; ...) {
 *         ...
 *       }
 *
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
#include <sprintf.h>

// Nu is het adres van de variabele screen uitgedrukt in het hexadecimale talstel: 0x8000!
// Het hexadecimale talstelsel is net zoals in decimale talstelsel, maar heeft 16 cijfers in plaats van 10 cijfers!
// Waarom? Dit werkt erg handig met computers, omdat computers binair werken in veelvouden van 2, 4, 8, 16, 32 of 64!
// We schrijven aan het begin van hexadecimale getallen (in de C taal) een "0x", om verwarring met gewone decimale getallen te vermijden.
// Het hexadecimale getal 0x8000 komt overeen in het decimale talstelsel met 32768 ...
// Echter, hexadecimale getallen hebben 16 cijfers, dus de cijfers 0 tot 9 zijn net zoals in het decimale talstelsel,
// maar na de 9 komen de cijfers A, B, C, D, E en F, die respectievelijk in het decimaal de waarden 11, 12, 13, 14, 15 en 16 hebben!
// Dus het voordeel van hexadecimaal is dat je erg compact getallen kan noteren die een veelvoud zijn van 16!
char *const screen = (char *)0x8000;

static char *hexadecimal(unsigned int number) {
    static char hex[7];
    sprintf(hex, "0x%04x", number);
    return hex;
}

static char *binary(unsigned int number) {
    static char bin[19] = "0b";
    for (char b = 17; b >= 2; b--) {
        if (number & 0b1) {
            *(bin + b) = '1';
        } else {
            *(bin + b) = '0';
        }
        number >>= 1;
    }
    *(bin + 18) = '\0';
    return bin;
}

/**
 * @brief De main functie van je pong game.
 *
 * @return int
 */
int main() {
    clrscr(); // Dit wist het scherm :-)

    unsigned int number = 345;

    printf("%u = %s, %s\n", number, binary(number), hexadecimal(number));

    // OPLOSSING 02.1:
    // ...

    return 1;
}