;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $Id: test.lh5801.asm 1.0 2021/03/16
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TASM  test file
; Test all instructions and addressing modes.
; Processor: Sharp lh5801
; Both Sharp syntax and Z80-like syntax checked
;
;      Class bits assigned as follows:
;        Bit-0 = Sharp syntax                (common opcodes == class 3)
;        Bit-1 = Z80   syntax                (common opcodes == class 3)
;        Bit-2 = Sharp syn. Enhanced Branch  (Requires TASM > 3.23 with)
;        Bit-3 = Z80   syn. Enhanced Branch  (R4 rule mode see note1.)
; See TASM manual for info on table structure.
;
; Note1: R4 relative branch rule added to TASM 3.23 by Jeff Birt.
;        Supports the lh5801's separate forward/back branch instructions
;        that take a full unsigned byte as an argument. This modification
;        allows use such as: BZR label_name
;
;        For older version add the following two macros to your project:       
;        #define   BRB(n8)    $+2-n8  ; calculate backward branch
;        #define   BRF(n8)    $+n8    ; calculate forward branch
;        use: BCH- (BRB(label_name)) or BCH+ (BRF(label_name))
;        
;---------------------------------------------------------------------------*/
;
; April. 28,2021
; Jeff Birt
; (Hey Birt!)
;
;

#define equ .equ

n8:         equ 20h
n16:        equ 0584h
dddd:       equ 07h
addr16:     equ $1234
port:       equ 3
imm8:       equ 56h    ;immediate data (8 bits)
offset:     equ 7
offset_neg: equ -7

#define   BRB(n)    $+2-n  ;calcualte backward branch
#define   BRF(n)    n-$    ; calcualte forward branch


begin:
     ADC XL              ; Sharp Syntax
     ADC YL
     ADC UL
     ADC VL
     ADC XH
     ADC YH
     ADC UH
     ADC VH
     ADC (X)
     ADC (Y)
     ADC (U)
     ADC (V)
     ADC (addr16)
     ADC #(X)
     ADC #(Y)
     ADC #(U)
     ADC #(V)
     ADC #(addr16)       ; Sharp Syntax

     ADC A,C             ; Z80 syntax
     ADC A,E
     ADC A,L
     ADC A,n8
     ADC A,B
     ADC A,D
     ADC A,H
     ADC A,M
     ADC A,(BC)
     ADC A,(DE)
     ADC A,(HL)
     ADC A,(MN)
     ADC A,(addr16)
     ADC# A,(BC)
     ADC# A,(DE)
     ADC# A,(HL)
     ADC# A,(MN)
     ADC# A,(addr16)     ; Z80 syntax


     ADI  A,n8            ; Sharp Syntax
     ADI  (X),n8
     ADI  (Y),n8
     ADI  (U),n8
     ADI  (V),n8
     ADI  (addr16),n8
     ADI  #(X),n8
     ADI  #(Y),n8
     ADI  #(U),n8
     ADI  #(V),n8    
     ADI  #(addr16),n8    ; Sharp Syntax

     ADC A,n8             ; Z80 syntax
     ADD (BC),n8
     ADD (DE),n8
     ADD (HL),n8
     ADD (MN),n8
     ADD (addr16),n8
     ADD# (BC),n8
     ADD# (DE),n8
     ADD# (HL),n8
     ADD# (MN),n8
     ADD# (addr16),n8     ; Z80 syntax


     ADR  X              ; Sharp Syntax
     ADR  Y
     ADR  U
     ADR  V              ; Sharp Syntax

     ADD BC,A            ; Z80 syntax
     ADD DE,A
     ADD HL,A
     ADD MN,A            ; Z80 syntax


     AM0                 ; Sharp Syntax
     AM1
     AEX                 ; Sharp Syntax 
     NEX                 ; Z80 syntax


     AND  (X)            ; Sharp Syntax
     AND  (Y)
     AND  (U)
     AND  (V)
     AND  (addr16)
     AND  #(X)
     AND  #(Y)
     AND  #(U)
     AND  #(V)
     AND  #(addr16)      ; Sharp Syntax

     AND A,(BC)          ; Z80 syntax
     AND A,(DE)
     AND A,(HL)
     AND A,(MN)
     AND A,(addr16)
     AND# A,(BC)
     AND# A,(DE)
     AND# A,(HL)
     AND# A,(MN)
     AND# A,(addr16)     ; Z80 syntax
     

     ANI  A,n8            ; Sharp Syntax
     ANI  (X),n8
     ANI  (Y),n8
     ANI  (U),n8
     ANI  (V),n8
     ANI  (addr16),n8
     ANI  #(X),n8
     ANI  #(Y),n8
     ANI  #(U),n8
     ANI  #(V),n8
     ANI  #(addr16),n8    ; Sharp Syntax

     AND A,n8             ; Z80 syntax
     AND (BC),n8
     AND (DE),n8
     AND (HL),n8
     AND (MN),n8
     AND (addr16),n8
     AND# (BC),n8
     AND# (DE),n8
     AND# (HL),n8
     AND# (MN),n8
     AND# (addr16),n8     ; Z80 syntax


backlable:
     ATP                 ; Sharp & Z80 syntax
     ATT                 ; Sharp & Z80 syntax


     ; Older versions of TASM did not have a rule to support the lh5801's
     ; seperate forward/back branch instructions that take a full unsigned byte
     ; argument. TASM 3.23 was modfied by Jeff Birt wiht a new 'R4' rule.
     ; Use : 'BZR label_name'.
     ; Enable with class (-x) Bit-2 = Sharp syntax
     ;                        Bit-3 = Z80   syntax
     ;
     ; For older version of TASM add the following two macros to your project:       
     ; #define   BRB(n8)    $+2-n8  ; calculate backward branch
     ; #define   BRF(n8)    n8-$    ; calculate forward branch
     ; use: BCH- (BRB(label_name)) or BCH+ (BRF(label_name))
     BCH+ (BRF(forlable))    ; Sharp syntax
     BCH- (BRB(backlable))
     BCH  forlable
     BCR+ n8
     BCR- n8
     BCR  forlable
     BCS+ n8
     BCS- n8
     BCS  backlable
     BHR+ n8
     BHR- n8
     BHR  backlable
     BHS+ n8
     BHS- n8              
     BHS  backlable      ; Sharp syntax

     JR+ n8              ; Z80 syntax
     JR- n8
     JR backlable
     JR+ NC,n8
     JR- NC,n8
     JR NC,backlable
     JR+ C,n8
     JR- C,n8
     JR  C,forlable
     JR+ NH,n8
     JR- NH,n8
     JR  NH,forlable
     JR+ H,n8
     JR- H,n8             
     JR  H,forlable      ; Z80 syntax


forlable:
     BII  A,n8           ; Sharp syntax
     BII  (X),n8
     BII  (Y),n8
     BII  (U),n8
     BII  (V),n8
     BII  (addr16),n8
     BII  #(X),n8
     BII  #(Y),n8
     BII  #(U),n8
     BII  #(V),n8
     BII  #(addr16),n8    ; Sharp syntax

     TEST A,n8            ; Z80 syntax
     TEST (BC),n8
     TEST (DE),n8
     TEST (HL),n8
     TEST (MN),n8
     TEST (addr16),n8
     TEST# (BC),n8
     TEST# (DE),n8
     TEST# (HL),n8
     TEST# (MN),n8
     TEST# (addr16),n8    ; Z80 syntax


     BIT  (X)            ; Sharp syntax
     BIT  (Y)
     BIT  (U)
     BIT  (V)
     BIT  (addr16)
     BIT  #(X)
     BIT  #(Y)
     BIT  #(U)
     BIT  #(V)
     BIT  #(addr16)      ; Sharp syntax

     TEST A,(BC)         ; Z80 syntax
     TEST A,(DE)
     TEST A,(HL)
     TEST A,(MN)
     TEST A,(addr16)
     TEST# A,(BC)
     TEST# A,(DE)
     TEST# A,(HL)
     TEST# A,(MN)
     TEST# A,(addr16)    ; Z80 syntax


     BVR+ n8              ; Sharp syntax
     BVR- n8
     BVS+ n8
     BVS- n8
     BZR+ n8
     BZR- n8
     BZS+ n8
     BZS- n8              ; Sharp syntax

     JR+ NV,n8            ; Z80 syntax
     JR- NV,n8
     JR+ V,n8
     JR- V,n8
     JR+ NZ,n8
     JR- NZ,n8
     JR+ Z,n8
     JR- Z,n8             ; Z80 syntax


     CDV                 ; Sharp & Z80 syntax
     CIN                 ; Sharp syntax
     CPI A,(BC)          ; Z80 syntax


     CPA  XL             ; Sharp syntax
     CPA  YL
     CPA  UL
     CPA  VL
     CPA  XH
     CPA  YH
     CPA  UH
     CPA  VH
     CPA  (X)
     CPA  (Y)
     CPA  (U)
     CPA  (V)
     CPA  (addr16)
     CPA  #(X)
     CPA  #(Y)
     CPA  #(U)
     CPA  #(V)
     CPA  #(addr16)      ; Sharp syntax

     CP   A,C            ; Z80 syntax
     CP   A,E
     CP   A,L
     CP   A,N
     CP   A,B
     CP   A,D
     CP   A,H
     CP   A,M
     CP   A,(BC)
     CP   A,(DE)
     CP   A,(HL)
     CP   A,(MN)
     CP   A,(addr16)
     CP#  A,(BC)
     CP#  A,(DE)
     CP#  A,(HL)
     CP#  A,(MN)
     CP#  A,(addr16)     ; Z80 syntax


     CPI  A,n8            ; Sharp syntax
     CPI  XL,n8
     CPI  YL,n8
     CPI  UL,n8
     CPI  VL,n8
     CPI  XH,n8
     CPI  YH,n8
     CPI  UH,n8
     CPI  VH,n8           ; Sharp syntax

     CP  A,n8             ; Z80 syntax
     CP  C,n8
     CP  E,n8
     CP  L,n8
     CP  N,n8
     CP  B,n8
     CP  D,n8
     CP  H,n8
     CP  M,n8             ; Z80 syntax


     DCA  (X)            ; Sharp Syntax
     DCA  (Y)
     DCA  (U)
     DCA  (V)
     DCA  #(X)
     DCA  #(Y)
     DCA  #(U)
     DCA  #(V)           ; Sharp Syntax

     ADCD A,(BC)         ; Z80 syntax
     ADCD A,(DE)
     ADCD A,(HL)
     ADCD A,(MN)
     ADCD A,#(BC)
     ADCD A,#(DE)
     ADCD A,#(HL)
     ADCD A,#(MN)        ; Z80 syntax


     DCS  (X)            ; Sharp Syntax
     DCS  (Y)
     DCS  (U)
     DCS  (V)
     DCS  #(X)
     DCS  #(Y)
     DCS  #(U)
     DCS  #(V)           ; Sharp Syntax

     SBCD A,(BC)         ; Z80 syntax
     SBCD A,(DE)
     SBCD A,(HL)
     SBCD A,(MN)
     SBCD A,#(BC)
     SBCD A,#(DE)
     SBCD A,#(HL)
     SBCD A,#(MN)        ; Z80 syntax


     DEC  A              ; Sharp Syntax
     DEC  XL
     DEC  YL
     DEC  UL
     DEC  VL
     DEC  XH
     DEC  YH
     DEC  UH
     DEC  VH
     DEC  X
     DEC  Y
     DEC  U
     DEC  S              ; Sharp Syntax

     DEC  A              ; Z80 syntax
     DEC  C
     DEC  E
     DEC  L
     DEC  N
     DEC  B
     DEC  D
     DEC  H
     DEC  M
     DEC  BC
     DEC  DE
     DEC  HL
     DEC  MN             ; Z80 syntax


     DRL (X)             ; Sharp Syntax
     DRL #(X)            ; Sharp Syntax

     DRL  A,(BC)         ; Z80 syntax
     DRL# A,(BC)         ; Z80 syntax


     DDR (X)             ; Sharp Syntax
     DDR #(X)            ; Sharp Syntax

     DDR  A,(BC)         ; Z80 syntax
     DDR# A,(BC)         ; Z80 syntax


     EAI  n8              ; Sharp Syntax
     XOR  A,n8            ; Z80 syntax


     EOR  (X)            ; Sharp Syntax
     EOR  (Y)
     EOR  (U)
     EOR  (V)
     EOR  (addr16)
     EOR  #(X)
     EOR  #(Y)
     EOR  #(U)
     EOR  #(V)
     EOR  #(addr16)      ; Sharp Syntax

     XOR  A,(BC)         ; Z80 syntax
     XOR  A,(DE)
     XOR  A,(HL)
     XOR  A,(MN)
     XOR  A,(addr16)
     XOR# A,(BC)
     XOR# A,(DE)
     XOR# A,(HL)
     XOR# A,(MN)
     XOR# A,(addr16)     ; Z80 syntax


     HLT                 ; Sharp Syntax
     HALT                ; Z80 syntax


     INC  A              ; Sharp Syntax
     INC  XL
     INC  YL
     INC  UL
     INC  VL
     INC  XH
     INC  YH
     INC  UH
     INC  VH
     INC  X
     INC  Y
     INC  U
     INC  S              ; Sharp Syntax

     INC  A              ; Z80 syntax
     INC  C
     INC  E
     INC  L
     INC  N
     INC  B
     INC  D
     INC  H
     INC  M
     INC  BC
     INC  DE
     INC  HL
     INC  MN             ; Z80 syntax


     ITA                 ; Sharp Syntax
     INA                 ; Z80 Syntax

     JMP  addr16         ; Sharp Syntax
     LD   PC,addr16      ; Z80 syntax


     LDA  XL             ; Sharp Syntax
     LDA  YL
     LDA  UL
     LDA  VL
     LDA  XH
     LDA  YH
     LDA  UH
     LDA  VH
     LDA  (X)
     LDA  (Y)
     LDA  (U)
     LDA  (V)
     LDA  (addr16)
     LDA  #(X)
     LDA  #(Y)
     LDA  #(U)
     LDA  #(V)
     LDA  #(addr16)      ; Sharp Syntax

     LD  A,C             ; Z80 syntax
     LD  A,E
     LD  A,L
     LD  A,N
     LD  A,B
     LD  A,D
     LD  A,H
     LD  A,M
     LD  A,(BC)
     LD  A,(DE)
     LD  A,(HL)
     LD  A,(MN)
     LD  A,(addr16)
     LD# A,(BC)
     LD# A,(DE)
     LD# A,(HL)
     LD# A,(MN)
     LD# A,(addr16)      ; Z80 syntax


     LDE  X              ; Sharp syntax
     LDE  Y
     LDE  U
     LDE  S              ; Sharp syntax

     LDD  A,(BC)         ; Z80 syntax
     LDD  A,(DE)
     LDD  A,(HL)
     LDD  A,(MN)         ; Z80 syntax


     LDI  A,n8            ; Sharp syntax
     LDI  XL,n8
     LDI  YL,n8
     LDI  UL,n8
     LDI  VL,n8
     LDI  XH,n8
     LDI  YH,n8
     LDI  UH,n8
     LDI  VH,n8
     LDI  S,addr16       ; Sharp syntax

     LD  A,n8             ; Z80 syntax
     LD  C,n8
     LD  E,n8
     LD  L,n8
     LD  N,n8
     LD  B,n8
     LD  D,n8
     LD  H,n8
     LD  M,n8
     LD  SP,addr16       ; Z80 syntax


     LDX  X              ; Sharp syntax
     LDX  Y
     LDX  U
     LDX  V
     LDX  S
     LDX  P              ; Sharp syntax

     LD  BC,BC           ; Z80 syntax can be FD 4A or FD 08 

     LD  BC,DE
     LD  BC,HL
     LD  BC,MN
     LD  BC,SP
     LD  BC,PC           ; Z80 syntax


     LIN  X              ; Sharp syntax
     LIN  Y
     LIN  U
     LIN  S              ; Sharp syntax

     LDI A,(BC)          ; Z80 syntax
     LDI A,(DE)
     LDI A,(HL)
     LDI A,(MN)          ; Z80 syntax


     LOP  UL,n8           ; Sharp Syntax
     DJL  -n8             ; Z80 Syntax


     NOP                 ; Sharp & Z80 syntax


     ORA  (X)            ; Sharp syntax
     ORA  (Y)
     ORA  (U)
     ORA  (V)
     ORA  (addr16)
     ORA  #(X)
     ORA  #(Y)
     ORA  #(U)
     ORA  #(V)
     ORA  #(addr16)      ; Sharp syntax

     OR  A,(BC)          ; Z80 syntax
     OR  A,(DE)
     OR  A,(HL)
     OR  A,(MN)
     OR  A,(addr16)
     OR# A,(BC)
     OR# A,(DE)
     OR# A,(HL)
     OR# A,(MN)
     OR# A,(addr16)      ; Z80 syntax


     ORI  A,n8            ; Sharp syntax
     ORI  (X),n8
     ORI  (Y),n8
     ORI  (U),n8
     ORI  (V),n8
     ORI  (addr16),n8
     ORI  #(X),n8
     ORI  #(Y),n8
     ORI  #(U),n8
     ORI  #(V),n8
     ORI  #(addr16),n8    ; Sharp syntax

     OR  A,n8             ; Z80 syntax
     OR  (BC),n8          
     OR  (DE),n8
     OR  (HL),n8
     OR  (MN),n8
     OR  (addr16),n8
     OR# (BC),n8
     OR# (DE),n8
     OR# (HL),n8
     OR# (MN),n8
     OR# (addr16),n8      ; Z80 syntax


     POP  A              ; Sharp syntax
     POP  X
     POP  Y
     POP  U
     POP  V              ; Sharp syntax
     
     POP  A              ; Z80 syntax
     POP  BC
     POP  DE
     POP  HL
     POP  MN             ; Z80 syntax


     PSH  A              ; Sharp syntax
     PSH  X
     PSH  Y
     PSH  U
     PSH  V              ; Sharp syntax

     PUSH  A             ; Z80 syntax
     PUSH  BC
     PUSH  DE
     PUSH  HL
     PUSH  MN            ; Z80 syntax


     RDP                 ; Sharp Syntax
     REC
     RIE
     ROL
     ROR
     RPU
     RPV
     RTI                 ; Sharp & Z80 Syntax
     RTN                 ; Sharp Syntax

     RCF                 ; Z80 syntax
     DI
     RLA
     RRA
     RET                 ; Z80 syntax


     SBC  XL             ; Sharp syntax
     SBC  YL
     SBC  UL
     SBC  VL
     SBC  XH
     SBC  YH
     SBC  UH
     SBC  VH
     SBC  (X)
     SBC  (Y) 
     SBC  (U)
     SBC  (V)
     SBC  (addr16)
     SBC  #(X)
     SBC  #(Y)
     SBC  #(U)
     SBC  #(V)
     SBC  #(addr16)      ; Sharp syntax

     SBC  A,C            ; Z80 syntax
     SBC  A,E
     SBC  A,L
     SBC  A,N
     SBC  A,B
     SBC  A,D
     SBC  A,H
     SBC  A,M
     SBC  A,(BC)
     SBC  A,(DE) 
     SBC  A,(HL)
     SBC  A,(MN)
     SBC  A,(addr16)
     SBC# A,(BC)
     SBC# A,(DE)
     SBC# A,(HL)
     SBC# A,(MN)
     SBC# A,(addr16)     ; Z80 syntax


     SBI  A,n8            ; Sharp syntax
     SBC  A,n8            ; Z80 syntax


     SDE  X              ; Sharp syntax
     SDE  Y
     SDE  U
     SDE  V              ; Sharp syntax

     LDD (BC),A          ; Z80 syntax
     LDD (DE),A
     LDD (HL),A
     LDD (MN),A          ; Z80 syntax


     SDP                 ; Sharp Syntax
     SEC
     SHL
     SHR
     SIE                 ; Sharp Syntax

     SCF                 ; Z80 Syntax
     SLA
     SRL
     EI                  ; Z80 Syntax


     SIN  X              ; Sharp Syntax
     SIN  Y
     SIN  U
     SIN  V              ; Sharp Syntax

     LDI (BC),A          ; Z80 syntax
     LDI (DE),A
     LDI (HL),A
     LDI (MN),A          ; Z80 syntax


     SJP addr16          ; Sharp Syntax
     CALL addr16         ; Z80 syntax


     SPU                 ; Sharp & Z80 Syntax
     SPV                 ; Sharp & Z80 Syntax


     STA  XL             ; Sharp Syntax
     STA  YL
     STA  UL
     STA  VL
     STA  XH
     STA  YH
     STA  UH
     ;STA  VH  ; same as NOP
     STA  (X)
     STA  (Y)
     STA  (U)
     STA  (V)
     STA  (addr16)
     STA  #(X)
     STA  #(Y)
     STA  #(U)
     STA  #(V)
     STA  #(addr16)      ; Sharp Syntax

     LD C,A              ; Z80 syntax
     LD E,A
     LD L,A
     LD N,A
     LD B,A
     LD D,A
     LD H,A
     ;LD L,A             ; same as NOP
     LD (BC),A
     LD (DE),A
     LD (HL),A
     LD (MN),A
     LD (addr16),A
     LD# (BC),A 
     LD# (DE),A
     LD# (HL),A
     LD# (MN),A
     LD# (addr16),A      ; Z80 syntax


     STX  X              ; Sharp Syntax
     STX  Y
     STX  U
     STX  V
     STX  S
     STX  P              ; Sharp Syntax

     LD BC,BC            ; Z80 syntax
     LD DE,BC
     LD HL,BC
     LD MN,BC
     LD SP,BC
     LD PC,BC            ; Z80 syntax


     TIN                 ; Sharp Syntax
     TTA                 ; Sharp Syntax

     LDI (DE),(BC)       ; Z80 syntax
     LD A,F              ; Z80 syntax


     VCR  n8              ; Sharp Syntax
     VCS  n8              ; Sharp Syntax

     SBR NC,n8            ; Z80 syntax
     SBR C,n8             ; Z80 syntax


     VEJ  (C0)           ; Sharp Syntax
     VEJ  (C2)
     VEJ  (C4)
     VEJ  (C6)
     VEJ  (C8)
     VEJ  (CA)
     VEJ  (CC)
     VEJ  (CE)
     VEJ  (D0)
     VEJ  (D2)
     VEJ  (D4)
     VEJ  (D6)
     VEJ  (D8)
     VEJ  (DA)
     VEJ  (DC)
     VEJ  (DE)
     VEJ  (E0)
     VEJ  (E2)
     VEJ  (E4)
     VEJ  (E6)
     VEJ  (E8)
     VEJ  (EA)
     VEJ  (EC)
     VEJ  (EE)
     VEJ  (F0)
     VEJ  (F2)
     VEJ  (F4)
     VEJ  (F6)
     VEJ  (F8)
     VEJ  (FA)
     VEJ  (FC)
     VEJ  (FE)           ; Sharp Syntax


     SBR (C0)            ; Z80 syntax
     SBR (C2)
     SBR (C4)
     SBR (C6)
     SBR (C8)
     SBR (CA)
     SBR (CC)
     SBR (CE)
     SBR (D0)
     SBR (D2)
     SBR (D4)
     SBR (D6)
     SBR (D8)
     SBR (DA)
     SBR (DC)
     SBR (DE)
     SBR (E0)
     SBR (E2)
     SBR (E4)
     SBR (E6)
     SBR (E8)
     SBR (EA)
     SBR (EC)
     SBR (EE)
     SBR (F0)
     SBR (F2)
     SBR (F4)
     SBR (F6)
     SBR (F8)
     SBR (FA)
     SBR (FC)
     SBR (FE)            ; Z80 syntax


     VHR  n8              ; Sharp Syntax
     VHS  n8
     VMJ  n8
     VVS  n8
     VZR  n8
     VZS  n8              ; Sharp Syntax

     SBR NH,n8            ; Z80 syntax
     SBR H,n8
     SBR n8
     SBR V,n8
     SBR NZ,n8
     SBR Z,n8             ; Z80 syntax


     .end
