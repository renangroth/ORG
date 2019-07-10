     .data

dificuldade:	    .asciiz		"\nDigite a dificuldade entre: 5 (5x5), 7 (7x7) ou 9 (9x9): "
achouBomba:	    .asciiz		"\nAchou bomba, voce perdeu!\n"
escolhaPosicao:     .asciiz     	"\nDigite a posicao do campo minado (linha (Pressione Enter) coluna):\n"
mostrarCampo:       .asciiz		"\nSeu campo minado:\n"
posicaoInvalida:    .asciiz		"\nCoordenada indisponivel, tente novamente com uma coordenada valida:\n"
tamanhoInvalido:    .asciiz		"\nDificuldade invalida, escolha uma dificuldade valida! (5, 7 ou 9)"
espaco:             .asciiz     	" "
bomba:              .asciiz     	" 9"
novalinha:	    .asciiz		"\n"
novabarra:	    .asciiz		"|"
campo:			.space		324
semente:		.asciiz		"\nEntre com a semente da funcao Rand: "
nova_linha:		.asciiz		"\n"
posicao:		.asciiz		"\nPosicao: "
salva_S0:		.word		0
salva_ra:		.word		0
salva_ra1:		.word		0


MatrizCampo:                          # Matriz controle campo minado 
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0

matrizUsuario:                  # matriz impressa // -1 para nao confudir com 0 bombas ao redor
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1

	    .text
main:
        li  $v0, 4                  # define operacao de chamada
        la  $a0, dificuldade        # imprime escolha de dificuldade
        syscall                     # imprime a string

        li  $v0, 5		    # prepara pra pegar valor digitado
        syscall                     # Imprime para usuario digitar tamanhao campo
        add $a1, $zero, $v0         
        
        beq $a1, 5, else            # verifica se dificuldade e 5
        beq $a1, 7, else            # verifica se dificuldade e 7
        beq $a1, 9, else            # verifica se dificuldade e 9
        li  $v0, 4                  # define operacao de chamada
        la  $a0, tamanhoInvalido    # imprime tamanho invalido
        syscall                     # imprime a string
        j main                      # volta para main pois tamanho e invalido

        else:                       # caso tamanho valido
        add $a3, $zero, $zero       # seta $a3 como controle de fim do jogo

        la $a0, MatrizCampo         # referencia da matriz campo 
        jal insere_bombas           # chama funcao inserir bombas
        la $a0, MatrizCampo         # referencia da matriz campo 
        jal calcula_bombas          # chama funcao para calcular bombas

        pedePosicao:                # printa o campo e pede outra posicao
        la $a0, MatrizCampo         # referencia da matriz campo 
        la $a2, matrizUsuario       # referencia da matriz usuario
        jal mostra_campo            # printa campo minado

        outraPosicao:               # Pede outra posicao e continua 
        li  $v0, 4                  # define operacao de chamada
        la  $a0, escolhaPosicao     # imprime mensagem para inserir posicao
        syscall                     # imprime a string

        li  $v0, 5                  # prepara para pegar valor digitado
        syscall                     # imprime para digitar coordenada Y
        add $t1, $zero, $v0         # y (linhas)
        subi $t1, $t1, 1            # linhas -1

        li  $v0, 5                  # prepara para pegar valor digitado
        syscall                     # imprime para digitar coordenada X
        add $t0, $zero, $v0         # x (colunas)
        subi $t0, $t0, 1            # colunas -1

        slt $t4, $t0, $a1           # verifica se X pertence a matriz
        beq $t4, 1, verificaY
        li  $v0, 4                  # define operacao de chamada
        la  $a0, posicaoInvalida    # imprime mensagem de coordernadas invalidas
        syscall                     # imprime a string
        j outraPosicao              # volta para outraPosicao para escolher novamente a coordenada da matriz

        verificaY:
        slt $t4, $t1, $a1           # verifica se Y pertence a matriz
        beq $t4, 1, verificaX
        li  $v0, 4                  # define operacao de chamada
        la  $a0, posicaoInvalida    # imprime mensagem de coordernadas invalidas
        syscall                     # imprime a string
        j outraPosicao              # volta para outraPosicao para escolher novamente a coordenada da matriz

        verificaX:
        slt $t4, $t0, $zero         # verifica se X < ou = 0
        beq $t4, 0, verificaYY
        li  $v0, 4                  # define operacao de chamada
        la  $a0, posicaoInvalida    # imprime mensagem de coordernadas invalidas
        syscall                     # imprime a string
        j outraPosicao              # volta para outraPosicao para escolher novamente a coordenada da matriz

        verificaYY:
        slt $t4, $t1, $zero         # verifica se Y < ou = 0
        beq $t4, 0, else1
        li  $v0, 4                  # define operacao de chamada
        la  $a0, posicaoInvalida    # imprime mensagem de coordernadas invalidas
        syscall                     # imprime a string
        j outraPosicao              # volta para outraPosicao para escolher novamente a coordenada da matriz 
        
        else1:                       # controle de posicao da matriz:
        mul $s1, $t1, 9             # posicao_matriz = y * ordem da matriz (9)
        add $s1, $s1, $t0           # posicao_matriz + x
        mul $s1, $s1, 4             # calcula posicao

        lw  $s3, MatrizCampo($s1)   # salva endereco da posicao campo
        sw  $s3, matrizUsuario($s1) # salva valor de campo em usuario
        
                                    # verifica se ha bomba na posicao selecionada
        bne $s3, 9, continua
        addi $a3, $zero, 1          # seta variavel de fim de jogo para 1
        li  $v0, 4                  # define operacao de chamada
        la  $a0, achouBomba         # salva mensagem de fim de jogo
        syscall                     # imprime a string
        
        la $a0, MatrizCampo         # referencia da matriz campo
        la $a2, matrizUsuario       # referencia da matriz usuario
        jal mostra_campo            # imprime o campo minado pela ultima vez com as bombas
        j final                     # finaliza o jogo
        
        continua:
        j pedePosicao               # continua o jogo printando o campo minado e pedindo outra coordenada

mostra_campo:                        
       
       add $s4, $a0, $zero          # salva endereco da matriz campo

        li  $v0, 4                  # define operacao de chamada
        la  $a0, mostrarCampo       # imprime mensagem para mostrar campo minado
        syscall                     # imprime a string

        add $t2, $zero, $zero       # reseta variavel linhas

        for:
        addi $t3, $zero, -1         # reseta variavel colunas
        beq $t2, $a1, exit          # verifica fim do for

        for2:
        addi $t3, $t3, 1            # aumenta contador de colunas
        beq $t3, $a1, exit1         # verifica fim do for2

        mul $s1, $t2, 9             # posicao_matriz = y (linhas) * ordem da matriz (9)
        add $s1, $s1, $t3           # posicao_matriz += x (colunas)
        mul $s1, $s1, 4             # calculo a posicao
        add $s3, $s1, $a2           # calcula endereco da posicao da matriz usuario
        lw  $s3, 0($s3)             # salva posicao da matriz usuario
        add $t5, $s1, $s4           # calcula endereco da matriz campo
        lw  $t5, 0($t5)             # salva posicao da matriz campo
        
        # imprime uma barra
        li $v0, 4              	    # seta valor de operação para string
        la $a0, novabarra            # carrega string
        syscall                     # imprime string
        
        # verifica variavel de fim de jogo, caso nao termine entao continua
        bne $a3, 1, if20        
        bne $t5, 9, if20            # verifica se a posicao da matriz campo[x1][y1] == 9

        li $v0, 4                   # define operacao de chamada
        la $a0, bomba               # imprime valor 9 (bomba)
        syscall                     # imprime a string
        j for2                      # volta para for2 porque o valor e bomba

        if20:                   
        beq $s3, -1, if21           # verifica necessidade de imprimir um espaco
        # imprime um espaÃ§o
        li $v0, 4                   # define operacao de chamada
        la $a0, espaco              # carrega string
        syscall                     # imprime a string

        if21:
        # imprime as posiÃ§Ãµes
        li $v0, 1                   # seta valor de operacao
        add $a0, $s3, $zero         # salva valor de $s3 em $a0 para ser impresso
        syscall                     # imprime a string

        j for2                      # volta para for2
        exit1:
        # imprime uma barra
        li $v0, 4                   # seta valor de operacao para string
        la $a0, novabarra            # carrega string
        syscall                     # imprime string
        # imprime nova linha
        li $v0, 4                   # seta valor de operação para string
        la $a0, novalinha           # carrega string
        syscall                     # imprime string
        addi $t2, $t2, 1            # aumenta contador de linha
        j for                       # volta para for
        exit:
                
        jr $ra                      # retorno

calcula_bombas:                     
        subi $s2, $a1, 1            # num_linhas - 1
        add $t2, $zero, $zero       # reseta variavel linhas

        for3:
        addi $t3, $zero, -1         # reseta variavel colunas
        beq $t2, $a1, fim1          # verifica fim do for3

        for4:
        add $s0, $zero, $zero       # reseta contador de bombas
        addi $t3, $t3, 1            # aumenta contador de colunas
        beq $t3, $a1, fim2          # verifica fim do for4

        mul $s1, $t2, 9             # posicao_matriz = linhas * 9
        add $s1, $s1, $t3           # posicao_matriz + colunas
        mul $s1, $s1, 4             # calculo da posicao

        add $s3, $s1, $a0           # calcula endereco da matriz campo
        lw  $s3, 0($s3)             # salva posicao da matriz

        
        bne $s3, 9, if1             # verifica se e bomba
        j for4                      # volta para for4 pois o valor e bomba

        if1:
        subi $s3, $s1, 4            # posicao_matriz - 4 ([x-1][y])
        subi $s3, $s3, 36           # posicao_matriz - 36 ([x-1][y-1])
        add $s3, $a0, $s3           # calcula enderecoo da matriz
        lw  $s3, 0($s3)             # salva posicao da matriz

        beq $t2, 0, if2             # verifica y != 0
        beq $t3, 0, if2             # verifica x != 0
        bne $s3, 9, if2             # verifica se e bomba
        addi $s0, $s0, 1            # i++

        if2:
        subi $s3, $s1, 36           # posicao_matriz - 36 ([x][y-1])
        add $s3, $s3, $a0           # calcula endereco da matriz
        lw  $s3, 0($s3)             # salva posicao da matriz

        beq $t2, 0, if3             # verifica y != 0
        bne $s3, 9, if3             # verifica se e bomba
        addi $s0, $s0, 1            # i++

        if3:
        addi $s3, $s1, 4            # posicao_matriz + 4 ([x+1][y])
        subi $s3, $s3, 36           # posicao_matriz - 36 (M[x+1][y-1])
        add $s3, $s3, $a0           # calcula endereco da matriz
        lw  $s3, 0($s3)             # salva posicao da matriz
        
        beq $t3, $s2, if4           # verifica x != num_linhas
        beq $t2, 0, if4             # verifica y != 0
        bne $s3, 9, if4             # verifica se e bomba
        addi $s0, $s0, 1            # i++

        if4:
        subi $s3, $s1, 4            # posicao_matriz - 4 ([x-1][y]) 
        add $s3, $s3, $a0           # calcula endereco da matriz
        lw  $s3, 0($s3)             # salva posicao da matriz
        
        beq $t3, 0, if5             # verifica x != 0
        bne $s3, 9, if5             # verifica se e bomba
        addi $s0, $s0, 1            # i++

        if5:
        addi $s3, $s1, 4            # posicao_matriz + 4 ([x+1][y]) 
        add $s3, $s3, $a0           # calcula endereco da matriz
        lw  $s3, 0($s3)             # salva posicao da matriz
        
        beq $t3, $s2, if6           # verifica x != num_linhas
        bne $s3, 9, if6             # verifica se e bomba
        addi $s0, $s0, 1            # i++

        if6:
        subi $s3, $s1, 4            # posicao_matriz - 4 ([x-1][y])
        addi $s3, $s3, 36           # posicao_matriz + 36 ([x-1][y+1])
        add $s3, $s3, $a0           # calcula endereco da matriz
        lw  $s3, 0($s3)             # salva posicao da matriz

        beq $t3, 0, if7             # verifica x != 0
        beq $t2, $s2, if7           # verifica y != num_linhas
        bne $s3, 9, if7             # verifica se e bomba
        addi $s0, $s0, 1            # i++

        if7:
        addi $s3, $s1, 36           # posicao_matriz + 36 ([x][y+1])
        add $s3, $s3, $a0           # calcula endereco da matriz
        lw  $s3, 0($s3)             # salva posicao da matriz
        
        beq $t2, $s2, if8           # verifica y != num_linhas
        bne $s3, 9, if8             # verifica se e bomba
        addi $s0, $s0, 1            # i++

        if8:
        addi $s3, $s1, 4            # posicao_matriz + 4 ([x+1][y])
        addi $s3, $s3, 36           # posicao_matriz + 36 ([x+1][y+1])
        add $s3, $s3, $a0           # calcula endereco da matriz
        lw  $s3, 0($s3)             # salva posicao da matriz

        beq $t3, $s2, continua1     # verifica se x != num_linhas
        beq $t2, $s2, continua1     # verifica se y != num_linhas
        bne $s3, 9, continua1       # verifica se e bomba
        addi $s0, $s0, 1            # i++

        continua1:
        add $s3, $s1, $a0           # calcula endereco da matriz                   
        sw  $s0, 0($s3)             # seta o valor de bombas ao redor da posicao
        j for4                      # volta para for4

        fim2:
        addi $t2, $t2, 1            # aumenta contador de linhas da matriz
        j for3                      # volta para for3

        fim1:
        jr $ra


insere_bombas:                      # void insere_bombas(int * campo[], int num_linhas);
        
       la	$t0, salva_S0
		sw  $s0, 0($t0)		# salva conteudo de s0 na memoria
		la	$t0, salva_ra
		sw  $ra, 0($t0)		# salva conteudo de ra na memoria
		
		add $t0, $zero, $a0	# salva a0 em t0
		add $t1, $zero, $a1	# salva a1 em t1

		li	$v0, 1
		add $a0, $zero, $a1 #
		syscall		
		
		li	$v0, 4			# 
		la	$a0, nova_linha
		syscall			

verifica_menor_que_5:
		slti $t3, $t1, 5
		beq	 $t3, $0, verifica_maior_que_9
		addi $t1, $0, 5			#se tamanho do campo menor que 5 atribui 5
		add  $a1, $0, $t1
verifica_maior_que_9:
		slti $t3, $t1, 9
		bne	 $t3, $0, testa_5
		addi $t1, $0, 9			
		add  $a1, $0, $t1
testa_5:
		addi $t3, $0, 5
		bne  $t1, $t3, testa_7
		addi $t2, $0, 10 # 10 bombas no campo 5x5
		j	 pega_semente
testa_7:
		addi $t3, $0, 7
		bne  $t1, $t3, testa_9
		addi $t2, $0, 20 # 20 bombas no campo 7x7
		j	 pega_semente
testa_9:
		addi $t3, $0, 9
		bne  $t1, $t3, else_qtd_bombas
		addi $t2, $0, 40 # 40 bombas no campo 9x9
		j	 pega_semente
else_qtd_bombas:
		addi $t2, $0, 25 # seta para 25 bomas no else		
pega_semente:
		jal SEED
		add $t3, $zero, $zero # inicia contador de bombas com 0
INICIO_LACO:
		beq $t2, $t3, FIM_LACO
		
		add $a0, $zero, $t1 # carrega limite para %
		jal PSEUDO_RAND
		add $t4, $zero, $v0	# pega linha sorteada e coloca em t4
   		jal PSEUDO_RAND
		add $t5, $zero, $v0	# pega coluna sorteada e coloca em t5

################ imprime valores na tela (para debug somente)
	
#		li	$v0, 4			# mostra linha sorteada
#		la	$a0, posicao
#		syscall
#		li	$v0, 1
#		add $a0, $zero, $t4 #linha
#		syscall
#
#		add $a0, $zero, $t5 #coluna
#		syscall
#		
#		li	$v0, 4			# mostra coluna sorteada
#		la	$a0, espaco
#		syscall
#		li	$v0, 1		
#		add $a0, $zero, $t3 #linha
#		syscall
		
#######################	
	
		mult $t4, $t1
		mflo $t4
		add  $t4, $t4, $t5  # calcula (L * tam) + C
		add  $t4, $t4, $t4  # multtiplica por 2
		add  $t4, $t4, $t4  # multtiplica por 4
		add	 $t4, $t4, $t0	# calcula Base + deslocamento
		lw	$t5, 0($t4)		# Le posicao de memoria LxC

		
		addi $t6, $zero, 9	
		beq  $t5, $t6, PULA_ATRIB
		sw   $t6, 0($t4)
		addi $t3, $t3, 1		
PULA_ATRIB:
		j	INICIO_LACO
FIM_LACO:


#		la   $a0, campo
#		addi $a1, $zero, 7
#		jal MOSTRA_CAMPO	
		
		la	$t0, salva_S0
		lw  $s0, 0($t0)		# recupera conteudo de s0 da memória
		la	$t0, salva_ra
		lw  $ra, 0($t0)		# recupera conteudo de ra da memória		
		jr $ra
		



SEED:
	li	$v0, 4			# lendo semente da funcao rand
	la	$a0, semente
	syscall
	li	$v0, 5		#
	syscall
	add	$a0, $zero, $v0	# coloca semente de bombas em a0
	bne  $a0, $zero, DESVIA
	lui  $s0,  1		# carrega semente 100001
 	ori $s0, $s0, 34465	# 
	jr $ra	
DESVIA:
	add	$s0, $zero, $a0		# carrega semente passada em a0
	jr $ra
	


#
#função que gera um número randomico
#
 #int rand1(int lim) {
 # static long a = 100001; 
 #a = (a * 125) % 2796203; 
 #return ((a % lim) + 1); 
 #} // 
  
PSEUDO_RAND:
	addi $t6, $zero, 125  	# carrega 125
	lui  $t5,  42			# carrega fator: 2796203
	ori $t5, $t5, 43691 	#-
	
	mult  $s0, $t6			# a * 125
	mflo $s0				# a = (a * 125)
	div  $s0, $t5			# a % 2796203
	mfhi $s0				# a = (a % 2796203)
	div  $s0, $a0			# a % lim
	mfhi $v0                # v0 = a % lim
	jr $ra

final:
