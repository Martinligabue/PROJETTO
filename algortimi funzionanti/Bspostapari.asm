.data
	testoorig: .asciiz "Testo da convertire"
	acapo: .asciiz "\n"
.text
	li $t4,256
	li $v0,4
	la $a0,testoorig
	syscall

	li $v0,4
	la $a0,acapo #a capo
	syscall

	la $t0,testoorig
	add $t0,$t0,1
ciclo:#	stampa un carattere  giusto  ed uno spostatto di 4
	lb $t3,($t0)
	beq $t3,0,exit
	add $t2,$t3,4
	div $t2,$t4
	mfhi $t2
	sb $t2,($t0) #imposta il carattere nella posizione di memoria del primo byte in posizione pari
	add $t0,$t0,2 #incrementa il contatore

	j ciclo

exit:
	li $v0,4
	la $a0,testoorig
	syscall

	li $v0,10
	syscall
