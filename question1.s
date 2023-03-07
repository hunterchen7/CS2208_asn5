		AREA Asn5, CODE, READONLY
		ENTRY
		NOP
UPC	 	DCB "060383755577" 	; UPC code					
		ADR r0,UPC 			; point r0 to UPC, address of the current character from the UPC being accessed
		LDR r1,=-0x480		; check sum, -1152 accounts for the 0x30s in front of our ascii numerals, we add 6*0x30*3 for even bytes, 6*0x30 for odd bytes, 6*0x30*3+6*0x30 = 0x480 = 1152 
		ADD r2,r0,#12 		; where the loop finishes, 12 characters total, 6 odd, 6 even
Loop	LDRB r4,[r0] 		; put even numbers(s) in r4 0,2,4,6,8,10
		LDRB r5,[r0,#1] 	; put odd number(s) in r4 1,3,5,7,9,11
		ADD r4,r4,r4,LSL#1 	; multiply the even number (r4) by 3
		ADD r1,r1,r4 		; add even byte to check sum
		ADD r1,r1,r5 		; add odd byte to check sum, note that the check digit is included here and added as an odd byte
		ADDS r0,r0,#2 		; increment by 2 since we're loading 2 bytes at once
		CMP r0,r2	 		; check if we're still in the loop
		BNE Loop
		MOV r0,#2 			; set r0 to a default value of false
Mod10	SUBS r1,r1,#10 		; subtract 10 from r1 and set flags, looking for Z flag to set r0 to 1, and N flag to exit loop
		MOVEQ r0,#1 		; set r0 to true if we have r1 = 0, which means the check sum is divisible by 10
		BPL Mod10 			; continue the loop while r1 is positive or 0, which means exit when negative
		END