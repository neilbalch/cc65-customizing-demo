; ---------------------------------------------------------------------------
; vectors.s
; ---------------------------------------------------------------------------
;
; Defines the interrupt vector table.

.import    _handle_reset, _handle_irq, _handle_nmi

.segment  "VECTORS"

.addr      _handle_nmi
.addr      _handle_reset
.addr      _handle_irq
