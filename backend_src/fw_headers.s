; Imports the code version identifiers into each identifiable memory segment
.export _ROM_FW_HEADER, _FPGA_FW_HEADER

.segment "FPGA_FW_HEADER"
_FPGA_FW_HEADER:
.incbin "firmware_header.txt"
.byte 0 ; Spacer/null-terminator byte

.segment "ROM_FW_HEADER"
_ROM_FW_HEADER:
.incbin "firmware_header.txt"
.byte 0 ; Spacer/null-terminator byte
