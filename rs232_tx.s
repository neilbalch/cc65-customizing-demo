; ---------------------------------------------------------------------------
; rs232_tx.s
; ---------------------------------------------------------------------------
;
; Write a string to the transmit UART FIFO

.export         _rs232_tx ; Allow the _rs232_tx symbol to be accessed by other
                          ; modules.
.exportzp       _rs232_data: near ; Allow the _rs232_data symbol (marked as
                                  ; being stored in the zero page memory block)
                                  ; to be accessed by other modules.

.define         TX_FIFO $1000    ; Location of the transmit FIFO buffer in
                                 ; memory address space

.zeropage

; Storing the incoming C-string pointer here allows for retrieval of each
; character in the string via the indirect indexed addressing mode.
_rs232_data:    .res 2, $00      ;  Reserve a local zero page pointer

.segment  "CODE"

.proc _rs232_tx: near

; ---------------------------------------------------------------------------
; Store pointer to zero page memory and load first character

        sta     _rs232_data      ;  Set zero page pointer to string address
        stx     _rs232_data+1    ;    (pointer passed in via the A/X registers)
        ldy     #00              ;  Initialize Y to 0
        lda     (_rs232_data)    ;  Load first character

; ---------------------------------------------------------------------------
; Main loop:  read data and store to FIFO until \0 is encountered

loop:   sta     TX_FIFO          ;  Loop:  Store character in FIFO
        iny                      ;         Increment Y index
        lda     (_rs232_data),y  ;         Get next character
        bne     loop             ;         If character == 0, exit loop

; ---------------------------------------------------------------------------
; Append CR/LF to output stream and return

        lda     #$0D             ;  Store CR
        sta     TX_FIFO
        lda     #$0A             ;  Store LF
        sta     TX_FIFO
        rts                      ;  Return

.endproc
