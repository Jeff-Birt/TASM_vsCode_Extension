; Memory store --- Load D with 0x55 store to Address pointed to by R(1)
; virtual system RAM, 0x0000 to 0x0039 ->
	
	.org 	$0000			; Start of variable Ram

BEGIN:  
	LDI $0F
	PLO R1
	LDI $00
	PHI R1
	SEX R1
	LDI $55
	STR R1

	.end