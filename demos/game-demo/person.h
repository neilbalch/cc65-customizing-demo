
#include <vram.h>
#include <Q9_6.h>

typedef struct person_s {
    Q9_6 xp, yp, xv, yv;
    uint8_t object, pmfa, color;
} person_t;
person_t p;


void draw_person() {
    OBM[p.object].x = Q9_6_to_sint8( p.xp );
    OBM[p.object].y = Q9_6_to_sint8( p.yp );
    OBM[p.object].pattern_config = p.pmfa;
    OBM[0].color = p.color;
}
