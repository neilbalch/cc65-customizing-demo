// Ensures that both the program ROM and game ROM have identical version strings
#pragma code-name ("FIRMWARE_CODE")

#include "int.h"
#include "stop.h"
#include "zero_page.h"

extern const char FPGA_FW_HEADER[];
extern const char ROM_FW_HEADER[];


bool streq( const char * a, const char * b ) {
    uint8_t i = 0;
    while (a[i]==b[i]) {
        if (a[i]==0) // Null-terminator
            return true;
        i++;
    }
    return false;
}

void verify_firmware() {
    if ( streq( FPGA_FW_HEADER, ROM_FW_HEADER ) == false ) {
        stop();
    }
}
