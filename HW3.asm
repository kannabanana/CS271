TITLE HW2     (AddTwo.asm)

;Author: SR Kanna
;Email: kannas@oregonstate.edu
;Class Number/Section: CS271-400   
; Assignment number: 3				Assignment Due Date: 11/1/2015 
  
; Description:  This program will introduce the programmer, get the user to input two numbers and produce
;	the sum, difference, product, quotient and remainder of the two numbers

;Comment Outline: 
;	The first section of code is an introduction where I query a pre-written string and display it to the user
;	The second portion is to get the data, where I ask the user to enter a negative number and keep going until a positive number is entered
;	The third protion is to calculate the required values. I will use variables to keep track of the sum, count and number entered by the user
;	I used a prompt to display the results for the user (average, sum, count)
;	I said goodbye through a prompt which waits until the user presses a key


INCLUDE Irvine32.inc

UPPER_LIMIT = -1
.data

average		SDWORD	0			;average
sum			SDWORD	0			;current sum
num			SDWORD	0			;current number entered by user
count		SDWORD	0			;total number of numbers entered
line_count	SDWORD	1			;linecount
new_count	DWORD	0
name_display DWORD	0			;number of times name should be displayed
EC_num		BYTE	"EC** I numbered the lines for the user!",0
EC_amaz		BYTE	"EC** For something amazing, I will display your name a number of times you say!" ,0
intro_1		BYTE	"Hi, my name is Kanna and welcome to the Amazing Negative Calculator!", 0
intro2		BYTE	"Enter a number between [-100 to -1] and the program will calculate the nth sequence!", 0
instruction	BYTE	"Enter a non-negative number (Ex. n >= 0 ) when you are done.", 0 
prompt_name	BYTE	"What's your name? ",0
usr_name	BYTE	100 DUP(0)	
intro_2		BYTE	"Nice to meet you ",0
greeting	BYTE	"Hello ",0
greeting2	BYTE	"!",0
prompt_num	BYTE	". Enter a number: ",0
enter_num	BYTE	"Please enter the number of times you want your name displayed greater than 0!",0
valid_num	BYTE	"The number of valid numbers you entered is ",0
dis_sum		BYTE	"The sum of the valid numbers is ",0
average_dis	BYTE	"The rounded average is ",0
no_neg		BYTE	"I'm sorry but no negative numbers were entered.",0
goodBye		BYTE	"Good-bye, ", 0

	;data
	;1. Repeat until the user chooses to quit. 
	;2. Validate the second number to be less than the first. 
	;3. Calculate and display the quotient as a floating-point number, rounded to the nearest .001.

	
.code
main PROC


;introduction
	mov		edx, OFFSET EC_num
	call	WriteString
	call	CrLF
	call	CrLF
	mov		edx, OFFSET EC_amaz
	call	WriteString
	call	CrLF
	call	CrLF
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	
	mov		edx, OFFSET prompt_name
	call	WriteString
	


;get name and display
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


;display/calculate the answers

	mov		edx, OFFSET intro2					;explains game
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruction				;enter a non-negative number of finish
	call	WriteString
	call	CrLF

	mov		ebx, sum
	mov		ecx, count

	L1:
		mov eax,line_count
		call WriteDec
		inc line_count

		mov	edx, OFFSET prompt_num
		call WriteString
		call ReadInt

		mov num, eax	;num updated

		mov eax, count
		inc eax
		mov count, eax	;count updated

		mov eax, sum
		add eax, num
		mov sum, eax	;sum updated (sum+=num)


		cmp num, UPPER_LIMIT ;(count & -1)
		jle L1
		

	cmp count,1
	je  L2


	dec count;							;display the number of valid numbers
	mov edx, OFFSET valid_num
	call WriteString
	mov eax, count
	call Writedec
	call CrLF

	mov edx, OFFSET dis_sum				;display the sum
	call WriteString
	mov eax,sum
	call WriteInt
	call CrLF


	mov edx, OFFSET average_dis			;display average
	call WriteString
	mov eax,sum
	cdq
	mov ecx,count
	idiv ecx
	call WriteInt
	call CrLF


	
	cmp count,1
	je	L2
	L2:
		mov edx, OFFSET no_neg
		call WriteString
		call CrLF

	call CrLF
;number of times the name should be displayed - EC
	mov edx, OFFSET enter_num
	call WriteString
	call ReadDec
	mov name_display,eax

	mov ecx, name_display
	L3:
		mov edx, OFFSET usr_name
		call WriteString
		loop L3

;say goodbye
    call	Crlf
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx,OFFSET usr_name
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

END main