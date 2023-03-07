		AREA prog, CODE, READONLY
		ENTRY
		ADR r0,UPC 			; point r0 to UPC
		MOV r1,#0			; check sum
		ADD r2,r0,#12 		; where the loop finishes, 10 characters so end 2 after, not 1 after since we increment by 2
Loop	LDRB r4,[r0] 		; even byte(s) 0,2,4,...
		LDRB r5,[r0,#1] 	; odd byte(s) 1,3,5,...
		ADD r0,r0,#2 		; increment 2 at a time since we're doing 2 bytes at once
		ADD r4,r4,r4,LSL#1 	; multiply r4 by 3
		ADD r1,r1,r4 		; add even byte to check sum
		ADD r1,r1,r5 		; add odd byte to check sum, note that the check digit is included here and added as an odd byte
		CMP r0,r2 			; check if we're still in the loop
		BNE Loop
		SUB r1,r1,#1152 	; accounts for the 0x30s in front of ascii, we add 6*48*3 for even bytes, 6*48 for odd bytes, 6*48*3+6*48 = 1152
		MOV r0,#0 			; set r0 to a default value of false
Mod10	SUBS r1,r1,#10 		; subtract 10 from r1 and set flags, looking for Z flag to set r0 to 1, and N flag to exit loop
		MOVEQ r0,#1 		; set r0 to true if we have r1 = 0
		BPL Mod10 			; continue the loop while r1 is positive or 0, which means exit when negative
UPC		DCB "060383755577" 	; UPC code		
		END