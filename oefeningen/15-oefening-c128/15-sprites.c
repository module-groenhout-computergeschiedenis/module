/**
 * @file 15-sprites.c
 * @author your name (you@domain.com)
 * @brief Dit is je eerste C programma, dat werkt op de Commodore 128!
 *
 * We spelen met sprites op de Commodore 128. De reden dat 'k de Commodore 128 heb gekozen voor deze oefening is omdat deze
 * machine in BASIC commando's bevat die sprites helpen definiëren en die je kan laten rondzweven.
 * Echter, dit is allemaal in BASIC en die commando's zijn gemaakt voor eenvoudige gebruikers, en deze zijn pas heel laat
 * geïntroduceerd door Commodore in de BASIC taal. De Commodore 64 kent deze BASIC instructies niet.
 * 
 * Wij gaan nu leren hoe we de C-taal kunnen gebruiken om zelf de sprites te besturen.
 * We doen dit door direct de registers van de VIC II chip aan te sturen, 
 * die het beeldscherm tekent op de Commodore 128 en in de Commodore 64.
 * 
 * Volg de onderstaande link voor een volledige beschrijving van de VIC II chip en zijn registers. Het is allemaal erg technisch, maar
 * in de les zullen we zien dat het allemaal best meevalt en dat het erg leuk is nadat je wat geoefend hebt!
 * [VIC II chip registers](https://handwiki.org/wiki/Engineering:MOS_Technology_VIC-II).
 * 
 * Zoals gezegd werken we vandaag met sprites.
 * Deze link [sprites](https://codebase64.org/doku.php?id=base:spriteintro) legt uit hoe we sprites besturen in de VIC II chip. We leren hoe ze worden aan en afgezet.
 * We positioneren ze op de x-as en y-as. We duiden aan waar de bitmap van de sprite zich bevindt in het internet geheugen.
 * We spelen met sprites. In de les zullen we samen over deze uitleg gaan.
 * 
 * In deze les leren we:
 *   - Welke registers de VICII heeft voor sprite bewerkingen.
 *   - Hoe deze registers werken.
 *   - We leren ze binair te addresseren (met &, |, ~ operatoren).
 *   - We leren hoe we C-functies bouwen om de sprite registers te bewerken op een éénvoudige wijze.
 *   - We spelen met onze C-functies en leren sprites te bewegen over het scherm.
 *   - We leren hoe we een scan line interrupt moeten maken en hoe we heel vlotte sprite bewegingen kunnen maken.
 *   - We leren sprites animeren.
 *   - We leren allerlei andere eigenschappen van sprites.
 * 
 * We maken de volgende functies en we leren hoe ze werken:
 * 
 * inline void screen_color(char color)
 * inline void border_color(char color)
 * inline void sprite_enable(char sprite)
 * inline void sprite_position_x(char sprite, unsigned int x)
 * inline void sprite_position_y(char sprite, char y)
 * inline void sprite_color(char sprite, char color)
 * inline void sprite_bitmap(char sprite, char* bitmap)
 * 
 * Noteer dat je zelf je programma zal intypen, maar we maken de oefeningen samen, want het is allemaal nieuw.
 * Dus geen zorg, je zal veel leren en later zal je zelf kunnen spelen hiermee :-).
 * 
 * 
 * OEFENING 15.1: We geven het scherm een andere kleur.
 *   - We gebruiken VIC II register 0xD020 om de rand van het scherm te kleuren.
 *   - We gebruiken VIC II register 0xD021 om het scherm te kleuren.
 *   - We vervolledigen functies screen_color en border_color.
 * 
 * OEFENING 15.2: Positioneer de sprite op een andere plaats op de x-as en the y-as!
 *   - Welke VIC II registers gebruik je hiervoor?
 *   - Begrijp je hoe de registers werken?
 *   - We vervolledigen functie sprite_enable om de sprite aan te zetten.
 *   - We vervolledigen functie sprite_position_x om de sprite op de x-as te positioneren.
 *   - We vervolledigen functie sprite_position_y om de sprite op de y-as te positioneren.
 *   - We vervolledigen functie sprite_bitmap om de sprite te verwijzen naar de sprite bitmap.
 *   - We positioneren de sprite op x-as op 100 en op y-as op 100.
 * 
 * OEFENING 15.3: Probeer nu de sprite een andere kleur te geven.
 *   - We gebruiken hiervoor VIC II registers D027 tem D02E.
 *   - We vervolledigen functie sprite_color om de sprite een kleur te geven. 
 * 
 * OEFENING 15.4: Teken je eigen sprite in de excel sheet, en cut/paste the binaire data in je c programma.
 *   - Hercompileer en voer je programma uit. Werkt het?
 *   - Ideeën voor een sprite zijn ruimteschepen, vliegtuigen, gezichtjes. Hou het eenvoudig.
 * 
 * OEFENING 15.5: Maak nu een 2de en een 3de sprite, gebaseerd op de 1ste sprite, maar verander het een beetje.
 *   - Declareer en alloceer de bitmap van de 2de en de 3de sprite.
 *   - Probeer nu je programma zo aan te passen dat de 2de sprite na een willekeurige toetsaanslag, verschijnt.
 *   - Om dit te bewerkstelligen, moet je de functie gebruiken om het sprite bitmap register aan te passen.
 * 
 * OEFENING 15.6: Probeer nu de sprite bitmap te elke 16 frames te wisselen tussen de 1ste sprite en de 2de en de 3de sprite.
 *   - We gebruiken de "raster lijn" methode. Ik zal dit uitleggen. De code scheleton bevat al deze logica.
 *   - We moeten een tellertje declareren dat telkens optelt telt.
 *   - Bij elke 16 frames, passen we de sprite bitmap aan naar de volgende bitmap.
 * 
 * OEFENING 15.7: Probeer nu de sprite te bewegen op de x-as, vanaf positie 50 tem positie 255.
 *   - Als de sprite op positie 255 is beland, moet de positie terug op 50 worden gezet en beginnen we van voor af aan.
 *   - We gebruiken een scan line interrupt om dit te doen.
 * 
 * OEFENING 15.8: Probeer nu de sprite VOORBIJ de positie 255 te zetten op de x-as!
 *   - Je hebt hier een speciaal register nodig!
 *   - Je moet aan Sven vragen hoe dit register werkt.
 *   - We zullen hier leren hoe we een '|' (OR), een '&' (AND) en een '~' (NOT) operator gebruiken.
 * 
 * OEFENING 15.9: Nu proberen we de sprite ook op de y-as te bewegen ...
 * 
 * @version 0.1
 * @date 2022-01-13
 *
 * @copyright Copyright (c) 2023
 *
 */

#pragma encoding(petscii_mixed)
#pragma var_model(zp)
#pragma target(C128)

#include <conio.h>
#include <kernal.h>
#include <printf.h>

#include <mos6569.h>

// We declareren en initialiseren de registers om het scherm en de border een kleur te geven.
// Voor de kleur van het scherm gebruiken we VIC II register 0xD021.
// Voor de kleur van de border gebruiken we VIC II register 0xD020.
char* const vic_background_color_0 = (char*)0xD021;
char* const vic_border_color = (char*)0xD020;

// We declareren en initialiseren de registers die de sprite pointers bevatten.
// Sprite pointers verwijzen naar de adressen waar de sprite tekening zich bevindt.
char* const vic_sprite_bitmap_base = (char*)0x07F8;

// We declareren de variabelen om sprites op de x-as en y-as te plaatsen.
char* const vic_sprite_x_base = (char*)0xD000;
char* const vic_sprite_y_base = (char*)0xD001;
char* const vic_sprite_x_msb = (char*)0xD010;

// We declareren de variablen om sprites een kleur te geven.
// Er zijn 8 registers vanaf D027 tem D02E die de kleur bevatten van sprite 0 tem 7.
char* const vic_sprite_color_base = (char*)0xD027;

// We declareren het VICII register om een sprite te tonen of te verbergen.
// Elke bit representeert 1 sprite.
char* const vic_sprite_enable = (char*)0xD015; 

// We declareren het VIC II register die de huidige raster (teken) lijn bevat van het beeldscherm.
// Dit raster lijn register is op adres 0xD012 in bit 0 tem 7, 
// maar register 0xD011 in bit 7, bevat de 8ste raster lijn bit die de waarden na 255 kan testen!
// M.a.w., als bit 7 van register 0xD011 op 1 staat, dan is de scan lijn voorbij de 255ste lijn!
char* const vic_raster_low = (char*)0xD012;
char* const vic_raster_high = (char*)0xD011; // We gebruiken hier ENKEL de 7de bit!

// spite_bitmap0
// OPLOSSING 15.4:
static __address(0x2000) char sprite_bitmap_0[3*21] = {
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b10000000,	0b00000000,	0b00000000,
0b11000000,	0b00000000,	0b00000000,
0b11100000,	0b00000000,	0b00000000,
0b11110000,	0b00000100,	0b00000000,
0b11111000,	0b00000110,	0b00000000,
0b11111111,	0b11111111,	0b11111110,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111110,
0b11111000,	0b00000110,	0b00000000,
0b11110000,	0b00000100,	0b00000000,
0b11100000,	0b00000000,	0b00000000,
0b11000000,	0b00000000,	0b00000000,
0b10000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000
};

// Ship1
// OPLOSSING 15.5:
static __address(0x2040) char sprite_bitmap_1[3*21] = {
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111
};

// Ship2
// OPLOSSING 15.5:
static __address(0x2080) char sprite_bitmap_2[3*21] = {
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111,
0b11111111,	0b11111111,	0b11111111
};

char* sprite_bitmap_array[3] = {sprite_bitmap_0, sprite_bitmap_1, sprite_bitmap_2};


/**
 * @brief Zet de achtergrond kleur van het scherm.
 * 
 * @param color 
 */
inline void screen_color(char color) {
    // OPLOSSING 15.1:
    *vic_background_color_0 = color;
}

/**
 * @brief Ze de border kleur van het scherm.
 * 
 * @param color 
 */
inline void border_color(char color) {
    // OPLOSSING 15.1:
   *vic_border_color=color;
}

/**
 * @brief Zet de sprite aan of uit.
 * 
 * @param sprite Een getal tussen 0 en 7.
 */
inline void sprite_enable(char sprite) {
    // OPLOSSING 15.2:
    // We activeren de sprite 0 en 1 door bit 0 en 1 op 1 te zetten in het enable register.
    *vic_sprite_enable=1<<sprite;
}

/**
 * @brief Zet de sprite op een positie op de X-as.
 * 
 * @param sprite Een getal tussen 0 en 7.
 * @param x Een getal tussen 0 en 512.
 */
inline void sprite_position_x(char sprite, unsigned int x) {
    // OPLOSSING 15.2:
    char* vic_sprite_x = vic_sprite_x_base;
    vic_sprite_x += sprite <<1;
    *vic_sprite_x = x;

    // OPLOSSING 15.8:
    // if(...)
    //     *vic_sprite_x_msb = ...;
    // else 
    //     *vic_sprite_x_msb  = ...;
}

/**
 * @brief Ze de sprite op een positie op de Y-as.
 * 
 * @param sprite Een getal tussen 0 en 7.
 * @param y Een getal tussen 0 en 255.
 */
inline void sprite_position_y(char sprite, char y) {
    // OPLOSSING 15.2:
    char* vic_sprite_y =  vic_sprite_y_base;
    vic_sprite_y += sprite << 1;
    *vic_sprite_y = y;
}

/**
 * @brief Zet de kleur van een sprite.
 * 
 * @param sprite Een getal tussen 0 en 7.
 * @param color Een getal tussen 0 en 15.
 */
inline void sprite_color(char sprite, char color) {
    // OPLOSSING 15.3:
    // char* vic_sprite_color = vic_sprite_color_base;
    // vic_sprite_color += ...;
    // *vic_sprite_color = ...;
}

/**
 * @brief Verwijs naar het geheugengebied om de juiste bitmap voor de sprite te tekenen.
 * De bitmap moet gealigneerd zijn per 64 bytes in het geheugen.
 * Elke sprite heeft een eigen bitmap pointer van 8 bits, vanaf 0x7F8 (vic_sprite_bitmap_base).
 * Elke waarde van de sprite pointer verwijst naar een blok van 64 bytes.
 * Er kunnen maximaal 256 blokken van sprite bitmaps worden toegewezen in 16K.
 * 
 * @param sprite Een getal tussen 0 en 7.
 * @param bitmap De pointer naar de positie in het geheugen van de sprite bitmap.
 * Noteer dat deze positie altijd moet gealigneerd zijn op 64 bytes!
 * Dus van de 16 bits van het adres, moeten bits 0 tem 5 de waarde 0 hebben!
 */
inline void sprite_bitmap(char sprite, char* bitmap) {
    // OPLOSSING 15.2:
    char* vic_sprite_bitmap = vic_sprite_bitmap_base;
    vic_sprite_bitmap += sprite;
    *vic_sprite_bitmap = (char)((unsigned int)bitmap >>6);
}

/**
 * @brief De main functie van pong.
 *
 * @return int
 */
int main() {

    // Deze 2 instructies mag je overslaan (ignore). Hier zetten we gewoon op de Commodore 128
    // de BASIC logica uit dat de sprite besturing doet.
    // Op de Commodore 64 zijn dezze instructies niet nodig.
    *((char*)0216) = 255;
    *((char*)0xA04) = *((char*)0xA04) & ~1;

    // We wissen het scherm.
    clrscr();

    // We doen een lus in de hoofd logica van dit programma, en we tested of er een toets was gedrukt.
    // Het karakter van de laatst gebruikte toetsaanslag slaan we op in ch, 
    // maar nu initialiseren we deze waarde met 0 om aan te duiden dat er geen toets was ingedrukt.
    unsigned char ch = 0;

    // Dit is een werk variabele die we bijhouden om te zorgen dat we de raster lijn
    // logica enkel uitvoeren als bit 8 van de raster lijn terug op 0 valt.
    // Ik zal het uitleggen in de klas, waarom we dit hebben en doen.
    // We voeren de hoofdlogica enkel uit als raster_test gelijk aan 1 is.
    unsigned raster_test = 1;

    // We houden de x positie bij in een teller.
    // Het type van de x positie moet een int zijn, 
    // want het scherm heeft 320 pixels op de x-as.
    // We hebben maar 256 mogelijke waarden in een char.
    // Dus we tellen met 2 bytes, en we maken gebruik van het type int.
    // OPLOSSING 15.7:
    unsigned int x = 24;

    // Hier is het sprite telletje, we gebruiken het om de array van sprite bitmaps te veranderen.
    // OPLOSSING 15.6:
    unsigned char sprite_counter = 0;
    
    // Dit is het tellertje dat elke frame telt.
    // OPLOSSING 15.6:
    unsigned char frame = 0;




    // We geven het scherm een kleur naar keuze.
    //OPLOSSING 15.1:
    screen_color(9);
    sprite_position_x(0, 200);

    // We geven de border een kleur naar keuze.
    //OPLOSSING 15.1:
   border_color(6);

    // We activeren sprite 0.
    //OPLOSSING 15.2:
    sprite_enable(0);

    // We zetten de sprite pointer op het adres van de sprite bitmap.
    //OPLOSSING 15.2:
    sprite_bitmap(0, sprite_bitmap_0);

    // We zetten de sprite op een positie op de x-as an y-as.
    // OPLOSSING 15.2:
    sprite_position_x(0, 125);
    sprite_position_y(0, 120);

    // We zetten de kleur van de sprites op een kleur naar keuze.
    // OPLOSSING 15.3:
    // sprite_color(0, ...);


    // We blijven deze logica uitvoeren totdat er een toets is gedrukt.
    while(!ch) {

        // We tested of we raster_lijn mogen tested en of de 8ste bit van het raster op 1 staat.
        // Indien de waarde van deze bit aan staat, dan voeren we de logica uit.
        if(raster_test && *vic_raster_high & 0x80) {

            // We zetten de sprite 0 x-as an y-as.
            // OPLOSSING 15.7:
            //sprite_position_x(0, ...);

            sprite_position_y(0, 100);

            // We zetten de sprite pointer op het adres van de sprite_bitmap teller.
            //OPLOSSING 15.6:
            //sprite_bitmap(0, ...);


            // We positioneren nu onze sprite op positie +1 op de x-as.
            // Indien de positie gelijk is aan 0 (OEFENING 15.7), 
            // of gelijk aan 320 (OEFENING 15.8),
            // dan positioneren we onze sprite op positie 24, de begin positie.
            // OPLOSSING 15.7 en 15.8 :
            // if(x < 320) {
            //     x++;
            // } else {
            //     x = 24;
            // }

            // Hier tellen we 1 op bij frame om bij te houden hoeveel frames we hebben gehad.
            // OPLOSSING 15.6:
            frame += 1;

            // Om te zorgen dat we elke 16 frames sprite_bitmap verhogen, 
            // berekenen we de huidige frame AND 0b00010000.
            // Als het resultaat daarvan niet 0 is, dan wordt de logica van de if uitgevoerd.
            if((frame & 0x0F) == 0x0F) {
                sprite_counter++;             // We verhogen nu de teller sprite_bitmap met 1. 
                if(sprite_counter == 3) {     // Als sprite_bitmap gelijk is aan 3?
                    sprite_counter = 0;       // Dan zetten we sprite_bitmap terug op 0.
                }
            }

            // We lezen gewoon een karakter in van het toetsenbord.
            ch = getch();

            // Om te zorgen dat we de logic maar 1 keer uitvoeren, zetten we deze
            // raster_test vlag op 0.
            // We voeren de hoofdlogica enkel uit als raster_test gelijk aan 1 is.
            raster_test = 0;

        } else {
            // Anders ... nu tested we of we de huidige raster lijn mogen testen.
            // Als we raster_lijn mogen testen, dus als raster_test gelijk aan 0 is
            // AND of bit 8 van raster lijn gelijk aan 0 is.
            if(!raster_test && !(*vic_raster_high & 0x80)) {
                raster_test = 1; // Dan zetten we raster_test terug op 1;
            }
        }

    }

    return 1;
}
