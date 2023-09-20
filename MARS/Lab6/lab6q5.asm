# Sample Data Memory Initialization
# Lab 6.5

	# Data Memory Section
	.data
value1:	.word 5
value2:	.word 89
	.align 2
	
	# Program Memory Section
	.text
	
main:
	lw $t0, value1
	lw $t1, value2
	sub $s0, $t0, $t1
	li $v0, 10
	syscall