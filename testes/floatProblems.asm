extern scanf
extern printf

section .data
vetor dq 4.0
str: db '%lf',0
str2: db 'valor %lf',13,10,0
section .text
global main
main:
	push vetor
	push str
	call scanf
	add esp,8

	fld qword[vetor]
	fld1
	faddp
	fstp qword[vetor]
	
	
	push dword[vetor+4]
	push dword[vetor]
	push dword str2
	call printf
	add esp,12

	mov eax,1
	mov ebx,0
	int 0x80
