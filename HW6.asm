TITLE HW6     (AddTwo.asm)

;Author: SR Kanna
;Email: kannas@oregonstate.edu
;Class Number/Section: CS271-400   
; Assignment number: 6				Assignment Due Date: 12/6/2015 
  
; Description:  This program will introduce the programmer, get the user to input two numbers and produce
;	the sum, difference, product, quotient and remainder of the two numbers


;Comment Outline: 
;	In the first section of the code, I will explain the game to the user (enter an unsigned number)
; the user will enter 10 and at the end, I will display the sum, average and all of the numbers they entered
; This program converts the string entered by the user without the readstring implementation or writestring
; the string is converted into it's numeric convention, calculations are made and then converted back to string


;Sources:
; Irvine, Kip. "Assembly Language for X86 Processors, 7/e." Assembly Language for X86 Processors, 7/e. Pearson, n.d. Web. 24 Nov. 2015. 	<http://kipirvine.com/asm/>.



INCLUDE Irvine32.inc


;CONSTANTS/MACROS
WriteVal MACRO buffer
	push edx
	mov edx,OFFSET buffer
	call WriteString
	pop edx
ENDM

ReadVal MACRO varName
	push ecx
	push edx
	mov edx,OFFSET varName
	mov ecx,SIZEOF varname
	dec ecx
	call ReadString
	pop edx
	pop ecx
ENDM

mreadstring MACRO prompt_un,user_num
	push ecx
	push edx
	mov		edx,OFFSET prompt_un
	call	WriteString
	mov		edx, OFFSET user_num		
	mov		ecx,99
	call	ReadString
	pop edx
	pop ecx
ENDM

mwritedec MACRO num
	push eax
	mov eax,num
	call WriteDec
	call Crlf
	pop eax
ENDM

mwritedec2 MACRO num
	push eax
	mov eax,num
	call Writedec
	pop eax
ENDM

;interrupt macro
writeval2 MACRO fun_num
	lidt
	mov AH,fun_num
	int 21H
	sidt
ENDM

mreadstring2 MACRO prompt_num,user_num
	push ecx
	push edx
	mov ah,prompt_un
	int 21H
	mov ah,user_num
	mov		edx, OFFSET user_num		
	mov		ecx,99
	call	ReadString
	pop edx
	pop ecx
ENDM

mnegative MACRO quotient,divisor
	push eax
	push ebx
	mov  eax, quotient
	mov  ebx, ebx
	imul ebx             ; EDX:EAX = FFFFFFFFh:86635D80h, OF = 0
	;mov signed_val, eax
	call writehex
	call crlf
	pop ebx
	pop eax
ENDM


;MAX = 4294967295

.data
intro_1		BYTE	"Hi, my name is Kanna. Enter 15 unsigned numbers and we'll display them, compute the sum and average!  ", 0 
prompt_un	BYTE	" .Enter an unsigned number: ",0
prompt_si	BYTE	" .Enter a signed number: ",0
user_num	BYTE	"ERROR: That wasn't an unsigned number or your number was too big. Enter again: ",0
error_num	BYTE	" ERROR: That wasn't an unsigned number or your number was too big. Enter again: ",0
EC_color	BYTE	"For EC, I changed the color of the background! ",0
line_num	BYTE	"For EC, I kept a running total of the sum and numbered the lines",0
sum_total	BYTE	"The total sum of the 10 numbers is ",0
recus		BYTE	"For EC, I implemented recursion",0
sum_cur		BYTE	"The running total is ", 0
average		BYTE	"the average is ",0
length1		BYTE	"The length is ",0
goodbye		BYTE	"Byte!",0
usr_name	BYTE	100 DUP(0)
temp		DWORD	0
temp2		DWORD	0
x			DWORD	0
array		DWORD 10 dup(0)
outer_loop	BYTE	"The outerloop is now",0
inner_loop	BYTE	"The innerloop is now",0
runtotal	BYTE	"The current total is ",0
dis_arr		BYTE	"You entered the following numbers ",0
space		BYTE	 "  ",0
asc_count	DWORD	0
ten			DWORD	10
sum			DWORD	0
out_count	DWORD	10
quiting		BYTE	"we are quitting recursion",0
charval		BYTE	"the char value is ",0
pushval		BYTE	"the value i'm pushing onto the stack",0
valueisneg	BYTE	"the value is negative ",0
signed_val	SDWORD	?
hexrep		BYTE	"The hexadecimal representation of the number you entered is ",0
interrupt	BYTE	"For EC, I implemented interrupt instead of writestring/readstring in macros",0
.code
main PROC


		
		;mov al,200
		;call writechar


		writeval ec_color
		call crlf
		writeval line_num
		call Crlf
		writeval recus
		call crlf
		writeval interrupt
		call crlf

		mov eax, white+(green*16);
		call SetTextColor;

		call Crlf
		WriteVal intro_1
		call Crlf
		call Crlf
		call crlf 


		;4294967295 = max size of unsigned int



		push sum
		push OFFSET array
		push x
		push temp2
		push temp
		call data						;esp		;gets users data and validates

comment &
		push out_count
		push sum
		push OFFSET array
		push x
		push temp2
		push temp
		call recursion1
&
		push OFFSET dis_arr				;esp+24 (title)
		push OFFSET	array				;esp+20 (starting point)
		push ten						;esp+16	(how many indicies)
		push OFFSET space				;esp+12	(space)
		push asc_count					;esp+8	(backwards count)
		push ten						;esp+4
		call display					;esp
		call CrLF

		push temp
		push temp
		push sum
		push OFFSET array
		push x
		push temp2
		push temp
		call sign
	
		push OFFSET goodbye				;esp+4
		call BYE

	exit	; exit to operating system
main ENDP


;ebp+4 = temp for ecx
;ebp+8 = temp to hold
;ebp+12 = x
;ebp+16 = array
;ebp+20 = sum
;--------------------------------------
; this procedure gets the number of composites the user wants to display. 
;It also error checks the input to make sure it's within the proper range
;this function converts the string digit to a numeric value for evaluation
;------------------------------------ 

 data PROC

		push ebp			;ebp+24
		mov ebp,esp
		push edx
		push ebx
		push eax
		push ecx
		push edi
		push esi

		;mov edi,OFFSET array
		mov edi,0

		mov ecx,10					;set outter limit
	.WHILE ecx > 0
								
		mov [ebp+8],ecx					;mov temp,ecx 
		mwritedec2 [ebp+8]

		mreadstring prompt_un,user_num
  errorback:	
		mov esi,OFFSET user_num
		.data
		len DWORD lengthof user_num

	.code
		mov ecx,len			;set the inner loop (use ecx to display loop)

		.WHILE eax > 0
	;validate:
							
		mov al, [esi]		;insert first char inside al
		movzx eax,al		;move it to a bigger byte
		cmp eax,0
		je zero
		cmp eax,48
		jl	error
		cmp eax,57
		jg	error


		sub eax,48			;str[k]-48
		mov [ebp+12],eax	;store it inside a temp variable
		mov eax,[ebp+16]	;move x to eax
		cdq
		mov ebx,10
		imul ebx			;x*10
		add eax,[ebp+12]	;x+(k-48)
		mov [ebp+16],eax	;update x

		inc esi

		;loop validate
		dec ecx
		.ENDW
 zero:
		;mov eax,[ebp+16]
		;call writedec
		;call crlf
		;cmp eax,4294967295
		;jl error

		mov ebx,[ebp+16]
		add [ebp+24],ebx
		writeval runtotal
		mwritedec [ebp+24]

	;	mov al,0					
	;	movzx eax,al			;new section added

		mov eax,[ebp+16]
		mov array[edi],eax
		;mwritedec array[edi]
		add edi,4
		

		mov al,0
		mov [ebp+16],al			;reset everything to make sure the next number (x) starts at zero

		mov ecx,[ebp+8]			;mov ecx,temp

		dec ecx
		;loop getnum
		.ENDW

		jmp ultimate_quit

		error:
			mreadstring error_num,user_num
			jmp errorback

		ultimate_quit:

	;	mov eax,[ebp+24]
	;	cdq
	;	mov ebx,10
	;	div ebx
	;	writeval average
	;	mwritedec eax
		
	;	push eax
	;	call convertstring			;calling function within function
		
	;	mov ecx,10
	;	mov edi,0

	;	.WHILE ecx > 0
	;	mwritedec array[edi]
	;	add edi,4
	;	dec ecx
	;	.ENDW

		pop esi
		pop edi
		pop ecx
		pop eax
		pop ebx
		pop edx

		pop ebp
		ret 20
data ENDP


;--------------------------------------
; this procedure gets a decimal number and coverts it into a string
;it takes the decimal and finds the ascii (+48)
;--------------------------------------
; this procedure displays all of the numbers in the array
;
;		push OFFSET dis_arr				;esp+24 (title)
;		push OFFSET	array				;esp+20 (starting point)
;		push ten						;esp+16	(how many indicies)
;		push OFFSET space				;esp+12	(space)
;		push asc_count					;esp+8	(backwards count)
;		push ten						;esp+4
;		call display					;esp
;		call CrLF


display PROC
	push ebp				;esp+28
	mov ebp,esp
	
		push edx
		push ebx
		push eax
		push ecx
		push edi
		push esi

	mov edx,[ebp+28]		;eax contains title
	;writeval edx
;	call WriteString
;	call Crlf
	

	mov esi,[ebp+24]			;esi has array offset (0)
	mov ecx,[ebp+20]			;ecx is loop counter
;	mov edi,[esi+ecx]			;array is now backwards and is displayed that way
	
		mov ecx,10
		mov edi,0
		mov eax,0

		.WHILE ecx > 0
		mwritedec [esi+edi]
		add eax,[esi+edi]
		add edi,4
		dec ecx
		.ENDW

		writeval sum_total
		;push temp
		;push eax
		;call recursion2
		mwritedec eax
		mov eax,eax
		cdq
		mov ebx,10
		div ebx
		writeval average
		;push temp
		;push eax
		;call recursion2
		mwritedec eax
		

		pop esi
		pop edi
		pop ecx
		pop eax
		pop ebx
		pop edx

	pop ebp
	ret 24

display ENDP


;--------------------------------------
; this procedure uses recursion instead of iteration
;to gather the numbers, validate and covert into a decimal
;sum, average are displayed in the other functions
;---

recursion1 PROC

		push ebp			;ebp+28
		mov ebp,esp

		mov edi,0

		mov ecx,[ebp+28]				;set outter limit
								
		mov [ebp+8],ecx					;mov temp,ecx 
		mwritedec2 [ebp+8]

		mreadstring prompt_un,user_num
  errorback:	
		mov esi,OFFSET user_num
		.data
		len2 DWORD lengthof user_num

	.code
		mov ecx,len2			;set the inner loop (use ecx to display loop)

		.WHILE eax > 0
	;validate:
							
		mov al, [esi]		;insert first char inside al
		movzx eax,al		;move it to a bigger byte
		
		cmp eax,0
		je zero
		cmp eax,48
		jl	error
		cmp eax,57
		jg	error


		sub eax,48			;str[k]-48
		mov [ebp+12],eax	;store it inside a temp variable
		mov eax,[ebp+16]	;move x to eax
		cdq
		mov ebx,10
		imul ebx			;x*10
		add eax,[ebp+12]	;x+(k-48)
		mov [ebp+16],eax	;update x

		inc esi
		dec ecx

		.ENDW
 zero:
		mov ebx,[ebp+16]
		add [ebp+24],ebx
		writeval runtotal
		mwritedec [ebp+24]


		mov eax,[ebp+16]
		mov array[edi],eax
		mwritedec array[edi]
		add edi,4
		

		mov al,0
		mov [ebp+16],al			;reset everything to make sure the next number (x) starts at zero

		mov ecx,[ebp+8]			;mov ecx,temp
		dec ecx
		mov eax,ecx
		mwritedec eax
		mov [ebp+28],ecx

		cmp ecx,0
		writeval outer_loop
		mwritedec ecx
		jg recurse
		jmp ultimate_quit

		recurse:
			push [ebp+28]
			push [ebp+24]
			push [ebp+24]
			push [ebp+16]
			push [ebp+16]
			push [ebp+16]
			call recursion1		

		error:
			mreadstring error_num,user_num
			jmp errorback

		ultimate_quit:

		mov eax,[ebp+24]
		cdq
		mov ebx,10
		div ebx
		writeval average
		mwritedec eax
		
		mov ecx,10
		mov edi,0

		.WHILE ecx > 0
		mwritedec array[edi]
		add edi,4
		dec ecx
		.ENDW

		pop ebp
		ret 24

recursion1 ENDP



;push temp (+4)
;push num
;call recursion2
;----
;This function converts the numeric value into a string via recursion
;it takes the origional numeric value, subtracts by 48 and then divides
;it the origional x by 10 (thereby making the quotient the next x)
;the display is at the end after recurison, because I want to be displayed in reverse

	;mov eax,455
	;	push temp
	;	push eax
	;	call recursion2

recursion2 PROC
	push ebp	;ebp+12
	mov ebp,esp
	mov al,[ebp+8]
	call writedec
	call crlf

	cmp al,0
	jg recursion
	jmp quit
	recursion:
		mov cl,al		;mov x1 into 
		add cl,48		;new x1
		
		movzx ax,al
		cwd
		mov bx,10
		div bx
		mov al,al
		mov ch,al

		movzx ax,al			;quotient of division
		cwd
		mul bx
		;al now contains the quotient*10

		;subtract al from cl
		sub cl,al
		mov al,cl
		;writeval charval
		mov [ebp+12],al
		call writechar
		;call crlf

		movzx ecx,ch
		mov eax,ecx
		;writeval pushval
		;call writedec
		;call crlf
		push [ebp+12]
		push ecx
		call recursion2
		;mov al, [ebp+8]
		;call writechar

	quit:
	;	call crlf
	;	mov al,[ebp+12]
	;	call writechar

		pop ebp
		ret 8

recursion2 ENDP



;ebp+4 = temp for ecx
;ebp+8 = temp to hold
;ebp+12 = x
;ebp+16 = array
;ebp+20 = sum
;ebp+24 = 
;ebp+28 = temp
;-----------------------------------
;this function evalutes the sign numbers
;the function can handle them but taking in the input, without readstring
;and displays back the number if negative in hex
;-----------------------------------


sign PROC

		push ebp			;ebp+32
		mov ebp,esp
		push edx
		push ebx
		push eax
		push ecx
		push edi
		push esi

		;mov edi,OFFSET array
		mov edi,0

		mov ecx,10					;set outter limit
	.WHILE ecx > 0
								
		mov [ebp+8],ecx					;mov temp,ecx 
		mwritedec2 [ebp+8]

		mreadstring prompt_si,user_num
  errorback:	
		mov esi,OFFSET user_num
		.data
		len4 DWORD lengthof user_num

	.code
		mov ecx,len4		;set the inner loop (use ecx to display loop)

		.WHILE eax > 0

	validate:
							
		mov al, [esi]		;insert first char inside al
		movzx eax,al		;move it to a bigger byte
		cmp eax,45
		je negative

		cmp eax,0
		je zero
		cmp eax,48
		jl	error
		cmp eax,57
		jg	error
		jmp not_neg

		negative:
			dec ecx
			inc esi
			writeval valueisneg
			mov eax,1
			mov [ebp+28],eax
			jmp validate
		not_neg:

		sub eax,48			;str[k]-48
		mov [ebp+12],eax	;store it inside a temp variable
		mov eax,[ebp+16]	;move x to eax
		cdq
		mov ebx,10
		imul ebx			;x*10
		add eax,[ebp+12]	;x+(k-48)
		mov [ebp+16],eax	;update x

		inc esi

		;loop validate
		dec ecx
		.ENDW
 zero:
		;mov eax,[ebp+16]
		;call writedec
		;call crlf
		;cmp eax,4294967295
		;jl error

		mov eax,1
		cmp [ebp+28],eax
		je negative2
		;writeval outer_loop
		;mwritedec [ebp+28]
		jmp not_negative2
		

		negative2:
			writeval hexrep
			mov eax,[ebp+16]
			mov ebx,-1
			mnegative eax,ebx
			jmp done

		not_negative2:
		mov eax,[ebp+16]
		call writedec
		call crlf
	;	mov ebx,[ebp+16]
	;	add [ebp+24],ebx
	;	writeval runtotal
	;	mwritedec [ebp+24]

	;	mov al,0					
	;	movzx eax,al			;new section added

	;	mov eax,[ebp+16]
	;	mov array[edi],eax
		;mwritedec array[edi]
	;	add edi,4
		
	done:
		mov al,0
		mov [ebp+16],al			;reset everything to make sure the next number (x) starts at zero
		mov [ebp+28],al

		mov ecx,[ebp+8]			;mov ecx,temp

		dec ecx
		;loop getnum
		.ENDW

		jmp ultimate_quit

		error:
			mreadstring error_num,user_num
			jmp errorback

		ultimate_quit:

		pop esi
		pop edi
		pop ecx
		pop eax
		pop ebx
		pop edx

		pop ebp
		ret 28
sign ENDP




;--------------------------------------
;this procedure only says goodbye and waits until the user is ready to go
;------------------------------------

;this procedure says goodbye to the user
BYE PROC
	push esp ;esp+8
	call	CrLF
	mov		edx, [ebp+8]
	call	WriteString
	call	CrLf
	pop ebp
	ret 4
BYE ENDP

END main