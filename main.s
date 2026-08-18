; header, not needed for the official release
.include "header.s"

;;; other includes here
.include "controller.inc"

;;; END

BYTES_PER_SPRITE    = 4
SPRITES_AMOUNT      = 2 * BYTES_PER_SPRITE ; THE AMOUNT OF BYTES FOR THE NECESSARY SPRITES.

PPU_CTRL            = $2000
PPU_MASK            = $2001
PPU_STATUS          = $2002
PPU_ADDR            = $2006

APU_DMC             = $4010
OAM_DMA             = $4014
FRAME_CTR           = $4017

.segment "ZEROPAGE"

;   PUT VARIABLES HERE!

.segment "VECTORS"
    .addr _nmi
    .addr _reset
    .addr 0 ; unused

.segment "STARTUP"      ; needed for the linker
.segment "CODE"         ; actual code is here

; rn we are doing MICHAEL's code
_reset:
    sei                 ; disable all IRQs
    cld                 ; clear decimal mode, not supported on NES
    ldx #$40            ; setting the 6-bit will...
    stx FRAME_CTR       ; disable the APU frame counter IRQ
    ldx #$ff            ; initialize the stack register
    txs                 ; stack is $ff
    inx                 ; x = $00
    stx PPUCTRL         ; PPUCTRL register, disabling it
    stx PPUMASK         ; do the same for PPUMASK, disable it
    stx APU_DMC         ; disable DMC IRQs
vblankwait_1:           ; the nes should be okay to use now
    bit PPU_STATUS      ; WHAT IS THIS LOCATION?
    bpl vblankwait_1
    txa                 ; END LOOP, x should be $00, so ACC = 0
clearmem:               ; clear memory loop
    sta $0000, x
    sta $0100, x
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x
    lda #$ff            ; sprites should be stored in $0200
    sta $0200, x        ; put it in $0200, for sprite memory
    lda #$00            ; go back to zero, for the rest of the init
    inx                 ; increment x
    bne clearmem        ; then compare x to zero
;   LOOP END

vblankwait_2:           ; second vblank wait loop
    bit PPU_STATUS      ; check if ppu_status is OK
    bpl vblankwait_2

; NOTE: THIS DIFFERS FROM NESHACKER'S CODE...
main:
    lda #$02            ; high byte for range of sprites
    sta OAM_DMA         ; store it to SPR_DMA register
    nop                 ; why burn a cycle? - could also be `lda $2002` maybe
    lda #$3f            ; we want to start writing data to a memory addr...so $3f00
    sta PPU_ADDR        ; put the palette data into PPU_ADDR
    lda #$00
    sta PPU_ADDR        ; now PPU understands where we want to write to.
    ldx #$00            ; initialize X for a loop
load_palettes:          ; load all the palettes, which are hardcoded rn
    lda palette_data, x
    sta $2007           ; store into PPUADDR
    inx                 ; increment the index
    cpx #32             ; 32 palettes
    bne load_palettes
    ldx #$00

load_sprites:           ; will get all sprites
    lda bishop_sprite, x
    sta $0200, x        ; store them into $0200 to init our sprites
    inx                 ; increment the index

    cpx #SPRITES_AMOUNT ; 32 bytes = 4*8 bytes, where 8 is tiles required

    bne load_sprites
;   LOOP END

turn_on_drawing:
;   lda #%10010000      ; uses the second screen entirely with bank 2 (UNUSED)
    lda #%10010000      ; TODO: TRY THIS CODE ... Enable NMI
    sta PPU_CTRL        ; now turn on drawing officially
;   lda #%00011110      ; turn on drawing of background and sprites (UNUSED)
    lda #%00011110      ; TODO: CHECK IF THIS WORKS
    sta PPU_MASK        ; store in PPU_MASK
;   enter game loop
forever_loop:
    jmp forever_loop

;   every NMI, do this code...
_nmi:
    lda #$02            ; copy sprite data from $0200 => PPU mem
    sta OAM_DMA         ; DONE
    rti

;   palette data can be here
;   NOTE: copied directly from MICHAEL's code
palette_data:
    .byte $22, $29, $1a, $0f ; background palette data
    .byte $22, $36, $17, $0f
    .byte $22, $30, $21, $0f
    .byte $22, $27, $17, $0f

    .byte $22, $16, $27, $18 ; sprite palette data
    .byte $22, $1A, $30, $27
    .byte $22, $16, $30, $27
    .byte $22, $0f, $36, $17

bishop_sprite:
;         Y    ID   ATTR X
    .byte $08, $01, $00, $01 ; x4
    .byte $10, $02, $00, $01 ; x8

;   divided into two "banks" ...
;   a high bit and a low bit
.segment "CHARS"
    .incbin "assets/chess.chr"
