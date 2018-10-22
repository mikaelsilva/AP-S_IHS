extern printf
section .data
value: dq 0.0
sinal: dq -1.0
s: dq -1.0

aux: dd -1
str: db 'Valor = %f',13, 10, 0
str2: db 'Valor = %d',13, 10, 0
section .text
global main

main:

mov eax, -1



cont:

fld qword[sinal]
fmul qword[s]
fstp qword[sinal]


push eax


mov eax, dword[aux]
inc eax
mov dword[aux], eax

fild dword[aux]
fild dword[aux]
faddp
fld1
faddp
fld qword[sinal]
fdivrp
fadd qword[value]

fst qword[value]


push dword[value+4]
push dword[value]
push dword str
call printf
add esp, 12

pop eax
inc eax

cmp eax, 10000
jne cont



mov eax, 1
mov ebx, 0
int 80h
