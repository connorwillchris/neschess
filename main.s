; header, not needed for the official release
.segment "HEADER"
    .byte "NES", $1a ; iNES header id
    .byte 2 ; 2x 16KiB PRG code
    .byte 1 ; 1x 8 KiB CHR data
    .byte $01 ; mapper 0
    .byte $00 ; vertical mirroring

;   the rest of these bytes are set to zero

.segment "ZEROPAGE"
;   PUT VARIABLES HERE!

.segment "VECTORS"
    .addr _nmi
    .addr _reset
    .addr 0 ; unused

.segment "STARTUP" ; needed for the linker
.segment "CODE" ; actual code is here

;   rn we are doing MICHAEL's code
_reset:
    sei ; disable all IRQs
    cld ; clear decimal mode, not supported on NES
    ldx #$40 ; setting the 6-bit will...
    stx $4017 ; disable the APU frame counter IRQ
;   initialize the stack register
    ldx #$ff ; top of stack
    txs ; stack is $ff
    inx ; x = $00
    stx $2000 ; PPUCTRL register, disabling it
    stx $2001 ; do the same for PPUMASK, disable it
    stx $4010 ; disable DMC IRQs
;   the nes should be okay to use now
vblankwait_1:
    bit $2002
    bpl vblankwait_1
    txa ; END LOOP, x should be $00, so ACC = 0
clearmem:
    sta $0000, x 
    sta $0100, x
;   sprites should be stored here in $0200
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x
;   load sprite mem for $0200
    lda #$ff
    sta $0200, x ; put it in $0200, for sprite memory
    lda #$00 ; go back to zero, for the rest of the init
    inx ; increment x
    bne clearmem ; then compare x to zero
    ; END LOOP
vblankwait_2:
    bit $2002
    bpl vblankwait_2
; NOTE: THIS DIFFERS FROM NESHACKER'S CODE...
main:
    lda #$02 ; high byte for range of sprites
    sta $4014 ; store it to SPR_DMA register
    nop ; why burn a cycle? - could also be `lda $2002` maybe
    lda #$3f ; we want to start writing data to a memory addr...so $3f00
    sta $2006
    lda #$00
    sta $2006 ; now PPU understands where we want to write to
    ldx #$00 ; init X for a loop
load_palettes: ; load all the palettes, which are hardcoded rn
    lda palette_data, x
    sta $2007 ; store into PPUADDR
    inx ; increment the index
    cpx #32 ; 32 palettes
    bne load_palettes
;   1 byte is the Y coord
;   2 byte is the tile to display: index
;   3 byte is kinda complicated
;   4 byte is the X coord
    ldx #$00
load_sprites:
    lda sprite_data, x ; will get all sprites
    sta $0200, x ; store them into $0200 to init our sprites
    inx ; increment the index
    cpx #32 ; 32 bytes = 4*8 bytes, where 8 is tiles required
    bne load_sprites
;   LOOP END

turn_on_drawing:
;   TURN ON DRAWING
;   lda #%10010000 ; uses the second screen entirely with bank 2
    lda #%10010000 ; TODO: TRY THIS CODE ... Enable NMI
    sta $2000 ; now turn on drawing officially
;   lda #%00011110 ; turn on drawing of background and sprites
    lda #%00011110 ; TODO: CHECK IF THIS WORKS
    sta $2001

;   enter game loop
forever_loop:
    jmp forever_loop

;   every NMI, do this code...
_nmi:
    lda #$02 ; copy sprite data from $0200 => PPU mem
    sta $4014 ; DONE
    rti

;   palette data can be here
;   NOTE: copied directly from MICHAEL's code
palette_data:
    .byte $22, $29, $1A, $0F
    .byte $22, $36, $17, $0F
    .byte $22, $30, $21, $0F
    .byte $22, $27, $17, $0F  ;background palette data

    .byte $22, $16, $27, $18
    .byte $22, $1A, $30, $27
    .byte $22, $16, $30, $27
    .byte $22, $0F, $36, $17  ;sprite palette data

sprite_data: ; sprite data for mario
    .byte $08, $00, $00, $08
    .byte $08, $01, $00, $10
    .byte $10, $02, $00, $08
    .byte $10, $03, $00, $10
    .byte $18, $04, $00, $08
    .byte $18, $05, $00, $10
    .byte $20, $06, $00, $08
    .byte $20, $07, $00, $10

.segment "CHARS" ; divided into two "banks" - a high bit and a low bit
    .incbin "assets/hellomario.chr"
