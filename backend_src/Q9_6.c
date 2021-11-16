
#pragma code-name ("FIRMWARE_CODE")

#include "Q9_6.h"

// https://github.com/ucsbieee/arcade/blob/main/assembly-level/src/firmware/subroutines/Q9_6.asm

Q9_6 sint8_to_Q9_6(sint8_t num) {
    // TODO
    Q9_6 out = num;
    out <<= 6;
    return out;
}

Q9_6 sint16_to_Q9_6(sint16_t num) {
    // TODO
    return (num << 6);
}

sint8_t Q9_6_to_sint8(Q9_6 num) {
    // TODO
    return (num >> 6);
}

sint16_t Q9_6_to_sint16(Q9_6 num) {
    // TODO
    return (num >> 6);
}

Q9_6 mul(Q9_6 n1, Q9_6 n2) {
    // TODO
    return ((sint32_t)n1 * (sint32_t)n2) >> 6;
}

Q9_6 div(Q9_6 n1, Q9_6 n2) {
    // TODO
    return (n1 / (n2 >> 6));
}
