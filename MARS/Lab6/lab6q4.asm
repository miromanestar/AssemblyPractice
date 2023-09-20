# Sample Data Memory Initialization
# Lab 6.4

	# Data Memory Selection
	.data
value1:	.word 12
value2:	.word -45
value3:	.word 00
	.align 2
	
	# Program Memory Selection
	.text

main:
	lw	$t0, value1
	lw	$t1, value2
	add	$t2, $t0, $t1
	bgt	$t2, $zero, skip
	sub	$t2, $zero, $t2
skip:	sw	$t2, value3
	li $v0, 10	# Exit
	syscall