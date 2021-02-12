; EFx input test -- output EF input # to Memory @ 0x22
; virtual system RAM, 0x0000 to 0x0039 -> 

	.org 	$0000			; Start of variable Ram

BEGIN:
    LDI $0F
    PLO R1
    LDI $00
    PHI R1
    SEX R1
    B1 	$11	;EF1
    B2	$15	;EF2
    B3	$19	;EF3
    B4	$1D	;EF4
    BR  $07
    LDI	$01
    BR	$1F	;OUTPUT
    LDI $02
    BR 	$1F	;OUTPUT
    LDI $03
    BR	$1F	;OUTPUT
    LDI	$04
    STR R1		;OUTPUT
    BR	$07

    	.end