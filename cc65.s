; Initializes the C runtime environemnt (aka. crt0.s in other projects)
.export init_cc65

; Insired by https://github.com/cc65/cc65/blob/master/libsrc/supervision/crt0.s

.import __RAM_START__, __RAM_SIZE__     ; Import the RAM's properties from
                                        ; linker-generated symbols.

.import copydata, zerobss, initlib, donelib

.include  "zeropage.inc"

.segment "STARTUP"

init_cc65:
; ---------------------------------------------------------------------------
; Set cc65 argument stack pointer

        lda     #<(__RAM_START__ + __RAM_SIZE__)
        sta     sp
        lda     #>(__RAM_START__ + __RAM_SIZE__)
        sta     sp+1

; ---------------------------------------------------------------------------
; Initialize memory storage

        jsr zerobss     ; Clear BSS segment
        jsr copydata    ; Initialize DATA segment
        jsr initlib     ; Run constructors


        rts
