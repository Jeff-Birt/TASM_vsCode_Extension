; Program to increment from 0 to 255
; You can use the BASIC loader below to POKE it into memory, and RUN it
; Compare assembled program to BASIC loader values
; 
; 200:POKE &78C0,&4A,&FF,&B5,&00,&DD,&06,&99,&04
; 210:POKE &78C8,&AE,&78,&CE,&9A,&00,&00,&00,&00
; 220:CALL &78C0
; 230:PRINT PEEK &78CC
; 240:END

#define   BRB(n)    &+2-n  ; calculate backward branch
#define   BRF(n)    &+n    ; calculate forward branch

.ORG $78C0

; using Sharp Assembler Syntax
begin:
    LDI XL,$FF              ; Load XLow Imediate with target value
    LDI A,$00               ; Load A Immediate with starting value
loop:
    INC A                   ; Increment Accumulator
    CPA XL                  ; Compare Accumulator to target in XL
    BZR loop                ; Loop back to 'loop' if not done yet
    
    STA (val)               ; Store last value of A so we can PEEK it
    RTN                     ; Return from subroutine
val:                        ; place marker for saved value
    .BYTE $00
.END

; using Z80 Assembler Syntax
; begin:
;     LD  C,$FF               ; Load XLow Imediate with target value
;     LD  A,$00               ; Load A Immediate with starting value
; loop:
;     INC A                   ; Increment Accumulator
;     CP  A,C                 ; Compare Accumulator to target in XL
;     JR  NZ, loop            ; Loop back to 'loop' if not done yet
;
;     LD (val),A              ; Store last value of A so we can PEEK it
;     RET                     ; Return from subroutine
; val:                        ; place marker for saved value
;     .BYTE $00
; .END