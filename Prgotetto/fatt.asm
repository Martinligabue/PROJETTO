.data
string0: .asciiz "Il fattoriale di 5 e' "

.text
.globl main

fact: # procedura che calcola il fattoriale di n

	addi $sp,$sp,-8    # crea spazio per due words nello stack frame
	sw $ra,4($sp)	   # salva l'indirizzo di ritorno al chiamante
	sw $a0,0($sp)	   # salva il parametro d'invocazione

	slti $t0,$a0,1     # controlla se n < 1
	beq $t0,$zero,L1   # se n >= 1 salta a L1

	addi $v0,$zero,1   # n = 0 quindi ritorna 1

	addi $sp,$sp,8     # ripristina lo stack frame
	jr $ra  	        # ritorna al chiamante

L1: # n >= 1

	addi $a0,$a0,-1

	jal fact 	       # chiamata ricorsiva a fattoriale (n-1)

	lw $a0,0($sp) 	 # ripristina i valori salvati in precedenza nello stack frame: parametro e indirizzo di ritorno
	lw $ra,4($sp)
	addi $sp,$sp,8 	 # ripristina lo stack frame

	mul $v0,$a0,$v0  # ritorna n * fattoriale (n-1)
	jr $ra		 			 # ritorna al chiamante


# procedura main

main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $a0,5	       # imposta a 5 il parametro per la chiamata a fattoriale
	jal fact	       # chiama fattoriale

	move $t0,$v0	   # salva il risultato in $t0

	la $a0,string0	 # stampa la stringa string0
	li $v0,4
	syscall

	move $a0, $t0	   # stampa il risultato
	li $v0, 1
	syscall

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra		  		 # torno al chiamante (exeption handler)
