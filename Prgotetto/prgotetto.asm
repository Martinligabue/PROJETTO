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

open:						#dobbiamo inserire il caso di errore

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

 	li  $v0, 16    			
  	move  $a0, $t0   		 	
  	syscall
  	
  	li $t1, 0
  	
  	la $t0, buffer

lunghezzabuffer:

	
	lb $t2, ($t0)
	bge $t1, 128, openK
	beq $t2, 0, openK
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	
	j lunghezzabuffer
	
openK:
	
	move $s0, $t1
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
	li $a2, 4				#dobbiamo mettere il caso di errore
	syscall

closeK:

 	 li  $v0, 16    			#
  	move  $a0, $t1  		 	#
  	syscall
  	


	la $t0, buffer2
	li $t1, 0

lunghezzabuffer2:

	
	lb $t2, ($t0)
	bge $t1, 128, dopo
	beq $t2, 0, dopo
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	
	j lunghezzabuffer2

dopo:

	move $s1, $t1
	la $t0, buffer2
	
sceltaalgoritmo:
	
	lb $t2, ($t0)
	ble $s1, 0, uscita			#bisogna mettere algoritmi inverso
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
	
	move $t7, $t0
	la $t0,buffer			 	#possiamo sovrascrivere t0
	
cicloA:						#	stampa il carattere aumentato di 4

	lb $t3,($t0)
	beq $t3,0,exit
	addi $t2,$t3,4
	li $t3,256				#t3 non ci serve pi√π
	div $t2,$t3				#per evitare overflow
	mfhi $t2
	sb $t2,($t0) 				#imposta il carattere  nella posizione di memoria del primo byte
	add $t0,$t0,1 				#incrementa il contatore
	
	j cicloA

algoritmoB:

	move $t7, $t0
	la $t0,buffer			 	#possiamo sovrascrivere t0
	addi $t0, $t0, 1
	
cicloB:	
					
	lb $t3,($t0)
	beq $t3,0,exit
	addi $t2,$t3,4
	li $t3,256				#t3 non ci serve piu'
	div $t2,$t3				#per evitare overflow
	mfhi $t2
	sb $t2,($t0) 				#imposta il carattere  nella posizione di memoria del primo byte
	add $t0,$t0,2				#incrementa il contatore
	
	j cicloB

algoritmoC:

	move $t7, $t0
	la $t0,buffer			 	#possiamo sovrascrivere t0

cicloC:
						#
	lb $t3,($t0)
	beq $t3,0,exit
	addi $t2,$t3,4
	li $t3,256				#t3 non ci serve piu'
	div $t2,$t3				#per evitare overflow
	mfhi $t2
	sb $t2,($t0) 				#imposta il carattere  nella posizione di memoria del primo byte
	add $t0,$t0,2				#incrementa il contatore
	
	j cicloC

algoritmoD:

	move $t7, $t0
	la $t0,buffer			 	#possiamo sovrascrivere t0

carica: 					#salva il testo nelllo stack

	lb $t1,($t0)
	addi $sp,$sp,-4 	 		# crea spazio per 1 words nello stack frame partendo dalla posizione -4
	sw $t1,0($sp)
	addi $t0,$t0,1
	bne $t1,$zero,carica 			# carica ogni bayte del testo origionale nello stack

	la $t0, buffer				#carica l'indirizzo del testo originale in t0
	addi $t0,$t0,-1

scarica: 					# inverte il testo originale della frase

	addi $sp,$sp,4
	sb $t1,($t0) 				#carica l'indirizzo del primo byte di t1 in t0
	addi $t0,$t0,1 				#somma ogni bayte di t0(t1) di per poi caricarli ed invertirli successivamente
	lw $t1,0($sp)				#prende il valore proveniente dallo stack
	bne $t1,$zero,scarica 			#controlla se il contore Ë arrivato alla posozione finale
	
	j exit

algoritmoE:






















inizio:
	la $s0,testo		#impostiamo le variabili $s0, e $s2 rispettivamente a testo e spazio
	la $s2,spazio
	move $t0, $s0		#creiamo una variable con lo stesso valore di -testo-
	li $s1, -1

conta:
	lb $t1,($t0)
	beqz $t1,prelettura
	addi $t0,$t0,1
	addi $s3,$s3,1 		#in $s3 alla fine avremo la lunghezza del testo(in termini numerici)
	j conta

spaziocarattere:
	li $t8, ' '
	sb $t8, ($s2)
	addi $s2,$s2,1
	j lettura

prelettura:
	li $t1,0 		#si resettano $t0 e $t1, cosi' che il ciclo di conta non interferisca
	move $t0, $s0

lettura:
	bge $s1,$s3,uscita
	lb $t1,($t0) 		#carico in $t1 la prima lettera del testo(f)
	move $s4,$t0 		#in $s4 mettiamo l'indirizzo della lettera che analizzeremo per poi utilizzarlo in "controllodx"
	addi $t0,$t0,1 		#contatore dell'indirizzo della lettera
	addi $s1,$s1,1 		#contatore della lettera che leggiamo
	li $t2, 0	 	#contatore che parte da 0 per il controllo a sx #####si potrebbe togliere
	move $t3, $s0 		#si resetta sempre al primo indirizzo del testo

	j controllosx

controllosx:
	bge $t2,$s1, salvalettera     #finche $t2(contatore posizione) e' minore o uguale di $s1(contatore lettera esaminata) continua ciclo
	addi $t2,$t2,1 		#contatore per il controllo a sx
	lb $t4, ($t3)		#carico in $t4 il carattere da controllare
	addi $t3,$t3,1 		#contatore per la posizione del carattere da controllare
	beq $t1,$t4, lettura	#controllo se i due caratteri sono uguali

	j controllosx

salvalettera:
	li $t3,0 		#$t3 diventa una variabile numerica uguale a 0 (non e' piu' un indirizzo)
	sb $t1, ($s2) 		#si carica la lettera non doppia nello space
	addi $s2,$s2,1		#si aumenta lo space per passare alla prossima posizione
	move $t5,$s1 		#$t5 diventa il contatore che verra' utilizzato in controllo a dx per non modificare $s1 e poterlo riutilizzare
	addi $s3,$s3,1

controllodx:
	bge $t5,$s3, spaziocarattere

	lb $t4,($s4) 		#in $t4 carichiamo la lettera da confrontare
	move $s6,$t5		#$s6 diventa il valore numerico di $t5 e lo utilizzeremo in "ciclonumero"

	addi $s4,$s4,1		#si sposta di 1 l'indirizzo della lettera a destra da confrontare
	addi $t5,$t5,1		#contatore per controllo a destra
	beq $t1,$t4, scriviposizione #se lettera non doppia e' uguale a quella che scorre a destra salva la posizione

	j controllodx

scriviposizione:
	li $t8, '-'
	sb $t8, ($s2)
	addi $s2,$s2,1
	j ciclonumero

ciclonumero:
	subi $sp,$sp, 4 	#apre uno stack
	addi $t9,$t9,1
	li $s5,10
	div $s6, $s5
	mfhi $t6
	mflo $s6
	sb $t6,0($sp)
	beq $s6,0,caricaNumero 
	j ciclonumero

caricaNumero:
	subi $t9,$t9,1
	lw $t3,0($sp)
	addi $sp,$sp,4
	addi $t3,$t3,48
	sb $t3,($s2) 		#inserisce il valore preso dallo stack come carattere in space
	addi $s2,$s2,1
	bge $t9,1,caricaNumero	#quando fa piu' di un ciclo fa il ciclo
	j controllodx




















uscita:

	li $v0, 10
	syscall




exit:

	move $t0, $t7
	addi $t0,$t0,1
	subi $s1, $s1, 1
	j sceltaalgoritmo







































errore:

	li $v0, 4
	la $a0, testo
	syscall
