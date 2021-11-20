
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

bool vram_initialized;

#include "patterns.h"
#include "person.h"

void init_vram() {
    uint8_t i, j;

    // clear vram
    for (i = 0; i < 64; i++) {
        OBM[i].y = 0xff;
    }

    // load background patterns
    load_background_pattern(&black,black_pmba);
    load_background_pattern(&dark_gray,dark_gray_pmba);
    load_background_pattern(&light_gray,light_gray_pmba);
    load_background_pattern(&white,white_pmba);

    // load foreground patterns
    load_foreground_pattern(&person_normal,person_normal_pmfa);

    // load background
    background_palette = CYAN_C0_MASK | GREEN_C1_MASK;
    for (i = 0; i < 28; i++) {
        for (j = 0; j < 32; j++) {
            NTBL[i][j] = white_pmba;
        }
    }
    for (i = 28; i < 30; i++) {
        for (j = 0; j < 32; j++) {
            NTBL[i][j] = light_gray_pmba | COLOR_ALT_MASK;
        }
    }

    vram_initialized = true;
}


// ================================ //
#pragma code-name ("RESET")
// Reset Segment
void reset() {
    CONTROLLER_1_PREV = 0;

    p.xp=SINT_TO_Q9_6(124);
    p.yp=SINT_TO_Q9_6(124);
    p.xv=0;
    p.yv=0;
    p.object=0;
    p.pmfa=person_normal_pmfa;
    p.color=YELLOW_C_MASK;

    vram_initialized = false;
}

// ================================ //
#pragma code-name ("DO_LOGIC")
// Do Logic Segment
void do_logic() {
    CONTROLLER_1_PEDGE = (~CONTROLLER_1_PREV)&CONTROLLER_1;
    CONTROLLER_1_PREV = CONTROLLER_1;

    #if SIM
    if (vram_initialized) stop();
    #endif
}


// ================================ //
#pragma code-name ("FILL_VRAM")
// Fill VRAM Segment

void fill_vram() {
    if (!vram_initialized) init_vram();
    draw_person();
}


// ================================ //
