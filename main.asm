;Karim Abou Nassif
;Synthesizer v1.0


.def workhorse = r20
.def io_set = r16
.def output = r17
.def temp = r18
.def count = r19

.cseg


.org 0x0100
.macro    set_Pointer    
	ldi @0, low(@2)    
	ldi @1, high(@2)    
.endmacro 


.org 0x0000		rjmp setup

.org 0x001C		rjmp ISR_SAW
			;rjmp ISR_TriSine					;Comment out to choose waveform

.org 0x002A		rjmp ISR_ADC


.org 0x0400

triangle_Inc: .db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35,  \
			      36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69,\
				  70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, \
				  103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, \
				  130,131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156,  \
				  157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, \
				  184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, \
				  211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, \
				  238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255

triangle_Dec: .db 254, 253, 252, 251, 250, 249, 248, 247, 246, 245, 244, 243, 242, 241, 240, 239, 238, 237, 236, 235, \
				  234, 233, 232, 231, 230, 229, 228, 227, 226, 225, 224, 223, 222, 221, 220, 219, 218, 217, 216, 215, \
				  214, 213, 212, 211, 210, 209, 208, 207, 206, 205, 204, 203, 202, 201, 200, 199, 198, 197, 196, 195, \
				  194, 193, 192, 191, 190, 189, 188, 187, 186, 185, 184, 183, 182, 181, 180, 179, 178, 177, 176, 175, \
				  174, 173, 172, 171, 170, 169, 168, 167, 166, 165, 164, 163, 162, 161, 160, 159, 158, 157, 156, 155, \
				  154, 153, 152, 151, 150, 149, 148, 147, 146, 145, 144, 143, 142, 141, 140, 139, 138, 137, 136, 135, \
				  134, 133, 132, 131, 130, 129, 128, 127, 126, 125, 124, 123, 122, 121, 120, 119, 118, 117, 116, 115, \
				  114, 113, 112, 111, 110, 109, 108, 107, 106, 105, 104, 103, 102, 101, 100, 99, 98, 97, 96, 95, 94,  \
				  93, 92, 91, 90, 89, 88, 87, 86, 85, 84, 83, 82, 81, 80, 79, 78, 77, 76, 75, 74, 73, 72, 71, 70, 69, \
				  68, 67, 66, 65, 64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, \
				  43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, \
				  18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 0

sine_array:		.db 128,131,134,137,140,143,146,149,152,156,159,162,165,168,171,174,176,179,182,185, 188,191,193,196,199,   \
				201,204,206,209,211,213,216,218,220,222,224,226,228,230,232,234, 236,237,239,240,242,243,245,246,247,248,   \
				249,250,251,252,252,253,254,254,255,255,255,255, 255,255,255,255,255,255,255,254,254,253,252,252,251,250,   \
				249,248,247,246,245,243,242,240,239,237,236,234,232,230,228,226,224,222,220,218,216,213,211,209,206,204,    \
				201,199,196,193,191,188,185,182,179,176,174,171,168,165,162,159,156,152,149,146,143,140,137,134,131,128,    \
				124,121,118,115,112,109,106,103,99, 96, 93, 90, 87, 84, 81, 79, 76, 73, 70, 67, 64, 62, 59, 56, 54, 51,     \
				49, 46, 44, 42, 39, 37, 35, 33, 31, 29, 27, 25, 23, 21, 19, 18, 16, 15, 13, 12, 10, 9, 8, 7, 6, 5, 4, 3,    \
				3, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 15, 16, 18, 19,   \
				21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 42, 44, 46, 49, 51, 54, 56, 59, 62, 64, 67, 70, 73, 76, 79, 81, 84, \
				87, 90, 93, 96, 99, 103, 106, 109, 112, 115, 118, 121, 124 



setup:				ldi io_set, 0xFF
				out DDRD, io_set				
				ldi output, 0					;initializing output (the register I feed to PORTD)
				ldi workhorse, 0b11101111		
				sts ADCSRA, workhorse				;enables ADC and the ADC Interrupt
				ldi workhorse, 0b01100101		
				sts ADMUX, workhorse				;setting up the ADC/picking ADC 2
				ldi workhorse, 0b00000011		
				out TCCR0B, workhorse				;prescalar for timer
				ldi workhorse, 0b00000010
				out TCCR0A, workhorse
				ldi workhorse, 0b00000010
				sts TIMSK0, workhorse				;enable overflow interrupt
				ldi workhorse, 0b00000000
				sts OCR0A, workhorse				;setting timer to 0
				sei						;enabling interrupts
				rjmp sawtooth					;uncomment rjmp statement of waveform you wish to generate (as well as appropriate ISR above)
				;rjmp tri_Inc
				;rjmp sine_Init


//Sawtooth Waveform 'Method'//

sawtooth:			out PORTD, output
				rjmp sawtooth

//Triangle Waveform 'Method'//
				
tri_Inc:			set_Pointer ZL,ZH, triangle_Inc*2		;macro stores triangle_Inc array into Z
				ldi count, 0
				rjmp tri_Loop
				
tri_Loop:			out PORTD, output				;Since 255 values are being loaded for the wave, count goes from 1-255
				cpi count, 255					;At 255 the decrementing loop is called to avoid overflow
				breq tri_Dec_Init
				rjmp tri_Loop

tri_Dec_Init:			set_Pointer ZL,ZH, triangle_Dec*2		;macro stores triangleDec array into Z
				ldi count, 0
				rjmp tri_Dec

tri_Dec:			out PORTD, output				;the same process as triLoop but inversed
				cpi count, 255
				breq tri_Inc
				rjmp tri_Dec

//Sine Waveform 'Method'//

sine_Init:			set_Pointer ZL,ZH, sine_array*2
				ldi count, 0
				rjmp sine_loop

sine_loop:			out PORTD, output
				cpi count, 255
				breq sine_Init
				rjmp sine_loop


//Interrupt Service Routine for Sawtooth//

ISR_SAW:			push workhorse				;Setting up the ISR.
				in workhorse, SREG		
				push workhorse
				inc output				;The part that actually makes a sawtooth wave.
				pop workhorse
				out SREG, workhorse
				pop workhorse
				reti

//Interrupt Service Routine for Triangle and Sine Waves//

ISR_TriSine:			lds workhorse, SREG			;Setting up the ISR.
				push workhorse
				lpm output, Z+				;Gives output the next value in the array then moves forward one (with the array being each element, ordered)
				inc count				;Count is used to return to beginning of sine wave, or to switch to decrementing portion of triangle waveform
				pop workhorse
				sts SREG, workhorse	
				reti


ISR_ADC:			lds workhorse, SREG			;Setting up the ADC portion of the ISR
				push workhorse
				lds workhorse, ADCH
				out OCR0A, workhorse
				pop workhorse
				sts SREG, workhorse
				reti
