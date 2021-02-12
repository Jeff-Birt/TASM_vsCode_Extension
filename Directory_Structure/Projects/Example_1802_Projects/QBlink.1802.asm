; Q blink --- Q off, load 0x0010 to R(1)
; virtual system RAM, 0x0000 to 0x0039 -> 

	.org 	$0000			; Start of variable Ram

BEGIN:  
	REQ
	LDI $10
	PLO R1
	LDI $00
	PHI R1
	DEC R1
	GLO R1
	BNZ $07
	BQ  $00
	SEQ
	BR  $01

	.end