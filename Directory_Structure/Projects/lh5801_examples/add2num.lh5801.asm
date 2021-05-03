; Program to add two numbers without carry, uses memory address for A& variable
; You can use the BASIC loader below to POKE it into memory, and RUN it
; Compare assembled program to BASIC loader values
; Program from Pocket Computer Newsletter, Machine Language Programming, 1983
; 
; 10:POKE &78C0,&B5,&03,&AE,&78,&D0,&EF,&78,&D0,&04,&9A
; 20:CALL &78C0
; 30:PRINT PEEK &78D0
; 40:END

#define   BRB(n)    &+2-n  ; calculate backward branch
#define   BRF(n)    &+n    ; calculate forward branch

.ORG $78C0

; using Sharp Assembler Syntax
; begin:
;     LDI A,$03               ; Load Immedate Accumulator 
;     STA ($78D0)             ; Store Accumulator to address &78D0
;     ADI ($78D0),$04         ; Add No Carry address &78D0 and immediate value &04
;     RTN                     ; Return form subroutine
; .END

; using Z80 Assembler Syntax
begin:
    LD  A,$03               ; Load Immedate Accumulator 
    LD  ($78D0),A           ; Store Accumulator to address &78D0
    ADD ($78D0),$04         ; Add No Carry address &78D0 and immediate value &04
    RET                     ; Return form subroutine
.END