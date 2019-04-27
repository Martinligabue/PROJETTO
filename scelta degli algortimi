.data
	CIAO: .asciiz "SCEGLI UN CAZZO DI ALGORMITMO O PIU' DI UNO, POI MUORI"
	ordine: .space 5

.text
main:
	la $s0,ordine
	li $v0,4
	la $a0,CIAO
	syscall
lettura:	
	li $v0,12
	syscall
	addi $t0,$t0,1
	sb $v0,($s0)
	addi $s0,$s0,1
	bge $t0,5,algoritmi
	j lettura
	
algoritmi: