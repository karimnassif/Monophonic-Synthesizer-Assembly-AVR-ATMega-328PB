# Monophonic-Synthesizer-Assembly---AVR-ATMega-328PB-

This project is an assembly based monophonic synthesizer programmed on an AVR ATMega-328PB. 
The hardware is the above kit with an 2-2R ladder (the DAC used for this purpose) receiving input from PORTD and sending output 
to a Piezo speaker (or any compatible speaker). 

The program can generate frequency waves in three forms: sawtooth, triangle and sine. In order to switch between the three, uncomment
the applicable rjmp command within setup as well as the applicable rjmp to ISR in the 0x001C .org space (Note sawtooth has its own 
ISR while sine and triangle waves share one.) Frequency can be changed by modifying the prescalar (a comment labels this). 

Functionality:
The waveforms are generated through the use of an ADC-backed ISR. Timer0 runs in the background and sends an overflow interrupt at a 
frequency determined by the prescalar variable. For the sawtooth wave this simply increments the output voltage variable with no control
as an overflow resets the value and thus generates the sawtooth shape. For triangle and sine a different ISR command block is used,
as both of these are determined by arrays. Arrays hold each step's value for these two forms, and with each overflow interrupt the 
program cycles forward to the next item.
