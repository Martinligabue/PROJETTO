.data

testoerrorealgoritmo: .asciiz "e' stato inserito un testo non corretto"
testo: .asciiz "si e' presentato un errore"
filein: .asciiz "messaggio.txt"
chiave: .asciiz "chiave.txt"
filedecifr: .asciiz "messaggioDecifrato.txt"
filecifr: .asciiz "messaggioCifrato.txt"
buffer: .space 128
buffer2: .space 4

.text

open:

	li $v0, 13				# apriamo il file
	la $a0, filein				# nome file
	la $a1, 0				# legge e basta
	la $a2, 0				# ignorato
	syscall

	move $t0, $v0				# salvimo in t0 il descrittore del file
	blt $v0, 0, errore

read:

	li $v0, 14				# legge file
	move $a0, $t0
	la $a1, buffer				# salviamo nel buffer il contenuto del file
	li $a2, 128
	syscall

close:

 	li  $v0, 16    			#
  	move  $a0, $t0   		 	#
  	syscall
  	
  	li $t1, 0

lunghezzabuffer:

	la $t0, buffer
	lb $t2, ($t0)
	bge $t1, 128, openK
	beq $t2, 0, openK
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	
	j lunghezzabuffer
	
openK:

	li $v0, 13				# apriamo il file chiave
	la $a0, chiave				# nome file chiave
	la $a1, 0				# legge e basta
	la $a2, 0				# ignorato
	syscall

	move $t1, $v0				# salvimo in t0 il descrittore del file chiave
	blt $v0, 0, errore

readK:

	li $v0, 14				# legge file chiave
	move $a0, $t1
	la $a1, buffer2				# salviamo nel buffer il contenuto del file chiave
	li $a2, 4
	syscall

closeK:

 	 li  $v0, 16    			#
  	move  $a0, $t1  		 	#
  	syscall
  	


	la $t2, buffer2

sceltaalgoritmo:

	beq $t2, 'A', algoritmoA
	beq $t2, 'B', algoritmoB
	beq $t2, 'C', algoritmoC
	beq $t2, 'D', algoritmoD
	beq $t2, 'E', algoritmoE

	li $v0, 4
	la $a0, testoerrorealgoritmo
	syscall
	
	j uscita
algoritmoA:

	la $t0,buffer			 	#possiamo sovrascrivere t0
ciclo:						#	stampa il carattere aumentato di 4
	lb $t3,($t0)
	beq $t3,0,exit
	addi $t2,$t3,4
	li $t3,256				#t3 non ci serve più
	div $t2,$t3				#per evitare overflow
	mfhi $t2
	sb $t2,($t0) 				#imposta il carattere  nella posizione di memoria del primo byte
	add $t0,$t0,1 				#incrementa il contatore
	
	j ciclo

algoritmoB:
algoritmoC:
algoritmoD:
algoritmoE:



uscita:

	li $v0, 10
	syscall




exit:
	addi $t2,$t2,1
	j sceltaalgoritmo







































errore:

	li $v0, 4
	la $a0, testo
	syscall
