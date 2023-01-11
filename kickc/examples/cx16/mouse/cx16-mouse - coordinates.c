
#include <conio.h>
#include <printf.h>
#include <cx16-mouse.h>
#include <kernal.h>

void main() {
    clrscr();
    cx16_mouse_config(0x01, 80, 60);

    printf("move the mouse, and check the registers updating correctly. press any key ...\n");

    while(!getin()) { // loop until a key is pressed
        char cx16_mouse_status = cx16_mouse_get(); // get the mouse status, which puts the x and y coordinates in zero page $22
        gotoxy(0,19);
        printf("coordinates : x=%03i, y=%03i", cx16_mousex, cx16_mousey); // print the mouse coordinates.
    }
}
