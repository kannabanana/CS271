TITLE HW5     (AddTwo.asm)

;Author: SR Kanna
;Email: kannas@oregonstate.edu
;Class Number/Section: CS271-400   
; Assignment number: 5				Assignment Due Date: 11/8/2015 
  
; Description:  This program will introduce the programmer, get the user to input two numbers and produce
;	the sum, difference, product, quotient and remainder of the two numbers

;Comment Outline: 
;	The first section of code is an introduction where I query a pre-written string and display it to the user
;	The second portion is to get the data, where I ask the user to enter  a number between 10 and 200
;	The third protion I will display a random array of nth size of numbers between 100 and 999
;	I will display the median
;	I will display the array in sorted descending order


INCLUDE Irvine32.inc


;constants
ARR_SIZE = 201
MIN = 10	;array size low
MAX = 200	;array size high
LO = 100	;range low
HI = 900	;range high
COL_ARRY = 10
USER_ENTER = 0

.data
color		BYTE	"For EC, I changed the background color scheme! ",0
intro_1		BYTE	"Hi, my name is Kanna and welcome to the Sorting Algorithm! Enter a number between 10 - 200 and the program will generate a list of random numbers between 100 to 999 in descending order!", 0 
prompt_num	BYTE	"Enter a number between 10 and 200: ",0
unsorted	BYTE	"The unsorted list:",0
sorted		BYTE	"The sorted list:",0
space		BYTE	"   ",0
num			DWORD	?
count		DWORD	0
asc_count	DWORD	0
ten			DWORD	10
two			DWORD	2
goodbye		BYTE	"Bye!",0
sum			DWORD	0


which_array	DWORD	0
array1		DWORD	COL_ARRY DUP(?)
array2		DWORD	COL_ARRY DUP(?)
array3		DWORD	COL_ARRY DUP(?)


.code
main PROC

		mov edx,OFFSET color
		call WriteString
		call Crlf

		mov eax, white+(blue*16);
		call SetTextColor;

		call Crlf
		push OFFSET intro_1				;esp+4
		call intro						;esp		;introduces program
		call crlf

		push OFFSET prompt_num			;esp+4
		call data						;esp		;gets users data and validates

		
		ARRAY_SIZE = NUM
		.data
		array DWORD ARR_SIZE DUP(?)
		
		.code

	
		push OFFSET array				;esp+8
		push num						;esp+4
		call create_array				;create array

		push OFFSET unsorted				;esp+24 (title)
		push OFFSET	array				;esp+20 (starting point)
		push num						;esp+16	(how many indicies)
		push OFFSET space				;esp+12	(space)
		push asc_count					;esp+8	(backwards count)
		push ten						;esp+4
		call display					;esp
		call CrLF

comment &
		mov eax, num					;esp+12
		shr eax, 2
		dec eax
		push eax						;esp+8
		push 0
		push OFFSET array				;esp+4
		call sort
&
		call CrLF
		

		push OFFSET array				;esp+8
		push num						;esp+4
		call sort_descending			;esp


		push OFFSET array				;esp+12
		push num						;esp+8
		push two						;esp+4
		call median						;esp  display median
		call Crlf

		push OFFSET sorted				;esp+24 (title)
		push OFFSET	array				;esp+20 (starting point)
		push num						;esp+16	(how many indicies)
		push OFFSET space				;esp+12	(space)
		push asc_count					;esp+8	(backwards count)
		push ten						;esp+4
		call display					;esp
		call CrLF
		

	exit	; exit to operating system
main ENDP


;this procedure introduces the user to the game and gathers their name and says hello to them
intro PROC
	push ebp					;esp+8
	mov ebp, esp

	mov edx,[ebp+8]
	call WriteString
	call Crlf

	pop ebp
	ret 4 
intro ENDP
 

 ; this procedure gets the number of composites the user wants to display. It also error checks the input to make sure it's within the proper range
data PROC
	push ebp
	mov ebp,esp		;esp 8


	L1:
		mov	edx, [ebp+8]
		call WriteString
		call ReadInt
		mov num, eax	;num updated
		cmp num, MAX
		jg L1
		cmp num,MIN
		jl	L1	

	pop ebp
	ret 4
data ENDP


create_array PROC
push ebp			;esp+12	
mov ebp,esp		

	;correct number has been entered
		
		mov edi,[ebp+12]		;edi points to array
		mov ecx,[ebp+8]			;ecx points to num
		mov edx,HI				;larger range
		sub edx,LO				;edx = absolute range
		cld						;clears direction flag and increments edi

		L2:
			mov eax,edx
			call RandomRange
			add eax,LO			;bias the result
			stosd				;store eax into [edi]
			loop L2
	pop ebp
	ret 8
create_array ENDP




display PROC
	push ebp				;esp+28
	mov ebp,esp

	mov edx,[ebp+28]		;eax contains title
	call WriteString
	call crlf

	mov esi,[ebp+24]			;esi has array offset (0)
	mov ecx,[ebp+20]			;ecx is loop counter
	mov edi,[esi+ecx]			;array is now backwards and is displayed that way

	L3:
		lodsd
		call WriteDec
		mov edx,[ebp+16]			;space
		call WriteString


		mov eax,[ebp+12]		;mov forward_count
		inc eax
		mov [ebp+12],eax		;increment count
		cdq						;move fill quadword

		mov ebx,[ebp+8]				;mov ten to ebx
		div ebx					;divide the count by ebx (0/10 first)

		cmp edx,0			;check if remainder is zero (remainder is in edx:eax)
		mov eax,edx

		je newline			;newline
		jmp noline			;skip newline
		
		newline:
			call Crlf
		
		noline:
			;inc esi			;update to the next index

		loop L3

	pop ebp
	ret 24

display ENDP



sort PROC
	push ebp
	mov ebp,esp

	mov esi, [esp + 32]
	mov eax, [esp + 36]
	mov edx, [esp + 40]
	mov ebx, [esp + 44]

;calculate additional variables: ecx, edi, ebp
	mov ebp, eax
	mov edi, ebp
	mov ecx, edx
	inc ecx


;while loop 1 of 3
While1:
	cmp ebp, edx
	jg afterWhile1
	cmp ecx, ebx
	jg afterWhile1


;if cond1 && cond2 (need to push pop eax and ebx to compare
;since we are out of general use registers!
	push ebx
	push eax
	mov eax, [esi + 4 * ebp]
	mov ebx, [esi + 4 * ecx]
	cmp eax, ebx
	jge While1_else


;do "if condition success" commands
	mov eax, [esi + 4 * ebp]
	xchg [esi +  4 * edi], eax
	inc ebp
	inc edi

;restore registers
	pop eax
	pop ebx

	jmp While1


While1_else:
;do "if condition failure" commands
	mov eax, [esi +  4 * ecx]
	mov [esi + 4 * edi], eax
	inc ecx
	inc edi

;restore registers from above
	pop eax
	pop ebx

	jmp While1

	afterWhile1:
;push eax for popping later after BOTH the
;second and third while loop.
	push eax

;while loop 2 of 3
	While2:


;terminating condition
	cmp ebp, edx
	jg While3


	mov eax, [esi + 4 * ebp]
	mov [esi + 4 * edi], eax
	inc ebp
	inc edi
	jmp While2


;final While loop
While3:

;terminating condition
	cmp ecx, ebx
	jg afterWhileLoops

	mov eax, [esi + 4 * ecx]
	mov [esi + 4 * edi], eax
	inc ecx
	inc edi
	jmp While3


afterWhileLoops:
;pop eax, since we are done with
;while loops 2 and 3.
	pop eax


;set k = i
	mov edi, eax


forLoop1:
;check if k <= j]
	cmp edi, ebx
	jg endMergeProc


;sacrifice the value of m (edx), since we are
;not using it, nor will need it in the future.
	mov edx, [esi + 4 * edi]
	mov [esi + 4 * edi], edx

	inc edi
	jmp forLoop1


endMergeProc:
	pop ebp
	ret 16
sort ENDP



sort_descending	PROC
	push ebp		;esp+12
	mov ebp,esp

	mov ecx,[ebp+8]
	dec ecx

L1:
	push ecx
	mov esi,[ebp+12]
L2:
	mov eax,[esi]
	cmp [esi+4],eax
	jg L3
	xchg eax,[esi+4]
	mov [esi],eax
L3:
	add esi,4
	loop L2
	pop ecx
	loop L1
L4:
	pop ebp
	ret 8
sort_descending	ENDP



;check whether even or odd (16 = 0-15 - access element number 7 and 8 n/2 and n-1/2)
	;if odd - find middle element (n-1/2)
	
	;if even:
		;find middle element


median PROC
	push ebp			;esp+16
	mov ebp,esp			

	mov eax,[ebp+12]		;# of array elements
	cdq						;move fill quadword
	mov ebx,two
	div ebx				;divide the count by ebx (0/10 first)			;eax = quotient

	cmp edx,0			;check if remainder is zero (remainder is in edx:eax)
	je e_array			;newline
	jmp o_array			;skip newline
	
	e_array:
		mov esi,[ebp+16]				;array offset
		mov ebx,[esi+eax*4]				;first index
		;call WriteDec
		call Crlf

		dec eax
		mov ecx,[esi+eax*4]
		;call WriteDec
		call Crlf

		add ecx,ebx
		mov eax,ecx
		;Call WriteDec
		call Crlf
		
		cdq						;overflow to quadword
		mov ebx,two
		div ebx					;divide by two
		mov eax,eax
		call WriteDec			;display sum
		Call Crlf
		jmp end_func
		
	o_array:
		mov esi,[ebp+16]		;array offset
		mov eax,[esi+eax*4]
		call WriteDec
		call CrlF

	end_func:
	pop ebp
	ret 12

median ENDP




;this procedure says goodbye to the user
BYE PROC
	call	CrLF
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf
	ret
BYE ENDP

END main