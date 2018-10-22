;programa calcula (pi/4) == sum (-1)^i/(2i+1)

extern printf ;declarando a função printf extern para uso no assembly
section .data ;declaração de variaveis inicializadas
value: dq 0.0
sinal: dq -1.0
s: dq -1.0

aux: dd -1	;contador para o i
str: db 'Valor = %f',13, 10, 0	;argumento do printf
str2: db 'Valor = %d',13, 10, 0 ;argumento do printf
section .text	;inicio do codigo
global main	

main:

mov eax, -1



cont:
				;nessa parte eu guardo o sinal antigo e multiplico por -1 pra achar o novo
fld qword[sinal];o sinal para controlar a variação (-1)^i
fmul qword[s]
fstp qword[sinal]


push eax		;salvo eax por que o printf tem um retorno que o sobreescreve


mov eax, dword[aux]	 ;calculo o incremento do i
inc eax
mov dword[aux], eax

fild dword[aux] 	;carrego i na fpu
fild dword[aux]		
faddp				;fpu agora possui 2i
fld1				
faddp				;2i + 1
fld qword[sinal]	
fdivrp				;divido por ((-1)^i)/(2i+1)
fadd qword[value]	;somo o novo passo ao valor calculado anteriormente

fst qword[value]


push dword[value+4]		;passo o final do valor
push dword[value]		;passo o inicio do valor
push dword str			;passo o argumento do printf
call printf				;chamo o printf
add esp, 12				;necessário para rearrumar a pilha do contrário ela ia ficar com o inicio 							;zaudo

pop eax
inc eax

cmp eax, 10000
jne cont



mov eax, 1
mov ebx, 0
int 80h
