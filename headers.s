
.export _ROM_FW_HEADER, _FPGA_FW_HEADER

.segment "FPGA_FW_HEADER"
_FPGA_FW_HEADER:
.incbin "firmware_header.txt"


.byte 0

.segment "ROM_FW_HEADER"
_ROM_FW_HEADER:
.incbin "firmware_header.txt"
.byte 0

.segment "ROM_GAME_HEADER"
.incbin "game_header.txt"
.byte 0
