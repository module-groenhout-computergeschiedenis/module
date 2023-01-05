/**
 * @file 08-pong.c
 * @author your name (you@domain.com)
 * @brief Dit is je eerste C programma, dat werkt op de PET 8032!
 *
 * - We doen een beetje extra wiskunde. We introduceren het "fixed point" binair rekenen.
 *   We doen dit omdat we het balletje niet altijd diagonaal 45° willen laten stuiteren,
 *   maar ook in andere richtingscoeficiënten.
 * - We passen we de truuk toe van fixed point binary, analoog naar decimale getallen, waar
 *   de hoogste byte (dus de hoogte 8 bits van de 16 bits) het gehele deel van het getal bevat
 *   en de laagste byte (dus de laagste 8 bits van de 16 bits) het fractionele gedeelte.
 *   Zo kunnen we het balletje allerlei alternatieve richtingen laten uitgaan.
 * - We kunnen hiermee ook de snelheid regelen van het balletje. Hoe kleiner de waarde van het fractionele gedeelte
 *   van de delta waarden, hoe trager het balletje op de as zal voorschrijden.
 *
 *
 * Bekijk OEFENING sectie(s) om dit programma te vervolledigen.
 *
 * OEFENING 08.1: Probeer met wat andere fractionele waarden een andere richtingscoëfficient te kiezen.
 *    - Probeer op de x-as met 0x80 (128).
 *    - Probeer op de y-as met 0x40 (64).
 *    - Zie je hoe de richtingscoëfficient veranderd is, en ook de snelheid?
 *
 *
 * @version 0.1
 * @date 2022-12-20
 *
 * @copyright Copyright (c) 2022
 *
 */

#pragma encoding(petscii_mixed)
#pragma var_model(zp)
#pragma target(PET8032)

#include <conio.h>
#include <kernal.h>


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
char* const screen = (char *)0x8000;
char const screen_width = 80;   // We tellen vanaf 0, dus 80 kolommen eindigt op 79.
char const screen_height = 25;  // We tellen vanaf 0, dus 25 lijnen eindigt op 24.



// De bitmap variabele bevat een lijst van alle karakters die op het scherm moeten worden getekend.
// Het is een "array" van het type char.
// Het is een soort buffer, dan in het interne geheugen wordt bijgewerkt.
char bitmap[screen_width * screen_height] = {0};

// De block variable bevat een beslissingstabel. We gebruiken het om het juste karakter met de blokjes te tekenen om het scherm.
// Zoals je ziet, is de block variabele een array van het type char, van 16 elementen groot!
// De waarden van elk element van block zijn geindexeerd van 0 tem 15, en dus een binair getal van 4 cijfers groot!
// Een weetje, we noemen een 4-bit binair getal een tetrade, dus in een 8-bit getal zitten dus 2 tedrades van elk 4-bit groot.
// Onze bitmap bevat dus een array van 80 * 25 elementen (dus 2000 char elementjes), die elk een karakter voorstellen met 4 blokjes!
// We gebruiken de block array om het juiste karakter te vormen tijdens de paint functie!
// Elk waarde in bitmap is namelijk 4 bits groot, en bevat een indicatie bij elke bit of er een blokje moet getekend worden of niet
// in een quadrant in elk karakter!
// We zullen binair toelichten in de klas, maar zie hier een geheugensteuntje:
//
// Elk binair getal bestaat uit 0-en en 1-en. Elke positie van een cijfer noemen we de orde van het cijfer.
// Een cijfer van 4 bits bestaaat dus uit 4 0-en en/of 1-en. Het laagste cijfer is rechts, en het meest significante cijfer is links.
// Dit is in het decimale talstelsel ook zo: Een 20 is lager dan 200, he!
// Om verwarring met decimale cijfers te vermijden, schrijven we in de C taal een binair cijfer beginnend met "0b" !!!

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
char block[16] = {
    16 * 2 + 0,   // 0b0000 = geen enkel blokje
    16 * 6 + 12,  // 0b0001 = blokje rechts onder
    16 * 7 + 11,  // 0b0010 = blokje links onder
    16 * 6 + 2,   // 0b0011 = blokje rechts en links onder
    16 * 7 + 12,  // 0b0100 = blokje rechts boven
    16 * 14 + 1,  // 0b0101 = blokje rechts boven en rechts onder
    16 * 15 + 15, // 0b0110 = blokje rechts boven en links onder
    16 * 15 + 14, // 0b0111 = blokje rechts boven en links en rechts onder
    16 * 7 + 14,  // 0b1000 = blokje links boven
    16 * 7 + 15,  // 0b1001 = blokje links boven en rechts onder
    16 * 6 + 1,   // 0b1010 = blokje links boven en links onder
    16 * 15 + 12, // 0b1011 = blokje links boven en links en rechts onder
    16 * 14 + 2,  // 0b1100 = blokje links en rechts boven
    16 * 15 + 11, // 0b1101 = blokje links en rechts boven en rechts onder
    16 * 14 + 12, // 0b1110 = blokje links en rechts boven en links onder
    16 * 10 + 0   // 0b1111 = overal blokjes!
};



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
void paint() {

    for (char x = 0; x < screen_width; x++) {
        *(screen + screen_width * 0 + x) = block[bitmap[screen_width * 0 + x]];
        *(screen + screen_width * 1 + x) = block[bitmap[screen_width * 1 + x]];
        *(screen + screen_width * 2 + x) = block[bitmap[screen_width * 2 + x]];
        *(screen + screen_width * 3 + x) = block[bitmap[screen_width * 3 + x]];
        *(screen + screen_width * 4 + x) = block[bitmap[screen_width * 4 + x]];
        *(screen + screen_width * 5 + x) = block[bitmap[screen_width * 5 + x]];
        *(screen + screen_width * 6 + x) = block[bitmap[screen_width * 6 + x]];
        *(screen + screen_width * 7 + x) = block[bitmap[screen_width * 7 + x]];
        *(screen + screen_width * 8 + x) = block[bitmap[screen_width * 8 + x]];
        *(screen + screen_width * 9 + x) = block[bitmap[screen_width * 9 + x]];
        *(screen + screen_width * 10 + x) = block[bitmap[screen_width * 10 + x]];
        *(screen + screen_width * 11 + x) = block[bitmap[screen_width * 11 + x]];
        *(screen + screen_width * 12 + x) = block[bitmap[screen_width * 12 + x]];
        *(screen + screen_width * 13 + x) = block[bitmap[screen_width * 13 + x]];
        *(screen + screen_width * 14 + x) = block[bitmap[screen_width * 14 + x]];
        *(screen + screen_width * 15 + x) = block[bitmap[screen_width * 15 + x]];
        *(screen + screen_width * 16 + x) = block[bitmap[screen_width * 16 + x]];
        *(screen + screen_width * 17 + x) = block[bitmap[screen_width * 17 + x]];
        *(screen + screen_width * 18 + x) = block[bitmap[screen_width * 18 + x]];
        *(screen + screen_width * 19 + x) = block[bitmap[screen_width * 19 + x]];
        *(screen + screen_width * 20 + x) = block[bitmap[screen_width * 20 + x]];
        *(screen + screen_width * 21 + x) = block[bitmap[screen_width * 21 + x]];
        *(screen + screen_width * 22 + x) = block[bitmap[screen_width * 22 + x]];
        *(screen + screen_width * 23 + x) = block[bitmap[screen_width * 23 + x]];
        *(screen + screen_width * 24 + x) = block[bitmap[screen_width * 24 + x]];
    }
}

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
void plot(char x, char y, char c) {
    // OPLOSSING 04.1:
    if (x > screen_width * 2 - 1) {
        x = screen_width * 2 - 1;
    }

    if (y > screen_height * 2 - 1) {
        y = screen_height * 2 - 1;
    }

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

    char ix = x >> 1; // We "shiften" de x waarde met 1 stapje naar rechts (dit is binair gelijk aan delen door 2)!
    char iy = y >> 1; // We "shiften" de y waarde met 1 stapje naar rechts,(dit is binair gelijk aan delen door 2)!

    // We berekenen de index in de lijst van de bitmap die moet "geupdate" worden.
    unsigned int i = (unsigned int)iy * screen_width + ix;

    // We lezen de 8-bit waarde van de bitmap en houden het bij in een tijdelijke bm (=bitmap) variabele.
    char bm = bitmap[i];

    // Hier doen we erg ingewikkelde dingen he!
    // Ik ga jullie dit uitleggen in de klas.
    // We gaan ook bekijken hoe dit in machinetaal wordt geconverveerd!
    // Jullie zullen leren hoe de 6502 hiermee omgaat :-)

    // De % operator neemt de "modulus" van de x en y waarde en stockeren dit in de bx en by variablen.
    // Dus als x = 159 en dan modulus 2, dan zal het resultaat 1 zijn! Bij x = 140 modulus 2, is het resultaat 0!
    // Idem voor y!
    char bx = (x % 2);
    // Let op! Deze sequentie zal de resulterende modulus waar eerst vermenigvuldigen met 2, want het *-tje zal een vermenigvuldiging toepassen!
    char by = (y % 2) * 2;

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
    char sh = (by + bx) ^ 3;

    // En nu komt de magic!
    // nu sh de positie van de bit bevat dat moet worden bijgewerkt, hebben we nog niet de exact bitwaarde!
    // We moeten de bit "shiften" naar links met het aantal benodigde posities!
    // We nemen eerst aan dat de bit positie sh = 0. Dus 0001.
    char b = 1;

    // Echter, als sh groter is dan 0, dan moeten we b (dat 1 bevat), shiften naar links met het aantal keer in de variabele sh.
    // De << operator zal de bit shiften naar links. Kijk goed! We shiften de 1 een aantal keer naar links, aangeduid door de variabele sh.
    // De if ( sh ) bekijkt of sh een waarde bevat, indien "ja", (dus sh is niet 0), dan zal de shift operatie plaatsvinden.
    if (sh) {
        b = 1 << sh;
    }

    // Als laatste bekijken we exact wat er moet gebeuren met de "kleur".
    // Onthou! Een 0 verwijdert een blokje en een 1 tekent een blokje.
    // if (c) zal bekijken of c niet nul is, of anders gezegt, een waarde bevat.
    // Indien c niet 0 is, dan zal er een OR operatie plaatvinden met b!
    // Indien c 0 is, dan zal er een AND operatie plaatvinden met de inverse van b!
    if (c) {
        // De |= operator berekent een OR operatie met bm en b. We lichten wat OR is nader toe in de klas.
        // Als geheugensteuntje voor de | of de OR operator ... 1 = 1 | 1 ... 1 = 1 | 0 ... 1 = 0 | 1 ... 0 = 0 | 0 ...
        // Als voorbeeld, stel bm = 1010 en b = 0001 ...
        // ... De operatie voluit geschreven wordt: bm = bm | b;
        // ... bm = 1010 | 0001 ...
        // ... bm = 1011
        // Wat leren we hieruit? Dat we bit 0 van de bitmap hebben aangezet, bm = 1011 als resultaat, waar de laatste waarde nu 1 is!
        bm |= b;
    } else {
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
        bm &= ~b;
    }

    // En als laatste wijzen we nu de bijgewerkte bitmap toe aan de vorige bitmap index positie!
    // In andere woorden, we overschrijven de vorige waarde met de nieuwe berekende waarde.
    bitmap[i] = bm;
}

/**
 * @brief Draws the wall controlled by the player.
 *
 * @param x
 * @param y
 * @param size
 * @param c
 */
void wall(char x, char y, char size, char c) {
    for (char i = 0; i < size; i++) {
        plot(x, y + i, c);
    }
}

/**
 * @brief De main functie van pong. Dit programma geeft je
 *
 * @return int
 */
int main() {
    clrscr(); // Dit wist het scherm :-)

    // Dit zijn constanten die de linker, rechter, boven en onderkant van het speelveld bepalen.
    const char border_left = 0;
    const char border_right = screen_width *  2 - 1;
    const char border_top = 0;
    const char border_bottom = screen_height * 2 - 1;

    // We tekenen eerst het scherm, de randen op de x-as!
    for (char x = border_left; x <= border_right; x++) {
        plot(x, border_top, 1);
        plot(x, border_bottom, 1);
    }

    // We tekenen eerst het scherm, de randen op de y-as!
    // OPLOSSING 06.1:
    for (char y = border_top; y <= border_bottom; y++) {
        plot(border_left, y, 1);
        plot(border_right, y, 1);
    }

    // We introduceren een fixed point x en y, waarvan de hoogste byte het gehele gedeelte van het getal bevat
    // en de laagste byte het fractionele gedeelte.
    unsigned int fx = 2 * 0x100;
    unsigned int fy = 24 * 0x100;

    // De hoogste byte wijzen we toe aan de x en y variabelen om te plotten.
    unsigned char x = BYTE1(fx);
    unsigned char y = BYTE1(fy);

    // Deze werk variabelen houden de "deltas" bij van de richting van het balletje.
    // Deze zijn nu 16-bit variabelen, maar de zijn "signed". Dit wil zeggen,
    // dat de variabelen ook een negatieve waarde kunnen hebben!
    // De laagste byte van deze variabelen bevatten het fractionele gedeelte.
    // OPLOSSING 08.1:
    signed int dx = 0x80;
    signed int dy = 0x40;

    // We declareren de variabelen die de positie bijhouden van het muurtje (wall).
    // We kunnen dit muurtje omhoog en omlaag schuiven door met de pijl omhoog of omlaag te tikken.
    // Ons programma zal dan de waarden wall_x en wall_y verminderen of vermeerderen.
    // We houden ook een grootte bij in wall_size.
    unsigned char wall_x = 154;
    unsigned char wall_y = 22;
    unsigned char wall_size = 6;

    char *pia1 = (char *)0x026F;

    // Deze variabele ch bevat het karaketer dat wordt gedrukt op het toetsenbord.
    // Het programma wacht niet tot het karaketer gedrukt wordt.
    char ch = getch();

    // Als we een 'x' drukken op het toetsenbord, dan stoppen we met het spelletje.
    while (ch != 'x') {
        // We wissen het muurtje.
        wall(wall_x, wall_y, wall_size, 0);

        char wall_min = border_top + 1;
        char wall_max = border_bottom - wall_size - 1;

        switch (ch) {
        case 0x91:
            if (wall_y > wall_min) {
                wall_y--;
            }
            break;
        case 0x11:
            // OPLOSSING 07.1:
            if (wall_y < wall_max) {
                wall_y++;
            }
            break;
        default:
            break;
        }

        plot(x, y, 0); // Weet je nog, de plot functie? Hier wissen we het blokje in de vorige x en y positie.

        // Nu werken we de x en y positie bij, we tellen de deltas op bij de x en y waarden.
        fx += dx; // Hoe kleiner de waarde van het fractionele gedeelte, hoe trager het balletje zal voortbewegen op de x-as.
        fy += dy; // Hoe kleiner de waarde van het fractionele gedeelte, hoe trager het balletje zal voortbewegen op de y-as.

        x = BYTE1(fx); // Hier wijzen we enkel de waarde van de hoogste byte (dus het gehele gedeelte) toe aan x.
        y = BYTE1(fy); // Hier wijzen we enkel de waarde van de hoogste byte (dus het gehele gedeelte) toe aan y.

        // Het blokje botst op de randen en kaatst terug.
        if (y == border_top + 1) {
            dy = -dy;
        }
        if (y == border_bottom - 1) {
            dy = -dy;
        }
        if (x == border_left + 1) {
            dx = -dx;
        }
        if (x == border_right - 1) {
            dx = -dx;
        }

        plot(x, y, 1); // Hier tekenen we in de bitmap het nieuwe blokje.

        // We hertekenen het muurtje.
        wall(wall_x, wall_y, wall_size, 1);

        // En deze draw functie tekent het volledige scherm door de bitmap te tekenen op alle karakters om het scherm!
        paint();

        // We scannen een nieuw karakter van het toetsenbord.
        ch = getch();
    }

    // Einde van het spel.
    clrscr(); // We wissen het scherm.
    return 1;
}