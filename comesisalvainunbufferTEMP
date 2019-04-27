nizioNumero:
	li $t1,$t9 #numero da convertire e caricare
	la $s0,($s2) #metter nel buffer in una certa posizione i numeri
cicloNumero:
	subi $sp,$sp, 4
	li $s0,10
	div $t1, $s0
	mfhi $t2
	mflo $t1
	sw $t2,0($sp)
	beq $t1, 0, esce
	j ciclo
caricaNumero:
	lw $t3,0($sp)
	addi $sp,$sp,4
	addi $t3,$t3,48
	sb $t3,($s0)
	addi $s0,$s0,1
	bne $t3,48,esce