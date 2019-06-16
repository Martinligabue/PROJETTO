.data
test:  .asciiz "Yolo"
test2: .asciiz "Yolo2"
.text
li $t0,1
li $t1,'a'
la $t2,test
move $s0,$t0

subi $sp,$sp,16
sw $t0,0($sp)
sw $t1,4($sp)
sw $t2,8($sp)
sw $s0,12($sp)


li $t0,2
li $t1,'b'
la $t2,test2
move $s0,$t0

lw $t0,0($sp)
lw $t1,4($sp)
lw $t2,8($sp)
lw $s0,12($sp)
subi $sp,$sp,-16
