; The first two bytes of a .prg file provide the loading address for the
; program (low byte, hi byte). We have to tell TASM to put those two bytes in 
; first, i.e. at desired start address - 2. 

       .org $0801 - 2       ;*=$07FF

       .BYTE  $01, $08

; This byte array creates the BASIC line: 10 SYS (2304)
; at the BASIC start address of *=$0801
       .BYTE  $0E, $08, $0A, $00, $9E, $20, $28
       .BYTE  $32, $33, $30, $34, $29, $00, $00, $00

*=$0900       ; alterntive form of .org

start  LDX #$0

cycle  LDA hworld,X
       CMP #0
       BEQ exit
       STA $0400,X
       INX
       JMP cycle
exit   RTS

hworld:
       ;.text "hello world!"
       ;.BYTE 0
       .BYTE $08, $05, $0C, $0C, $0F, $20, $17, $0F
       .BYTE $12, $0C, $04, $21, $00
       .END