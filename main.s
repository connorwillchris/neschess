; header, not needed for the official release
.segment "HEADER"
    .byte "NES", $1a ; iNES header id
    .byte 2 ; 2x 16KiB PRG code
    .byte 1 ; 1x 8 KiB CHR data
    .byte $01, $00 ; mapper 0, vertical mirroring

.segment "ZEROPAGE"
;   PUT VARIABLES HERE!

.segment "VECTORS"
    .addr _nmi
    .addr _reset
    .addr 0 ; unused

.segment "STARTUP" ; needed for the linker
.segment "CODE" ; actual code is here

; rn we are doing MICHAEL's code
_reset:

_nmi:

.segment "CHARS"
