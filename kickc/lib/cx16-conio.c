// CX16 conio.h implementation

#include <cx16.h>
#include <conio.h>
#include <kernal.h>

// The text screen base address, which is a 16:0 bit value in VERA VRAM.
// That is 128KB addressable space, thus 17 bits in total.
// CONIO_SCREEN_TEXT contains bits 15:0 of the address.
// CONIO_SCREEN_BANK contains bit 16, the the 64K memory bank in VERA VRAM (the upper 17th bit).
// !!! note that these values are not const for the cx16!
// This conio implements the two layers of VERA, which can be layer 0 or layer 1.
// Configuring conio to output to a different layer, will change these fields to the address base
// configured using VERA_L0_MAPBASE = 0x9f2e or VERA_L1_MAPBASE = 0x9f35.
// Using the function setscreenlayer(layer) will re-calculate using CONIO_SCREEN_TEXT and CONIO_SCREEN_BASE
// based on the values of VERA_L0_MAPBASE or VERA_L1_MAPBASE, mapping the base address of the selected layer.
// The function setscreenlayermapbase(layer,mapbase) allows to configure bit 16:9 of the
// mapbase address of the time map in VRAM of the selected layer VERA_L0_MAPBASE or VERA_L1_MAPBASE.


// This requires the following constants to be defined
// - CONIO_WIDTH - The screen width
// - CONIO_HEIGHT - The screen height
// - CONIO_SCREEN_TEXT - The text screen address
// - CONIO_SCREEN_COLORS - The color screen address
// - CONIO_TEXTCOLOR_DEFAULT - The default text color

#include <string.h>

#define CONIO_TEXTCOLOR_DEFAULT WHITE // The default text color
#define CONIO_BACKCOLOR_DEFAULT BLUE  // The default back color

struct CX16_CONIO {
    unsigned char layer;
    unsigned int mapbase_offset; // Base pointer to the tile map base of the conio screen.
    char mapbase_bank; // Default screen of the CX16 emulator uses memory bank 0 for text.

    unsigned char width; // Variable holding the screen width;
    unsigned char height; // Variable holding the screen height;
    unsigned char mapwidth; // Variable holding the map width;
    unsigned char mapheight; // Variable holding the map height;
    // unsigned char rowshift;
    unsigned int rowskip;
    unsigned char cursor; // Is a cursor whown when waiting for input (0: no, other: yes)
    unsigned char color; // The color of the foreground and background
    unsigned char bordercolor; // The color of the border
    // The current cursor x-position
    unsigned char cursor_x;
    // The current cursor y-position
    unsigned char cursor_y;
    //// The current text cursor line start
    //unsigned int line;
    // Is scrolling enabled when outputting beyond the end of the screen (1: yes, 0: no).
    // If disabled the cursor just moves back to (0,0) instead
    unsigned char scroll[2];
    unsigned char hscroll[2];
    unsigned int offset; // The current offset
    unsigned int offsets[60]; // Calculated offsets per line according the mapbase and the row width (scale).
};


struct CX16_CONIO __conio;


// Initializer for conio.h on X16 Commander.
#pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)

// Set initial cursor position
void conio_x16_init() {

    screenlayer1();
    
    textcolor(CONIO_TEXTCOLOR_DEFAULT);
    bgcolor(CONIO_BACKCOLOR_DEFAULT);
    
    cursor(0);
    
    __conio.cursor_x = BYTE1(cbm_k_plot_get());
    __conio.cursor_y = BYTE0(cbm_k_plot_get());
    gotoxy(__conio.cursor_x, __conio.cursor_y);

    __conio.scroll[0] = 1;
    __conio.scroll[1] = 1;
}

inline unsigned char kbhit(void) 
{
    return getin();
}

// clears the screen and moves the cursor to the upper left-hand corner of the screen.
void clrscr(void) 
{
    unsigned int line_text = __conio.mapbase_offset;

    *VERA_CTRL &= ~VERA_ADDRSEL;
    *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1;

    unsigned char l = __conio.mapheight;
    do {
        unsigned int ch = line_text;
        // Set address
        *VERA_ADDRX_L = BYTE0(ch);
        *VERA_ADDRX_M = BYTE1(ch);

        unsigned char c = __conio.mapwidth;
        do{
            *VERA_DATA0 = ' ';
            *VERA_DATA0 = __conio.color;
            c--;
        } while(c);

        line_text += __conio.rowskip;
        l--;
    } while(l);

    __conio.cursor_x = 0;
    __conio.cursor_y = 0;
    __conio.offset = __conio.mapbase_offset;
}

// Set the cursor to the specified position
void gotoxy(unsigned char x, unsigned char y) {
    __conio.cursor_x = (x>=__conio.width)?__conio.width:x;
    __conio.cursor_y = (y>=__conio.height)?__conio.height:y;
    __conio.offset = __conio.offsets[y] + __conio.cursor_x << 1;
}

// Return the current screen size.
void screensize(unsigned char* x, unsigned char* y) {
    // VERA returns in VERA_DC_HSCALE the value of 128 when 80 columns is used in text mode,
    // and the value of 64 when 40 columns is used in text mode.
    // Basically, 40 columns mode in the VERA is a double scan mode.
    // Same for the VERA_DC_VSCALE mode, but then the subdivision is 60 or 30 rows.
    // I still need to test the other modes, but this will suffice for now for the pure text modes.
    char hscale = (*VERA_DC_HSCALE) >> 7;
    *x = (40 << hscale)-1;
    char vscale = (*VERA_DC_VSCALE) >> 7;
    *y = (30 << vscale)-1;
    //printf("%u, %u\n", *x, *y);
}

// Return the current screen size X width.
unsigned char screensizex() {
    return __conio.width;
}

// Return the current screen size Y height.
unsigned char screensizey() {
    return __conio.height;
}

// Return the X position of the cursor
unsigned char wherex(void) {
    return __conio.cursor_x;
}

// Return the Y position of the cursor
unsigned char wherey(void) {
    return __conio.cursor_y;
}

// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
void cputc(char c) {

    if(c=='\n') {
        cputln();
    } else {

#ifdef __DEBUG
        cbm_k_plot_set(0,0);
        cbm_k_chrout(c);
#endif

#ifndef __DEBUG
        *VERA_CTRL &= ~VERA_ADDRSEL;
        *VERA_ADDRX_L = BYTE0(__conio.offset);
        *VERA_ADDRX_M = BYTE1(__conio.offset);
        *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1;
        *VERA_DATA0 = c;
        *VERA_DATA0 = __conio.color;
#endif
        if(!__conio.hscroll[__conio.layer]) {
            if(__conio.cursor_x >= __conio.width)
                cputln();
            else {
                __conio.cursor_x++;
                __conio.offset++;
                __conio.offset++;
            }
        } else {
            if(__conio.cursor_x >= __conio.mapwidth)
                cputln();
            else
                __conio.cursor_x++;
                __conio.offset++;
                __conio.offset++;
        }
    }
}

// Print a newline
void cputln() {
    __conio.cursor_x = 0;
    __conio.cursor_y++;
    __conio.offset = __conio.offsets[__conio.cursor_y];
    cscroll();
#ifdef __DEBUG
    cbm_k_plot_set(0,0);
    cbm_k_chrout(13);
#endif
}

void clearline() {
    unsigned int addr = __conio.offsets[__conio.cursor_y];
    *VERA_CTRL &= ~VERA_ADDRSEL;
    *VERA_ADDRX_L = BYTE0(addr);
    *VERA_ADDRX_M = BYTE1(addr);
    *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1;
    register unsigned char c=__conio.width;
    do {
        *VERA_DATA0 = ' ';
        *VERA_DATA0 = __conio.color;
        c--;
    } while(c);
}

// Insert a new line, and scroll the lower part of the screen down.
void insertdown(unsigned char rows) {
    unsigned char width = (__conio.width+1) * 2;
    for(unsigned char y=__conio.height - __conio.cursor_y + 1; y>__conio.cursor_y; y--) {
        memcpy8_vram_vram(__conio.mapbase_bank, __conio.offsets[y], __conio.mapbase_bank, __conio.offsets[y-1], width);
    }
    clearline();
}

// Insert a new line, and scroll the upper part of the screen up.
void insertup(unsigned char rows) {
    unsigned char width = (__conio.width+1) * 2;
    for(unsigned char y=0; y<=__conio.cursor_y; y++) {
        memcpy8_vram_vram(__conio.mapbase_bank, __conio.offsets[y], __conio.mapbase_bank, __conio.offsets[y+1], width);
    }
    clearline();
}

// Scroll the entire screen if the cursor is beyond the last line
void cscroll() {
    if(__conio.cursor_y>__conio.height) {
        if(__conio.scroll[__conio.layer]) {
            insertup(1);
            gotoxy( 0, __conio.height);
            clearline();
        } else {
            if(__conio.cursor_y>__conio.height) {
               gotoxy(0,0);
            }
        }
    }
}


// Output a NUL-terminated string at the current cursor position
void cputs(const char* s) {
    char c;
    while(c=*s++)
        cputc(c);
}

// Move cursor and output one character
// Same as "gotoxy (x, y); cputc (c);"
void cputcxy(unsigned char x, unsigned char y, char c) {
    gotoxy(x, y);
    cputc(c);
}

// Move cursor and output a NUL-terminated string
// Same as "gotoxy (x, y); puts (s);"
void cputsxy(unsigned char x, unsigned char y, const char* s) {
    gotoxy(x, y);
    cputs(s);
}

// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
unsigned char cursor(unsigned char onoff) {
    // not supported in CX16
    char old = __conio.cursor;
    __conio.cursor = onoff;
    return old;
}

// If onoff is 1, scrolling is enabled when outputting past the end of the screen
// If onoff is 0, scrolling is disabled and the cursor instead moves to (0,0)
// The function returns the old scroll setting.
unsigned char scroll(unsigned char onoff) {
    char old = __conio.scroll[__conio.layer];
    __conio.scroll[__conio.layer] = onoff;
    return old;
}

// If onoff is 1, scrolling is enabled when outputting past the end of the screen
// If onoff is 0, scrolling is disabled and the cursor instead moves to (0,0)
// The function returns the old scroll setting.
unsigned char hscroll(unsigned char onoff) {
    char old = __conio.hscroll[__conio.layer];
    __conio.hscroll[__conio.layer] = onoff;
    return old;
}

// --- Defined in cx16.c and cx16-vera.h ---

// --- layer management in VERA ---



void screenlayer(char layer, char mapbase, char config)
{
    unsigned char const VERA_LAYER_DIM[4] = {31, 63, 127, 255};
    unsigned int const VERA_LAYER_SKIP[4] = {64, 128, 256, 512};

    __mem char vera_dc_hscale_temp = *VERA_DC_HSCALE;
    __mem char vera_dc_vscale_temp = *VERA_DC_VSCALE;

    __conio.layer = 0;
    __conio.mapbase_bank = mapbase >> 7;
    __conio.mapbase_offset = MAKEWORD((mapbase)<<1,0);
    __conio.mapwidth = VERA_LAYER_DIM[ (config & VERA_LAYER_WIDTH_MASK) >> 4];
    __conio.mapheight = VERA_LAYER_DIM[ (config & VERA_LAYER_HEIGHT_MASK) >> 6];
    // __conio.rowshift = ((config & VERA_LAYER_WIDTH_MASK)>>4)+6;
    __conio.rowskip = VERA_LAYER_SKIP[(config & VERA_LAYER_WIDTH_MASK)>>4];
    __conio.width = (40 << (char)(vera_dc_hscale_temp == 0x80))-1;
    __conio.height = (30 << (char)(vera_dc_vscale_temp == 0x80))-1;

    unsigned int mapbase_offset = __conio.mapbase_offset;
    for(register char y=0; y<__conio.height; y++) {
        __conio.offsets[y] = mapbase_offset;
        mapbase_offset += __conio.rowskip;
    }
}

// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
void screenlayer0() {
    screenlayer(0, *VERA_L0_MAPBASE, *VERA_L0_CONFIG);
}


// Set the layer with which the conio will interact.
void screenlayer1() {
    screenlayer(1, *VERA_L1_MAPBASE, *VERA_L1_CONFIG);
}


// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
char textcolor(char color) {
    return __conio.color = __conio.color & 0xF0 | color;
}

// Set the back color for text output.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
char bgcolor(char color) {
    return __conio.color = __conio.color & 0x0F | color << 4;
}

// Set the color for the border.
char bordercolor(unsigned char color) {
    return __conio.bordercolor = *VERA_DC_BORDER;
}

