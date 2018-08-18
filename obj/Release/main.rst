                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 3.7.2 #10507 (MINGW64)
                                      4 ;--------------------------------------------------------
                                      5 	.module main
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _main
                                     12 	.globl _Clock_Init
                                     13 	.globl _GPIO_Init
                                     14 	.globl __delay
                                     15 ;--------------------------------------------------------
                                     16 ; ram data
                                     17 ;--------------------------------------------------------
                                     18 	.area DATA
                                     19 ;--------------------------------------------------------
                                     20 ; ram data
                                     21 ;--------------------------------------------------------
                                     22 	.area INITIALIZED
                                     23 ;--------------------------------------------------------
                                     24 ; Stack segment in internal ram 
                                     25 ;--------------------------------------------------------
                                     26 	.area	SSEG
      FFFFFF                         27 __start__stack:
      FFFFFF                         28 	.ds	1
                                     29 
                                     30 ;--------------------------------------------------------
                                     31 ; absolute external ram data
                                     32 ;--------------------------------------------------------
                                     33 	.area DABS (ABS)
                                     34 ;--------------------------------------------------------
                                     35 ; interrupt vector 
                                     36 ;--------------------------------------------------------
                                     37 	.area HOME
      008000                         38 __interrupt_vect:
      008000 82 00 80 08             39 	int s_GSINIT ; reset
                                     40 ;--------------------------------------------------------
                                     41 ; global & static initialisations
                                     42 ;--------------------------------------------------------
                                     43 	.area HOME
                                     44 	.area GSINIT
                                     45 	.area GSFINAL
                                     46 	.area GSINIT
      008008                         47 __sdcc_gs_init_startup:
      008008                         48 __sdcc_init_data:
                                     49 ; stm8_genXINIT() start
      008008 AE 00 00         [ 2]   50 	ldw x, #l_DATA
      00800B 27 07            [ 1]   51 	jreq	00002$
      00800D                         52 00001$:
      00800D 72 4F 00 00      [ 1]   53 	clr (s_DATA - 1, x)
      008011 5A               [ 2]   54 	decw x
      008012 26 F9            [ 1]   55 	jrne	00001$
      008014                         56 00002$:
      008014 AE 00 00         [ 2]   57 	ldw	x, #l_INITIALIZER
      008017 27 09            [ 1]   58 	jreq	00004$
      008019                         59 00003$:
      008019 D6 80 AA         [ 1]   60 	ld	a, (s_INITIALIZER - 1, x)
      00801C D7 00 00         [ 1]   61 	ld	(s_INITIALIZED - 1, x), a
      00801F 5A               [ 2]   62 	decw	x
      008020 26 F7            [ 1]   63 	jrne	00003$
      008022                         64 00004$:
                                     65 ; stm8_genXINIT() end
                                     66 	.area GSFINAL
      008022 CC 80 04         [ 2]   67 	jp	__sdcc_program_startup
                                     68 ;--------------------------------------------------------
                                     69 ; Home
                                     70 ;--------------------------------------------------------
                                     71 	.area HOME
                                     72 	.area HOME
      008004                         73 __sdcc_program_startup:
      008004 AC 00 80 25      [ 2]   74 	jpf	_main
                                     75 ;	return from main will return to caller
                                     76 ;--------------------------------------------------------
                                     77 ; code
                                     78 ;--------------------------------------------------------
                                     79 	.area CODE
                                     80 ;	main.c: 18: void main(void)
                                     81 ;	-----------------------------------------
                                     82 ;	 function main
                                     83 ;	-----------------------------------------
      008025                         84 _main:
                                     85 ;	main.c: 20: Clock_Init();
      008025 8D 00 80 44      [ 5]   86 	callf	_Clock_Init
                                     87 ;	main.c: 21: GPIO_Init();
      008029 8D 00 80 5E      [ 5]   88 	callf	_GPIO_Init
                                     89 ;	main.c: 23: PE_ODR |= (1 << 7);   //yesil led yakiliyor
      00802D 72 1E 50 14      [ 1]   90 	bset	20500, #7
                                     91 ;	main.c: 24: PC_ODR &= ~(1 << 7);  //mavi led söndürülüyor
      008031 72 1F 50 0A      [ 1]   92 	bres	20490, #7
      008035                         93 00102$:
                                     94 ;	main.c: 28: PE_ODR ^= (1 << 7); //yesil led blinking
      008035 90 1E 50 14      [ 1]   95 	bcpl	20500, #7
                                     96 ;	main.c: 29: PC_ODR ^= (1 << 7); //mavi led blinking
      008039 90 1E 50 0A      [ 1]   97 	bcpl	20490, #7
                                     98 ;	main.c: 30: _delay();           //bekleme
      00803D 8D 00 80 81      [ 5]   99 	callf	__delay
      008041 20 F2            [ 2]  100 	jra	00102$
                                    101 ;	main.c: 33: }
      008043 87               [ 5]  102 	retf
                                    103 ;	main.c: 35: void Clock_Init(void)
                                    104 ;	-----------------------------------------
                                    105 ;	 function Clock_Init
                                    106 ;	-----------------------------------------
      008044                        107 _Clock_Init:
                                    108 ;	main.c: 37: CLK_ICKCR = 0x01;            //High-speed internal RC oscillator ON
      008044 35 01 50 C2      [ 1]  109 	mov	0x50c2+0, #0x01
                                    110 ;	main.c: 38: while(!(CLK_ICKCR & 0x02));  //HSI clock hazir olana kadar bekle
      008048                        111 00101$:
      008048 C6 50 C2         [ 1]  112 	ld	a, 0x50c2
      00804B A5 02            [ 1]  113 	bcp	a, #0x02
      00804D 27 F9            [ 1]  114 	jreq	00101$
                                    115 ;	main.c: 39: CLK_SWR = 0x01;              //HSI selected as systemclock source
      00804F 35 01 50 C8      [ 1]  116 	mov	0x50c8+0, #0x01
                                    117 ;	main.c: 40: while(CLK_SCSR!=0x01);       //HSI Systemclock icin stabilizasyonu saglanana kadar bekle
      008053                        118 00104$:
      008053 C6 50 C7         [ 1]  119 	ld	a, 0x50c7
      008056 4A               [ 1]  120 	dec	a
      008057 26 FA            [ 1]  121 	jrne	00104$
                                    122 ;	main.c: 41: CLK_CKDIVR = 0x00;           //System clock source/1
      008059 35 00 50 C0      [ 1]  123 	mov	0x50c0+0, #0x00
                                    124 ;	main.c: 42: }
      00805D 87               [ 5]  125 	retf
                                    126 ;	main.c: 44: void GPIO_Init(void)
                                    127 ;	-----------------------------------------
                                    128 ;	 function GPIO_Init
                                    129 ;	-----------------------------------------
      00805E                        130 _GPIO_Init:
                                    131 ;	main.c: 47: PE_DDR |= (1 << 7);  //Output olarak ayarlaniyor
      00805E 72 1E 50 16      [ 1]  132 	bset	20502, #7
                                    133 ;	main.c: 48: PE_CR1 |= (1 << 7);  //Push-pull
      008062 72 1E 50 17      [ 1]  134 	bset	20503, #7
                                    135 ;	main.c: 49: PE_ODR &= (0 << 7);  //Cikis degeri
      008066 C6 50 14         [ 1]  136 	ld	a, 0x5014
      008069 35 00 50 14      [ 1]  137 	mov	0x5014+0, #0x00
                                    138 ;	main.c: 52: PC_DDR |= (1 << 7);  //Output olarak ayarlaniyor
      00806D 72 1E 50 0C      [ 1]  139 	bset	20492, #7
                                    140 ;	main.c: 53: PC_CR1 |= (1 << 7);  //Push-pull
      008071 C6 50 0D         [ 1]  141 	ld	a, 0x500d
      008074 AA 80            [ 1]  142 	or	a, #0x80
      008076 C7 50 0D         [ 1]  143 	ld	0x500d, a
                                    144 ;	main.c: 54: PC_ODR &= (0 << 7);  //Cikis degeri
      008079 C6 50 0A         [ 1]  145 	ld	a, 0x500a
      00807C 35 00 50 0A      [ 1]  146 	mov	0x500a+0, #0x00
                                    147 ;	main.c: 55: }
      008080 87               [ 5]  148 	retf
                                    149 ;	main.c: 57: void _delay(void)
                                    150 ;	-----------------------------------------
                                    151 ;	 function _delay
                                    152 ;	-----------------------------------------
      008081                        153 __delay:
      008081 52 08            [ 2]  154 	sub	sp, #8
                                    155 ;	main.c: 60: while(j--);
      008083 90 AE 49 F0      [ 2]  156 	ldw	y, #0x49f0
      008087 AE 00 02         [ 2]  157 	ldw	x, #0x0002
      00808A 1F 05            [ 2]  158 	ldw	(0x05, sp), x
      00808C                        159 00101$:
      00808C 1E 05            [ 2]  160 	ldw	x, (0x05, sp)
      00808E 1F 01            [ 2]  161 	ldw	(0x01, sp), x
      008090 93               [ 1]  162 	ldw	x, y
      008091 72 A2 00 01      [ 2]  163 	subw	y, #0x0001
      008095 7B 06            [ 1]  164 	ld	a, (0x06, sp)
      008097 A2 00            [ 1]  165 	sbc	a, #0x00
      008099 6B 06            [ 1]  166 	ld	(0x06, sp), a
      00809B 7B 05            [ 1]  167 	ld	a, (0x05, sp)
      00809D A2 00            [ 1]  168 	sbc	a, #0x00
      00809F 6B 05            [ 1]  169 	ld	(0x05, sp), a
      0080A1 5D               [ 2]  170 	tnzw	x
      0080A2 26 E8            [ 1]  171 	jrne	00101$
      0080A4 1E 01            [ 2]  172 	ldw	x, (0x01, sp)
      0080A6 26 E4            [ 1]  173 	jrne	00101$
                                    174 ;	main.c: 61: }
      0080A8 5B 08            [ 2]  175 	addw	sp, #8
      0080AA 87               [ 5]  176 	retf
                                    177 	.area CODE
                                    178 	.area CONST
                                    179 	.area INITIALIZER
                                    180 	.area CABS (ABS)
