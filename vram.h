

#ifndef __VRAM_H
#define __VRAM_H

#include "int.h"


// https://arcade.ucsbieee.org/guides/gpu/

typedef struct pattern_s {
    uint8_t data[16];
} pattern_t;

typedef uint8_t tile_t;

typedef uint8_t background_palette_t;

typedef struct object_s {
    uint8_t x;
    uint8_t y;
    uint8_t pattern_config;
    uint8_t color;
} object_t;


extern pattern_t PMF[32];

extern pattern_t PMB[32];

extern tile_t NTBL[30][32];
extern background_palette_t background_palette;

extern object_t OBM[32];


#define COLOR_ALT_MASK          0x80
#define HFLIP_MASK              0x40
#define VFLIP_MASK              0x20
#define PATTERN_ADDRESS_MASK    0x1f


#define BLACK_C_MASK     0x0
#define BLUE_C_MASK      0x1
#define GREEN_C_MASK     0x2
#define CYAN_C_MASK      0x3
#define RED_C_MASK       0x4
#define MAGENTA_C_MASK   0x5
#define YELLOW_C_MASK    0x6
#define WHITE_C_MASK     0x7

#define BLACK_C0_MASK    BLACK_C_MASK   << 0
#define BLUE_C0_MASK     BLUE_C_MASK    << 0
#define GREEN_C0_MASK    GREEN_C_MASK   << 0
#define CYAN_C0_MASK     CYAN_C_MASK    << 0
#define RED_C0_MASK      RED_C_MASK     << 0
#define MAGENTA_C0_MASK  MAGENTA_C_MASK << 0
#define YELLOW_C0_MASK   YELLOW_C_MASK  << 0
#define WHITE_C0_MASK    WHITE_C_MASK   << 0

#define BLACK_C1_MASK    BLACK_C_MASK   << 3
#define BLUE_C1_MASK     BLUE_C_MASK    << 3
#define GREEN_C1_MASK    GREEN_C_MASK   << 3
#define CYAN_C1_MASK     CYAN_C_MASK    << 3
#define RED_C1_MASK      RED_C_MASK     << 3
#define MAGENTA_C1_MASK  MAGENTA_C_MASK << 3
#define YELLOW_C1_MASK   YELLOW_C_MASK  << 3
#define WHITE_C1_MASK    WHITE_C_MASK   << 3



#endif
