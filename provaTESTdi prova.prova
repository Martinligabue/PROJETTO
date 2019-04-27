.data
	coleottero: .asciiz "abaac"
	buffer: .space 256
.text
inizio:
	la $s0,coleottero
	la $s2,buffer
	move $s4,$s2
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
	li $t2,-1 
	move $t0,$s0
	j cicloCheScorre

cicloCheScorre:
	move $t4,$s0
	addi $t2,$t2,1
	lb $t1,($t0)
	addi $t0,$t0,1
	j cicloControllo
	
cicloControllo:#guarda a sinistra prima di attraversare
	bge $t2,$t3,salvaLettera#non ha trovato nulla rpima
	lb $t5,($t4)

	addi $t3,$t3,1
	move $t3,$s7#salva4
	addi $t4,$t4,1
	beq $t5,$t1,cicloCheScorre  #se sono uguali i due caratteri
	move $s7,$t3#salva4
	j cicloControllo
	
salvaLettera:
	sb $t1,($s4)
	addi $s4,$s4,1
	j vediamoSeSiRipete
	
vediamoSeSiRipete:
	bge $t3,$s1,cicloCheScorre#quando finisce di scorrere il testo, torna...
	addi $s2,$s2,1
	addi $t9,$t9,1
	lb $t7,($t4)
	addi $t4,$t4,1
	addi $t3,$t3,1
	move $t3,$s7
	beq $t7,$t1,salvaNumeroDoppione #se sono uguali
	j vediamoSeSiRipete
	
salvaNumeroDoppione:
	li $s2,'-'
	j converti
	
	
	
	
converti:
	#numero da convertire e caricare
#	move  $s4,$s2 #metter nel buffer in una certa posizione i numeri
#	addi $s4,$s4, 1
	
cicloNumero:
	
	subi $sp,$sp, 4
	li $s3,10
	div $t9, $s3
	mfhi $t2
	mflo $t9
	sb $t2,0($sp)
	beq $t9,0,caricaNumero
	j cicloNumero
caricaNumero:
	lw $t3,0($sp)
	addi $sp,$sp,4
	addi $t3,$t3,48
	
	sb $t3,($s4)
	addi $s4,$s4,1
	bne $t3,48,caricaNumero
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	j cicloCheScorre
	li $v0,10
	syscall
	
	
	
	
	
	
	
	
	
	
	
	
	
##############################################################################################################################	
	
	
	ciclonumero:
	subi $sp,$sp, 4
	li $s5,10
	div $s6, $s5
	mfhi $t6
	mflo $s6
	sb $t6,0($sp)
	beq $s6,0,caricaNumero
	
	j ciclonumero
caricaNumero:
	lw $t3,0($sp)
	addi $sp,$sp,4
	addi $t3,$t3,48
	
	sb $t3,($s2)
	addi $s2,$s2,1
	bne $t3,48,caricaNumero
	
	j controllodx
	
uscita:
	li $v0,10
	syscall
	
