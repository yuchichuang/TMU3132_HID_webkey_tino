;=================================================================================================
; 	Tenx TP6620
;
;==================================================================================================
;==================================================================================================
;	   System Definitions
;==================================================================================================

;------------- USB ID infomation define ------------------------
VID_HI			equ		05h;11h;
VID_LO			equ		ach;30h;
PID_HI			equ		02h;98h;
PID_LO			equ		0bh;08h;


;------------- CLOCK initial define ------------
TP6620_CLK_INI	equ	28h

;---------- Interrupt Enable Setup Define ----------
;WARNING: Be carefully when open EXT/TM0 interrupt enable
EN_INT0_NONE	equ	e0h	;When Reset
EN_INT1_NONE	equ	15h
EN_INT0_UNCONF	equ	e0h	;When Unconfig
EN_INT1_UNCONF	equ	15h
EN_INT0_NORMAL	equ	fch	;AddEp1 efh;AddEp2	e7h	;When Config	;Enable Suspend
EN_INT1_NORMAL	equ	15h
EN_INT0_SUSPEND	equ	e0h ;When Suspend
EN_INT1_SUSPEND equ	1ch	;	Enable Resume
