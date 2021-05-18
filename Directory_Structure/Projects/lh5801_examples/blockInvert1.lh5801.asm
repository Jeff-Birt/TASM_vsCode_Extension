; Block invert 1, first attempt to invert screen one line at a time.
; It shows the screwy screen mapping of the PC-1500
; You can use the BASIC loader below to POKE it into memory, and RUN it
; Compare assembled program to BASIC loader values
; Program inspired by Pocket Computer Newsletter, Machine Language Programming, 1983
; 
; 300:POKE &78C0,&48,&76,&4A,&00,&05,&BD,&FF,&0E
; 310:POKE &78C8,&5A,&00,&58,&00,&54,&5C,&FF,&99
; 320:POKE &78D0,&05,&BD,&FF,&41,&4E,&4E,&99,&14
; 330:POKE $78D8,&4C,&77,&8B,&04,&48,&77,&9E,&1E,&9A
; 340:INPUT "YOUR MESSAGE?",X$
; 350:CALL &78C0
; 360:FOR X=1 TO 50:NEXT X
; 370:GOTO 350
; 380:END

#define   BRB(n)    &+2-n   ; calculate backward branch
#define   BRF(n)    &+n     ; calculate forward branch

QA_QC    .EQU $76           ; MSB of QA and QC screen buffer block
QB_QD    .EQU $77           ; MSB of QB and QD screen buffer block

.ORG $78C0

; using Sharp Assembler Syntax
begin:
    LDI XH,QA_QC            ; Load Immedate X reg Hi (76h is left half of display)
setPointer:
    LDI XL,$00              ; Load Immedate X reg Low (begining of this half)
loop:
    LDA (X)                 ; Load Accumulator with value in register X
    EAI $FF                 ; XOR Accumulator with X register
    STA (X)                 ; Store inverted version to screen

    LDI YL,$00              ; Init delay counter low
    LDI YH,$00              ; Init delay counter high
wait:
    INC Y                   ; Increment delay counter
    CPI YH,$20              ; If high byte less than $20
    BZR wait                ; loop back
    
    EAI $FF                 ; Invert back to normal
    SIN X                   ; Store A into address X and inc X
    
    CPI XL,$4E              ; Compare XL with immediate value 4Eh
    BZR loop                ; Loop back to 'loop' if above compare != 0
    
    CPI XH,QB_QD            ; Compare XH with immedate value 77H
    BZS done                ; skip ahead if we are done
    
    LDI XH,QB_QD            ; Load XH with immedate value 77H               
    BCH setPointer          ; Branch back to get second half of display
done:
    RTN                     ; Return from subroutine
.END
