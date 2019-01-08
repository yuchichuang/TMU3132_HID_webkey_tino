
;==================================================================================================
		org	0000h			;Reset Vector
;==================================================================================================

 		goto	Start

;==================================================================================================
		org	0001h			;Interrupt Vector
;==================================================================================================
		goto	INT_Rc0
		goto	INT_Out0
		goto	INT_Tx0
		goto	INT_Tx1
		goto	INT_Tx2
		goto	INT_Susp
		goto	INT_Tx3
		goto	INT_Rc4

		goto	INT_Rst
		goto	INT_Rsm
		goto	INT_WakeupTimer
		goto	INT_Timer0
		goto	INT_PB0ExternalIO

;==============================================================================
;==============================================================================
INT_Rc0:					;SETUP Command
		movwf	BackupW
		movfw	Psw
		movwf	BackupPSW

		clrf	Tx0Reg

		movlw	7fh
		movwf	Int0Reg
		;bcf	Set0i
		bsf	gbRc0Flag
		bcf	Ep0Stall

		movfw	BackupPSW
		movwf	Psw
		movfw	BackupW
		reti

INT_Out0:					;Received DATA
		movwf	BackupW
		movfw	Psw
		movwf	BackupPSW

		movlw	bfh
		movwf	Int0Reg
	;	bcf	Out0i
		btfsc	WriteE2EROMFlag	
		bsf	gbOut0Flag
		movrw	Rc0Cnt
		andlw	02h
		btfsc	Zero
		goto	$+3
		movrw	Out1FifoReg;Out0FifoReg			;if Rc0Cnt=1, it is SetLed data here
		movwf	UsbLedDataTemp
		movfw	BackupPSW
		movwf	Psw
		movfw	BackupW
		reti

INT_Tx0:					;Send DATA
		movwf	BackupW
		movfw	Psw
		movwf	BackupPSW

		movlw	dfh
		movwf	Int0Reg

	;	bcf	Tx0i
		bsf	gbTx0Flag

		movfw	BackupPSW
		movwf	Psw
		movfw	BackupW

		reti

INT_Tx1:
		movwf	BackupW
		movfw	Psw
		movwf	BackupPSW

		movlw	efh
		movwf	Int0Reg

	;	bcf	Tx1i
	;	bsf	gbTx1Flag

		movfw	BackupPSW
		movwf	Psw
		movfw	BackupW
		reti

INT_Tx2:
		movwf	BackupW
		movfw	Psw
		movwf	BackupPSW

		movlw	f7h
		movwf	Int0Reg

	;	bcf	Tx2i
		bsf	gbTx2Flag

		movfw	BackupPSW
		movwf	Psw
		movfw	BackupW
		reti

INT_Tx3:
		movwf	BackupW
		movfw	Psw
		movwf	BackupPSW

		movlw	fdh
		movwf	Int0Reg

	;	bcf	Tx3i
	;	bsf	gbTx3Flag

		movfw	BackupPSW
		movwf	Psw
		movfw	BackupW
		reti

INT_Rc4:
		movwf	BackupW
		movfw	Psw
		movwf	BackupPSW

		movlw	feh
		movwf	Int0Reg

	;	bcf	Rc4i
	;	bsf	gbRc4Flag

		movfw	BackupPSW
		movwf	Psw
		movfw	BackupW
		reti

INT_WakeupTimer:
		movwf	BackupW
		movfw	Psw
		movwf	BackupPSW

		movlw	dfh
		movwf	Int1Reg

	;	bcf	Wkti
		bsf	gbWktFlag

		movfw	BackupPSW
		movwf	Psw
		movfw	BackupW
		reti

INT_Timer0:
		movwf	BackupW
		movfw	Psw
		movwf	BackupPSW

		movlw	feh
		movwf	Int1Reg
	;	bcf	Timer0i
		bsf	gbTm0Flag
		incf	TimerRollOver,F

		btfss	W7StartCount		;entry time: set report
		goto	$+18
		btfsc	FriPlugEnd
		goto	$+16		
		movlw	01h
		xorwf	CounterHead2,W
		btfsc	Zero
		goto	$+6
		incf	CounterHead,F
		testz	CounterHead
		btfsc	Zero
		incf	CounterHead2,F
		goto	$+7
		clrf	TimerRollOver
		movlw	04h					;3x delay for send key
		movwf	DelayCountH
		bsf		JudgeSendFlag
		bsf		FriPlugEnd			;if FriPlugEnd be cleared, this counter will be execute one more time.
		bsf		MSJudgeSendOnceFlag
	
		movfw	BackupPSW
		movwf	Psw
		movfw	BackupW
		reti

INT_PB0ExternalIO:
		movwf	BackupW
		movfw	Psw
		movwf	BackupPSW

		movlw	fdh
		movwf	Int1Reg

	;	bcf	Pb0i
		bsf	gbPb0Flag

		movfw	BackupPSW
		movwf	Psw
		movfw	BackupW
		reti


;==============================================================================
INT_Rst:
		movwf	BackupW
		movfw	Psw
		movwf	BackupPSW

		;bsf	LED1
		movlw	efh
		movwf	Int1Reg
	;	bcf	Rsti
		bsf	gbRstFlag
		bcf	Suspend			;Clear Interface in suspend mode

		bsf	gbResetPath
;		call	UsbReset
		goto	UsbReset
	INT_RST_END_USBRESET:
	;	bcf	LED

		movfw	BackupPSW
		movwf	Psw
		movfw	BackupW
		reti
;==============================================================================
INT_Rsm:
		movwf	BackupW
		movfw	Psw
		movwf	BackupPSW

		movlw	f7h
		movwf	Int1Reg
	;	bcf	Rsmi

		bcf	LED1

		movlw	0ch		;Try Pb2/Pb3 pull-up;TestV7
		movwr	PBPU
		movlw	ffh
		movwf	PbReg
		bsf	DeviceR

		movlw	80h
		iorwf	UsbAddrReg,F

	;	bsf	gbRsmFlag
		bcf	gbSuspendFlag		;Keeping FLAG
		bcf	Suspend			;Clear Interface in suspend mode

		movlw	EN_INT0_NORMAL
		movwr	Int0IeReg
		movlw	EN_INT1_NORMAL
		movwr	Int1IeReg
		bsf	StartScanFlag

		movfw	BackupPSW
		movwf	Psw
		movfw	BackupW
		reti
;==============================================================================
INT_Susp:
		movwf	BackupW
		movfw	Psw
		movwf	BackupPSW

		movlw	fah
		movwf	Int0Reg
;		bcf	Suspi
  		bsf	gbSuspendFlag		;Keeping FLAG

		bsf	LED1
		bsf	LED2

	;	movlw	EN_INT0_SUSPEND
	;	movwr	Int0IeReg
	;	movlw	EN_INT1_SUSPEND
	;	movwr	Int1IeReg
        ;
  	;	bsf	Suspend			;Force Interface to suspend mode
        ;
	;	movfw	UsbAddrReg		;If have address ?
	;	andlw	7fh
	;	btfsc	Zero
	;	goto	END_PWR_DOWN
        ;
	;	movlw	ffh
	;	movwr	PwrDownCtrlReg
	END_PWR_DOWN:
		movfw	BackupPSW
		movwf	Psw
		movfw	BackupW
  		reti
;==============================================================================
SystemReset:
		movlw	TP6620_CLK_INI
		movwr	ClockCtrlReg

		movlw	60h
		movwr	WrcConfig
	;_________Init Tm0_______
		;>>>DON'T CHANGE TIMER-0 PRRIOD<<<<
		movlw	00d			;(256-24*1)		;1ms

		movwr	T0RLD
		movwf	Timer0			;Count of time

		movlw	18h			;Enable/Prescale8=256
		movwr	T0Pscl
						; BIT.4		Enable
						; BIT.3-0	Prescale(0:div1/1:div2/8:div256)
		movlw	1h
		movwr	12h			;Enable Interrupt

	;-----Clear RamBank1---------
		bsf	RamBank			;1
		movlw	40h
		call	InitRAM
	;-----Clear RamBank0------
		bcf	RamBank			;0
		movlw	20h
		call	InitRAM
		movlw	00h
		movwf	Getreportcount
		movwf	Setreportcount
	;-----Reset Int -----------
		movlw	EN_INT0_NONE
		movwr	Int0IeReg
		movlw	EN_INT1_NONE
		movwr	Int1IeReg

	;-----Data Info Bit Flag------
		btfss	PaReg,0
		bsf	E2PROMFlag
		ret
;--------------------------------------
;	Clear Area : 20h-7fh
;--------------------------------------
InitRAM:
	;	movlw	20h
		movwf	Fsr
	SR_ClearLoop0:
		movlw	00h
		movwf	Indf
		incf	Fsr,F
		movlw	7fh
		subwf	Fsr,W
		btfss	Zero
		goto	SR_ClearLoop0
		ret

;==============================================================================
UsbReset:
	;	movlw	0
	;	movwf	UsbAddrReg
	
		;movlw	ffh
		;movwf	DelayCount
		;movlw	a8h
		;movwf	DelayCountH
	;InitWaiting:
		;decf	DelayCount,F
		;testz	DelayCount
		;btfsc	Zero
		;decf	DelayCountH,F
		;testz	DelayCountH
		;btfss	Zero
		;goto	InitWaiting
		;clrf	DelayCount
		;clrf	DelayCountH
		
	;-----Clear RamBank1---------
		;bsf	RamBank			;1
		;movlw	40h
		;call	InitRAM
	;-----Clear RamBank0------
		;bcf	RamBank			;0
		;movlw	20h
		;call	InitRAM
		
		clrf	Int0Reg
		clrf	Int1Reg
		clrf	Tx0Reg
		clrf	Tx3Reg
		clrf	Rc4Reg

		bsf	DeviceR

		bcf	Suspend
		movlw	EN_INT0_NONE
		movwr	Int0IeReg
		movlw	EN_INT1_NONE
		movwr	Int1IeReg
	;	movlw	BIT7			;EN_USB bit
		movlw   80h
		movwf	UsbAddrReg

		clrf	gCbwNextStep
		XRAM1CPU_XRAM2USB

		bsf	Rc0Rdy
		btfsc	gbResetPath
		goto	INT_RST_END_USBRESET
		ret

;==============================================================================
SuspendTask:
		movlw	EN_INT0_SUSPEND
		movwr	Int0IeReg
		movlw	EN_INT1_SUSPEND
		movwr	Int1IeReg

		bcf	LED

  		bsf	Suspend			;Force Interface to suspend mode

		movfw	UsbAddrReg		;If have address ?
		andlw	7fh
		btfsc	Zero
		ret

		movlw	ffh
		movwr	PwrDownCtrlReg
		nop
		nop
		nop
		bsf	LED
		ret

;==============================================================================
;Input W=Length
EP0Transfer:
		movwf	gTempVar6

		movlw	BIT6			;TX0tgl=>1
		xorwf	Tx0Reg,F
  		movlw	f0h
  		andwf	Tx0Reg,F		;Clear TX0cnt
		movfw	gTempVar6
		iorwf	Tx0Reg,F		;gLengthCnt=>1
  		bsf	Tx0Rdy
		ret

NoDataControl:
		clrw
		call	EP0Transfer
		bsf	Rc0Rdy			;WaitNextCommand
		ret
;==============================================================================
EP3Transfer:
		;movlw	BIT6			;TX0tgl=>1
		;xorwf	Tx3Reg,F
		;movlw	40h
		;movwf	Tx3Cnt
  		;bsf	Tx3Rdy
		;ret
;==============================================================================
Rc0Task:
		bcf	gbRc0Flag
		
		movrw	Rc0Reg			;if(Rc0Err) ErrHandler.
		andlw	BIT6
		btfss	Zero
		goto	SetupCmdErr

		movrw	BmRequestType
		movwf	gTempVar1
		swapf	gTempVar1,F
		rrf	gTempVar1,W
		andlw	3h
		addwf	Pcl,F

		goto	RequestStandard
		goto	RequestClass
		goto	RequestVendor
		goto	SetupCmdErr
;==============================================================================
RequestClass:
		;Check Index value
		movrw	WIndex			;WIndex must be 0 or 1
		andlw	feh
		btfss	Zero
		goto	SetupCmdErr

		movrw	WIndex
		addwf	Pcl,F
		goto	ClassCmd_HID
		goto	ClassCmd_HID	;SetupCmdErr
		goto	SetupCmdErr
		goto	SetupCmdErr
;==============================================================================

ClassCmd_HID:
		movrw	BRequest
		xorlw	SetProtocol
		btfsc	Zero
		goto	HidSetProtocol

		movrw	BRequest
		xorlw	GetProtocol
		btfsc	Zero
		goto	HidGetProtocol

		movrw	BRequest
		xorlw	GetReport
		btfsc	Zero
		goto	HidGetReport

		movrw	BRequest
		xorlw	SetReport
		btfsc	Zero
		goto	HidSetReport

		movrw	BRequest
		xorlw	GetIdle
		btfsc	Zero
		goto	HidGetIdle

		movrw	BRequest
		xorlw	SetIdle
		btfsc	Zero
		goto	HidSetIdle

		goto	SetupCmdErr

	HidGetIdle:
		movfw	IdlePeriodStatus		;Echo DATA
		movwr	Tx0Fifo0

		movlw	1h
		call	EP0Transfer
		ret

	HidSetIdle:
		;WValue->ReportID/0(all)
			btfsc	OSType				;for Fresco USB 3.0
			goto	$+9;$+6;
			bsf	OSType
			movlw	02h
			subwf	getstring1counter,W	;if getstring1counter >= 2, bcf	OSType
			btfsc	Carry
			goto	$+3
			bsf	NECUSB3ChipFlag			;handle send key stuck, meanwhile 
			goto	$+2
			bcf	OSType					;restore original mac os


			movlw	01h
			subwf	getstring1counter,W	
			btfss	Carry
			goto	$+7			
			movlw	02h					;check if Android 4.0 OS
			subwf	getstring2counter,W
			btfsc	Carry
			goto	$+3
			bcf	OSType					;select other flag for Android
			bsf	AndroidOSFlag

			
		bsf	StartScanFlag
			clrf	TimerRollOver
			movlw	8ah
			movwf	DelayCount
			
		movrw	WValueHi
		movwf	IdlePeriodStatus
		movwf	IdlePeriodTemp

		clrw				;ACK
		call	EP0Transfer
		ret

	HidSetReport:
		;..............................
		;........Receive Data..........
		;..............................
		movrw	WLength
		xorlw	20h
		btfsc	Zero
		bsf		WriteE2EROMFlag
		incf	Setreportcount,F				;when fisrt emuration, the value must be even, otherwise odd
  		testz	gConfigurationStatus			;ConfigurationStatus = UnConfig ?
  		btfsc	Zero
 		goto	HidSetRequestTaskError
    CheckInterface2:
			movrw	WIndex
			xorlw	01h
  		btfss	Zero
  		goto	CheckInterface1
  		goto	HidSetRequestTaskSend
	CheckInterface1:	
    	bsf	StartScanFlag
			movrw	WIndex
			xorlw	00h		
  		btfss	Zero
  		goto	HidSetRequestTaskError
		
		movrw	WValueHi
		xorlw	02h			
  		btfsc	Zero		
  		bsf		W7StartCount				;enable this flag = start timer for trigger JudgeSendFlag
		
  		btfsc	Check_Flag
		goto	HidSetRequestTaskSend
  		btfss	OSType
  		goto	HidSetRequestTaskSend
		movlw	00h
		xorwf	nextsetreportflag,W
		btfsc	Zero
		goto	testfirstplugin
		movlw	01h
		xorwf	nextsetreportflag,W
		btfss	Zero
		goto	HidSetRequestTaskSend
		incf	nextsetreportflag,F
		goto	deviceready
  	testfirstplugin:
		btfsc	USB30TrueFlag
		goto	waitnextgetreport	
		
  		movlw	04h;07h						;1st emuration run failed
  		subwf	getstring2counter,W
  		btfsc	Carry	
		
		;btfsc	USB30TrueFlag
		;goto	waitnextgetreport	
		
  		;movlw	04h						;only 1st emuration long delay
  		;subwf	getstring2counter,W
  		;btfsc	Carry		
  		goto	waitnextgetreport		;goto first emuration delay
  	deviceready:
		
  		movlw	01h
  		subwf	getstring2counter,W
  		btfss	Carry		
  		goto	HidSetRequestTaskSend
  		bsf	Check_Flag

		movrw	WValueHi
		xorlw	02h			
  		btfss	Zero		
		goto	deviceready2
			movlw	02h						;for NEC USB 3.0 chipset
			subwf	getstring2counter,W
			btfss	Carry
			bsf	NECUSB3ChipFlag
			
			btfss	NECUSB3ChipFlag
			goto	$+9
			movfw	Setreportcount
			xorlw	01h;02h
			btfss	Zero
			goto	deviceready2
			movfw	Getreportcount
			xorlw	01h;02h
			btfss	Zero
			goto	deviceready2

			btfsc	MSJudgeSendOnceFlag	;make sure only one send key path
			goto	deviceready2
			
	 	bsf	JudgeSendFlag				;if u want to send key, JudgeSendFlag and Check_Flag must be 1
		bsf	FriPlugEnd
deviceready2:		
  		clrf	TimerRollOver			;second emuration delay
  		movlw	0ch;a0h;		
  		movwf	DelayCount	
  		goto	HidSetRequestTaskSend
	waitnextgetreport:
		incf	nextsetreportflag,F		;if first goto here, getstring2counter>=7 
			;movlw	09h
			;subwf	getstring2counter,W
			;btfss	Carry
			;goto	$+12
			;movfw	Getreportcount
			;xorlw	01h
			;btfss	Zero			
			;goto	$+8
			;bsf	JudgeSendFlag
			;bsf	Check_Flag
			;;bsf	FriPlugEnd
			;clrf	TimerRollOver
			;movlw	8ah		
			;movwf	DelayCount	
			;movlw	04h
			;movwf	DelayCountH			
		;btfss	USB30TrueFlag
		;goto	$+7
		;movfw	Setreportcount
		;andlw	02h
		;btfss	Zero
		;goto	$+3
		;bsf	JudgeSendFlag
		;bsf	Check_Flag
		
		;bsf	JudgeSendFlag
  		;bcf	Check_Flag
  		;clrf	TimerRollOver			;first emuration delay
  		;movlw	f0h;0ch;
  		;movwf	DelayCount
  		;movlw	04h
  		;movwf	DelayCountH
		;bsf	JudgeSendFlag
		;bsf	FriPlugEnd
    HidSetRequestTaskSend:
		clrw				;ACK
		call	EP0Transfer
		bsf	Rc0Rdy
		ret
;--------------------------------------------------		
	HidSetRequestTaskError:
		bsf	Ep0Stall
		ret		
;--------------------------------------------------		

	HidGetReport:
		;..............................
		;..........Return Data.........
		;..............................
;		incf	Getreportcount,F
		movrw	WIndex			;if(Index==1)
		xorlw	00h
    		btfss	Zero
    		goto	GetReport1
	GetReport2:
  		movlw	1h
		movwf	gDatalength
		goto	GetDescriptorTaskSend

      	GetReport1:
      		movrw	WValueHi
    		xorlw	01h			;KeyboardReport
    		btfsc	Zero
    		goto	SendKeyboardReport
	SendLedReport:
		btfsc	AskROMSizeFlag
		goto	SendE2PROMSize
		
;		btfsc	CMDInFlag
;		goto	Senddata2host

		
  		movfw	UsbLedDataTemp
  		movwr	Tx0Fifo0
  		movlw	c1h
  		movwf	Tx0Reg
		ret

SendE2PROMSize:
		bcf		AskROMSizeFlag
		btfss	E2PROMFlag
		ret
		
		movlw	55h
 		movwr	Tx0Fifo0
		movlw	01h
		btfsc	E2PROM512Flag
		movlw	02h
		movwr	Tx0Fifo1
		movlw	00h
 		movwr	Tx0Fifo2
		movlw	00h
 		movwr	Tx0Fifo3
		movlw	00h
 		movwr	Tx0Fifo4
		movlw	00h
 		movwr	Tx0Fifo5
		movlw	00h
 		movwr	Tx0Fifo6
		movlw	00h
 		movwr	Tx0Fifo7
		
  		movlw	c8h
  		movwf	Tx0Reg		
		ret
		
      	SendKeyboardReport:
      		movlw	00h
      		movwr	Tx0Fifo0
      		movwr	Tx0Fifo1
      		movwr	Tx0Fifo2
      		movwr	Tx0Fifo3
      		movwr	Tx0Fifo4
      		movwr	Tx0Fifo5
      		movwr	Tx0Fifo6
      		movwr	Tx0Fifo7
		movlw	c8h
  		movwf	Tx0Reg
		ret

	HidSetProtocol:
		btfsc	Check_Flag
		goto	NoMacOS
		
		btfsc GetDeviceDspt08Byte
		bcf OSType
		
  		btfsc	OSType
		goto	NoMacOS
		movlw	01h
		subwf	getstring2counter,W;getstring0counter,W
		btfss	Carry
		goto	NoMacOS
		bsf	Check_Flag
		btfsc	OSType
		goto	HidSetProtocol_2	
	 	bsf	JudgeSendFlag
HidSetProtocol_2:		
	 	clrf	TimerRollOver
	 	movlw	0ch;60h			;08h
	 	movwf	DelayCount
		
		;movlw	01h
		;movwf	DelayCountH
	 	clrf	DelayCountH
  	NoMacOS:
		bsf	StartScanFlag

		bsf	gbHidProtocol
		movrw	WValue
		movwf	gHidProtocolVal
		andlw	ffh
		btfsc	Zero
		bcf	gbHidProtocol

		clrw				;ACK
		call	EP0Transfer
		ret

	HidGetProtocol:
		clrw				;Echo DATA
		btfsc	gbHidProtocol
		movfw	gHidProtocolVal
		movwr	Tx0Fifo0

		movlw	1h
		call	EP0Transfer
		ret
;==============================================================================
RequestVendor:
		goto	SetupCmdErr
;==============================================================================
RequestStandard:
		movrw	BRequest
		addlw	(256-(SETUP_TBL_END-SETUP_TBL_BEGIN))
		btfsc	Carry
       	 	goto	SetupCmdErr

		movrw	BRequest
		addwf	Pcl,F
	SETUP_TBL_BEGIN:
		goto	GetStatusTask		;(00h)
		goto	ClearFeatureTask	;(01h)
		goto	SetupCmdErr
		goto	SetFeatureTask		;(03h)
		goto	SetupCmdErr
		goto	SetAddressTask		;(05h)
		goto	GetDescriptorTask	;(06h)
		goto	SetupCmdErr
		goto	GetConfigurationTask	;(08h)
		goto	SetConfigurationTask	;(09h)
  		goto	GetInterfaceTask	;(0ah)
		goto	SetInterfaceTask	;(0bh)
	SETUP_TBL_END:
		nop

SetupCmdErr:
		bsf	Ep0Stall
		ret


;==============================================================================
Ep0OutTask:
		bcf	gbOut0Flag
		btfss	DataOutFlag
		goto	$+10
		btfsc	SendFlag
		goto	$+7
		incf	TEMP1,F
		movlw	03h
		xorwf	TEMP1,W
		btfsc	Zero
		bsf	SendFlag
		goto	$+2
		call	DataOutTask
		call	NoDataControl
		call	Commandcheck
		ret
		
Commandcheck:		
		movrw	48h
		xorlw	0ah
		btfss	Zero
		ret
		movrw	49h
		xorlw	0bh
		btfss	Zero
		ret
		movrw	4ah
		xorlw	0ch
		btfss	Zero
		ret
		movrw	4bh
		xorlw	0dh
		btfss	Zero
		ret
		
;		movlw	00h
;		movwf	ReportDataLength
;		movlw	01h
;		btfsc	E2PROM512Flag
;		movlw	02h
;		movwf	ReportDataLengthH			;re-check your EPROM size
		
;		clrf	W_I2C_Address
;		clrf	W_I2C_AddressH	
        clrf	R_I2C_Address
  		clrf    ReadI2CAddressH
InputValueTest:
		movrw	4eh		
		xorlw	03h
		btfsc	Zero
		bsf	AskROMSizeFlag		;AP wants to ask EPROM size
		btfsc	AskROMSizeFlag
		ret;goto	$+6

		movrw	4eh
		xorlw	01h;InputValue
		btfss	Zero
		goto	OutputValueTest
		bsf	CMDInFlag
        ret
  OutputValueTest:
		movrw	4eh
		xorlw	02h;OutputValue
		btfss	Zero
		ret
		nop
		bsf	DataOutFlag
		ret
		

DataOutTask:
		btfss	DataOutFlag
		ret

;  		testz	ReportDataLength
;  		btfss	Zero
;  		goto	DataInFlash
;  		testz	ReportDataLengthH
;  		btfsc	Zero
;  		goto	EndReceiveData
;  DataInFlash:
;  		bcf		Out0i			;disable RC0 interrupt enable
;  		bcf		Tx0i
;  		btfsc   E2PROM512Flag
;  		goto    $+3
;  		call	I2C_Send_Nbyte 
;  		goto    $+2
;  		call	I2C_Send_Nbyte_E2PROM512
;  		call	Delay5ms
;		call	Delay5ms
;		call	Delay5ms
;		call	Delay5ms
		
;  		movlw	08h
;		addwf	W_I2C_Address,F  
;		btfsc	Carry
;		incf    W_I2C_AddressH,F  
		
		;call	Delay5ms
		;call	Delay5ms
;		bsf	Tx0i
;		bsf	Out0i
;		movlw	08h
;		subwf	ReportDataLength,F
;		btfss	Carry
;		decf	ReportDataLengthH,F
;		testz	ReportDataLength
;		btfss	Zero
;		ret
;		testz	ReportDataLengthH
;		btfsc	Zero
;		goto	EndReceiveData
;		ret


   EndReceiveData:
  		bcf	DataOutFlag
  		clrf	TEMP1
  		bcf	SendFlag
  		ret
		
;Senddata2host:		
;		call	DataInTask
;		call    CheckLength0
;DataTransfer:
;		movlw	40h					;toggle
;		xorwf	Tx0Reg,F
;		movlw	08h					;length=8
;		iorwf	Tx0Reg,F
;  		bsf	Tx0Rdy
;		bsf	Rc0Rdy
;		ret
		
		
;CheckLength0:
;  		testz	ReportDataLength
;		btfss	Zero
;  		ret
;  		testz	ReportDataLengthH
;  		btfss	Zero
;  		ret

;DataInTask:
;		btfsc	Tx0Rdy
;		ret
    	
;  		clrf	TEMP1;AnyCountTemp
;  		clrf	TEMP2
		
;  		testz	ReportDataLength
;  		btfss	Zero
;  		goto	SaveData
;  		testz	ReportDataLengthH
;  		btfss	Zero
;  		goto	SaveData
; 		bsf	Tx0i
;        ret
        
;SaveData:		
;		bcf	Tx0i
;		call	Delay5ms 		  		  		  		
  		
;        movlw	10h
;        xorwf	R_I2C_Address,0 
;        btfsc	Zero
;        nop
;  		call	I2C_Receive_Nbyte8			;read data from EPROM(AP)
		
;		movlw	08h
;		addwf	R_I2C_Address,F
;		btfsc	Carry
;		incf    ReadI2CAddressH,F

;		movlw	08h
;		xorwf	R_I2C_Address,W
;		btfss	Zero
;		goto	$+3
;		bcf		CMDInFlag
;		bsf		SecondCMDInFlag

;   SaveInData:
;  		movlw	40h
;  		movwf	Fsr

;  		movfw	TEMP1;AnyCountTemp
;  		addwf	Fsr,F
;		bsf	RamBank
;		movfw	Indf
;		bcf	RamBank
;        movwf	TEMP2;UsbDataTemp

;  		movlw	50h
;     		movwf	Rsr
;     		movfw	TEMP1;AnyCountTemp
;     		addwf	Rsr,F
;     		movfw	TEMP2;UsbDataTemp
;           		movwr	Indf
				
;      		incf	TEMP1,F;AnyCountTemp,F
;  		movlw	08h
;  		xorwf	TEMP1,W;AnyCountTemp,W
;  		btfss	Zero
;  		goto	SaveInData

;		movlw	08h
;		subwf	ReportDataLength,F
;		btfss	Carry
;		decf	ReportDataLengthH,F
;		testz	ReportDataLength
;		btfss	Zero
;		ret
;		testz	ReportDataLengthH
;		btfsc	Zero
;		goto	EndSaveData
;		ret
;;SendE2PROMSize:
;		;bcf		AskROMSizeFlag
;		;btfss	E2PROMFlag
;		;ret
		
;		;movlw	55h
; 		;movwr	Tx0Fifo0
;		;movlw	01h
;		;btfsc	E2PROM512Flag
;		;movlw	02h
;		;movwr	Tx0Fifo1
;		;movlw	00h
; 		;movwr	Tx0Fifo2
;		;movlw	00h
; 		;movwr	Tx0Fifo3
;		;movlw	00h
; 		;movwr	Tx0Fifo4
;		;movlw	00h
; 		;movwr	Tx0Fifo5
;		;movlw	00h
; 		;movwr	Tx0Fifo6
;		;movlw	00h
; 		;movwr	Tx0Fifo7
		
;EndSaveData:	
;		bcf	SecondCMDInFlag;CMDInFlag
;		bsf	Tx0i
;		ret
;==============================================================================
Tx0Task:
		bcf	gbTx0Flag
;		btfsc	SecondCMDInFlag;CMDInFlag
;		goto	Senddata2host;ret;
  	;---------Check and set New Address----------
  	;IMPORTANT : It's here because we have to send NULL to Host by Addr0.
		btfss	gbNewAddrFlag
		goto	Tx0TransCheck

		movrw	WValue
		iorlw	BIT7			;EN_USB bit
		movwf	UsbAddrReg
		bcf	gbNewAddrFlag
	;-------- Transfer Next Packet --------------
	Tx0TransCheck:
  		testz	gWLengthTemp
		btfss	Zero
		goto	NormalTrans		;Len>0;Send DATA
		call	NoDataControl		;Len=0;Send NULL + WaitNextCommand
		ret

	NormalTrans:
		call	Tx0Transfer		;Prepare DATA to transfer
		bsf	Rc0Rdy			;Transfer
		ret

;==============================================================================
RsmTask:
		bcf	gbRsmFlag
		ret
;==============================================================================
Tx3Task:
		bcf	gbTx3Flag
		;btfsc	DataInFlag
		;call	ReadData
		ret
;==============================================================================
Rc4Task:
		bcf	gbRc4Flag
		;XRAM1CPU_XRAM2CPU
		;btfsc	DataOutFlag
		;goto	$+3
		;call	CommandTask
		;goto	$+3
		;clrf	TEMP2
		;call	I2C_Send_Nbyte
		;XRAM1CPU_XRAM2USB
		bsf	Rc4Rdy
		ret
;==============================================================================
CommandTask:
		;movrw	Xram20
		;xorlw	55h
		;btfss	Zero
		;ret
		;movrw	Xram21
		;xorlw	53h
		;btfss	Zero
		;ret
		;movrw	Xram22
		;xorlw	42h
		;btfss	Zero
		;ret
		;movrw	Xram23
		;xorlw	43h
		;btfss	Zero
		;ret
		;movrw	Xram27
		;xorlw	F3h
		;btfsc	Zero
		;goto	ReadPro
		;movrw	Xram27
		;xorlw	F4h
		;btfsc	Zero
		;goto	WritePro
		;movrw	Xram27
		;xorlw	F1h
		;btfss	Zero
		;ret
		;clrf	R_I2C_Address1
		;clrf	W_I2C_Address
	CheckDevice:
		;XRAM1CPU_XRAM2CPU
		;movlw	74h
		;movwr	Xram20
		;movlw	65h
		;movwr	Xram21
		;movlw	6eh
		;movwr	Xram22
		;movlw	78h
		;movwr	Xram23
		;movlw	64h
		;movwr	Xram24
		;movlw	73h
		;movwr	Xram25
		;movlw	6bh
		;movwr	Xram26
		;movlw	00h
		;movwr	Xram27
		;XRAM1CPU_XRAM2USB
		;call	EP3Transfer
		;ret
	WritePro:
		;bsf	DataOutFlag
		;ret
	ReadPro:
		;bsf	DataInFlag
	   ReadData:
	   	;XRAM1CPU_XRAM2CPU
		;call	I2C_Receive_Nbyte8
		;XRAM1CPU_XRAM2USB
		;movlw	40h
		;addwf	R_I2C_Address1,F
		;testz	R_I2C_Address1
		;btfsc	Zero
		;bcf	DataInFlag
		;call	EP3Transfer
		;ret

;==============================================================================
CheckLength:
		movfw	gDatalength		;if WLengthHi > 0
		movwf	gWLengthTemp		;[gWLengthTemp]=gDataLength
		movrw	WLengthHi
		xorlw	0
		btfss	Zero
		ret

CheckLenTask:
		bcf	Carry
		movrw	WLength			;W = WLength - gDataLength
		movwf	gTempVar1		;if(WLength >= gDataLength)
		movfw	gDatalength	 	;[gWLengthTemp]=gDataLength
		subwf	gTempVar1,W
		btfsc	Carry
		ret
		btfsc	VerTestDoneFlag
		ret
		movrw	WLength			;if(WLength < gDataLength)
		movwf	gWLengthTemp		;[gWLengthTemp]=WLength
		ret


;==============================================================================
Tx0Transfer:
		clrf	gLengthCnt		;reset the count of send , gLengthCnt=0
		testz	gWLengthTemp
		btfsc	Zero
		goto	SetTgl

	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		movlw	Tx0Fifo0
		movwf	Rsr
		movlw	8
		movwf	gTempVar1

	Tx0ByteLoop:
	;-------- Byte n -------
		;btfss	gfUSEinitGetDescriptor		;first time Emuration flag for mac_ver judgement
		;goto	GetStringCase
		;movlw	08h
		;subwf	gTableCnt,W
		;btfss	Carry
		;goto	GetStringCase
		;movlw	0ch
		;subwf	gTableCnt,W
		;btfsc	Carry
		;goto	GetStringCase
		;movlw	ReadBuffer-8	;get VID/PID from last page
     		;movwf	Fsr
     		;movfw	gTableCnt
     		;addwf	Fsr,F
     		;bsf	RamBank
     		;movfw	Indf
     		;bcf	RamBank
		;goto	Tx0BufferWrite
	;GetStringCase:
		;btfsc	gfGetString1
		;goto	$+3
		;btfss	gfGetString2
		;goto	NoE2p
		;movlw	ReadBuffer		;get string descriptor from last page
		;movwf	Fsr
     		;movfw	gTableCnt
     		;addwf	Fsr,F
     		;bsf	RamBank
     		;movfw	Indf
     		;bcf	RamBank
     		;goto	Tx0BufferWrite
	NoE2p:
		movfw	gTableCnt
		call	DeviceDescTable
	Tx0BufferWrite:
		movwr	Indf
		incf	gTableCnt,F		;increase index
		incf	gLengthCnt,F		;increase count of send			;gLengthCnt=1
		decf	gWLengthTemp,F
		incf	Rsr,F

		decf	gTempVar1,F
		btfsc	Zero
		goto	SetTgl
	;--- end? ----
		testz	gWLengthTemp
		btfss	Zero
		goto	Tx0ByteLoop
		bcf	gfUSEinitGetDescriptor
		;bcf	gfGetString1
		;bcf	gfGetString2
	SetTgl:
		movfw	gLengthCnt
	    	call	EP0Transfer

		ret

;==============================================================================
GetDescriptorTask:
		movrw	BmRequestType
  		xorlw	DeviceToHost		;80
  		btfsc	Zero
  		goto	GetDescriptorType

  		movrw	BmRequestType
  		xorlw	InterfaceToHost	   	;81
  		btfsc	Zero
  		goto	GetDescriptorType

		movrw	BmRequestType
  		xorlw	EndpointToHost		;82
  		btfss	Zero

  		goto	SetupCmdErr

	GetDescriptorType:
  		movrw	WValueHi
  		xorlw	Device			;01h
  		btfsc	Zero
  		goto	DeviceType		;get decice descriptor

  		movrw	WValueHi
  		xorlw	Configuration		;02h
  		btfsc	Zero
  		goto	ConfigurationType	;get config descriptor

  		movrw	WValueHi
		xorlw	String			;03h
  		btfsc	Zero
 		goto	StringType		;get string descriptor


  		movrw	WValueHi
		xorlw	HidClass		;21h
  		btfsc	Zero
 		goto	HidClassType		;get string descriptor

  		movrw	WValueHi
		xorlw	HidReport		;22h
  		btfsc	Zero
 		goto	HidReportType		;get string descriptor


  		goto	SetupCmdErr		;others, set Ep0 Stall
;-----------------------
	DeviceType:				; init xchange MASK byte
	;	btfss	GetInfoFlag
	;	call	GetDeviceInfo
		bcf	Check_Flag
	 	bcf	JudgeSendFlag
		bsf	USB30TestFlag
		
		btfsc	USB30TrueFlag
		goto	$+10
		movrw	WLength
    		xorlw	40h
    		btfsc	Zero
    		bsf	OSType
    		movrw	WLength
    		xorlw	08h
    		btfsc	Zero
    		bcf	OSType
		goto	$+2
		bsf	OSType
		
		
		;////Save initial device descript length
    	movrw	WLength					;
    	xorlw	08h
    	btfsc	Zero			
		bsf GetDeviceDspt08Byte
		
		btfsc GetDeviceDspt08Byte		;specific MAC PC will re-get device descriptior
		bcf OSType
		
		
		bsf	gfUSEinitGetDescriptor
		clrf	gTableCnt
		movlw	DeviceLen
		movwf	gDatalength
		goto	GetDescriptorTaskSend
;-----------------------
	ConfigurationType:
		movlw	ConfigIndex		;Config start rom offset
		movwf	gTableCnt
		movlw	ConfigLen
		movwf	gDatalength
		goto	GetDescriptorTaskSend
;-----------------------
	StringType:
  		movrw	WValue
  		xorlw	String0
		btfsc	Zero
		goto	SendString0

		movrw	WValue
  		xorlw	String1
		btfsc	Zero
		goto	SendString1

		movrw	WValue
  		xorlw	String2
		btfsc	Zero
		goto	SendString2

		;bsf	NewOSFlag
		goto	SetupCmdErr

	SendString0:
		;incf	getstring0counter,F
	  	movlw	String0Index
	  	movwf	gTableCnt
		movlw	String0Len
		movwf	gDatalength
		goto	GetDescriptorTaskSend

	SendString1:
		incf	getstring1counter,F

			
		;call	GetDeviceInfo
		;movlw	03h
		;bsf	RamBank
		;xorwf	ReadBuffer5,W
		;bcf	RamBank
		;btfss	Zero
		;goto	$+6
		;bsf	RamBank
		;movfw	ReadBuffer4
		;bcf	RamBank
		;movwf	TempReg
		;bsf	gfGetString1
	  	movlw	String1Index
	  	;btfsc	gfGetString1
		;movlw	04h
	  	movwf	gTableCnt
		movlw	String1Len
		;btfsc	gfGetString1
		;movfw	TempReg
		movwf	gDatalength
		goto	GetDescriptorTaskSend

	SendString2:
		incf	getstring2counter,F
			;movlw	02h
			;xorwf	getstring2counter,W
			;btfsc	Zero
			;bsf	FrescoChipFlag
			
		;movlw	03h
		;bsf	RamBank
		;xorwf	ReadBuffer23,W
		;bcf	RamBank
		;btfss	Zero
		;goto	$+6
		;bsf	RamBank
		;movfw	ReadBuffer22
		;bcf	RamBank
		;movwf	TempReg
		;bsf	gfGetString2
	  	movlw	String2Index
	  	;btfsc	gfGetString2
		;movlw	22d
	  	movwf	gTableCnt			;table content
		movlw	String2Len
		;btfsc	gfGetString2
		;movfw	TempReg
		movwf	gDatalength
		goto	GetDescriptorTaskSend

;-----------------------
	HidClassType:
		movrw	WValue
  		xorlw	00h
		btfsc	Zero
		goto	HidClass1

;		movrw	WValue
;  		xorlw	01h
;		btfsc	Zero
;		goto	HidClass2
		goto	SetupCmdErr
	HidClass1:	
		movlw	HidClass1Index
		movwf	gTableCnt
		movlw	HidClassLen
		movwf	gDatalength
		goto	GetDescriptorTaskSend

	HidClass2:	
;		movlw	HidClass2Index
;		movwf	gTableCnt
;		movlw	HidClassLen
;		movwf	gDatalength
;		goto	GetDescriptorTaskSend

;-----------------------
	HidReportType:
		incf	Getreportcount,F
		movrw	WIndex
  		xorlw	00h
		btfsc	Zero
		goto	HidReport1
		
;		movrw	WIndex
;  		xorlw	01h
;		btfsc	Zero
;		goto	HidReport2
		goto	SetupCmdErr
	HidReport1:
		movlw	HidReport1Index
		movwf	gTableCnt
		movlw	HidReport1Len
		movwf	gDatalength
		;btfsc	OSType
		goto	GetDescriptorTaskSend
	HidReport2:
;		incf	Getreportcount,F
;		movlw	HidReport2Index
;		movwf	gTableCnt
;		movlw	HidReport2Len
;		movwf	gDatalength
;		goto	GetDescriptorTaskSend
	
		;movlw	55h
		;xorwf	ResetFlag0,W
		;btfss	Zero
		;goto	JudgeMacOSVer
		;movlw	53h
		;xorwf	ResetFlag1,W
		;btfss	Zero
		;goto	JudgeMacOSVer
		;movlw	42h
		;xorwf	ResetFlag2,W
		;btfss	Zero
		;goto	JudgeMacOSVer
		;movlw	43h
		;xorwf	ResetFlag3,W
		;btfsc	Zero
		;goto	GetDescriptorTaskSend
	;JudgeMacOSVer:
		;movlw	02h
		;xorwf	GetReportCounter,W
		;btfsc	Zero
		;goto	SetMacVerFlags
		;movlw	01h
		;xorwf	GetReportCounter,W
		;btfss	Zero
		;goto	GetDescriptorTaskSend
		;movlw	63d
		;movwf	gDatalength
		;bsf	VerTestDoneFlag
		;goto	GetDescriptorTaskSend
	;SetMacVerFlags:
		;movlw	08h
		;subwf	TimerRollOver,W
		;btfss	Carry
		;goto	GetDescriptorTaskSend
		;movlw	54h
		;movwf	MacVerFlag0
		;movlw	45h
		;movwf	MacVerFlag1
		;movlw	4Eh
		;movwf	MacVerFlag2
		;movlw	58h
		;movwf	MacVerFlag3
	GetDescriptorTaskSend:
		call	CheckLength		;Decide What Size to send
		bcf	VerTestDoneFlag
		call	Tx0Transfer		;Prepare data and send it
		;btfsc	OSType
		ret
		;movlw	02h
		;xorwf	getstring2counter,W
		;btfss	Zero
		;ret
	
		;bsf	StartScanFlag
		;bsf	Check_Flag
	 	;bsf	JudgeSendFlag
	 	;clrf	TimerRollOver
	 	;movlw	60h			;08h
	 	;movwf	DelayCount
	 	;movlw	00h			;10h
	 	;movwf	DelayCountH
		;ret


;==============================================================================
SetAddressTask:
		bsf	gbNewAddrFlag
		btfss	USB30TestFlag
		bsf	USB30TrueFlag			;if setAddress tack work before getDeviceDpt, do it.
		call	NoDataControl
		ret

;==============================================================================
GetConfigurationTask:
		movrw	BmRequestType
		xorlw	DeviceToHost
  		btfss	Zero
  		goto	SetupCmdErr

  		movfw	gConfigurationStatus	;config status
  		movwr	Tx0Fifo0
  		movlw	c1h			;TX0Rdy=1,TX0tgl=1,TX0cnt=1
  		movwf	Tx0Reg
		ret

;==============================================================================
SetConfigurationTask:
		movrw	BmRequestType
		xorlw	0
  		btfss	Zero
  		goto	SetupCmdErr

	SetConfigurationType:
		movrw	WValue
		xorlw	0
  		btfss	Zero
  		goto	ConfigType		;1 is config
	UnConfigType:  				;0 is unconfig
		movrw	WValue
  		movwf	gConfigurationStatus	;gConfigurationStatus=0
  		movlw	EN_INT0_UNCONF
		movwr	Int0IeReg
		movlw	EN_INT1_UNCONF
		movwr	Int1IeReg
		bcf	StartScanFlag
   		call	NoDataControl
		ret

	ConfigType:
   	  	movrw	WValue
  		movwf	gConfigurationStatus

  		movlw	7dh
		movwf	IdlePeriodStatus
		movwf	IdlePeriodTemp

 		movlw	EN_INT0_NORMAL
		movwr	Int0IeReg
		movlw	EN_INT1_NORMAL
		movwr	Int1IeReg

		movlw	d0h
		movwf	Tx3Reg

		movlw	90h
		movwf	Rc4Reg

		bsf	Ep1Cfg
		bcf	Tx1Tgl
		bsf	Ep2Cfg
		bcf	Tx2Tgl
		bsf	Ep3Cfg
		bsf	Ep4Cfg
		bsf	Rc4Rdy

	;	movlw	c8h
	;	movwf	Tx1Reg
	;	movlw	c4h
	;	movwf	Tx2Reg

		call	NoDataControl
		call	CheckE2PROMSize
		ret
;==============================================================================
ClearFeatureTask:
		movrw	BmRequestType
		xorlw	HostToDevice		;00h
  		btfsc	Zero
  		goto	ClearRemoteWakeup

		movrw	BmRequestType
  		xorlw	HostToEndpoint		;02h
  		btfss	Zero
  		goto	SetupCmdErr

	ClearEndpointStall:
		testz	gConfigurationStatus	;gConfigurationStatus = Config ?
		btfsc	Zero
		goto	SetupCmdErr

	CheckClrEndpointStall:
  		movrw	WIndex
  		xorlw	Endpoint0
		btfsc	Zero
		goto	ClrEp0Stall

		movrw	WIndex
  		xorlw	Endpoint1
		btfsc	Zero
		goto	ClrEp1Stall

		movrw	WIndex
  		xorlw	Endpoint2
		btfsc	Zero
		goto	ClrEp2Stall

		movrw	WIndex
  		xorlw	Endpoint3
		btfsc	Zero
		goto	ClrEp3Stall

		movrw	WIndex
  		xorlw	Endpoint4
		btfss	Zero
		goto	SetupCmdErr

	ClrEp4Stall:
  		bcf	Ep3Stall
		bcf	Ep4Stall		;clear Ep4 stall

		goto	ClearFeatureTaskSend
	ClrEp3Stall:

		bsf	Tx3Tgl			;Keep 1, let NEXT packet use DATA0.
	  	bcf	Ep4Stall
		bcf	Ep3Stall		;clear Ep3 Stall

		goto	ClearFeatureTaskSend
	ClrEp2Stall:
		bcf	Ep2Stall		;clear Ep2 Stall
		bcf	Tx2Tgl			;clear Rc2 toggle bit
		goto	ClearFeatureTaskSend
	ClrEp1Stall:
	  	bcf	Ep1Stall		;clear Ep1 Stall
	  	bcf	Tx1Tgl			;clear Tx1 toggle bit
		goto	ClearFeatureTaskSend
	ClrEp0Stall:
	  	bcf	Ep0Stall		;clear Ep0 Stall
	  	bcf	Tx0Tgl			;clear Tx0 toggle bit
		goto	ClearFeatureTaskSend
	ClearRemoteWakeup:
  		movrw	WValue
		xorlw	Device			;Feature Id=02h
		btfss	Zero
		goto	SetupCmdErr
		movlw	DisableRemoteWakeup
		movwf	gRemoteWakeupStatus

	ClearFeatureTaskSend:
		call	NoDataControl
		ret
;==============================================================================
SetFeatureTask:
		movrw	BmRequestType
		xorlw	HostToDevice
  		btfsc	Zero
  		goto	SetRemoteWakeup

		movrw	BmRequestType
  		xorlw	HostToEndpoint
  		btfss	Zero
  		goto	SetupCmdErr

	SetEndpointStall:
		testz	gConfigurationStatus	;gConfigurationStatus = Config ?
		btfsc	Zero
		goto	SetupCmdErr

	CheckSetEndpointStall:
  		movrw	WIndex
		xorlw	Endpoint1
		btfsc	Zero
		goto	SetEp1Stall

		movrw	WIndex
		xorlw	Endpoint2
		btfsc	Zero
		goto	SetEp2Stall

		movrw	WIndex
		xorlw	Endpoint3
		btfsc	Zero
		goto	SetEp3Stall

		movrw	WIndex
		xorlw	Endpoint4
		btfss	Zero
		goto	SetupCmdErr
	SetEp4Stall:
		bsf	Ep4Stall
		goto	SetFeatureTaskSend

	SetEp3Stall:
		bsf	Ep3Stall
		goto	SetFeatureTaskSend

	SetEp2Stall:
		bsf	Ep2Stall
		goto	SetFeatureTaskSend

	SetEp1Stall:
		bsf	Ep1Stall
		goto	SetFeatureTaskSend

	SetRemoteWakeup:
  		movrw	WValue
		xorlw	Device		;Feature Id=02h
		btfss	Zero
		goto	SetupCmdErr
		movlw	EnableRemoteWakeup
		movwf	gRemoteWakeupStatus

	SetFeatureTaskSend:
		call	NoDataControl
		ret


;==============================================================================
GetStatusTask:
		movrw	BmRequestType
		xorlw	DeviceToHost
  		btfsc	Zero
  		goto	GetDeviceStatus

		movrw	BmRequestType
  		xorlw	InterfaceToHost
  		btfsc	Zero
		goto	GetInterfaceStatus

		movrw	BmRequestType
		xorlw	EndpointToHost
  		btfss	Zero
		goto	SetupCmdErr

	GetEndpointStatus:
		testz	gConfigurationStatus	;gConfigurationStatus = Config ?
  		btfsc	Zero
  		goto	SetupCmdErr

		movrw	WIndex
  		xorlw	Endpoint0	;00h
  		btfsc	Zero
  		goto	GetEp0Status

		movrw	WIndex
  		xorlw	Endpoint1	;01h
  		btfsc	Zero
  		goto	GetEp1Status

		movrw	WIndex
  		xorlw	Endpoint2
  		btfsc	Zero
  		goto	GetEp2Status

		movrw	WIndex
  		xorlw	Endpoint3	;01h
  		btfsc	Zero
  		goto	GetEp3Status

  		movrw	WIndex
  		xorlw	Endpoint4
  		btfss	Zero
  		goto	SetupCmdErr
	GetEp4Status:
  		movlw	00h
  		movwr	Tx0Fifo0	;clear stauts1
  		btfsc	Ep4Stall
		movlw	01h
  		goto	GetEndpointStatusEnd

	GetEp0Status:
  		movlw	00h
  		movwr	Tx0Fifo1
  		goto	GetEndpointStatusEnd

	GetEp1Status:
  		movlw	00h
  		movwr	Tx0Fifo1	;clear stauts1
  		btfsc	Ep1Stall
		movlw	01h		;if stall set status=1
		goto	GetEndpointStatusEnd

	GetEp2Status:
  		movlw	00h
  		movwr	Tx0Fifo1	;clear stauts1
  		btfsc	Ep2Stall
		movlw	01h
		goto	GetEndpointStatusEnd
	GetEp3Status:
   		movlw	00h
  		movwr	Tx0Fifo1	;clear stauts1
  		btfsc	Ep3Stall
		movlw	01h
	GetEndpointStatusEnd:
		movwr	Tx0Fifo0
		goto	GetStatusTaskSend

	GetDeviceStatus:
  		movfw	gRemoteWakeupStatus
  		movwr	Tx0Fifo0
  		movlw	00h
  		movwr	Tx0Fifo1
  		goto	GetStatusTaskSend

	GetInterfaceStatus:
  		movfw	gCurAlternate
  		movwr	Tx0Fifo0
  		movlw   00h
  		movwr	Tx0Fifo1

	GetStatusTaskSend:
  		movlw	c2h		;TX0rdy=1,TX0tgl=1,TX0cnt=2
  		movwf	Tx0Reg
		ret

;==============================================================================
GetInterfaceTask:
		movrw	BmRequestType
		xorlw	InterfaceToHost
  		btfss	Zero
  		goto	SetupCmdErr

	;GetInterface:
   		movfw	gCurAlternate
   		movwr	Tx0Fifo0
   		movlw	c1h		;TX0rdy=1,TX0tgl=1,TX0cnt=1
  		movwf	Tx0Reg
		ret

;==============================================================================
SetInterfaceTask:
		movrw	BmRequestType
		xorlw	HostToInterface	;(HostToDevice|Standard|Interface)
  		btfss	Zero
  		goto	SetupCmdErr

   		movrw	WValue
   		movwf   gCurAlternate   ;keep the gCurAlternate setting

		movrw	WIndex
  		xorlw	Interface0	;check interface 0?
  		btfsc	Zero
  		goto	SetInterface0

  		movrw	WIndex
  		xorlw	Interface1	;check interface 1
  		btfsc	Zero
  		goto	SetInterface1

  		movrw	WIndex
  		xorlw	Interface2	;check interface 2
  		btfss	Zero
  		goto	SetupCmdErr	;

	SetInterface2:
		movrw	WValue
		xorlw	0
		btfss   Zero
   		goto	SIT2_SetNewAlternate
   		bcf	Ep2Cfg
		call	NoDataControl
		ret
	SIT2_SetNewAlternate:
		bsf	Ep2Cfg
		call	NoDataControl
		ret

	SetInterface1:			;set interface 1
		movrw	WValue
		xorlw	0
   		goto	SetNewAlternate
   		bcf	Ep1Cfg
		call	NoDataControl
		ret
	SetNewAlternate:
		bsf	Ep1Cfg

	SetInterface0:			;set interface 0
		call	NoDataControl
		ret

;==============================================================================
IntCheck:
	;	btfsc   gbTx3Flag
	;	goto	Tx3Task
        ;
	;	btfsc   gbRc4Flag
	;	goto	Rc4Task

		btfsc   gbRc0Flag
		goto	Rc0Task		;setup token

		btfsc   gbOut0Flag
		goto	Ep0OutTask	;control write

		btfsc	gbTx0Flag
		goto	Tx0Task

		;~~~~~~~ WARNING:Keep Status ~~~~~~~
		btfsc	gbSuspendFlag
		goto	SuspendTask

	;	btfsc	gbRsmFlag
	;	goto	RsmTask

		ret



KeepDelay:
	;	movlw	160
		movwf	gTempVar6
	KeepLoopDelay:
		call	KeepDelay62us
		clrwdt
		decfsz	gTempVar6,F
		goto	KeepLoopDelay
		ret

KeepDelay62us:
		movlw	125		;220
		movwf	gTempVar5
	LoopDelay:
		decfsz	gTempVar5,F
		goto	LoopDelay
		ret

ChkUsbAttach:
		bcf	Zero
		ret

;==============================================================

SendResumeSignal:
		btfss	gbSuspendFlag
		ret

		bsf	Resume		;RESUME signal ON
		movlw	160d		;10ms
		call	KeepDelay
		bcf	Resume		;RESUME signal OFF
		reti
;====================================================
Start:
		;bcf	DeviceR
		;call	ICinitdelay
		
		bsf	LED1
		bcf	LED2
		call	SystemReset
		movlw	0ch				;Try Pb2/Pb3 pull-up;TestV7
		movwr	PBPU
		movlw	ffh
		movwf	PbReg			;avoid DM unexpected error, PB.2/PB.3 must set high

		bcf GetDeviceDspt08Byte
		bcf	gbResetPath
		call	UsbReset
		bsf	MacVerFlag
		
	ATTACH_LOOP:	
		call	IntCheck
		clrwdt
		btfss	StartScanFlag		;when setconfiguration this flag is 0, then be set 1 at setidle 
		goto	ATTACH_LOOP
		
		;btfss	gSendEnterOver
		;goto	SendNormalURL
		;btfss	gEnterDelayOver
		;call 	DelayforSecurity
		;btfss	gRegisterInitOver
		;call	InitforSecurityKey
		;call	SendSecurityKey
;SendNormalURL:

		;btfsc	SendSecurityEnd
		;goto	ATTACH_LOOP
		
		btfss	JudgeSendFlag		
		goto	Continue			;windows go there first
		
		btfsc AndroidOSFlag
		goto PulgInDataPre

		movfw	DelayCount			;mac go there first		;delay time from get report
		subwf	TimerRollOver,W
		btfss	Carry
		goto	ATTACH_LOOP
		testz	DelayCountH
		btfsc	Zero
		goto	$+6
		clrf	TimerRollOver
		decf	DelayCountH,F
		movlw	8ah
		movwf	DelayCount
		goto	ATTACH_LOOP

	PulgInDataPre:
		clrf	TimerRollOver
		bcf	JudgeSendFlag
		clrf	getstring1counter
		;clrf	getstring2counter
		call	PlugInTask_E2PROM
	SendPreData:
	
		btfsc	AndroidOSFlag
		goto	$+6;$+4
		;movlw 09h
		bcf setting0x51addrFlag
		clrf gTempVar0
		call	PrepareDataTask1
		call	DataTransfer1
		goto	ATTACH_LOOP
		call	PrepareData_Android
		call	DataTransfer1_android		
		goto	ATTACH_LOOP
	Continue:
		call	KeyscanTask
		btfsc	GUIFlag
		goto	SendPreData
		btfsc AndroidURLDoneFlag
		goto	ThirdStage
		call	PrepareDataTask
		call	ReportTask
		;btfss AndroidURLDoneFlag
		goto	ATTACH_LOOP
	ThirdStage:
		call	PrepareData_Android
		call	DataTransfer1_android
		goto	ATTACH_LOOP
;==============================================================================
;function:check e2prom size
;==============================================================================
CheckE2PROMSize:
		;bcf		E2PROMFlag		
        ;bcf		E2PROM512Flag
		;bcf		RamBank	

		
        ;read E2PROM(0ffh) and save the value in 0ffh
        ;movlw	02h
		;movwf	DataBuffer0
		;movlw	feh
		;movwf	R_I2C_Address1;ReadI2CAddress
		;movlw	00h
		;movwf	ReadI2CAddressH
		;call	I2C_Receive_byte1_CKE2PROM
		;call	Delay5ms
		;movfw	WorkReg
		;bsf		RamBank
		;movwf	Check0FF								
		
		;btfsc	E2PCheckFlag
		;goto	ReturnToOriginal
		
        ;read E2PROM(1ffh) and save the value in 1ffh
		;bcf		RamBank
		
        ;movlw	02h
		;movwf	DataBuffer0
		;movlw	feh
		;movwf	R_I2C_Address1;ReadI2CAddress
		;movlw	01h
		;movwf	ReadI2CAddressH
		;call	I2C_Receive_byte1_CKE2PROM
		;movfw	WorkReg
		;bsf		RamBank
		;movwf	Check1FF								
		;call	Delay5ms
		;bcf		RamBank
		
		;movlw	aah
		;movwf	DataBuffer0
		;movlw	ffh
		;movwf	W_I2C_Address
		;movlw	00h
		;movwf	W_I2C_AddressH 
		;call	I2C_Send_byte1_E2PROM512
		;call	Delay5ms
		;call	Delay5ms
		;call	Delay5ms
		;call	Delay5ms
	

		;movlw	cch
		;movwf	DataBuffer0
		;movlw	ffh
		;movwf	W_I2C_Address
		;movlw	01h
		;movwf	W_I2C_AddressH 
		;call	I2C_Send_byte1_E2PROM512
		;call	Delay5ms
		;call	Delay5ms	
		;call	Delay5ms
		;call	Delay5ms
		
		
		;movlw	02h
		;movwf	DataBuffer0
		;movlw	feh
		;movwf	R_I2C_Address1;ReadI2CAddress
		;movlw	00h
		;movwf	ReadI2CAddressH
		;call	I2C_Receive_byte1_CKE2PROM							
		;call	Delay5ms
		
		;bsf		RamBank
		;movlw	41h
     	;movwf	Fsr
     	;movfw	Indf
		;bcf		RamBank
		;xorlw	aah
		;btfsc	Zero
		;bsf		E2PROMFlag
		
		;movlw	02h
		;movwf	DataBuffer0
		;movlw	feh
		;movwf	R_I2C_Address1;ReadI2CAddress
		;movlw	01h
		;movwf	ReadI2CAddressH
		;call	I2C_Receive_byte1_CKE2PROM
		;call	Delay5ms
		
		;bsf		RamBank
		;movlw	41h
     	;movwf	Fsr
     	;movfw	Indf
		;bcf		RamBank
		;xorlw	cch
		;btfsc	Zero				
		;bsf		E2PROM512Flag   
		
		;restore the original value in
		;bsf		RamBank
		;movfw	Check0FF
		;bcf		RamBank									
		;movwf	DataBuffer0
		;movlw	ffh
		;movwf	W_I2C_Address
		;movlw	00h
		;movwf	W_I2C_AddressH 
		;call	I2C_Send_byte1_E2PROM512
		;call	Delay5ms
		;call	Delay5ms
		;call	Delay5ms
		;call	Delay5ms		
		;restore the original value in
		;bsf		RamBank
		;movfw	Check1FF
		;bcf		RamBank									
		;movwf	DataBuffer0
		;movlw	ffh
		;movwf	W_I2C_Address
		;movlw	01h
		;movwf	W_I2C_AddressH 
		;call	I2C_Send_byte1_E2PROM512
		;call	Delay5ms
		;call	Delay5ms
		;call	Delay5ms
		;call	Delay5ms
ReturnToOriginal:
		bcf		RamBank
		movlw	00h
		;movwf	Check0FF
		;movwf	Check1FF
		movwf	R_I2C_Address1
		movwf	TempReg
		movwf	WorkReg
		movwf	DataBuffer0
		movwf	ReadI2CAddressH
        ret
		
		
;==============================================================================
;function:check e2prom exist or not
;==============================================================================
;E2PROMCheck:
	 	;clrf	R_I2C_Address
		;call	I2C_Receive_64byte
		;bsf	RamBank
		;movfw	ReadBuffer0
		;bcf	RamBank
		;movwf	TEMPE2PDATA
		;testz	TEMPE2PDATA
		;btfsc	Zero
		;goto	NoE2PROM
		;movlw	ffh
		;xorwf	TEMPE2PDATA,W
		;btfsc	Zero
		;goto	NoE2PROM
		;bsf	E2PROMFlag
		;ret
	;NoE2PROM:
		;bcf	E2PROMFlag
		;clrf	R_I2C_Address
		;call	Get64ByteInfo
		;ret
;==============================================================================
;function:Get device information
;==============================================================================
;GetDeviceInfo:
		;bsf	GetInfoFlag
		;clrf	R_I2C_Address
		;btfsc	E2PROMFlag
		;goto	$+3
		;call	Get64ByteInfo
		;ret
		;clrf	R_I2C_Address
		;call	I2C_Receive_64byte
		;ret
;==============================================================================
;function:PB0 option and PD4~PD7 scan key
;==============================================================================
KeyscanTask:
		btfss	PbReg,0
		goto	$+3
		bcf	KeyPressedFlag
		bcf	PressToggleFlag
		btfsc	KeyPressedFlag
		ret

		btfsc	DataOKFlag
		ret

		comf	PbReg,W
		andlw	01h
		btfsc	Zero
		ret
		call	KeepDelay62us
		comf	PbReg,W
		andlw	01h
		btfsc	Zero
		ret
		btfsc	PressToggleFlag
		goto	$+4
		bsf	PressToggleFlag
		clrf	TimerRollOver
		ret
		movlw	0ah
		subwf	TimerRollOver,W
		btfss	Carry
		ret
		bsf	KeyPressedFlag

PlugInTask_E2PROM:
	;	btfsc	DataOKFlag
	;	ret				;data transmiting
		
		bcf	EndTransFlag
		;movlw	199d
		;btfsc	E2PROMFlag
		;movlw	192d
		;movwf	MaxURLLength				;none used
		bsf	DataInFlag1
		bcf	OneFlag
		movlw	00h
		movwf	ScanNumber
;		movlw	DeviceIDIndex				;clear R_I2C_Address to get info from URL table
		;btfsc	E2PROMFlag
		;movlw	00h
		movwf	R_I2C_Address
		clrf	TempCount
		clrf	EndMaxURL40h

		;btfss	E2PROMFlag
		;goto	$+3
		;call	I2C_Receive_64byte			;get 64 bytes data from I2C
		;goto	$+2
		
;		call	GetTagInfo					;get 64 bytes data from URL which in last page
		call	GetWindowsInfo
		call	GetMACInfo
		call	GetAndroidInfo

		;check language	if 2 or 10 for MAC and Android
		;bsf		RamBank 			;check language for mac	
		movlw	10h 
		xorwf	LanguageType,W;ReadBuffer1,W
		btfsc	Zero 
		goto	$+5
		movlw	02h 
		xorwf	LanguageType,W;ReadBuffer1,W
		btfss	Zero 
		goto	$+2
		;bcf		RamBank 
		bsf		CheckLanguage
				
;		bsf	RamBank					;read encry type
;		movfw	42h
;		bcf	RamBank
;		movwf	EncryptionValue
		
;		bsf	RamBank					;read windows url index, althouth 2 bytes reserved, but high byte doesn't use
;		movfw	44h
;		bcf	RamBank				
;		movwf	URLAddressIndex
		
;		bsf	RamBank					;read windows url length
;		movfw	45h
;		bcf	RamBank		
;		movwf	URLAddressLen
;		incf	URLAddressLen,F		;send key judge, necessary
		
;		bsf	RamBank					;read mac url index
;		movfw	47h
;		bcf	RamBank		
;		movwf	MacURLAddressIndex
		
;		bsf	RamBank					;read mac url length
;		movfw	48h
;		bcf	RamBank		
;		movwf	MacURLAddressLen	
;		addwf	MacURLAddressLen,F
;		movlw	02h
;		addwf	MacURLAddressLen,F
		
;		bsf	RamBank					;read security key index
;		movfw	4ah
;		bcf	RamBank		
;		movwf	SecurityKeyIndex
		
;		bsf	RamBank					;read security delay time
;		movfw	4ch
;		bcf	RamBank
;		movwf	SecurityDelayTime
		
;		bsf	RamBank					;read send key type, specific
;		movfw	4dh
;		bcf	RamBank
;		movwf	CtrlCmdSpace			;0=ctrl, 1=command
		
		movfw	URLAddressIndex			;refresh url starting address
		btfss	OSType
		movfw	MacURLAddressIndex
			btfsc	AndroidOSFlag		;if OS is android
			movfw	AndroidURLIndex
		movwf	R_I2C_Address
		
		btfsc	Zero
	E2PROMEmpty:
		call	ChangeBufferData		;Change Data for open a vacant web
		bsf	DataOKFlag
		movlw	05h
		btfsc	E2PROM512Flag
		movlw	0ah
		movwf	ReadURLTime
		bsf	GUIFlag			;transmit GUI/R at first
		ret

;=====================================================================
ChangeBufferData:
		bsf	RamBank
		movlw	68h
		movwf	ReadBuffer0
		movlw	74h
		movwf	ReadBuffer1
		movwf	ReadBuffer2
		movlw	70h
		movwf	ReadBuffer3
		movlw	3ah
		movwf	ReadBuffer4
		movlw	2fh
		movwf	ReadBuffer5
		movwf	ReadBuffer6
		movlw	00h
		movwf	ReadBuffer7
		bcf	RamBank
		ret
;=============================================================================
PrepareDataTask1:
		btfsc	OSType
		goto	PrepareData_Win
    PrepareData_Mac:
		btfss	DataInFlag1
		ret
		btfsc	OneFlag
		ret
		bsf	TransFlag
		bsf	OneFlag
		btfsc	PlugFlag
		ret
		movfw	ScanNumber
		;btfss	MacVerFlag
		;goto	$+3
		call	GetKeyValuePro_Mac
		;goto	$+2
		;call	GetKeyValuePro_Mac1
		movwf	UsbKeyBuffer2
		movlw	E1h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue0
		movlw	00h						
		movwf	UsbKeyBuffer0
		;movlw	01h
		;xorwf	CtrlCmdSpace,W
		;btfss	Zero
		;goto	$+3
		;movlw	08h
		;movwf	UsbKeyBuffer0
		;btfss	MacVerFlag;CtrlCmdSpace,0;MacVerFlag
		;movlw	01h					;; ctrl
		;movwf	UsbKeyBuffer0
		movlw	91h					;switch to single char country language for mac
		;btfss	MacVerFlag
		;movlw	3bh
		movwf	UsbKeyBuffer2
		incf	ScanNumber,F
		ret
	NormalKeyValue0:				;multi-language, a<->q
		movlw	E2h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue01
		movlw	0ah 		
		movwf	UsbKeyBuffer0		
		btfss	CheckLanguage
		goto	$+3
		movlw	14h
		goto	$+2	
		movlw	04h    				
		movwf	UsbKeyBuffer2
		incf	ScanNumber,F 
		ret
		;movlw	E2h					;gui+'L'
		;xorwf	UsbKeyBuffer2,W
		;btfss	Zero
		;goto	NormalKeyValue01	;NormalKeyValue01
		;movlw	08h
		;movwf	UsbKeyBuffer0
		;movlw	0fh
		;movwf	UsbKeyBuffer2
		;incf	ScanNumber,F
		;ret
	NormalKeyValue01:				;ctrl space		
		movlw	E3h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue02

		movlw	00h
		clrf	UsbKeyBuffer2
		
		movlw	01h
		andwf	CtrlCmdSpace,W
		btfsc	Zero
		goto	$+5
		
		movlw	01h;08h
		movwf	UsbKeyBuffer0
		movlw	2ch;12h
		movwf	UsbKeyBuffer2
		incf	ScanNumber,F  
		ret

	NormalKeyValue02:
		movlw	E4h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue03
		;call	LockLedState
		;call	DelaySendKeyRoutine
		call	WaitforLangSwitch
		clrf	UsbKeyBuffer2			;remember clrf UsbKeyBuffer2
		;incf	ScanNumber,F 
			
		ret
	
		;movlw	E4h					;gui+'O'
		;xorwf	UsbKeyBuffer2,W
		;btfss	Zero
		;goto	NormalKeyValue03
		;movlw	08h
		;movwf	UsbKeyBuffer0
		;movlw	12h
		;movwf	UsbKeyBuffer2
		;incf	ScanNumber,F
		;ret
	NormalKeyValue03:
		movlw	E5h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue04
		movlw	08h
		movwf	UsbKeyBuffer0
		movlw	0fh
		movwf	UsbKeyBuffer2
		incf	ScanNumber,F
		ret

	NormalKeyValue04:			;command space
		movlw	E6h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue05

		movlw	00h
		clrf	UsbKeyBuffer2
		
		movlw	02h
		andwf	CtrlCmdSpace,W
		btfsc	Zero
		goto	$+5
		
		movlw	08h
		movwf	UsbKeyBuffer0
		movlw	2ch
		movwf	UsbKeyBuffer2
		incf	ScanNumber,F 		
		ret

	NormalKeyValue05:			;command+Q
		movlw	E7h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue06
		movlw	08h;02h
		movwf	UsbKeyBuffer0
		movlw	14h;24h
		movwf	UsbKeyBuffer2
		incf	ScanNumber,F
		ret
		
	NormalKeyValue06:
		clrf	UsbKeyBuffer0
		incf	ScanNumber,F
		movlw	MacWebLength
		;btfss	MacVerFlag
		;movlw	MacWebLength1
		subwf	ScanNumber,W
		btfss	Carry
		ret
		clrf	ScanNumber
		bcf	EndTransFlag
		bcf	DataInFlag1
		bcf	GUIFlag
		bcf	OneFlag
		ret
		
;MoreSendCapsLock:
;  		movfw	39h;CapsLock
;  		movwr	Tx1FifoReg0

;  		movlw	00h
;  		movwr	Tx1FifoReg1
;  		movwr	Tx1FifoReg5
;  		movwr	Tx1FifoReg6
;  		movwr	Tx1FifoReg7
;  		movwf	UsbKeyBuffer3
;  		movwf	UsbKeyBuffer4

; 		movlw	f0h
; 		andwf	Tx1Reg,F
; 		movlw	08h
;		iorwf	Tx1Reg,F
;		movlw	40h
;		xorwf	Tx1Reg,F
;		bsf	Tx1Rdy
;		ret
  Delay5ms:
		clrf	DelayCount_us		;Used for a 5 ms delay at write
  Delay5_ms:
  		Delay_us	8
		decfsz	DelayCount_us,F
		goto	Delay5_ms
		ret


;============================================================================
		;org	0600h
;InitforSecurityKey:
		;clrf	EndMaxURL40h
		;movfw	SecurityKeyIndex
		;movwf	R_I2C_Address
		;call	GetSecurityInfo
		;bsf		gRegisterInitOver
		;ret	
;SendSecurityKey:
		;btfss	gEnterDelayOver
		;ret
		
		;bsf		StartScanFlag
		;btfsc	Tx1Rdy			;is ready to prepare to send packet?
		;ret 

		;movfw	SendSecuritytimes
		;xorlw	03h
		;btfss   Zero
		;goto    $+2 
		;goto	sendzerodata

		;movlw	ReadBuffer
     		;movwf	Fsr
     		;movfw	EndMaxURL40h

     		;addwf	Fsr,F
     		;bsf	RamBank
     		;movfw	Indf
     		;bcf	RamBank
     		;movwf	UsbKeyBuffer0;WorkReg
     		;incf	EndMaxURL40h,F		;transmit 64 times data

		;movlw	ReadBuffer
     		;movwf	Fsr
     		;movfw	EndMaxURL40h

     		;addwf	Fsr,F
     		;bsf	RamBank
     		;movfw	Indf
     		;bcf	RamBank
     		;movwf	UsbKeyBuffer2;WorkReg
     		;incf	EndMaxURL40h,F		;transmit 64 times data
			

		;movfw	UsbKeyBuffer2
		;xorlw	20h
		;btfss	Zero
		;goto	$+4
		;incf	SendSecuritytimes,F
		;clrf	EndMaxURL40h
		;bcf		DataOKFlag
		
		;movfw	UsbKeyBuffer2
  		;movwr	Tx1FifoReg2
		
  		;movfw	UsbKeyBuffer0	;02h
  		;movwr	Tx1FifoReg0
  		;movlw	00h
  		;movwr	Tx1FifoReg3
  		;movwr	Tx1FifoReg4
       		
		;movlw	f0h
		;andwf	Tx1Reg,F
		;movlw	08h
		;iorwf	Tx1Reg,F		;Endpoint1 transmit 8 byte
		;movlw	40h
		;xorwf	Tx1Reg,F
		;bsf	Tx1Rdy 	
		;ret
		
;sendzerodata:
		;btfsc	Tx1Rdy			;is ready to prepare to send packet?
		;ret 
		;movlw	00h 
		;movwr	Tx1FifoReg0
  		;movwr	Tx1FifoReg1
  		;movwr	Tx1FifoReg2
  		;movlw	f0h
		;andwf	Tx1Reg,F
		;movlw	08h
		;iorwf	Tx1Reg,F		;Endpoint1 transmit 8 byte
		;movlw	40h
		;xorwf	Tx1Reg,F		
		;bsf	Tx1Rdy  
		;bcf		DataOKFlag
		;bsf	SendSecurityEnd
		;ret
		
;DelayforSecurity:
		;movfw	TimerRollOver			
		;xorlw	17h
		;btfss	Zero
		;ret
		;movlw	01h
		;subwf	SecurityDelayTime,W
		;btfss	Carry
		;goto	$+7		
		;clrf	TimerRollOver
		;incf	TimeBuffer,F
		;movfw	SecurityDelayTime
		;xorwf	TimeBuffer,W
		;btfss	Zero
		;ret
		;bsf	gEnterDelayOver
		;ret
		
;============================================================================	
GetWindowsInfo:	
		movlw	LanguageNumber
		call	WindowsURLTable
		movwf	LanguageType
		
		movlw	EncryptionType
		call	WindowsURLTable
		movwf	EncryptionValue
			
		movlw	WindowsURLaddrStartLow
		call	WindowsURLTable
		movwf	URLAddressIndex
		
		movlw	WindowsURLaddrLength
		call	WindowsURLTable
		movwf	URLAddressLen
		incf	URLAddressLen,F		;send key judge, necessary			
		
		movlw	WindowsURLaddrEndtLow
		call	WindowsURLTable
		movwf	WindowsURLEnd
		
		movlw	CtrlCmdSpaceType
		call	WindowsURLTable
		movwf	CtrlCmdSpace		
		
		ret
;============================================================================
GetMACInfo:				
		movlw	MACURLaddrStartLow
		call	MACURLTable
		movwf	MacURLAddressIndex;AndroidURLIndex
		
		movlw	MACURLaddrLength
		call	MACURLTable
		movwf	MacURLAddressLen	
		addwf	MacURLAddressLen,F
		movlw	02h
		addwf	MacURLAddressLen,F		
		
		movlw	MACURLaddrEndtLow
		call	MACURLTable
		movwf	MACURLEnd	
		ret		
;============================================================================	
GetAndroidInfo:				
		movlw	AndroidURLaddrStartLow
		call	AndroidURLTable
		movwf	AndroidURLIndex
		
		movlw	AndroidURLaddrLength
		call	AndroidURLTable
		movwf	AndroidURLLength	
		addwf	AndroidURLLength,F
		movlw	02h
		addwf	AndroidURLLength,F		
		
		movlw	AndroidURLaddrEndtLow
		call	AndroidURLTable
		movwf	AndroidURLEnd	
		ret
;============================================================================
;GetTagInfo:				;get 64bytes data from last page
;		movlw	00h
;		movwf	TempReg
;	GetNextTagByte:
;		movfw	R_I2C_Address
;		call	DeviceInfoTable
;		movwf	WorkReg
;		call	StoreReceiveData1
;		incf	R_I2C_Address,F
;		incf	TempReg,F

;		movlw	40h
;		subwf	TempReg,W
;		btfss	Carry
;		goto	GetNextTagByte
;		ret
;=======================================================
StoreReceiveNoEncrytion:
		movlw	ReadBuffer
     		movwf	Fsr
     		movfw	TempReg
     		addwf	Fsr,F
     		movfw	WorkReg
     		bsf	RamBank
     		movwf	Indf
     		bcf	RamBank
		ret
;=======================================================
ChooseLanguageKey:
		btfsc	CheckLanguage
		retlw	14h	
		retlw	04h	
;=======================================================


WaitSendNextURL:		
		btfsc	langSwitchDelayFlag
		goto	WaitSendNextURL_sub		
		clrf	TimerRollOver
		movlw	01h;02h
		movwf	TimerCountH
	WaitSendNextURL_sub:
		bsf		langSwitchDelayFlag
		movlw	03h
		btfsc	AndroidOSFlag
		movlw	02h;05h;10h
		subwf	TimerRollOver,W
		btfss	Carry		
		goto	clrUsbBuffer_android
		testz	TimerCountH
		btfss	Zero
		goto	$+5
		;incf	ScanNumber,F
		bcf		SendKeyNotYetFlag
		clrf	TimerRollOver
		;clrf	UsbKeyBuffer2
		bcf		langSwitchDelayFlag
		ret
		decf	TimerCountH
	clrUsbBuffer_android:
		bsf		SendKeyNotYetFlag
		decf	EndMaxURL40h,F
		decf	EndMaxURL40h,F
		clrf	UsbKeyBuffer0
		clrf	UsbKeyBuffer2
		ret		

;=======================================================
WaitforLangSwitch:
		btfsc	langSwitchDelayFlag
		goto	WaitforLangSwitch_sub
		clrf	TimerRollOver
		movlw	20h
		movwf	TimerCountH
	WaitforLangSwitch_sub:
		bsf		langSwitchDelayFlag
		movlw	10h
		btfsc	AndroidOSFlag
		movlw	30h;50h
		subwf	TimerRollOver,W
		btfss	Carry		
		goto	clrUsbBuffer
		testz	TimerCountH
		btfss	Zero
		goto	$+6
		incf	ScanNumber,F
		clrf	TimerRollOver
		clrf	UsbKeyBuffer2
		bcf		langSwitchDelayFlag
		ret
		decf	TimerCountH
	clrUsbBuffer:
		clrf	UsbKeyBuffer0
		clrf	UsbKeyBuffer2
		ret
		
;=======================================================
GetAndroid64URL:				;get security data from last page
		movlw	00h
		movwf	TempReg
	GetNextAndroid:
		movfw	R_I2C_Address
		call	AndroidURLTable
		movwf	WorkReg
		call	StoreReceiveData1
		incf	R_I2C_Address,F
		incf	TempReg,F
		
		movfw	AndroidURLEnd				;the lastest URL address
		subwf	R_I2C_Address,W
		btfsc	Carry
		ret
		movlw	40h			
		subwf	TempReg,W
		btfss	Carry
		goto	GetNextAndroid
		ret	
;--------------ic initial delay-------------------------
;ICinitdelay:
		;movlw	04h
		;movwf	TEMPE2PDATA
		;movlw	ffh
		;movwf	DelayCount
		;movwf	DelayCountH
		;movwf	TempCount
	;InitWaiting:
		;decf	DelayCount,F
		;testz	DelayCount
		;btfsc	Zero
		;decf	DelayCountH,F
		;testz	DelayCountH
		;btfsc	Zero
		;decf	TempCount,F
		;testz	TempCount
		;btfsc	Zero
		;decf	TEMPE2PDATA,F
		;testz	TEMPE2PDATA
		;btfss	Zero
		;goto	InitWaiting
		;clrf	DelayCount
		;clrf	DelayCountH
		;clrf	TempCount
		;clrf	TEMPE2PDATA
		;ret		
;=======================================================
;WaitforLangSwitch_win:
		;movlw	02h
		;xorwf	Setreportcount,W
		;btfss	Zero
		;goto 	$+4
		;clrf	UsbKeyBuffer2
		;incf	ScanNumber,F
		;ret

		;btfsc	langSwitchDelayFlag
		;goto	WaitforLangSwitch_sub_win
		;clrf	TimerRollOver
		;movlw	08h
		;movwf	TimerCountH
	;WaitforLangSwitch_sub_win:
		;bsf		langSwitchDelayFlag
		;movlw	08h
		;subwf	TimerRollOver,W
		;btfss	Carry		
		;goto	clrUsbBuffer_win
		;testz	TimerCountH
		;btfss	Zero
		;goto	$+5
		;incf	ScanNumber,F
		;clrf	TimerRollOver
		;bcf		langSwitchDelayFlag
		;ret
		;decf	TimerCountH
	;clrUsbBuffer_win:
		;clrf	UsbKeyBuffer0
		;clrf	UsbKeyBuffer2
		;ret
;============================================================================		
		org	0600h	;org	0700h
.TABLE
GetKeyValuePro_Mac:
		addwf	Pcl,F
	MacArray_start:
		retlw	00h
		retlw	E4h			
		retlw	00h		
		retlw	00h			
		retlw	00h 
		retlw	E4h;E3h			;	check ctrl space
		retlw	00h
		retlw	00h
		retlw	00h
		retlw	E3h;E6h			;	check command space
		retlw	00h
		retlw	00h									
		retlw	00h
		retlw	E6h	;00h
		retlw	00h
		retlw	00h		 	 
		retlw	00h
		retlw	00h
		retlw	00h
		retlw	00h
		retlw	00h
		retlw	E1h		;	switch to single char country lang
		retlw	00h
		retlw	00h
		retlw	00h
		retlw	E4h	;00h	;delay
		retlw	00h
		retlw	00h
		retlw	00h
		retlw	00h
		retlw	16h	;	's'
		retlw	00h
		retlw	00h
		retlw	00h;E4h;00h
		retlw	00h
		retlw	00h		
		goto	ChooseLanguageKey    
		retlw	00h
		retlw	00h
		retlw	00h;E4h;00h
		retlw	00h
		retlw	00h
		retlw	09h	;	'f'
		retlw	00h
		retlw	00h
		retlw	00h;E4h;00h
		retlw	00h
		retlw	00h
		goto	ChooseLanguageKey
		retlw	00h
		retlw	00h
		retlw	00h;E4h;00h
		retlw	00h
		retlw	00h
		retlw	15h ;	'r'
		retlw	00h
		retlw	00h
		retlw	00h;E4h;00h
		retlw	00h
		retlw	00h
		retlw	0ch	;	'i'
		retlw	00h	
		retlw	00h
		retlw	E4h;00h
		retlw	00h
		retlw	00h			 
		retlw	00h;28h	;	enter							
		retlw	00h
		retlw	E4h;00h
		retlw	00h		
		retlw	00h
		retlw	00h
		retlw	00h		
		retlw	28h;00h
		retlw	00h
		retlw	00h
		retlw	00h	
		retlw	E4h;00h
		retlw	00h
		retlw	00h		
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h			
		;retlw	00h		
		;retlw	00h
		;retlw	00h
		;retlw	00h		
		;retlw	00h		
		retlw	E5h ;	safari bar selection		
		retlw	00h
		retlw	E5h	;	safari bar selection
		retlw	00h
		retlw	00h		
		;retlw	E4h	;lock leds 				 		
		;retlw	00h
	
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	E1h	;Control+Space
		;retlw	E4h
		;retlw	00h
		;retlw	16h	;s
		;retlw	E4h
		;retlw	00h
		;goto	ChooseLanguageKey;retlw	04h	;a
		;retlw	E4h
		;retlw	00h
		;retlw	09h	;f
		;retlw	E4h
		;retlw	00h
		;goto	ChooseLanguageKey;retlw	04h	;a
		;retlw	E4h
		;retlw	00h
		;retlw	15h	;r
		;retlw	E4h
		;retlw	00h
		;retlw	0ch	;i
		;retlw	E4h
		;retlw	00h
		;retlw	28h
		;retlw	E4h
		;retlw	00h
		;retlw	E4h
		;retlw	00h
		;retlw	E4h
		;retlw	00h		
		;retlw	00h			
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	E4h
		;retlw	00h
		;retlw	E2h
		;retlw	00h
		;retlw	00h
		;retlw	E4h
		;retlw	00h
		;retlw	2ch
		;retlw	00h
		;retlw	00h
	MacArray_end:
.ENDTABLE

;.TABLE
;GetKeyValuePro_Mac1:
;		addwf	Pcl,F
;	MacArray_start1:
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
		;retlw	00h
;		retlw	E1h
;		retlw	00h
;		retlw	51h
;		retlw	00h
		;retlw	51h
		;retlw	00h
;		retlw	52h
;		retlw	00h
		;retlw	52h
		;retlw	00h
;		retlw	51h
;		retlw	00h
;		retlw	51h
;		retlw	28h
;		retlw	00h
		;retlw	29h
		;retlw	00h
		;retlw	29h
		;retlw	00h
;		retlw	29h
;		retlw	00h
;		retlw	29h
;		retlw	00h
;		retlw	29h
;		retlw	00h
;		retlw	29h
;		retlw	00h
;		retlw	E2h
;		retlw	00h
;		retlw	E2h
;		retlw	00h
;		retlw	2ch
;		retlw	00h
;	MacArray_end1:
;.ENDTABLE
;================================================================================
PrepareData_Win:
		btfss	DataInFlag1
		ret
		btfsc	OneFlag
		ret
		bsf	TransFlag
		bsf	OneFlag
		btfsc	PlugFlag
		ret
		movfw	ScanNumber
		call	GetKeyValuePro_WinA
		movwf	UsbKeyBuffer2
		movlw	E1h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue1_Win
		call	Get_LedState
		incf	ScanNumber,F
		ret
	NormalKeyValue1_Win:
		movlw	E2h					;gui+'R'
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue2_Win
		movlw	08h
		movwf	UsbKeyBuffer0
		movlw	15h
		movwf	UsbKeyBuffer2
		incf	ScanNumber,F
		ret
	NormalKeyValue2_Win:
		movlw	E3h					;shift+end
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue02_Win
		movlw	02h;08h;
		movwf	UsbKeyBuffer0
		movlw	4dh;00h;
		movwf	UsbKeyBuffer2
		incf	ScanNumber,F
		ret
	NormalKeyValue02_Win:
		movlw	E5h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue03_Win
		call	Set_LedState			;detect led status and let NumLock and CapsLock on
		incf	ScanNumber,F
		ret
	NormalKeyValue03_Win:
		movlw	E6h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	NormalKeyValue04_Win
		movlw	0ch
		xorwf	getstring2counter,W
		btfss	Zero
		goto	$+4						;if getstring2counter!=0ch, incf and ret
		movlw	02h
		subwf	Setreportcount,W
		btfsc	Carry
		;goto	WaitforLangSwitch_win
		
		;movfw   UsbLedDataTemp
		;andlw   02h
		;btfss	Zero		
		incf	ScanNumber,F		
		clrf	UsbKeyBuffer2			;remember use specific char like 'E6', must be clear value before sent
		ret		
	NormalKeyValue04_Win:
		clrf	UsbKeyBuffer0
		incf	ScanNumber,F
		movlw	WinWebLength
		subwf	ScanNumber,W
		btfss	Carry
		ret
		clrf	ScanNumber
		bcf	GUIFlag
		bcf	EndTransFlag
		bcf	DataInFlag1
		bcf	OneFlag
		ret

;==================================================================================
.TABLE
GetKeyValuePro_WinA:
		addwf	Pcl,F
	WinArray_startA:
		;retlw	E1h	;get leds state
		retlw	00h	;ICH6 specific
		retlw	00h	;checking point
		retlw	00h
		retlw	00h
		retlw	00h
		retlw	00h
		retlw	00h
		retlw	00h
		retlw	00h
		retlw	00h
		retlw	00h
		retlw	E6h	;ICH6 specific
		retlw	00h
		retlw	00h
		retlw	00h	
		retlw	00h
		retlw	00h
		retlw	E5h	;set leds state
		retlw	00h
		retlw	00h
		retlw	00h	;E3h
		retlw	E2h	;win+r
		retlw	00h	;E3h;
		retlw	4Ah	;homeE2h;
		retlw	00h	;E3h;
		retlw	E3h	;shift+end E2h;
		retlw	00h	
		retlw	2Ah	;back space
		retlw	00h
		retlw	00h

	WinArray_endA:
.ENDTABLE
;==============================================================================
;Function:Get_LedState
;Get leds state
;==============================================================================
Get_LedState:
		movlw	00h
		movwf	UsbKeyBuffer0
		movwf	UsbKeyBuffer2
		movwf	UsbKeyBuffer4
		movlw	39h				;CapsLock
		movwf	UsbKeyBuffer3
		ret
;==============================================================================
;Function:Set_LedState
;Enable capslock&numlock
;==============================================================================
Set_LedState:
		movlw	00h
		movwf	KeyPress0
		movwf	KeyPress1
		movwf	KeyPress2
		movwf   UsbKeyBuffer0
		movwf   UsbKeyBuffer2
		movwf   UsbKeyBuffer3
		movwf   UsbKeyBuffer4
		movwf	UsbKeyBuffer5

		movfw   UsbLedDataTemp
		andlw   01h
		btfss	Zero
		goto	LockState2
		movlw   53h				;NumLock
		movwf	KeyPress0
		movwf	UsbKeyBuffer3
	LockState2:
		movfw   UsbLedDataTemp
		andlw   02h
		btfss	Zero
		goto	LockState3
		movlw   39h				;CapsLock
		btfsc AndroidOSFlag		;URL must use with lower case letter in Android
		movlw	00h
		movwf	KeyPress1
		movwf	UsbKeyBuffer4
	LockState3:
		movfw   UsbLedDataTemp
		andlw   04h
		btfsc	Zero
		goto	LockState4
		movlw   47h				;Scroll Lock
		movwf	KeyPress2
		movwf	UsbKeyBuffer5
	LockState4:
		ret

;==============================================================================
;Function:Restore_LedState
;restore leds state
;==============================================================================
Restore_LedState:
		clrf    UsbKeyBuffer0
		movfw   KeyPress0
		movwf	UsbKeyBuffer2
	;	movlw	00h
	;	testz   KeyPress1
	;	btfsc	Zero
	;	movlw	39h
		movfw	KeyPress1
		movwf	UsbKeyBuffer3
		movfw   KeyPress2
		movwf	UsbKeyBuffer4
     		ret

;==============================================================================
;Function:LockLedState
;Lock leds state
;==============================================================================
;LockLedState:
		;btfsc	RestorLedsFlag
		;bcf	DataOKFlag
		;bcf	RestorLedsFlag
		;clrf    UsbKeyBuffer0
		;clrf    UsbKeyBuffer4
		;movlw   53h
		;movwf	UsbKeyBuffer2
		;movlw   39h
		;movwf	UsbKeyBuffer3
		;ret
;==============================================================================
;Function:DataTransfer
;Transfer data from the buffer to bus
;==============================================================================

DataTransfer1:
		btfsc	TransFlag
		goto	SendDataReport
		ret
  SendDataReport:
  		btfsc	Tx1Rdy
  		ret
		
		movlw	01h
		movwr	Tx1FifoReg0
		
  		movfw	UsbKeyBuffer0
  		movwr	Tx1FifoReg1;Tx1FifoReg0
  		movfw	UsbKeyBuffer2
  		movwr	Tx1FifoReg3;Tx1FifoReg2
  		movfw	UsbKeyBuffer3
  		movwr	Tx1FifoReg4;Tx1FifoReg3
  		movfw	UsbKeyBuffer4
  		movwr	Tx1FifoReg5;Tx1FifoReg4
  		movlw	00h
  		;movwr	Tx1FifoReg1
  		;movwr	Tx1FifoReg5
  		movwr	Tx1FifoReg6
  		movwr	Tx1FifoReg7
  		movwf	UsbKeyBuffer3
  		movwf	UsbKeyBuffer4

 		movlw	f0h
 		andwf	Tx1Reg,F
 		movlw	08h
		iorwf	Tx1Reg,F
		movlw	40h
		xorwf	Tx1Reg,F
		bsf	Tx1Rdy

		;call	DelaySendKeyRoutine
		
		bcf	OneFlag
  		bcf	TransFlag
  		btfsc	WinRFlag
  		goto	EnterDelay200ms
  		btfsc	EnterFlag
  		goto	EnterDelay200ms

		movlw	28h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	JudgeDelay
		btfsc	EndTransFlag
		goto	$+3
		bsf	EndTransFlag
		goto	EnterDelay
		bcf	DataOKFlag
	JudgeDelay:
		movlw	08h
		xorwf	UsbKeyBuffer0,W
		btfss	Zero
		goto	JudgeCtrlF3
		movlw	15h				;'R'
		xorwf	UsbKeyBuffer2,W
		btfsc	Zero
		goto	DelayPro
		movlw	0fh				;'L'
		xorwf	UsbKeyBuffer2,W
		btfsc	Zero
		goto	DelayPro
		movlw	2bh				;'tab'
		xorwf	UsbKeyBuffer2,W
		btfsc	Zero
		goto	DelayPro
		movlw	1ah				;'W'
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	JudgeCtrlF3
	DelayPro:
		bsf	WinRFlag
		clrf	TimerRollOver
		goto	NoEnterOrWinL
JudgeCtrlF3:
		movlw	01h
		xorwf	UsbKeyBuffer0,W
		btfss	Zero
		goto	JudgeCommShiftA
		bsf	WinRFlag
		clrf	TimerRollOver
		goto	NoEnterOrWinL
JudgeCommShiftA:
		movlw	0ah
		xorwf	UsbKeyBuffer0,W
		btfss	Zero
		goto	JudgeEnter
		movlw	04h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	JudgeEnter
		bsf	WinRFlag
		clrf	TimerRollOver
		goto	NoEnterOrWinL
JudgeEnter:
		movlw	00h
		xorwf	UsbKeyBuffer0,W
		btfss	Zero
		goto	NoEnterOrWinL
		movlw	FEh
		andwf	UsbKeyBuffer2,W
		xorlw	28h
		btfss	Zero
		goto	NoEnterOrWinL
		bsf	WinRFlag
		clrf	TimerRollOver
NoEnterOrWinL:
		clrf	UsbKeyBuffer0
  		clrf	UsbKeyBuffer2
  		ret
EnterDelay:
		btfsc	OSType
		ret
		bsf	EnterFlag
		clrf	TimerRollOver
		movlw	02h
		btfss	MacVerFlag
		movlw	00h
		movwf	TimerCountH
		ret
	EnterDelay200ms:
		bsf	PlugFlag
		movlw	40h;f0h
		btfsc	WinRFlag
		movlw	20h;34h
		subwf	TimerRollOver,W
		btfss	Carry
		ret
		testz	TimerCountH
		btfss	Zero
		goto	$+5
		bcf	EnterFlag
		bcf	WinRFlag
		bcf	PlugFlag
		ret
		decf	TimerCountH,F
		clrf	TimerRollOver
		ret
;==============================================================================
;Function:PrepareDataTask
;  1.Prepare data to usb buffer
;  2.judge key press or release
;==============================================================================
PrepareDataTask:

		btfss	OSType
		goto	PrepareDataTask_Mac

	PrepareDataTask_Win:
		;btfsc	MoreOnceAltFlag
		;ret
		btfss	DataOKFlag
		ret						;no key press
		btfsc	OneFlag			;if this flag is 1, send alt+key, else send alt only
		ret

		movlw	UsbReport
		movwf	UsbRequireState
		bsf	OneFlag

		btfsc	WinTransAscII
		goto	PrepareData_Ascii
		btfsc	RestorLedsFlag
		goto	PrepareData_Leds

		testz	ReadURLTime
		btfss	Zero
		call	ReceiveNtimeData	;receive 64 data (URL)

		movlw	ReadBuffer
     		movwf	Fsr
     		movfw	EndMaxURL40h

     		addwf	Fsr,F
     		bsf	RamBank
     		movfw	Indf
     		bcf	RamBank
     		movwf	WorkReg
     		incf	EndMaxURL40h,F		;transmit 64 times data

     		movlw	01h
		addwf	TempCount,F

NormalKeyValuePro_Win:
     		movfw	WorkReg
     		movwf	WorkRegTemp
     		movwf	UsbKeyBuffer2

		movlw	00h
		movwf	AsciiMSC
		movwf	AsciiMID
		movwf	AsciiLSC

		movlw	02h
		movwf	AsciiMSC
		movlw	200d
		subwf	WorkRegTemp,W
		movwf	WorkReg
		btfsc	Carry
		goto	NormalKeyValue_Win
		movlw	01h
		movwf	AsciiMSC
		movlw	100d
		subwf	WorkRegTemp,W
		movwf	WorkReg
		btfsc	Carry
		goto	NormalKeyValue_Win
		movfw	WorkRegTemp
		movwf	WorkReg
		movlw	00h
		movwf	AsciiMSC

	NormalKeyValue_Win:
		movfw	WorkReg
		call	HexToDecTable
		movwf	WorkRegTemp
		movlw	0fh
		andwf	WorkRegTemp,W
		movwf	AsciiLSC
		swapf	WorkRegTemp,F
		movlw	0fh
		andwf	WorkRegTemp,W
		movwf	AsciiMID

		movfw	AsciiMSC
		call	KeypadTable
		movwf	AsciiMSC
		movfw	AsciiMID
		call	KeypadTable
		movwf	AsciiMID
		movfw	AsciiLSC
		call	KeypadTable
		movwf	AsciiLSC

		movlw	04h
		movwf	UsbKeyBuffer0
		movlw	01h
		movwf	ScanNumber
		bsf	WinTransAscII
ExitPreDataPro_Win:
		;movfw	TempCount
		;movwf	TempReg

		;movfw	MaxURLLength
		movfw	URLAddressLen
		btfss	urladd1forenter
		movwf	URLLenTemp
		bsf		urladd1forenter
		decf	URLLenTemp,F
		;subwf	TempReg,W
		btfsc	Zero
		goto	TransmitENTERData_Win
		movfw	AsciiMSC		;send MSC of the transfered data
		movwf	UsbKeyBuffer2
		ret
		

	JudgeTransmitLength_Win:
		;btfsc	Zero
		;goto	DetectDataISZero_Win
		;btfss	Carry
		;goto	DetectDataISZero_Win
		;goto	TransmitENTERData_Win

DetectDataISZero_Win:
		;testz	UsbKeyBuffer2
		;btfsc	Zero			;if 0,send enter key
		;goto	TransmitENTERData_Win
		;movlw	ffh
		;xorwf	UsbKeyBuffer2,W
		;btfsc	Zero
		;goto	TransmitENTERData_Win
		
		;movfw	AsciiMSC		;send MSC of the transfered data
		;movwf	UsbKeyBuffer2
		;ret

TransmitENTERData_Win:
		movlw	00h
		movwf	UsbKeyBuffer0
		movlw	28h
		movwf	UsbKeyBuffer2
		bcf	WinTransAscII
		ret

KeypadTable:
		addwf	Pcl,F
		retlw	62h
		retlw	59h
		retlw	5ah
		retlw	5bh
		retlw	5ch
		retlw	5dh
		retlw	5eh
		retlw	5fh
		retlw	60h
		retlw	61h
PrepareData_Ascii:
		movlw	04h			
		movwf	UsbKeyBuffer0
		incf	ScanNumber,F
		movfw	AsciiMID		;send MID of the transfered data
		movwf	UsbKeyBuffer2
		movlw	02h
		xorwf	ScanNumber,W
		btfsc	Zero
		ret
		bcf	WinTransAscII
		;bsf	MoreOnceAltFlag
		movfw	AsciiLSC		;send LSC of the transfered data
		movwf	UsbKeyBuffer2
		ret
PrepareData_Leds:
		bcf	EndTransFlag
		bcf	RestorLedsFlag
		call	Restore_LedState
		bcf	DataOKFlag
		ret
;==================================================================
PrepareDataTask_Mac:
		btfsc	WinRFlag
		ret
		btfss	DataOKFlag
		ret				;no key press
		btfsc	OneFlag
		ret

		movlw	UsbReport
		movwf	UsbRequireState
		bsf	OneFlag

		testz	ReadURLTime
		btfss	Zero
		call	ReceiveNtimeData	;receive 64 data from 24C02
		
		
		movlw	ReadBuffer
     		movwf	Fsr
     		movfw	EndMaxURL40h


     		addwf	Fsr,F
     		bsf	RamBank
     		movfw	Indf
     		bcf	RamBank
     		movwf	WorkReg
			movwf	UsbKeyBuffer0
     		incf	EndMaxURL40h,F		;transmit 64 times data

		movlw	ReadBuffer
     		movwf	Fsr
     		movfw	EndMaxURL40h

     		addwf	Fsr,F
     		bsf	RamBank
     		movfw	Indf
     		bcf	RamBank
     		movwf	WorkReg
			movwf	UsbKeyBuffer2
     		incf	EndMaxURL40h,F		;transmit 64 times data

		call	WaitSendNextURL
		btfsc	SendKeyNotYetFlag
		ret
		bcf		SendKeyNotYetFlag	
		
			;movlw	00h
			;movwf	UsbKeyBuffer0
			;movlw	1ah
			;movwf	UsbKeyBuffer2
			
     	;	movlw	01h
		;addwf	TempCount,F

		;call	Judge_CapitalPro
		;call	Judge_SymbolPro

;NormalKeyValuePro:
     	;	movfw	WorkReg
     	;	call	ASCIIChangeToUSBCode_US
		;movwf	UsbKeyBuffer2

	;NormalKeyValue:
		;movlw	02h			;left shift
		;movwf	UsbKeyBuffer0
		;testz	Judge_Capital
		;btfsc	Zero
		;clrf	UsbKeyBuffer0

ExitPreDataPro:
		;movfw	TempCount
		;movwf	TempReg

		;movfw	MaxURLLength
		;subwf	TempReg,F
		
		movfw	MacURLAddressLen
			btfsc	AndroidOSFlag		;if OS is android
			movfw	AndroidURLLength
		btfss	urladd1forenter
		movwf	URLLenTemp
		bsf		urladd1forenter
		decf	URLLenTemp,F
		decf	URLLenTemp,F
		btfsc	Zero
		goto	TransmitENTERData
		ret

	JudgeTransmitLength:
		;btfsc	Zero
		;goto	DetectDataISZero
		;btfss	Carry
		;goto	DetectDataISZero
		;goto	TransmitENTERData

DetectDataISZero:
		;testz	UsbKeyBuffer2
		;btfsc	Zero			;if 0,send enter key
		;goto	TransmitENTERData
		;movlw	ffh
		;xorwf	UsbKeyBuffer2,W
		;btfss	Zero
		;ret

TransmitENTERData:
		movlw	00h
		movwf	UsbKeyBuffer0
		movlw	28h
		movwf	UsbKeyBuffer2
		ret
;_______________________________________________________________

ReceiveNtimeData:		
		movlw	01h
		xorwf	ReadI2CAddressH,W
		btfsc	Zero
		goto	Each64Loop;$+9;$+7
		movfw	URLAddressIndex		;basically, beside first get 64 bytes data, every loop should not entry this branch
		btfss	OSType
		movfw	MacURLAddressIndex
			btfsc	AndroidOSFlag	;if OS is android
			movfw	AndroidURLIndex
		xorwf	R_I2C_Address,W
		btfsc	Zero
		goto	ActualGet64;$+7
	Each64Loop:
		movlw	40h					;check 64 bytes/each read loop
		xorwf	EndMaxURL40h,W
		btfss	Zero
		ret


		clrf	EndMaxURL40h		;every 64 bytes, clear it for next 64bytes
		decf	ReadURLTime,F
		

	ActualGet64:
;		btfss	E2PROMFlag
;		goto	$+8
;		call	I2C_Receive_Nbyte_E2PROM512
;		bcf		Carry
;		movlw	40h
;		addwf	R_I2C_Address,F
;		btfsc	Carry
;		incf	ReadI2CAddressH,F		
;		ret	;goto	$+2
		btfsc	AndroidOSFlag	;if OS is android
		goto	 $+3
		call	Get64ByteInfo
		goto	 $+2
		call 	GetAndroid64URL
		
		ret
;_______________________________________________________________
Judge_CapitalPro:
		clrf	Judge_Capital		;small letter flag
		movlw	41h
		subwf	WorkReg,W
		btfss	Carry
		ret

		movlw	05ah+1
		subwf	WorkReg,W
		btfsc	Carry
		ret

		movlw	01h			;[41h~5ah] is capital
		movwf	Judge_Capital		;capital flag,must press SHIFT key
		ret
;_______________________________________________________________
Judge_SymbolPro:
		testz	Judge_Capital
		btfss	Zero
		ret

     		movlw	7eh			;'~'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

     		movlw	21h			;'!'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

     		movlw	40h			;'@'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

		movlw	23h			;'#'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

		movlw	24h			;'$'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

		movlw	25h			;'%'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

     		movlw	5eh			;'^'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

     		movlw	26h			;'&'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

		movlw	2ah			;'*'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

		movlw	28h			;'('
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

		movlw	29h			;')'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

     		movlw	5fh			;'_'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

     		movlw	2bh			;'+'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

		movlw	7bh			;'{'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

		movlw	7dh			;'}'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

		movlw	3ah			;':'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

     		movlw	22h			;'"'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

     		movlw	3ch			;'<'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

		movlw	3eh			;'>'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

		movlw	3fh			;'?'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey

		movlw	7ch			;'|'
     		xorwf	WorkReg,W
     		btfsc	Zero
		goto	PressShiftKey
		ret

	PressShiftKey:
		movlw	01h
		movwf	Judge_Capital
		ret
;==============================================================================
;Function:ReportTask
;Send InOutBuffer data to Tx1FifoReg
;==============================================================================
ReportTask:
		movlw	UsbNoReport				;send alt only or send clear txfifo
		subwf	UsbRequireState,W
		btfsc	Zero
		goto	SendstoppacketNow

		movlw	UsbReport				;send alt+key
		subwf	UsbRequireState,W		
		btfsc	Zero
		goto	SendpacketNow
		ret
SendstoppacketNow:
		btfss	BreakFlag
		ret

		btfsc	Tx1Rdy			;is ready to prepare to send packet?
		ret
		
		movlw	01h				;report id(1)
		movwr	Tx1FifoReg0
		
		movlw	00h
		btfsc	WinTransAscII		
		movlw	04h	
		movwr	Tx1FifoReg1;Tx1FifoReg0		
		movlw	00h
		;movwr	Tx1FifoReg1
		movwr	Tx1FifoReg2
		movwr	Tx1FifoReg3
		movwr	Tx1FifoReg4
		movwr	Tx1FifoReg5
		movwr	Tx1FifoReg6
		movwr	Tx1FifoReg7
		bcf	BreakFlag
		bcf	OneFlag
		goto	SendReportNow
SendpacketNow:
		btfsc	Tx1Rdy			;is ready to prepare to send packet?
		ret
		
		movlw	01h
		movwr	Tx1FifoReg0
		
  		movfw	UsbKeyBuffer0
 		movwr	Tx1FifoReg1;Tx1FifoReg0
  		movfw	UsbKeyBuffer2
  		movwr	Tx1FifoReg3;Tx1FifoReg2
  		movfw	UsbKeyBuffer3
  		movwr	Tx1FifoReg4;Tx1FifoReg3
  		movfw	UsbKeyBuffer4
  		movwr	Tx1FifoReg5;Tx1FifoReg4
  		movlw	00h
  		;movwr	Tx1FifoReg1
  		;movwr	Tx1FifoReg5
  		;movwr	Tx1FifoReg6
  		;movwr	Tx1FifoReg7
  		movwf	UsbKeyBuffer3
  		movwf	UsbKeyBuffer4
  		bsf	BreakFlag			;set 1 for send alt only between twice alt+key

SendReportNow:
		movlw	f0h
		andwf	Tx1Reg,F
		movlw	08h
		iorwf	Tx1Reg,F		;Endpoint1 transmit 8 byte
		movlw	40h
		xorwf	Tx1Reg,F
		bsf	Tx1Rdy

		;call	DelaySendKeyRoutine
		
		movlw	UsbNoReport
		;btfsc	MoreOnceAltFlag
		;movlw	03h
		movwf	UsbRequireState

		btfss	EndTransFlag
		goto	$+6
		btfss	OSType
		goto	$+3
		bsf	RestorLedsFlag
		goto	$+2
		bcf	DataOKFlag

		movlw	28h
		xorwf	UsbKeyBuffer2,W
		btfss	Zero
		goto	clrbuff;$+7
		
		bsf	EndTransFlag
		call DelaySendKeyRoutine	;wait enter transfer out
		btfsc OSType
		goto clrbuff;$+4
		
		bcf AndroidURLDoneFlag
		btfss	AndroidOSFlag
		goto $+3	
		bsf AndroidURLDoneFlag
		goto clrbuff	;ready to send third key
		
		
		bcf	DeviceR
		sleep
		goto $-1
clrbuff:
	  	clrf	UsbKeyBuffer0
		clrf	UsbKeyBuffer2
		ret
		


;========================================================================
;  This is the ASCII change to usb code
;========================================================================
		org	0900h;org	0a00h
;========================================================================
ASCIIChangeToUSBCode_US:
		addwf	Pcl,F
		retlw	00h	; //" " 000	NUL    (Null char.)
		retlw	00h	; //" " 001        SOH    (. of Header)
		retlw	00h	; //" " 002        STX    (Start of Text)
		retlw	00h	; //" " 003        ETX    (End of Text)
		retlw	00h	; //" " 004        EOT    (End of Transmission)
		retlw	00h	; //" " 005        ENQ    (Enquiry)
		retlw	00h	; //" " 006        ACK    (Acknowledgment)
		retlw	00h	; //" " 007        BEL    (Bell)
		retlw	00h	; //" " 008         BS    (Backspace)
		retlw	00h	; //" " 009         HT    (Horizontal Tab)
		retlw	00h	; //" " 00A         LF    (Line Feed)
		retlw	00h	; //" " 00B         VT    (Vertical Tab)
		retlw	00h	; //" " 00C         FF    (Form Feed)
		retlw	00h	; //" " 00D         CR    (Carriage Return)
		retlw	00h	; //" " 00E         SO    (Shift Out)
		retlw	00h	; //" " 00F         SI    (Shift In)
		retlw	00h	; //" " 010	DLE    (Data Link Escape)
		retlw	00h	; //" " 011        DC1 (XON) (Device Control 1)
		retlw	00h	; //" " 012        DC2       (Device Control 2)
		retlw	00h	; //" " 013        DC3 (XOFF)(Device Control 3)
		retlw	00h	; //" " 014        DC4       (Device Control 4)
		retlw	00h	; //" " 015        NAK    (Negative Acknowledgement)
		retlw	00h	; //" " 016        SYN    (Synchronous Idle)
		retlw	00h	; //" " 017        ETB    (End of Trans. Block)
		retlw	00h	; //" " 018        CAN    (Cancel)
		retlw	00h	; //" " 019         EM    (End of Medium)
		retlw	00h	; //" " 01A        SUB    (Substitute)
		retlw	00h	; //" " 01B        ESC    (Escape)
		retlw	00h	; //" " 01C         FS    (File Separator)
		retlw	00h	; //" " 01D         GS    (Group Separator)
		retlw	00h	; //" " 01E         RS    (Request to Send)(Record Separator)
		retlw	00h	; //" " 01F         US    (Unit Separator)
		retlw	2ch	; //" " 020
		retlw	1eh	; //"!" 021
		retlw	34h	; //""" 022
		retlw	20h	; //"#" 023
		retlw	21h	; //"$" 024
		retlw	22h	; //"%" 025
		retlw	24h	; //"&" 026
		retlw	34h	; //"'" 027
		retlw	26h	; //"(" 028
		retlw	27h	; //")" 029
		retlw	25h	; //"*" 02A
		retlw	2eh	; //"+" 02B
		retlw	36h	; //"," 02C
		retlw	2dh	; //"-" 02D
		retlw	37h	; //"." 02E
		retlw	38h	; //"/" 02F
		retlw	27h	; //"0" 030
		retlw	1eh	; //"1" 031
		retlw	1fh	; //"2" 032
		retlw	20h	; //"3" 033
		retlw	21h	; //"4" 034
		retlw	22h	; //"5" 035
		retlw	23h	; //"6" 036
		retlw	24h	; //"7" 037
		retlw	25h	; //"8" 038
		retlw	26h	; //"9" 039
		retlw	33h	; //":" 03A
		retlw	33h	; //";" 03B
		retlw	36h	; //"<" 03C
		retlw	2eh	; //"=" 03D
		retlw	37h	; //">" 03E
		retlw	38h	; //"?" 03F
		retlw	1fh	; //"@" 040
		retlw	04h	; //"A" 041
		retlw	05h	; //"B" 042
		retlw	06h	; //"C" 043
		retlw	07h	; //"D" 044
		retlw	08h	; //"E" 045
		retlw	09h	; //"F" 046
		retlw	0ah	; //"G" 047
		retlw	0bh	; //"H" 048
		retlw	0ch	; //"I" 049
		retlw	0dh	; //"J" 04A
		retlw	0eh	; //"K" 04B
		retlw	0fh	; //"L" 04C
		retlw	10h	; //"M" 04D
		retlw	11h	; //"N" 04E
		retlw	12h	; //"O" 04F
		retlw	13h	; //"P" 050
		retlw	14h	; //"Q" 051
		retlw	15h	; //"R" 052
		retlw	16h	; //"S" 053
		retlw	17h	; //"T" 054
		retlw	18h	; //"U" 055
		retlw	19h	; //"V" 056
		retlw	1ah	; //"W" 057
		retlw	1bh	; //"X" 058
		retlw	1ch	; //"Y" 059
		retlw	1dh	; //"Z" 05A
		retlw	2fh	; //"[" 05B
		retlw	31h	; //"\" 05C
		retlw	30h	; //"]" 05D
		retlw	23h	; //"^" 05E
		retlw	2dh	; //"_" 05F
		retlw	35h	;32h	; //"'" 060
		retlw	04h	; //"a" 061
		retlw	05h	; //"b" 062
		retlw	06h	; //"c" 063
		retlw	07h	; //"d" 064
		retlw	08h	; //"e" 065
		retlw	09h	; //"f" 066
		retlw	0ah	; //"g" 067
		retlw	0bh	; //"h" 068
		retlw	0ch	; //"i" 069
		retlw	0dh	; //"j" 06A
		retlw	0eh	; //"k" 06B
		retlw	0fh	; //"l" 06C
		retlw	10h	; //"m" 06D
		retlw	11h	; //"n" 06E
		retlw	12h	; //"o" 06F
		retlw	13h	; //"p" 070
		retlw	14h	; //"q" 071
		retlw	15h	; //"r" 072
		retlw	16h	; //"s" 073
		retlw	17h	; //"t" 074
		retlw	18h	; //"u" 075
		retlw	19h	; //"v" 076
		retlw	1ah	; //"w" 077
		retlw	1bh	; //"x" 078
		retlw	1ch	; //"y" 079
		retlw	1dh	; //"z" 07A
		retlw	2fh	; //"{" 07B
		retlw	31h	; //"|" 07C
		retlw	30h	; //"}" 07D
		retlw	35h	;32h	; //"~" 07E

;////////////////////////////////////////////////////////////////////////
;7eh(~/`)32h
;21h(!/1)1eh
;40h(@/2)1fh
;23h(#/3)20h
;24h($/4)21h
;25h(%/5)22h
;5eh(^/6)23h
;26h(&/7)24h
;2ah(*/8)25h
;28h((/9)26h
;29h()/0)27h
;5fh(_/-)2dh
;2bh(+/=)2eh
;7bh({/[)2fh
;7dh(}/])30h
;3ah(:/;)33h
;22h("/')34h
;3ch(</,)36h
;3eh(>/.)37h
;3fh(?//)38h
;7ch(|/\)31h
;must press shift key
;========================================================================
;========================================================================
HexToDecTable:
	addwf	Pcl,F
	retlw	00h
	retlw	01h
	retlw	02h
	retlw	03h
	retlw	04h
	retlw	05h
	retlw	06h
	retlw	07h
	retlw	08h
	retlw	09h
	retlw	10h
	retlw	11h
	retlw	12h
	retlw	13h
	retlw	14h
	retlw	15h
	retlw	16h
	retlw	17h
	retlw	18h
	retlw	19h
	retlw	20h
	retlw	21h
	retlw	22h
	retlw	23h
	retlw	24h
	retlw	25h
	retlw	26h
	retlw	27h
	retlw	28h
	retlw	29h
	retlw	30h
	retlw	31h
	retlw	32h
	retlw	33h
	retlw	34h
	retlw	35h
	retlw	36h
	retlw	37h
	retlw	38h
	retlw	39h
	retlw	40h
	retlw	41h
	retlw	42h
	retlw	43h
	retlw	44h
	retlw	45h
	retlw	46h
	retlw	47h
	retlw	48h
	retlw	49h
	retlw	50h
	retlw	51h
	retlw	52h
	retlw	53h
	retlw	54h
	retlw	55h
	retlw	56h
	retlw	57h
	retlw	58h
	retlw	59h
	retlw	60h
	retlw	61h
	retlw	62h
	retlw	63h
	retlw	64h
	retlw	65h
	retlw	66h
	retlw	67h
	retlw	68h
	retlw	69h
	retlw	70h
	retlw	71h
	retlw	72h
	retlw	73h
	retlw	74h
	retlw	75h
	retlw	76h
	retlw	77h
	retlw	78h
	retlw	79h
	retlw	80h
	retlw	81h
	retlw	82h
	retlw	83h
	retlw	84h
	retlw	85h
	retlw	86h
	retlw	87h
	retlw	88h
	retlw	89h
	retlw	90h
	retlw	91h
	retlw	92h
	retlw	93h
	retlw	94h
	retlw	95h
	retlw	96h
	retlw	97h
	retlw	98h
	retlw	99h

;=======================================================
Get64ByteInfo:				;get 64bytes data from last page
		movlw	00h
		movwf	TempReg
	GetNextByte:
		movfw	R_I2C_Address			
		;call	DeviceInfoTable
		
		btfsc	OSType	
		goto	 $+3
		call	MACURLTable;DeviceInfoTable
		goto	 $+2
		call 	WindowsURLTable		
		
		movwf	WorkReg
		call	StoreReceiveData1
		incf	R_I2C_Address,F
		incf	TempReg,F
		movfw	WindowsURLEnd;MacURLAddressIndex
		btfss	OSType
		movfw	MACURLEnd;SecurityKeyIndex				;the lastest URL address
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
	