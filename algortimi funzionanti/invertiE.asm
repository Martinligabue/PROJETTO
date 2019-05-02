.data
    testo: .asciiz "a-0-1-2-3"
    buffer: .space 256
.text

    la $s0,testo

fraseiniziale:
    li $v0,4
    la $a0,testo
    syscall
    move $t0,$s0

contalunghezzatesto:
    lb $t1,($t0)
    beqz $t1,reset
    addi $t0,$t0,1
    addi $t2,$t2,1
    j contalunghezzatesto

reset:
	move $s3,$t2#salvo lunghezza testo
	li $t1,0
    li $t2,0
	move $t0,$s0
    j main
    
main:#questo ciclo fa lettera per lettera
	beq $s2,$s3,esci
	lb $t1,($t0)
	j trovaposizione

	jal spostatesto
	j main

spostatesto:
    addi $s2,$s2,1 #contatore numerico
    addi $t0,$t0,1 #contatore indirizzico
    jr $ra

tornaalmain:
	jal spostatesto
	j main

trovaposizione:
	move $t3,$t0
    jal	spostatesto
    addi $t3,$t3,1
	lb $t4,($t3)
	beq $t4,'-',trovatotrattino
	beq $t4,' ',tornaalmain #si ferma
	#altrimenti c'e' un numero
	j trovaposizione

trovatotrattino:
	addi $t3,$t3,1
	lb $t4,($t3)
	addi $t5,$t3,1
	lb $t5,($t5)
	bne $t5,'-',nontrattino
	j salvacifra

nontrattino:
	bne $t5,' ',nonspazio
	j doppiaalmeno

nonspazio:
doppiaalmeno:
salvacifra:
	subi $t4,$t4,48
	la $t6,buffer
	j carica

carica:
	addi $t5,$t5,1
	addi $t6,$t6,1 #spostiamo l'indiririzzo...
	ble $t5,$t4,carica #...tante volte quante ne servono a un contatore per arrivare a t4
	sb $t1,($t6) #salviamo in quella posizione la lettera
	jal spostatesto
	j trovaposizione

esci:
	li $v0,10
	syscall
