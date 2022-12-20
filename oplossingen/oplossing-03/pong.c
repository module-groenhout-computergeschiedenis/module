/**
 * @file pong.c
 * @author your name (you@domain.com)
 * @brief Dit is je eerste C programma, dat werkt op de PET 8032!
 *
 * Hier leer je dat de PET geen grafische modus had, en enkel kon tekenen met karakters.
 * We kunnen echter tekenen met de PETSCII karakters.
 * Er zijn in de PETSCII karakterset combinaties van karakters bestaande uit vier blokjes
 * in een quadrant. Dus door het juiste karakter te kiezen kan je een tekening maken met
 * blokjes bestaande uit 4x4 pixels.
 * Bekijk de [PETSCII](https://www.pagetable.com/c64ref/charset) karakterset via deze link.
 *
 * 
 * Bekijk OEFENING sectie(s) om dit programma te vervolledigen.
 *
 * OEFENING 03.1: Teken alle petscii karaketers die vierkante blokjes bevatten van 4x4 groot.
 *   - Hoeveel zijn er intotal?
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
char *const screen = (char *)0x8000;


/**
 * @brief De main functie van je pong game.
 *
 * @return int
 */
int main() {
    clrscr(); // Dit wist het scherm :-)

    // OPLOSSING 03.1:
    *(screen+00) = 16 * 6 + 12;  // 0b0001 = blokje rechts onder
    *(screen+02) = 16 * 2 + 0;   // 0b0000 = geen enkel blokje
    *(screen+04) = 16 * 6 + 12;  // 0b0001 = blokje rechts onder
    *(screen+06) = 16 * 7 + 11;  // 0b0010 = blokje links onder
    *(screen+08) = 16 * 6 + 2;   // 0b0011 = blokje rechts en links onder
    *(screen+10) = 16 * 7 + 12;  // 0b0100 = blokje rechts boven
    *(screen+12) = 16 * 14 + 1;  // 0b0101 = blokje rechts boven en rechts onder
    *(screen+14) = 16 * 15 + 15; // 0b0110 = blokje rechts boven en links onder
    *(screen+16) = 16 * 15 + 14; // 0b0111 = blokje rechts boven en links en rechts onder
    *(screen+18) = 16 * 7 + 14;  // 0b1000 = blokje links boven
    *(screen+20) = 16 * 7 + 15;  // 0b1001 = blokje links boven en rechts onder
    *(screen+22) = 16 * 6 + 1;   // 0b1010 = blokje links boven en links onder
    *(screen+24) = 16 * 15 + 12; // 0b1011 = blokje links boven en links en rechts onder
    *(screen+26) = 16 * 14 + 2;  // 0b1100 = blokje links en rechts boven
    *(screen+28) = 16 * 15 + 11; // 0b1101 = blokje links en rechts boven en rechts onder
    *(screen+30) = 16 * 14 + 12; // 0b1110 = blokje links en rechts boven en links onder
    *(screen+32) = 16 * 10 + 0;  // 0b1111 = overal blokjes!

    return 1;
}