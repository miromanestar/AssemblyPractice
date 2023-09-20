# Simple User Input Program
# Lab 6.7

	# Data Memory Section
	.data
pr:	.asciiz "Enter Number 1: "
pr1:	.asciiz "Enter Number 2: "
ans:	.asciiz "Answer: "
ad:	.asciiz " + "
eq:	.asciiz " = "
	
	# Program Memory Section
	.text	
main:
	la $a0, pr # Print out pr
	li $v0, 4
	syscall
	
	li $v0, 5 # Take input and put into $t0
	syscall
	move $t0, $v0
	
	la $a0, pr1 # Print out pr1
	li $v0, 4
	syscall
	
	li $v0, 5 #Take input and put into $t1
	syscall
	move $t1, $v0
	
	la $a0, ans # Print out "Answer: "
	li $v0, 4
	syscall
	
	la $a0, ($t0) # Print first integer
	li $v0, 1
	syscall
	
	la $a0, ad # Print out ad
	li $v0, 4
	syscall
	
	la $a0, ($t1) # Print second integer
	li $v0, 1
	syscall
	
	la $a0, eq # Print out eq
	li $v0, 4
	syscall
	
	add $a0, $t0, $t1 #Add integers and print out
	li $v0, 1
	syscall
	
	li $a0, 10 # Print newline (10 in ASCII is newline)
	li $v0, 11
	syscall
	
	li $a0, 10 # Print newline (10 in ASCII is newline)
	li $v0, 11
	syscall
	
	j main
	
	li $v0, 10 # Exit
	syscall