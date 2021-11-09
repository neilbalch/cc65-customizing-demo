
.export init_cc65

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
