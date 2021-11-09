

.segment "IO"

.export _IN_VBLANK, _CLR_VBLANK_IRQ, CONTROLLER_1, CONTROLLER_2

_IN_VBLANK:
        .byte 1

_CLR_VBLANK_IRQ:
        .byte 0

CONTROLLER_1:
;              a
;              |b
;              ||select
;              |||start
;              ||||up
;              |||||down
;              ||||||left
;              |||||||right
        .byte %0000001

CONTROLLER_2:
;              a
;              |b
;              ||select
;              |||start
;              ||||up
;              |||||down
;              ||||||left
;              |||||||right
        .byte %00000000
