# Selection sort implementation which stores a char*
# Lab 8.4 - Miro Manestar

	.data
msg:	.asciiz "The quick brown fox jumps over the lazy dog."
	.text

main:
	la $a0, msg
	
	li $v0, 4
	syscall
	
	move $s0, $a0
	li $a0, 10 # Print newline
	li $v0, 11
	syscall
	move $a0, $s0
	
	jal selection
	
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
##### SELECTION SORT ROUTINE #####
# Input:  $a0 (char*)
# Output: $a0 (char*)

selection:
	# Store values in stack pointer
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $s0, 8($sp)
	
	move $s0, $a0
	
	jal strlen # Set $t0 to length of str
	move $t0, $v0
	move $a0, $s0
	
	li $t1, 0 # i variable
ofor:
	bge $t1, $t0, e_ofor
	
	move $t2, $t1 # min-index variable
	move $t3, $t1 # j-varible
ifor:
	bge $t3, $t0, e_ifor
	
	add $t4, $t2, $s0 # Address of char at min-index
	add $t5, $t3, $s0 # Address of char at j
	
	lbu $t4, 0($t4) # Load char at msg[min-index]
	lbu $t5, 0($t5) # Load char at msg[j]
	
	bgt $t5, $t4, skip
	move $t2, $t3 # min-index = j
skip:
	add $t3, $t3, 1 # Increment j
	j ifor
e_ifor:
	#Save t pointers and ra
	addi $sp, $sp, -24
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)

	
	move $a1, $t1
	move $a2, $t2
	jal swap
	
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	addi $sp, $sp, 24
	
	add $t1, $t1, 1 # Increment i
	j ofor
e_ofor:
	lw $ra, 4($sp)
	lw $s0, 8($sp)
	addi $sp, $sp, 8
	
	jr $ra
	
##### SWAP ROUTINE #####
# Input:  $a0 (char*)
#	 $a1 (int)
#	 $a2 (int)
# Output: $a0 (char*)

swap:
	move $t0, $a0 # Set to address of msg
	move $t1, $a1 # Index 1
	move $t2, $a2 # Index 2
	
	add $t3, $t0, $t1 # Address of byte at index 1
	add $t4, $t0, $t2 # Address of byte at index 2
	
	lb $t5, 0($t3) # Save ASCII value from first index
	lb $t6, 0($t4) # Save ASCII value from second index
	
	sb $t5, 0($t4) # Put first index value into second index address
	sb $t6, 0($t3) # Put second index value into first index address
	
	jr $ra
	
##### STRLEN ROUTINE #####
# Input:	  $a0 (char*)
# Output: $v0

strlen:
	move $t7, $a0 # Move addr of str into $s0
	
	li $t0, 0 # Use $t0 as length counter

lenfor:	
	add $t1, $t7, $t0 # Get address of character to be checked
	lb $t2, 0($t1) # Load the character into $t2
	
	beqz $t2, endlenf # If char is 0, exit
	addi $t0, $t0, 1 # Increment length counter
	j lenfor
endlenf:	
	move $v0, $t0 # Return value
	jr $ra
