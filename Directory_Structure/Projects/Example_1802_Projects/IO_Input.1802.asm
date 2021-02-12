; I/O Input --- Set R(1)=0x000F, Set X=R(1), Input from data bus to Mem @ R(1)
; N0, N1, N2 indicate the lower nibble of the 6N Output instruction
; virtual system RAM, 0x0000 to 0x0039 -> 

	.org 	$0000			; Start of variable Ram

BEGIN:  
	LDI $0F
	PLO R1
	LDI $00
	PHI R1
	SEX R1
	INP 1

	.end