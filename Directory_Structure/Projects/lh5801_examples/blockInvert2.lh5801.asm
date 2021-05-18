; Block invert 2, Program to invert screen one column at a time
; In this version we try to deal with the screwy screen mapping
; You can use the BASIC loader below to POKE it into memory, and RUN it
; Compare assembled program to BASIC loader values
; Program inspired by Pocket Computer Newsletter, Machine Language Programming, 1983
;
; The LCD buffer is made of two distinct memory blocks $7600-$764D and $7700-$774D.
; These two memory blocks are split into two separate regions which are interleaved. 
; We call these quardrants starting from the left QA, QB, QC, QD. So, QA and QC
; share the same memory block, $7600-$764D, but are physically sperated on LCD
; by QB. In the same manner QC and QD share memory block $7700-$774D.
;
; This makes drawing directly to the screen a more complicated affair. See the
; accompanying diagram,Sharp_PC-1500_LCD_Mapping.png, for a more complete explanation.
; 
; 300:POKE &78C0,&B5,&0F,&AE,&78,&F8,&48,&76,&4A
; 310:POKE &78C8,&00,&05,&AD,&78,&F8,&0E,&44,&05
; 320:POKE &78D0,&AD,&78,&F8,&41,&5A,&00,&58,&00
; 330:POKE $78D8,&54,&5C,&10,&99,&05,&4E,&4E,&99
; 340:POKE $78E0,&18,&4C,&77,&8B,&04,&48,&77,&9E
; 350:POKE $78E8,&22,&A5,&78,&F8,&B7,&F0,&8B,&07
; 360:POKE $78F0,&B5,&F0,&AE,&78,&F8,&9E,&32,$9A,&0F
; 370:INPUT "YOUR MESSAGE?",X$
; 380:CALL &78C0
; 390:FOR X=1 TO 50:NEXT X
; 400:GOTO 380
; 410:END

#define   BRB(n)    &+2-n   ; calculate backward branch
#define   BRF(n)    &+n     ; calculate forward branch

; Two methods to define a lable and assign it a value
QA_QC    .EQU $76           ; MSB of QA and QC screen buffer block
QB_QD    .EQU $77           ; MSB of QB and QD screen buffer block
blckEnd  =    $4E           ; end (LSB) of screen buffer block
delay    =    $10           ; delay * $FF = delay between columns

.ORG $78C0                  ; startign address of our program

; using Sharp Assembler Syntax
begin:
    LDI A,$0F               ; initalize bit mask used to toggle bits on LCD
    STA (bitMask)           ; 'bitMask' address lable defiend at end of code

setQuadAC:
    LDI XH,QA_QC            ; Load Immedate X Hi with QA/QC MSB ($76)
setPointer:
    LDI XL,$00              ; Load Immedate X Low with block LSB (address pointer)
loop:
    LDA (X)                 ; Load Accumulator with screen column bits 0-3 (even address)
    EOR (bitMask)           ; Invert nibble (low inbble QA&QB, high nibble QC&QD)
    STA (X)                 ; Store inverted version to screen
    INC X                   ; Inc screen buffer pointer
    LDA (X)                 ; Load Accumulator with screen column bits 4-6 (odd address)
    EOR (bitMask)           ; Invert nibble (low inbble QA&QB, high nibble QC&QD)
    SIN X                   ; Store A into address X, and inc X

    LDI YL,$00              ; Init delay counter low byte
    LDI YH,$00              ; Init delay counter high byte
wait:
    INC Y                   ; Increment delay counter
    CPI YH,delay            ; If high byte less than dealy setting
    BZR wait                ; loop back

    CPI XL,blckEnd          ; Are we at the end of this memory buffer block?
    BZR loop                ; If not loop back to 'loop' (compare != 0)
    
    CPI XH,QB_QD            ; Are we at end of QB or QD?
    BZS QCQD                ; If so jump ahead. If not we are at end
    LDI XH,QB_QD            ; of QA or QC so we need to change MSB to QB_QD        
    BCH setPointer          ; and branch back to do QB or QD

QCQD:
    LDA (bitMask)           ; If our bitMask is already set to $F0 then
    CPI A,$F0               ; we just finished QC and QD so we are done
    BZS done                ; Go to the end

    LDI A,$F0               ; If bitMask != $F0 then we are on QA&QB
    STA (bitMask)           ; so change bitMask to $F0 and loop back
    BCH setQuadAC           ; to get 2nd half of LCD (QC and QD)

done:
    RTN                     ; Return from subroutine

; Mask used to invert nibbles of display. Quadrants QA&QB have bitMask
; set to $0Fh while quadrants QC&QD have bitMask set to $F0
bitMask:
    .BYTE $0F               ; Mask for low nibble

.END
