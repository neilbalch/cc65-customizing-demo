

; ; stop
; .macro  stp
;         .byte $db
; .endmacro

; ; wait for interrupt
; .macro  wai
;         .byte $cb
; .endmacro




; increment memory with length
.macro  inc_mem         address, length

        .if length < 1                     ; ensure input is valid
        .warning "Bad memory size in inc_mem"
        .exitmacro
        .endif

        .if length = 1
        inc address
        .exitmacro
        .endif

        .local end_inc
        inc address
        bne end_inc            ; increment next if overflow occurred

        inc_mem {address+1}, {length-1}

end_inc:
        .endmacro
