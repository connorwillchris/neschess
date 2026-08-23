.global read_controller

JOYPAD1             = $4016
.importzp controller_1_down, controller_1_pressed

read_controller:    ; A B SELECT START UP DOWN LEFT RIGHT
    lda controller_1_down          ; needed to read 8-bits for 8x times
    tay
    sta JOYPAD1       ; set controller to read mode
    sta controller_1_down          ; zeropage location = 0x32
    lsr
    sta JOYPAD1       ; set controllers to low
@loop:
    lda JOYPAD1
    lsr
    rol controller_1_down
    bcc @loop
    tya 
    eor controller_1_down
    and controller_1_down
    sta controller_1_pressed
    rts
