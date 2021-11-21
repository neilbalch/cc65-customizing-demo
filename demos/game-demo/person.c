
#include <vram.h>
#include <Q9_6.h>
#include "person.h"


void draw_person(const person_t * const p) {
    OBM[p->object].x = Q9_6_to_sint8( p->xp );
    OBM[p->object].y = Q9_6_to_sint8( p->yp );
    OBM[p->object].pattern_config = p->pmfa;
    OBM[p->object].color = p->color;
}
