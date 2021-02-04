                        	                
;	Test program for expansion ports 08/19/2001
;	Reads Keypad at $6000 and outputs hex to terminal
;	Debouce addition now working, next steps are decode
;	and getting it to work from interrupt
;	This version uses the RTI, runs fine if reset into
;	expanded mode after bootloading but won't work after
;	power off, power problem later traced to incorrect jumper
;	setting on board!  Duh!                   	                
;	Also flashes LED                     	                
;	Version 5.0


;
;	The following is for .equ's ect
;                        	                
	.org 	$b800			; Start of variable Ram
		
Regbas		.equ	$1000			; control register base address
Key_Loc		.equ	$6000			; address of keypad
Key_Lo_Byte		.BYTE	1			; memory for use by key pad routine
Key_Hi_Byte		.BYTE	1       	; ditto
Key_Lo_Saved	.BYTE	1			; first keypress snapshot
Key_Hi_Saved	.BYTE	1			; ditto
Key_Buffer		.BYTE	1			; for accepted key press storage
Key_Buffer_A	.BYTE	1			; keypad input buffer
Key_Buffer_B	.BYTE	1
Key_Reads		.BYTE	1			; counter for keypad debounce
Debounce		.equ	$06			; # of cycles before keypress accepted
Conversion_Table:	
	.text "0123456789ABCDEF"	; for use in hex_ascii routine
        	
        	

;
;	Program initialization stuff
;
        	
    .org	$8000           
                        
Setup:          
		lds	#$00ff	         	; Top of Users stack area
		ldx	#Regbas				; Register base        
		ldaa	#$07            ; Following 4 lines for LED blink routine
        staa	$28,X           ; Disable SPI and not wired-OR mode
        ldaa	#$08            ;
        staa	$09,X           ; Data direction for port D	                
        jsr	Init_Term			;
        jsr	Init_Keypad			; init for keypad routine
        cli						; enable intterpts

;          
;	Main routine - blinks led and calls terminal output          
;                               
Main:   
		ldx	#Regbas
		ldaa	#$08            ;
        staa	$08,X           ; Turn LED on
;        jsr	Get_Key		      ; check to see if key is pressed
        ldab	Key_Buffer_A	; 
        jsr	Hex_Ascii			; send to term
        ldab	#':'				;
        jsr	Write_2_Term		;
        ldab	Key_Buffer_B	;
        jsr	Hex_Ascii			;
        ldab	#':'			;
        jsr	Write_2_Term		;
        ldab	Key_Buffer		;
        jsr	Write_2_Term		;
        ldab	#$0d			; carriage return
		jsr	Write_2_Term		;
        bsr	Delay           	; about 1 sec delay
        bsr	Delay
        ldaa	#$00        	;
        staa	$08,X       	; Turn LED off
        bsr	Delay           	;
        bsr	Delay
        bra	Main            	; continuious loop
        
        
;        
;	Dealy loop - about 1/2 second        
;  
                      	                
Delay:
        pshx	                ; Save value of X
        ldx	#$0000          	;
Loopx:  
		dex	                	;
        bne	Loopx           	; 
        pulx					; Restore value of X
        rts	                	;


;        
;	Terminal initialization routine        
; 
                      	                
Init_Term:
		clr	$2c,x			; set 8-bits, wake on idle
		ldd	#$3008			; boot-loader loads #$302c
		staa	$2b,x		; 9600 BAUD
		stab	$2d,x		; no interrupts, enable transmitter
		rts  				;
			
	
;	
;	Write to termainl routine - data sent in ascii form from b reg	
;
			
Write_2_Term:	
		brclr	$2e,x,%10000000, Write_2_Term ; wait till buffer is empty
		stab	$2f,x			;
		rts	
			
			
;			
;	Converts data in b reg to ascii and calls Write_2_Term to send to terminal			
;
			
Hex_Ascii:		
		pshb				; Save byte for later
		lsrb				; Converts byte to Ascii
		lsrb				; Starts with high nibble
		lsrb				;
		lsrb				;
		ldy	#Conversion_Table	; Y for use
		aby					; as an index value
		ldab	$00,y		; 
		jsr	Write_2_Term	; ouput Ascii converted byte
		pulb				; Reclaim original byte
		andb	#$0f		; mask for low nibble this time
		ldy	#Conversion_Table	;
		aby					;
		ldab	$00,y		;
		jsr	Write_2_Term	;
		rts					;
		
		
		
;
;	Keypad read routine
;
				
Init_Keypad:
		clr	Key_Lo_Byte			; Initilization stuff for keypad
		clr	Key_Hi_Byte			; routine
		clr	Key_Lo_Saved		;
		clr	Key_Hi_Saved		;
		clr	Key_Buffer_A		; Temp use for degugging
		clr	Key_Buffer_B		; ditto
		ldaa	#Debounce		;
		staa	Key_Reads		;
		bclr	$26,x,%00000011		; set RTI to fastest rate
        ldaa	#%01000000		;
        staa	$24,x			; turn on RTI
        staa	$25,x			; clear interrrupt flag
		rts						;

	.org	$ba00				; memory address for keypad routine
Get_Key:
		bsr	Key_Scan			; get new reading
		ldaa	Key_Lo_Byte		; or new reading with old
		anda	Key_Lo_Saved	; if same key data is present
		staa	Key_Lo_Saved	; it stays, if not it's cleared
		ldaa	Key_Hi_Byte		; AND new reading with old
		anda	Key_Hi_Saved	; if same key data is present
		staa	Key_Hi_Saved	; it stays, if not it's cleared
		dec	Key_Reads			; update debounce counter
		bne	Done				; if it zero debounce is done
		ldaa	Key_Lo_Saved		; save final or'd result in
		staa	Key_Buffer_A		; the buffers for debugging
		ldaa	Key_Hi_Saved		; ditto
		staa	Key_Buffer_B		; ditto
		ldaa	Key_Lo_Byte		; update snapshot with last
		staa	Key_Lo_Saved	; keypad scans
		ldaa	Key_Hi_Byte		;
		staa	Key_Hi_Saved	;
		bsr	Decode				; decode what we just read
		ldaa	#Debounce		; reset debounce counter
		staa	Key_Reads		;
Done	ldx	#Regbas				; clear RTI bit
		ldaa	#%01000000		; ditto
		staa	$25,x			; ditto
		rti					; return
		 
		
		
Key_Scan:	ldaa	#%00001000		; Start the scan on the last column
		bsr	Get_Row_Lo			; Get the low nibble first
		stab	Key_Hi_Byte		; Save it
		lsra					; Now change rows
		bsr	Get_Row_Hi			; Get hi nibble now	
		orab	Key_Hi_Byte		; Or the two together
		stab	Key_Hi_Byte		; Save the result
		lsra					; Start process again for last two rows
		bsr	Get_Row_Lo			;
		stab	Key_Lo_Byte		;
		lsra					;
		bsr	Get_Row_Hi			;
		orab	Key_Lo_Byte		;
		stab	Key_Lo_Byte		;
		rts						;
		
		
Get_Row_Lo
		staa	Key_Loc			; Strobe row indicated by Reg A
		ldab	Key_Loc			; Read data from that row
		clr	Key_Loc				; turn off strobe
		anda	#$0f			; make sure non used bits are zero
		rts						; return	
		
Get_Row_Hi
		staa	Key_Loc			; Strobe row indicated by Reg A
		ldab	Key_Loc			; Read data from that row
		clr	Key_Loc				; turn off strobe
		lslb					; shift data to hi nibble
		lslb					; ditto
		lslb					; ditto
		lslb					; ditto
		rts					; return
		

Decode:		
		ldab	#$0000			; for use later in table lookup
		ldy	#Key_Conv			; ditto
		
		
		ldaa	#%10000000		; test each bit to see if key hit
Hi_Loop		bita	Key_Hi_Saved		; if key hit detected go on to check
		bne 	Scnd_Press		; for 2nd key being pressed
		incb					; increment lookup pointer
		lsra					; move test bit
		bne	Hi_Loop				; continue if not zero
		ldaa	#%01000000		; same as above for low byte
Lo_Loop		bita	Key_Lo_Saved		; but don't test bit 7 yet
		bne 	Scnd_Press		; bit seven is the 2nd key
		incb					;
		lsra					;
		bne	Lo_Loop				;
		
Scnd_Press	aby					; add offset to y for lookup table
		ldaa	Key_Lo_Saved	; test to see of 2nd key pressed
		bpl	Get_Key_Code		; not pressed go get code
		ldab	#$0f			; table offset for 2nd key
		aby						; adjust lookup
		
Get_Key_Code	ldab	$00,y	; Get key value from table
		stab	Key_Buffer		; Save in key buffer
		rts

;	need to not overwrite any currnet key press in buffer and need to ring buzzer
		
Key_Conv:	
	.text "!321@654987#$0%;QWERTYUIOPASDFHJ"	; this does not account for 2nd function yet

	.end