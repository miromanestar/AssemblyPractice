# is_odd assembly function
# Lab 7.3 - Miro Manestar

	# Data Memory Section
	.data
pr:	.asciiz "Enter Number: "
pr1:	.asciiz "is_odd: "
	.text

main:
	la $a0, pr # Print out pr
	li $v0, 4
	syscall
	
	li $v0, 5 # Take input and put into $t0
	syscall
	move $t0, $v0
	
	jal is_odd
	
	la $a0, pr1 # Print out pr1
	li $v0, 4
	syscall
	
	move $a0, $t1
	li $v0, 1
	syscall
	
	li $v0, 10 # Exit
	syscall
	
is_odd:
	andi $t1, $t0, 1
	jr $ra