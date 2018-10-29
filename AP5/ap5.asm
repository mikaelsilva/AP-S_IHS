extern printf ;declarando a função printf extern para uso no assembly
section .data ;declaração de variaveis inicializadas
value: dq 0.0
sinal: dq -1.0
s: dq -1.0

teste: dq 1
aux: dd -1	;contador para o i
aux2: dq 20000.0
aux3: dq 30000.0
aux5: dq -1.0
result: dq 0.0
result2: dq -1.0
x: dq 5.0
diff: dq 0.0
angulo: dq 0.0

str: db 'Valor = %f %f',13, 10, 0	;argumento do printf
str2: db 'Valor = %d',13, 10, 0 ;argumento do printf
str3: db 'meu deus',13,10,0
section .text	;inicio do codigo
global sen	

sen:

;COLOCANDO OS VALORES QUE ESTÃO NAS PILHAS PARA AS RESPECTIVAS VARIAVEIS
;---------------------------------------------------
enter 0,0
finit

fld dword[ebp+16]
fstp qword[x]

fld dword[ebp+16]

fsin 
fstp qword[angulo]


fld dword[ebp+20]
fstp qword[diff]

;-----------------------------------------------------
mov eax, 0



cont:
;--------------------------------------------
fld qword[sinal];o sinal para controlar a variação (-1)^i
fmul qword[s]
fstp qword[sinal]
;;------------------------------------- calcula o sinal que fica em sinal deve ser multiplicado pelo resultado no final
push eax				

mov eax, dword[aux]
inc eax
mov dword[aux], eax

fild dword[aux] 	;carrego i na fpu
fild dword[aux]		
faddp				;fpu agora possui 2i
fld1				
faddp				;2i+1

fistp dword[aux2]		;salvo 2i+1 em aux2

mov ecx, dword[aux2]
fild dword[aux2]		;coloco em st0 2i+1
fild dword[aux2]		;coloco em st0 2i+1 e st1 2i+1
laco:
cmp ecx, 1			;se tirar isso nada funciona 
je sai2
fld1

fsubp				;calculo o proximo numero (n-1)
fmul st1, st0			;multiplico para o fatorial

dec ecx
cmp ecx, 1
jne laco
sai2:
fistp dword[value]		;tenho que desempilhar o que eu to diminuindo 1 a 1		
fstp qword[value]		;e tenho que desempilhar o original pra manter a consistencia
	
mov ecx,dword[aux2]		;começo a calcular o x^(2i+1)
fld qword[x]			;empilho o x
pot:
	cmp ecx, 1
	je sai
	dec ecx
	fmul qword[x]		;st0 =st0 *x
	cmp ecx, 1
	jne pot
	
sai:
fmul qword[sinal]		;multiplico x^(2i+1) * (-1)^i

fdiv qword[value]		;divido x^(2i+1) * (-1)^i / (2i+1)!
fadd qword[result]		;somatorio
fstp qword[result]; 	;guardo o resultado


push ecx
push eax

;push dword[result+4]
;push dword[result]		;passo o inicio do valor
;push dword str			;passo o argumento do printf
;call printf			;chamo o printf
;add esp, 12

pop eax
pop ecx


fld qword[result]
fld qword[result2]
fcomip st0,st1
je sair



inc eax
fstp qword[result2]



cmp eax,100000
jne cont



sair:

;VALORES PARA SALVAR NOS ENDEREÇOS CEDIDOS NA TESTE.C
push ebx
	fild dword[aux]
	mov ebx, dword[ebp+12]
	fstp dword[ebx]
pop ebx

push ebx
	mov ebx, dword[ebp+8]
	fld qword[result]
	fstp dword[ebx] 
pop ebx
;-------------------------------------------------------

leave
ret
