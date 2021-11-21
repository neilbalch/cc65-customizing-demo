
.CODE

.include  "zeropage.inc"
.import __RAM_START__, __RAM_SIZE__     ; Import from arcade.cfg symbols
.import copydata, zerobss, initlib, donelib

.import _reset
.export _game_reset

_game_reset:
        ; Set cc65 argument stack pointer
        lda     #<(__RAM_START__ + __RAM_SIZE__)
        sta     sp
        lda     #>(__RAM_START__ + __RAM_SIZE__)
        sta     sp+1

        ; Initialize memory storage
        jsr zerobss     ; Clear BSS segment
        jsr copydata    ; Initialize DATA segment
        jsr initlib     ; Run constructors

        jsr _reset

        rts
