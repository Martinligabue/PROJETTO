.data

testo: .asciiz "l-0 a-1-4-7  -2 c-3-5-6"
end: .asciiz "la frase cifrata era"
sbuffer: .space 256

.text

	la $s0, testo
	li $s1,-1			#facciamo in modo che non sia zero senno' il beqz risulta subito uguale a zero
	j lunghezzatesto

lunghezzatesto:				#ciclo grande, da cmabiare di nome

	#beqz $s1,uscitaseria
	lb $s1,($s0)			#salviamo in s1 la letteraaaaa
	addi $s0,$s0,1
	lb $t0,($s0)
	bne $t0,'-',uscitaseria
	addi $s0,$s0,1

	j leggesalvanumero

leggesalvanumero:

	lb $s2,($s0)			#salviamo in t2 il primo numero
	subi $s2,$s2,48

	j controllonumero

controllonumero:

	addi $s0,$s0,1
	lb $t0,($s0)
	beq $t0,'-',converteprim
	beq $t0,' ',convertesec
	subi $t0,$t0,48
	move $t2,$t0
	mul $s2,$s2,10
	add $s2,$s2,$t2

	j controllonumero

converteprim:

	la $t1, sbuffer 			#salviamo in t1 il buffer per poterci salvare la roba dentro
	add $t1,$t1,$s2
	sb $s1,($t1)
	addi $s0,$s0,1

	j leggesalvanumero

convertesec:

	la $t1, sbuffer 			#salviamo in t1 il buffer per poterci salvare la roba dentro
	add $t1,$t1,$s2
	sb $s1,($t1)
	addi $s0,$s0,1
	li $s1,-1

	j lunghezzatesto

uscitaseria:

 	li $v0, 4
 	la $a0, end
 	syscall

 	li $v0, 4
	la $a0, sbuffer
	syscall

	li $v0,10
	syscall
