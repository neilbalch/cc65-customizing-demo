; Imports the code version identifiers into each identifiable memory segment

.segment "ROM_GAME_HEADER"
.incbin "game_header.txt"
.byte 0 ; Spacer/null-terminator byte
