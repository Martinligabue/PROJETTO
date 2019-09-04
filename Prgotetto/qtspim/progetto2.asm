.data
fnf:	.asciiz "File non trovato"
ftl:	.asciiz	"Il file e' diventato troppo lungo"

file:	.asciiz	"messaggio.txt"
chiave: .asciiz "chiave.txt"
fileO:	.asciiz	"messaggioCifrato.txt"
fileO2:	.asciiz "messaggioDecifrato.txt"

buffer: .space 128
buffer_chiave:	.space  4

array: 	.space 128
.text

.globl main 
main:
	la	$s7, array

	jal	apri_chiave
	jal	leggi_chiave
	move	$s0, $a1	# $s0 = indirizzo della chiave
	
	jal	apri
	jal	leggi
	move	$s1, $a1	# $s1 = indirizzo del messaggio
	move	$s6, $v0	# $s6 = lunghezza del messaggio
	
	jal	chiudi	
	
	jal 	switch_cript
	jal	stampa_cifrato
	
	jal	switch_decript
	jal	stampa_decifrato
	
	jal	chiudi
	jal	fine
	
# Switch per criptare
switch_cript:
	addi	$sp, $sp, -4	# Alloco spazio nello stack per salvare $ra
	sw	$ra, 0($sp)	# Salvo $ra nello stack
loop_cript:		
	beq 	$s2, 4, exit_sw	# $t0 = indice ciclo switch, itera finchè è minore (quindi diverso) di 4
	lb 	$t1, 0($s0)	# $t1 = carattere i-esimo della chave
	ble	$t1, 69, check	
	subi	$t1, $t1, 32	# Se $t1 è maggiore di 69 (codice ASCII per E), allora viene sottratto 32, in modo da ottenere solo lettere maiuscole
check:	
	bne	$t1, 65, skipA	# Se $t1 != 65 (codice ASCII per A), allora si salta la chiamata all'algoritmo A
	jal 	algoritmoA	# Si salta all'algoritmo A	
	jal	indici
	j	loop_cript	# Si torna all'inizio del ciclo
skipA:
	bne	$t1, 66, skipB	# Se $t1 != 66 (codice ASCII per B), allora si salta la chiamata all'algoritmo B
	jal 	algoritmoB	# Si salta all'algoritmo B
	jal	indici
	j	loop_cript	# Si torna all'inizio del ciclo
skipB:
	bne	$t1, 67, skipC	# Se $t1 != 67 (codice ASCII per C), allora si salta la chiamata all'algoritmo C
	jal 	algoritmoC	# Si salta all'algoritmo C
	jal	indici
	j	loop_cript	# Si torna all'inizio del ciclo
skipC:
	bne	$t1, 68, skipD	# Se $t1 != 68 (codice ASCII per D), allora si salta la chiamata all'algoritmo D
	jal 	algoritmoD	# Si salta all'algoritmo D+
	jal	indici
	j	loop_cript	# Si torna all'inizio del ciclo
skipD:
	bne	$t1, 69, skipE	# Se $t1 != 69 (codice ASCII per E), allora si salta la chiamata all'algoritmo E
	jal 	algoritmoE	# Si salta all'algoritmo E
	jal	indici
	j	loop_cript	# Si torna all'inizio del ciclo
skipE:
	jal	indici
	j	loop_cript	# Si torna all'inizio del ciclo
exit_sw:
	lw	$ra, 0($sp)	# Ripristino l'indirizzo di $ra
	addi	$sp, $sp, 4	# Disalloco lo spazio nello stack
	jr 	$ra		# Si esce dalla procedura

# Incremento indici criptatore
indici:
	addi	$s0, $s0, 1	# Si incrementa di 1 la posizione corrente della chiave
	addi	$s2, $s2, 1	# $s2 ++
	jr	$ra		

# Switch per decriptare
switch_decript:
	addi	$sp, $sp, -4	# Alloco spazio nello stack per salvare $ra
	sw	$ra, 0($sp)	# Salvo $ra nello stack
	
	move	$s2, $zero	# $s2 = 0, così può essere riutilizzato come indice
loop_d:	beq	$s2, 4, exit_swd	# $s2 = indice ciclo switch, itera finchè è minore (quindi diverso) di 4
	subi	$s0, $s0, 1	# Si decrementa di 1 la posizione corrente della chiave
	lb	$t1, 0($s0)	# $t1 = carattere (4-i)-esimo della chiave
	ble	$t1, 69, checkD	
	subi	$t1, $t1, 32	# Se $t1 è maggiore di 69 (codice ASCII per E), allora viene sottratto 32, in modo da ottenere solo lettere maiuscole
checkD:	
	bne 	$t1, 65, skipAD	# Se $t1 != 65 (codice ASCII per A), allora si salta la chiamata all'inverso di A
	jal 	reverseA	# Si salta all'inverso di A
	jal 	indici_de
	j	loop_d		# Si torna all'inizio del ciclo
skipAD:
	bne 	$t1, 66, skipBD	# Se $t1 != 66 (codice ASCII per B), allora si salta la chiamata all'inverso di B
	jal 	reverseB	# Si salta all'inverso di 
	jal 	indici_de
	j	loop_d		# Si torna all'inizio del ciclo
skipBD:
	bne 	$t1, 67, skipCD	# Se $t1 != 67 (codice ASCII per C), allora si salta la chiamata all'inverso di C
	jal 	reverseC	# Si salta all'inverso di C
	jal 	indici_de
	j	loop_d		# Si torna all'inizio del ciclo
skipCD:	
	bne 	$t1, 68, skipDD	# Se $t1 != 68 (codice ASCII per D), allora si salta la chiamata all'inverso di D (ovvero se stesso)
	jal 	algoritmoD	# Si salta all'inverso di D
	jal 	indici_de
	j	loop_d		# Si torna all'inizio del ciclo
skipDD:	
	bne 	$t1, 69, skipED	# Se $t1 != 69 (codice ASCII per E), allora si salta la chiamata all'inverso di E
	jal 	reverseE	# Si salta all'inverso di E
	jal 	indici_de
	j	loop_d		# Si torna all'inizio del ciclo
skipED:
	jal 	indici_de
	j	loop_d		# Si torna all'inizio del ciclo
exit_swd:
	lw	$ra, 0($sp)	# Ripristino l'indirizzo di $ra
	addi	$sp, $sp, 4	# Disalloco lo spazio nello stack
	jr	$ra

# Incremento indici decriptatore
indici_de:
	addi	$s2, $s2, 1	# $s2 ++
	jr	$ra

# Algoritmo A
algoritmoA:
	addi	$sp, $sp, -8	# Alloco lo spazio nello stack
	sw	$s1, 0($sp)	# Salvo il valore di $s1 nello stack
	sw	$ra, 4($sp)	# Salvo il valore di $ra nello stack 
	
	move 	$t1, $zero	# $t1 = 0, indice del ciclo
loopA:	beq 	$t1, $s6, exitA	# Finchè $t1 è minore (quindi diverso) di $s6 il ciclo itera
	jal 	incremento	# Si chiama la procedura "incremento"
	addi	$s1, $s1, 1	# $s1 ++, incremento della posizione del byte da criptare
	addi 	$t1, $t1, 1	# $t1 ++
	j 	loopA		# Si torna all'inizio del ciclo
exitA:	
	lw	$ra, 4($sp)	# Si ripristina l'indirrizzo di $ra
	lw	$s1, 0($sp)	# Si ripristina il valore di $s1
	addi	$sp, $sp, 8	# Disalloco lo spazio nello stack
	jr 	$ra		# Si esce dalla procedura

# Inverso A
reverseA:
	addi	$sp, $sp, -8	# Alloco lo spazio nello stack
	sw	$s1, 0($sp)	# Salvo il valore di $s1 nello stack
	sw	$ra, 4($sp)	# Salvo il valore di $ra nello stack 
	
	move 	$t1, $zero	# $t1 = 0, indice del ciclo
loopRA:	beq 	$t1, $s6, exitRA# Finchè $t1 è minore (quindi diverso) di $s6 il ciclo itera
	jal 	decremento	# Si chiama la procedura "incremento"
	addi	$s1, $s1, 1	# $s1 ++, incremento della posizione del byte da decriptare
	addi 	$t1, $t1, 1	# $t1 ++
	j 	loopRA		# Si torna all'inizio del ciclo
exitRA:
	lw	$ra, 4($sp)	# Si ripristina l'indirrizzo di $ra
	lw	$s1, 0($sp)	# Si ripristina il valore di $s1
	addi	$sp, $sp, 8	# Disalloco lo spazio nello stack
	jr 	$ra			# Si esce dalla procedura

# Algoritmo B
algoritmoB:
	addi	$sp, $sp, -8	# Alloco lo spazio nello stack
	sw	$s1, 0($sp)	# Salvo il valore di $s1 nello stack
	sw	$ra, 4($sp)	# Salvo il valore di $ra nello stack 
	
	move 	$t1, $zero	# $t1 = 0, indice del ciclo
loopB:	bge	$t1, $s6, exitB	# Finchè $t1 è minore (quindi diverso) di $s6 il ciclo itera
	jal 	incremento	# Si chiama la procedura "incremento"
	addi	$s1, $s1, 2	# $s1 = $t0 + 2, si incrementa di 2 partendo dalla posizione 0 così da criptare solo i byte di indice pari
	addi	$t1, $t1, 2	# $t1 = $t1 + 2
	j 	loopB		# Si torna all'inizio del ciclo
exitB:
	lw	$ra, 4($sp)	# Si ripristina l'indirrizzo di $ra
	lw	$s1, 0($sp)	# Si ripristina il valore di $s1
	addi	$sp, $sp, 8	# Disalloco lo spazio nello stack
	jr $ra			# Si esce dalla procedura
	
# Inverso B
reverseB:
	addi	$sp, $sp, -8	# Alloco lo spazio nello stack
	sw	$s1, 0($sp)	# Salvo il valore di $s1 nello stack
	sw	$ra, 4($sp)	# Salvo il valore di $ra nello stack 
	
	move 	$t1, $zero	# $t1 = 0, indice del ciclo
loopRB:	bge	$t1, $s6, exitRB# Finchè $t1 è minore di $s6 il ciclo itera
	jal 	decremento	# Si chiama la procedura "decremento"
	addi	$s1, $s1, 2	# $s1 = $t0 + 2, si incrementa di 2 partendo dalla posizione 0 così da decriptare solo i byte di indice pari
	addi	$t1, $t1, 2	# $t1 = $t1 + 2
	j 	loopRB		# Si torna all'inizio del ciclo
exitRB:
	lw	$ra, 4($sp)	# Si ripristina l'indirrizzo di $ra
	lw	$s1, 0($sp)	# Si ripristina il valore di $s1
	addi	$sp, $sp, 8	# Disalloco lo spazio nello stack
	jr $ra			# Si esce dalla procedura
	
# Algoritmo C
algoritmoC:
	addi	$sp, $sp, -8	# Alloco lo spazio nello stack
	sw	$s1, 0($sp)	# Salvo il valore di $s1 nello stack
	sw	$ra, 4($sp)	# Salvo il valore di $ra nello stack 
	
	addi	$s1, $s1, 1	# $s1 ++, così da partire dalla prima posizione dispari
	move 	$t1, $zero	# $t1 = 0, indice del ciclo
	addi	$t1, $t1, 1	# $t1 ++, così da iterare il numero corretto di volte
loopC:	bge	$t1, $s6, exitC	# Finchè $t1 è minore di $s6 il ciclo itera
	jal 	incremento	# Si chiama la procedura "incremento"
	addi	$s1, $s1, 2	# $s1 = $s1 + 2, si incrementa di 2 partendo dalla posizione 1 così da criptare solo i byte di indice dispari
	addi	$t1, $t1, 2	# $t1 = $t1 + 2
	j 	loopC		# Si torna all'inizio del ciclo
exitC:
	lw	$ra, 4($sp)	# Si ripristina l'indirrizzo di $ra
	lw	$s1, 0($sp)	# Si ripristina il valore di $s1
	addi	$sp, $sp, 8	# Disalloco lo spazio nello stack
	jr $ra			# Si esce dalla procedura
	
# Inverso C
reverseC:
	addi	$sp, $sp, -8	# Alloco lo spazio nello stack
	sw	$s1, 0($sp)	# Salvo il valore di $s1 nello stack
	sw	$ra, 4($sp)	# Salvo il valore di $ra nello stack 
	
	addi	$s1, $s1, 1	# $s1 ++, così da partire dalla prima posizione dispari
	move 	$t1, $zero	# $t1 = 0, indice del ciclo
	addi 	$t1, $t1, 1	# $t1 ++, così da iterare il numero corretto di volte
loopRC:	bge	$t1, $s6, exitRC# Finchè $t1 è minore di $s6 il ciclo itera
	jal 	decremento	# Si chiama la procedura "decremento"
	addi	$s1, $s1, 2	# $s1 = $s1 + 2, si incrementa di 2 partendo dalla posizione 1 così da decriptare solo i byte di indice dispari
	addi	$t1, $t1, 2	# $t1 = $t1 + 2
	j 	loopRC		# Si torna all'inizio del ciclo
exitRC:
	lw	$ra, 4($sp)	# Si ripristina l'indirrizzo di $ra
	lw	$s1, 0($sp)	# Si ripristina il valore di $s1
	addi	$sp, $sp, 8	# Disalloco lo spazio nello stack
	jr $ra			# Si esce dalla procedura

# Algoritmo D, autoinvertibile
algoritmoD:
	addi	$sp, $sp, -4	# Alloco lo spazio nello stack
	sw	$s1, 0($sp)	# Salvo il valore di $s1 nello stack
	
 	move	$t1, $s1	# $t1 = puntatore alla coda del messaggio
 	add 	$t1, $t1, $s6	# $t1 = $t1 + $s6 (lunghezza del messaggio)
 	subi 	$t1, $t1, 1	# $t1 --, altrimenti va in overflow
 	
 	move	$t2, $zero	# $t2 = 0, indice del ciclo
 	div 	$t3, $s6, 2 	# $t3 = lunghezza del messaggio / 2 (sarà la lunghezza del ciclo)
loopD:	beq 	$t2, $t3, exitD	# Finchè $t2 è minore (quindi diverso) di $t3 il ciclo itera
 	lb 	$t4, 0($s1)	# $t4 = byte in testa, da scambiare con quello in coda
 	lb 	$t5, 0($t1)	# $t5 = byte in coda, da scambiare con quello in testa
	sb  	$t4, 0($t1)	# Coda del messaggio = byte in testa
	sb	$t5, 0($s1)	# Testa del messaggio = byte in coda
	addi	$s1, $s1, 1	# Si aggiorna la testa del messaggio
	subi	$t1, $t1, 1	# Si aggiorna la coda del messaggio
	addi 	$t2, $t2, 1	# Si incrementa l'indice del ciclo
 	j 	loopD		# Si torna all'inizio del ciclo
exitD:
	lw	$s1, 0($sp)	# Si ripristina il valore di $s1
	addi	$sp, $sp, 4	# Disalloco lo spazio nello stack
 	jr $ra			# Si esce dalla procedura
	
# Algoritmo E
algoritmoE:
	addi	$sp, $sp, -12
	sw	$s7, 0($sp)
	sw	$ra, 4($sp)
	sw	$s1, 8($sp)
	
	li	$t9, 45		# $t9 = '-' (codice ASCII 45)
	li	$t8, 10		# $t8 = 10, divisore
	move 	$t0, $zero	# $t0 = 0, indice del ciclo_2
	move	$t2, $zero	# $t2 = 0, indice cel ciclo_1
	move	$t5, $zero	# $t5 = 0, indice per la conta delle cifre della posizione
ciclo_2:	
	bge	$t0, $s6,fine_2	# $t0 = indice, finchè è minore (quindi divero) di $s6 il ciclo itera
	la	$t4, buffer	# Secondo puntatore al messaggio
	move	$t5, $zero	# $t5 = 0, azzeramento
	lb	$t1, 0($s1)	# $t1 = carattere i-esimo del messaggio
	move	$t2, $zero	# $t2 = 0, azzeramento
ciclo_1:
	beq	$t2, $s6,fine_1	# $t2 = indice, finchè è minore (quindi divero) di $s6 il ciclo itera
	lb	$t3, 0($t4)	# $t3 = carattere da confrontare con $t1
	bne	$t1, $t3, falso	# Se $t1 != $t3, allora si va alla fine del ciclo
	blt	$t2, $t0,fine_1b# Se $t2 < $t0, allora la lettera i-esima è un doppione di una lettera precedente, quindi si salta alla fine del ciclo
	bne	$t2, $t0, jump	# Se $t2 != $t0, allora deve essere che $t2 > $t0, quindi salto l'aggiunta della lettera, che è stata aggiunta qaundo $t2 == $t0
	sb	$t1, 0($s7)	# Si nserisce il caratttere i-esimo nell'array
	addi 	$s7, $s7, 1	# Si incrementa il puntatore alla testa dell'array
jump:
	sb	$t9, 0($s7)	# Si inserisce '-' nell'array
	addi	$s7, $s7, 1	# Si incrementa il puntatore alla testa dell'array
	
	addi	$sp, $sp, -4	# Alloco lo spazio nello stack
	sw	$t2, 0($sp)	# Salvo il valore di $t2 (indice del ciclo) nello stack
	move	$t5, $zero	# $t5 = 0, azzeramento
divisione:	
	div	$t2, $t8	# $t2 / $t8, serve per calcolare cle cifre della posizione separatamente
	mfhi	$t2		# $t2 = resto della divisione	
	addi	$t2, $t2, 48	# $t2 = $t2 + 48, in modo da diventare un carattere ASCII corrispondente ad una cifra da 0 a 9 (codice ASCII da 48 a 57)
	addi	$sp, $sp, -4	# Alloco lo spazio nello stack
	sb	$t2, 0($sp)	# Salvo il valore di $t2 (cifra della posizione) nello stack
	mflo	$t2		# $t2 = quoziente della divisione
	addi	$t5, $t5, 1	# $t5 ++, conta-cifre della posizione
	bne	$t2, $zero, divisione	# Finchè $t2 (quoziente) != 0, il procdedimento si ripete
numero:	
	beq	$t2, $t5, no_numero	# Finchè $t2 (indice provvisorio) minore (quindi diverso) di $t5, si estrae una nuova cifra dallo stack
	lb	$t6, 0($sp)	# Estrazione cifra dallo stack
	addi	$sp, $sp, 4	# Disalloco lo spazio nello stack
	sb	$t6, 0($s7)	# Si inserisce la cifra nell'array (dalla più significativa a quella meno)
	addi	$s7, $s7, 1	# Si incrementa il puntatore alla testa dell'array
	addi	$t2, $t2, 1	# $t2 ++
	j 	numero		# Si salta all'inizio del sotto-ciclo
no_numero:	
	lw	$t2, 0($sp)	# Si ripristina il valore di $t2 (indice ciclo_1)
	addi	$sp, $sp, 4	# Disalloco lo spazio nello stack
falso:
	addi	$t2, $t2, 1	# $t2 ++
	addi	$t4, $t4, 1	# Si aggiorna il secondo puntatore al messaggio
	j 	ciclo_1		# Si salta all'inizio del ciclo
fine_1:	
	addi 	$s7, $s7, 1	# Si incrementa il puntatore alla testa dell'array
fine_1b:
	addi	$t0, $t0, 1	# $t0 ++
	addi	$s1, $s1, 1	# Si aggiorna il primo puntatore al messaggio
	j	ciclo_2		# Si salta all'inizio del ciclo
fine_2:
	move	$s1, $s7	# $s1 = puntatore alla coda dell'array
	lw	$s7, 0($sp)
	
	move	$a0, $s6
	jal	svuota_buffer
	sub	$s6, $s1, $s7	# $s6 = nuova lunghezza del messaggio
	addi	$s6, $s6, -1
	bgt	$s6, 128, err_lung
	move	$a0, $s6
	jal	copia
	move	$a0, $s6
	jal	svuota_array
	
	lw	$s1, 8($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 12
	jr	$ra		# Si esce dalla procedura
	
# Svuota buffer
svuota_buffer:
	la	$t0, buffer
	move	$t1, $zero
	move	$t2, $zero
loop_buffer:
	beq	$t1, $a0, svuotato_b
	sb	$t2, 0($t0)
	addi	$t0, $t0, 1
	addi	$t1, $t1, 1
	j	loop_buffer
svuotato_b:
	jr	$ra

# Copia l'array nel buffer
copia:
	la	$t0, buffer
	la	$t1, array
	move	$t2, $zero
loop_copia:
	beq	$t2, $a0, copiato
	lb	$t3, 0($t1)
	sb	$t3, 0($t0)
	addi	$t0, $t0, 1
	addi	$t1, $t1, 1
	addi	$t2, $t2, 1
	j	loop_copia
copiato:
	jr	$ra
	
# Svuota array
svuota_array:
	la	$t0, array
	move	$t1, $zero
	move	$t2, $zero
loop_array:
	beq	$t1, $a0, svuotato_a
	sb	$t2, 0($t0)
	addi	$t0, $t0, 1
	addi	$t1, $t1, 1
	j	loop_array
svuotato_a:
	jr	$ra
	
# Inverso E
reverseE:
	addi	$sp, $sp, -8
	sw	$ra, 0($sp)
	sw	$s1, 4($sp)
	
	la	$t4, array	# $t4 = putatore alla testa dell'array
	li	$t9, 45		# $t9 = '-', codice ASCII 45
	move	$t0, $zero	# $t0 = 0, indice del ciclo
	move	$s3, $zero	
ciclo_2R:
	bge	$t0, $s6,fine_2R	# $t0 = indice, finchè è minore (quindi divero) di $s6 il ciclo itera
	lb	$t1, 0($s1)	# $t1 = lettera da scrivere nelle posizioni del messaggio
	addi	$s1, $s1, 1
	addi	$t0, $t0, 1
ciclo_1R:
	lb	$t5, 0($s1)	# $t5 = carattere i-esimo del messaggio
	beq	$t5, $t9, incr
	move	$t6, $zero
	move	$t7, $zero
	addi	$sp, $sp, -4	# Alloco lo spazio nello stack
	subi	$t5, $t5, 48
	sw	$t5, 0($sp)
	addi	$t6, $t6, 1
numero_R:
	addi	$s1, $s1, 1
	addi	$t0, $t0, 1
	lb	$t5, 0($s1)
	blt	$t5, 48, multi_R
	bgt	$t5, 57, multi_R
	addi	$sp, $sp, -4	# Alloco lo spazio nello stack
	subi	$t5, $t5, 48
	sw	$t5, 0($sp)
	addi	$t6, $t6, 1
	j	numero_R
multi_R:
	beq	$t7, $t6, posizionamento
	beq	$t7, 0, per1
	beq	$t7, 1, per10
	beq	$t7, 2, per100
per1:
	lw	$t5, 0($sp)
	addi	$sp, $sp, 4	# Disalloco lo spazio nello stack
	j	fine_multi
per10:	
	move	$t8, $t5
	lw	$t5, 0($sp)
	addi	$sp, $sp, 4	# Disalloco lo spazio nello stack
	mul	$t5, $t5, 10
	add	$t5, $t5, $t8
	j	fine_multi
per100:
	move	$t8, $t5
	lw	$t5, 0($sp)
	addi	$sp, $sp, 4	# Disalloco lo spazio nello stack
	mul	$t5, $t5, 100
	add	$t5, $t5, $t8
	j	fine_multi
fine_multi:
	addi	$t7, $t7, 1
	j	multi_R
posizionamento:
	addi	$sp, $sp, -4	# Alloco lo spazio nello stack
	sw	$t4, 0($sp)
	add 	$t4, $t4, $t5
	sb	$t1, 0($t4)
	lw	$t4, 0($sp)
	addi	$s3, $s3, 1
	addi	$sp, $sp, 4	# Disalloco lo spazio nello stack
	j	controllo
incr:
	addi	$s1, $s1, 1
	addi	$t0, $t0, 1
	j	ciclo_1R
controllo:
	lb	$t5, 0($s1)
	beq	$t5, $t9, incr
	addi	$s1, $s1, 1
	addi	$t0, $t0, 1
	j	ciclo_2R
fine_2R:
	move	$a0, $s6
	jal	svuota_buffer
	move	$s6, $s3
	move	$a0, $s6
	jal	copia
	move	$a0, $s6
	jal	svuota_array
	
	lw	$s1, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 8
	jr	$ra		# Si esce dalla procedura
	
# Incremento di 4
incremento:
	lb 	$t3, 0($s1)	# $t3 = byte da incrementare
	addi	$t3, $t3, 4	# Si aumenta di 4 il valore ASCII del byte
	sb	$t3, 0($s1)	# Si sovrascrive il byte in prima posizione
	jr 	$ra		# Si esce dalla procedura

# Decremento di 4
decremento:
	lb 	$t3, 0($s1)	# $t3 = byte da decrementare
	subi	$t3, $t3, 4	# Si diminuisce di 4 il valore ASCII del byte
	sb	$t3, 0($s1)	# Si sovrascrive il byte in prima posizione
	jr 	$ra		# Si esce dalla procedura

# Apri "messaggio.txt"
apri:
	li	$v0, 13		# $v0 = 13, codice apertura file per syscall
	la	$a0, file	# $a0 = "messaggio.txt", file da aprire
	li	$a1, 0		# $a1 = 0, lettura file
	li	$a2, 0		# $a2 = 0, ignorato
	syscall			# Si apre il file e $v0 = file descriptor di "messaggio.txt"
	blt	$v0, 0, err	# Se $v0 < 0 allora il file non è stato trovato, quindi c'è un errore
	move	$s4, $v0	# $s4 = file descriptor di "messaggio.txt"
	jr	$ra		# Si esce dalla procedura

# Apri "chiave.txt"
apri_chiave:
	li	$v0, 13		# $v0 = 13, codice apertura file per syscall
	la	$a0, chiave	# $a0 = "chiave.txt", file da aprire
	li	$a1, 0		# $a1 = 0, lettura file
	li	$a2, 0		# $a2 = 0, ignorato
	syscall			# Si apre il file e $v0 = file descriptor di "chiave.txt"
	blt	$v0, 0, err	# Se $v0 < 0 allora il file non è stato trovato, quindi c'è un errore
	move	$s5, $v0	# $s5 = file descriptor di "chiave.txt"
	jr	$ra		# Si esce dalla procedura
	
# Leggi "messaggio.txt"
leggi:
	li	$v0, 14		# $v0 = 14, codice di lettura file per syscall
	move	$a0, $s4	# $a0 = file descriptor di "messaggio.txt"
	la	$a1, buffer	# $a1 = indirizzo del buffer
	li	$a2, 128	# $a2 = dimensione del buffer
	syscall			# Si effettua la syscall e $v0 = numero byte letti
	jr 	$ra		# Si esce dalla procedura	

# Leggi "chiave.txt"
leggi_chiave:
	li	$v0, 14		# $v0 = 14, codice di lettura file per syscall
	move	$a0, $s5	# $a0 = file descriptor di "messaggio.txt"
	la	$a1, buffer_chiave	# $a1 = indirizzo del buffer
	li	$a2, 4		# $a2 = dimensione del buffer
	syscall			# Si effettua la syscall e $v0 = numero byte letti
	jr 	$ra		# Si esce dalla procedura
		
# Stampa in "messaggioCifrato.txt"
stampa_cifrato:
	li	$v0, 13		# $v0 = 13, codice apertura file per syscall
	la	$a0, fileO	# $a0 = "messaggioCifrato.txt", file da aprire
    	li 	$a1, 1          # $a1 = 1, scrittura file 
     	li 	$a2, 0		# $a2 = 0, ignorato
	syscall			# Si apre il file e $v0 = file descriptor di "messaggioCifrato.txt"
	blt	$v0, 0, err	# Se $v0 < 0 allora il file non è stato trovato, quindi c'è un errore
	move 	$s4, $v0	# $s4 = file descriptor di "messaggioCifrato.txt"
	
	li	$v0, 15		# $v0 = 15, codice scrittura file per syscall
	move	$a0, $s4    	# $a0 = file descriptor di "messaggioCifrato.txt"
	la	$a1, ($s1)	# $a1 = indirizzo del buffer che contiene il messaggio cifrato
	li	$a2, 128	# $a2 = dimensione del buffer
	syscall			# Si effettua la syscall
	jr 	$ra			# Si esce dalla procedura
	
# Stampa in "messaggioDecifrato.txt"
stampa_decifrato:
	li	$v0, 13		# $v0 = 13, codice apertura file per syscall
	la	$a0, fileO2	# $a0 = "messaggioDecifrato.txt", file da aprire
    	li 	$a1, 1          # $a1 = 1, scrittura file 
     	li 	$a2, 0		# $a2 = 0, ignorato
	syscall			# Si apre il file e $v0 = file descriptor di "messaggioDecifrato.txt"
	blt	$v0, 0, err	# Se $v0 < 0 allora il file non è stato trovato, quindi c'è un errore
	move 	$s5, $v0	# $s5 = file descriptor di "messaggioDecifrato.txt"
	
	li	$v0, 15		# $v0 = 15, codice scrittura file per syscall
	move	$a0, $s5    	# $a0 = file descriptor di "messaggioDecifrato.txt"
	la	$a1, ($s1)	# $a1 = indirizzo del buffer che contiene il messaggio decifrato
	li	$a2, 128	# $a2 = dimensione del buffer
	syscall			# Si effettua la syscall
	jr 	$ra		# Si esce dalla procedura

# Chiudi "messaggio.txt" e "chiave.txt" o "messaggioCifrato.txt" e "messaggioDecifrato.txt"
chiudi:
	li	$v0, 16		# $v0 = 16, codice chiusura file per syscall
	move 	$a0, $s4	# $a0 = file descriptor di "messaggio.txt" o "messaggioCifrato.txt"
	syscall			# Il file viene chiuso
	
	li	$v0, 16		# $v0 = 16, codice chiusura file per syscall
	move 	$a0, $s5	# $a0 = file descriptor di "chiave.txt"	o "messaggioDecifrato.txt"
	syscall			# Il file viene chiuso
	jr	$ra		# Si esce dalla procedura
	
# Errore file non trovato
err:
	li	$v0, 4		# $v0 = 4, codice stampa stringa per syscall
	la	$a0, fnf	# $a0 = "File non trovato"
	syscall			# La stringa viene stampata su terminale
	j	fine
# Errore codifica messaggio troppo lunga
err_lung:
	li	$v0, 4		# $v0 = 4, codice stampa stringa per syscall
	la	$a0, ftl	# $a0 = "Il file è diventato troppo lungo"
	syscall			# La stringa viene stampata su terminale
	j	fine

# Fine
fine:
	li	$v0, 10		# $v0 = 10, codice chiusura programma per syscall
	syscall 		# Il programma termina
