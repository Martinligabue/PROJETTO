.data
filein: .asciiz "messaggio.txt"
chiave: .asciiz "chiave.txt"
filedecifr: .asciiz "messaggioDecifrato.txt"
filecifr: .asciiz "messaggioCifrato.txt"
buffer: .space 128

.text

	li $v0,8
	la $a0,buffer
	syscall
	

salvabuffer:

 	 