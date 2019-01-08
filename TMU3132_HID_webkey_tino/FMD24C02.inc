;==============================================================================
;IIC transmit subroutine
;==============================================================================
;I2C_start:
;		bsf	SDA

;		bsf	SCL
;		call	Delay3us
;		bcf	SDA
;		call	Delay3us
;		bcf	SCL

;		ret
;=======================================================
;I2C_stop:
;		bcf	SCL
;		bcf	SDA
;		call	Delay3us
;		bsf	SCL
;		call	Delay3us
;		bsf	SDA
;		call	Delay3us
;		ret
;=======================================================
;I2C_Receive_byte:
;		movlw	08h
;		movwf	AnyCountTemp		;read count

;		bsf	SDA
;		nop
;I2C_Receive_byte_Again:
;		call	Delay3us
;		bsf	SCL
;		nop
;		nop
;		bsf	Carry
;		btfss	SDA
;		bcf	Carry
;		rlf	WorkReg,F
		
;		bsf	SDA
;		nop
;		bcf	SCL

;		decfsz	AnyCountTemp,F
;		goto	I2C_Receive_byte_Again
;		ret
;SEND_ACK:

;		bcf	SDA			;send a ACK as low
;		nop
;		nop
;		bsf	SCL
;		call	Delay3us
;		bcf	SCL
;		ret
;=======================================================
;I2C_Send_byte:
;		movlw	08h
;		movwf	AnyCountTemp
;I2C_Send_byte_Again:
;		rlf	WorkReg,F
;		bsf	SDA			;set 1
;		btfss	Carry
;		bcf	SDA			;set 0
;		nop
;		nop
;		bsf	SCL
;		call	Delay3us
;		bcf	SCL

;		decfsz	AnyCountTemp,F
;		goto	I2C_Send_byte_Again
;		bsf	SDA
;		nop
;		nop
;		nop
;		nop
;		bsf	SCL
;		nop
;		nop
;		btfsc	SDA			;24C02 send a low sign to mcu
;		goto	_ErrorACK
;		bcf	SCL
;		bcf	E2PCheckFlag
;		ret
;_ErrorACK:
;		bcf	SCL
;		bsf	E2PCheckFlag	;if 24C02 no return SDA=0, means no ACK, set the flag
;		ret
;=======================================================
;I2C_Send_byte1:
;		movlw	08h
;		movwf	AnyCountTemp
;I2C_Send_byte_Again1:
;		rlf	WorkReg,F
;		bsf	SDA			;set 1
;		btfss	Carry
;		bcf	SDA			;set 0
;		nop
;		nop
;		bsf	SCL
;		call	Delay3us
;		bcf	SCL

;		decfsz	AnyCountTemp,F
;		goto	I2C_Send_byte_Again1
;		bsf	SDA
;		nop
;		nop
;		bsf	SCL
;		nop
;		nop
;	Wait_ACK:
;		btfsc	SDA			;24C02 send a low sign to mcu
;		goto	Wait_ACK
;		bcf	SCL
;		bcf	E2PCheckFlag
;		ret
;==============================================================================
;Function:I2C serial communicate Write
;==============================================================================
;I2C_Send_Nbyte:
;		;clrwdt
;		;movlw	160d		;10ms
;		;call	KeepDelay
;		call	I2C_start
;		movlw	a0h                     ;//////write enable///////////
;		movwf	WorkReg
;		call	I2C_Send_byte
;		btfsc	E2PCheckFlag
;		goto	WriteError

;		movfw	W_I2C_Address
;		movwf	WorkReg
;		call	I2C_Send_byte
;		btfsc	E2PCheckFlag
;		goto	WriteError
;WriteNextByteAgain:
;		movlw	00h
;		movwf	TempReg
;		movwf	TEMP2
;WriteNextByte:
;		call	GetDataToWriteBuffer_EP0	;GetDataToWriteBuffer
;		movwf	WorkReg
;		call	I2C_Send_byte
;		btfsc	E2PCheckFlag
;		goto	WriteError
;	WriteTheNextOneByte:
;		incf	TempReg,F
;		incf	TEMP2,F
;		movlw	08h
;		subwf	TempReg,W
;		btfss	Zero
;		goto	WriteNextByte
;EndWriteTask:
;		call	I2C_stop
;		ret
;WriteError:
;		call	I2C_stop
;		ret
;==============================================================================
;Function:I2C serial communicate Write
;==============================================================================
;I2C_Send_Nbyte_E2PROM512:
;		call	I2C_start
		
;		bcf		Carry
;		rlf     W_I2C_AddressH,W		;if W_I2C_AddressH=1 means EPROM size =512 bytes
;		andlw	00000110b
;		iorlw	a0h                     ;//////E2PROM512 write enable///////////
;		movwf	WorkReg
;		call	I2C_Send_byte			;vaild + device address + a write
;		btfsc	E2PCheckFlag
;		goto	WriteError512
		
;		movfw	W_I2C_Address
;		movwf	WorkReg
;		call	I2C_Send_byte			;address that want to be write
;		btfsc	E2PCheckFlag
;		goto	WriteError512		
;WriteNextByteAgain512:
;		movlw	00h
;		movwf	TempReg					;write 8 bytes
;		movwf	TEMP2
;WriteNextByte512:
;		call	GetDataToWriteBuffer_EP0;GetDataToWriteBuffer		
;		movwf	WorkReg

;		call	I2C_Send_byte			;data that want to be write into E2PROM
;		btfsc	E2PCheckFlag
;		goto	WriteError512
;	WriteTheNextOneByte512:
;		incf	TempReg,F
;		incf	TEMP2,F
;		movlw	08h
;		subwf	TempReg,W
;		btfss	Zero
;		goto	WriteNextByte512
;EndWriteTask512:
;		call	I2C_stop
;		ret
;WriteError512:
;		call	I2C_stop
;		ret 
;==============================================================================
;Function:I2C serial communicate Write
;==============================================================================
;I2C_Send_byte1_E2PROM512:
		;call	I2C_start
		
		;bcf		Carry
		;rlf     W_I2C_AddressH,W
		;andlw	00000110b
		;iorlw	a0h                     ;//////E2PROM512 write enable///////////
		;movwf	WorkReg
		;call	I2C_Send_byte
		;btfsc	E2PCheckFlag
		;goto	E2PROMWriteError
		
		;movfw	W_I2C_Address
		;movwf	WorkReg
		;call	I2C_Send_byte
		;btfsc	E2PCheckFlag
		;goto	E2PROMWriteError
		
		;movfw	DataBuffer0
		;movwf	WorkReg

		;call	I2C_Send_byte
		;btfsc	E2PCheckFlag
		;goto	E2PROMWriteError
;E2PROMWriteError:		
		;call	I2C_stop
		;ret
		
;==============================================================================
;Function:I2C serial communicate Read
;==============================================================================
;I2C_Receive_Nbyte8:
;		call	I2C_start			;//send start//				
;		bcf		Carry
;		rlf     ReadI2CAddressH,W
;		andlw	00000110b
;		iorlw	a0h					;//////Write enable///////////
;		movwf	WorkReg
;		call	I2C_Send_byte

;		movfw	R_I2C_Address		;//address//
;		movwf	WorkReg
;		call	I2C_Send_byte

;	I2C_Read_Nbyte:
;		call	I2C_start
;		bcf		Carry
;		rlf     ReadI2CAddressH,W
;		andlw	00000110b
;		iorlw	a1h					;//////Read enable///////////
;		movwf	WorkReg
;		call	I2C_Send_byte

;		movlw	00h
;		movwf	TempReg

;		call	I2C_Receive_byte	;//read data//
;		call	StoreReceiveData1
;		incf	TempReg,F

;	ReadNextByte:
;		call	SEND_ACK
;		call	I2C_Receive_byte
;		call	StoreReceiveData1

;		incf	TempReg,F
;		movlw	08h
;		subwf	TempReg,W
;		btfss	Zero
;		goto	ReadNextByte
;END_ReceiveTask:
;		call	I2C_stop
;		ret
;==============================================================================
;Function:I2C serial communicate Read
;==============================================================================
;I2C_Receive_Nbyte_E2PROM512:
;		call	I2C_start		;//send start//
;		bcf		Carry
;		rlf     ReadI2CAddressH,W
;		andlw	00000110b
;		iorlw	a0h			;//////Write enable///////////
;		movwf	WorkReg 		
;		call	I2C_Send_byte
		
;		movfw	R_I2C_Address
;		movwf	WorkReg
;		call	I2C_Send_byte
				
;	I2C_Read_Nbyte2:
;		call	I2C_start		;//send start//
;		bcf		Carry
;		rlf     ReadI2CAddressH,W
;		andlw	00000110b
;		iorlw	a1h			;//////Write enable///////////
;		movwf	WorkReg 
;		call	I2C_Send_byte

;		movlw	00h
;		movwf	TempReg		;read 8 bytes

;		call	I2C_Receive_byte
;		call	StoreReceiveData1		;receive a bytes and de-encry, design for mac
;		incf	TempReg,F

;	ReadNextByte2:
;		call	SEND_ACK
;		call	I2C_Receive_byte
;		call	StoreReceiveData1

;		incf	TempReg,F
;		movlw	40h
;		subwf	TempReg,W
;		btfss	Zero
;		goto	ReadNextByte2
;END_ReceiveTask2:
;		call	I2C_stop
;		ret		
;======================================================= 
;==============================================================================
;Function:I2C serial communicate Read
;==============================================================================
;I2C_Receive_byte1_CKE2PROM:
		
		;call	I2C_start		;//send start//								
		;bcf		Carry
		;rlf     ReadI2CAddressH,W
		;andlw	00000110b
		;iorlw	a0h				;//////Write enable///////////
		;movwf	WorkReg
		;call	I2C_Send_byte
		;call	Delay5ms
		;btfsc	E2PCheckFlag
		;goto	WriteError_CKE2ROM
		
		;movfw	R_I2C_Address1
		;movwf	WorkReg
		;call	I2C_Send_byte
		;btfsc	E2PCheckFlag
		;goto	WriteError_CKE2ROM
		
	;I2C_Read_Nbyte3:
		
		;call	I2C_start		;//////read enable////////////				
		;bcf		Carry
		;rlf     ReadI2CAddressH,W
		;andlw	00000110b
		;iorlw	a1h				;//////Write enable///////////
		;movwf	WorkReg
		;call	I2C_Send_byte
		;btfsc	E2PCheckFlag
		;goto	WriteError_CKE2ROM
		
		;movlw	00h
		;movwf	TempReg

		;call	I2C_Receive_byte
		;call	StoreReceiveData1
		;incf	TempReg,F
		

	;ReadNextByte3:
		
		;call	SEND_ACK
		;call	I2C_Receive_byte
		;call	StoreReceiveData1

		;incf	TempReg,F
		;movlw	02h
		;subwf	TempReg,W
		;btfss	Zero
		;goto	ReadNextByte3		
;END_ReceiveTask3: 
		;call	I2C_stop
		;ret	
;WriteError_CKE2ROM:
		;call	I2C_stop
		;ret	
;=======================================================
;StoreReceiveData:
;		movlw	Xram2StartAddress
;     		movwf	Rsr
;     		movfw	TempReg
;     		addwf	Rsr,F
;     		movfw	WorkReg
;     		movwr	Indf
;		ret
;=======================================================
;GetDataToWriteBuffer:				;I2C address process
;		movlw	Xram2StartAddress
;		movwf	Rsr
;     		movfw	TEMP2
;     		addwf	Rsr,F
;		movrw	Indf
;		ret
;=======================================================
;GetDataToWriteBuffer_EP0:				;I2C address process
;		;movlw	48h
;		;movwf	Rsr
;     	;	movfw	TEMP2
;     	;	addwf	Rsr,F
;		;movrw	Indf
	
;		movfw	TEMP2
;		xorlw	00h
;		btfss Zero
;		goto	$+3
;		movrw 48h
;		ret
		
;		movfw	TEMP2
;		xorlw	01h
;		btfss Zero
;		goto	$+3
;		movrw 49h
;		ret
		
;		movfw	TEMP2
;		xorlw	02h
;		btfss Zero
;		goto	$+3
;		movrw 4ah
;		ret
		
;		movfw	TEMP2
;		xorlw	03h
;		btfss Zero
;		goto	$+3
;		movrw 4bh
;		ret

;		movfw	TEMP2
;		xorlw	04h
;		btfss Zero
;		goto	$+3
;		movrw 4ch
;		ret

;		movfw	TEMP2
;		xorlw	05h
;		btfss Zero
;		goto	$+3
;		movrw 4dh
;		ret

;		movfw	TEMP2
;		xorlw	06h
;		btfss Zero
;		goto	$+3
;		movrw 4eh
;		ret

;		movfw	TEMP2
;		xorlw	07h
;		btfss Zero
;		goto	$+2
;		movrw 4fh
;		;clrf	TEMP2	
;		ret
;=======================================================
;I2C_Receive_64byte:
;		call	I2C_start		;//send start//
;		movlw	a0h			;//////Write enable///////////
;		movwf	WorkReg
;		call	I2C_Send_byte1

;		movfw	R_I2C_Address
;		movwf	WorkReg
;		call	I2C_Send_byte1

;	I2C_Read_Nbyte1:
;		call	I2C_start
;		movlw	a1h			;//////read enable////////////
;		movwf	WorkReg
;		call	I2C_Send_byte1

;		movlw	00h
;		movwf	TempReg

;		call	I2C_Receive_byte
;		call	StoreReceiveData1
;		incf	TempReg,F

;	ReadNextByte1:
;		call	SEND_ACK
;		call	I2C_Receive_byte
;		movlw	ffh
;		xorwf	WorkReg,W
;		btfsc	Zero
;		bcf	LED
;		call	StoreReceiveData1

;		incf	TempReg,F
;		movlw	40h
;		subwf	TempReg,W
;		btfss	Zero
;		goto	ReadNextByte1
;		call	I2C_stop
;		ret

;=======================================================
GetSecurityInfo:				;get security data from last page
		;movlw	00h
		;movwf	TempReg
	GetNextSecurity:
		;movfw	R_I2C_Address
		;call	DeviceInfoTable
		;movwf	WorkReg
		;call	StoreReceiveNoEncrytion;StoreReceiveData1
		;incf	R_I2C_Address,F
		;incf	TempReg,F

		;movlw	08h;SecurityKeyLen			;a loop which take data till 8 byte
		;subwf	TempReg,W
		;btfss	Carry
		;goto	GetNextSecurity
		;ret
;=======================================================
Get64ByteInfo:				;get 64bytes data from last page
		movlw	00h
		movwf	TempReg
	GetNextByte:
		movfw	R_I2C_Address			
		call	DeviceInfoTable
		movwf	WorkReg
		call	StoreReceiveData1
		incf	R_I2C_Address,F
		incf	TempReg,F
		movfw	MacURLAddressIndex
		btfss	OSType
		movfw	SecurityKeyIndex				;the lastest URL address
		subwf	R_I2C_Address,W
		btfsc	Carry
		ret
		;movlw	40h;URLAddressLenMinus1			;a loop which take data till URL done
		;btfss	OSType
		;movlw	MacURLAddressLenMinus1
		movlw	40h
		subwf	TempReg,W
		btfss	Carry
		goto	GetNextByte
		ret
;=======================================================
StoreReceiveData1:
		movlw	ReadBuffer
     		movwf	Fsr
     		movfw	TempReg
     		addwf	Fsr,F
     		movfw	WorkReg
     		bsf	RamBank
     		movwf	Indf
     		bcf	RamBank
		
		testz	EncryptionValue
		btfsc	Zero
		ret
		
		incf	PitchXor,1
     	testz   WorkReg
     	btfsc	Zero
		ret
		movlw	01h
     	xorwf	EncryptionValue,W
		btfss	Zero
     	goto    EncryptionCode2
EncryptionCode1:
		movlw	01h
		andwf	PitchXor,W
		btfss   Zero
        goto    XorEncryption
        ret
EncryptionCode2:
		movlw	01h
		andwf	PitchXor,W
		btfss   Zero		
     	ret
XorEncryption:   
        movfw	TempReg
		xorlw	01h
		btfsc	Zero
		nop
  	
     	bsf	RamBank
     	movlw	80h
		xorwf	Indf,F
     	bcf	RamBank 
	     			
		ret
;=======================================================
;Delay3us:
;		nop
;		nop
;		nop
;		nop
;		nop
;		nop
;		ret