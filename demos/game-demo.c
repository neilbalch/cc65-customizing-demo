
// ==================== game.c ==================== //
// Follow this file template to implement your game //
// ================================================ //

#define SIM 1 // change value depending if running simulation or not


// ================================ //
#pragma code-name ("CODE")
#pragma bss-name ("BSS")
// Misc Code Segment

#include <int.h>
#include <vram.h>
#include <stop.h>
#include <Q9_6.h>
#include <arcade_zero_page.h>
#include <controller.h>

uint16_t CONTROLLER_1_PEDGE;
uint16_t CONTROLLER_1_PREV;

typedef struct person_s {
    Q9_6 xp, yp, xv, yv;
    uint8_t object;
} person_t;

person_t p;

// ================================ //
#pragma code-name ("RESET")
// Reset Segment
void reset() {
    CONTROLLER_1_PREV = 0;
    p = (person_t) {
        .xp=0, .yp=0, .xv=0, .yv=0,
        .object=0
    };
}

// ================================ //
#pragma code-name ("DO_LOGIC")
// Do Logic Segment
void do_logic() {
    CONTROLLER_1_PEDGE = (~CONTROLLER_1_PREV)&CONTROLLER_1;
    CONTROLLER_1_PREV = CONTROLLER_1;
}


// ================================ //
#pragma code-name ("FILL_VRAM")
// Fill VRAM Segment
void fill_vram() { }


// ================================ //
