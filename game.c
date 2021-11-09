#pragma code-name ("CODE")
#pragma bss-name ("BSS")

#include "int.h"
#include "vram.h"
#include "stop.h"

//
// This is a test program that fills the VRAM with a tessellated matrix of
// bi-colored shading. Utterly useless in practice, but a good test to ensure
// that the fundamentals of our cc65 implementation and framework are functional
//
// Exits with the STP opcode after drawing one frame
//

bool vram_initialized;

#pragma code-name ("RESET")
void reset() {
    vram_initialized = false;
}

#pragma code-name ("DO_LOGIC")
void do_logic() {
    if (vram_initialized)
        stop();
}

#pragma code-name ("FILL_VRAM")
void fill_vram() {
    uint8_t i, j;

    // init PMB
    for ( i = 0; i < 16; i+=1 ) {
        PMB[0].data[i+0] = 0xe4;
        PMB[0].data[i+1] = 0x1b;
    }

    // init NTBL
    for ( i = 0; i < 30; i+=1 )
        for ( j = 0; j < 32; j++ )
            NTBL[i][j] = (((i^j)&1)==0) ? COLOR_ALT_MASK : 0;

    background_palette = MAGENTA_C1_MASK | GREEN_C0_MASK;

    vram_initialized = true;
}
