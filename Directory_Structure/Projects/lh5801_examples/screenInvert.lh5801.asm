; Program to invert screen
; You can use the BASIC loader below to POKE it into memory, and RUN it
; Compare assembled program to BASIC loader values
; Program from Pocket Computer Newsletter, Machine Language Programming, 1983
; 
; 100:POKE &78C0,&48,&76,&4A,&00,&05,&BD,&FF,&41
; 110:POKE &78C8,&4E,&4E,&99,&08,&4C,&77,&8B,&04
; 120:POKE &78D0,&48,&77,&9E,&12,&9A
; 130:INPUT "YOUR MESSAGE?",X$
; 140:CALL &78C0
; 150:FOR X=1 TO 50:NEXT X
; 160:GOTO 140
; 170:END

#define   BRB(n)    &+2-n  ; calculate backward branch
#define   BRF(n)    &+n    ; calculate forward branch

.ORG $78C0

; using Sharp Assembler Syntax
; begin:
;     LDI XH,$76              ; Load Immedate X reg Hi (76h is left half of display)
; dispLR:
;     LDI XL,$00              ; Load Immedate X reg Low (begining of this half)
; loop:
;     LDA (X)                 ; Load Accumulator with value in register X
;     EAI $FF                 ; XOR Accumulator with X register
;     SIN X                   ; Store A into address X and inc X
;     CPI XL,$4E              ; Compare XL with immediate value 4Eh
;     BZR loop                ; Loop back to 'loop' if above compare != 0
;     CPI XH,$77              ; Compare XH with immedate value 77H
;     BZS done                ; skip ahead if we are done
;     LDI XH,$77              ; Load XH with immedate value 77H               
;     BCH dispLR              ; Branch back to get second half of display
; done:
;     RTN                     ; Return from subroutine
; .END

; using Z80 Assembler Syntax
begin:
    LD B,$76                ; Load Immedate X reg Hi (76h is left half of display)
dispLR:
    LD C,$00                ; Load Immedate X reg Low (begining of this half)
loop:
    LD  A,(BC)              ; Load Accumulator with value in register X
    XOR A,$FF               ; XOR Accumulator with X register
    LDI (BC),A              ; Store A into address X and inc X
    CP  C,$4E               ; Compare XL with immediate value 4Eh
    JR  NZ, loop            ; Loop back to 'loop' if above compare != 0
    CP  B,$77               ; Compare XH with immedate value 77H
    JR  Z, done             ; skip ahead if we are done
    LD  B,$77               ; Load XH with immedate value 77H               
    JR  dispLR              ; Branch back to get second half of display
done:
    RET                     ; Return from subroutine
.END