.data#####questo file può essere anche non modificato, basta richiamare sempre lo stesso algoritmo
	acapo: .asciiz "\n"
	dentro: .asciiz  "dentro.txt"
	fuori: .asciiz "fuori.txt"
	testo: .space 256
.text
.globl main
main:
	j apri
	li $v0,4
	la $a0,testo
	syscall

	li $v0,4
	la $a0,acapo #a capo
	syscall

	la $t0,testoorig
	j carica
	la $t2,text
	li $t0,0

apri:
	li $v0,13
	la $a0,dentro
	li $a1, 0		# Read-only Flag
	li $a2, 0		# (ignored)
	syscall
	move $t6,$v0
leggi:
	read:
	li $v0, 14		# Read File Syscall
	move $a0, $t6		# Load File Descriptor
	la $a1, testo	# Load Buffer Address
	li $a2, 256	# Buffer Size
	syscall
	j main

carica: #salva la roba nello staccc
	lb $t1,($t0)
	addi $sp,$sp,-4    # crea spazio per 1 words nello stack frame
	sw $t1,0($sp)
	addi $t0,$t0,1
	bne $t1,$zero,carica

	la $t0,testoorig
	addi $t0,$t0,-1
scarica:#la rimette al contrario

	addi $sp,$sp,4
	sb $t1,($t0)
	addi $t0,$t0,1
	lw $t1,0($sp)
	bne $t1,$zero,scarica
exit:
	li $v0,4
	la $a0,testoorig
	syscall

	li $v0,10
	syscall
