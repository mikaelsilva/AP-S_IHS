org 0x8600
jmp 0x0000:start

;ULTIMA MODIFICAÇÃO 13/09
;HORARIO 10:00da manha


nome db 'nome? ',13,10,0
cpf db 'cpf? ',13,10,0
codigo db 'codigo? ',13,10,0
numero db 'numero? ',13,10,0
linha db 10,13,0
quant_pessoas dw 0
cliente db 'Dados do cliente:',13,10,0
fail_busca db 'Cliente nao encontrado!!',13,10,0
guarda_si db 0
listarAgencias db 0 


menu: db 'Menu:',10,13,'1 -> para cadastro',10,13, '2 -> para buscar',10,13, '3 -> para editar',10,13, '4 -> para deletar',10,13, '5 -> listar agencias',10,13, '6 -> contas',10,13, '7 -> para sair',10,13,0

modeloNome db 'ddddda11111111111111',0
modeloCpf times 12 db 0
modeloCodigo times 4 db 0
modeloNumero times 6 db 0



print:
		push ax
		push bx
		mov ah, 0xe
		mov bh, 0
		int 10h
		pop bx
		pop ax
ret

ler:
	mov ah, 0h
	int 16h
ret

printS:
	push si
	mov si, bx
	loopS:
		lodsb
		cmp al, 0
		je exitS
		call print
		jmp loopS
	exitS:
	pop si
iret

scanS: ;le exatamente cx-1 caracteres e salva numa string apontada por di
	push ax
	loopScanS:
	cmp cx, 0
	je exitScanS
	call ler
	stosb
	call print
	sub cx, 1
	jmp loopScanS
	exitScanS:
	pop ax
ret	;no final cx deve ter 0

pularLinha:
	mov bx,linha
	int 40h
ret



cadastrar:
	mov ax, 0
	mov es, ax

	push di
	mov bx, nome
	int 40h
	mov cx, 20
	mov di, modeloNome
	call scanS
	;mov bx, modeloNome
	;int 40h

	call pularLinha
	mov bx, cpf
	int 40h
	mov cx, 11
	mov di, modeloCpf
	call scanS
	;mov bx, modeloCpf
	;int 40h

	call pularLinha
	mov bx, codigo
	int 40h
	mov cx, 3
	mov di, modeloCodigo
	call scanS
	;mov bx, modeloCodigo
	;int 40h
	
	call pularLinha
	mov bx, numero
	int 40h
	mov cx, 5
	mov di, modeloNumero
	call scanS
	;mov bx, modeloNumero
	;int 40h
	pop di
	call salvar
ret

carregaSalva: ;carrega cx caracteres apontados por si e depois salva em di

	cmp cx, 0
	je exitCarregaSalva
	lodsb
	stosb
	sub cx, 1
	jmp carregaSalva
	exitCarregaSalva:
ret

salvar:	;salva tudo no di, ainda não to salvando a parte do vetor de busca
	push es
	mov ax, 0
	mov es, ax
	mov cx, 11
	mov si, modeloCpf
	call carregaSalva

	mov cx, 20
	mov si, modeloNome
	call carregaSalva

	mov cx, 3
	mov si, modeloCodigo
	call carregaSalva

	mov cx, 5
	mov si, modeloNumero
	call carregaSalva

	mov cx,word[quant_pessoas]
	add cx,1
	mov word[quant_pessoas],cx

	pop es
ret	;modifica cx, ax, e si

;Esta função serve apenas para mostrar todos os clientes que estao cadastrados (a visualização é de uma forma meio feiosa)
ferrou:
	push ax
	mov ax,word[quant_pessoas]
	mov cx,39
	mul cx	
	mov cx,ax

	mov si,0x500
	ferrou2:
	lodsb
	cmp cx,0
	je sair_ferrou
	dec cx
	call print
	jmp ferrou2

	sair_ferrou:
	call pularLinha
	pop ax
ret

;Está função serve para identificar um cliente no cadastro
buscar:	
	
	mov ax, 0
	mov es, ax
	push di

	call pularLinha

	;mov cx,word[quant_pessoas]
	;pessoas:
	;cmp cx,0
	;je sair_pessoas
	;dec cx
	;mov al,'#'
	;call print
	;jmp pessoas
	;sair_pessoas:

	mov bx,cpf ;Pede que o CPF seja inserido
	int 40h

	mov cx,11
	mov di,modeloCpf  ; Recebe o CPF do cliente
	call scanS

	mov ax,0
	mov dx,0

	mov si,0x500 ; mov SI para o inicio da memória

	buscar2:
	cmp dx,word[quant_pessoas] ; Analisa quantas pesquisas já foram feitas de acordo com a quantidade de pessoas que são inscritas
	je sairBuscar

		buscar3:
		mov di,modeloCpf   ;Passa para DI o valor do CPF informado pelo cliente
	
		mov cx,11    ; Compara com a string que está na memória na posição 0x500 (já que ax == 0)
		cld
		repe cmpsb
		je buscar4


		mov ax,11
		sub ax,cx
		sub si,ax

		mov ax,39 ; ;Isso faz com que a cada volta no loop, se o cliente não foi encontrado, um valor é somado ao SI para poder se chegar até o "CLIENTE" correto
		add si,ax
		inc dx

	jmp buscar2
			buscar4: ; Essa função ocorre caso o REPE CMPSB seja identificado que a string na memoria é a mesma que a informada para BUSCA
			mov ax,11
			sub si,ax
			mov word[guarda_si],si; Guarda o valor inicial da string que pode ser alterada, analisada ou deletada
			call carrega
			jmp sair_total

	sairBuscar:
	call pularLinha
	mov bx,fail_busca
	int 40h
	sair_total:
	pop di    ;Di aponta para memoria novamente
	mov si,di	;si passa a ter o seu valor também
ret

;Esta função é responsavel por, dado o valor inicial de SI em BUSCAR4 na função BUSCAR percorrer 39 caracteres para identificar os dados do cliente
carrega:
	call pularLinha
	call pularLinha
	mov bx,cliente
	int 40h


	mov bx,cpf
	int 40h
	mov di,modeloCpf
	mov cx,11
	carrega_cpf:
	cmp cx,0
	je sair_carrega_cpf
	lodsb
	stosb
	dec cx
	jmp carrega_cpf
	sair_carrega_cpf:
		mov bx,modeloCpf
		int 40h
		call pularLinha

	mov bx,nome
	int 40h
	mov di,modeloNome
	mov cx,20
	carrega_nome:
	cmp cx,0
	je sair_carrega_nome
	lodsb
	stosb
	dec cx
	jmp carrega_nome
	sair_carrega_nome:
		mov bx,modeloNome
		int 40h
		call pularLinha

	mov bx,codigo
	int 40h
	mov di,modeloCodigo
	mov cx,3
	carrega_codigo:
	cmp cx,0
	je sair_carrega_codigo
	lodsb
	stosb
	dec cx
	jmp carrega_codigo
	sair_carrega_codigo:
		mov bx,modeloCodigo
		int 40h
		call pularLinha

	mov bx,numero
	int 40h
	mov di,modeloNumero
	mov cx,5
	carrega_numero:
	cmp cx,0
	je sair_carrega_numero
	lodsb
	stosb
	dec cx
	jmp carrega_numero
	sair_carrega_numero:
		mov bx,modeloNumero
		int 40h
		call pularLinha

	call pularLinha
ret


;Esta função permite alterar algum campo do cadastro
editar:
	call buscar
	call pularLinha
	push di
	mov di,word[guarda_si] ;Responsavel por indicar futuramente na função chamada por CADASTRAR a partir de que ponto será salvo os dados do cliente 
	call cadastrar
	mov cx,word[quant_pessoas] ;Cada vez que a função cadastrar é chamada ela add 1 para quant_pessoas, aqui, como é feita uma alteração, sub 1 para não ter valores incorretos
	dec cx
	mov word[quant_pessoas],cx
	pop di
ret

;Esta é responsavel por deletar um cliente, nesse caso, quando isso ocorre, é dado um 'shift' da direita para a esquerda
;para trazer os outros cadastros para a sequencia novamente
deletar:
	call buscar
	mov ax,di 					 ;Armazena o valor final de até onde se tem memoria de clientes
	mov bx,word[guarda_si]		 ;Armazena o valor inicial do cadastro que será deletado
	sub ax,bx
	mov cx,ax					;Com essa subtração, temos o quanto CX precisa ter para usarmos a função REP e MOVSB
	
	add bx,39					
	mov si,bx				
	mov di,word[guarda_si]

	cld
	repe movsb

	sub di,39 ;Di aponta para um valor menor agora, pois um cliente acabou de ser removido

	call ferrou
	call pularLinha

ret

listarA:
	push si
	push di
	
	mov si, 0x500
	;add si, 39

	initListarA:

	cmp si, di
	je exitListarA
	
	push si
	add si, 31
	mov cx, 3

	push di
	mov di, modeloCodigo
	call carregaSalva
	pop di

	mov bx, modeloCodigo
	int 40h
	call pularLinha	
	pop si

	add si, 39
	jmp initListarA
	
	exitListarA:
	
	pop di
	pop si
ret

listarC:
	push si
	push di
	mov si, 0x500
	
	mov bx,codigo 		;Pede que o CODIGO seja inserido
	int 40h

	mov cx,3
	mov di,modeloCodigo  	;Recebe o CODIGO do cliente
	call scanS

	mov dx,0

	initListarC:
	mov di,modeloCodigo
	cmp dx, word[quant_pessoas]
	je exitListarC		

	add si, 31
	mov cx, 3

	cld
	repe cmpsb
	je initListarC2
	jmp initListarC2.1


		initListarC2:
				
		mov cx,5	
		mov di, modeloNumero
		call carregaSalva

		push si
		call pularLinha
		mov bx, modeloNumero
		int 40h
		pop si

		;add si, 39

		jmp initListarC
		
		initListarC2.1:
		mov ax,3
		sub ax,cx
		add ax,5
		add si,ax	
		inc dx



	jmp initListarC
	
	exitListarC:
	mov al,'&'
	call print
	
	pop di
	pop si
ret



;FUNÇÕES QUE DOUGLAS FEZ
reverse:
	mov di, si
	xor cx, cx ; zerar contador
	.loop1:
	lodsb
	cmp al, 0
	je .endloop1
	inc cl
	push ax
	jmp .loop1
	.endloop1:

	;reverse:
	.loop2:
	cmp cl, 0
	je .endloop2
	dec cl
	pop ax
	stosb
	jmp .loop2
	.endloop2:
ret

tostring: ; ax = 9999
	push di
	.loop1:
	cmp ax, 0
	je .endloop1
	xor dx, dx
	mov bx, 10

	div bx ; ax = 999, dx = 9
	xchg ax, dx; swap ax, dx
	add ax, 48 ; 9 + '0' = '9'
	stosb
	xchg ax, dx
	jmp .loop1
	.endloop1:

	;to string:
	pop si
	cmp si, di
	jne .done
	mov al, 48
	stosb
	.done:
	mov al, 0
	stosb
	call reverse
ret





start: 
		 push ds
		 mov ax, 0
		 mov ds, ax
		 mov di, 100h
		 mov word[di], printS
		 mov word[di + 2], 0
		 pop ds

		
    		 mov di, 0x500		 		

		loop:
		call pularLinha
				mov bx, menu
		 		int 40h
				loop2:
				call pularLinha
				call ler
				cmp al,'1'
				je a1
				cmp al,'2'
				je a2
				cmp al,'3'
				je a3
				cmp al,'4'
				je a4
				cmp al,'5'
				je a5
				cmp al,'6'
				je a6
				cmp al,'7'
				je exit
		jmp loop2
		jmp loop
				
a1:
call print
call pularLinha
call cadastrar

jmp loop


a2:
call print
call pularLinha

call buscar
call pularLinha
jmp loop



a3:
call print
call pularLinha

call editar
call pularLinha
jmp loop

a4:
call print
call pularLinha

call deletar
call pularLinha
jmp loop

a5:
call print
call pularLinha

call listarA
call pularLinha
jmp loop

a6:
call print
call pularLinha

call listarC
call pularLinha
jmp loop



	jmp 0x8600

exit:
