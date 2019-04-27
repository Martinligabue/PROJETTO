.data
	coleottero: .asciiz "PoP"
	buffer: .space 256
.text
inizio:
	la $s0,coleottero
	la $s2,buffer

	move $t0,$s0
	j conta	
	
conta:
	lb $t1,($t0)
	beqz  $t1,reset
	addi $t0,$t0,1
	addi $t2,$t2,1
	j conta

reset:
	move $s1,$t2
	li $t2,-1 #rassetta le variabile 2
	j cicloCheScorre

cicloCheScorre:
	move $t0,$s0
	move $t4,$s0
	addi $t2,$t2,1
	lb $t1,($t0)
	addi $t0,$t0,1
	j cicloControllo
	
cicloControllo:#guarda a sinistra prima di attraversare
	bge $t2,$t3,salvaLettera#non ha trovato nulla rpima
	lb $t5,($t4)
	addi $t3,$t3,1
	addi $t4,$t4,1
	beq $t5,$t1,cicloCheScorre  #se sono uguali i due caratteri
	j cicloControllo
	
salvaLettera:
	sb $t1,($s2)
	addi $s2,$s2,1
	move $t8,$t2
	j vediamoSeSiRipete
	
vediamoSeSiRipete:
	bge $t8,$s1,cicloCheScorre#quando finisce di scorrere il testo, torna...
	addi $s2,$s2,1
	add $t8,$s0,$t8
	lb $t7,($t8)
	addi $t8,$t8,1
	beq $t7,$t1,salvaNumeroDoppione #se sono uguali
	j vediamoSeSiRipete
	
salvaNumeroDoppione:
	li $s2,'-'
	jal converti
	
	
	
	
	
converti:
	move $t9,$t8
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	j cicloCheScorre
	li $v0,10
	syscall