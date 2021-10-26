; ---------------------------------------------------------------------------
; wait.s
; ---------------------------------------------------------------------------
;
; Wait for interrupt and return

.export  _wait, _stop ; Allow the _wait and _stop symbols to be accessed by
                      ; other modules.

; ---------------------------------------------------------------------------
; Wait for interrupt:  Forces the assembler to emit a WAI opcode ($CB)
; ---------------------------------------------------------------------------

.segment  "CODE" ; Force placement into the CODE memory section.

.proc _wait: near ; Declare a C procedure (function) and tag it for 16-bit
                  ; absolute addressing

           CLI  ; Enable interrupts
.byte      $CB  ; Inserts a WAI opcode, fooling the assembler into inserting an
                ; opcode it doesn't understand by asking it to insert a byte
                ; equating to the WAI opcode here.
           RTS  ; Return to caller

.endproc

; ---------------------------------------------------------------------------
; Stop:  Forces the assembler to emit a STP opcode ($DB)
; ---------------------------------------------------------------------------

.proc _stop: near ; Declare a C procedure (function) and tag it for 16-bit
                  ; absolute addressing

.byte      $DB  ; Inserts a STP opcode, again fooling the assembler.

.endproc
