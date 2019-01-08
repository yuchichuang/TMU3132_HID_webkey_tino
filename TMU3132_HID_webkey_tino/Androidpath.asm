

PrepareData_Android:
		btfsc	AndroidURLDoneFlag
		goto	ThirdSendKey
		
		btfss	DataInFlag1
		ret
		btfsc	OneFlag
		ret
		bsf	TransFlag
		bsf	OneFlag
		btfsc	PlugFlag
		ret
		
		movfw	ScanNumber
		call	GetKeyValuePro_Android
		movwf	UsbKeyBuffer2
		movlw	E1h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue0_android

		movlw	02h					;AC Home
		movwf	UsbKeyBuffer2
		incf	ScanNumber,F
		ret
		
ThirdSendKey:
		movfw	ScanNumber
		xorwf	table0x51addr_add5,W
		btfss	Zero
		goto	No0x51LOOP
		
		movlw 09h
		subwf gTempVar0,W
		btfsc Carry
		
		;yes bigger
		goto No0x51LOOP
		
		;no smaller
		movfw table0x51addr
		movwf 	ScanNumber
No0x51LOOP:		
		movfw	ScanNumber
		call	GetThirdKeyValue_Android
		movwf	UsbKeyBuffer2
		movlw	EBh
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue0_android

		btfsc setting0x51addrFlag
		goto $+7
		movfw 	ScanNumber
		movwf	table0x51addr
		movwf	table0x51addr_add5
		movlw	06h
		addwf	table0x51addr_add5,F
		bsf setting0x51addrFlag
		
		incf gTempVar0,F
		clrf	UsbKeyBuffer2
		movlw	51h					;0x51 'down arrow key'
		movwf	UsbKeyBuffer3		
		incf	ScanNumber,F
		ret	
		
	NormalKeyValue0_android:
		movlw	E2h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue01_android
		;movlw	01h    				;AC Search	
		;movwf	UsbKeyBuffer2
		bsf	ReportIDFlag
			
		movlw	08h    				;gui	
		movwf	UsbKeyBuffer2
		movlw	05h    				;B	
		movwf	UsbKeyBuffer3	
		incf	ScanNumber,F 
		ret		
	NormalKeyValue01_android:						
		movlw	E3h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue02_android
		bsf		ReportIDFlag
		call	WaitforLangSwitch
		clrf	UsbKeyBuffer2			;remember clrf UsbKeyBuffer2
		clrf	UsbKeyBuffer3	
		ret
	NormalKeyValue02_android:						
		movlw	E4h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue03_android
		;bsf	ReportIDFlag
		clrf	UsbKeyBuffer2
		movlw	28h					;enter
		movwf	UsbKeyBuffer3
		incf	ScanNumber,F
		ret		
	NormalKeyValue03_android:						
		movlw	E5h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue04_android
		bcf	ReportIDFlag
		movlw	01h    				;AC Search	
		movwf	UsbKeyBuffer2

		incf	ScanNumber,F		
		ret

	NormalKeyValue04_android:						
		movlw	E6h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue05_android
				
		movlw	04h    				;alt	
		movwf	UsbKeyBuffer2
		movlw	07h    				;D	
		movwf	UsbKeyBuffer3	
		incf	ScanNumber,F	
		ret	
	NormalKeyValue05_android:						
		movlw	E7h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue06_android
		;bsf	ReportIDFlag
		clrf	UsbKeyBuffer2
		;movlw	4fh					;right
		;movwf	UsbKeyBuffer3
		call	Set_LedState			;detect led status and let NumLock and CapsLock on		
		incf	ScanNumber,F	
		ret			
	NormalKeyValue06_android:						
		movlw	E8h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue07_android
		;bsf	ReportIDFlag
		;clrf	UsbKeyBuffer2
		movlw	01h    				;ctrl	
		movwf	UsbKeyBuffer2
		movlw	0fh    				;L	
		movwf	UsbKeyBuffer3	
		incf	ScanNumber,F	
		ret			

;third 
	NormalKeyValue07_android:						
		movlw	E9h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue08_android
		clrf	UsbKeyBuffer2
		movlw	65h					;0x65
		movwf	UsbKeyBuffer3	
		incf	ScanNumber,F	
		ret
	NormalKeyValue08_android:						
		movlw	EAh
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue09_android
		clrf	UsbKeyBuffer2
		movlw	2bh					;tab
		movwf	UsbKeyBuffer3
		incf	ScanNumber,F	
		ret
	NormalKeyValue09_android:						
		movlw	ECh
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue10_android
		clrf	UsbKeyBuffer2
		movlw	4fh					;0x4f 'right arrow key'
		movwf	UsbKeyBuffer3
		incf	ScanNumber,F	
		ret			
;third
		
	NormalKeyValue10_android:
;	NormalKeyValue09_android:
		clrf	UsbKeyBuffer0
		incf	ScanNumber,F
		movlw	AndroidWebLength
		btfsc AndroidURLDoneFlag
		movlw AndroidThirdLength
		subwf	ScanNumber,W
		btfss	Carry
		ret
		clrf	ScanNumber
		bcf	EndTransFlag
		bcf	DataInFlag1
		bcf	GUIFlag
		bcf	OneFlag
		ret
		

DataTransfer1_android:
		btfsc AndroidURLDoneFlag
		goto SendDataReport_android
		
		btfsc	TransFlag
		goto	SendDataReport_android
		ret
  SendDataReport_android:
  		btfsc	Tx1Rdy
  		ret
		
		movlw	02h				;report id = 2
		btfsc	ReportIDFlag
		movlw	01h
		movwr	Tx1FifoReg0
		
  		movfw	UsbKeyBuffer2
  		movwr	Tx1FifoReg1
  		movfw	UsbKeyBuffer3
  		movwr	Tx1FifoReg3
  		movfw	UsbKeyBuffer4
  		movwr	Tx1FifoReg4;
  		movfw	UsbKeyBuffer5
  		movwr	Tx1FifoReg6;
  		movlw	00h
  		;movwr	Tx1FifoReg1
  		;movwr	Tx1FifoReg5
		movwr	Tx1FifoReg2
		;movwr	Tx1FifoReg3
		;movwr	Tx1FifoReg4
		;movwr	Tx1FifoReg5
  		movwr	Tx1FifoReg6
  		movwr	Tx1FifoReg7
  		movwf	UsbKeyBuffer3
  		;movwf	UsbKeyBuffer4
		;movwf   UsbKeyBuffer5

 		movlw	f0h
 		andwf	Tx1Reg,F
		
		movlw	02h
		btfsc	ReportIDFlag
 		movlw	08h
		iorwf	Tx1Reg,F
		movlw	40h
		xorwf	Tx1Reg,F
		bsf	Tx1Rdy

		bcf	OneFlag
  		bcf	TransFlag

		clrf	UsbKeyBuffer0
		clrf	UsbKeyBuffer2
  		clrf	UsbKeyBuffer3
		
		
		btfss AndroidURLDoneFlag
		ret
		call DelaySendKeyRoutine
		testz ScanNumber
		btfss	Zero
		ret
		bcf	DeviceR
		sleep
		goto $-1
		
		ret	

DelaySendKeyRoutine:
		movlw	40h
		btfsc	AndroidOSFlag
		movlw	80h;c0h
		btfsc AndroidURLDoneFlag
		movlw	30h
		movwf	gTempVar3
		movwf	gTempVar4
DelaySendKey_sub:	
		decf 	gTempVar4,F
		btfss	Zero
		goto	$-2
		decf 	gTempVar3,F
		btfss	Zero
		goto	DelaySendKey_sub
		clrf	gTempVar3
		clrf	gTempVar4
		ret
		
;---------------------------------------------		
		org 0b00h
;---------------------------------------------		
.TABLE		
GetKeyValuePro_Android:
		addwf	Pcl,F
	AndroidArray_start:
		retlw	00h
		retlw	00h
		retlw	E1h			;	AC Home
		retlw	00h
		retlw	00h
		retlw	E3h
		retlw	00h 
		retlw	00h			
		retlw	00h
		retlw	E7h			;	detect SetLed
		retlw	00h
		retlw	00h			
		retlw	00h
		retlw	E3h
		retlw	00h
		retlw	00h	
		retlw	E2h			;	win+b
		retlw	00h
		retlw	00h			
		retlw	00h
		retlw	E3h
		retlw	00h
		retlw	00h

		retlw	E4h			;	enter
		retlw	00h
		retlw	00h	
		retlw	E3h
		retlw	00h
		retlw	00h
		
		retlw	E4h			;	enter
		retlw	00h
		retlw	00h	
		retlw	E3h
		retlw	00h
		retlw	00h		
		
		retlw	E4h			;	enter
		retlw	00h
		retlw	00h	
		retlw	E3h
		retlw	00h
		retlw	00h
		
		retlw	E5h			;	AC search
		retlw	00h
		retlw	00h
		retlw	E3h
		retlw	00h
		retlw	00h	

		retlw	E8h			;	ctrl+L
		retlw	00h
		retlw	00h
		retlw	E3h
		retlw	00h
		retlw	00h	

		retlw	E6h			;	alt+D
		retlw	00h
		retlw	00h
		retlw	E3h
		retlw	00h
		retlw	00h			
	AndroidArray_end:
.ENDTABLE		

.TABLE		
GetThirdKeyValue_Android:
		addwf	Pcl,F
	AndroidThird_start:
		retlw	00h
		retlw	00h
		retlw	E9h			;	0x65
		retlw	00h
		retlw	00h
		retlw	E3h
		retlw	00h 
		retlw	00h			
		retlw	00h
		retlw	ECh			;	tab
		retlw	00h
		retlw	00h			
		retlw	00h
		retlw	E3h
		retlw	00h
		retlw	00h	
		retlw	EBh			;	0x51 ;table0x51addr
		retlw	00h
		retlw	00h			
		retlw	00h
		retlw	E3h
		retlw	00h
		retlw	00h

		retlw	E4h			;	enter
		retlw	00h
		retlw	00h	
		retlw	E3h
		retlw	00h
		retlw	00h
		
		retlw	EAh			;	tab
		retlw	00h
		retlw	00h	
		retlw	E3h
		retlw	00h
		retlw	00h		
		
		retlw	EAh			;	tab
		retlw	00h
		retlw	00h	
		retlw	E3h
		retlw	00h
		retlw	00h
		
		retlw	E4h			;	enter
		retlw	00h
		retlw	00h
		retlw	E3h
		retlw	00h
		retlw	00h	

		
	AndroidThird_end:
.ENDTABLE