TITLE HW4     (AddTwo.asm)

;Author: SR Kanna
;Email: kannas@oregonstate.edu
;Class Number/Section: CS271-400   
; Assignment number: 4				Assignment Due Date: 11/8/2015 
  
; Description:  This program will introduce the programmer, get the user to input two numbers and produce
;	the sum, difference, product, quotient and remainder of the two numbers

;Comment Outline: 
;	The first section of code is an introduction where I query a pre-written string and display it to the user
;	The second portion is to get the data, where I ask the user to enter a negative number and keep going until a positive number is entered
;	The third protion is to calculate the required values. I will use variables to keep track of the sum, count and number entered by the user
;	I used a prompt to display the results for the user (average, sum, count)
;	I said goodbye through a prompt which waits until the user presses a key


INCLUDE Irvine32.inc

UPPER_LIMIT = 400
.data


num			DWORD	0			;current number entered by user
array		BYTE	0,1,2
comp_num	BYTE	4, 6, 8, 9
			BYTE	10, 12, 14, 15
			BYTE	16, 18, 20, 21
			BYTE	22, 24, 25, 26
			BYTE	27, 28, 30, 32
			BYTE	33, 34, 35, 36
			BYTE	38, 39, 40, 42
			BYTE	44, 45, 46, 48
			BYTE	49, 50, 51, 52
			BYTE	54, 55, 56, 57
			BYTE	58, 60, 62, 63
			BYTE	64, 65, 66, 68
			BYTE	69, 70, 72, 74
			BYTE	75, 76, 77, 78
			BYTE	80, 81, 82, 84
			BYTE	85, 86, 87, 88 
			BYTE	90, 91, 92, 93
			BYTE	94, 95, 96, 98
			BYTE	99, 100, 102, 104
			BYTE	105, 106, 108, 110
			BYTE	111, 112, 114, 115
			BYTE	116, 117, 118, 119
			BYTE	120, 121, 122, 123
			BYTE	124, 125, 126, 128
			BYTE	129, 130, 132, 133
			BYTE	134, 135, 136, 138
			BYTE	140, 141, 142, 143
			BYTE	144, 145, 146, 147
			BYTE	148, 150, 152, 153
			BYTE	154, 155, 156, 158
			BYTE	159, 160, 161, 162
			BYTE	164, 165, 166, 168
			BYTE	169, 170, 171, 172
			BYTE	174, 175, 176, 177 
			BYTE	178, 180, 182, 183
			BYTE	184, 185, 186, 187
			BYTE	188, 189, 190, 192, 194, 195, 196, 198, 200, 201, 202, 203, 204
			BYTE	205, 206, 207, 208, 209, 210, 212, 213, 214, 215, 216, 217, 218
		;	BYTE	219, 220, 221, 222, 224, 225, 226, 228, 230, 231, 232, 234, 235
		;	BYTE	236, 237, 238, 240, 242, 243, 244, 245, 246, 247, 248, 249, 250
		;	BYTE	252, 253, 254, 255, 256, 258, 259, 260, 261, 262, 264, 265, 266
		;	BYTE	267, 268, 270, 272, 273, 274, 275, 276, 278, 279, 280, 282, 284
		;	BYTE	285, 286, 287, 288, 289, 290, 291, 292, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 308, 309, 310, 312, 314, 315, 316, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 332, 333, 334, 335, 336, 338, 339, 340, 341, 342, 343, 344, 345, 346, 348, 350, 351, 352, 354, 355, 356, 357, 358, 360, 361, 362, 363, 364, 365, 366, 368, 369, 370, 371, 372, 374, 375, 376, 377, 378, 380, 381, 382, 384, 385, 386, 387, 388, 390, 391, 392, 393, 394, 395, 396, 398, 399, 400


intro_1		BYTE	"Hi, my name is Kanna and welcome to the Composite Calculator!", 0
intro2		BYTE	"Enter a number between [1 and 400] and the program will calculate the nth sequence!", 0 
prompt_name	BYTE	"What's your name? ",0
usr_name	BYTE	100 DUP(0)	
intro_2		BYTE	"Nice to meet you ",0
greeting	BYTE	"Hello ",0
greeting2	BYTE	"!",0
prompt_num	BYTE	"Enter a number between 1 and 400: ",0
valid_num	BYTE	"The number of valid numbers you entered is ",0
dis_sum		BYTE	"The sum of the valid numbers is ",0
average_dis	BYTE	"The rounded average is ",0
no_neg		BYTE	"I'm sorry but no negative numbers were entered.",0
goodBye		BYTE	"Good-bye, ", 0
space		BYTE	"   ",0

	;data
	;1. Repeat until the user chooses to quit. 
	;2. Validate the second number to be less than the first. 
	;3. Calculate and display the quotient as a floating-point number, rounded to the nearest .001.

	
.code
main PROC
		call intro			;introduces game to user and gets their name
		call data			;gets users data and validates
		call composite
			;isComposite
		;say goodbye

	exit	; exit to operating system
main ENDP

intro PROC
	
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	
	mov		edx, OFFSET prompt_name
	call	WriteString
	mov		edx, OFFSET usr_name
	mov		ecx,99
	call	ReadString
	call	CrLf

	;display name
	mov		edx,OFFSET greeting
	call	WriteString
	mov		edx, OFFSET usr_name
	call	WriteString
	mov		edx,OFFSET greeting2
	call	WriteString
	call	Crlf
	ret
intro ENDP
 


data PROC
	mov	edx, OFFSET intro2					;explains game
	call	WriteString
	call	CrLf

	L1:
	mov	edx, OFFSET prompt_num
		call WriteString
		call ReadInt
		mov num, eax	;num updated
		cmp num, upper_limit
		jge L1
		cmp num,1
		jl	L1
	ret
data ENDP



composite PROC
	mov ecx, num		;loop counter set
	mov esi,0
	L2:
		mov	al,comp_num[esi]	
		call WriteDec	;display number
		mov edx, OFFSET space
		call WriteString
		mov dl,10


		mov num, esi			;store num in eax
		mov ax, num
				
		div dl				;num/10
		cmp ah,0			;check if remainder is zero
		je newline			;newline
		jmp noline			;skip newline
		
		newline:
			call Crlf
		
		noline:
			inc esi			;update to the next index
		loop L2
	ret
composite ENDP


;array of composite numbers
;keep a loop count (Ecx) to go through the array and display the number

END main