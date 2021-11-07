#ifndef UTIL_H
#define UTIL_H

#define nop()  __asm__ ("NOP") // NO Operation opcode (http://www.6502.org/users/andre/65k/af65002/af65002opcodes.html)
#define sei()  __asm__ ("SEI") // Enable interrupts (set flag)
#define cli()  __asm__ ("CLI") // Disable interrupts (reset flag)

#endif
