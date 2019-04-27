.data 
	baffer: .space 34
.text

	
	li $v0,4
	la $a0,baffer
	syscall
	
	li $t0,'F'
	sb $t0,baffer
	la $t1,baffer
	addi $t1,$t1,1
	sb $t0,($t1)
	
	li $v0,4
	la $a0,baffer
	syscall
	
	li $v0, 10
	syscall