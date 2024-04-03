#include <mega32.h>
#include <delay.h>

int pause = 0;
int number = 0;

interrupt [TIM1_COMPA] void timer1_compa_isr(void) {
    if (pause == 0) {
        number += 1;
        number %= 10;
    }
}

interrupt [EXT_INT2] void ext_int2_isr(void) {
    pause ^= 1;
}

void main(void) {
    DDRC = 0xFF; //output port
    DDRA = 0x00; 
    
    //set for interrupts
    GICR |= 0xE0;
    MCUCR = 0x0A;
    MCUCSR = 0x00;
    GIFR = 0xE0;
    
    // timer configurations
    TCCR1B = 0x0C;
    OCR1AH = 0x7A;
    OCR1AL = 0x12;

    TIMSK = 0x12;

    // Global enable interrupts
    #asm("sei")
    
    while (1) {  
        PORTC = number;
    }
}
