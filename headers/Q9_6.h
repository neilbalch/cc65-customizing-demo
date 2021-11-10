// Defines a new type for fixed-point number math. Q9_6 means 9 digits before
// and 6 digits after the decimal
#ifndef Q9_6_H
#define Q9_6_H
#include "int.h"

typedef int16_t Q9_6;

Q9_6 new_Q9_6(int16_t num);
int16_t get_Q9_6(Q9_6 n);

Q9_6 mul(Q9_6 n1, Q9_6 n2);
Q9_6 div(Q9_6 n1, Q9_6 n2);

#endif
