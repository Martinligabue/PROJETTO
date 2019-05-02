.data
	acapo: .asciiz "\n"
	dentro: .asciiz  "dentro.txt"
	fuori: .asciiz "fuori.txt"
	testo: .space 256
.text
.globl main
main:
	j apri
	li $v0,4
	la $a0,testo
	syscall

	li $v0,4
	la $a0,acapo #porta il la frase a capo
	syscall

	la $t0,testoorig # carica l'indirizzo di del testo originale in t0
	j carica #salva le  variabili nello stack
	la $t2,text
	li $t0,0

apri:
	li $v0,13
	la $a0,dentro
	li $a1, 0		# Read-only Flag
	li $a2, 0		# (ignored)
	syscall
	move $t6,$v0
leggi:
	read:
	li $v0, 14		# Read File Syscall
	move $a0, $t6		# Load File Descriptor
	la $a1, testo	# Load Buffer Address
	li $a2, 256	# Buffer Size
	syscall
	j main

carica: #salva il testo nelllo stack
	lb $t1,($t0)
	addi $sp,$sp,-4  # crea spazio per 1 words nello stack frame partendo dalla posizione -4
	sw $t1,0($sp)
	addi $t0,$t0,1
	bne $t1,$zero,carica # carica ogni bayte del testo origionale nello stack

	la $t0,testoorig #carica l'indirizzo del testo originale in t0
	addi $t0,$t0,-1

scarica: # inverte il testo originale della frase

	addi $sp,$sp,4
	sb $t1,($t0) #carica l'indirizzo del primo byte di t1 in t0
	addi $t0,$t0,1 #somma ogni bayte di t0(t1) di per poi caricarli ed invertirli successivamente
	lw $t1,0($sp)#prende il valore proveniente dallo stack
	bne $t1,$zero,scarica #controlla se il contore è arrivato alla posozione finale

exit:# esce e stampa la frase invertita

  li $v0,4
	la $a0,testoorig#carica l'indirizzo del tsesto originale  in a0 per poi stamparlo
	syscall

	li $v0,10
	syscall
