.text
li $t0,50
li $t5,34
jal salvaStack
li $t0,4
li $t5,6
jal ripristinaStack
li $v0,10
syscall
salvaStack: #228

	addi $sp,$sp,-40
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $t4,16($sp)
	sw $t5,20($sp)
	sw $t6,24($sp)
	sw $t7,28($sp)
	sw $t8,32($sp)
	#sw $ra,36($sp)
	jr $ra
	
ripristinaStack: #attenzione al nome
	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $t4,16($sp)
	lw $t5,20($sp)
	lw $t6,24($sp)
	lw $t7,28($sp)
	lw $t8,32($sp)
	#lw $ra,36($sp)
	addi $sp,$sp,40
	jr $ra