TITLE HW2     (KannasrHW2.asm)

;Author: SR Kanna
;Email: kannas@oregonstate.edu
;Class Number/Section: CS271-400   
; Assignment number: 2				Assignment Due Date: 10/11/2015 
  
; Description:  This program will introduce the programmer, get the user to input two numbers and produce
;	the sum, difference, product, quotient and remainder of the two numbers

;Comment Outline: 
;	The first section of code is an introduction where I query a pre-written string and display it to the user
;	The second portion is to get the data, where I ask the user to enter a number between 1 and 46 and keep querying until a number between 1-46 is entered
;	The third protion is to calculate the required values. I used will use a loop to display until the nth term
;	I used a prompt to display the results for the different results (5 terms per line)
;	I said goodbye through a prompt which waits until the user presses a key


INCLUDE Irvine32.inc

UPPER_LIMIT = 46
DIVISOR = 5
.data
first_num	DWORD	?			;first integer to be entered by user
second_num	DWORD	?			;second integer to be entered by user
f0			DWORD	0			;fn-2
f1			DWORD	1			;fn-1
count		DWORD	?			;fib number
intro_1		BYTE	"Hi, my name is Kanna and this is Fiboacci Calculator!", 0
intro2		BYTE	"For HW2 we'll do some cool stuff. Enter a number between [1-46] and the program will calculate the nth sequence!", 0
prompt_name	BYTE	"What's your name? ",0
usr_name	BYTE	100 DUP(0)	
intro_2		BYTE	"Nice to meet you ",0
greeting	BYTE	"Hello ",0
greeting2	BYTE	"!",0
prompt_fib	BYTE	"Enter the number of fibonacci terms to be displayed ",0
fib_num		DWORD	?
space		BYTE	"     ",0
goodBye		BYTE	"Good-bye, ", 0

	;data
	;1. Repeat until the user chooses to quit. 
	;2. Validate the second number to be less than the first. 
	;3. Calculate and display the quotient as a floating-point number, rounded to the nearest .001.

	
.code
main PROC


;introduction
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro2
	call	WriteString
	call	CrLf
	
	mov		edx, OFFSET prompt_name
	call	WriteString
	


;get data
	;reading Name
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


	;get the nth number of fibonacci numbers to display
	;	do{//keep asking for a new number}
	;	while (fib_num >= 1 && fib_num <= UPPER_LIMIT)


	L1:
		mov		edx,OFFSET prompt_fib
		call	WriteString
		call	ReadInt
		mov		fib_num,eax
		cmp		fib_num,UPPER_LIMIT
		jge		L1				;jump if greater than
		cmp		fib_num,1
		jl		L1				;jump if less than




;calculate the desired results
	;fibonacci series:
		;f0 = 0
		;f1 = 1
		;fn = fn-1+fn-2

		;ask for 10
			;for loop
				;start at 1
				;display until less than or equal to
				;have a f0 var -update
				;have f1 var -update
				;have a count - new f1
		
		mov eax,f1
		call WriteInt
		mov edx,OFFSET space
		call Writestring
			
		dec fib_num
		mov ecx, fib_num		;set loopcounter
		L2:
			mov	eax, f0
			mov ebx, f1
			add eax,ebx
			mov	count, eax			;new "fib num"
			mov eax,count
			call WriteInt
			mov edx, OFFSET space
			call WriteString

			mov eax,f1				;update f0+f1
			mov f0,eax
			mov eax,count
			mov f1,eax

			;divide ecx by 5
			;check if the remainder is 0
			;have a new line if remainder is zero

			loop L2;
			

;display
;can load into array
;loop through array - check if count is a multiple of five
	;new line if it is
	;either way put five spaces inbetween


;say goodbye
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx,OFFSET usr_name
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

END main