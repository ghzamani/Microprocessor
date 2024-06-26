#include <mega32.h>
#include <alcd.h>
#include <stdio.h>
#include <delay.h>

void request(void)
{
    DDRD = 0x01;
    PORTD.0 = 0;  
    delay_ms(100);
    PORTD.0 = 1;
}

void response(void)
{
    DDRD = 0x00;
    while(PIND.0 == 1);
    while(PIND.0 == 0);
    while(PIND.0 == 1);
}

unsigned char receive_data(void)
{
    int counter_bit;
    int data = 0;
    for(counter_bit=0; counter_bit<8; counter_bit++)
    {
        while(PIND.0 == 0);
        delay_us(50);
        if(PIND.0==1)
            data=(data<<1)|(0x01);  
        else data=data<<1;        
        while(PIND.0==1);
    }  
    return data;
}

void main(void)
{
    char lcd_message[16];
    char check_sum = 0, int_temperature = 0, int_humidity = 0, dec_temperature = 0, dec_humidity = 0; 
    
    lcd_init(16);
    
    // SET B0 TO OUTPUT 
    DDRB = 0X01;
    PORTB.0 = 0;
    
    delay_ms(1000); 
    
    while (1)
    {   
        request(); 
        response();

        int_humidity = receive_data();  
        dec_humidity = receive_data();
        int_temperature = receive_data();
        dec_temperature = receive_data();
        check_sum = receive_data(); 
        
        if (int_temperature + dec_temperature + int_humidity + dec_humidity != check_sum)
            continue;
        
        sprintf(lcd_message,"Humidity:%d %% ",int_humidity);
        lcd_gotoxy(0,0);
        lcd_puts(lcd_message);

        if (int_humidity<40 || int_humidity>60)
            PORTB.0 =1 ;
        else PORTB.0 = 0;
    }
}
