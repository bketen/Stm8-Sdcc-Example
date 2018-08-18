;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.7.2 #10507 (MINGW64)
;--------------------------------------------------------
	.module main
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _Clock_Init
	.globl _GPIO_Init
	.globl __delay
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
;--------------------------------------------------------
; Stack segment in internal ram 
;--------------------------------------------------------
	.area	SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area DABS (ABS)
;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------
	.area HOME
__interrupt_vect:
	int s_GSINIT ; reset
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
__sdcc_gs_init_startup:
__sdcc_init_data:
; stm8_genXINIT() start
	ldw x, #l_DATA
	jreq	00002$
00001$:
	clr (s_DATA - 1, x)
	decw x
	jrne	00001$
00002$:
	ldw	x, #l_INITIALIZER
	jreq	00004$
00003$:
	ld	a, (s_INITIALIZER - 1, x)
	ld	(s_INITIALIZED - 1, x), a
	decw	x
	jrne	00003$
00004$:
; stm8_genXINIT() end
	.area GSFINAL
	jp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
__sdcc_program_startup:
	jpf	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	main.c: 18: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	main.c: 20: Clock_Init();
	callf	_Clock_Init
;	main.c: 21: GPIO_Init();
	callf	_GPIO_Init
;	main.c: 23: PE_ODR |= (1 << 7);   //yesil led yakiliyor
	bset	20500, #7
;	main.c: 24: PC_ODR &= ~(1 << 7);  //mavi led söndürülüyor
	bres	20490, #7
00102$:
;	main.c: 28: PE_ODR ^= (1 << 7); //yesil led blinking
	bcpl	20500, #7
;	main.c: 29: PC_ODR ^= (1 << 7); //mavi led blinking
	bcpl	20490, #7
;	main.c: 30: _delay();           //bekleme
	callf	__delay
	jra	00102$
;	main.c: 33: }
	retf
;	main.c: 35: void Clock_Init(void)
;	-----------------------------------------
;	 function Clock_Init
;	-----------------------------------------
_Clock_Init:
;	main.c: 37: CLK_ICKCR = 0x01;            //High-speed internal RC oscillator ON
	mov	0x50c2+0, #0x01
;	main.c: 38: while(!(CLK_ICKCR & 0x02));  //HSI clock hazir olana kadar bekle
00101$:
	ld	a, 0x50c2
	bcp	a, #0x02
	jreq	00101$
;	main.c: 39: CLK_SWR = 0x01;              //HSI selected as systemclock source
	mov	0x50c8+0, #0x01
;	main.c: 40: while(CLK_SCSR!=0x01);       //HSI Systemclock icin stabilizasyonu saglanana kadar bekle
00104$:
	ld	a, 0x50c7
	dec	a
	jrne	00104$
;	main.c: 41: CLK_CKDIVR = 0x00;           //System clock source/1
	mov	0x50c0+0, #0x00
;	main.c: 42: }
	retf
;	main.c: 44: void GPIO_Init(void)
;	-----------------------------------------
;	 function GPIO_Init
;	-----------------------------------------
_GPIO_Init:
;	main.c: 47: PE_DDR |= (1 << 7);  //Output olarak ayarlaniyor
	bset	20502, #7
;	main.c: 48: PE_CR1 |= (1 << 7);  //Push-pull
	bset	20503, #7
;	main.c: 49: PE_ODR &= (0 << 7);  //Cikis degeri
	ld	a, 0x5014
	mov	0x5014+0, #0x00
;	main.c: 52: PC_DDR |= (1 << 7);  //Output olarak ayarlaniyor
	bset	20492, #7
;	main.c: 53: PC_CR1 |= (1 << 7);  //Push-pull
	ld	a, 0x500d
	or	a, #0x80
	ld	0x500d, a
;	main.c: 54: PC_ODR &= (0 << 7);  //Cikis degeri
	ld	a, 0x500a
	mov	0x500a+0, #0x00
;	main.c: 55: }
	retf
;	main.c: 57: void _delay(void)
;	-----------------------------------------
;	 function _delay
;	-----------------------------------------
__delay:
	sub	sp, #8
;	main.c: 60: while(j--);
	ldw	y, #0x49f0
	ldw	x, #0x0002
	ldw	(0x05, sp), x
00101$:
	ldw	x, (0x05, sp)
	ldw	(0x01, sp), x
	ldw	x, y
	subw	y, #0x0001
	ld	a, (0x06, sp)
	sbc	a, #0x00
	ld	(0x06, sp), a
	ld	a, (0x05, sp)
	sbc	a, #0x00
	ld	(0x05, sp), a
	tnzw	x
	jrne	00101$
	ldw	x, (0x01, sp)
	jrne	00101$
;	main.c: 61: }
	addw	sp, #8
	retf
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
