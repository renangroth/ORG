.data
	vetor: .word 2,-1,3,5,-7
	
.text
	add s0, zero, zero #contador para o indice do vetor
	add s1, zero, zero #variavel para ver quantas posicoes mover para chegar no inicio do laco

main:
	add a3, s0, zero #contador do laco
	addi a1, zero, 5 #tamanho do vetor em a1
	la a0, vetor #o indice do primeiro numero do vetor 
	add a0, a0, s1
	lw t1, 0(a0) #o valor do primeiro numero do vetor eh dito como o menor

troca_primeiro:
	add a5, t1, zero #primeiro menor do vetor
	jal procura_menor
	add a0, a6, zero #Indice do menor
	add a1, a5, zero #Conteudo do menor
	blt a1, t1, Swap_vetor #Faz a troca

continue:
	addi s0, s0, 1 # Contador + 1
	addi s1, s1, 4 # Auxiliar da posicao + 4
	beq a0, s0, main #verifica se o menor valor eh o primeiro do vetor
	addi a5, zero, 5
	bne s0, a5, main # se nao percorreu todo o vetor volta pra main
	nop
	ebreak

Swap_vetor:
	la a0, vetor #recebe o endereco inicial do vetor
	add a0, a0, s1
	sw a1, (a0)
	sw t1, (a7)
	j continue
	
procura_menor: #procura pelo menor valor
	beq a1, a3, fim_laco #verifica se laco acabou
	lw t0, 0(a0) #carrega valor atual do vetor em t0
	blt t0, a5, menor #if(t0<a5), vai para o rotulo 'menor'
	addi a3, a3, 1 #incrementa em 1 o controlador do la�o
	addi a0, a0, 4 #passa para o proximo valor do vetor
	j procura_menor
	
menor:
	add a5, t0, zero #grava o novo menor valor em a5
	add a6, zero, a3 #grava o indice do menor valor em a6
	add a7, zero, a0 #grava o endereco do menor
	addi a3, a3, 1 # Contador + 1
	addi a0, a0, 4 #Contador + 4 para proximo valor do vetor
	j procura_menor
	
fim_laco:
	ret
