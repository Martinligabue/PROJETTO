.data
 		
 	   buffer: .space 200
.text
 		
  main:
 	   la $a1, buffer
 	   li $a2, 231
 	   li $a0, 6
	  jal write_unsigned_int
 exit:
	   addiu $v0, $0, 4
	   la $a0, buffer
	   syscall
	   addiu $v0, $0, 10
	   syscall
		
		
 write_unsigned_int:
	  # maxlength in $a0, buffer location in $a1, and number to be printed in $a2
	   addiu $sp, $sp, -8
	   sw $ra,0($sp)
	   add $s0, $0, $0 # s0 is the counter
	   write_loop:
	   add $t2, $0, $a2 # load contents of number
	   add $t3, $s0, $a1 # load buffer
		
	   addiu $t0, $0, 10
	   divu $a2, $t0
	   mfhi $t0
	   addi $t0, $t0, '0'
	   mflo $a2
	   
	   li $v0,1
	   la $a0,($t0)
	   syscall
	   
	   
	   sb $t0, 0($t3)
	   beq $a2, $0, write_unsigned_int_done
	   addi $s0, $s0, 1
	   j write_loop
		
 write_unsigned_int_done:
	   #sb $a2, 0($t3)
	   lw $ra,0($sp)
	   addiu $sp, $sp, 8
	   addu $v0, $a0, $0
	   jr $ra