.text
main:
    li $t1,1
    li $t2,3
    jal funzione
    move $v0,$a0
    jal stampa
    li $t1,2
    li $t2,5
    jal funzione
    move $v0,$a0
    jal stampa
    j exit

funzione:
    addi $v0,$t1,$t2
    j $ra

stampa:
    li $v0,1
    syscall

exit:
    li $v0,10
    syscall
