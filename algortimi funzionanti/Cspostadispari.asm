.data
	testoorig: .asciiz "Testo da convertire"
	acapo: .asciiz "\n"
.text
	li $t4,256
	li $v0,4
	la $a0,testoorig #carico l'indirizzo del testo originale in a0
	syscall

	li $v0,4
	la $a0,acapo #porta la frase a capo
	syscall

	la $t0,testoorig #carico l'indirizzo del testo orizzontale in t0

ciclo:#	stampa il carattere aumentato di 4 in posizione dispari
	lb $t3,($t0)
	beq $t3,0,exit
	add $t2,$t3,4
	div $t2,$t4
	mfhi $t2
	sb $t2,($t0) #imposta il carattere nella posizione di memoria del primo byte in posizione dispari
	add $t0,$t0,2 #incrementa il contatore di 2
	j ciclo

exit:
	li $v0,4
	la $a0,testoorig #carico l'indirizzo del testo originale in a0
	syscall

	li $v0,10
	syscall
