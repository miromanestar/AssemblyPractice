# Takes a pointer to an array and two index ints and swaps the chars at those indexes
# Lab 8.2 - Miro Manestar

	.data
msg:	.asciiz "Test"
	.text

main:
	la $a0, msg # Print msg
	li $v0, 4
	syscall
	
	la $a0, msg
	li $a1, 1
	li $a2, 2
	jal swap
	
	li $a0, 10 # Print newline
	li $v0, 11
	syscall
	
	la $a0, msg
	li $v0, 4
	syscall
	
	li $v0, 10 # Exit
	syscall

swap:
	move $t0, $a0 # Set to address of msg
	move $t1, $a1 # Index 1
	move $t2, $a2 # Index 2
	
	add $t3, $t0, $t1 # Address of byte at index 1
	add $t4, $t0, $t2 # Address of byte at index 2
	
	lbu $t5, 0($t3) # Save ASCII value from first index
	lbu $t6, 0($t4) # Save ASCII value from second index
	
	sb $t5, 0($t4) # Put first index value into second index address
	sb $t6, 0($t3) # Put second index value into first index address
	
	jr $ra