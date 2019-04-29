.data
	testo: .asciiz "esempio di messaggio criptato"
	spazio: .space 256
.text
stampastringaoriginale:
	li $v0,4
	la $a0,testo
	syscall

	li $v0,11
	li $a0,'\n'
	syscall

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
	move $t5,$s1 		#$t5 diventa il contatore che verra'  utilizzato in controllo a dx per non modificare $s1 e poterlo riutilizzare
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
	beq $s6,0,caricaNumero 	#qui c'e' un errore, se e' 0 carica due volte lo 0
	j ciclonumero

caricaNumero:
	subi $t9,$t9,1
	lw $t3,0($sp)
	addi $sp,$sp,4
	addi $t3,$t3,48
	sb $t3,($s2) 		#inserisce il valore preso dallo stack come carattere in space
	addi $s2,$s2,1
	beqz $t9,caricaNumero
	addi $t5,$t5,1		####
	j controllodx

uscita:
	li $v0,4
	la $a0,spazio
	syscall

	li $v0,10
	syscall
