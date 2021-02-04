; The first ype bytes of a .org file provide the loading address for the
; program (low byte, hi byte). We have to 'fake' that here by telling 
; TASM to pop those bytes in before the actual start address of our program. 
; We use'start_address- 2' as are fake starting address.
*=$07FF
       .BYTE  $01, $08
; The following byte array creates the basic line of 
; 10 SYS (2304) , which calls our machine code
*=$0801
       .BYTE  $0E, $08, $0A, $00, $9E, $20, $28
       .BYTE  $32, $33, $30, $34, $29, $00, $00, $00

*=$0900

start  LDX #$0

cycle  LDA hworld,X
       CMP #0
       BEQ exit
       STA $0400,X
       INX
       JMP cycle
exit   RTS

; The C64 uses PETSCII not ASCII so we can't use .text to encode our text as a
; byte array. We have to convert our text to PETSCII values manually.
hworld:
       ;.text "hello world!"
       ;.BYTE 0
       .BYTE $08, $05, $0C, $0C, $0F, $20, $17, $0F
       .BYTE $12, $0C, $04, $21, $00
       .END