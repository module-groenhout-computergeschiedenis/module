/**
 * @file 15-sprites.c
 * @author your name (you@domain.com)
 * @brief Dit is je eerste C programma, dat werkt op de Commodore 128!
 * Het resultaat zal een werkend pong spelletje zijn!
 *
 * Nu tonen we sprites op de C128.
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

// We declareren en initialiseren de registers die de sprite pointers bevatten.
// Sprite pointers verwijzen naar de adressen waar de sprite tekening zich bevindt.
char *vic_sprite_bitmap_base = (char*)0x07F8;

// We declareren de variabelen om sprites op de x-as en y-as te plaatsen.
char *vic_sprite_x_base = (char*)0xD000;
char *vic_sprite_y_base = (char*)0xD001;
char *vic_sprite_x_msb = (char*)0xD010;

// We declareren de variablen om sprites een kleur te geven.
// Er zijn 8 registers vanaf D027 tem D02E die de kleur bevatten van sprite 0 tem 7.
char *vic_sprite_color_base = (char*)0xD027;

// We declareren het VICII register om een sprite te tonen of te verbergen.
// Elke bit representeert 1 sprite.
char *vic_sprite_enable = (char*)0xD015; 

// Puck
static __address(0x3000) char puck[3*21] = {
    0b11110000, 0b00000000, 0b00000000,
    0b11110000, 0b00000000, 0b00000000,
    0b11110000, 0b00000000, 0b00000000,
    0b11110000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000,
    0b00000000, 0b00000000, 0b00000000
};



inline void sprite_enable(char sprite) {
    // We activeren de sprite 0 en 1 door bit 0 en 1 op 1 te zetten in het enable register.
    *vic_sprite_enable = 1 << sprite;
}

inline void sprite_position_x(char sprite, unsigned int x) {
    char* vic_sprite_x =  vic_sprite_x_base;
    vic_sprite_x += sprite << 1;
    *vic_sprite_x = BYTE0(x);
    if(BYTE1(x))
        *vic_sprite_x_msb = *vic_sprite_x_msb | 1;
    else 
        *vic_sprite_x_msb  = *vic_sprite_x_msb & ~1;
}

inline void sprite_position_y(char sprite, char y) {
    char* vic_sprite_y =  vic_sprite_y_base;
    vic_sprite_y += sprite;
    *vic_sprite_y = y;
}

inline void sprite_color(char sprite, char color) {
    char* vic_sprite_color = vic_sprite_color_base;
    vic_sprite_color += sprite;
    *vic_sprite_color = color;
}

inline void sprite_bitmap(char sprite, char* bitmap) {
    char* vic_sprite_bitmap = vic_sprite_bitmap_base;
    vic_sprite_bitmap += sprite;
    *vic_sprite_bitmap = (char)((unsigned int)bitmap >> 6);
}

/**
 * @brief De main functie van pong.
 *
 * @return int
 */
int main() {
    *((char*)0216) = 255;
    *((char*)0xA04) = *((char*)0xA04) & ~1;


    // We activeren sprite 0.
    sprite_enable(0);

    // We zetten de sprite 0 x-as an y-as.
    sprite_position_x(0, 50);
    sprite_position_y(0, 50);

    // We zetten de kleur van de sprites op wit.
    sprite_color(0, 1);

    // We zetten de sprite pointer op het adres van de sprite bitmap.
    sprite_bitmap(0, puck);

    // We zetten de sprite pointer.
    sprite_bitmap(0, puck);


    return 1;
}
