; ---------------------------------------------------------------------------
; crt0.s
; ---------------------------------------------------------------------------
;
; Startup code for cc65 (Single Board Computer version)



; ========= Helper Macros ========= ;

; increment memory with length
.macro  inc_mem         address, length

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





; ========= Code ========= ;


.export   _handle_reset, _handle_irq, _handle_nmi
.import   _reset, _do_logic, _fill_vram
.import _CLR_VBLANK_IRQ, _IN_VBLANK

.import _verify_firmware, init_cc65

.export   __STARTUP__ : absolute = 1

.importzp _FRAME

.segment "STARTUP"

.include  "zeropage.inc"
.import __RAM_START__, __RAM_SIZE__     ; Import from arcade.cfg symbols
.import copydata, zerobss, initlib, donelib


; NMI (disabled)
_handle_nmi:
        rti



; reset, program entry point
_handle_reset:


        sei                     ; disble irq by default
        ldx #$ff                ; Initialize stack pointer to $01ff
        txs
        cld                     ; Clear decimal mode

        ;  reset frame counter
        lda #$ff
        sta _FRAME
        sta _FRAME+1
        sta _FRAME+2
        sta _FRAME+3

        ; verify firmware is correct
        jsr _verify_firmware

        ; Set cc65 argument stack pointer
        lda     #<(__RAM_START__ + __RAM_SIZE__)
        sta     sp
        lda     #>(__RAM_START__ + __RAM_SIZE__)
        sta     sp+1

        ; Initialize memory storage
        jsr zerobss     ; Clear BSS segment
        jsr copydata    ; Initialize DATA segment
        jsr initlib     ; Run constructors

        ; game reset
        jsr _reset

; game loop
next_frame:    ; handle frame timing
        inc_mem {_FRAME}, {4}   ; increment frame count
        jsr _do_logic           ; do non-vram logic

        wai                     ; wait for interrupt
        cli                     ; enable irq (irq is immediately handled)
        jsr _fill_vram          ; enter fill_vram with interrupts on
        sei                     ; disble irq
        jmp next_frame          ; repeat




; IRQ
_handle_irq:
_vblank_irq:    ; wait for vblank; clear irq and return
        pha

check_if_in_vblank:
        stz _CLR_VBLANK_IRQ     ; clear interrupt
        lda _IN_VBLANK
        bne in_vblank          ; if in vblank, return
        wai                     ; otherwise,    wait for next interrupt,
        jmp check_if_in_vblank ;               check if in vblank again

in_vblank:
        pla
        rti
