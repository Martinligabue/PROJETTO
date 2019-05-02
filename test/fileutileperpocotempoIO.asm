# Sample MIPS program that writes to a new file.
#   by Kenneth Vollmar and Pete Sanderson

        .data
fout:   .asciiz "testout.txt"      # filename for output
text: .asciiz "The quick brown fox jumps over the lazy dog. Or not?"
        .text
  ###############################################################
  # Open (for writing) a file that does not exist
  li   $v0, 13       # system call for open file
  la   $a0, fout   # output file name
  li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
  li   $a2, 0        # mode is ignored
  syscall            # open a file (file descriptor returned in $v0)
  move $s6, $v0      # save the file descriptor 
  ###############################################################
	la $t2,text
	li $t0,0
    loop:
  	
  	lb $t1,($t2)
	add  $t0,$t0,1
	add $t2,$t2,1
	bne $t1,$zero,loop
	subi $t0,$t0,1
  # Write to file just opened
  li   $v0, 15       # system call for write to file
  move $a0, $s6      # file descriptor 
  la   $a1, text   # address of buffer from which to write
  move  $a2, $t0       # hardcoded buffer length
  syscall            # write to file
  ###############################################################
  # Close the file 
  li   $v0, 16       # system call for close file
  move $a0, $s6      # file descriptor to close
  syscall            # close file
  ###############################################################
  li $v0,10
  syscall