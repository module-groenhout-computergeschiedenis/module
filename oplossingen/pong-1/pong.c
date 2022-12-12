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

#pragma encoding(petscii_mixed)
#pragma var_model(zp)

#include <conio.h>
#include <printf.h>

char bitmap[80 * 80] = {0};

char block[16] = {
    16 * 2 + 0,   // 0000
    16 * 6 + 12,  // 0001
    16 * 7 + 11,  // 0010
    16 * 6 + 2,   // 0011
    16 * 7 + 12,  // 0100
    16 * 14 + 1,  // 0101
    16 * 15 + 15, // 0110
    16 * 15 + 14, // 0111
    16 * 7 + 14,  // 1000
    16 * 7 + 15,  // 1001
    16 * 6 + 1,   // 1010
    16 * 15 + 12, // 1011
    16 * 14 + 2,  // 1100
    16 * 15 + 11, // 1101
    16 * 14 + 12, // 1110
    16 * 10 + 0   // 1111
};

char *const screen = (char *)0x8000;

void draw()
{

    for (char x = 0; x < 80; x++)
    {
        *(screen + 80 * 0 + x) = block[bitmap[80 * 0 + x]];
        *(screen + 80 * 1 + x) = block[bitmap[80 * 1 + x]];
        *(screen + 80 * 2 + x) = block[bitmap[80 * 2 + x]];
        *(screen + 80 * 3 + x) = block[bitmap[80 * 3 + x]];
        *(screen + 80 * 4 + x) = block[bitmap[80 * 4 + x]];
        *(screen + 80 * 5 + x) = block[bitmap[80 * 5 + x]];
        *(screen + 80 * 6 + x) = block[bitmap[80 * 6 + x]];
        *(screen + 80 * 7 + x) = block[bitmap[80 * 7 + x]];
        *(screen + 80 * 8 + x) = block[bitmap[80 * 8 + x]];
        *(screen + 80 * 9 + x) = block[bitmap[80 * 9 + x]];
        *(screen + 80 * 10 + x) = block[bitmap[80 * 10 + x]];
        *(screen + 80 * 11 + x) = block[bitmap[80 * 11 + x]];
        *(screen + 80 * 12 + x) = block[bitmap[80 * 12 + x]];
        *(screen + 80 * 13 + x) = block[bitmap[80 * 13 + x]];
        *(screen + 80 * 14 + x) = block[bitmap[80 * 14 + x]];
        *(screen + 80 * 15 + x) = block[bitmap[80 * 15 + x]];
        *(screen + 80 * 16 + x) = block[bitmap[80 * 16 + x]];
        *(screen + 80 * 17 + x) = block[bitmap[80 * 17 + x]];
        *(screen + 80 * 18 + x) = block[bitmap[80 * 18 + x]];
        *(screen + 80 * 19 + x) = block[bitmap[80 * 19 + x]];
        *(screen + 80 * 20 + x) = block[bitmap[80 * 20 + x]];
        *(screen + 80 * 21 + x) = block[bitmap[80 * 21 + x]];
        *(screen + 80 * 22 + x) = block[bitmap[80 * 22 + x]];
        *(screen + 80 * 23 + x) = block[bitmap[80 * 23 + x]];
        *(screen + 80 * 24 + x) = block[bitmap[80 * 24 + x]];
    }
}

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
void plot(char x, char y, char c)
{
    // OEFENING:
    // Kan je een aantal testen toevoegen om zeker te zijn dat:
    // - De x waarden telkens binnen de 0 en 159 vallen?
    // - De y waarden telkens binnen de 0 en 49 vallen?
    // Je doet die met de if() functie toe te passen.
    // Voeg je code onderaan hier toe...

    // if( ... ) {
    //      ;
    // }

    // if( ... ) {
    //      ;
    // }

    // ...

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
    unsigned int i = (unsigned int)iy * 80 + ix;

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
    char sh = (by + bx) ^ 3;

    // En nu komt de magic!
    // nu sh de positie van de bit bevat dat moet worden bijgewerkt, hebben we nog niet de exact bitwaarde!
    // We moeten de bit "shiften" naar links met het aantal benodigde posities!
    // We nameen eerst aan dat de bit positie sh = 0. Dus 0001.
    char b = 1;
    // Echter, als sh groter is dan 0, dan moeten we b (dat 1 bevat), shiften naar links met het aantal keer in de variabele sh.
    // De << operator zal de bit shiften naar links. Kijk goed! We shiften de 1 een aantal keer naar links, aangeduid door de variabele sh.
    // De if ( sh ) bekijkt of sh een waarde bevat, indien "ja", (dus sh is niet 0), dan zal de shift operatie plaatsvinden.
    if (sh)
    {
        b = 1 << sh;
    }

    // Als laatste bekijken we exact wat er moet gebeuren met de "kleur".
    // Onthou! Een 0 verwijdert een blokje en een 1 tekent een blokje.
    // if (c) zal bekijken of c niet nul is, of anders gezegt, een waarde bevat.
    // Indien c niet 0 is, dan zal er een OR operatie plaatvinden met b!
    // Indien c 0 is, dan zal er een AND operatie plaatvinden met de inverse van b!

    if (c)
    {
        // De |= operator berekent een OR operatie met bm en b. We lichten wat OR is nader toe in de klas.
        // Als geheugensteuntje voor de | or OR operator ... 1 = 1 OR 1 ... 1 = 1 OR 0 ... 1 = 0 OR 1 ... 0 = 0 OR 0 ...
        // Als voorbeeld, stel bm = 1010 en b = 0001 ...
        // ... De operatie voluit geschreven wordt: bm = bm | b;
        // ... bm = 1010 | 0001 ...
        // ... bm = 1011
        // Wat leren we hieruit? Dat we bit 0 van de bitmap hebben aangezet, bm = 1011 als resultaat, waar de laatste waarde nu 1 is!
        bm |= b; 
    }
    else
    {
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
        bm &= ~b; 
    }

    // En als laatste wijzen we nu de bijgewerkte bitmap toe aan de vorige bitmap index positie!
    // In andere woorden, we overschrijven de vorige waarde met de nieuwe berekende waarde.
    bitmap[i] = bm;
}

int main()
{
    clrscr();

    signed char dx = 1;
    signed char dy = 1;
    unsigned int y = 0;
    unsigned int x = 0;

    while (1)
    {
        plot(x, y, 0);
        y += dy;
        x += dx;

        // Kan je zorgen dat het blokje goed loopt? 
        // Dat het op het einde van het scherm terug botst op de rand van het scherm? 
        if (y == 0)
        {
            dy = 1;
        }
        if (y == 49)
        {
            dy = -1;
        }
        if (x == 0)
        {
            dx = 1;
        }
        if (x == 159)
        {
            dx = -1;
        }
        plot(x, y, 1);
        draw();
        for (unsigned int e = 0; e < 16384; e++)
            ;
    }

    return 1;
}