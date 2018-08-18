/**
  ******************************************************************************
  * @file       main.c
  * @author     Burak Keten
  * @version    V1.0.0
  * @date       18-August-2018
  * @compiler   SDCC
  * @brief      Led blinking
  ******************************************************************************
**/

#include "stm8l.h"

void Clock_Init(void);
void GPIO_Init(void);
void _delay(void);

void main(void)
{
  Clock_Init();
  GPIO_Init();

  PE_ODR |= (1 << 7);   //yesil led yakiliyor
  PC_ODR &= ~(1 << 7);  //mavi led söndürülüyor

  for(;;)
  {
    PE_ODR ^= (1 << 7); //yesil led blinking
    PC_ODR ^= (1 << 7); //mavi led blinking
    _delay();           //bekleme

  }
}

void Clock_Init(void)
{
   CLK_ICKCR = 0x01;            //High-speed internal RC oscillator ON
   while(!(CLK_ICKCR & 0x02));  //HSI clock hazir olana kadar bekle
   CLK_SWR = 0x01;              //HSI selected as systemclock source
   while(CLK_SCSR!=0x01);       //HSI Systemclock icin stabilizasyonu saglanana kadar bekle
   CLK_CKDIVR = 0x00;           //System clock source/1
}

void GPIO_Init(void)
{
   // Yesil Led (PE7)
   PE_DDR |= (1 << 7);  //Output olarak ayarlaniyor
   PE_CR1 |= (1 << 7);  //Push-pull
   PE_ODR &= (0 << 7);  //Cikis degeri

   // Mavi Led (PC7)
   PC_DDR |= (1 << 7);  //Output olarak ayarlaniyor
   PC_CR1 |= (1 << 7);  //Push-pull
   PC_ODR &= (0 << 7);  //Cikis degeri
}

void _delay(void)
{
  unsigned long int j=150000;
  while(j--);
}
