
#include <vram.h>
#include <Q9_6.h>

typedef struct person_s {
    Q9_6 xp, yp, xv, yv;
    uint8_t object, pmfa, color;
} person_t;


void draw_person(const person_t * const p);
