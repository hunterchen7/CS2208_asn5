     AREA prog, CODE, READONLY
     ENTRY
     MOV r0,#2 			; default set to false
UPC	 DCB "013800150738" ; UPC code
	 LDRB r1,UPC 		; get first byte of UPC code
     END