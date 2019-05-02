.text
main:
    li $a0,1
    li $a1,3
    jal funzione
    move $a0,$v0
    jal stampa
    li $a0,2
    li $a1,5
    jal funzione
    move $a0,$v0
    jal stampa
    j exit

funzione:
    add $v0,$a0,$a1
    jr $ra

stampa:
    li $v0,1
    syscall
	jr $ra
exit:
    li $v0,10
    syscall
