
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MyProject.c,20 :: 		void interrupt()       // Kesme alt program?
;MyProject.c,22 :: 		if(PORTB.B1){
	BTFSS      PORTB+0, 1
	GOTO       L_interrupt0
;MyProject.c,24 :: 		delay_ms(10000); // 10 sn bekle
	MOVLW      127
	MOVWF      R11+0
	MOVLW      212
	MOVWF      R12+0
	MOVLW      49
	MOVWF      R13+0
L_interrupt1:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt1
	DECFSZ     R12+0, 1
	GOTO       L_interrupt1
	DECFSZ     R11+0, 1
	GOTO       L_interrupt1
	NOP
	NOP
;MyProject.c,25 :: 		}
L_interrupt0:
;MyProject.c,26 :: 		INTCON.INTF=0;
	BCF        INTCON+0, 1
;MyProject.c,27 :: 		}
L_end_interrupt:
L__interrupt18:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;MyProject.c,29 :: 		void main() {
;MyProject.c,30 :: 		Lcd_init();
	CALL       _Lcd_Init+0
;MyProject.c,31 :: 		ADC_init();
	CALL       _ADC_Init+0
;MyProject.c,32 :: 		ANSEL  = 0x03;              // AN0 ve AN1 pini analog olarak ayarlanýyor.
	MOVLW      3
	MOVWF      ANSEL+0
;MyProject.c,33 :: 		ANSELH = 0;                 // Diðer pinler dijital olarak ayarlanýyor
	CLRF       ANSELH+0
;MyProject.c,34 :: 		C1ON_bit = 0;               // Karsilastiricilar kapali
	BCF        C1ON_bit+0, BitPos(C1ON_bit+0)
;MyProject.c,35 :: 		C2ON_bit = 0;
	BCF        C2ON_bit+0, BitPos(C2ON_bit+0)
;MyProject.c,36 :: 		TRISB = 0x00;               // B portu çýkýþ olarak tanýmlanýyor
	CLRF       TRISB+0
;MyProject.c,38 :: 		PORTB.B1 = 1;               //Yeþil led
	BSF        PORTB+0, 1
;MyProject.c,39 :: 		PORTB.B2 = 0;               //Kýrmýzý led
	BCF        PORTB+0, 2
;MyProject.c,40 :: 		PORTB.B3 =0;                 //Buzzer
	BCF        PORTB+0, 3
;MyProject.c,41 :: 		INTCON.GIE=1; // Tüm kesmeler aktif.
	BSF        INTCON+0, 7
;MyProject.c,42 :: 		INTCON.INTE=1; // RB0/INT dýþ kesme biti
	BSF        INTCON+0, 4
;MyProject.c,43 :: 		OPTION_REG.INTEDG=0; // Interrupt kenarý seçme biti 1: Yükselen, 0: Düþen
	BCF        OPTION_REG+0, 6
;MyProject.c,46 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,47 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,48 :: 		Lcd_Out(1,1,"Akilli  Konteynir");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_MyProject+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,49 :: 		Lcd_Out(2,1,"Uygulama");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_MyProject+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,50 :: 		Delay_ms(2000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
	DECFSZ     R11+0, 1
	GOTO       L_main2
	NOP
;MyProject.c,52 :: 		while(1){
L_main3:
;MyProject.c,53 :: 		gas=Adc_read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _gas+0
	MOVF       R0+1, 0
	MOVWF      _gas+1
;MyProject.c,54 :: 		agirlik=Adc_read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _agirlik+0
	MOVF       R0+1, 0
	MOVWF      _agirlik+1
;MyProject.c,56 :: 		if(agirlik>500 || gas>500){
	MOVF       R0+1, 0
	SUBLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main20
	MOVF       R0+0, 0
	SUBLW      244
L__main20:
	BTFSS      STATUS+0, 0
	GOTO       L__main16
	MOVF       _gas+1, 0
	SUBLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main21
	MOVF       _gas+0, 0
	SUBLW      244
L__main21:
	BTFSS      STATUS+0, 0
	GOTO       L__main16
	GOTO       L_main7
L__main16:
;MyProject.c,57 :: 		if(agirlik>500){
	MOVF       _agirlik+1, 0
	SUBLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main22
	MOVF       _agirlik+0, 0
	SUBLW      244
L__main22:
	BTFSC      STATUS+0, 0
	GOTO       L_main8
;MyProject.c,58 :: 		PORTB.B1=0;
	BCF        PORTB+0, 1
;MyProject.c,59 :: 		PORTB.B2=1;
	BSF        PORTB+0, 2
;MyProject.c,60 :: 		PORTB.B3=1;
	BSF        PORTB+0, 3
;MyProject.c,61 :: 		intToStr(agirlik,agirlikDeger);
	MOVF       _agirlik+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _agirlik+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _agirlikDeger+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;MyProject.c,62 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,63 :: 		Lcd_Out(1,1,"Agirlik Uyarisi");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_MyProject+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,64 :: 		Lcd_Out(2,1,agirlikDeger);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _agirlikDeger+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,65 :: 		delay_ms(2000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	DECFSZ     R11+0, 1
	GOTO       L_main9
	NOP
;MyProject.c,66 :: 		}
L_main8:
;MyProject.c,67 :: 		if(gas>500){
	MOVF       _gas+1, 0
	SUBLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main23
	MOVF       _gas+0, 0
	SUBLW      244
L__main23:
	BTFSC      STATUS+0, 0
	GOTO       L_main10
;MyProject.c,68 :: 		PORTB.B1=0;
	BCF        PORTB+0, 1
;MyProject.c,69 :: 		PORTB.B2=1;
	BSF        PORTB+0, 2
;MyProject.c,70 :: 		PORTB.B3=1;
	BSF        PORTB+0, 3
;MyProject.c,71 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,72 :: 		Lcd_Out(1,1,"Gaz Uyarisi");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_MyProject+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,73 :: 		intToStr(gas,gasDeger);
	MOVF       _gas+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _gas+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _gasDeger+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;MyProject.c,74 :: 		Lcd_Out(2,1,gasDeger);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _gasDeger+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,75 :: 		delay_ms(2000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main11:
	DECFSZ     R13+0, 1
	GOTO       L_main11
	DECFSZ     R12+0, 1
	GOTO       L_main11
	DECFSZ     R11+0, 1
	GOTO       L_main11
	NOP
;MyProject.c,76 :: 		}
L_main10:
;MyProject.c,77 :: 		}
	GOTO       L_main12
L_main7:
;MyProject.c,79 :: 		PORTB.B1=1;
	BSF        PORTB+0, 1
;MyProject.c,80 :: 		PORTB.B2=0;
	BCF        PORTB+0, 2
;MyProject.c,81 :: 		PORTB.B3=0;
	BCF        PORTB+0, 3
;MyProject.c,82 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,83 :: 		Lcd_Out(1,5,"Sorun");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_MyProject+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,84 :: 		Lcd_Out(2,6,"Yok");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_MyProject+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,85 :: 		delay_ms(1000);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main13:
	DECFSZ     R13+0, 1
	GOTO       L_main13
	DECFSZ     R12+0, 1
	GOTO       L_main13
	DECFSZ     R11+0, 1
	GOTO       L_main13
	NOP
;MyProject.c,87 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,88 :: 		Lcd_Out(1,1,"Gaz Seviyesi");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_MyProject+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,89 :: 		intToStr(gas,gasDeger);
	MOVF       _gas+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _gas+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _gasDeger+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;MyProject.c,90 :: 		Lcd_Out(2,1,gasDeger);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _gasDeger+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,91 :: 		delay_ms(1000);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main14:
	DECFSZ     R13+0, 1
	GOTO       L_main14
	DECFSZ     R12+0, 1
	GOTO       L_main14
	DECFSZ     R11+0, 1
	GOTO       L_main14
	NOP
;MyProject.c,93 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,94 :: 		Lcd_Out(1,1,"Agirlik Seviyesi");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_MyProject+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,95 :: 		intToStr(agirlik,agirlikDeger);
	MOVF       _agirlik+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _agirlik+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _agirlikDeger+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;MyProject.c,96 :: 		Lcd_Out(2,1,agirlikDeger);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _agirlikDeger+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,97 :: 		delay_ms(1000);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main15:
	DECFSZ     R13+0, 1
	GOTO       L_main15
	DECFSZ     R12+0, 1
	GOTO       L_main15
	DECFSZ     R11+0, 1
	GOTO       L_main15
	NOP
;MyProject.c,98 :: 		}
L_main12:
;MyProject.c,99 :: 		}
	GOTO       L_main3
;MyProject.c,100 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
