.global read_controller

read_controller:    ; A B SELECT START UP DOWN LEFT RIGHT
    lda #1          ; needed to read 8-bits for 8x times
    sta $20         ; zeropage location = 0x32
    sta $4016       ; set controller to read mode
    lda #0          ; now write a zero
    sta $4016       ; set controllers to low
read_loop:
    lda $4016       ; get all buttons into ACC
    lsr a           ; logical shift A, first bit into the carry flag
    rol $20         ; rol shifts 1 position to the left -> $20 = bit
    bcc read_loop
;   WE ARE FINISHED GETTING INPUTS
    rts
