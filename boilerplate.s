;
; boilerplate.s
; Samuel Woodbridge
; 7th November 2017
;
; This is an boilerplate designed to compile with the ca65 assembler.
; It will create a working starting point for NES game development.
;
; github.com/WsCandy/6502-boilerplate
;
; Enjoy :)

.segment "INESHDR"                                      ; Define the iNes headers segment (ca65 specific)
    .byte "NES", $1A                                    ; The iNes identifier
    .byte $01                                           ; The number of PRG RAM blocks the game will have
    .byte $01                                           ; The numer of CHR RAM blocks the game will have

.segment "VECTORS"                                      ; Define the vectors segment (ca65 specific)
    .addr NMI, RESET, IRQ_ISR

.segment "CODE"                                         ; Define the main "code" segment (ca65 specific)

.enum                                                   ; Define vars here later

.endenum

.org $C000                                              ; Set the start point for the code $C000 memory location

IRQ_ISR:
    RTI

RESET:                                                  ; Create a reset routine
                                                        ; Turn everyhing off and reset back to default values
SEI                                                     ; Tells the code to ignore
LDA $00                                                 ; Load 00 into the accumilator
STA $2000                                               ; Disables the NMI
STA $2001                                               ; Disabled rendering
STA $4010
STA $4015
LDA $40                                                 ; Loads hex 40 (64 decimal)
STA $4017
CLD                                                     ; Disabled decimal mode
LDX $FF                                                 ; Loads value hex FF (255 decimal)
TXS                                                     ; Initialises the stack

bit $2002

vBlankWait1:                                            ; Loop if everything is not cleared on its frame
    bit $2002
    BPL vBlankWait1

LDA $00                                                 ; Loads 00 into the accumuliator
LDX $00                                                 ; Loads 00 into X

ClearMemoryLoop:                                        ; Start my loop
    STA $0000,x                                         ; Store 00 into accumilator at memory address 0000x
    STA $0100,x                                         ; Store 00 into accumilator at memory address 0100x
    STA $0200,x                                         ; Store 00 into accumilator at memory address 0200x
    STA $0300,x                                         ; Store 00 into accumilator at memory address 0300x
    STA $0400,x                                         ; Store 00 into accumilator at memory address 0400x
    STA $0500,x                                         ; Store 00 into accumilator at memory address 0500x
    STA $0600,x                                         ; Store 00 into accumilator at memory address 0600x
    STA $0700,x                                         ; Store 00 into accumilator at memory address 0700x
    INX                                                 ; Increase x by 1

BNE ClearMemoryLoop                                     ; This will branch through an loop until x is 0
                                                        ; x will be 0 again when the value gets to $FF (255) as it will loop around
                                                        ; Memory locations $0000 - $07FF will be reset to 0

vBlankWait2:                                            ; Loop if everything is not cleared on its frame
    bit $2002
    BPL vBlankWait2
                                                        ; Turn everything back on
LDA %10001000                                           ; Loads binary number 10001000 (decimal 136) to the accumilator
STA $2000                                               ; The the NMI back on
LDA %00011110                                           ; Loads binary number 00011110 (decimal 30) to the accumilator
STA $2001                                               ; Enables rendering

JMP MainGameLoop                                        ; Jump to the main game loop once the reset routine has been completed!

NMI:                                                    ; The NMI (Non Maskable Interupt) happens at the end of every single frame
                                                        ; Push the registers to the stack to preserve them
    PHA                                                 ; This pushes the accumilator the the stack
    TXA                                                 ; This loads whatever is in x to the accumilator
    PHA
    TYA                                                 ; This loads whatever is in y to the accumilator
    PHA

    LDA $00                                             ; Puts 00 into the accumilator
    STA $2003                                           ; Sets the low byte of the RAM address
    LDA $02                                             ; Puts 02 into the accumilator
    STA $4014                                           ; Sets the high byte of the RAM address

    LDA %10001000                                       ; Loads binary number 10001000 (decimal 136) to the accumilator
    STA $2000                                           ; The the NMI back on
    LDA %00011110                                       ; Loads binary number 00011110 (decimal 30) to the accumilator
    STA $2001                                           ; Enables rendering


                                                        ; Pull the registers from the stack and restore them
    PLA                                                 ; Pulls the top stack and puts it in the accumilator
    TAY                                                 ; Puts the pulled value back into y
    PLA
    TAX                                                 ; Puts the pulled value back into x
    PLA
    RTI                                                 ; RTI will put us back in the correct place at the end of the frame

MainGameLoop:

JMP MainGameLoop
