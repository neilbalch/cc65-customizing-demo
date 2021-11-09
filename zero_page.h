// Declare variables to be stored in the zeropage memory area (0x00 to 0xFF)
#ifndef __ZERO_PAGE
#define __ZERO_PAGE

#include "int.h"

extern uint32_t FRAME;
#pragma zpsym ("FRAME"); // Put the "FRAME" SYMbol in the ZeroPage

#endif
