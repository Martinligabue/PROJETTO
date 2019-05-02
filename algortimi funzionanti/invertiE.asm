.data
    testo: .asciiz "a-0-1-3 b-2"
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
    beqz $t1,main
    addi $t0,$t0,1
    j contalunghezzatesto
reset:
	move $t0,$s3#salvo lunghezza testo
	li $t1,0
	move $t0,$s0
main:
	beq $s2,$s3,esci
	lb $t1,($t0)
	jal trovaposizione
	
	addi $s2,$s2,1 #contatore numerico
	addi $t0,$t0,1 #contatore indirizzico
	j main
	
tornaalmain:
	addi $s2,$s2,1 #contatore numerico
	addi $t0,$t0,1 #contatore indirizzico
	j main
	
trovaposizione:
	move $t3,$t0
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
	la $t0,buffer
	j carica
	
carica:
	addi $t5,$t5,1
	addi $t0,$t0,1 #spostiamo l'indiririzzo...
	blt $t5,$t4,carica #...tante volte quante ne servono a un contatore per arrivare a t4
	sb $t1,($t0) #salviamo in quella posizione la lettera
esci:
	li $v0,10
	syscall