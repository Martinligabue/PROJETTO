.data
	testo: 		.asciiz "U"
	#testo_criptato: 	.asciiz "F-0 r-1-14-17 a-2-7 s-3 e-4-13-18  -5-8 d-6 c-9 o-10 n-11 v-12 t-15 i-16"
	sbaffer:		.space 1024
.text
main:
	li $v0,4
	la $a0,testo
	syscall
	
	la $t0,testo
	move $t2,$t0
	la $s0,sbaffer
	move $s1,$t0 #salviamo l'inizio del vettore in t0
cuoricino:	
	li $s6,'@'
	sb $s6,($s1) #qui salvo il trattino
	addi $s1,$s1,1
	
cicloCheScorre:
	addi $t7,$t7,1#contatore posizione in t7
	lb $t1,($t0) #carichiamo la prima lettera in t1
	beq $t1,$0,scrive
	addi $t0,$t0,1 #sposto l'indice del vettoro e
	move $t9,$s0 #salvo l'inizio del vettore
cicloControllo: #controlla se c'è già questo valore nel vettore	
	bge $t9,$t0,salvaLettera # con valore 0 #comincia a creare il blocco
	lb $t2,($t9)
	lb $t3,($t0)
	addi $t9,$t9,1 #contatore
	beq $t2,$t3,cicloCheScorre# 1 #torna a ciclocgescorre con valore +1 (lo fa già) #qui cmq controlla se il valroe dei due registri è guauale
	j cicloControllo
	################## fin qui tutto giusto

salvaLettera:
	sb $t1,($s1)
	addi $s1,$s1,1
	#mette il 45
	li $t1,'-'
	sb $t1,($s1) #qui salvo il trattino
	addi $s1,$s1,1
	
	sb $t7,($s1) #qui non ho idea di come salvare un numero
	addi $s1,$s1,1

	addi $t4,$t4,2 ####roba copiata sobra e soppo
	li $t6,0
	j cicloRipetizione
spazio:
	li $t1,' '
	sb $t1,($s1) #qui salvo il trattino
	addi $s1,$s1,1
	j cicloCheScorre
	
cicloRipetizione:
	
	lb $t1,($t0) #carica la lettera da caricare in t #potrebbe non servire
	lb $t3,($t2)
	
	li $v0,11
	la $a0,($t3)
	syscall
	
	beq $t3,$s6,spazio#ha trovato la fine del vettore

	addi $t2,$t2,1 #aumenta questa roba
	addi $t6,$t6,1 #ciclo
	beq $t3,$t1,salvaRipetizione #ha trovato che il valore che scorre è uguale al valore sentinella
	j cicloRipetizione
	
salvaRipetizione:
	li $t1,'-'
	sb $t1,($s1) #qui salvo il trattino
	addi $s1,$s1,1
	
	sb $t6,($s1) #ci salva male un numero
	addi $s1,$s1,1
	j cicloRipetizione

scrive:

esce:
	li $v0,4 #prima c'era uno zero
	la $a0,testo
	syscall
	
	li $v0,10
	syscall
