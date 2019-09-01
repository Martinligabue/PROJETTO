.data

testoerrorealgoritmo: .asciiz "e' stata inserita una chiave non corretta"
eroreio: .asciiz "si e' presentato un errore nell'apertura del file"
filein: .asciiz "messaggio.txt"
chiave: .asciiz "chiave.txt"
filedecifr: .asciiz "messaggioDecifrato.txt"
filecifr: .asciiz "messaggioCifrato.txt"
buffer: .space 128
buffer2: .space 4
bufferTemp: .space 256

.text
main:
		jal open

		move $s1, $t1					#salvo in $s1 e $s7 la lunghezza del testo CHIAVE
		move $s7, $t1
		la $t0, buffer2

		jal sceltaalgoritmo

		la $t0, buffer2				#salvo in $t0 il testo chiave e lo faccio partire dall'ultimo carattere
		addi $t0, $t0, 4			#parte dal 4 carattere, per poi tornare indietro nel ciclo successivo

		jal invertialgoritmi

		jal stampacriptato

		j jrra
############################################################à
open:						#apertura file

	li $v0, 13				# apriamo il file
	la $a0, filein		# nome file
	la $a1, 0					# legge e basta
	la $a2, 0					# ignorato
	syscall

	move $t0, $v0				# salvimo in t0 il descrittore del file
	blt $v0, 0, errore	#quando il descrittore e' minore di 0 significa che si e' verificato un errore

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
	bge $t1, 128, openK		#fa il ciclo finche' non si riempe il buffer
	beq $t2, 0, openK			#fa il ciclo finche' non finisce il testo
	addi $t1, $t1, 1			#contatore
	addi $t0, $t0, 1

	j lunghezzabuffer

openK:

	move $s0, $t1
	li $v0, 13				# apriamo il file chiave
	la $a0, chiave		# nome file chiave
	la $a1, 0					# legge e basta
	la $a2, 0					# ignorato
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

 	 li  $v0, 16
	 move  $a0, $t1
	 syscall
	 la $t0, buffer2
	 li $t1, 0

lunghezzabuffer2:

	lb $t2, ($t0)
	bge $t1, 128, jrra		#come prima ma con il file chiave.txt
	beq $t2, 0, dopo
	addi $t1, $t1, 1
	addi $t0, $t0, 1

	j lunghezzabuffer2

############################################################
sceltaalgoritmo:			#scorre il buffer contenente le chiavi carattere per carattere

	lb $t2, ($t0)
	ble $s1, 0, stampacriptato
	beq $t2, 'A', algoritmoA
	beq $t2, 'B', algoritmoB
	beq $t2, 'C', algoritmoC
	beq $t2, 'D', algoritmoD
	beq $t2, 'E', algoritmoE

	li $v0, 4
	la $a0, testoerrorealgoritmo
	syscall

	j jrra

	############################################################
preinverti:
	jr $ra

invertialgoritmi:					#scorre il buffer contenente le chiavi in ordine inverso carattere per carattere

	lb $t2, ($t0)
	ble $s7, 0, stampadecriptato			#da impostare il metodo fine per far terminare il programma
	beq $t2, 'A', invertialgoritmoA		#jal
	beq $t2, 'B', invertialgoritmoB
	beq $t2, 'C', invertialgoritmoC
	beq $t2, 'D', invertialgoritmoD
	beq $t2, 'E', invertialgoritmoE

	addi $t0, $t0, -1

	j invertialgoritmi

algoritmoA:

	move $t7, $t0					#salva il valore di t0 in t7, per ripristinarlo in seguito
	la $t0, buffer			 	#possiamo sovrascrivere t0

cicloA:						#	stampa il carattere aumentato di 4

	lb $t3,($t0)
	beq $t3,0,exit
	addi $t2,$t3,4
	li $t3,256				#ci serve il valore 256
	div $t2,$t3				#per evitare overflow
	mfhi $t2					#prende il numero senza overflow
	sb $t2,($t0) 				#imposta il carattere  nella posizione di memoria del primo byte
	add $t0,$t0,1 				#incrementa il contatore

	j cicloA

algoritmoB:

	move $t7, $t0
	la $t0,buffer			 	#possiamo sovrascrivere t0
	addi $t0, $t0, 1		#per partire dal secondo carattere

cicloB:

	lb $t3,($t0)
	beq $t3,0,exit
	addi $t2,$t3,4
	li $t3,256					#t3 non ci serve piu'
	div $t2,$t3					#per evitare overflow
	mfhi $t2
	sb $t2,($t0) 				#imposta il carattere nella posizione di memoria del primo byte
	add $t0,$t0,2				#incrementa il contatore di due

	j cicloB

algoritmoC:

	move $t7, $t0
	la $t0,buffer			 	#possiamo sovrascrivere t0

cicloC:

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
	la $t0, buffer			 	#possiamo sovrascrivere t0

carica: 					#salva il testo nello stack

	lb $t1,($t0)
	addi $sp,$sp,-4 	 		# crea spazio per 1 words nello stack frame partendo dalla posizione -4
	sw $t1,0($sp)
	addi $t0,$t0,1
	bne $t1,$zero,carica 			# carica ogni byte del testo origionale nello stack

	la $t0, buffer				#carica l'indirizzo del testo originale in t0
	addi $t0,$t0,-1

scarica: 					# inverte il testo originale della frase

	addi $sp,$sp,4
	sb $t1,($t0) 				#carica l'indirizzo del primo byte di t1 in t0
	addi $t0,$t0,1 				#somma ogni bayte di t0(t1) di per poi caricarli ed invertirli successivamente
	lw $t1,0($sp)				#prende il valore proveniente dallo stack
	bne $t1,$zero,scarica 			#controlla se il contore e' arrivato alla posizione finale
	##################aggiornare con indirizzo invece che zero

	j exit

algoritmoE:

salvaStack:

	addi $sp,$sp,-12
	sw $t0,0($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	move $s3,$s0 				#imposta a $s3 la lunghezza di buffer

resetValori:

	li $t0,0
	li $t9,0
	li $s1,0

inizio:

	la $s0,buffer				#impostiamo le variabili $s0, e $s2 rispettivamente a testo e spazio
	la $s2,bufferTemp			#da impostare con un buffer temporaneo
	move $t0, $s0				#creiamo una variable con lo stesso valore di -testo-
	li $s1, -1

spaziocarattere:

	li $t8, ' '
	sb $t8, ($s2)
	addi $s2,$s2,1
	j lettura

prelettura:

	li $t1,0 				#si resettano $t0 e $t1, cosi' che il ciclo di conta non interferisca
	move $t0, $s0

lettura:

	bge $s1,$s3,ripristinaStack
	lb $t1,($t0) 				#carico in $t1 la prima lettera del testo(f)
	move $s4,$t0 				#in $s4 mettiamo l'indirizzo della lettera che analizzeremo per poi utilizzarlo in "controllodx"
	addi $t0,$t0,1 				#contatore dell'indirizzo della lettera
	addi $s1,$s1,1 				#contatore della lettera che leggiamo
	li $t2, 0	 			#contatore che parte da 0 per il controllo a sx####forse, se abbiamo voglia, lo mettiamo nel resetta
	move $t3, $s0 				#si resetta sempre al primo indirizzo del testo

	j controllosx

controllosx:

	bge $t2,$s1, salvalettera     		#finche $t2(contatore posizione) e' minore o uguale di $s1(contatore lettera esaminata) continua ciclo
	addi $t2,$t2,1 				#contatore per il controllo a sx
	lb $t4, ($t3)				#carico in $t4 il carattere da controllare
	addi $t3,$t3,1 				#contatore per la posizione del carattere da controllare
	beq $t1,$t4, lettura			#controllo se i due caratteri sono uguali

	j controllosx

salvalettera:


	sb $t1, ($s2) 				#si carica la lettera non doppia nello space
	addi $s2,$s2,1				#si aumenta lo space per passare alla prossima posizione
	move $t5,$s1 				#$t5 diventa il contatore che verra' utilizzato in controllo a dx per non modificare $s1 e poterlo riutilizzare

controllodx:

	bge $t5,$s3, spaziocarattere

	lb $t4,($s4) 				#in $t4 carichiamo la lettera da confrontare
	move $s6,$t5				#$s6 diventa il valore numerico di $t5 e lo utilizzeremo in "ciclonumero"

	addi $s4,$s4,1				#si sposta di 1 l'indirizzo della lettera a destra da confrontare
	addi $t5,$t5,1				#contatore per controllo a destra
	beq $t1,$t4, scriviposizione	 	#se lettera non doppia e' uguale a quella che scorre a destra salva la posizione

	j controllodx

scriviposizione:

	li $t8, '-'
	sb $t8, ($s2)
	addi $s2,$s2,1
	j ciclonumero

ciclonumero:

	addi $sp,$sp, -4 			#apre uno stack
	addi $t9,$t9,1
	li $s5,10
	div $s6, $s5
	mfhi $t6
	mflo $s6
	sb $t6,0($sp)
	beq $s6,0,caricaNumero
	j ciclonumero

caricaNumero:

	addi $t9,$t9,-1
	lw $t3,0($sp)
	addi $sp,$sp,4
	addi $t3,$t3,48
	sb $t3,($s2) 				#inserisce il valore preso dallo stack come carattere in space
	addi $s2,$s2,1
	bge $t9,1,caricaNumero			#quando fa piu' di un ciclo fa il ciclo
	j controllodx

ripristinaStack:

	li $t0,0
	la $t1,buffer 				#posizione nel buffer temp
	la $t2,bufferTemp
	addi $t2, $t2, 1

cicloripristina:			#copia nel buffer

	addi $t0, $t0, 1
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	lb $t3,($t2)
	sb $t3,($t1)
	ble $t0,126,cicloripristina

	lw $t0, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12

	addi $t0,$t0,1
	addi $s1, $s1, -1

	j sceltaalgoritmo

invertialgoritmoA:

	move $t7, $t0
	li $t4,256
	la $t0, buffer

cicloinvA:

	lb $t3, ($t0)
	beq $t3, 0, exitinvertito
	addi $t2, $t3, -4			#toglie 4 posizioni all'ascii
	addi $t2, $t2, 256			#aggiunge 256 per evitare l'underflow in caso di file danneggiato
	div $t2, $t4
	mfhi $t2
	sb $t2, ($t0)				#imposta la lettera nella posizione di memoria del primo byte
	add $t0, $t0, 1				#incrementa il contatore

	j cicloinvA

invertialgoritmoB:

	move $t7, $t0
	li $t4,256
	la $t0, buffer
	addi $t0, $t0, 1

cicloinvB:

	lb $t3, ($t0)
	beq $t3, 0, exitinvertito
	addi $t2, $t3, -4			#toglie 4 posizioni all'ascii
	div $t2, $t4
	mfhi $t2
	sb $t2, ($t0)				#imposta la lettera nella posizione di memoria del primo byte
	add $t0, $t0, 2				#incrementa il contatore

	j cicloinvB

invertialgoritmoC:

	move $t7, $t0
	li $t4,256
	la $t0, buffer

cicloinvC:

	lb $t3, ($t0)
	beq $t3, 0, exitinvertito
	addi $t2, $t3, -4			#toglie 4 posizioni all'ascii
	div $t2, $t4
	mfhi $t2
	sb $t2, ($t0)				#imposta la lettera nella posizione di memoria del primo byte
	add $t0, $t0, 2				#incrementa il contatore

	j cicloinvC


invertialgoritmoD:

	move $t7, $t0
	la $t0,buffer			 	#possiamo sovrascrivere t0

caricainv: 					#salva il testo nelllo stack

	lb $t1,($t0)
	addi $sp,$sp,-4 	 		# crea spazio per 1 words nello stack frame partendo dalla posizione -4
	sw $t1,0($sp)
	addi $t0,$t0,1
	bne $t1,$zero,caricainv 		# carica ogni byte del testo origionale nello stack

	la $t0, buffer				#carica l'indirizzo del testo originale in t0
	addi $t0,$t0,-1

scaricainv: 					# inverte il testo originale della frase

	addi $sp,$sp,4
	sb $t1,($t0) 				#carica l'indirizzo del primo byte di t1 in t0
	addi $t0,$t0,1 				#somma ogni bayte di t0(t1) di per poi caricarli ed invertirli successivamente
	lw $t1,0($sp)				#prende il valore proveniente dallo stack
	bne $t1,$zero,scaricainv 		#controlla se il contore e' arrivato alla posozione finale

	j exitinvertito

invertialgoritmoE:
salvaStackinv:

	addi $sp,$sp,-16
	sw $t0,0($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	move $s3,$s0 				#imposta a $s3 la lunghezza di buffer

resetValoriinv:

	li $t0,0
	li $s0,0
	li $s1,0
	li $s3,0

	la $s0, buffer


salvaletterainv:				#ciclo grande, da cambiare di nome

	lb $s1,($s0)				#salviamo in s1 la lettera
	addi $s0,$s0,1
	lb $t0,($s0)
	bne $t0,'-',exitE
	addi $s0,$s0,1

	j leggesalvanumeroinv

leggesalvanumeroinv:

	lb $s2,($s0)				#salviamo in s2 il primo numero
	addi $s2,$s2,-48

	j controllonumeroinv

controllonumeroinv:

	addi $s0,$s0,1
	lb $t0,($s0)
	beq $t0,'-',convertepriminv
	beq $t0,' ',convertesecinv
	beq $t0,0,convertesecinv
	addi $t0,$t0,-48
	move $t2,$t0
	mul $s2,$s2,10
	add $s2,$s2,$t2


	j controllonumeroinv

uguaglia1:

	move $s3, $s2

	j f

uguaglia2:

	move $s3, $s2

	j f2

convertepriminv:

	bge $s2, $s3, uguaglia1

f:
	                                     	#t1 uguale a s2
	la $t1, bufferTemp 			#salviamo in t1 il buffer per poterci salvare la roba dentro
	add $t1,$t1,$s2
	sb $s1,($t1)
	addi $s0,$s0,1

	j leggesalvanumeroinv

convertesecinv:

	bge $s2, $s3, uguaglia2

f2:

	la $t1,bufferTemp 			#salviamo in t1 il buffer per poterci salvare la roba dentro
	add $t1,$t1,$s2
	sb $s1,($t1)
	addi $s0,$s0,1

	j salvaletterainv

exitE:

	li $t0, 0
	la $t1,buffer 				#reset di t1 all'indirizzo del buffer temp
	la $t2,bufferTemp

cicloripristinainv:

	addi $t0, $t0, 1
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	lb $t3,($t2)
	sb $t3,($t1)
	bgt $s3, $t0, cicloripristinainv	#copia solo fino la parte contenente effettivamente il testo

pulibuffer:

	li $t2, 0
	addi $t0, $t0, 1
	bge $t0,126, vaigiu		#quando il buffer e' finito esce
	addi $t1, $t1, 1
	sb $t2, ($t1)					#pulisce le posizioni da s3 alla fine del buffer

	j pulibuffer

vaigiu:

	lw $t0, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12

	addi $t0,$t0,-1
	addi $s7, $s7, -1

	j invertialgoritmi
############################################################
stampacriptato:

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

	j preinverti

stampadecriptato:

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

	j jrra
############################################################
salvaStack: #228

	addi $sp,$sp,-12
	sw $t0,0($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)

ripristinaStack: ####??????
	lw...
	addi $sp,$sp,12

exit:

	move $t0, $t7			#esce dall'algoritmo
	addi $t0,$t0, 1
	addi $s1, $s1, -1

	j sceltaalgoritmo

exitinvertito:

	move $t0, $t7			#esce dall'algoritmo invertito
	addi $t0, $t0, -1
	addi $s7, $s7, -1

	j invertialgoritmi

errore:

	li $v0, 4
	la $a0, eroreio
	syscall
	j jrra

	jr $ra
	jrra:
		jr $ra
