#ifndef GAME_CODE_H
#define GAME_CODE_H

#include "util.h"
#pragma code-name ("CODE2")

// Function prototypes with no parameters must be declared with a `void`
// parameter: https://github.com/cc65/cc65/issues/1591#issuecomment-962532711

// Called once upon MPU reset
void reset(void);

// Called once per frame to perform all necessary game logic, without writing
// to the GPU frame buffer.
void do_logic(void);

// Called after completion of the do_logic() function and the next GPU interrupt
// indicating it is safe to write to the GPU frame buffer.
void fill_vram(void);

#endif
