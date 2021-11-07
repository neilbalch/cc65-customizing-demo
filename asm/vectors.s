; ---------------------------------------------------------------------------
; vectors.s
; ---------------------------------------------------------------------------
;
; Defines the interrupt vector table.

.import    _init ; Import knowledge of the _init symbol.
.import    _nmi_int, _irq_int ; Import knowledge of the _nmi_int and _irq_int symbols.

.segment  "VECTORS" ; Force placement into the VECTORS memory section.

; Initialize the important parts of the vector table with the appropriate symbols.
.addr      _nmi_int    ; NMI interrupt vector: $FFFA (low byte) -  $FFFB (high byte)
.addr      _init       ; Reset vector: $FFFC (low byte) -  $FFFD (high byte)
.addr      _irq_int    ; IRQ/BRK interrupt vector: $FFFE (low byte) -  $FFFF (high byte)
