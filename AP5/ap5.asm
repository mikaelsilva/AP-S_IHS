extern printf ;declarando a função printf extern para uso no assembly
section .data ;declaração de variaveis inicializadas
value: dq 0.0
sinal: dq -1.0
s: dq -1.0

teste: dq 1
aux: dd -1	;contador para o i
str: db 'Valor = %f',13, 10, 0	;argumento do printf
str2: db 'Valor = %d',13, 10, 0 ;argumento do printf
str3: db 'meu deus',13,10,0
section .text	;inicio do codigo
global main	

main:

mov eax, 0

cont:

push eax				

mov eax, dword[aux]
inc eax
mov dword[aux], eax

fild dword[aux] 	;carrego i na fpu
fild dword[aux]		
faddp				;fpu agora possui 2i
fld1				
faddp

fistp dword[value]

mov ecx, dword[value]
fild dword[value]
fild dword[value]
laco:
cmp ecx, 1
je sai
fld1

fsubp
fmul st1, st0

dec ecx
cmp ecx, 1
jne laco
sai:
fistp dword[value]
fstp qword[value]

push ecx
push eax
push dword[value+4]
push dword[value]		;passo o inicio do valor
push dword str			;passo o argumento do printf
call printf				;chamo o printf
add esp, 12
pop eax
pop ecx

;push dword[value+4]		;passo o final do valor
;push dword[value]		;passo o inicio do valor
push dword str3			;passo o argumento do printf
call printf				;chamo o printf
add esp, 4

pop eax
inc eax

cmp eax, 10
jne cont

mov eax, 1
mov ebx, 0
int 80h
