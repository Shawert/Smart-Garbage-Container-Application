#line 1 "C:/Users/pymuz/OneDrive/Masaüstü/KendiDenemem/MyProject.c"
sbit LCD_RS at RD0_bit;
sbit LCD_EN at RD1_bit;
sbit LCD_D4 at RD2_bit;
sbit LCD_D5 at RD3_bit;
sbit LCD_D6 at RD4_bit;
sbit LCD_D7 at RD5_bit;

sbit LCD_RS_Direction at TRISD0_bit;
sbit LCD_EN_Direction at TRISD1_bit;
sbit LCD_D4_Direction at TRISD2_bit;
sbit LCD_D5_Direction at TRISD3_bit;
sbit LCD_D6_Direction at TRISD4_bit;
sbit LCD_D7_Direction at TRISD5_bit;

unsigned int gas=0;
unsigned int agirlik=0 , cnt=0;
char gasDeger[7];
char agirlikDeger[7];

void interrupt()
{
 if(PORTB.B1){

 delay_ms(10000);
 }
 INTCON.INTF=0;
}

void main() {
Lcd_init();
ADC_init();
ANSEL = 0x03;
ANSELH = 0;
C1ON_bit = 0;
C2ON_bit = 0;
TRISB = 0x00;

PORTB.B1 = 1;
PORTB.B2 = 0;
PORTB.B3 =0;
INTCON.GIE=1;
INTCON.INTE=1;
OPTION_REG.INTEDG=0;


Lcd_Cmd(_LCD_CLEAR);
Lcd_Cmd(_LCD_CURSOR_OFF);
Lcd_Out(1,1,"Akilli  Konteynir");
Lcd_Out(2,1,"Uygulama");
Delay_ms(2000);

while(1){
gas=Adc_read(0);
agirlik=Adc_read(1);

if(agirlik>500 || gas>500){
 if(agirlik>500){
 PORTB.B1=0;
 PORTB.B2=1;
 PORTB.B3=1;
 intToStr(agirlik,agirlikDeger);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Agirlik Uyarisi");
 Lcd_Out(2,1,agirlikDeger);
 delay_ms(2000);
 }
 if(gas>500){
 PORTB.B1=0;
 PORTB.B2=1;
 PORTB.B3=1;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Gaz Uyarisi");
 intToStr(gas,gasDeger);
 Lcd_Out(2,1,gasDeger);
 delay_ms(2000);
 }
 }
 else{
 PORTB.B1=1;
 PORTB.B2=0;
 PORTB.B3=0;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,5,"Sorun");
 Lcd_Out(2,6,"Yok");
 delay_ms(1000);

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Gaz Seviyesi");
 intToStr(gas,gasDeger);
 Lcd_Out(2,1,gasDeger);
 delay_ms(1000);

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Agirlik Seviyesi");
 intToStr(agirlik,agirlikDeger);
 Lcd_Out(2,1,agirlikDeger);
 delay_ms(1000);
 }
 }
}
