.data

  testoerrorealgoritmo: .asciiz "e' stata inserita una chiave non corretta"
  eroreio: .asciiz "si e' presentato un errore nell'apertura del file"
  filein: .asciiz "messaggio.txt"
  chiave: .asciiz "chiave.txt"
  filedecifr: .asciiz "messaggioDecifrato.txt"
  filecifr: .asciiz "messaggioCifrato.txt"
  buffer: .space 128 #buffer file input
  bufferK: .space 4  #buffer file chiave
  bufferTemp: .space 256
.text

.globl main
main:
  addi $sp,$sp,-12 #salvo
  sw $ra, 0($sp)   #ra
  sw $s0, 4($sp)    #e
  sw $s1, 8($sp)    #i
  jal letturaFiles  #registri

  move $t8, $t1
  #move $t8, $s0
  #s0 lunghezza file input
  move $s1, $v1 #in s1 lunghezza chiave

  la $t0, bufferK
  jal sceltaAlgoritmo
  jal stampaCriptato

 # jal invertiEAggiungi5

  jal sceltaAlgoritmo

  jal stampaDecriptato

  jr $ra


sceltaAlgoritmo:

  lb $t2, ($t0)
  ble $t8, 0, jrra
  subi $t8, $t8, 1
  beq $t2, 'A', algoritmoA
  #beq $t2, 'B', algoritmoB
 # beq $t2, 'C', algoritmoC
  beq $t2, 'D', algoritmoD
 # beq $t2, 'E', algoritmoE
  #beq $t2, 'F', algoritmoAinv
  #beq $t2, 'G', algoritmoBinv
 # beq $t2, 'H', algoritmoCinv
  beq $t2, 'I', algoritmoD
  #beq $t2, 'J', algoritmoEinv

  li $v0, 4
  la $a0, testoerrorealgoritmo
  syscall

  jr $ra

############################################
letturaFiles:
#apertura testo input

	li $v0, 13				# apriamo il file
	la $a0, filein		# nome file
	la $a1, 0					# legge e basta
	la $a2, 0					# ignorato
	syscall

	move $t0, $v0				# salvimo in t0 il descrittore del file
	blt $v0, 0, errore	#quando il descrittore e' minore di 0 significa che si e' verificato un errore

#lettura contenuto
	li $v0, 14				# legge file
	move $a0, $t0
	la $a1, buffer				# salviamo nel buffer il contenuto del file
	li $a2, 128
	syscall

#chiusura file testo input
		li  $v0, 16
		move  $a0, $t0
  	syscall

  	li $t1, 0
  	la $t0, buffer

lunghezzabuffer:

	lb $t2, ($t0)
	bge $t1, 128, openK		#fa il ciclo finche' non si riempe il buffer
	beq $t2, 0, openK			#fa il ciclo finche' non finisce il testo
	addi $t1, $t1, 1			#contatore
	addi $t0, $t0, 1

	j lunghezzabuffer

  openK:



  	li $v0, 13				# apriamo il file chiave
  	la $a0, chiave		# nome file chiave
  	la $a1, 0					# legge e basta
  	la $a2, 0					# ignorato
  	syscall

  	move $t1, $v0				# salvimo in t0 il descrittore del file chiave
  	blt $v0, 0, errore


#lettura file chiave

	li $v0, 14				# legge file chiave
	move $a0, $t1
	la $a1, bufferK			# salviamo nel buffer il contenuto del file chiave
	li $a2, 4				#dobbiamo mettere il caso di errore
	syscall
#chiusura file chiave

 	 li  $v0, 16
	 move  $a0, $t1
	 syscall
	 la $t0, bufferK
	 li $t1, 0

lunghezzabufferK:

	lb $t2, ($t0)
	bge $v1, 128, jrra		#come prima ma con il file chiave.txt
	beq $t2, 0, jrra
	addi $v1, $v1, 1 #in v1 c'e' la lunghezza della chiave
	addi $t0, $t0, 1

	j lunghezzabufferK

  stampaCriptato:

  	li $v0, 13				# Open File Syscall
  	la $a0, filecifr			# Load File Name
  	li $a1, 1
  	li $a2, 0
  	syscall

  	move $t1, $v0				# Save File Descriptor

  	li $v0, 15				# Write File Syscall
  	move $a0, $t1				#  = $a0, $t1    	# Load File Descriptor
  	la $a1, buffer				# Load Buffer Address
  	li $a2, 128				# Buffer Size
  	syscall


  	li $v0, 16				# Close File Syscall
  	move $a0, $t6				# Load File Descriptor
  	syscall

  	li $v0, 16				# Close File Syscall
  	move $a0, $t1				# Load File Descriptor
  	syscall

  	jr $ra

  stampaDecriptato:

  	li $v0, 13				# Open File Syscall
  	la $a0, filedecifr			# Load File Name
  	li  $a1, 1
  	li  $a2, 0
  	syscall

  	move $t1, $v0				# Save File Descriptor

  	li $v0, 15				# Write File Syscall
  	move $a0, $t1			  	# Load File Descriptor
  	la $a1, buffer				# Load Buffer Address
  	li $a2, 128				# Buffer Size
  	syscall

  	li $v0, 16				# Close File Syscall
  	move $a0, $t6				# Load File Descriptor
  	syscall

  	li $v0, 16				# Close File Syscall
  	move $a0, $t1				# Load File Descriptor
  	syscall

    jr $ra


    algoritmoA:

    	la $t4, buffer			 	#possiamo sovrascrivere t0

    cicloA:						#	stampa il carattere aumentato di 4

    	lb $t3,($t4)
    	beq $t3,0,sceltaAlgoritmo
    	addi $t2,$t3,4
    	li $t3,256				#ci serve il valore 256
    	div $t2,$t3				#per evitare overflow
    	mfhi $t2					#prende il numero senza overflow
    	sb $t2,($t4) 				#imposta il carattere  nella posizione di memoria del primo byte
    	add $t4,$t4,1 				#incrementa il contatore

    	j cicloA

algoritmoD:

      	la $t4, buffer			 	#possiamo sovrascrivere t0

      carica: 					#salva il testo nello stack

      	lb $t1,($t4)
        la $t5,$sp
      	addi $sp,$sp,-4 	 		# crea spazio per 1 words nello stack frame partendo dalla posizione -4
      	sw $t1,0($sp)
      	addi $t4,$t4,1
      	bne $t1,$zero,carica 			# carica ogni byte del testo origionale nello stack

      	la $t4, buffer				#carica l'indirizzo del testo originale in t0
      	addi $t4,$t4,-1

      scarica: 					# inverte il testo originale della frase

      	addi $sp,$sp,4
      	sb $t1,($t4) 				#carica l'indirizzo del primo byte di t1 in t0
      	addi $t4,$t4,1 				#somma ogni bayte di t0(t1) di per poi caricarli ed invertirli successivamente
      	lw $t1,0($sp)				#prende il valore proveniente dallo stack

      	ble $t1,$t5,scarica 			#controlla se il contore e' arrivato alla posizione finale

j sceltaAlgoritmo




  salvaStack:

  	addi $sp,$sp,-32
  	sw $s0,0($sp)
  	sw $s1,4($sp)
  	sw $s2,8($sp)
  	sw $s3,12($sp)
  	sw $s4,16($sp)
  	sw $s5,20($sp)
  	sw $s6,24($sp)
    sw $s7,28($sp)
  	jr $ra

  ripristinaStack: #attenzione al nome
  	lw $s0,0($sp)
  	lw $s1,4($sp)
  	lw $s2,8($sp)
  	lw $s3,12($sp)
  	lw $s4,16($sp)
  	lw $s5,20($sp)
  	lw $s6,24($sp)
  	lw $s7,28($sp)
  	addi $sp,$sp,32
  	jr $ra

    errore:

    	li $v0, 4
    	la $a0, eroreio
    	syscall
    	li $v0,10
      syscall

    jrra:
     jr $ra
