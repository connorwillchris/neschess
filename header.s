.segment "HEADER"
    .byte "NES", $1a    ; iNES header id
    .byte 2             ; 2x 16KiB PRG code
    .byte 1             ; 1x 8 KiB CHR data
    .byte %00000001     ; mapper and mirroring
    .byte $00           ; vertical mirroring
;   the rest of these bytes are set to $00

